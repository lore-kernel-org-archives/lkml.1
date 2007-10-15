Return-Path: <linux-kernel-owner+w=401wt.eu-S933117AbXJOSMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbXJOSMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbXJOSMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:12:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46196 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbXJOSMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:12:18 -0400
Message-ID: <4713AD7F.8030906@garzik.org>
Date: Mon, 15 Oct 2007 14:12:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: James.Bottomley@steeleye.com, linux-scsi <linux-scsi@vger.kernel.org>
CC: akpm@linux-foundation.org, kristen.c.accardi@intel.com, htejun@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/1] scsi: expose AN support to user space
References: <200710032104.l93L40CM008614@imap1.linux-foundation.org> <470FE29A.7050605@garzik.org>
In-Reply-To: <470FE29A.7050605@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> akpm@linux-foundation.org wrote:
>> From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>>
>> If a scsi_device supports async notification for media change, then 
>> let user
>> space know this capability exists by creating a new sysfs entry
>> "media_change_notify", which will be 1 if it is supported, and 0 if not
>> supported.  Create a routine which allows scsi devices to send a 
>> uevent when
>> media change events occur.
>>
>> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
>> Acked-by: Jeff Garzik <jeff@garzik.org>
>> Cc: Tejun Heo <htejun@gmail.com>
>> Cc: James Bottomley <James.Bottomley@steeleye.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Ping?

Re-Ping?

This patch works (it has been working for months), is ACK'd by me, 
addresses some of the feedback given in August, and has not received any 
comments despite the SCSI maintainers being To'd or CC'd for weeks 
(months, if you include the older thread).

Further, this patch is required to round out interrupt-driven media 
change notification, that which eliminates the CD-ROM polling that 
userspace has done since the dawn of time.

It was not in the merge window SCSI push, while being in -mm for a while 
and linux-scsi having the patch for a while.  Which means, if the 
silence continues, it must wait 4-6 months for 2.6.25 release, for no 
apparent reason.

	Jeff


