Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbXCSMJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbXCSMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbXCSMJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:09:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51696 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbXCSMJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:09:27 -0400
Message-ID: <45FE7D74.6090503@garzik.org>
Date: Mon, 19 Mar 2007 08:09:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christian <christiand59@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703182131.00476.christiand59@web.de> <45FDF9EE.20303@gmail.com> <200703190808.00746.christiand59@web.de>
In-Reply-To: <200703190808.00746.christiand59@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> On Monday 19 March 2007 03:48:14 you wrote:
>> Christian wrote:
>>> On Sunday 18 March 2007 06:43:09 you wrote:
>>>> Christian wrote:
>>>>>> This does indeed look like a drive side issue to me (the controller is
>>>>>> reporting CPBs with response flags 2 which as far as I can tell
>>>>>> indicates it's still waiting for the drive to complete the request).
>>>>> I have been using this hw-config (SATA II, NCQ) since the nvidia ADMA
>>>>> support made it in the -mm kernel (maybe around 2.6.19-mm? or even
>>>>> earlyer). I'm seeing this problem excessively since I upgraded to
>>>>> 2.6.21-rc3-mm1. I think something got broken recently...
>>>> Can you post the result of "hdparm -I /dev/sdX"?
>>> Output generated on 2.6.21-rc3-mm1 #3 SMP PREEMPT
>>>
>>> user@ubuntu:~$ sudo hdparm -I /dev/sda
>>>
>>> /dev/sda:
>>>
>>> ATA device, with non-removable media
>>>         Model Number:       SAMSUNG HD401LJ
>>>         Serial Number:      S0HVJ1FL900207
>>>         Firmware Revision:  ZZ100-15
>>> Standards:
>>>         Used: ATA/ATAPI-7 T13 1532D revision 4a
>>>         Supported: 7 6 5 4
>>> Configuration:
>>>         Logical         max     current
>>>         cylinders       16383   16383
>>>         heads           16      16
>>>         sectors/track   63      63
>>>         --
>>>         CHS current addressable sectors:   16514064
>>>         LBA    user addressable sectors:  268435455
>>>         LBA48  user addressable sectors:  781422768
>>>         device size with M = 1024*1024:      381554 MBytes
>>>         device size with M = 1000*1000:      400088 MBytes (400 GB)
>> That's a fairly recent drive.  Does the problem go away if you downgrade
>> the kernel?
> 
> Yes, for me the problem was introduced recently. I have moved around terabytes 
> (sic!) on my discs with older kernels and I never got errors.

I may have missed the answer to this before, but:  does the problem go 
away if you disable preempt?

	Jeff



