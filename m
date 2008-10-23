Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYJWQEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYJWQEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYJWQEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:04:24 -0400
Received: from rtr.ca ([76.10.145.34]:33402 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbYJWQEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:04:23 -0400
Message-ID: <4900A0A7.3090102@rtr.ca>
Date: Thu, 23 Oct 2008 12:04:55 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
Cc: Tejun Heo <tj@kernel.org>, David Greaves <david@dgreaves.com>,
       linux-ide@vger.kernel.org,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] SMART to USB/sata dock in 2.6.27-rc5
 doesn't work
References: <48EE7E0A.8040701@dgreaves.com> <48F40164.5000502@kernel.org> <48F641A3.5080609@free.fr>
In-Reply-To: <48F641A3.5080609@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

matthieu castet wrote:
> Hi,
> 
> Tejun Heo wrote:
>> David Greaves wrote:
>>> Error Counter logging not supported
>>> Device does not support Self Test logging
>>
>> The USB bridge should support SAT (SCSI-ATA translation) and many
>> don't.  Nothing much can be done about it.  The hardware just don't know
>> how to do it.
>>
> That true that the hardware should support SAT, but even if it support 
> it, linux need some patches to support SAT over USB. See 
> http://thread.gmane.org/gmane.linux.scsi/43688 and the patch mentioned 
> in the thread.
...

Ahh.. Great!  This mostly fixes smartctl operation on at least two
of my USB drive enclosures here:

    1. a recent rev.  2.5" NexStar-3 SATA enclosure.
    2. a 250GB 2.5" WD "Passport" external USB drive/enclosure.

With the patch, this command line works for me:

    smartctl -a -dsat -T permissive /dev/sdb 

And hdparm just works regardless, with or without the patch.


> 
> Unfortunately I am a bit busy to try to resubmit it. But I won't care if 
> somebody improve it/resubmit it ;)
> 
> Matthieu
> 
> PS : there also  http://thread.gmane.org/gmane.linux.usb.general/7145 
> that is pending.
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

