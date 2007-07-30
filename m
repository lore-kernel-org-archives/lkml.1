Return-Path: <linux-kernel-owner+w=401wt.eu-S1765911AbXG3My2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765911AbXG3My2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXG3MyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:54:01 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:41987 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbXG3Mx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:53:57 -0400
X-Greylist: delayed 1772 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 08:53:56 EDT
Date: Mon, 30 Jul 2007 14:24:20 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Adrian Bunk <bunk@stusta.de>
Cc: Alois Nespor <alois.nespor@gmail.com>, Bernhard Kaindl <bk@suse.de>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci=assign-busses
Message-ID: <20070730122420.GA2685@localhost.localdomain>
References: <6c9774880707300129if10dbf4n25c5077f02c940e3@mail.gmail.com> <20070730115331.GO16817@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20070730115331.GO16817@stusta.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Another report of the same kind. Box is an HP/Compaq nx7400.
Before/after use of pci= option dmesgs attached.

-- 
Damien Wyart

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Jul 23 11:41:06 dalpdw2 kernel: Linux version 2.6.23-rc1-23072007dw (root@dalpdw2) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Mon Jul 23 09:21:55 CEST 2007
Jul 23 11:41:06 dalpdw2 kernel: BIOS-provided physical RAM map:
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 0000000000100000 - 000000005f7d0000 (usable)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 000000005f7d0000 - 000000005f7e5600 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 000000005f7e5600 - 000000005f7f8000 (ACPI NVS)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 000000005f7f8000 - 000000005f800000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel:  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Jul 23 11:41:06 dalpdw2 kernel: 631MB HIGHMEM available.
Jul 23 11:41:06 dalpdw2 kernel: 896MB LOWMEM available.
Jul 23 11:41:06 dalpdw2 kernel: Entering add_active_range(0, 0, 391120) 0 entries of 256 used
Jul 23 11:41:06 dalpdw2 kernel: Zone PFN ranges:
Jul 23 11:41:06 dalpdw2 kernel:   DMA             0 ->     4096
Jul 23 11:41:06 dalpdw2 kernel:   Normal       4096 ->   229376
Jul 23 11:41:06 dalpdw2 kernel:   HighMem    229376 ->   391120
Jul 23 11:41:06 dalpdw2 kernel: Movable zone start PFN for each node
Jul 23 11:41:06 dalpdw2 kernel: early_node_map[1] active PFN ranges
Jul 23 11:41:06 dalpdw2 kernel:     0:        0 ->   391120
Jul 23 11:41:06 dalpdw2 kernel: On node 0 totalpages: 391120
Jul 23 11:41:06 dalpdw2 kernel:   DMA zone: 32 pages used for memmap
Jul 23 11:41:06 dalpdw2 kernel:   DMA zone: 0 pages reserved
Jul 23 11:41:06 dalpdw2 kernel:   DMA zone: 4064 pages, LIFO batch:0
Jul 23 11:41:06 dalpdw2 kernel:   Normal zone: 1760 pages used for memmap
Jul 23 11:41:06 dalpdw2 kernel:   Normal zone: 223520 pages, LIFO batch:31
Jul 23 11:41:06 dalpdw2 kernel:   HighMem zone: 1263 pages used for memmap
Jul 23 11:41:06 dalpdw2 kernel:   HighMem zone: 160481 pages, LIFO batch:31
Jul 23 11:41:06 dalpdw2 kernel:   Movable zone: 0 pages used for memmap
Jul 23 11:41:06 dalpdw2 kernel: DMI 2.4 present.
Jul 23 11:41:06 dalpdw2 kernel: ACPI: RSDP 000F7BD0, 0024 (r2 HP    )
Jul 23 11:41:06 dalpdw2 kernel: ACPI: XSDT 5F7E57C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: FACP 5F7E5684, 00F4 (r4 HP     30A2            3 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: DSDT 5F7E5AC0, F9BB (r1 HP       nx7400    10000 MSFT  100000E)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: FACS 5F7F7E80, 0040
Jul 23 11:41:06 dalpdw2 kernel: ACPI: SLIC 5F7E5838, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: HPET 5F7E59B0, 0038 (r1 HP     30A2            1 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: APIC 5F7E59E8, 0068 (r1 HP     30A2            1 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: MCFG 5F7E5A50, 003C (r1 HP     30A2            1 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: TCPA 5F7E5A8C, 0032 (r2 HP     30A2            1 HP          1)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: SSDT 5F7F547B, 0326 (r1 HP       HPQSAT        1 MSFT  100000E)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: SSDT 5F7F5FB4, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: SSDT 5F7F6213, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: SSDT 5F7F62B9, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PM-Timer IO Port: 0x1008
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Local APIC address 0xfee00000
Jul 23 11:41:06 dalpdw2 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jul 23 11:41:06 dalpdw2 kernel: Processor #0 6:15 APIC version 20
Jul 23 11:41:06 dalpdw2 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jul 23 11:41:06 dalpdw2 kernel: Processor #1 6:15 APIC version 20
Jul 23 11:41:06 dalpdw2 kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Jul 23 11:41:06 dalpdw2 kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Jul 23 11:41:06 dalpdw2 kernel: ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Jul 23 11:41:06 dalpdw2 kernel: IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Jul 23 11:41:06 dalpdw2 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: IRQ0 used by override.
Jul 23 11:41:06 dalpdw2 kernel: ACPI: IRQ2 used by override.
Jul 23 11:41:06 dalpdw2 kernel: ACPI: IRQ9 used by override.
Jul 23 11:41:06 dalpdw2 kernel: Enabling APIC mode:  Flat.  Using 1 I/O APICs
Jul 23 11:41:06 dalpdw2 kernel: ACPI: HPET id: 0x8086a201 base: 0xfed00000
Jul 23 11:41:06 dalpdw2 kernel: Using ACPI (MADT) for SMP configuration information
Jul 23 11:41:06 dalpdw2 kernel: Allocating PCI resources starting at 60000000 (gap: 5f800000:9f400000)
Jul 23 11:41:06 dalpdw2 kernel: Built 1 zonelists in Zone order.  Total pages: 388065
Jul 23 11:41:06 dalpdw2 kernel: Kernel command line: root=/dev/sda7 ro vga=0x305 selinux=0 elevator=cfq video=vesafb:mtrr:3 
Jul 23 11:41:06 dalpdw2 kernel: mapped APIC to ffffb000 (fee00000)
Jul 23 11:41:06 dalpdw2 kernel: mapped IOAPIC to ffffa000 (fec00000)
Jul 23 11:41:06 dalpdw2 kernel: Enabling fast FPU save and restore... done.
Jul 23 11:41:06 dalpdw2 kernel: Enabling unmasked SIMD FPU exception support... done.
Jul 23 11:41:06 dalpdw2 kernel: Initializing CPU#0
Jul 23 11:41:06 dalpdw2 kernel: CPU 0 irqstacks, hard=c041d000 soft=c041b000
Jul 23 11:41:06 dalpdw2 kernel: PID hash table entries: 4096 (order: 12, 16384 bytes)
Jul 23 11:41:06 dalpdw2 kernel: Detected 1828.897 MHz processor.
Jul 23 11:41:06 dalpdw2 kernel: Console: colour dummy device 80x25
Jul 23 11:41:06 dalpdw2 kernel: console [tty0] enabled
Jul 23 11:41:06 dalpdw2 kernel: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Jul 23 11:41:06 dalpdw2 kernel: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul 23 11:41:06 dalpdw2 kernel: Memory: 1546808k/1564480k available (2202k kernel code, 16520k reserved, 751k data, 192k init, 646976k highmem)
Jul 23 11:41:06 dalpdw2 kernel: virtual kernel memory layout:
Jul 23 11:41:06 dalpdw2 kernel:     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
Jul 23 11:41:06 dalpdw2 kernel:     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jul 23 11:41:06 dalpdw2 kernel:     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
Jul 23 11:41:06 dalpdw2 kernel:     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
Jul 23 11:41:06 dalpdw2 kernel:       .init : 0xc03e8000 - 0xc0418000   ( 192 kB)
Jul 23 11:41:06 dalpdw2 kernel:       .data : 0xc032699c - 0xc03e28a4   ( 751 kB)
Jul 23 11:41:06 dalpdw2 kernel:       .text : 0xc0100000 - 0xc032699c   (2202 kB)
Jul 23 11:41:06 dalpdw2 kernel: Checking if this processor honours the WP bit even in supervisor mode... Ok.
Jul 23 11:41:06 dalpdw2 kernel: SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Jul 23 11:41:06 dalpdw2 kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jul 23 11:41:06 dalpdw2 kernel: hpet0: 3 64-bit timers, 14318180 Hz
Jul 23 11:41:06 dalpdw2 kernel: Calibrating delay using timer specific routine.. 3660.74 BogoMIPS (lpj=1830370)
Jul 23 11:41:06 dalpdw2 kernel: Mount-cache hash table entries: 512
Jul 23 11:41:06 dalpdw2 kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
Jul 23 11:41:06 dalpdw2 kernel: monitor/mwait feature present.
Jul 23 11:41:06 dalpdw2 kernel: using mwait in idle threads.
Jul 23 11:41:06 dalpdw2 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Jul 23 11:41:06 dalpdw2 kernel: CPU: L2 cache: 2048K
Jul 23 11:41:06 dalpdw2 kernel: CPU: Physical Processor ID: 0
Jul 23 11:41:06 dalpdw2 kernel: CPU: Processor Core ID: 0
Jul 23 11:41:06 dalpdw2 kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Jul 23 11:41:06 dalpdw2 kernel: Intel machine check architecture supported.
Jul 23 11:41:06 dalpdw2 kernel: Intel machine check reporting enabled on CPU#0.
Jul 23 11:41:06 dalpdw2 kernel: Compat vDSO mapped to ffffe000.
Jul 23 11:41:06 dalpdw2 kernel: Checking 'hlt' instruction... OK.
Jul 23 11:41:06 dalpdw2 kernel: Freeing SMP alternatives: 13k freed
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Core revision 20070126
Jul 23 11:41:06 dalpdw2 kernel: CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Jul 23 11:41:06 dalpdw2 kernel: Booting processor 1/1 eip 2000
Jul 23 11:41:06 dalpdw2 kernel: CPU 1 irqstacks, hard=c041e000 soft=c041c000
Jul 23 11:41:06 dalpdw2 kernel: Initializing CPU#1
Jul 23 11:41:06 dalpdw2 kernel: Calibrating delay using timer specific routine.. 3657.50 BogoMIPS (lpj=1828754)
Jul 23 11:41:06 dalpdw2 kernel: CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
Jul 23 11:41:06 dalpdw2 kernel: monitor/mwait feature present.
Jul 23 11:41:06 dalpdw2 kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Jul 23 11:41:06 dalpdw2 kernel: CPU: L2 cache: 2048K
Jul 23 11:41:06 dalpdw2 kernel: CPU: Physical Processor ID: 0
Jul 23 11:41:06 dalpdw2 kernel: CPU: Processor Core ID: 1
Jul 23 11:41:06 dalpdw2 kernel: CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Jul 23 11:41:06 dalpdw2 kernel: Intel machine check architecture supported.
Jul 23 11:41:06 dalpdw2 kernel: Intel machine check reporting enabled on CPU#1.
Jul 23 11:41:06 dalpdw2 kernel: CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Jul 23 11:41:06 dalpdw2 kernel: Total of 2 processors activated (7318.24 BogoMIPS).
Jul 23 11:41:06 dalpdw2 kernel: ENABLING IO-APIC IRQs
Jul 23 11:41:06 dalpdw2 kernel: ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Jul 23 11:41:06 dalpdw2 kernel: checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Jul 23 11:41:06 dalpdw2 kernel: Brought up 2 CPUs
Jul 23 11:41:06 dalpdw2 kernel: HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
Jul 23 11:41:06 dalpdw2 kernel: NET: Registered protocol family 16
Jul 23 11:41:06 dalpdw2 kernel: ACPI: bus type pci registered
Jul 23 11:41:06 dalpdw2 kernel: PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
Jul 23 11:41:06 dalpdw2 kernel: PCI: Not using MMCONFIG.
Jul 23 11:41:06 dalpdw2 kernel: PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
Jul 23 11:41:06 dalpdw2 kernel: PCI: Using configuration type 1
Jul 23 11:41:06 dalpdw2 kernel: Setting up standard PCI resources
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Interpreter enabled
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Using IOAPIC for interrupt routing
Jul 23 11:41:06 dalpdw2 kernel: ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62<6>ACPI: PCI Root Bridge [C002] (0000:00)
Jul 23 11:41:06 dalpdw2 kernel: PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Jul 23 11:41:06 dalpdw2 kernel: PCI quirk: region 1100-113f claimed by ICH6 GPIO
Jul 23 11:41:06 dalpdw2 kernel: PCI: Transparent bridge - 0000:00:1e.0
Jul 23 11:41:06 dalpdw2 kernel: PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03) (try 'pci=assign-busses')
Jul 23 11:41:06 dalpdw2 kernel: Please report the result to <bk@suse.de> to fix this permanently
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C002._PRT]
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C002.C098._PRT]
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C002.C104._PRT]
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C002.C114._PRT]
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.C002.C11A._PRT]
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C110] (IRQs *10 11)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C111] (IRQs *10 11)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C112] (IRQs 10 *11)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C113] (IRQs *10 11)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C12D] (IRQs 10 11) *0, disabled.
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt Link [C12E] (IRQs 10 11) *0, disabled.
Jul 23 11:41:06 dalpdw2 kernel: ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C200] (on)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C21D] (on)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C226] (off)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C320] (off)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C321] (off)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C322] (off)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: Power Resource [C323] (off)
Jul 23 11:41:06 dalpdw2 kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 23 11:41:06 dalpdw2 kernel: pnp: PnP ACPI init
Jul 23 11:41:06 dalpdw2 kernel: ACPI: bus type pnp registered
Jul 23 11:41:06 dalpdw2 kernel: pnp: PnP ACPI: found 13 devices
Jul 23 11:41:06 dalpdw2 kernel: ACPI: ACPI bus type pnp unregistered
Jul 23 11:41:06 dalpdw2 kernel: SCSI subsystem initialized
Jul 23 11:41:06 dalpdw2 kernel: libata version 2.21 loaded.
Jul 23 11:41:06 dalpdw2 kernel: usbcore: registered new interface driver usbfs
Jul 23 11:41:06 dalpdw2 kernel: usbcore: registered new interface driver hub
Jul 23 11:41:06 dalpdw2 kernel: usbcore: registered new device driver usb
Jul 23 11:41:06 dalpdw2 kernel: PCI: Using ACPI for IRQ routing
Jul 23 11:41:06 dalpdw2 kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Jul 23 11:41:06 dalpdw2 kernel: Time: tsc clocksource has been installed.
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:00: iomem range 0x100000-0x5f7fffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: ioport range 0x4d0-0x4d1 has been reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: ioport range 0x1000-0x107f has been reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: ioport range 0x1100-0x113f has been reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: ioport range 0x1200-0x121f has been reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: iomem range 0xf8000000-0xfbffffff has been reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: iomem range 0xfec00000-0xfec000ff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: iomem range 0xfed20000-0xfed3ffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0b: iomem range 0xfed45000-0xfed8ffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0c: iomem range 0xfeda0000-0xfedbffff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
Jul 23 11:41:06 dalpdw2 kernel: PCI: Bridge: 0000:00:1c.0
Jul 23 11:41:06 dalpdw2 kernel:   IO window: disabled.
Jul 23 11:41:06 dalpdw2 kernel:   MEM window: disabled.
Jul 23 11:41:06 dalpdw2 kernel:   PREFETCH window: disabled.
Jul 23 11:41:06 dalpdw2 kernel: PCI: Bridge: 0000:00:1c.1
Jul 23 11:41:06 dalpdw2 kernel:   IO window: disabled.
Jul 23 11:41:06 dalpdw2 kernel:   MEM window: f4000000-f40fffff
Jul 23 11:41:06 dalpdw2 kernel:   PREFETCH window: disabled.
Jul 23 11:41:06 dalpdw2 kernel: PCI: Bridge: 0000:00:1c.3
Jul 23 11:41:06 dalpdw2 kernel:   IO window: 2000-3fff
Jul 23 11:41:06 dalpdw2 kernel:   MEM window: f0000000-f3ffffff
Jul 23 11:41:06 dalpdw2 kernel:   PREFETCH window: disabled.
Jul 23 11:41:06 dalpdw2 kernel: PCI: Bus 3, cardbus bridge: 0000:02:06.0
Jul 23 11:41:06 dalpdw2 kernel:   IO window: 00005000-000050ff
Jul 23 11:41:06 dalpdw2 kernel:   IO window: 00005400-000054ff
Jul 23 11:41:06 dalpdw2 kernel:   PREFETCH window: 60000000-63ffffff
Jul 23 11:41:06 dalpdw2 kernel:   MEM window: 64000000-67ffffff
Jul 23 11:41:06 dalpdw2 kernel: PCI: Bridge: 0000:00:1e.0
Jul 23 11:41:06 dalpdw2 kernel:   IO window: 5000-5fff
Jul 23 11:41:06 dalpdw2 kernel:   MEM window: f4100000-f43fffff
Jul 23 11:41:06 dalpdw2 kernel:   PREFETCH window: 60000000-63ffffff
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1c.0 to 64
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1c.1 to 64
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1c.3 to 64
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 19
Jul 23 11:41:06 dalpdw2 kernel: NET: Registered protocol family 2
Jul 23 11:41:06 dalpdw2 kernel: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul 23 11:41:06 dalpdw2 kernel: TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
Jul 23 11:41:06 dalpdw2 kernel: TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Jul 23 11:41:06 dalpdw2 kernel: TCP: Hash tables configured (established 131072 bind 65536)
Jul 23 11:41:06 dalpdw2 kernel: TCP reno registered
Jul 23 11:41:06 dalpdw2 kernel: Machine check exception polling timer started.
Jul 23 11:41:06 dalpdw2 kernel: highmem bounce pool size: 64 pages
Jul 23 11:41:06 dalpdw2 kernel: SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
Jul 23 11:41:06 dalpdw2 kernel: SGI XFS Quota Management subsystem
Jul 23 11:41:06 dalpdw2 kernel: io scheduler noop registered
Jul 23 11:41:06 dalpdw2 kernel: io scheduler cfq registered (default)
Jul 23 11:41:06 dalpdw2 kernel: Boot video device is 0000:00:02.0
Jul 23 11:41:06 dalpdw2 kernel: vesafb: framebuffer at 0xe0000000, mapped to 0xf8880000, using 1536k, total 7872k
Jul 23 11:41:06 dalpdw2 kernel: vesafb: mode is 1024x768x8, linelength=1024, pages=9
Jul 23 11:41:06 dalpdw2 kernel: vesafb: scrolling: redraw
Jul 23 11:41:06 dalpdw2 kernel: vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Jul 23 11:41:06 dalpdw2 kernel: Console: switching to colour frame buffer device 128x48
Jul 23 11:41:06 dalpdw2 kernel: fb0: VESA VGA frame buffer device
Jul 23 11:41:06 dalpdw2 kernel: hpet_resources: 0xfed00000 is busy
Jul 23 11:41:06 dalpdw2 kernel: Linux agpgart interface v0.102
Jul 23 11:41:06 dalpdw2 kernel: agpgart: Detected an Intel 945GM Chipset.
Jul 23 11:41:06 dalpdw2 kernel: agpgart: Detected 7932K stolen memory.
Jul 23 11:41:06 dalpdw2 kernel: agpgart: AGP aperture is 256M @ 0xe0000000
Jul 23 11:41:06 dalpdw2 kernel: [drm] Initialized drm 1.1.0 20060810
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 23 11:41:06 dalpdw2 kernel: [drm] Initialized i915 1.6.0 20060119 on minor 0
Jul 23 11:41:06 dalpdw2 kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Jul 23 11:41:06 dalpdw2 kernel: loop: module loaded
Jul 23 11:41:06 dalpdw2 kernel: b44.c:v1.01 (Jun 16, 2006)
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:02:0e.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 23 11:41:06 dalpdw2 kernel: eth0: Broadcom 4400 10/100BaseT Ethernet 00:17:08:43:b3:8e
Jul 23 11:41:06 dalpdw2 kernel: ahci 0000:00:1f.2: version 2.3
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
Jul 23 11:41:06 dalpdw2 kernel: Switched to high resolution mode on CPU 1
Jul 23 11:41:06 dalpdw2 kernel: Switched to high resolution mode on CPU 0
Jul 23 11:41:06 dalpdw2 kernel: ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
Jul 23 11:41:06 dalpdw2 kernel: ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
Jul 23 11:41:06 dalpdw2 kernel: scsi0 : ahci
Jul 23 11:41:06 dalpdw2 kernel: scsi1 : ahci
Jul 23 11:41:06 dalpdw2 kernel: scsi2 : ahci
Jul 23 11:41:06 dalpdw2 kernel: scsi3 : ahci
Jul 23 11:41:06 dalpdw2 kernel: ata1: SATA max UDMA/133 cmd 0xf8840100 ctl 0x00000000 bmdma 0x00000000 irq 223
Jul 23 11:41:06 dalpdw2 kernel: ata2: SATA max UDMA/133 cmd 0xf8840180 ctl 0x00000000 bmdma 0x00000000 irq 223
Jul 23 11:41:06 dalpdw2 kernel: ata3: SATA max UDMA/133 cmd 0xf8840200 ctl 0x00000000 bmdma 0x00000000 irq 223
Jul 23 11:41:06 dalpdw2 kernel: ata4: SATA max UDMA/133 cmd 0xf8840280 ctl 0x00000000 bmdma 0x00000000 irq 223
Jul 23 11:41:06 dalpdw2 kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jul 23 11:41:06 dalpdw2 kernel: ata1.00: ATA-7: FUJITSU MHV2080BH PL, 892C, max UDMA/100
Jul 23 11:41:06 dalpdw2 kernel: ata1.00: 156301488 sectors, multi 16: LBA48 
Jul 23 11:41:06 dalpdw2 kernel: ata1.00: configured for UDMA/100
Jul 23 11:41:06 dalpdw2 kernel: ata2: SATA link down (SStatus 0 SControl 0)
Jul 23 11:41:06 dalpdw2 kernel: ata3: SATA link down (SStatus 0 SControl 0)
Jul 23 11:41:06 dalpdw2 kernel: ata4: SATA link down (SStatus 0 SControl 0)
Jul 23 11:41:06 dalpdw2 kernel: scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Write Protect is off
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Write Protect is off
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 23 11:41:06 dalpdw2 kernel:  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 >
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Jul 23 11:41:06 dalpdw2 kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul 23 11:41:06 dalpdw2 kernel: USB Universal Host Controller Interface driver v3.0
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004020
Jul 23 11:41:06 dalpdw2 kernel: usb usb1: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: hub 1-0:1.0: USB hub found
Jul 23 11:41:06 dalpdw2 kernel: hub 1-0:1.0: 2 ports detected
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.1: irq 17, io base 0x00004040
Jul 23 11:41:06 dalpdw2 kernel: usb usb2: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: hub 2-0:1.0: USB hub found
Jul 23 11:41:06 dalpdw2 kernel: hub 2-0:1.0: 2 ports detected
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.2: irq 19, io base 0x00004060
Jul 23 11:41:06 dalpdw2 kernel: usb usb3: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: hub 3-0:1.0: USB hub found
Jul 23 11:41:06 dalpdw2 kernel: hub 3-0:1.0: 2 ports detected
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Jul 23 11:41:06 dalpdw2 kernel: uhci_hcd 0000:00:1d.3: irq 18, io base 0x00004080
Jul 23 11:41:06 dalpdw2 kernel: usb usb4: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: hub 4-0:1.0: USB hub found
Jul 23 11:41:06 dalpdw2 kernel: hub 4-0:1.0: 2 ports detected
Jul 23 11:41:06 dalpdw2 kernel: PNP: PS/2 Controller [PNP0303:C21A,PNP0f13:C21B] at 0x60,0x64 irq 1,12
Jul 23 11:41:06 dalpdw2 kernel: i8042.c: Detected active multiplexing controller, rev 1.1.
Jul 23 11:41:06 dalpdw2 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 23 11:41:06 dalpdw2 kernel: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Jul 23 11:41:06 dalpdw2 kernel: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Jul 23 11:41:06 dalpdw2 kernel: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Jul 23 11:41:06 dalpdw2 kernel: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Jul 23 11:41:06 dalpdw2 kernel: mice: PS/2 mouse device common for all mice
Jul 23 11:41:06 dalpdw2 kernel: input: AT Translated Set 2 keyboard as /class/input/input0
Jul 23 11:41:06 dalpdw2 kernel: TCP cubic registered
Jul 23 11:41:06 dalpdw2 kernel: NET: Registered protocol family 1
Jul 23 11:41:06 dalpdw2 kernel: NET: Registered protocol family 17
Jul 23 11:41:06 dalpdw2 kernel: Using IPI Shortcut mode
Jul 23 11:41:06 dalpdw2 kernel: usb 3-2: new low speed USB device using uhci_hcd and address 2
Jul 23 11:41:06 dalpdw2 kernel: usb 3-2: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
Jul 23 11:41:06 dalpdw2 kernel: serio: Synaptics pass-through port at isa0060/serio4/input0
Jul 23 11:41:06 dalpdw2 kernel: input: SynPS/2 Synaptics TouchPad as /class/input/input1
Jul 23 11:41:06 dalpdw2 kernel: kjournald starting.  Commit interval 5 seconds
Jul 23 11:41:06 dalpdw2 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Jul 23 11:41:06 dalpdw2 kernel: VFS: Mounted root (ext3 filesystem) readonly.
Jul 23 11:41:06 dalpdw2 kernel: Freeing unused kernel memory: 192k freed
Jul 23 11:41:06 dalpdw2 kernel: ata_piix 0000:00:1f.1: version 2.11
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1f.1 to 64
Jul 23 11:41:06 dalpdw2 kernel: scsi4 : ata_piix
Jul 23 11:41:06 dalpdw2 kernel: scsi5 : ata_piix
Jul 23 11:41:06 dalpdw2 kernel: ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140a0 irq 14
Jul 23 11:41:06 dalpdw2 kernel: ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140a8 irq 15
Jul 23 11:41:06 dalpdw2 kernel: ata5.00: ATAPI: TSSTcorpCD/DVDW TS-L632D, HH15, max MWDMA2
Jul 23 11:41:06 dalpdw2 kernel: ata5.00: configured for MWDMA2
Jul 23 11:41:06 dalpdw2 kernel: ata6: port disabled. ignoring.
Jul 23 11:41:06 dalpdw2 kernel: scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D HH15 PQ: 0 ANSI: 5
Jul 23 11:41:06 dalpdw2 kernel: scsi 4:0:0:0: Attached scsi generic sg1 type 5
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
Jul 23 11:41:06 dalpdw2 kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jul 23 11:41:06 dalpdw2 kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Jul 23 11:41:06 dalpdw2 kernel: ehci_hcd 0000:00:1d.7: debug port 1
Jul 23 11:41:06 dalpdw2 kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Jul 23 11:41:06 dalpdw2 kernel: ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf4584000
Jul 23 11:41:06 dalpdw2 kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jul 23 11:41:06 dalpdw2 kernel: usb usb5: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: hub 5-0:1.0: USB hub found
Jul 23 11:41:06 dalpdw2 kernel: hub 5-0:1.0: 8 ports detected
Jul 23 11:41:06 dalpdw2 kernel: input: PC Speaker as /class/input/input2
Jul 23 11:41:06 dalpdw2 kernel: Real Time Clock Driver v1.12ac
Jul 23 11:41:06 dalpdw2 kernel: HID device not claimed by input or hiddev
Jul 23 11:41:06 dalpdw2 kernel: Yenta: CardBus bridge found at 0000:02:06.0 [103c:30a2]
Jul 23 11:41:06 dalpdw2 kernel: Yenta: Enabling burst memory read transactions
Jul 23 11:41:06 dalpdw2 kernel: Yenta: Using INTVAL to route CSC interrupts to PCI
Jul 23 11:41:06 dalpdw2 kernel: Yenta: Routing CardBus interrupts to PCI
Jul 23 11:41:06 dalpdw2 kernel: Yenta TI: socket 0000:02:06.0, mfunc 0x01011b22, devctl 0x64
Jul 23 11:41:06 dalpdw2 kernel: sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Jul 23 11:41:06 dalpdw2 kernel: Uniform CD-ROM driver Revision: 3.20
Jul 23 11:41:06 dalpdw2 kernel: sr 4:0:0:0: Attached scsi CD-ROM sr0
Jul 23 11:41:06 dalpdw2 kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 23 11:41:06 dalpdw2 kernel: PCI: Setting latency timer of device 0000:00:1b.0 to 64
Jul 23 11:41:06 dalpdw2 kernel: usbcore: registered new interface driver usbhid
Jul 23 11:41:06 dalpdw2 kernel: usb 3-2: USB disconnect, address 2
Jul 23 11:41:06 dalpdw2 kernel: drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Jul 23 11:41:06 dalpdw2 kernel: si3054: cannot initialize. EXT MID = 0000
Jul 23 11:41:06 dalpdw2 kernel: Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
Jul 23 11:41:06 dalpdw2 kernel: Socket status: 30000006
Jul 23 11:41:06 dalpdw2 kernel: Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
Jul 23 11:41:06 dalpdw2 kernel: pcmcia: parent PCI bridge I/O window: 0x5000 - 0x5fff
Jul 23 11:41:06 dalpdw2 kernel: pcmcia: parent PCI bridge Memory window: 0xf4100000 - 0xf43fffff
Jul 23 11:41:06 dalpdw2 kernel: pcmcia: parent PCI bridge Memory window: 0x60000000 - 0x63ffffff
Jul 23 11:41:06 dalpdw2 kernel: usb 3-2: new low speed USB device using uhci_hcd and address 3
Jul 23 11:41:06 dalpdw2 kernel: usb 3-2: configuration #1 chosen from 1 choice
Jul 23 11:41:06 dalpdw2 kernel: input: Logitech Optical USB Mouse as /class/input/input3
Jul 23 11:41:06 dalpdw2 kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.2-2
Jul 23 11:41:06 dalpdw2 kernel: Adding 2623280k swap on /dev/sda12.  Priority:-1 extents:1 across:2623280k
Jul 23 11:41:06 dalpdw2 kernel: EXT3 FS on sda7, internal journal
Jul 23 11:41:06 dalpdw2 kernel: XFS mounting filesystem sda10
Jul 23 11:41:06 dalpdw2 kernel: Ending clean XFS mount for filesystem: sda10
Jul 23 11:41:06 dalpdw2 kernel: XFS mounting filesystem sda8
Jul 23 11:41:06 dalpdw2 kernel: Ending clean XFS mount for filesystem: sda8
Jul 23 11:41:06 dalpdw2 kernel: XFS mounting filesystem sda9
Jul 23 11:41:06 dalpdw2 kernel: Ending clean XFS mount for filesystem: sda9
Jul 23 11:41:06 dalpdw2 kernel: XFS mounting filesystem sda11
Jul 23 11:41:06 dalpdw2 kernel: Ending clean XFS mount for filesystem: sda11
Jul 23 11:41:06 dalpdw2 kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
Jul 23 11:41:06 dalpdw2 kernel: b44: eth0: Flow control is off for TX and off for RX.

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2"

