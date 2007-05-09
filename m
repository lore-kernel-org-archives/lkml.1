Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbXEIMml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbXEIMml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXEIMmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:42:31 -0400
Received: from ns.bitdefender.com ([217.156.83.1]:33995 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbXEIMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:42:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 08:42:18 EDT
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mdontu@bitdefender.com>
Organization: Softwin
To: linux-kernel@vger.kernel.org
Subject: Re: PCI: Bus #02 (-#05) is hidden behind transparent bridge #01 (-#01) (try 'pci=assign-busses')
User-Agent: KMail/1.9.5
References: <20070401181822.9700a7df.mailing@wodkahexe.de>
In-Reply-To: <20070401181822.9700a7df.mailing@wodkahexe.de>
MIME-Version: 1.0
Date: Wed, 9 May 2007 15:35:30 +0300
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_SAcQGKDrXBouKDT"
Message-Id: <200705091535.30607.mdontu@bitdefender.com>
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 2.0.0 on
 mail.bitdefender.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_SAcQGKDrXBouKDT
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Sunday 01 April 2007 19:18, you wrote:
> > Hi,
> >
> > dmesg told me to report this to LKML.
>
>   And here is my report.
>
> > Have a nice day..
>
>   x 2 ;)

    And again, from a different email address.

    I would also like to take the opportunity to apologise to Gene Heskett for
spamming him :)

-- 
Mihai Donțu

--Boundary-00=_SAcQGKDrXBouKDT
Content-Type: text/x-log;
  charset="utf-8";
  name="lspci-with-assign-busses.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci-with-assign-busses.log"

00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64

00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d0400000-d07fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cff00000
	Capabilities: [44] HyperTransport: MSI Mapping
	Capabilities: [b0] #0d [0000]

00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [b0] #0d [0000]
	Capabilities: [b8] HyperTransport: MSI Mapping
	Capabilities: [100] Advanced Error Reporting

00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [b0] #0d [0000]
	Capabilities: [b8] HyperTransport: MSI Mapping
	Capabilities: [100] Advanced Error Reporting

00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at d0800000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at d0801000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at d0802000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 11)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: 66MHz, medium devsel
	I/O ports at 8200 [size=16]
	Memory at d0803000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [b0] HyperTransport: MSI Mapping

00:14.1 IDE interface: ATI Technologies Inc Standard Dual Channel PCI IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 3010 [size=16]
	Capabilities: [70] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge (prog-if 01 [Subtractive decode])
	Flags: bus master, VGA palette snoop, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=04, subordinate=08, sec-latency=64
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d0000000-d03fffff
	Prefetchable memory behind bridge: 50000000-53ffffff

00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400 AC'97 Audio Controller (rev 02)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
	Memory at d0804000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.6 Modem: ATI Technologies Inc SB400 AC'97 Modem Controller (rev 02) (prog-if 00 [Generic])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: 66MHz, slow devsel, IRQ 17
	Memory at d0805000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon XPRESS 200M 5955 (PCIE) (prog-if 00 [VGA])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, fast Back2Back, 66MHz, medium devsel, latency 64, IRQ 5
	Memory at c0000000 (32-bit, prefetchable) [size=256M]
	I/O ports at 2000 [size=256]
	Memory at d0400000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0420000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2

04:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788 Gigabit Ethernet (rev 03)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 23
	Memory at d0000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-

04:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, fast devsel, latency 64, IRQ 22
	Memory at d0010000 (32-bit, non-prefetchable) [size=8K]

04:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at d0012000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=04, secondary=05, subordinate=08, sec-latency=176
	Memory window 0: 50000000-53fff000 (prefetchable)
	Memory window 1: 54000000-57fff000 (prefetchable)
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	16-bit legacy interface ports at 0001

04:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at d0013000 (32-bit, non-prefetchable) [size=2K]
	Memory at d0014000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2

04:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated FlashMedia Controller
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at d0018000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2

04:04.4 Class 0805: Texas Instruments PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at d001a000 (32-bit, non-prefetchable) [size=256]
	Memory at d001b000 (32-bit, non-prefetchable) [size=256]
	Memory at d001c000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2


--Boundary-00=_SAcQGKDrXBouKDT
Content-Type: text/x-log;
  charset="utf-8";
  name="lspci-without-assign-busses.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci-without-assign-busses.log"

00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64

00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d0400000-d07fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cff00000
	Capabilities: [44] HyperTransport: MSI Mapping
	Capabilities: [b0] #0d [0000]

00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=10, subordinate=10, sec-latency=0
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [b0] #0d [0000]
	Capabilities: [b8] HyperTransport: MSI Mapping
	Capabilities: [100] Advanced Error Reporting

00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=20, subordinate=20, sec-latency=0
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [b0] #0d [0000]
	Capabilities: [b8] HyperTransport: MSI Mapping
	Capabilities: [100] Advanced Error Reporting

00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at d0800000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at d0801000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 19
	Memory at d0802000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 11)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: 66MHz, medium devsel
	I/O ports at 8200 [size=16]
	Memory at d0803000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [b0] HyperTransport: MSI Mapping

00:14.1 IDE interface: ATI Technologies Inc Standard Dual Channel PCI IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 3010 [size=16]
	Capabilities: [70] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge (prog-if 01 [Subtractive decode])
	Flags: bus master, VGA palette snoop, 66MHz, medium devsel, latency 64
	Bus: primary=00, secondary=02, subordinate=03, sec-latency=64
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d0000000-d03fffff
	Prefetchable memory behind bridge: 50000000-53ffffff

00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400 AC'97 Audio Controller (rev 02)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 17
	Memory at d0804000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:14.6 Modem: ATI Technologies Inc SB400 AC'97 Modem Controller (rev 02) (prog-if 00 [Generic])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: 66MHz, slow devsel, IRQ 17
	Memory at d0805000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Flags: fast devsel

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon XPRESS 200M 5955 (PCIE) (prog-if 00 [VGA])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, fast Back2Back, 66MHz, medium devsel, latency 64, IRQ 5
	Memory at c0000000 (32-bit, prefetchable) [size=256M]
	I/O ports at 2000 [size=256]
	Memory at d0400000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d0420000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2

02:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788 Gigabit Ethernet (rev 03)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 23
	Memory at d0000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-

02:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, fast devsel, latency 64, IRQ 22
	Memory at d0010000 (32-bit, non-prefetchable) [size=8K]

02:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at d0012000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
	Memory window 0: 50000000-53fff000 (prefetchable)
	Memory window 1: 54000000-57fff000 (prefetchable)
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	16-bit legacy interface ports at 0001

02:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at d0013000 (32-bit, non-prefetchable) [size=2K]
	Memory at d0014000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2

02:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated FlashMedia Controller
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at d0018000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2

02:04.4 Class 0805: Texas Instruments PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
	Subsystem: Hewlett-Packard Company MX6125
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at d001a000 (32-bit, non-prefetchable) [size=256]
	Memory at d001b000 (32-bit, non-prefetchable) [size=256]
	Memory at d001c000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2


