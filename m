Return-Path: <linux-kernel-owner+w=401wt.eu-S933466AbXG3Pcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbXG3Pcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbXG3Pci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:32:38 -0400
Received: from Mail.MNSU.EDU ([134.29.1.12]:56959 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbXG3Pch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:32:37 -0400
X-Greylist: delayed 1628 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 11:32:37 EDT
Message-ID: <46ADFDFB.8000809@mnsu.edu>
Date: Mon, 30 Jul 2007 10:04:27 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: pat-lkml <pat-lkml@erley.org>, Bernhard Kaindl <bk@suse.de>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI Quirk / Hidden Bus Report
References: <469EDBA3.2000404@erley.org> <20070730115505.GP16817@stusta.de>
In-Reply-To: <20070730115505.GP16817@stusta.de>
Content-Type: multipart/mixed;
 boundary="------------060409050508010500080609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060409050508010500080609
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I also have the same type message in my dmesg from a Dell Latitude D820 
with the latest BIOS:

PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1080-10bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #04 (-#07) is hidden behind transparent bridge #03 (-#04) (try 
'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *3
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay

Full dmesg attached.

Adrian Bunk wrote:
> Bernhard?
>
> cu
> Adrian
>
>
> On Wed, Jul 18, 2007 at 11:33:55PM -0400, pat-lkml wrote:
>   
>> I received:
>>
>> PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0a) (try
>> 'pci=assign-busses')
>> Please report the result to linux-kernel to fix this permanently
>>
>> in my dmesg in 2.6.22, and am reporting it.  Context of message follows.
>>  Full dmesg output available on request.  This is a Clevo d900t laptop
>> motherboard, and everything works perfectly on it.
>>
>> Pat Erley
>>
>> --
>>
>> ENABLING IO-APIC IRQs
>> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>> Brought up 2 CPUs
>> migration_cost=22
>> NET: Registered protocol family 16
>> EISA bus registered
>> ACPI: bus type pci registered
>> PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
>> PCI: Not using MMCONFIG.
>> PCI: PCI BIOS revision 2.10 entry at 0xfd951, last bus=10
>> PCI: Using configuration type 1
>> Setting up standard PCI resources
>> ACPI: Interpreter enabled
>> ACPI: Using IOAPIC for interrupt routing
>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>> PCI: Probing PCI hardware (bus 00)
>> PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
>> PCI quirk: region 1180-11bf claimed by ICH6 GPIO
>> PCI: Transparent bridge - 0000:00:1e.0
>> PCI: Bus #0b (-#0e) is hidden behind transparent bridge #0a (-#0a) (try
>> 'pci=assign-busses')
>> Please report the result to linux-kernel to fix this permanently
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
>> ACPI: PCI Interrupt Link [LNKA] (IRQs 10) *11
>> ACPI: PCI Interrupt Link [LNKB] (IRQs 11) *10
>> ACPI: PCI Interrupt Link [LNKC] (IRQs 10) *5
>> ACPI: PCI Interrupt Link [LNKD] (IRQs 11) *10
>> ACPI: PCI Interrupt Link [LNKE] (IRQs *10)
>> ACPI: PCI Interrupt Link [LNKF] (IRQs *11)
>> ACPI: PCI Interrupt Link [LNKG] (IRQs 10) *0, disabled.
>> ACPI: PCI Interrupt Link [LNKH] (IRQs *11)
>> Linux Plug and Play Support v0.97 (c) Adam Belay
>> pnp: PnP ACPI init
>> ACPI: bus type pnp registered
>> pnp: PnP ACPI: found 12 devices
>> ACPI: ACPI bus type pnp unregistered
>> SCSI subsystem initialized
>> libata version 2.21 loaded.
>> PCI: Using ACPI for IRQ routing
>> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
>> report
>> Time: tsc clocksource has been installed.
>>     
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

--------------060409050508010500080609
Content-Type: application/x-gzip;
 name="dmesg-latitude-d820.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dmesg-latitude-d820.txt.gz"

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
tcb/AAXPqxXNWwAA
--------------060409050508010500080609--