Linux version 2.6.23-rc1-git4-27072007dw (root@dalpdw2) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 SMP Fri Jul 27 09:51:07 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005f7d0000 (usable)
 BIOS-e820: 000000005f7d0000 - 000000005f7e5600 (reserved)
 BIOS-e820: 000000005f7e5600 - 000000005f7f8000 (ACPI NVS)
 BIOS-e820: 000000005f7f8000 - 000000005f800000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
631MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 391120) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   391120
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   391120
On node 0 totalpages: 391120
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 1263 pages used for memmap
  HighMem zone: 160481 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.4 present.
ACPI: RSDP 000F7BD0, 0024 (r2 HP    )
ACPI: XSDT 5F7E57C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 5F7E5684, 00F4 (r4 HP     30A2            3 HP          1)
ACPI: DSDT 5F7E5AC0, F9BB (r1 HP       nx7400    10000 MSFT  100000E)
ACPI: FACS 5F7F7E80, 0040
ACPI: SLIC 5F7E5838, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 5F7E59B0, 0038 (r1 HP     30A2            1 HP          1)
ACPI: APIC 5F7E59E8, 0068 (r1 HP     30A2            1 HP          1)
ACPI: MCFG 5F7E5A50, 003C (r1 HP     30A2            1 HP          1)
ACPI: TCPA 5F7E5A8C, 0032 (r2 HP     30A2            1 HP          1)
ACPI: SSDT 5F7F547B, 0326 (r1 HP       HPQSAT        1 MSFT  100000E)
ACPI: SSDT 5F7F5FB4, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT 5F7F6213, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT 5F7F62B9, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 60000000 (gap: 5f800000:9f400000)
Built 1 zonelists in Zone order.  Total pages: 388065
Kernel command line: root=/dev/sda7 ro vga=0x305 selinux=0 elevator=cfq video=vesafb:mtrr:3 pci=assign-busses 
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0422000 soft=c0420000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.910 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1546784k/1564480k available (2215k kernel code, 16544k reserved, 759k data, 192k init, 646976k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03ed000 - 0xc041d000   ( 192 kB)
      .data : 0xc0329c5c - 0xc03e78a4   ( 759 kB)
      .text : 0xc0100000 - 0xc0329c5c   (2215 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3660.76 BogoMIPS (lpj=1830383)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 13k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c0423000 soft=c0421000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.51 BogoMIPS (lpj=1828756)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
Total of 2 processors activated (7318.27 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62<6>ACPI: PCI Root Bridge [C002] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1100-113f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.C002._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C098._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C104._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C114._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C11A._PRT]
ACPI: PCI Interrupt Link [C110] (IRQs *10 11)
ACPI: PCI Interrupt Link [C111] (IRQs *10 11)
ACPI: PCI Interrupt Link [C112] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C113] (IRQs *10 11)
ACPI: PCI Interrupt Link [C12C] (IRQs *10 11)
ACPI: PCI Interrupt Link [C12D] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C12E] (IRQs 10 11) *0, disabled.
ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C200] (on)
ACPI: Power Resource [C21D] (on)
ACPI: Power Resource [C226] (off)
ACPI: Power Resource [C320] (off)
ACPI: Power Resource [C321] (off)
ACPI: Power Resource [C322] (off)
ACPI: Power Resource [C323] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x5f7fffff could not be reserved
pnp: 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0b: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0b: ioport range 0x1000-0x107f has been reserved
pnp: 00:0b: ioport range 0x1100-0x113f has been reserved
pnp: 00:0b: ioport range 0x1200-0x121f has been reserved
pnp: 00:0b: iomem range 0xf8000000-0xfbffffff has been reserved
pnp: 00:0b: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:0b: iomem range 0xfed20000-0xfed3ffff could not be reserved
pnp: 00:0b: iomem range 0xfed45000-0xfed8ffff could not be reserved
pnp: 00:0c: iomem range 0xfeda0000-0xfedbffff could not be reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: f4000000-f40fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 2000-3fff
  MEM window: f0000000-f3ffffff
  PREFETCH window: disabled.