--Boundary-00=_SAcQGKDrXBouKDT
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg-with-assign-busses.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-with-assign-busses.log"

[    0.000000] Linux version 2.6.21-rc7 (mihai@mdontu-l) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #1 PREEMPT Mon Apr 23 04:16:33 EEST 2007
[    0.000000] Command line: vga=791 nohz=on pci=assign-busses
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000037fd0000 - 0000000037fefc00 (reserved)
[    0.000000]  BIOS-e820: 0000000037fefc00 - 0000000037ffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000037ffb000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FE270, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 37FEFC84, 0034 (r1 HP     0944     22110520 HP          1)
[    0.000000] ACPI: FACP 37FEFC00, 0084 (r2 HP     0944            2 HP          1)
[    0.000000] ACPI: DSDT 37FEFD50, 7489 (r1 HP        SB400    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 37FFAE80, 0040
[    0.000000] ACPI: APIC 37FEFCB8, 005A (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 37FEFD14, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 37FF71D9, 0382 (r1 HP       HPQPpc     1001 MSFT  100000E)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   229328
[    0.000000] On node 0 totalpages: 229231
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2012 pages reserved
[    0.000000]   DMA zone: 1931 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3079 pages used for memmap
[    0.000000]   DMA32 zone: 222153 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfec01000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e0000
[    0.000000] Nosave address range: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists.  Total pages: 224084
[    0.000000] Kernel command line: vga=791 nohz=on pci=assign-busses
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   14.486846] time.c: Detected 2194.539 MHz processor.
[   14.486898] Console: colour dummy device 80x25
[   14.488383] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   14.489336] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   14.503372] Memory: 894468k/917312k available (4263k kernel code, 22208k reserved, 1795k data, 232k init)
[   14.562723] Calibrating delay using timer specific routine.. 4391.80 BogoMIPS (lpj=2195900)
[   14.562776] Mount-cache hash table entries: 256
[   14.562916] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   14.562922] CPU: L2 Cache: 1024K (64 bytes/line)
[   14.562936] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   14.562949] ACPI: Core revision 20070126
[   14.608885] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   14.618890] Using local APIC timer interrupts.
[   14.664403] result 12468973
[   14.664407] Detected 12.468 MHz APIC timer.
[   14.664719] NET: Registered protocol family 16
[   14.664805] No dock devices found.
[   14.664874] ACPI: bus type pci registered
[   14.667859] PCI: Using MMCONFIG at e0000000 - efffffff
[   14.667905] PCI: No mmconfig possible on device 00:18
[   14.681170] ACPI: Interpreter enabled
[   14.681180] ACPI: (supports S0 S3 S4 S5)
[   14.681197] ACPI: Using IOAPIC for interrupt routing
[   14.696539] ACPI: PCI Root Bridge [C047] (0000:00)
[   14.696553] PCI: Probing PCI hardware (bus 00)
[   14.696962] 0000:00:14.1: trying to change BAR0 from 0000 to 01F0
[   14.696968] 0000:00:14.1: trying to change BAR1 from 0000 to 03F4
[   14.696973] 0000:00:14.1: trying to change BAR2 from 0000 to 0170
[   14.696977] 0000:00:14.1: trying to change BAR3 from 0000 to 0374
[   14.697296] Boot video device is 0000:01:05.0
[   14.697990] PCI: Transparent bridge - 0000:00:14.4
[   14.698061] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   14.698252] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   14.698332] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   14.710069] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   14.710193] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   14.710314] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   14.710434] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   14.710559] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   14.710681] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   14.710802] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   14.710929] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   14.711040] ACPI: Power Resource [C1CF] (off)
[   14.711184] ACPI: Power Resource [C1B7] (on)
[   14.711224] ACPI: Power Resource [C1C7] (on)
[   14.711304] ACPI: Power Resource [C26C] (off)
[   14.711374] ACPI: Power Resource [C26D] (off)
[   14.711444] ACPI: Power Resource [C26E] (off)
[   14.711521] ACPI: Power Resource [C26F] (off)
[   14.711532] Linux Plug and Play Support v0.97 (c) Adam Belay
[   14.711547] pnp: PnP ACPI init
[   14.717464] pnp: PnP ACPI: found 12 devices
[   14.717600] SCSI subsystem initialized
[   14.717667] usbcore: registered new interface driver usbfs
[   14.717699] usbcore: registered new interface driver hub
[   14.717733] usbcore: registered new device driver usb
[   14.717805] PCI: Using ACPI for IRQ routing
[   14.717811] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   14.717822] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   14.717827] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   14.717831] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   14.717836] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   14.717841] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   14.717845] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   14.717943] Bluetooth: Core ver 2.11
[   14.717978] NET: Registered protocol family 31
[   14.717983] Bluetooth: HCI device and connection manager initialized
[   14.717988] Bluetooth: HCI socket layer initialized
[   14.717992] NET: Registered protocol family 8
[   14.717997] NET: Registered protocol family 20
[   14.718042] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   14.718048] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   14.718054] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   14.718063] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   14.718069] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   14.718074] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   14.718080] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[   14.718087] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[   14.718097] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   14.718102] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   14.718109] pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   14.718117] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   14.718124] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   14.718130] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   14.718137] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff could not be reserved
[   14.718358] ieee1394: Initialized config rom entry `ip1394'
[   14.718453] ACPI: PCI Interrupt 0000:04:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   14.718487] Time: tsc clocksource has been installed.
[   14.768768] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   14.768872] PCI: Bridge: 0000:00:01.0
[   14.768877]   IO window: 2000-2fff
[   14.768882]   MEM window: d0400000-d07fffff
[   14.768887]   PREFETCH window: c0000000-cfffffff
[   14.768891] PCI: Bridge: 0000:00:04.0
[   14.768894]   IO window: disabled.
[   14.768898]   MEM window: disabled.
[   14.768902]   PREFETCH window: disabled.
[   14.768906] PCI: Bridge: 0000:00:05.0
[   14.768909]   IO window: disabled.
[   14.768913]   MEM window: disabled.
[   14.768917]   PREFETCH window: disabled.
[   14.768923] PCI: Bus 5, cardbus bridge: 0000:04:04.0
[   14.768928]   IO window: 00001000-000010ff
[   14.768932]   IO window: 00001400-000014ff
[   14.768937]   PREFETCH window: 50000000-53ffffff
[   14.768942]   MEM window: 54000000-57ffffff
[   14.768946] PCI: Bridge: 0000:00:14.4
[   14.768951]   IO window: 1000-1fff
[   14.768956]   MEM window: d0000000-d03fffff
[   14.768960]   PREFETCH window: 50000000-53ffffff
[   14.768972] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   14.768977] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   14.769001] ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   14.769030] NET: Registered protocol family 2
[   14.778427] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   14.778796] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   14.780966] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   14.781509] TCP: Hash tables configured (established 131072 bind 65536)
[   14.781515] TCP reno registered
[   14.785129] VFS: Disk quotas dquot_6.5.1
[   14.785144] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   14.785248] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   14.785519] NTFS driver 2.1.28 [Flags: R/O].
[   14.785549] fuse init (API version 7.8)
[   14.785668] io scheduler noop registered
[   14.785673] io scheduler anticipatory registered
[   14.785677] io scheduler deadline registered
[   14.785690] io scheduler cfq registered (default)
[   14.785948] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   14.785965] assign_interrupt_mode Found MSI capability
[   14.785993] Allocate Port Service[0000:00:04.0:pcie00]
[   14.786028] Allocate Port Service[0000:00:04.0:pcie01]
[   14.786055] Allocate Port Service[0000:00:04.0:pcie02]
[   14.786098] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   14.786114] assign_interrupt_mode Found MSI capability
[   14.786132] Allocate Port Service[0000:00:05.0:pcie00]
[   14.786158] Allocate Port Service[0000:00:05.0:pcie01]
[   14.786188] Allocate Port Service[0000:00:05.0:pcie02]
[   14.786295] Evaluate _OSC Set fails. Status = 0x0005
[   14.786300] Evaluate _OSC Set fails. Status = 0x0005
[   14.786302] aer_init: AER service init fails - Run ACPI _OSC fails
[   14.786305] aer: probe of 0000:00:04.0:pcie01 failed with error 2
[   14.786319] Evaluate _OSC Set fails. Status = 0x0005
[   14.786323] Evaluate _OSC Set fails. Status = 0x0005
[   14.786325] aer_init: AER service init fails - Run ACPI _OSC fails
[   14.786328] aer: probe of 0000:00:05.0:pcie01 failed with error 2
[   14.786469] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 3072k, total 131072k
[   14.786477] vesafb: mode is 1024x768x16, linelength=2048, pages=84
[   14.786482] vesafb: scrolling: redraw
[   14.786487] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[   14.795523] Console: switching to colour frame buffer device 128x48
[   14.803634] fb0: VESA VGA frame buffer device
[   14.805736] ACPI: AC Adapter [C177] (on-line)
[   14.827835] ACPI: Battery Slot [C179] (battery present)
[   14.828082] ACPI: Battery Slot [C178] (battery absent)
[   14.828259] input: Power Button (FF) as /class/input/input0
[   14.828360] ACPI: Power Button (FF) [PWRF]
[   14.828501] input: Sleep Button (CM) as /class/input/input1
[   14.828597] ACPI: Sleep Button (CM) [C1F0]
[   14.828716] input: Lid Switch as /class/input/input2
[   14.828801] ACPI: Lid Switch [C1F1]
[   14.829030] ACPI: Transitioning device [C270] to D3
[   14.829114] ACPI: Transitioning device [C270] to D3
[   14.829197] ACPI: Fan [C270] (off)
[   14.829386] ACPI: Transitioning device [C271] to D3
[   14.829470] ACPI: Transitioning device [C271] to D3
[   14.829554] ACPI: Fan [C271] (off)
[   14.829739] ACPI: Transitioning device [C272] to D3
[   14.829822] ACPI: Transitioning device [C272] to D3
[   14.831033] ACPI: Fan [C272] (off)
[   14.832399] ACPI: Transitioning device [C273] to D3
[   14.833707] ACPI: Transitioning device [C273] to D3
[   14.835024] ACPI: Fan [C273] (off)
[   14.836539] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   14.838232] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   14.839768] ACPI: Processor [C000] (supports 8 throttling states)
[   14.847395] ACPI: Thermal Zone [TZ1] (50 C)
[   14.852176] ACPI: Thermal Zone [TZ2] (36 C)
[   14.862087] ACPI: Thermal Zone [TZ3] (23 C)
[   14.863816] ibm_acpi: ec object not found
[   14.886192] Non-volatile memory driver v1.2
[   14.888061] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   14.890021] sc1200wdt: build 20020303
[   14.892035] sc1200wdt: io parameter must be specified
[   14.894105] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   14.896261] Linux agpgart interface v0.102 (c) Dave Jones
[   14.898540] ipmi message handler version 39.1
[   14.900802] ipmi device interface
[   14.903124] IPMI System Interface driver.
[   14.913230] ipmi_si: Unable to find any System Interface(s)
[   14.915629] IPMI Watchdog: driver initialized
[   14.918076] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   14.920678] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   14.923343] Hangcheck: Using get_cycles().
[   14.925940] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   14.929137] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   14.932322] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   14.935358] loop: loaded (max 8 devices)
[   14.938283] nbd: registered device at major 43
[   14.941605] ACPI: PCI Interrupt 0000:04:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   14.944589] tg3.c:v3.75 (March 23, 2007)
[   14.947450] ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   14.979958] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:f7:d7:da
[   14.986097] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   14.989346] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   14.992659] PPP generic driver version 2.4.2
[   14.995956] PPP Deflate Compression module registered
[   14.999286] PPP BSD Compression module registered
[   15.002658] PPP MPPE Compression module registered
[   15.006003] NET: Registered protocol family 24
[   15.009452] tun: Universal TUN/TAP device driver, 1.6
[   15.012863] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   15.016342] bcm43xx driver
[   15.019932] ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 22 (level, low) -> IRQ 22
[   15.029560] bcm43xx: Chip ID 0x4318, rev 0x2
[   15.033117] bcm43xx: Number of cores: 4
[   15.036627] bcm43xx: Core 0: ID 0x800, rev 0xd, vendor 0x4243
[   15.040165] bcm43xx: Core 1: ID 0x812, rev 0x9, vendor 0x4243
[   15.043640] bcm43xx: Core 2: ID 0x804, rev 0xc, vendor 0x4243
[   15.047120] bcm43xx: Core 3: ID 0x80d, rev 0x7, vendor 0x4243
[   15.053942] bcm43xx: PHY connected
[   15.057400] bcm43xx: Detected PHY: Analog: 3, Type 2, Revision 7
[   15.060917] bcm43xx: Detected Radio: ID: 8205017f (Manuf: 17f Ver: 2050 Rev: 8)
[   15.064432] bcm43xx: Radio turned off
[   15.067865] bcm43xx: Radio turned off
[   15.071351] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   15.074778] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   15.078289] ATIIXP: IDE controller at PCI slot 0000:00:14.1
[   15.081788] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   15.085360] ATIIXP: chipset revision 0
[   15.088920] ATIIXP: not 100% native mode: will probe irqs later
[   15.092505]     ide0: BM-DMA at 0x3010-0x3017, BIOS settings: hda:DMA, hdb:pio
[   15.096158]     ide1: BM-DMA at 0x3018-0x301f, BIOS settings: hdc:DMA, hdd:pio
[   15.099722] Probing IDE interface ide0...
[   15.141867] Time: acpi_pm clocksource has been installed.
[   15.364988] hda: FUJITSU MHV2080AH, ATA DISK drive
[   15.982317] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   15.985770] Probing IDE interface ide1...
[   16.143518] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99292d1c0c]
[   16.657068] hdc: MATSHITAUJ-840D, ATAPI CD/DVD-ROM drive
[   16.965493] ide1 at 0x170-0x177,0x376 on irq 15
[   16.969044] hda: max request size: 128KiB
[   16.972327] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
[   17.000281] hda: cache flushes supported
[   17.003649]  hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
[   17.055346] hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, (U)DMA
[   17.058739] Uniform CD-ROM driver Revision: 3.20
[   17.065668] ieee1394: raw1394: /dev/raw1394 device initialized
[   17.068869] usbmon: debugfs is not available
[   17.072032] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   17.075224] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   17.078434] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[   17.081697] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0802000
[   17.084889] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   17.088246] usb usb1: configuration #1 chosen from 1 choice
[   17.091517] hub 1-0:1.0: USB hub found
[   17.094734] hub 1-0:1.0: 8 ports detected
[   17.197914] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   17.197949] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   17.201205] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   17.204438] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[   17.207666] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0800000
[   17.265819] usb usb2: configuration #1 chosen from 1 choice
[   17.269069] hub 2-0:1.0: USB hub found
[   17.272323] hub 2-0:1.0: 4 ports detected
[   17.375625] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   17.379043] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   17.382478] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[   17.385929] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0801000
[   17.443581] usb usb3: configuration #1 chosen from 1 choice
[   17.447019] hub 3-0:1.0: USB hub found
[   17.450458] hub 3-0:1.0: 4 ports detected
[   18.011601] usb 3-1: new full speed USB device using ohci_hcd and address 2
[   18.150602] usb 3-1: configuration #1 chosen from 1 choice
[   18.371067] usb 3-3: new low speed USB device using ohci_hcd and address 3
[   18.516117] usb 3-3: configuration #1 chosen from 1 choice
[   18.520174] usbcore: registered new interface driver usblp
[   18.523518] drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
[   18.526869] Initializing USB Mass Storage driver...
[   18.530285] usbcore: registered new interface driver usb-storage
[   18.533676] USB Mass Storage support registered.
[   18.537070] usbcore: registered new interface driver hiddev
[   18.546242] input: Logitech USB Receiver as /class/input/input3
[   18.549667] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
[   18.553143] usbcore: registered new interface driver usbhid
[   18.556622] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   18.560147] PNP: PS/2 Controller [PNP0303:C1C4,PNP0f13:C1C5] at 0x60,0x64 irq 1,12
[   18.565420] i8042.c: Detected active multiplexing controller, rev 1.1.
[   18.569691] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.573189] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   18.576632] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   18.580000] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   18.583311] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   18.586675] mice: PS/2 mouse device common for all mice
[   18.611409] input: AT Translated Set 2 keyboard as /class/input/input4
[   18.624551] input: PC Speaker as /class/input/input5
[   19.232286] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   19.278131] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[   19.284292] I2O subsystem v1.325
[   19.287574] i2o: max drivers = 8
[   19.290926] i2c /dev entries driver
[   19.294353] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   19.297703] Bluetooth: HCI USB driver ver 2.9
[   19.301040] usbcore: registered new interface driver hci_usb
[   19.304389] Bluetooth: Virtual HCI driver ver 1.2
[   19.307731] Bluetooth: HCI UART driver ver 2.2
[   19.311021] Bluetooth: HCI H4 protocol initialized
[   19.314330] Bluetooth: HCI BCSP protocol initialized
[   19.317583] Bluetooth: Broadcom Blutonium firmware driver ver 1.1
[   19.320839] usbcore: registered new interface driver bcm203x
[   19.324086] Bluetooth: Digianswer Bluetooth USB driver ver 0.8
[   19.327359] usbcore: registered new interface driver bpa10x
[   19.330615] Bluetooth: BlueFRITZ! USB driver ver 1.1
[   19.333888] usbcore: registered new interface driver bfusb
[   19.337188] EDAC MC: Ver: 2.0.1 Apr 23 2007
[   19.340607] sdhci: Secure Digital Host Controller Interface driver
[   19.343884] sdhci: Copyright(c) Pierre Ossman
[   19.347158] sdhci: SDHCI controller found at 0000:04:04.4 [104c:8034] (rev 0)
[   19.350478] ACPI: PCI Interrupt 0000:04:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   19.353897] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   19.357237] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   19.360493] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   19.363637] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   19.366793] wbsd: Copyright(c) Pierre Ossman
[   19.369981] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[   19.373451] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   19.386258] ALSA device list:
[   19.389441]   #0: ATI IXP rev 2 with unknown codec at 0xd0804000, irq 17
[   19.392706] oprofile: using NMI interrupt.
[   19.395901] Netfilter messages via NETLINK v0.30.
[   19.399069] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.402215] arp_tables: (C) 2002 David S. Miller
[   19.405354] TCP cubic registered
[   19.408513] NET: Registered protocol family 1
[   19.411745] NET: Registered protocol family 10
[   19.416030] lo: Disabled Privacy Extensions
[   19.419303] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   19.422524] IPv6 over IPv4 tunneling driver
[   19.425759] sit0: Disabled Privacy Extensions
[   19.430020] NET: Registered protocol family 17
[   19.433081] Bluetooth: L2CAP ver 2.8
[   19.436098] Bluetooth: L2CAP socket layer initialized
[   19.439136] Bluetooth: SCO (Voice Link) ver 0.5
[   19.442181] Bluetooth: SCO socket layer initialized
[   19.445159] Bluetooth: RFCOMM socket layer initialized
[   19.448080] Bluetooth: RFCOMM TTY layer initialized
[   19.450959] Bluetooth: RFCOMM ver 1.8
[   19.453789] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   19.456643] Bluetooth: BNEP filters: protocol multicast
[   19.459496] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   19.462420] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   19.465359] All bugs added by David S. Miller <davem@redhat.com>
[   19.468315] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   19.471278] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   19.474299] ieee80211_crypt: registered algorithm 'NULL'
[   19.474301] ieee80211_crypt: registered algorithm 'WEP'
[   19.474303] ieee80211_crypt: registered algorithm 'CCMP'
[   19.474305] ieee80211_crypt: registered algorithm 'TKIP'
[   19.474310] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (version 2.00.00)
[   19.480053] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   19.483113] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   19.486122] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   19.489065] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   19.491950] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   19.494823] powernow-k8: ph2 null fid transition 0xe
[   19.497666] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   19.524230] kjournald starting.  Commit interval 5 seconds
[   19.527101] EXT3-fs: mounted filesystem with ordered data mode.
[   19.530059] VFS: Mounted root (ext3 filesystem) readonly.
[   19.533056] Freeing unused kernel memory: 232k freed
[   25.011599] EXT3 FS on hda7, internal journal
[   25.438770] kjournald starting.  Commit interval 5 seconds
[   25.439064] EXT3 FS on hda8, internal journal
[   25.439068] EXT3-fs: mounted filesystem with ordered data mode.
[   25.485981] NTFS volume version 3.1.
[   25.597764] Adding 1791208k swap on /dev/hda6.  Priority:-1 extents:1 across:1791208k
[   25.704145] Real Time Clock Driver v1.12ac
[   45.180727] PM: Writing back config space on device 0000:04:01.0 at offset b (was 3ed173b, writing 308b103c)
[   45.180752] PM: Writing back config space on device 0000:04:01.0 at offset 3 (was 0, writing 4010)
[   45.180759] PM: Writing back config space on device 0000:04:01.0 at offset 2 (was 2000000, writing 2000003)
[   45.180766] PM: Writing back config space on device 0000:04:01.0 at offset 1 (was 2b00000, writing 2b00006)
[   45.180773] PM: Writing back config space on device 0000:04:01.0 at offset 0 (was 3ed173b, writing 169c14e4)
[   45.474777] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   47.145294] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   47.145301] tg3: eth0: Flow control is on for TX and on for RX.
[   47.146828] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   57.152522] eth0: no IPv6 routers present

--Boundary-00=_SAcQGKDrXBouKDT
Content-Type: text/x-log;
  charset="utf-8";
  name="dmesg-without-assign-busses.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-without-assign-busses.log"

[    0.000000] Linux version 2.6.21-rc7 (mihai@mdontu-l) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #1 PREEMPT Mon Apr 23 04:16:33 EEST 2007
[    0.000000] Command line: vga=791 nohz=on
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000037fd0000 - 0000000037fefc00 (reserved)
[    0.000000]  BIOS-e820: 0000000037fefc00 - 0000000037ffb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000037ffb000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec02000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FE270, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 37FEFC84, 0034 (r1 HP     0944     22110520 HP          1)
[    0.000000] ACPI: FACP 37FEFC00, 0084 (r2 HP     0944            2 HP          1)
[    0.000000] ACPI: DSDT 37FEFD50, 7489 (r1 HP        SB400    10000 MSFT  100000E)
[    0.000000] ACPI: FACS 37FFAE80, 0040
[    0.000000] ACPI: APIC 37FEFCB8, 005A (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: MCFG 37FEFD14, 003C (r1 HP     0944            1 HP          1)
[    0.000000] ACPI: SSDT 37FF71D9, 0382 (r1 HP       HPQPpc     1001 MSFT  100000E)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 229328) 1 entries of 256 used
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   229328
[    0.000000] On node 0 totalpages: 229231
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2012 pages reserved
[    0.000000]   DMA zone: 1931 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3079 pages used for memmap
[    0.000000]   DMA32 zone: 222153 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfec01000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 21 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000e0000
[    0.000000] Nosave address range: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists.  Total pages: 224084
[    0.000000] Kernel command line: vga=791 nohz=on
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   16.881066] time.c: Detected 2194.636 MHz processor.
[   16.881136] Console: colour dummy device 80x25
[   16.883258] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   16.884649] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   16.904728] Memory: 894468k/917312k available (4263k kernel code, 22208k reserved, 1795k data, 232k init)
[   16.963932] Calibrating delay using timer specific routine.. 4395.21 BogoMIPS (lpj=2197606)
[   16.964004] Mount-cache hash table entries: 256
[   16.964200] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   16.964206] CPU: L2 Cache: 1024K (64 bytes/line)
[   16.964232] CPU: AMD Turion(tm) 64 Mobile ML-40                  stepping 02
[   16.964257] ACPI: Core revision 20070126
[   17.011244] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   17.021256] Using local APIC timer interrupts.
[   17.066768] result 12469524
[   17.066772] Detected 12.469 MHz APIC timer.
[   17.067919] NET: Registered protocol family 16
[   17.068005] No dock devices found.
[   17.068075] ACPI: bus type pci registered
[   17.071049] PCI: Using MMCONFIG at e0000000 - efffffff
[   17.071095] PCI: No mmconfig possible on device 00:18
[   17.084371] ACPI: Interpreter enabled
[   17.084381] ACPI: (supports S0 S3 S4 S5)
[   17.084398] ACPI: Using IOAPIC for interrupt routing
[   17.099556] ACPI: PCI Root Bridge [C047] (0000:00)
[   17.099569] PCI: Probing PCI hardware (bus 00)
[   17.099982] 0000:00:14.1: trying to change BAR0 from 0000 to 01F0
[   17.099988] 0000:00:14.1: trying to change BAR1 from 0000 to 03F4
[   17.099993] 0000:00:14.1: trying to change BAR2 from 0000 to 0170
[   17.099998] 0000:00:14.1: trying to change BAR3 from 0000 to 0374
[   17.100301] Boot video device is 0000:01:05.0
[   17.100994] PCI: Transparent bridge - 0000:00:14.4
[   17.101059] PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
[   17.101067] Please report the result to linux-kernel to fix this permanently
[   17.101090] ACPI: PCI Interrupt Routing Table [\_SB_.C047._PRT]
[   17.101284] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C048._PRT]
[   17.101364] ACPI: PCI Interrupt Routing Table [\_SB_.C047.C0AB._PRT]
[   17.113098] ACPI: PCI Interrupt Link [C0F0] (IRQs 10 11) *0, disabled.
[   17.113221] ACPI: PCI Interrupt Link [C0F1] (IRQs 10 11) *0, disabled.
[   17.113342] ACPI: PCI Interrupt Link [C0F2] (IRQs 10 11) *0, disabled.
[   17.113463] ACPI: PCI Interrupt Link [C0F3] (IRQs 10 11) *0, disabled.
[   17.113584] ACPI: PCI Interrupt Link [C0F4] (IRQs 10 11) *0, disabled.
[   17.113711] ACPI: PCI Interrupt Link [C0F5] (IRQs 9) *0, disabled.
[   17.113833] ACPI: PCI Interrupt Link [C0F6] (IRQs 10 11) *0, disabled.
[   17.113961] ACPI: PCI Interrupt Link [C0F7] (IRQs *10 11)
[   17.114071] ACPI: Power Resource [C1CF] (off)
[   17.114215] ACPI: Power Resource [C1B7] (on)
[   17.114254] ACPI: Power Resource [C1C7] (on)
[   17.114333] ACPI: Power Resource [C26C] (off)
[   17.114403] ACPI: Power Resource [C26D] (off)
[   17.114472] ACPI: Power Resource [C26E] (off)
[   17.114542] ACPI: Power Resource [C26F] (off)
[   17.114553] Linux Plug and Play Support v0.97 (c) Adam Belay
[   17.114568] pnp: PnP ACPI init
[   17.120505] pnp: PnP ACPI: found 12 devices
[   17.120636] SCSI subsystem initialized
[   17.120711] usbcore: registered new interface driver usbfs
[   17.120741] usbcore: registered new interface driver hub
[   17.120773] usbcore: registered new device driver usb
[   17.120841] PCI: Using ACPI for IRQ routing
[   17.120847] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   17.120857] PCI: Cannot allocate resource region 7 of bridge 0000:00:04.0
[   17.120862] PCI: Cannot allocate resource region 8 of bridge 0000:00:04.0
[   17.120867] PCI: Cannot allocate resource region 9 of bridge 0000:00:04.0
[   17.120872] PCI: Cannot allocate resource region 7 of bridge 0000:00:05.0
[   17.120876] PCI: Cannot allocate resource region 8 of bridge 0000:00:05.0
[   17.120881] PCI: Cannot allocate resource region 9 of bridge 0000:00:05.0
[   17.120978] Bluetooth: Core ver 2.11
[   17.121015] NET: Registered protocol family 31
[   17.121019] Bluetooth: HCI device and connection manager initialized
[   17.121025] Bluetooth: HCI socket layer initialized
[   17.121029] NET: Registered protocol family 8
[   17.121033] NET: Registered protocol family 20
[   17.121076] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   17.121083] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[   17.121088] pnp: 00:00: iomem range 0x100000-0x37ffffff could not be reserved
[   17.121097] pnp: 00:09: ioport range 0x40b-0x40b has been reserved
[   17.121103] pnp: 00:09: ioport range 0x4d0-0x4d1 has been reserved
[   17.121108] pnp: 00:09: ioport range 0x4d6-0x4d6 has been reserved
[   17.121114] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[   17.121121] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[   17.121130] pnp: 00:0a: ioport range 0x8000-0x802f has been reserved
[   17.121136] pnp: 00:0a: ioport range 0x8100-0x811f has been reserved
[   17.121143] pnp: 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[   17.121150] pnp: 00:0a: iomem range 0xfec00000-0xfec000ff has been reserved
[   17.121157] pnp: 00:0b: iomem range 0xcf000-0xdffff has been reserved
[   17.121163] pnp: 00:0b: iomem range 0x38000000-0x3fffffff could not be reserved
[   17.121171] pnp: 00:0b: iomem range 0xfec01000-0xfec01fff could not be reserved
[   17.121389] ieee1394: Initialized config rom entry `ip1394'
[   17.121485] ACPI: PCI Interrupt 0000:02:04.2[C] -> GSI 21 (level, low) -> IRQ 21
[   17.121683] Time: tsc clocksource has been installed.
[   17.171833] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[d0013000-d00137ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   17.171937] PCI: Bridge: 0000:00:01.0
[   17.171942]   IO window: 2000-2fff
[   17.171947]   MEM window: d0400000-d07fffff
[   17.171952]   PREFETCH window: c0000000-cfffffff
[   17.171956] PCI: Bridge: 0000:00:04.0
[   17.171959]   IO window: disabled.
[   17.171963]   MEM window: disabled.
[   17.171967]   PREFETCH window: disabled.
[   17.171971] PCI: Bridge: 0000:00:05.0
[   17.171974]   IO window: disabled.
[   17.171978]   MEM window: disabled.
[   17.171982]   PREFETCH window: disabled.
[   17.171988] PCI: Bus 3, cardbus bridge: 0000:02:04.0
[   17.171993]   IO window: 00001000-000010ff
[   17.171997]   IO window: 00001400-000014ff
[   17.172002]   PREFETCH window: 50000000-53ffffff
[   17.172007]   MEM window: 54000000-57ffffff
[   17.172011] PCI: Bridge: 0000:00:14.4
[   17.172016]   IO window: 1000-1fff
[   17.172021]   MEM window: d0000000-d03fffff
[   17.172025]   PREFETCH window: 50000000-53ffffff
[   17.172037] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   17.172043] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   17.172067] ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   17.172097] NET: Registered protocol family 2
[   17.181624] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   17.181993] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[   17.184158] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   17.184693] TCP: Hash tables configured (established 131072 bind 65536)
[   17.184699] TCP reno registered
[   17.188318] VFS: Disk quotas dquot_6.5.1
[   17.188334] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   17.188439] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.188708] NTFS driver 2.1.28 [Flags: R/O].
[   17.188739] fuse init (API version 7.8)
[   17.188859] io scheduler noop registered
[   17.188865] io scheduler anticipatory registered
[   17.188869] io scheduler deadline registered
[   17.188882] io scheduler cfq registered (default)
[   17.189141] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   17.189157] assign_interrupt_mode Found MSI capability
[   17.189185] Allocate Port Service[0000:00:04.0:pcie00]
[   17.189222] Allocate Port Service[0000:00:04.0:pcie01]
[   17.189249] Allocate Port Service[0000:00:04.0:pcie02]
[   17.189293] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   17.189309] assign_interrupt_mode Found MSI capability
[   17.189326] Allocate Port Service[0000:00:05.0:pcie00]
[   17.189352] Allocate Port Service[0000:00:05.0:pcie01]
[   17.189383] Allocate Port Service[0000:00:05.0:pcie02]
[   17.189493] Evaluate _OSC Set fails. Status = 0x0005
[   17.189498] Evaluate _OSC Set fails. Status = 0x0005
[   17.189501] aer_init: AER service init fails - Run ACPI _OSC fails
[   17.189504] aer: probe of 0000:00:04.0:pcie01 failed with error 2
[   17.189518] Evaluate _OSC Set fails. Status = 0x0005
[   17.189522] Evaluate _OSC Set fails. Status = 0x0005
[   17.189524] aer_init: AER service init fails - Run ACPI _OSC fails
[   17.189527] aer: probe of 0000:00:05.0:pcie01 failed with error 2
[   17.189669] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc20010100000, using 3072k, total 131072k
[   17.189678] vesafb: mode is 1024x768x16, linelength=2048, pages=84
[   17.189682] vesafb: scrolling: redraw
[   17.189687] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[   17.198727] Console: switching to colour frame buffer device 128x48
[   17.206836] fb0: VESA VGA frame buffer device
[   17.208804] ACPI: AC Adapter [C177] (off-line)
[   17.230875] ACPI: Battery Slot [C179] (battery present)
[   17.231123] ACPI: Battery Slot [C178] (battery absent)
[   17.231299] input: Power Button (FF) as /class/input/input0
[   17.231395] ACPI: Power Button (FF) [PWRF]
[   17.231539] input: Sleep Button (CM) as /class/input/input1
[   17.231636] ACPI: Sleep Button (CM) [C1F0]
[   17.231755] input: Lid Switch as /class/input/input2
[   17.231840] ACPI: Lid Switch [C1F1]
[   17.232069] ACPI: Transitioning device [C270] to D3
[   17.232154] ACPI: Transitioning device [C270] to D3
[   17.232238] ACPI: Fan [C270] (off)
[   17.232424] ACPI: Transitioning device [C271] to D3
[   17.232507] ACPI: Transitioning device [C271] to D3
[   17.232595] ACPI: Fan [C271] (off)
[   17.232783] ACPI: Transitioning device [C272] to D3
[   17.232866] ACPI: Transitioning device [C272] to D3
[   17.234080] ACPI: Fan [C272] (off)
[   17.235438] ACPI: Transitioning device [C273] to D3
[   17.236748] ACPI: Transitioning device [C273] to D3
[   17.238062] ACPI: Fan [C273] (off)
[   17.239584] ACPI: Video Device [C049] (multi-head: yes  rom: no  post: no)
[   17.241296] ACPI: CPU0 (power states: C1[C1] C3[C3])
[   17.242832] ACPI: Processor [C000] (supports 8 throttling states)
[   17.250546] ACPI: Thermal Zone [TZ1] (38 C)
[   17.255362] ACPI: Thermal Zone [TZ2] (24 C)
[   17.265145] ACPI: Thermal Zone [TZ3] (22 C)
[   17.266877] ibm_acpi: ec object not found
[   17.289181] Non-volatile memory driver v1.2
[   17.291050] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=0)
[   17.293014] sc1200wdt: build 20020303
[   17.295038] sc1200wdt: io parameter must be specified
[   17.297120] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   17.299276] Linux agpgart interface v0.102 (c) Dave Jones
[   17.301562] ipmi message handler version 39.1
[   17.303836] ipmi device interface
[   17.306168] IPMI System Interface driver.
[   17.316426] ipmi_si: Unable to find any System Interface(s)
[   17.318830] IPMI Watchdog: driver initialized
[   17.321287] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   17.323903] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[   17.326577] Hangcheck: Using get_cycles().
[   17.329190] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   17.332418] ACPI: PCI Interrupt 0000:00:14.6[B] -> GSI 17 (level, low) -> IRQ 17
[   17.335619] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   17.338670] loop: loaded (max 8 devices)
[   17.341612] nbd: registered device at major 43
[   17.344956] ACPI: PCI Interrupt 0000:02:04.3[B] -> GSI 21 (level, low) -> IRQ 21
[   17.347953] tg3.c:v3.75 (March 23, 2007)
[   17.350823] ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 23 (level, low) -> IRQ 23
[   17.383185] eth0: Tigon3 [partno(BCM95788A50) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:0f:b0:f7:d7:da
[   17.389348] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
[   17.392616] eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
[   17.395951] PPP generic driver version 2.4.2
[   17.399259] PPP Deflate Compression module registered
[   17.402594] PPP BSD Compression module registered
[   17.405983] PPP MPPE Compression module registered
[   17.409340] NET: Registered protocol family 24
[   17.412809] tun: Universal TUN/TAP device driver, 1.6
[   17.416237] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   17.419728] bcm43xx driver
[   17.423345] ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 22 (level, low) -> IRQ 22
[   17.432996] bcm43xx: Chip ID 0x4318, rev 0x2
[   17.436565] bcm43xx: Number of cores: 4
[   17.440094] bcm43xx: Core 0: ID 0x800, rev 0xd, vendor 0x4243
[   17.443648] bcm43xx: Core 1: ID 0x812, rev 0x9, vendor 0x4243
[   17.447147] bcm43xx: Core 2: ID 0x804, rev 0xc, vendor 0x4243
[   17.450641] bcm43xx: Core 3: ID 0x80d, rev 0x7, vendor 0x4243
[   17.457485] bcm43xx: PHY connected
[   17.460965] bcm43xx: Detected PHY: Analog: 3, Type 2, Revision 7
[   17.464498] bcm43xx: Detected Radio: ID: 8205017f (Manuf: 17f Ver: 2050 Rev: 8)
[   17.468023] bcm43xx: Radio turned off
[   17.471474] bcm43xx: Radio turned off
[   17.474972] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   17.478415] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   17.481941] ATIIXP: IDE controller at PCI slot 0000:00:14.1
[   17.485448] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[   17.489034] ATIIXP: chipset revision 0
[   17.492607] ATIIXP: not 100% native mode: will probe irqs later
[   17.496215]     ide0: BM-DMA at 0x3010-0x3017, BIOS settings: hda:DMA, hdb:pio
[   17.499885]     ide1: BM-DMA at 0x3018-0x301f, BIOS settings: hdc:DMA, hdd:pio
[   17.503454] Probing IDE interface ide0...
[   17.546062] Time: acpi_pm clocksource has been installed.
[   17.769182] hda: FUJITSU MHV2080AH, ATA DISK drive
[   18.386438] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   18.389909] Probing IDE interface ide1...
[   18.547713] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f99292d1c0c]
[   19.061262] hdc: MATSHITAUJ-840D, ATAPI CD/DVD-ROM drive
[   19.369687] ide1 at 0x170-0x177,0x376 on irq 15
[   19.373259] hda: max request size: 128KiB
[   19.376554] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63, UDMA(100)
[   19.578420] hda: cache flushes supported
[   19.581801]  hda: hda1 hda2 < hda5 hda6 hda7 hda8 >
[   19.635404] hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, (U)DMA
[   19.638814] Uniform CD-ROM driver Revision: 3.20
[   19.645749] ieee1394: raw1394: /dev/raw1394 device initialized
[   19.648963] usbmon: debugfs is not available
[   19.652131] ACPI: PCI Interrupt 0000:00:13.2[A] -> GSI 19 (level, low) -> IRQ 19
[   19.655336] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   19.658553] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 1
[   19.661818] ehci_hcd 0000:00:13.2: irq 19, io mem 0xd0802000
[   19.665025] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   19.668394] usb usb1: configuration #1 chosen from 1 choice
[   19.671681] hub 1-0:1.0: USB hub found
[   19.674908] hub 1-0:1.0: 8 ports detected
[   19.778832] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   19.778866] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 19 (level, low) -> IRQ 19
[   19.782142] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   19.785384] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[   19.788614] ohci_hcd 0000:00:13.0: irq 19, io mem 0xd0800000
[   19.846755] usb usb2: configuration #1 chosen from 1 choice
[   19.850017] hub 2-0:1.0: USB hub found
[   19.853278] hub 2-0:1.0: 4 ports detected
[   19.956558] ACPI: PCI Interrupt 0000:00:13.1[A] -> GSI 19 (level, low) -> IRQ 19
[   19.959974] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   19.963420] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[   19.966889] ohci_hcd 0000:00:13.1: irq 19, io mem 0xd0801000
[   20.024516] usb usb3: configuration #1 chosen from 1 choice
[   20.027959] hub 3-0:1.0: USB hub found
[   20.031418] hub 3-0:1.0: 4 ports detected
[   20.592532] usb 3-1: new full speed USB device using ohci_hcd and address 2
[   20.731533] usb 3-1: configuration #1 chosen from 1 choice
[   20.951999] usb 3-3: new low speed USB device using ohci_hcd and address 3
[   21.097047] usb 3-3: configuration #1 chosen from 1 choice
[   21.101105] usbcore: registered new interface driver usblp
[   21.104464] drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
[   21.107824] Initializing USB Mass Storage driver...
[   21.111262] usbcore: registered new interface driver usb-storage
[   21.114666] USB Mass Storage support registered.
[   21.118079] usbcore: registered new interface driver hiddev
[   21.127167] input: Logitech USB Receiver as /class/input/input3
[   21.130610] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:13.1-3
[   21.134107] usbcore: registered new interface driver usbhid
[   21.137603] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   21.141135] PNP: PS/2 Controller [PNP0303:C1C4,PNP0f13:C1C5] at 0x60,0x64 irq 1,12
[   21.146471] i8042.c: Detected active multiplexing controller, rev 1.1.
[   21.150765] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.154282] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   21.157737] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   21.161130] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   21.164458] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   21.167837] mice: PS/2 mouse device common for all mice
[   21.192936] input: AT Translated Set 2 keyboard as /class/input/input4
[   21.206547] input: PC Speaker as /class/input/input5
[   21.813842] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04713/0x200000
[   21.859050] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[   21.865212] I2O subsystem v1.325
[   21.868506] i2o: max drivers = 8
[   21.871863] i2c /dev entries driver
[   21.875305] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   21.878663] Bluetooth: HCI USB driver ver 2.9
[   21.882015] usbcore: registered new interface driver hci_usb
[   21.885371] Bluetooth: Virtual HCI driver ver 1.2
[   21.888722] Bluetooth: HCI UART driver ver 2.2
[   21.892027] Bluetooth: HCI H4 protocol initialized
[   21.895344] Bluetooth: HCI BCSP protocol initialized
[   21.898607] Bluetooth: Broadcom Blutonium firmware driver ver 1.1
[   21.901870] usbcore: registered new interface driver bcm203x
[   21.905120] Bluetooth: Digianswer Bluetooth USB driver ver 0.8
[   21.908412] usbcore: registered new interface driver bpa10x
[   21.911674] Bluetooth: BlueFRITZ! USB driver ver 1.1
[   21.914960] usbcore: registered new interface driver bfusb
[   21.918266] EDAC MC: Ver: 2.0.1 Apr 23 2007
[   21.921696] sdhci: Secure Digital Host Controller Interface driver
[   21.924992] sdhci: Copyright(c) Pierre Ossman
[   21.928271] sdhci: SDHCI controller found at 0000:02:04.4 [104c:8034] (rev 0)
[   21.931594] ACPI: PCI Interrupt 0000:02:04.4[C] -> GSI 21 (level, low) -> IRQ 21
[   21.935018] mmc0: SDHCI at 0xd001a000 irq 21 DMA
[   21.938358] mmc1: SDHCI at 0xd001b000 irq 21 DMA
[   21.941625] mmc2: SDHCI at 0xd001c000 irq 21 DMA
[   21.944776] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   21.947944] wbsd: Copyright(c) Pierre Ossman
[   21.951140] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[   21.954622] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level, low) -> IRQ 17
[   21.966448] ALSA device list:
[   21.970637]   #0: ATI IXP rev 2 with unknown codec at 0xd0804000, irq 17
[   21.974928] oprofile: using NMI interrupt.
[   21.978125] Netfilter messages via NETLINK v0.30.
[   21.981298] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.984449] arp_tables: (C) 2002 David S. Miller
[   21.987591] TCP cubic registered
[   21.990761] NET: Registered protocol family 1
[   21.994011] NET: Registered protocol family 10
[   21.998306] lo: Disabled Privacy Extensions
[   22.001589] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   22.004813] IPv6 over IPv4 tunneling driver
[   22.008063] sit0: Disabled Privacy Extensions
[   22.013347] NET: Registered protocol family 17
[   22.016425] Bluetooth: L2CAP ver 2.8
[   22.019449] Bluetooth: L2CAP socket layer initialized
[   22.022505] Bluetooth: SCO (Voice Link) ver 0.5
[   22.025564] Bluetooth: SCO socket layer initialized
[   22.028561] Bluetooth: RFCOMM socket layer initialized
[   22.031494] Bluetooth: RFCOMM TTY layer initialized
[   22.034385] Bluetooth: RFCOMM ver 1.8
[   22.037221] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   22.040087] Bluetooth: BNEP filters: protocol multicast
[   22.042961] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   22.045900] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   22.048854] All bugs added by David S. Miller <davem@redhat.com>
[   22.051817] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   22.054797] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   22.057828] ieee80211_crypt: registered algorithm 'NULL'
[   22.057830] ieee80211_crypt: registered algorithm 'WEP'
[   22.057833] ieee80211_crypt: registered algorithm 'CCMP'
[   22.057835] ieee80211_crypt: registered algorithm 'TKIP'
[   22.057840] powernow-k8: Found 1 AMD Turion(tm) 64 Mobile ML-40                  processors (version 2.00.00)
[   22.063645] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x4
[   22.066713] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
[   22.069724] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x8
[   22.072678] powernow-k8:    3 : fid 0x8 (1600 MHz), vid 0xa
[   22.075578] powernow-k8:    4 : fid 0x0 (800 MHz), vid 0x16
[   22.085069] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   22.109885] kjournald starting.  Commit interval 5 seconds
[   22.112358] EXT3-fs: mounted filesystem with ordered data mode.
[   22.114912] VFS: Mounted root (ext3 filesystem) readonly.
[   22.117553] Freeing unused kernel memory: 232k freed
[   26.855026] EXT3 FS on hda7, internal journal
[   27.203479] kjournald starting.  Commit interval 5 seconds
[   27.203715] EXT3 FS on hda8, internal journal
[   27.203720] EXT3-fs: mounted filesystem with ordered data mode.
[   27.242746] NTFS volume version 3.1.
[   27.333431] Adding 1791208k swap on /dev/hda6.  Priority:-1 extents:1 across:1791208k
[   27.429880] Real Time Clock Driver v1.12ac
[   44.950180] PM: Writing back config space on device 0000:02:01.0 at offset c (was f7f70000, writing 0)
[   44.950188] PM: Writing back config space on device 0000:02:01.0 at offset b (was 3ed173b, writing 308b103c)
[   44.950207] PM: Writing back config space on device 0000:02:01.0 at offset 3 (was 0, writing 4010)
[   44.950213] PM: Writing back config space on device 0000:02:01.0 at offset 2 (was 2000000, writing 2000003)
[   44.950220] PM: Writing back config space on device 0000:02:01.0 at offset 1 (was 2b00000, writing 2b00006)
[   44.950226] PM: Writing back config space on device 0000:02:01.0 at offset 0 (was 3ed173b, writing 169c14e4)
[   45.191234] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   46.523323] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   46.523329] tg3: eth0: Flow control is on for TX and on for RX.
[   46.524845] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   54.775436] eth0: no IPv6 routers present

--Boundary-00=_SAcQGKDrXBouKDT--

