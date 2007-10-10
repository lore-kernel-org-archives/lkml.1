Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXJJJ4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXJJJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXJJJ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:56:16 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:50363 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbXJJJ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:56:15 -0400
Message-ID: <470CA1BD.1080502@free.fr>
Date: Wed, 10 Oct 2007 11:56:13 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470B366F.4030306@free.fr> <3efb10970710091304g30ab5549u84a092d4de40368b@mail.gmail.com>
In-Reply-To: <3efb10970710091304g30ab5549u84a092d4de40368b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Remy,

Remy Bohmer wrote:

> John Sigler wrote:
> 
>> When I run 'halt' the kernel prints:
>> Halting.
>> Shutdown: hdc
>> ACPI: PCI interrupt for device 0000:01:05.0 disabled
>> ACPI: PCI interrupt for device 0000:01:04.0 disabled
>> ACPI: PCI interrupt for device 0000:01:03.0 disabled
>> ACPI: PCI interrupt for device 0000:01:02.0 disabled
>> Power down.
>> acpi_power_off called
>>
>> But the system does not shut down. (The fans keep spinning, the LEDs
> 
> I have seen this behavior earlier on a system with the SMI interrupt
> disabled. I do not know if this the case here, it is just a hint.

Thanks for the suggestion. I didn't see anything related to SMM in the 
BIOS menus. However, the system has real-time constraints. Thus, I'd 
turn SMM off if I knew how :-)

    Phoenix - AwardBIOS v6.00PG, An Energy Star Ally
    Copyright (C) 1984-2003, Phoenix Technologies, LTD
*** NAMB-3140 BIOS V1.20 ***
03/27/2006-i845GV-W83627-6A69VAKHC-00

> By the way, some distros bring the CPU in a halted state on a 'halt'
> command, instead of powering off (actually very logical). For real
> powering off these distros require the obvious 'poweroff' command.

Good suggestion. I'm using sysvinit-2.86
http://freshmeat.net/projects/sysvinit/

AFAIU, poweroff is equivalent to halt -p

halt (no option) calls reboot(RB_HALT);
poweroff or halt -p calls reboot(RB_POWER_OFF);
man 2 reboot

Alas, when I run 'poweroff' the kernel prints the same information:

Halting.
Shutdown: hdc
ACPI: PCI interrupt for device 0000:01:05.0 disabled
ACPI: PCI interrupt for device 0000:01:04.0 disabled
ACPI: PCI interrupt for device 0000:01:03.0 disabled
ACPI: PCI interrupt for device 0000:01:02.0 disabled
Power down.
acpi_power_off called

Regards.