PCI: Bus 5, cardbus bridge: 0000:04:06.0
  IO window: 00005000-000050ff
  IO window: 00005400-000054ff
  PREFETCH window: 60000000-63ffffff
  MEM window: 64000000-67ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 5000-5fff
  MEM window: f4100000-f43fffff
  PREFETCH window: 60000000-63ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:04:06.0[A] -> GSI 18 (level, low) -> IRQ 19
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
vesafb: framebuffer at 0xe0000000, mapped to 0xf8880000, using 1536k, total 7872k
vesafb: mode is 1024x768x8, linelength=1024, pages=9
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
loop: module loaded
b44.c:v1.01 (Jun 16, 2006)
ACPI: PCI Interrupt 0000:04:0e.0[A] -> GSI 16 (level, low) -> IRQ 16
eth0: Broadcom 4400 10/100BaseT Ethernet 00:17:08:43:b3:8e
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8840100 ctl 0x00000000 bmdma 0x00000000 irq 223
ata2: SATA max UDMA/133 cmd 0xf8840180 ctl 0x00000000 bmdma 0x00000000 irq 223
ata3: SATA max UDMA/133 cmd 0xf8840200 ctl 0x00000000 bmdma 0x00000000 irq 223
ata4: SATA max UDMA/133 cmd 0xf8840280 ctl 0x00000000 bmdma 0x00000000 irq 223
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHV2080BH PL, 892C, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHV2080B 892C PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004020
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00004040
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 19, io base 0x00004060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 18, io base 0x00004080
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:C21A,PNP0f13:C21B] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
usb 3-2: new low speed USB device using uhci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
input: SynPS/2 Synaptics TouchPad as /class/input/input1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 192k freed
ACPI: SSDT 5F7F5869, 01FB (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT 5F7F5AE9, 04CB (r1 HP      Cpu0Cst     3001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [C243]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [C23C]
ACPI: SSDT 5F7F57A1, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT 5F7F5A64, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: AC Adapter [C1BC] (on-line)
Marking TSC unstable due to: possible TSC halt in C2.
Time: hpet clocksource has been installed.
ACPI: Battery Slot [C1BE] (battery present)
ACPI: Battery Slot [C1BD] (battery absent)
ata_piix 0000:00:1f.1: version 2.11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000140a0 irq 14
ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000140a8 irq 15
ata5.00: ATAPI: TSSTcorpCD/DVDW TS-L632D, HH15, max MWDMA2
input: PC Speaker as /class/input/input5
ata5.00: configured for MWDMA2
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-L632D HH15 PQ: 0 ANSI: 5
scsi 4:0:0:0: Attached scsi generic sg1 type 5
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf4584000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
Real Time Clock Driver v1.12ac
ACPI: Thermal Zone [TZ0] (51 C)
ACPI: Thermal Zone [TZ1] (51 C)
ACPI: Thermal Zone [TZ2] (45 C)
Yenta: CardBus bridge found at 0000:04:06.0 [103c:30a2]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:04:06.0, mfunc 0x01011b22, devctl 0x64
ACPI: Thermal Zone [TZ3] (26 C)
ACPI: Thermal Zone [TZ4] (23 C)
HID device not claimed by input or hiddev
ACPI: Transitioning device [C324] to D3
ACPI: Transitioning device [C324] to D3
ACPI: Fan [C324] (off)
ACPI: Transitioning device [C325] to D3
ACPI: Transitioning device [C325] to D3
ACPI: Fan [C325] (off)
ACPI: Transitioning device [C326] to D3
ACPI: Transitioning device [C326] to D3
ACPI: Fan [C326] (off)
ACPI: Fan [C327] (on)
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
usb 3-2: USB disconnect, address 2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
si3054: cannot initialize. EXT MID = 0000
Yenta: ISA IRQ mask 0x0cf8, PCI irq 19
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x5000 - 0x5fff
pcmcia: parent PCI bridge Memory window: 0xf4100000 - 0xf43fffff
pcmcia: parent PCI bridge Memory window: 0x60000000 - 0x63ffffff
usb 3-2: new low speed USB device using uhci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
input: Logitech Optical USB Mouse as /class/input/input6
input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.2-2
Adding 2623280k swap on /dev/sda12.  Priority:-1 extents:1 across:2623280k
EXT3 FS on sda7, internal journal
XFS mounting filesystem sda10
Ending clean XFS mount for filesystem: sda10
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
XFS mounting filesystem sda9
Ending clean XFS mount for filesystem: sda9
XFS mounting filesystem sda11
Ending clean XFS mount for filesystem: sda11
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.

--wRRV7LY7NUeQGEoC--
