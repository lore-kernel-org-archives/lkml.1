Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbZD3VQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbZD3VQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZD3VPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:15:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:26471 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZD3VPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F2BL6DbPPHfvJWhPvHMPiEYygs4F11nXeZjoknvnBO0BLI+++Ey5jNbkhKurzimiSq
         JvJOU1fgU4dUTNz7hPnpVEfwS7IRjWCDZlYIJI1RjSoiT8ErBR3cQeMcTq5JusivEZ+f
         Mr21lg6MtV99mzzQ5m4j5sAYt4ZgRHoNk24oE=
MIME-Version: 1.0
In-Reply-To: <49FA0349.3090706@garzik.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
Date: Thu, 30 Apr 2009 14:15:48 -0700
Message-ID: <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
From: Dan Williams <dan.j.williams@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       Mauelshagen@redhat.com, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 1:00 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Tejun Heo wrote:
>>
>> Hello,
>>
>> Jeff Garzik wrote:
>>>
>>> <shrug>  I suppose...
>>>
>>> It just seems like a nasty hack, but unfortunately I don't see
>>> anyone stepping up to do it properly -- with a DM device
>>> automatically layered on top that splits the device into separate
>>> regions: one block device for the 'regular' area, and one for the
>>> HPA.
>>
>> Isn't that more hacky?  I don't know.  All that dm needs to know is
>> the location of the metadata which is located w.r.t. the end of the
>> device which might be at a different location if BIOS tried to pull
>> silly stunts.  So, exporting the size BIOS might have used seems like
>> a straight forward solution to me.
>
> "<shrug> I suppose" is basically a reluctant ack, in the absence of other
> solutions :)
>

Couldn't the "fix" also just be a note to users to disable ignore_hpa
if they notice that there raid arrays are not assembling correctly?

--
Dan
