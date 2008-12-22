Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYLVG7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYLVG7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 01:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYLVG7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 01:59:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:16057 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYLVG7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 01:59:36 -0500
Message-ID: <494F3AD2.3060201@gawab.com>
Date: Sun, 21 Dec 2008 22:59:30 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
References: <494318F5.4060007@gawab.com> <494EFD79.7020008@kernel.org>
In-Reply-To: <494EFD79.7020008@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
>
> Justin Madru wrote:
>   
>> I've been testing .28 (currently -rc8) and I've noticed in the logs a
>> massive amount of the following.
>> I can confirm that the messages doesn't appear when booting into a .27
>> kernel.
>>
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> ata2.00: ST_FIRST: !(DRQ|ERR|DF)
>> ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>>         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>>         res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
>> ata2.00: status: { DRDY }
>> ata2: soft resetting link
>> ata2.00: configured for UDMA/33
>> ata2: EH complete
>>     
>
> That's HSM violation on ALLOW_MEDIUM_REMOVAL on the second ATA port.
>
>   
>> I get this block of messages about every 20 seconds for as long as I'm
>> booted into a .28 kernel.
>> It seems that the sata link is being soft reseted about every _20_ secs.
>> My drive is a sata drive that should be using UDMA/133 (right?),
>> but the "error" message says configuring for UDMA/33.
>> Does this mean that my drive is running at a slower speed?
>> Should I be worried about the .28 kernel corrupting my hardware? Is this
>> a known issue?
>> How can I stop it from filling my logs!
>>
>> Some information about my computer:
>>
>> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA
>> IDE Controller (rev 01)
>>
>> $ hdparm -I /dev/sda
>> /dev/sda:
>> ATA device, with non-removable media
>>        Model Number:       ST980811AS
>>     
>
> and I strongly doubt it's the hard drive.  Can you please post full
> kernel log including the boot messages?
>
> Thanks.
>
>   
Well, it's good to hear that you don't think my drive is failing (sure 
hope it's not failing!)

I posted the full dmesg in reply to Alan in 
http://lkml.org/lkml/2008/12/19/30.
Also, more information about my computer can be found at: 
http://jdserver.homelinux.org/bugreports/
If you need me to run anything else not found in the above links then 
let me know.

Justin Madru

