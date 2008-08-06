Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYHFEGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYHFEGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYHFEFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:05:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:51761 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYHFEFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dJngfaraFgpns7do55pBku2vO2mU1p+xNKrxwprckXFIxC6mjxbh+f7T0ikJjdvi+v
         wlLk6Alwtqq+2n38kpKdVilUFBvQCl9+KBi9GLqgtLmAfTtx4KrWx8dElaerZ8EDzTyL
         vGQW6DoD7PKfrFuM3HN5SdyMVbBF2B6RiVV+U=
Message-ID: <b6a2187b0808052105l15bf0e66re106a426d4bbc928@mail.gmail.com>
Date: Wed, 6 Aug 2008 12:05:51 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808052050u489264beo30812523669ef4df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <86802c440808052050u489264beo30812523669ef4df@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 11:50 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 32bit or 64 bit?

32bit.

    High Memory Support (64GB)  --->
-*- PAE (Physical Address Extension) Support
    Memory model (Sparse Memory)  --->
-*- 64 bit Memory and IO resources (EXPERIMENTAL)
[*] Allocate 3rd-level pagetables from highmem


> can you post full demsg?

The following is "cut&paste" ... (gmail is not the a good way to do
this.) for the 8 cpus that I managed to boot.

routine.. 3723.90 BogoMIPS (lpj=7447810)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 6
CPU: Processor Core ID: 0
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
CPU 4 irqstacks, hard=c053f000 soft=c051f000
Booting processor 4/2 ip 6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 3723.87 BogoMIPS (lpj=7447748)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
CPU 5 irqstacks, hard=c0540000 soft=c0520000
Booting processor 5/10 ip 6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 3723.89 BogoMIPS (lpj=7447794)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
CPU 6 irqstacks, hard=c0541000 soft=c0521000
Booting processor 6/18 ip 6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 3723.89 BogoMIPS (lpj=7447791)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 4
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
CPU 7 irqstacks, hard=c0542000 soft=c0522000
Booting processor 7/26 ip 6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 3723.88 BogoMIPS (lpj=7447769)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 6
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
Total of 8 processors activated (29791.07 BogoMIPS).
net_namespace: 596 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
No dock devices found.
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Dell PowerEdge R900 detected, enabling pci=bfsort.
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor: Dell Inc.
ACPI: DMI Product Name: PowerEdge R900
ACPI: DMI Product Version:
ACPI: DMI Board Name: 0C764H
ACPI: DMI BIOS Vendor: Dell Inc.
ACPI: DMI BIOS Date: 03/23/2008
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:16:00.0: PME# supported from D0 D3hot D3cold
pci 0000:16:00.0: PME# disabled
pci 0000:16:00.3: PME# supported from D0 D3hot D3cold
pci 0000:16:00.3: PME# disabled
pci 0000:17:00.0: PME# supported from D0 D3hot D3cold
pci 0000:17:00.0: PME# disabled
pci 0000:17:01.0: PME# supported from D0 D3hot D3cold
pci 0000:17:01.0: PME# disabled
pci 0000:19:00.0: supports D1
pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:02:02.0: PME# supported from D0 D3hot D3cold
pci 0000:02:02.0: PME# disabled
pci 0000:02:03.0: PME# supported from D0 D3hot D3cold
pci 0000:02:03.0: PME# disabled
pci 0000:02:04.0: PME# supported from D0 D3hot D3cold
pci 0000:02:04.0: PME# disabled
pci 0000:02:05.0: PME# supported from D0 D3hot D3cold
pci 0000:02:05.0: PME# disabled
pci 0000:0a:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0a:00.0: PME# disabled
pci 0000:0b:00.0: PME# supported from D3hot D3cold
pci 0000:0b:00.0: PME# disabled
pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
pci 0000:08:00.0: PME# disabled
pci 0000:09:00.0: PME# supported from D3hot D3cold
pci 0000:09:00.0: PME# disabled
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:07:00.0: PME# supported from D3hot D3cold
pci 0000:07:00.0: PME# disabled
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:05:00.0: PME# supported from D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0d:02.0: PME# disabled
pci 0000:0d:04.0: PME# supported from D0 D3hot D3cold
pci 0000:0d:04.0: PME# disabled
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:11:02.0: PME# supported from D0 D3hot D3cold
pci 0000:11:02.0: PME# disabled
pci 0000:11:04.0: PME# supported from D0 D3hot D3cold
pci 0000:11:04.0: PME# disabled
pci 0000:1b:0c.0: supports D1
pci 0000:1b:0c.0: supports D2
pci 0000:00:1e.0: transparent bridge
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST.DWN1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2.UPST.DWN2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3.UPST.DWN2.BCOM._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3.UPST.DWN3.BCOM._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3.UPST.DWN4.BCOM._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3.UPST.DWN5.BCOM._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4.UPST.DWNB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4.UPST.DWNC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6.UPST.DWNB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6.UPST.DWNC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SBEX._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.COMP._PRT]
ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 *10 11 12)
ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 *6 7 10 11 12)
ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 *5 6 7 10 11 12)
ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 *11 12)
ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 7
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 3
system 00:07: ioport range 0x800-0x87f has been reserved
system 00:07: ioport range 0x880-0x8bf has been reserved
system 00:07: ioport range 0x8c0-0x8df has been reserved
system 00:07: ioport range 0x8e0-0x8e3 has been reserved
system 00:07: ioport range 0x8f0-0x8f1 has been reserved
system 00:07: ioport range 0x900-0x900 has been reserved
system 00:07: ioport range 0xc00-0xc7f has been reserved
system 00:07: ioport range 0xca0-0xca7 has been reserved
system 00:07: ioport range 0xca9-0xcab has been reserved
system 00:07: ioport range 0xcad-0xcaf has been reserved
system 00:08: ioport range 0xca8-0xca8 has been reserved
system 00:08: ioport range 0xcac-0xcac has been reserved
system 00:09: iomem range 0xe0000000-0xefffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:14
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:17:00.0: PCI bridge, secondary bus 0000:19
pci 0000:17:00.0:   IO window: 0xe000-0xefff
pci 0000:17:00.0:   MEM window: 0xde200000-0xde3fffff
pci 0000:17:00.0:   PREFETCH window: disabled
pci 0000:17:01.0: PCI bridge, secondary bus 0000:18
pci 0000:17:01.0:   IO window: disabled
pci 0000:17:01.0:   MEM window: disabled
pci 0000:17:01.0:   PREFETCH window: disabled
pci 0000:16:00.0: PCI bridge, secondary bus 0000:17
pci 0000:16:00.0:   IO window: 0xe000-0xefff
pci 0000:16:00.0:   MEM window: 0xde200000-0xde3fffff
pci 0000:16:00.0:   PREFETCH window: disabled
pci 0000:16:00.3: PCI bridge, secondary bus 0000:1a
pci 0000:16:00.3:   IO window: disabled
pci 0000:16:00.3:   MEM window: disabled
pci 0000:16:00.3:   PREFETCH window: disabled
pci 0000:00:02.0: PCI bridge, secondary bus 0000:16
pci 0000:00:02.0:   IO window: 0xe000-0xefff
pci 0000:00:02.0:   MEM window: 0xde100000-0xde3fffff
pci 0000:00:02.0:   PREFETCH window: disabled
pci 0000:02:01.0: PCI bridge, secondary bus 0000:03
pci 0000:02:01.0:   IO window: disabled
pci 0000:02:01.0:   MEM window: disabled
pci 0000:02:01.0:   PREFETCH window: disabled
pci 0000:0a:00.0: PCI bridge, secondary bus 0000:0b
pci 0000:0a:00.0:   IO window: disabled
pci 0000:0a:00.0:   MEM window: 0xd6000000-0xd7ffffff
pci 0000:0a:00.0:   PREFETCH window: disabled
pci 0000:02:02.0: PCI bridge, secondary bus 0000:0a
pci 0000:02:02.0:   IO window: disabled
pci 0000:02:02.0:   MEM window: 0xd6000000-0xd7ffffff
pci 0000:02:02.0:   PREFETCH window: disabled
pci 0000:08:00.0: PCI bridge, secondary bus 0000:09
pci 0000:08:00.0:   IO window: disabled
pci 0000:08:00.0:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:08:00.0:   PREFETCH window: disabled
pci 0000:02:03.0: PCI bridge, secondary bus 0000:08
pci 0000:02:03.0:   IO window: disabled
pci 0000:02:03.0:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:02:03.0:   PREFETCH window: disabled
pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
pci 0000:06:00.0:   IO window: disabled
pci 0000:06:00.0:   MEM window: 0xda000000-0xdbffffff
pci 0000:06:00.0:   PREFETCH window: disabled
pci 0000:02:04.0: PCI bridge, secondary bus 0000:06
pci 0000:02:04.0:   IO window: disabled
pci 0000:02:04.0:   MEM window: 0xda000000-0xdbffffff
pci 0000:02:04.0:   PREFETCH window: disabled
pci 0000:04:00.0: PCI bridge, secondary bus 0000:05
pci 0000:04:00.0:   IO window: disabled
pci 0000:04:00.0:   MEM window: 0xdc000000-0xddffffff
pci 0000:04:00.0:   PREFETCH window: disabled
pci 0000:02:05.0: PCI bridge, secondary bus 0000:04
pci 0000:02:05.0:   IO window: disabled
pci 0000:02:05.0:   MEM window: 0xdc000000-0xddffffff
pci 0000:02:05.0:   PREFETCH window: disabled
pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
pci 0000:01:00.0:   IO window: disabled
pci 0000:01:00.0:   MEM window: 0xd6000000-0xddffffff
pci 0000:01:00.0:   PREFETCH window: disabled
pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
pci 0000:00:03.0:   IO window: disabled
pci 0000:00:03.0:   MEM window: 0xd6000000-0xddffffff
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:0d:02.0: PCI bridge, secondary bus 0000:0f
pci 0000:0d:02.0:   IO window: disabled
pci 0000:0d:02.0:   MEM window: disabled
pci 0000:0d:02.0:   PREFETCH window: disabled
pci 0000:0d:04.0: PCI bridge, secondary bus 0000:0e
pci 0000:0d:04.0:   IO window: disabled
pci 0000:0d:04.0:   MEM window: disabled
pci 0000:0d:04.0:   PREFETCH window: disabled
pci 0000:0c:00.0: PCI bridge, secondary bus 0000:0d
pci 0000:0c:00.0:   IO window: disabled
pci 0000:0c:00.0:   MEM window: disabled
pci 0000:0c:00.0:   PREFETCH window: disabled
pci 0000:00:04.0: PCI bridge, secondary bus 0000:0c
pci 0000:00:04.0:   IO window: disabled
pci 0000:00:04.0:   MEM window: disabled
pci 0000:00:04.0:   PREFETCH window: disabled
pci 0000:11:02.0: PCI bridge, secondary bus 0000:13
pci 0000:11:02.0:   IO window: disabled
pci 0000:11:02.0:   MEM window: disabled
pci 0000:11:02.0:   PREFETCH window: disabled
pci 0000:11:04.0: PCI bridge, secondary bus 0000:12
pci 0000:11:04.0:   IO window: disabled
pci 0000:11:04.0:   MEM window: disabled
pci 0000:11:04.0:   PREFETCH window: disabled
pci 0000:10:00.0: PCI bridge, secondary bus 0000:11
pci 0000:10:00.0:   IO window: disabled
pci 0000:00:06.0:   MEM window: disabled
pci 0000:00:06.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:15
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:1b
pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
pci 0000:00:1e.0:   MEM window: 0xde400000-0xde4fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000c8000000-0x000000cfffffff
pci 0000:00:01.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:02.0: setting latency timer to 64
pci 0000:16:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:16:00.0: setting latency timer to 64
pci 0000:17:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:17:00.0: setting latency timer to 64
pci 0000:17:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:17:01.0: setting latency timer to 64
pci 0000:16:00.3: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
pci 0000:00:03.0: setting latency timer to 64
pci 0000:01:00.0: setting latency timer to 64
pci 0000:02:01.0: setting latency timer to 64
pci 0000:02:02.0: setting latency timer to 64
pci 0000:0a:00.0: setting latency timer to 64
pci 0000:02:03.0: setting latency timer to 64
pci 0000:08:00.0: setting latency timer to 64
pci 0000:02:04.0: setting latency timer to 64
pci 0000:06:00.0: setting latency timer to 64
pci 0000:02:05.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:04:00.0: setting latency timer to 64
pci 0000:00:04.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:00:04.0: setting latency timer to 64
pci 0000:0c:00.0: setting latency timer to 64
pci 0000:0d:02.0: setting latency timer to 64
pci 0000:0d:04.0: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
pci 0000:00:06.0: setting latency timer to 64
pci 0000:10:00.0: setting latency timer to 64
pci 0000:11:02.0: setting latency timer to 64
pci 0000:11:04.0: setting latency timer to 64
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
highmem bounce pool size: 64 pages
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 1234
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
pci 0000:1b:0c.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie00: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pcieport-driver 0000:00:04.0: setting latency timer to 64
pcieport-driver 0000:00:04.0: found MSI capability
pci_express 0000:00:04.0:pcie00: allocate port service
pcieport-driver 0000:00:06.0: setting latency timer to 64
pcieport-driver 0000:00:06.0: found MSI capability
pci_express 0000:00:06.0:pcie00: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pcieport-driver 0000:01:00.0: setting latency timer to 64
pcieport-driver 0000:02:01.0: setting latency timer to 64
pcieport-driver 0000:02:01.0: found MSI capability
pcieport-driver 0000:02:02.0: setting latency timer to 64
pcieport-driver 0000:02:02.0: found MSI capability
pcieport-driver 0000:02:03.0: setting latency timer to 64
pcieport-driver 0000:02:03.0: found MSI capability
pcieport-driver 0000:02:04.0: setting latency timer to 64
pcieport-driver 0000:02:04.0: found MSI capability
pcieport-driver 0000:02:05.0: setting latency timer to 64
pcieport-driver 0000:02:05.0: found MSI capability
pcieport-driver 0000:0c:00.0: setting latency timer to 64
pcieport-driver 0000:0d:02.0: setting latency timer to 64
pcieport-driver 0000:0d:02.0: found MSI capability
pcieport-driver 0000:0d:04.0: setting latency timer to 64
pcieport-driver 0000:0d:04.0: found MSI capability
pcieport-driver 0000:10:00.0: setting latency timer to 64
pcieport-driver 0000:11:02.0: setting latency timer to 64
pcieport-driver 0000:11:02.0: found MSI capability
ACPI: Power Button (FF) [PWRF]
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
processor ACPI0007:02: registered as cooling_device2
processor ACPI0007:03: registered as cooling_device3
processor ACPI0007:04: registered as cooling_device4
processor ACPI0007:05: registered as cooling_device5
processor ACPI0007:06: registered as cooling_device6
processor ACPI0007:07: registered as cooling_device7
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
brd: module loaded
loop: module loaded
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.7.9 (July 18, 2008)
bnx2 0000:05:00.0: PCI INT A -> GSI 38 (level, low) -> IRQ 38
eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit
133MHz found at mem dc000000, IRQ 38, node addr 00:1e:c9:d9:84:57
bnx2 0000:07:00.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit
133MHz found at mem da000000, IRQ 37, node addr 00:1e:c9:d9:84:59
bnx2 0000:09:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
eth2: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit
133MHz found at mem d8000000, IRQ 19, node addr 00:1e:c9:d9:84:5b
bnx2 0000:0b:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
eth3: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit
133MHz found at mem d6000000, IRQ 18, node addr 00:1e:c9:d9:84:5d
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing
all legacy ISA IDE ports
Probing IDE interface ide0...
hda: TSSTcorpDVD-ROM TS-L333A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
megasas: 0x1000:0x0060:0x1028:0x1f0c: bus 25:slot 0:func 0
megaraid_sas 0000:19:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
megaraid_sas 0000:19:00.0: setting latency timer to 64
megasas: FW now in Ready state
scsi0 : LSI SAS based MegaRAID driver
scsi 0:0:0:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:2:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:3:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:4:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:5:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:6:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:7:0: Direct-Access     SEAGATE  ST973451SS       SM04 PQ: 0 ANSI: 5
scsi 0:0:32:0: Enclosure         DP       BACKPLANE        1.06 PQ: 0 ANSI: 5
scsi 0:2:0:0: Direct-Access     DELL     PERC 6/i         1.11 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:2:0:0: [sda] 710410240 512-byte hardware sectors (363730 MB)
sd 0:2:0:0: [sda] Write Protect is off
sd 0:2:0:0: [sda] Mode Sense: 1f 00 00 08
sd 0:2:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:2:0:0: [sda] 710410240 512-byte hardware sectors (363730 MB)
sd 0:2:0:0: [sda] Mode Sense: 1f 00 00 08
sd 0:2:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:2:0:0: [sda] 710410240 512-byte hardware sectors (363730 MB)
sd 0:2:0:0: [sda] Write Protect is off
sd 0:2:0:0: [sda] Mode Sense: 1f 00 00 08
sd 0:2:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12
sda13 sda14 sda15 >
sd 0:2:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 0 (errno=-16)
ata_piix 0000:00:1f.2: BAR 2: can't reserve I/O region [0x170-0x177]
ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 1 (errno=-16)
ata_piix 0000:00:1f.2: no available native port
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
ehci_hcd 0000:00:1d.7: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xde0ffc00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
...
