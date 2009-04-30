Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbZD3UAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbZD3UAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZD3UAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:00:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40477 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZD3UAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:00:13 -0400
Message-ID: <49FA0349.3090706@garzik.org>
Date: Thu, 30 Apr 2009 16:00:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org> <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
In-Reply-To: <49F903DD.8040707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Jeff Garzik wrote:
>> <shrug>  I suppose...
>>
>> It just seems like a nasty hack, but unfortunately I don't see
>> anyone stepping up to do it properly -- with a DM device
>> automatically layered on top that splits the device into separate
>> regions: one block device for the 'regular' area, and one for the
>> HPA.
> 
> Isn't that more hacky?  I don't know.  All that dm needs to know is
> the location of the metadata which is located w.r.t. the end of the
> device which might be at a different location if BIOS tried to pull
> silly stunts.  So, exporting the size BIOS might have used seems like
> a straight forward solution to me.

"<shrug> I suppose" is basically a reluctant ack, in the absence of 
other solutions :)


