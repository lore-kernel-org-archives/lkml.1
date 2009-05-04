Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZEDIEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZEDIEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZEDIER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:04:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:55069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZEDIEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:04:15 -0400
Message-ID: <49FEA127.1000905@kernel.org>
Date: Mon, 04 May 2009 17:02:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       Mauelshagen@redhat.com, dm-devel@redhat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org>	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>	 <49FA0349.3090706@garzik.org> <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
In-Reply-To: <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 08:02:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Thu, Apr 30, 2009 at 1:00 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Tejun Heo wrote:
>>> Hello,
>>>
>>> Jeff Garzik wrote:
>>>> <shrug>  I suppose...
>>>>
>>>> It just seems like a nasty hack, but unfortunately I don't see
>>>> anyone stepping up to do it properly -- with a DM device
>>>> automatically layered on top that splits the device into separate
>>>> regions: one block device for the 'regular' area, and one for the
>>>> HPA.
>>> Isn't that more hacky?  I don't know.  All that dm needs to know is
>>> the location of the metadata which is located w.r.t. the end of the
>>> device which might be at a different location if BIOS tried to pull
>>> silly stunts.  So, exporting the size BIOS might have used seems like
>>> a straight forward solution to me.
>> "<shrug> I suppose" is basically a reluctant ack, in the absence of other
>> solutions :)
>>
> 
> Couldn't the "fix" also just be a note to users to disable ignore_hpa
> if they notice that there raid arrays are not assembling correctly?

I don't know.  If it doesn't work automatically, the solution really
isn't worth much.  People generally don't (shouldn't need to) have any
idea what HPA is.  It basically boils down to "Linux doesn't support
RAID".  :-)

Maybe we should just put this issue to the rest and strongly advise
people against BIOS raids.

Thanks.

-- 
tejun
