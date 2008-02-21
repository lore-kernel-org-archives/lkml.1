Return-Path: <linux-kernel-owner+w=401wt.eu-S1764673AbYBUPnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764673AbYBUPnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYBUPnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:43:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:42685 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbYBUPnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=qNjUikrT+2Jb2ZAeosHa61ka8P8LxQKV343zwA1duaZo6cVxTqpOWjEqQn9FNkJQIFTzsrUE6EuLJ09S3hFQahE2vx/SeBSHxP5Gj+G5CQ1mnr0ImYB282HA0W2Njw5cL2D6yaGW3Dkd74tF6FpUl0zahv3ya/9tKjU75aCaWW0=
Date: Thu, 21 Feb 2008 16:41:05 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: BUG?: "Cannot map mmconfig aperture"
Message-Id: <20080221164105.145d0cbb.diegocg@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0802210853060.7583@apollo.tec.linutronix.de>
References: <20080220223156.578e0a5d.diegocg@gmail.com>
	<alpine.LFD.1.00.0802210853060.7583@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 21 Feb 2008 08:53:39 +0100 (CET), Thomas Gleixner <tglx@linutronix.de> escribió:

> Hmm, that's confusing. Can you please provide a complete boot log ?
> 
> Thanks,

Sure

[    0.000000] Linux version 2.6.25-rc2-00342-g5d9c4a7 (diego@diego-desktop) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #17 SMP PREEMPT Wed Feb 20 19:54:40 CET 2008
[    0.000000] Command line: root=/dev/sda2 ro quiet splash locale=es_ES
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f790000 (usable)
[    0.000000]  BIOS-e820: 000000003f790000 - 000000003f79e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f79e000 - 000000003f7e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f7e0000 - 000000003f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 259984) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FB0D0, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3F790100, 004C (r1 A_M_I_ OEMXSDT   6000706 MSFT       97)
[    0.000000] ACPI: FACP 3F790290, 00F4 (r3 A_M_I_ OEMFACP   6000706 MSFT       97)
[    0.000000] ACPI: DSDT 3F790590, 5870 (r1  A0356 A0356034       34 INTL 20060113)
[    0.000000] ACPI: FACS 3F79E000, 0040
[    0.000000] ACPI: APIC 3F790390, 0080 (r1 A_M_I_ OEMAPIC   6000706 MSFT       97)
[    0.000000] ACPI: OEMB 3F79E040, 006B (r1 A_M_I_ AMI_OEM   6000706 MSFT       97)
[    0.000000] ACPI: HPET 3F795E00, 0038 (r1 A_M_I_ OEMHPET   6000706 MSFT       97)
[    0.000000] ACPI: MCFG 3F795E40, 003C (r1 A_M_I_ OEMMCFG   6000706 MSFT       97)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 259984) 1 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-7d0c57] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-afff] PGTABLE
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   259984
[    0.000000] On node 0 totalpages: 259887
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1497 pages reserved
[    0.000000]   DMA zone: 2446 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3498 pages used for memmap
[    0.000000]   DMA32 zone: 252390 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f800000:c0780000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 34692 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 254836
[    0.000000] Kernel command line: root=/dev/sda2 ro quiet splash locale=es_ES
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] time.c: Detected 1866.664 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000999] Checking aperture...
[    0.000999] Memory: 1017360k/1039936k available (2771k kernel code, 22020k reserved, 2163k data, 252k init)
[    0.000999] CPA: page pool initialized 16 of 16 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.000999] hpet clockevent registered
[    0.059993] Calibrating delay using timer specific routine.. 3735.73 BogoMIPS (lpj=1867866)
[    0.060027] Mount-cache hash table entries: 256
[    0.060193] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.060195] CPU: L2 cache: 4096K
[    0.060198] CPU: Physical Processor ID: 0
[    0.060199] CPU: Processor Core ID: 0
[    0.060202] using mwait in idle threads.
[    0.060994] ACPI: Core revision 20070126
[    0.081810] Using local APIC timer interrupts.
[    0.081995] APIC timer calibration result 16666639
[    0.081997] Detected 16.666 MHz APIC timer.
[    0.082115] Booting processor 1/2 APIC 0x1
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3733.25 BogoMIPS (lpj=1866625)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Intel(R) Core(TM)2 CPU          6320  @ 1.86GHz stepping 06
[    0.153629] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.153996] Brought up 2 CPUs
[    0.154039] CPU0 attaching sched-domain:
[    0.154041]  domain 0: span 3
[    0.154043]   groups: 1 2
[    0.154047] CPU1 attaching sched-domain:
[    0.154049]  domain 0: span 3
[    0.154050]   groups: 2 1
[    0.155023] net_namespace: 880 bytes
[    0.155027] Booting paravirtualized kernel on bare hardware
[    0.155208] NET: Registered protocol family 16
[    0.155374] No dock devices found.
[    0.155477] ACPI: bus type pci registered
[    0.155569] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
[    0.161145] PCI: Cannot map mmconfig aperture for segment 0
[    0.161177] PCI: Using configuration type 1
[    0.165999] ACPI: EC: Look up EC in DSDT
[    0.172436] ACPI: Interpreter enabled
[    0.172439] ACPI: (supports S0 S1 S3 S4 S5)
[    0.172457] ACPI: Using IOAPIC for interrupt routing
[    0.180622] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.181125] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.181129] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.181582] PCI: Transparent bridge - 0000:00:1e.0
[    0.181609] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.181787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.181915] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.182016] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.184864] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.184999] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.185128] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 *6 7 10 11 12 14 15)
[    0.185256] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.185383] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.185510] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.185637] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.185764] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.185953] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  AB, should be A5 [20070126]
[    0.185981] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.186017] pnp: PnP ACPI init
[    0.186025] ACPI: bus type pnp registered
[    0.190360] pnp: PnP ACPI: found 16 devices
[    0.190362] ACPI: ACPI bus type pnp unregistered
[    0.190557] SCSI subsystem initialized
[    0.190627] libata version 3.00 loaded.
[    0.190760] usbcore: registered new interface driver usbfs
[    0.190802] usbcore: registered new interface driver hub
[    0.190858] usbcore: registered new device driver usb
[    0.191019] PCI: Using ACPI for IRQ routing
[    0.191022] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.197988] PCI-GART: No AMD northbridge found.
[    0.198969] Time: tsc clocksource has been installed.
[    0.209986] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.209995] system 00:07: ioport range 0x290-0x297 has been reserved
[    0.210002] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.210005] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.210008] system 00:08: ioport range 0x400-0x41f has been reserved
[    0.210011] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.210014] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.210017] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.210021] system 00:08: iomem range 0xffb00000-0xffbfffff has been reserved
[    0.210024] system 00:08: iomem range 0xfff00000-0xfffffffe could not be reserved
[    0.210031] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.210035] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.210042] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.210048] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    0.210055] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.210058] system 00:0f: iomem range 0xc0000-0xdffff has been reserved
[    0.210061] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    0.210065] system 00:0f: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.210068] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.210739] PCI: Bridge: 0000:00:1c.0
[    0.210742]   IO window: e000-efff
[    0.210747]   MEM window: disabled.
[    0.210750]   PREFETCH window: disabled.
[    0.210755] PCI: Bridge: 0000:00:1c.1
[    0.210757]   IO window: d000-dfff
[    0.210761]   MEM window: 0xcff00000-0xcfffffff
[    0.210765]   PREFETCH window: disabled.
[    0.210770] PCI: Bridge: 0000:00:1e.0
[    0.210772]   IO window: c000-cfff
[    0.210777]   MEM window: 0xcfe00000-0xcfefffff
[    0.210780]   PREFETCH window: disabled.
[    0.210803] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.210808] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.210825] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.210829] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.210839] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.210849] NET: Registered protocol family 2
[    0.246011] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.246272] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.247115] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.247665] TCP: Hash tables configured (established 131072 bind 65536)
[    0.247667] TCP reno registered
[    0.105493] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[    0.105830] audit: initializing netlink socket (disabled)
[    0.105845] type=2000 audit(1203608492.261:1): initialized
[    0.109411] NTFS driver 2.1.29 [Flags: R/O].
[    0.109803] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.109806] io scheduler noop registered
[    0.109808] io scheduler anticipatory registered
[    0.109810] io scheduler deadline registered
[    0.109923] io scheduler cfq registered (default)
[    0.109935] pci 0000:00:02.0: Boot video device
[    0.110106] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.110135] assign_interrupt_mode Found MSI capability
[    0.110137] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.110180] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.110266] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.110294] assign_interrupt_mode Found MSI capability
[    0.110296] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.110670] input: Power Button (FF) as /devices/virtual/input/input0
[    0.110673] ACPI: Power Button (FF) [PWRF]
[    0.110760] input: Power Button (CM) as /devices/virtual/input/input1
[    0.110763] ACPI: Power Button (CM) [PWRB]
[    0.111297] ACPI: SSDT 3F79E0B0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
[    0.266510] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.266514] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.266841] ACPI: SSDT 3F79E280, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
[    0.112742] ACPI: ACPI0007:01 is registered as cooling_device1
[    0.112746] ACPI: Processor [CPU2] (supports 8 throttling states)
[    0.162677] Real Time Clock Driver v1.12ac
[    0.162680] Linux agpgart interface v0.103
[    0.162701] agpgart: Detected an Intel 945G Chipset.
[    0.164817] agpgart: Detected 7932K stolen memory.
[    0.178794] agpgart: AGP aperture is 256M @ 0xd0000000
[    0.178900] [drm] Initialized drm 1.1.0 20060810
[    0.178903] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    0.178977] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.179629] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.179821] PPP generic driver version 2.4.2
[    0.179894] PPP Deflate Compression module registered
[    0.179896] PPP BSD Compression module registered
[    0.180027] PPP MPPE Compression module registered
[    0.180069] Driver 'sd' needs updating - please use bus_type methods
[    0.180110] Driver 'sr' needs updating - please use bus_type methods
[    0.180187] SCSI Media Changer driver v0.25 
[    0.180226] Driver 'ch' needs updating - please use bus_type methods
[    0.180277] ata_piix 0000:00:1f.1: version 2.12
[    0.180289] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    0.180320] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.180400] scsi0 : ata_piix
[    0.180477] scsi1 : ata_piix
[    0.182757] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.182760] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.346952] Switched to high resolution mode on CPU 1
[    0.500927] Switched to high resolution mode on CPU 0
[    0.353049] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A103, max UDMA/33
[    0.359984] ata1.00: configured for UDMA/33
[    0.504923] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A103 PQ: 0 ANSI: 5
[    0.517333] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.517338] Uniform CD-ROM driver Revision: 3.20
[    0.517444] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.517539] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.517619] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
[    0.517624] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.517652] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.517714] scsi2 : ata_piix
[    0.517788] scsi3 : ata_piix
[    0.520069] ata3: SATA max UDMA/133 cmd 0xb800 ctl 0xb400 bmdma 0xa400 irq 17
[    0.520072] ata4: SATA max UDMA/133 cmd 0xb000 ctl 0xa800 bmdma 0xa408 irq 17
[    0.530919] ata3.00: ATA-7: SAMSUNG SP1213C, SV100-27, max UDMA7
[    0.530919] ata3.00: 234493056 sectors, multi 16: LBA48 
[    0.531204] ata3.00: configured for UDMA/133
[    0.533918] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG SP1213C  SV10 PQ: 0 ANSI: 5
[    0.533952] sd 2:0:0:0: [sda] 234493056 512-byte hardware sectors (120060 MB)
[    0.533966] sd 2:0:0:0: [sda] Write Protect is off
[    0.533969] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.533992] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.534043] sd 2:0:0:0: [sda] 234493056 512-byte hardware sectors (120060 MB)
[    0.534056] sd 2:0:0:0: [sda] Write Protect is off
[    0.534058] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.534081] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.534084]  sda: sda1 sda2 sda3 < sda5 sda6 >
[    0.546916] sd 2:0:0:0: [sda] Attached SCSI disk
[    0.546916] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    0.546986] usbcore: registered new interface driver libusual
[    0.547080] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.547082] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.547609] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.547741] mice: PS/2 mouse device common for all mice
[    0.576912] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.122228] cpuidle: using governor ladder
[    1.122231] cpuidle: using governor menu
[    1.122269] usbcore: registered new interface driver hiddev
[    1.122305] usbcore: registered new interface driver usbhid
[    1.122309] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    1.122365] oprofile: using NMI interrupt.
[    1.122407] Netfilter messages via NETLINK v0.30.
[    1.122440] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[    1.122562] ctnetlink v0.93: registering with nfnetlink.
[    1.123149] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.123172] TCP cubic registered
[    1.123183] NET: Registered protocol family 1
[    1.123196] NET: Registered protocol family 17
[    1.124017] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    0.465929] kjournald starting.  Commit interval 5 seconds
[    1.134827] EXT3-fs: mounted filesystem with ordered data mode.
[    1.134827] VFS: Mounted root (ext3 filesystem) readonly.
[    1.134827] Freeing unused kernel memory: 252k freed
[    5.008803] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[    5.008820] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.008823] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.009279] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    5.013192] ehci_hcd 0000:00:1d.7: debug port 1
[    5.013199] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    5.013211] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xcfdffc00
[    5.022248] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.022410] usb usb1: configuration #1 chosen from 1 choice
[    5.022441] hub 1-0:1.0: USB hub found
[    5.022447] hub 1-0:1.0: 8 ports detected
[    2.472766] USB Universal Host Controller Interface driver v3.0
[    5.123350] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.123354] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.123357] usb usb1: Product: EHCI Host Controller
[    5.123359] usb usb1: Manufacturer: Linux 2.6.25-rc2-00342-g5d9c4a7 ehci_hcd
[    5.123361] usb usb1: SerialNumber: 0000:00:1d.7
[    2.560547] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[    2.560560] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.560564] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.560597] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.560628] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00009000
[    2.560740] usb usb2: configuration #1 chosen from 1 choice
[    2.560766] hub 2-0:1.0: USB hub found
[    2.560771] hub 2-0:1.0: 2 ports detected
[    5.151279] parport_pc 00:06: reported by Plug and Play ACPI
[    5.151439] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[    2.661672] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.661675] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.661678] usb usb2: Product: UHCI Host Controller
[    2.661680] usb usb2: Manufacturer: Linux 2.6.25-rc2-00342-g5d9c4a7 uhci_hcd
[    2.661682] usb usb2: SerialNumber: 0000:00:1d.0
[    2.661712] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[    2.661722] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    2.661725] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.661755] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.661778] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00009400
[    2.661891] usb usb3: configuration #1 chosen from 1 choice
[    2.661918] hub 3-0:1.0: USB hub found
[    2.661925] hub 3-0:1.0: 2 ports detected
[    2.762651] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.762654] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.762657] usb usb3: Product: UHCI Host Controller
[    2.762659] usb usb3: Manufacturer: Linux 2.6.25-rc2-00342-g5d9c4a7 uhci_hcd
[    2.762661] usb usb3: SerialNumber: 0000:00:1d.1
[    2.762694] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    2.762703] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    2.762706] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.762736] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.762766] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009800
[    2.762880] usb usb4: configuration #1 chosen from 1 choice
[    2.762906] hub 4-0:1.0: USB hub found
[    2.762913] hub 4-0:1.0: 2 ports detected
[    2.863638] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.863641] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.863644] usb usb4: Product: UHCI Host Controller
[    2.863646] usb usb4: Manufacturer: Linux 2.6.25-rc2-00342-g5d9c4a7 uhci_hcd
[    2.863648] usb usb4: SerialNumber: 0000:00:1d.2
[    2.863687] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
[    2.863696] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    2.863700] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.863730] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.863758] uhci_hcd 0000:00:1d.3: irq 19, io base 0x0000a000
[    2.863873] usb usb5: configuration #1 chosen from 1 choice
[    2.863900] hub 5-0:1.0: USB hub found
[    2.863906] hub 5-0:1.0: 2 ports detected
[    2.964620] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.964623] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.964625] usb usb5: Product: UHCI Host Controller
[    2.964627] usb usb5: Manufacturer: Linux 2.6.25-rc2-00342-g5d9c4a7 uhci_hcd
[    2.964629] usb usb5: SerialNumber: 0000:00:1d.3
[    3.333501] usb 2-1: new full speed USB device using uhci_hcd and address 2
[    6.053505] usb 2-1: configuration #1 chosen from 1 choice
[    6.056435] hub 2-1:1.0: USB hub found
[    6.058389] hub 2-1:1.0: 4 ports detected
[    6.165665] usb 2-1: New USB device found, idVendor=058f, idProduct=9254
[    6.165670] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.165672] usb 2-1: Product: Generic USB Hub
[    6.165674] usb 2-1: Manufacturer: ALCOR
[    6.230022] ACPI: PCI Interrupt 0000:01:0a.0[A] -> GSI 22 (level, low) -> IRQ 22
[    6.230049] snd-ca0106: Model 1006 Rev 00000000 Serial 10061102
[    6.371049] usb 2-2: new low speed USB device using uhci_hcd and address 3
[    6.532384] usb 2-2: configuration #1 chosen from 1 choice
[    6.548499] input: Forward USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input3
[    6.568022] input: USB HID v1.10 Mouse [Forward USB Optical Mouse] on usb-0000:00:1d.0-2
[    6.568068] usb 2-2: New USB device found, idVendor=05bc, idProduct=0102
[    6.568070] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.568072] usb 2-2: Product: USB Optical Mouse
[    6.568074] usb 2-2: Manufacturer: Forward
[    6.774979] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    6.932529] usb 4-1: configuration #1 chosen from 1 choice
[    6.951644] input: USB Wheel Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input4
[    6.973959] input: USB HID v1.00 Mouse [USB Wheel Mouse] on usb-0000:00:1d.2-1
[    6.974003] usb 4-1: New USB device found, idVendor=04fc, idProduct=0003
[    6.974006] usb 4-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    6.974008] usb 4-1: Product: USB Wheel Mouse
[    7.057683] fuse init (API version 7.9)
[    4.515313] usb 2-1.2: new low speed USB device using uhci_hcd and address 4
[    7.083288] lp0: using parport0 (interrupt-driven).
[    7.134916] Adding 481908k swap on /dev/sda6.  Priority:-1 extents:1 across:481908k
[    7.169911] usb 2-1.2: configuration #1 chosen from 1 choice
[    7.186524] input: Microsoft Comfort Curve Keyboard 2000 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input5
[    7.205944] input: USB HID v1.11 Keyboard [Microsoft Comfort Curve Keyboard 2000] on usb-0000:00:1d.0-1.2
[    7.224902] input: Microsoft Comfort Curve Keyboard 2000 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.1/input/input6
[    7.243935] input: USB HID v1.11 Device [Microsoft Comfort Curve Keyboard 2000] on usb-0000:00:1d.0-1.2
[    7.244005] usb 2-1.2: New USB device found, idVendor=045e, idProduct=00dd
[    7.244008] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.244010] usb 2-1.2: Product: Comfort Curve Keyboard 2000
[    7.244013] usb 2-1.2: Manufacturer: Microsoft
[    7.273791] EXT3 FS on sda2, internal journal
[    5.039234] kjournald starting.  Commit interval 5 seconds
[    7.671191] EXT3 FS on sda5, internal journal
[    7.671197] EXT3-fs: mounted filesystem with ordered data mode.
[    6.569549] ppdev: user-space parallel port driver
[    6.925429] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   11.410346] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   11.410362] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   11.410484] [drm] Initialized i915 1.6.0 20060119 on minor 0
