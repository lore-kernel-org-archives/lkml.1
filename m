Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZBFPCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZBFPCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZBFPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:02:12 -0500
Received: from bay0-omc3-s12.bay0.hotmail.com ([65.54.246.212]:4143 "EHLO
	bay0-omc3-s12.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837AbZBFPCF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:02:05 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Feb 2009 10:02:05 EST
Message-ID: <BAY103-DAV85426C2D17E24B96AEB0AB2C10@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.28.3 and 2.6.27.9/2.6.26 kernel error
Date: Fri, 6 Feb 2009 15:55:09 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 06 Feb 2009 14:55:49.0571 (UTC) FILETIME=[FFC3E930:01C9886A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I'm sporadically getting these errors with linux 2.6.28.3
(also with 2.6.27.9 and 2.6.26).
This pretty old box is running squid and openswan.
Unfortunately I'm unable to reproduce the problem.
I have also the error log from 2.6.27.9 and 2.6.26, if you
need them, just drop me message.

TIA

Feb  3 13:45:23 Pleiadi kernel: klogd 1.4.1, log source = /proc/kmsg started.
Feb  3 13:45:23 Pleiadi kernel: BIOS EBDA/lowmem at: 0009f800/0009f800
Feb  3 13:45:23 Pleiadi kernel: Linux version 2.6.28.3 (root@Pleiadi) (gcc version 3.4.6) #1 Tue Feb 3 12:49:56 CET 2009
Feb  3 13:45:23 Pleiadi kernel: KERNEL supported cpus:
Feb  3 13:45:23 Pleiadi kernel:   Intel GenuineIntel
Feb  3 13:45:23 Pleiadi kernel:   AMD AuthenticAMD
Feb  3 13:45:23 Pleiadi kernel:   Cyrix CyrixInstead
Feb  3 13:45:23 Pleiadi kernel:   NSC Geode by NSC
Feb  3 13:45:23 Pleiadi kernel:   Centaur CentaurHauls
Feb  3 13:45:23 Pleiadi kernel:   Transmeta GenuineTMx86
Feb  3 13:45:23 Pleiadi kernel:   Transmeta TransmetaCPU
Feb  3 13:45:23 Pleiadi kernel:   UMC UMC UMC UMC
Feb  3 13:45:23 Pleiadi kernel: BIOS-provided physical RAM map:
Feb  3 13:45:23 Pleiadi kernel:  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Feb  3 13:45:23 Pleiadi kernel:  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Feb  3 13:45:23 Pleiadi kernel:  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb  3 13:45:23 Pleiadi kernel:  BIOS-e820: 0000000000100000 - 000000000a000000 (usable)
Feb  3 13:45:23 Pleiadi kernel:  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb  3 13:45:23 Pleiadi kernel: DMI 2.1 present.
Feb  3 13:45:23 Pleiadi kernel: last_pfn = 0xa000 max_arch_pfn = 0x100000
Feb  3 13:45:23 Pleiadi kernel: kernel direct mapping tables up to a000000 @ 7000-c000
Feb  3 13:45:23 Pleiadi kernel: ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080926]
Feb  3 13:45:23 Pleiadi kernel: 160MB LOWMEM available.
Feb  3 13:45:23 Pleiadi kernel:   mapped low ram: 0 - 0a000000
Feb  3 13:45:23 Pleiadi kernel:   low ram: 00000000 - 0a000000
Feb  3 13:45:23 Pleiadi kernel:   bootmap 00001000 - 00002400
Feb  3 13:45:23 Pleiadi kernel: (6 early reservations) ==> bootmem [0000000000 - 000a000000]
Feb  3 13:45:23 Pleiadi kernel:   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Feb  3 13:45:23 Pleiadi kernel:   #1 [0000100000 - 00003bba94]    TEXT DATA BSS ==> [0000100000 - 00003bba94]
Feb  3 13:45:23 Pleiadi kernel:   #2 [00003bc000 - 00003be000]    INIT_PG_TABLE ==> [00003bc000 - 00003be000]
Feb  3 13:45:23 Pleiadi kernel:   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
Feb  3 13:45:23 Pleiadi kernel:   #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
Feb  3 13:45:23 Pleiadi kernel:   #5 [0000001000 - 0000003000]          BOOTMAP ==> [0000001000 - 0000003000]
Feb  3 13:45:23 Pleiadi kernel: Zone PFN ranges:
Feb  3 13:45:23 Pleiadi kernel:   DMA      0x00000000 -> 0x00001000
Feb  3 13:45:23 Pleiadi kernel:   Normal   0x00001000 -> 0x0000a000
Feb  3 13:45:23 Pleiadi kernel: Movable zone start PFN for each node
Feb  3 13:45:23 Pleiadi kernel: early_node_map[2] active PFN ranges
Feb  3 13:45:23 Pleiadi kernel:     0: 0x00000000 -> 0x0000009f
Feb  3 13:45:23 Pleiadi kernel:     0: 0x00000100 -> 0x0000a000
Feb  3 13:45:23 Pleiadi kernel: On node 0 totalpages: 40863
Feb  3 13:45:23 Pleiadi kernel: free_area_init_node: node 0, pgdat c035b540, node_mem_map c1000000
Feb  3 13:45:23 Pleiadi kernel:   DMA zone: 32 pages used for memmap
Feb  3 13:45:23 Pleiadi kernel:   DMA zone: 0 pages reserved
Feb  3 13:45:23 Pleiadi kernel:   DMA zone: 3967 pages, LIFO batch:0
Feb  3 13:45:23 Pleiadi kernel:   Normal zone: 288 pages used for memmap
Feb  3 13:45:23 Pleiadi kernel:   Normal zone: 36576 pages, LIFO batch:7
Feb  3 13:45:23 Pleiadi kernel:   Movable zone: 0 pages used for memmap
Feb  3 13:45:23 Pleiadi kernel: Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb  3 13:45:23 Pleiadi kernel: Allocating PCI resources starting at 10000000 (gap: a000000:f5ff0000)
Feb  3 13:45:23 Pleiadi kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 40543
Feb  3 13:45:23 Pleiadi kernel: Kernel command line: auto BOOT_IMAGE=Linux ro root=301 console=ttyS0,9600 console=tty0
Feb  3 13:45:23 Pleiadi kernel: Enabling fast FPU save and restore... done.
Feb  3 13:45:23 Pleiadi kernel: Initializing CPU#0
Feb  3 13:45:23 Pleiadi kernel: PID hash table entries: 1024 (order: 10, 4096 bytes)
Feb  3 13:45:23 Pleiadi kernel: Fast TSC calibration using PIT
Feb  3 13:45:23 Pleiadi kernel: Detected 300.691 MHz processor.
Feb  3 13:45:23 Pleiadi kernel: Console: colour VGA+ 80x25
Feb  3 13:45:23 Pleiadi kernel: console [tty0] enabled
Feb  3 13:45:23 Pleiadi kernel: Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb  3 13:45:23 Pleiadi kernel: Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Feb  3 13:45:23 Pleiadi kernel: Memory: 159000k/163840k available (1727k kernel code, 4304k reserved, 722k data, 188k init, 0k highmem)
Feb  3 13:45:23 Pleiadi kernel: virtual kernel memory layout:
Feb  3 13:45:23 Pleiadi kernel:     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
Feb  3 13:45:23 Pleiadi kernel:     vmalloc : 0xca800000 - 0xfffaa000   ( 855 MB)
Feb  3 13:45:23 Pleiadi kernel:     lowmem  : 0xc0000000 - 0xca000000   ( 160 MB)
Feb  3 13:45:23 Pleiadi kernel:       .init : 0xc0368000 - 0xc0397000   ( 188 kB)
Feb  3 13:45:23 Pleiadi kernel:       .data : 0xc02afeb9 - 0xc03649fc   ( 722 kB)
Feb  3 13:45:23 Pleiadi kernel:       .text : 0xc0100000 - 0xc02afeb9   (1727 kB)
Feb  3 13:45:23 Pleiadi kernel: Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb  3 13:45:23 Pleiadi kernel: SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Feb  3 13:45:23 Pleiadi kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 601.38 BogoMIPS (lpj=1202764)
Feb  3 13:45:23 Pleiadi kernel: Mount-cache hash table entries: 512
Feb  3 13:45:23 Pleiadi kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Feb  3 13:45:23 Pleiadi kernel: CPU: L2 cache: 128K
Feb  3 13:45:23 Pleiadi kernel: CPU: Intel Celeron (Mendocino) stepping 00
Feb  3 13:45:23 Pleiadi kernel: Checking 'hlt' instruction... OK.
Feb  3 13:45:23 Pleiadi kernel: Freeing SMP alternatives: 0k freed
Feb  3 13:45:23 Pleiadi kernel: ACPI: Core revision 20080926
Feb  3 13:45:23 Pleiadi kernel: ACPI Exception (tbxface-0627): AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20080926]
Feb  3 13:45:23 Pleiadi kernel: ACPI: Unable to load the System Description Tables
Feb  3 13:45:23 Pleiadi kernel: net_namespace: 480 bytes
Feb  3 13:45:23 Pleiadi kernel: NET: Registered protocol family 16
Feb  3 13:45:23 Pleiadi kernel: PCI: PCI BIOS revision 2.10 entry at 0xfda61, last bus=1
Feb  3 13:45:23 Pleiadi kernel: PCI: Using configuration type 1 for base access
Feb  3 13:45:23 Pleiadi kernel: ACPI: Interpreter disabled.
Feb  3 13:45:23 Pleiadi kernel: PCI: Probing PCI hardware
Feb  3 13:45:23 Pleiadi kernel: PCI: Probing PCI hardware (bus 00)
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:00.0: reg 10 32bit mmio: [0xe8000000-0xebffffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.1: reg 20 io port: [0xffa0-0xffaf]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.2: reg 20 io port: [0x6000-0x601f]
Feb  3 13:45:23 Pleiadi kernel: * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
Feb  3 13:45:23 Pleiadi kernel: * this clock source is slow. Consider trying other clock sources
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.3: quirk: region 6100-613f claimed by PIIX4 ACPI
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.3: quirk: region 5f00-5f0f claimed by PIIX4 SMB
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:09.0: reg 10 io port: [0xde00-0xde3f]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:09.0: reg 30 32bit mmio: [0xefff0000-0xefffffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:0a.0: reg 10 io port: [0xdc00-0xdc3f]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:0a.0: reg 30 32bit mmio: [0xeffe0000-0xeffeffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:0b.0: reg 10 io port: [0xda00-0xda3f]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:0b.0: reg 30 32bit mmio: [0xeffd0000-0xeffdffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:01:00.0: reg 10 32bit mmio: [0xe6000000-0xe6ffffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:01:00.0: reg 14 io port: [0xbc00-0xbcff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:01:00.0: reg 18 32bit mmio: [0xefeff000-0xefefffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:01:00.0: reg 30 32bit mmio: [0xefec0000-0xefedffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:01:00.0: supports D1 D2
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0: bridge 32bit mmio: [0xefe00000-0xefefffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0: bridge 32bit mmio pref: [0xe5c00000-0xe7cfffff]
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.0: PIIX/ICH IRQ router [8086:7110]
Feb  3 13:45:23 Pleiadi kernel: PCI: setting IRQ 11 as level-triggered
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.2: found PCI INT D -> IRQ 11
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:07.2: sharing IRQ 11 with 0000:00:0b.0
Feb  3 13:45:23 Pleiadi kernel: pnp: PnP ACPI: disabled
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0:   IO window: 0xb000-0xbfff
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0:   MEM window: 0xefe00000-0xefefffff
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:01.0:   PREFETCH window: 0x000000e5c00000-0x000000e7cfffff
Feb  3 13:45:23 Pleiadi kernel: bus: 00 index 0 io port: [0x00-0xffff]
Feb  3 13:45:23 Pleiadi kernel: bus: 00 index 1 mmio: [0x000000-0xffffffff]
Feb  3 13:45:23 Pleiadi kernel: bus: 01 index 0 io port: [0xb000-0xbfff]
Feb  3 13:45:23 Pleiadi kernel: bus: 01 index 1 mmio: [0xefe00000-0xefefffff]
Feb  3 13:45:23 Pleiadi kernel: bus: 01 index 2 mmio: [0xe5c00000-0xe7cfffff]
Feb  3 13:45:23 Pleiadi kernel: bus: 01 index 3 mmio: [0x0-0x0]
Feb  3 13:45:23 Pleiadi kernel: NET: Registered protocol family 2
Feb  3 13:45:23 Pleiadi kernel: IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
Feb  3 13:45:23 Pleiadi kernel: TCP established hash table entries: 8192 (order: 4, 65536 bytes)
Feb  3 13:45:23 Pleiadi kernel: TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
Feb  3 13:45:23 Pleiadi kernel: TCP: Hash tables configured (established 8192 bind 8192)
Feb  3 13:45:23 Pleiadi kernel: TCP reno registered
Feb  3 13:45:23 Pleiadi kernel: NET: Registered protocol family 1
Feb  3 13:45:23 Pleiadi kernel: platform rtc_cmos: registered platform RTC device (no PNP device found)
Feb  3 13:45:23 Pleiadi kernel: alg: cipher: Test 1 failed on encryption for aes-asm
Feb  3 13:45:23 Pleiadi kernel: 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08 
Feb  3 13:45:23 Pleiadi kernel: SGI XFS with security attributes, no debug enabled
Feb  3 13:45:23 Pleiadi kernel: msgmni has been set to 310
Feb  3 13:45:23 Pleiadi kernel: alg: No test for stdrng (krng)
Feb  3 13:45:23 Pleiadi kernel: io scheduler noop registered (default)
Feb  3 13:45:23 Pleiadi kernel: pci 0000:00:00.0: Limiting direct PCI/PCI transfers
Feb  3 13:45:23 Pleiadi kernel: pci 0000:01:00.0: Boot video device
Feb  3 13:45:23 Pleiadi kernel: Uniform Multi-Platform E-IDE driver
Feb  3 13:45:23 Pleiadi kernel: piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
Feb  3 13:45:23 Pleiadi kernel: piix 0000:00:07.1: not 100%% native mode: will probe irqs later
Feb  3 13:45:23 Pleiadi kernel:     ide0: BM-DMA at 0xffa0-0xffa7
Feb  3 13:45:23 Pleiadi kernel:     ide1: BM-DMA at 0xffa8-0xffaf
Feb  3 13:45:23 Pleiadi kernel: Probing IDE interface ide0...
Feb  3 13:45:23 Pleiadi kernel: hda: QUANTUM FIREBALL EX4.3A, ATA DISK drive
Feb  3 13:45:23 Pleiadi kernel: hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb  3 13:45:23 Pleiadi kernel: hda: UDMA/33 mode selected
Feb  3 13:45:23 Pleiadi kernel: Probing IDE interface ide1...
Feb  3 13:45:23 Pleiadi kernel: hdc: MATSHITA CR-588, ATAPI CD/DVD-ROM drive
Feb  3 13:45:23 Pleiadi kernel: hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb  3 13:45:23 Pleiadi kernel: hdc: MWDMA2 mode selected
Feb  3 13:45:23 Pleiadi kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb  3 13:45:23 Pleiadi kernel: ide1 at 0x170-0x177,0x376 on irq 15
Feb  3 13:45:23 Pleiadi kernel: ide-gd driver 1.18
Feb  3 13:45:23 Pleiadi kernel: hda: max request size: 128KiB
Feb  3 13:45:23 Pleiadi kernel: hda: 8405775 sectors (4303 MB) w/418KiB Cache, CHS=8895/15/63
Feb  3 13:45:23 Pleiadi kernel: hda: cache flushes not supported
Feb  3 13:45:23 Pleiadi kernel:  hda: hda1 hda2 < hda5 hda6 hda7 hda8 hda9 >
Feb  3 13:45:23 Pleiadi kernel: PNP: No PS/2 controller found. Probing ports directly.
Feb  3 13:45:23 Pleiadi kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Feb  3 13:45:23 Pleiadi kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Feb  3 13:45:23 Pleiadi kernel: mice: PS/2 mouse device common for all mice
Feb  3 13:45:23 Pleiadi kernel: nf_conntrack version 0.5.0 (2560 buckets, 10240 max)
Feb  3 13:45:23 Pleiadi kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Feb  3 13:45:23 Pleiadi kernel: TCP cubic registered
Feb  3 13:45:23 Pleiadi kernel: Initializing XFRM netlink socket
Feb  3 13:45:23 Pleiadi kernel: NET: Registered protocol family 17
Feb  3 13:45:23 Pleiadi kernel: NET: Registered protocol family 15
Feb  3 13:45:23 Pleiadi kernel: IO APIC resources could be not be allocated.
Feb  3 13:45:23 Pleiadi kernel: Using IPI Shortcut mode
Feb  3 13:45:23 Pleiadi kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Feb  3 13:45:23 Pleiadi kernel: Filesystem "hda1": Disabling barriers, trial barrier write failed
Feb  3 13:45:23 Pleiadi kernel: XFS mounting filesystem hda1
Feb  3 13:45:23 Pleiadi kernel: Ending clean XFS mount for filesystem: hda1
Feb  3 13:45:23 Pleiadi kernel: VFS: Mounted root (xfs filesystem) readonly.
Feb  3 13:45:23 Pleiadi kernel: Freeing unused kernel memory: 188k freed
Feb  3 13:45:23 Pleiadi kernel: Adding 151160k swap on /dev/hda9.  Priority:-1 extents:1 across:151160k
Feb  3 13:45:23 Pleiadi kernel: PCI: setting IRQ 9 as level-triggered
Feb  3 13:45:23 Pleiadi kernel: 3c59x 0000:00:09.0: found PCI INT A -> IRQ 9
Feb  3 13:45:23 Pleiadi kernel: 3c59x: Donald Becker and others.
Feb  3 13:45:23 Pleiadi kernel: 0000:00:09.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001de00.
Feb  3 13:45:23 Pleiadi kernel: PCI: setting IRQ 10 as level-triggered
Feb  3 13:45:23 Pleiadi kernel: 3c59x 0000:00:0a.0: found PCI INT A -> IRQ 10
Feb  3 13:45:23 Pleiadi kernel: 0000:00:0a.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001dc00.
Feb  3 13:45:23 Pleiadi kernel: 3c59x 0000:00:0b.0: found PCI INT A -> IRQ 11
Feb  3 13:45:23 Pleiadi kernel: 3c59x 0000:00:0b.0: sharing IRQ 11 with 0000:00:07.2
Feb  3 13:45:23 Pleiadi kernel: 0000:00:0b.0: 3Com PCI 3c905 Boomerang 100baseTx at 0001da00.
Feb  3 13:45:23 Pleiadi kernel: Filesystem "hda5": Disabling barriers, trial barrier write failed
Feb  3 13:45:23 Pleiadi kernel: XFS mounting filesystem hda5
Feb  3 13:45:23 Pleiadi kernel: Ending clean XFS mount for filesystem: hda5
Feb  3 13:45:23 Pleiadi kernel: Filesystem "hda6": Disabling barriers, trial barrier write failed
Feb  3 13:45:23 Pleiadi kernel: XFS mounting filesystem hda6
Feb  3 13:45:23 Pleiadi kernel: Ending clean XFS mount for filesystem: hda6
Feb  3 13:45:23 Pleiadi kernel: Filesystem "hda7": Disabling barriers, trial barrier write failed
Feb  3 13:45:23 Pleiadi kernel: XFS mounting filesystem hda7
Feb  3 13:45:23 Pleiadi kernel: Ending clean XFS mount for filesystem: hda7
Feb  3 13:45:23 Pleiadi kernel: Filesystem "hda8": Disabling barriers, trial barrier write failed
Feb  3 13:45:23 Pleiadi kernel: XFS mounting filesystem hda8
Feb  3 13:45:23 Pleiadi kernel: Ending clean XFS mount for filesystem: hda8
Feb  3 13:45:23 Pleiadi kernel: eth0:  setting full-duplex.
Feb  3 13:45:23 Pleiadi kernel: eth1:  setting full-duplex.
Feb  3 13:45:24 Pleiadi kernel: eth2:  setting full-duplex.
Feb  3 13:46:28 Pleiadi kernel: alg: No test for authenc(hmac(sha1),cbc(aes)) (authenc(hmac(sha1-generic),cbc(aes-generic)))
Feb  3 13:46:58 Pleiadi kernel: alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc(hmac(md5-generic),cbc(des3_ede-generic)))
Feb  3 13:47:06 Pleiadi kernel: alg: No test for authenc(hmac(sha1),cbc(des3_ede)) (authenc(hmac(sha1-generic),cbc(des3_ede-generic)))
Feb  5 10:10:29 Pleiadi kernel: < [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c014a18a>] __kmalloc_track_caller+0x80/0xb5
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<ca82d7f9>] boomerang_start_xmit+0x355/0x36e [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c02967b2>] nf_nat_fn+0x119/0x125
Feb  5 10:10:29 Pleiadi kernel:  [<c024d406>] dev_hard_start_xmit+0x61/0xb4
Feb  5 10:10:29 Pleiadi kernel:  [<c0258a6f>] __qdisc_run+0xb7/0x178
Feb  5 10:10:29 Pleiadi kernel:  [<c024d70a>] dev_queue_xmit+0x12c/0x1cf
Feb  5 10:10:29 Pleiadi kernel:  [<c026e18c>] ip_finish_output+0x1a4/0x1df
Feb  5 10:10:29 Pleiadi kernel:  [<c026e500>] ip_output+0x74/0x76
Feb  5 10:10:29 Pleiadi kernel:  [<c026cd48>] ip_forward_finish+0x20/0x22
Feb  5 10:10:29 Pleiadi kernel:  [<c026cf9b>] ip_forward+0x251/0x292
Feb  5 10:10:29 Pleiadi kernel:  [<c026c08f>] ip_rcv_finish+0x215/0x229
Feb  5 10:10:29 Pleiadi kernel:  [<c026c26f>] ip_rcv+0x1cc/0x1e9
Feb  5 10:10:29 Pleiadi kernel:  [<c024dbfc>] netif_receive_skb+0x211/0x22b
Feb  5 10:10:29 Pleiadi kernel:  [<c024dcd3>] process_backlog+0x79/0x8d
Feb  5 10:10:29 Pleiadi kernel:  [<c024dd64>] net_rx_action+0x5a/0x110
Feb  5 10:10:29 Pleiadi kernel:  [<c0118dab>] __do_softirq+0x43/0xb6
Feb  5 10:10:29 Pleiadi kernel:  [<c0118e40>] do_softirq+0x22/0x26
Feb  5 10:10:29 Pleiadi kernel:  [<c01046fe>] do_IRQ+0x5a/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c0110000>] aes_enc_blk+0x75c/0xb80
Feb  5 10:10:29 Pleiadi kernel:  [<c011268f>] finish_task_switch+0x1c/0x4c
Feb  5 10:10:29 Pleiadi kernel:  [<c02ae2c3>] __sched_text_start+0x233/0x24f
Feb  5 10:10:29 Pleiadi kernel:  [<c011bb03>] lock_timer_base+0x12/0x25
Feb  5 10:10:29 Pleiadi kernel:  [<c02ae61b>] schedule_timeout+0x69/0x84
Feb  5 10:10:29 Pleiadi kernel:  [<c011bf10>] process_timeout+0x0/0x5
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3482>] xfsbufd+0x30/0xbf
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3452>] xfsbufd+0x0/0xbf
Feb  5 10:10:29 Pleiadi kernel:  [<c0122a09>] kthread+0x33/0x54
Feb  5 10:10:29 Pleiadi kernel:  [<c01229d6>] kthread+0x0/0x54
Feb  5 10:10:29 Pleiadi kernel:  [<c01036cb>] kernel_thread_helper+0x7/0x10
Feb  5 10:10:29 Pleiadi kernel: Mem-Info:
Feb  5 10:10:29 Pleiadi kernel: DMA per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
Feb  5 10:10:29 Pleiadi kernel: Normal per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  47
Feb  5 10:10:29 Pleiadi kernel: Active_anon:9532 active_file:5273 inactive_anon:9631
Feb  5 10:10:29 Pleiadi kernel:  inactive_file:10413 unevictable:0 dirty:63 writeback:0 unstable:0
Feb  5 10:10:29 Pleiadi kernel:  free:293 slab:3462 mapped:476 pagetables:280 bounce:0
Feb  5 10:10:29 Pleiadi kernel: DMA free:628kB min:156kB low:192kB high:232kB active_anon:2644kB inactive_anon:2932kB active_file:3508kB inactive_file:2928kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 142 142
Feb  5 10:10:29 Pleiadi kernel: Normal free:544kB min:1448kB low:1808kB high:2172kB active_anon:35484kB inactive_anon:35592kB active_file:17584kB inactive_file:38724kB unevictable:0kB present:146304kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 0 0
Feb  5 10:10:29 Pleiadi kernel: DMA: 19*4kB 3*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 628kB
Feb  5 10:10:29 Pleiadi kernel: Normal: 20*4kB 40*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB
Feb  5 10:10:29 Pleiadi kernel: 16671 total pagecache pages
Feb  5 10:10:29 Pleiadi kernel: 952 pages in swap cache
Feb  5 10:10:29 Pleiadi kernel: Swap cache stats: add 3777, delete 2825, find 1321/1609
Feb  5 10:10:29 Pleiadi kernel: Free swap  = 143916kB
Feb  5 10:10:29 Pleiadi kernel: Total swap = 151160kB
Feb  5 10:10:29 Pleiadi kernel: 40960 pages RAM
Feb  5 10:10:29 Pleiadi kernel: 1127 pages reserved
Feb  5 10:10:29 Pleiadi kernel: 11955 pages shared
Feb  5 10:10:29 Pleiadi kernel: 32130 pages non-shared
Feb  5 10:10:29 Pleiadi kernel: eth2: memory shortage
Feb  5 10:10:29 Pleiadi kernel: xfsbufd: page allocation failure. order:0, mode:0x4020
Feb  5 10:10:29 Pleiadi kernel: Pid: 345, comm: xfsbufd Not tainted 2.6.28.3 #1
Feb  5 10:10:29 Pleiadi kernel: Call Trace:
Feb  5 10:10:29 Pleiadi kernel:  [<c01350a7>] __alloc_pages_internal+0x325/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0148c4f>] allocate_slab+0x55/0xa4
Feb  5 10:10:29 Pleiadi kernel:  [<c0148cd6>] new_slab+0x1f/0x108
Feb  5 10:10:29 Pleiadi kernel:  [<c01490ca>] __slab_alloc+0x86/0xf0
Feb  5 10:10:29 Pleiadi kernel:  [<c014a174>] __kmalloc_track_caller+0x6a/0xb5
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<ca82d7f9>] boomerang_start_xmit+0x355/0x36e [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c02967b2>] nf_nat_fn+0x119/0x125
Feb  5 10:10:29 Pleiadi kernel:  [<c024d406>] dev_hard_start_xmit+0x61/0xb4
Feb  5 10:10:29 Pleiadi kernel:  [<c0258a6f>] __qdisc_run+0xb7/0x178
Feb  5 10:10:29 Pleiadi kernel:  [<c024d70a>] dev_queue_xmit+0x12c/0x1cf
Feb  5 10:10:29 Pleiadi kernel:  [<c026e18c>] ip_finish_output+0x1a4/0x1df
Feb  5 10:10:29 Pleiadi kernel:  [<c026e500>] ip_output+0x74/0x76
Feb  5 10:10:29 Pleiadi kernel:  [<c026cd48>] ip_forward_finish+0x20/0x22
Feb  5 10:10:29 Pleiadi kernel:  [<c026cf9b>] ip_forward+0x251/0x292
Feb  5 10:10:29 Pleiadi kernel:  [<c026c08f>] ip_rcv_finish+0x215/0x229
Feb  5 10:10:29 Pleiadi kernel:  [<c026c26f>] ip_rcv+0x1cc/0x1e9
Feb  5 10:10:29 Pleiadi kernel:  [<c024dbfc>] netif_receive_skb+0x211/0x22b
Feb  5 10:10:29 Pleiadi kernel:  [<c024dcd3>] process_backlog+0x79/0x8d
Feb  5 10:10:29 Pleiadi kernel:  [<c024dd64>] net_rx_action+0x5a/0x110
Feb  5 10:10:29 Pleiadi kernel:  [<c0118dab>] __do_softirq+0x43/0xb6
Feb  5 10:10:29 Pleiadi kernel:  [<c0118e40>] do_softirq+0x22/0x26
Feb  5 10:10:29 Pleiadi kernel:  [<c01046fe>] do_IRQ+0x5a/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c0110000>] aes_enc_blk+0x75c/0xb80
Feb  5 10:10:29 Pleiadi kernel:  [<c011268f>] finish_task_switch+0x1c/0x4c
Feb  5 10:10:29 Pleiadi kernel:  [<c02ae2c3>] __sched_text_start+0x233/0x24f
Feb  5 10:10:29 Pleiadi kernel:  [<c011bb03>] lock_timer_base+0x12/0x25
Feb  5 10:10:29 Pleiadi kernel:  [<c02ae61b>] schedule_timeout+0x69/0x84
Feb  5 10:10:29 Pleiadi kernel:  [<c011bf10>] process_timeout+0x0/0x5
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3482>] xfsbufd+0x30/0xbf
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3452>] xfsbufd+0x0/0xbf
Feb  5 10:10:29 Pleiadi kernel:  [<c0122a09>] kthread+0x33/0x54
Feb  5 10:10:29 Pleiadi kernel:  [<c01229d6>] kthread+0x0/0x54
Feb  5 10:10:29 Pleiadi kernel:  [<c01036cb>] kernel_thread_helper+0x7/0x10
Feb  5 10:10:29 Pleiadi kernel: Mem-Info:
Feb  5 10:10:29 Pleiadi kernel: DMA per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
Feb  5 10:10:29 Pleiadi kernel: Normal per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  47
Feb  5 10:10:29 Pleiadi kernel: Active_anon:9532 active_file:5273 inactive_anon:9631
Feb  5 10:10:29 Pleiadi kernel:  inactive_file:10413 unevictable:0 dirty:63 writeback:0 unstable:0
Feb  5 10:10:29 Pleiadi kernel:  free:293 slab:3462 mapped:476 pagetables:280 bounce:0
Feb  5 10:10:29 Pleiadi kernel: DMA free:628kB min:156kB low:192kB high:232kB active_anon:2644kB inactive_anon:2932kB active_file:3508kB inactive_file:2928kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 142 142
Feb  5 10:10:29 Pleiadi kernel: Normal free:544kB min:1448kB low:1808kB high:2172kB active_anon:35484kB inactive_anon:35592kB active_file:17584kB inactive_file:38724kB unevictable:0kB present:146304kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 0 0
Feb  5 10:10:29 Pleiadi kernel: DMA: 19*4kB 3*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 628kB
Feb  5 10:10:29 Pleiadi kernel: Normal: 20*4kB 40*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB
Feb  5 10:10:29 Pleiadi kernel: 16671 total pagecache pages
Feb  5 10:10:29 Pleiadi kernel: 952 pages in swap cache
Feb  5 10:10:29 Pleiadi kernel: Swap cache stats: add 3777, delete 2825, find 1321/1609
Feb  5 10:10:29 Pleiadi kernel: Free swap  = 143916kB
Feb  5 10:10:29 Pleiadi kernel: Total swap = 151160kB
Feb  5 10:10:29 Pleiadi kernel: 40960 pages RAM
Feb  5 10:10:29 Pleiadi kernel: 1127 pages reserved
Feb  5 10:10:29 Pleiadi kernel: 11955 pages shared
Feb  5 10:10:29 Pleiadi kernel: 32130 pages non-shared
Feb  5 10:10:29 Pleiadi kernel: klogd: page allocation failure. order:0, mode:0x4020
Feb  5 10:10:29 Pleiadi kernel: Pid: 407, comm: klogd Not tainted 2.6.28.3 #1
Feb  5 10:10:29 Pleiadi kernel: Call Trace:
Feb  5 10:10:29 Pleiadi kernel:  [<c01350a7>] __alloc_pages_internal+0x325/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0148c4f>] allocate_slab+0x55/0xa4
Feb  5 10:10:29 Pleiadi kernel:  [<c0148cd6>] new_slab+0x1f/0x108
Feb  5 10:10:29 Pleiadi kernel:  [<c01490ca>] __slab_alloc+0x86/0xf0
Feb  5 10:10:29 Pleiadi kernel:  [<c014a174>] __kmalloc_track_caller+0x6a/0xb5
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c011252e>] try_to_wake_up+0x85/0x90
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3394>] xfsbufd_wakeup+0x2b/0x39
Feb  5 10:10:29 Pleiadi kernel:  [<c013815e>] shrink_slab+0x69/0x178
Feb  5 10:10:29 Pleiadi kernel:  [<c01396f5>] do_try_to_free_pages+0xf4/0x1d2
Feb  5 10:10:29 Pleiadi kernel:  [<c0139839>] try_to_free_pages+0x66/0x6e
Feb  5 10:10:29 Pleiadi kernel:  [<c0138b6e>] isolate_pages_global+0x0/0x47
Feb  5 10:10:29 Pleiadi kernel:  [<c0134f53>] __alloc_pages_internal+0x1d1/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0246b4f>] sock_def_readable+0x1d/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c01441a2>] read_swap_cache_async+0x32/0xa5
Feb  5 10:10:29 Pleiadi kernel:  [<c014424d>] swapin_readahead+0x38/0x6b
Feb  5 10:10:29 Pleiadi kernel:  [<c013d4c9>] do_swap_page+0x57/0x1e2
Feb  5 10:10:29 Pleiadi kernel:  [<c013db4d>] handle_mm_fault+0xdb/0x13a
Feb  5 10:10:29 Pleiadi kernel:  [<c010d1f7>] do_page_fault+0x161/0x3ea
Feb  5 10:10:29 Pleiadi kernel:  [<c010d096>] do_page_fault+0x0/0x3ea
Feb  5 10:10:29 Pleiadi kernel:  [<c02af20a>] error_code+0x6a/0x70
Feb  5 10:10:29 Pleiadi kernel:  [<c0115927>] do_syslog+0x15a/0x30e
Feb  5 10:10:29 Pleiadi kernel:  [<c0122d56>] autoremove_wake_function+0x0/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c0122d56>] autoremove_wake_function+0x0/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c017817c>] kmsg_read+0x0/0x36
Feb  5 10:10:29 Pleiadi kernel:  [<c0172d61>] proc_reg_read+0x35/0x48
Feb  5 10:10:29 Pleiadi kernel:  [<c014c90b>] vfs_read+0x7f/0xe5
Feb  5 10:10:29 Pleiadi kernel:  [<c014cb8b>] sys_read+0x3c/0x62
Feb  5 10:10:29 Pleiadi kernel:  [<c0102aae>] syscall_call+0x7/0xb
Feb  5 10:10:29 Pleiadi kernel:  [<c02a0000>] copy_templates+0x5a/0xbf
Feb  5 10:10:29 Pleiadi kernel: Mem-Info:
Feb  5 10:10:29 Pleiadi kernel: DMA per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
Feb  5 10:10:29 Pleiadi kernel: Normal per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  47
Feb  5 10:10:29 Pleiadi kernel: Active_anon:9532 active_file:5273 inactive_anon:9631
Feb  5 10:10:29 Pleiadi kernel:  inactive_file:10413 unevictable:0 dirty:63 writeback:0 unstable:0
Feb  5 10:10:29 Pleiadi kernel:  free:293 slab:3462 mapped:476 pagetables:280 bounce:0
Feb  5 10:10:29 Pleiadi kernel: DMA free:628kB min:156kB low:192kB high:232kB active_anon:2644kB inactive_anon:2932kB active_file:3508kB inactive_file:2928kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 142 142
Feb  5 10:10:29 Pleiadi kernel: Normal free:544kB min:1448kB low:1808kB high:2172kB active_anon:35484kB inactive_anon:35592kB active_file:17584kB inactive_file:38724kB unevictable:0kB present:146304kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 0 0
Feb  5 10:10:29 Pleiadi kernel: DMA: 19*4kB 3*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 628kB
Feb  5 10:10:29 Pleiadi kernel: Normal: 20*4kB 40*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB
Feb  5 10:10:29 Pleiadi kernel: 16671 total pagecache pages
Feb  5 10:10:29 Pleiadi kernel: 952 pages in swap cache
Feb  5 10:10:29 Pleiadi kernel: Swap cache stats: add 3777, delete 2825, find 1321/1610
Feb  5 10:10:29 Pleiadi kernel: Free swap  = 143916kB
Feb  5 10:10:29 Pleiadi kernel: Total swap = 151160kB
Feb  5 10:10:29 Pleiadi kernel: 40960 pages RAM
Feb  5 10:10:29 Pleiadi kernel: 1127 pages reserved
Feb  5 10:10:29 Pleiadi kernel: 11955 pages shared
Feb  5 10:10:29 Pleiadi kernel: 32130 pages non-shared
Feb  5 10:10:29 Pleiadi kernel: klogd: page allocation failure. order:0, mode:0x4020
Feb  5 10:10:29 Pleiadi kernel: Pid: 407, comm: klogd Not tainted 2.6.28.3 #1
Feb  5 10:10:29 Pleiadi kernel: Call Trace:
Feb  5 10:10:29 Pleiadi kernel:  [<c01350a7>] __alloc_pages_internal+0x325/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0148c4f>] allocate_slab+0x55/0xa4
Feb  5 10:10:29 Pleiadi kernel:  [<c0148cd6>] new_slab+0x1f/0x108
Feb  5 10:10:29 Pleiadi kernel:  [<c01490ca>] __slab_alloc+0x86/0xf0
Feb  5 10:10:29 Pleiadi kernel:  [<c014a174>] __kmalloc_track_caller+0x6a/0xb5
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c014a18a>] __kmalloc_track_caller+0x80/0xb5
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c011252e>] try_to_wake_up+0x85/0x90
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3394>] xfsbufd_wakeup+0x2b/0x39
Feb  5 10:10:29 Pleiadi kernel:  [<c013815e>] shrink_slab+0x69/0x178
Feb  5 10:10:29 Pleiadi kernel:  [<c01396f5>] do_try_to_free_pages+0xf4/0x1d2
Feb  5 10:10:29 Pleiadi kernel:  [<c0139839>] try_to_free_pages+0x66/0x6e
Feb  5 10:10:29 Pleiadi kernel:  [<c0138b6e>] isolate_pages_global+0x0/0x47
Feb  5 10:10:29 Pleiadi kernel:  [<c0134f53>] __alloc_pages_internal+0x1d1/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0246b4f>] sock_def_readable+0x1d/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c01441a2>] read_swap_cache_async+0x32/0xa5
Feb  5 10:10:29 Pleiadi kernel:  [<c014424d>] swapin_readahead+0x38/0x6b
Feb  5 10:10:29 Pleiadi kernel:  [<c013d4c9>] do_swap_page+0x57/0x1e2
Feb  5 10:10:29 Pleiadi kernel:  [<c013db4d>] handle_mm_fault+0xdb/0x13a
Feb  5 10:10:29 Pleiadi kernel:  [<c010d1f7>] do_page_fault+0x161/0x3ea
Feb  5 10:10:29 Pleiadi kernel:  [<c010d096>] do_page_fault+0x0/0x3ea
Feb  5 10:10:29 Pleiadi kernel:  [<c02af20a>] error_code+0x6a/0x70
Feb  5 10:10:29 Pleiadi kernel:  [<c0115927>] do_syslog+0x15a/0x30e
Feb  5 10:10:29 Pleiadi kernel:  [<c0122d56>] autoremove_wake_function+0x0/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c0122d56>] autoremove_wake_function+0x0/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c017817c>] kmsg_read+0x0/0x36
Feb  5 10:10:29 Pleiadi kernel:  [<c0172d61>] proc_reg_read+0x35/0x48
Feb  5 10:10:29 Pleiadi kernel:  [<c014c90b>] vfs_read+0x7f/0xe5
Feb  5 10:10:29 Pleiadi kernel:  [<c014cb8b>] sys_read+0x3c/0x62
Feb  5 10:10:29 Pleiadi kernel:  [<c0102aae>] syscall_call+0x7/0xb
Feb  5 10:10:29 Pleiadi kernel:  [<c02a0000>] copy_templates+0x5a/0xbf
Feb  5 10:10:29 Pleiadi kernel: Mem-Info:
Feb  5 10:10:29 Pleiadi kernel: DMA per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
Feb  5 10:10:29 Pleiadi kernel: Normal per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  47
Feb  5 10:10:29 Pleiadi kernel: Active_anon:9532 active_file:5273 inactive_anon:9631
Feb  5 10:10:29 Pleiadi kernel:  inactive_file:10413 unevictable:0 dirty:63 writeback:0 unstable:0
Feb  5 10:10:29 Pleiadi kernel:  free:293 slab:3462 mapped:476 pagetables:280 bounce:0
Feb  5 10:10:29 Pleiadi kernel: DMA free:628kB min:156kB low:192kB high:232kB active_anon:2644kB inactive_anon:2932kB active_file:3508kB inactive_file:2928kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 142 142
Feb  5 10:10:29 Pleiadi kernel: Normal free:544kB min:1448kB low:1808kB high:2172kB active_anon:35484kB inactive_anon:35592kB active_file:17584kB inactive_file:38724kB unevictable:0kB present:146304kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 0 0
Feb  5 10:10:29 Pleiadi kernel: DMA: 19*4kB 3*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 628kB
Feb  5 10:10:29 Pleiadi kernel: Normal: 20*4kB 40*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB
Feb  5 10:10:29 Pleiadi kernel: 16671 total pagecache pages
Feb  5 10:10:29 Pleiadi kernel: 952 pages in swap cache
Feb  5 10:10:29 Pleiadi kernel: Swap cache stats: add 3777, delete 2825, find 1321/1610
Feb  5 10:10:29 Pleiadi kernel: Free swap  = 143916kB
Feb  5 10:10:29 Pleiadi kernel: Total swap = 151160kB
Feb  5 10:10:29 Pleiadi kernel: 40960 pages RAM
Feb  5 10:10:29 Pleiadi kernel: 1127 pages reserved
Feb  5 10:10:29 Pleiadi kernel: 11955 pages shared
Feb  5 10:10:29 Pleiadi kernel: 32130 pages non-shared
Feb  5 10:10:29 Pleiadi kernel: klogd: page allocation failure. order:0, mode:0x4020
Feb  5 10:10:29 Pleiadi kernel: Pid: 407, comm: klogd Not tainted 2.6.28.3 #1
Feb  5 10:10:29 Pleiadi kernel: Call Trace:
Feb  5 10:10:29 Pleiadi kernel:  [<c01350a7>] __alloc_pages_internal+0x325/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0148c4f>] allocate_slab+0x55/0xa4
Feb  5 10:10:29 Pleiadi kernel:  [<c0148cd6>] new_slab+0x1f/0x108
Feb  5 10:10:29 Pleiadi kernel:  [<c01490ca>] __slab_alloc+0x86/0xf0
Feb  5 10:10:29 Pleiadi kernel:  [<c014a174>] __kmalloc_track_caller+0x6a/0xb5
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c02476ad>] __alloc_skb+0x46/0xef
Feb  5 10:10:29 Pleiadi kernel:  [<c024776a>] __netdev_alloc_skb+0x14/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<ca82e465>] boomerang_rx+0x34a/0x45a [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<ca82dbf6>] boomerang_interrupt+0x103/0x35f [3c59x]
Feb  5 10:10:29 Pleiadi kernel:  [<c012f0c9>] handle_IRQ_event+0x1a/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c012fd38>] handle_level_irq+0x50/0x85
Feb  5 10:10:29 Pleiadi kernel:  [<c01046f9>] do_IRQ+0x55/0x6c
Feb  5 10:10:29 Pleiadi kernel:  [<c0103593>] common_interrupt+0x23/0x28
Feb  5 10:10:29 Pleiadi kernel:  [<c011252e>] try_to_wake_up+0x85/0x90
Feb  5 10:10:29 Pleiadi kernel:  [<c01c3394>] xfsbufd_wakeup+0x2b/0x39
Feb  5 10:10:29 Pleiadi kernel:  [<c013815e>] shrink_slab+0x69/0x178
Feb  5 10:10:29 Pleiadi kernel:  [<c01396f5>] do_try_to_free_pages+0xf4/0x1d2
Feb  5 10:10:29 Pleiadi kernel:  [<c0139839>] try_to_free_pages+0x66/0x6e
Feb  5 10:10:29 Pleiadi kernel:  [<c0138b6e>] isolate_pages_global+0x0/0x47
Feb  5 10:10:29 Pleiadi kernel:  [<c0134f53>] __alloc_pages_internal+0x1d1/0x337
Feb  5 10:10:29 Pleiadi kernel:  [<c0246b4f>] sock_def_readable+0x1d/0x3f
Feb  5 10:10:29 Pleiadi kernel:  [<c01441a2>] read_swap_cache_async+0x32/0xa5
Feb  5 10:10:29 Pleiadi kernel:  [<c014424d>] swapin_readahead+0x38/0x6b
Feb  5 10:10:29 Pleiadi kernel:  [<c013d4c9>] do_swap_page+0x57/0x1e2
Feb  5 10:10:29 Pleiadi kernel:  [<c013db4d>] handle_mm_fault+0xdb/0x13a
Feb  5 10:10:29 Pleiadi kernel:  [<c010d1f7>] do_page_fault+0x161/0x3ea
Feb  5 10:10:29 Pleiadi kernel:  [<c010d096>] do_page_fault+0x0/0x3ea
Feb  5 10:10:29 Pleiadi kernel:  [<c02af20a>] error_code+0x6a/0x70
Feb  5 10:10:29 Pleiadi kernel:  [<c0115927>] do_syslog+0x15a/0x30e
Feb  5 10:10:29 Pleiadi kernel:  [<c0122d56>] autoremove_wake_function+0x0/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c0122d56>] autoremove_wake_function+0x0/0x2d
Feb  5 10:10:29 Pleiadi kernel:  [<c017817c>] kmsg_read+0x0/0x36
Feb  5 10:10:29 Pleiadi kernel:  [<c0172d61>] proc_reg_read+0x35/0x48
Feb  5 10:10:29 Pleiadi kernel:  [<c014c90b>] vfs_read+0x7f/0xe5
Feb  5 10:10:29 Pleiadi kernel:  [<c014cb8b>] sys_read+0x3c/0x62
Feb  5 10:10:29 Pleiadi kernel:  [<c0102aae>] syscall_call+0x7/0xb
Feb  5 10:10:29 Pleiadi kernel:  [<c02a0000>] copy_templates+0x5a/0xbf
Feb  5 10:10:29 Pleiadi kernel: Mem-Info:
Feb  5 10:10:29 Pleiadi kernel: DMA per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
Feb  5 10:10:29 Pleiadi kernel: Normal per-cpu:
Feb  5 10:10:29 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  47
Feb  5 10:10:29 Pleiadi kernel: Active_anon:9532 active_file:5273 inactive_anon:9631
Feb  5 10:10:29 Pleiadi kernel:  inactive_file:10413 unevictable:0 dirty:63 writeback:0 unstable:0
Feb  5 10:10:29 Pleiadi kernel:  free:293 slab:3462 mapped:476 pagetables:280 bounce:0
Feb  5 10:10:29 Pleiadi kernel: DMA free:628kB min:156kB low:192kB high:232kB active_anon:2644kB inactive_anon:2932kB active_file:3508kB inactive_file:2928kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 142 142
Feb  5 10:10:29 Pleiadi kernel: Normal free:544kB min:1448kB low:1808kB high:2172kB active_anon:35484kB inactive_anon:35592kB active_file:17584kB inactive_file:38724kB unevictable:0kB present:146304kB pages_scanned:0 all_unreclaimable? no
Feb  5 10:10:29 Pleiadi kernel: lowmem_reserve[]: 0 0 0
Feb  5 10:10:29 Pleiadi kernel: DMA: 19*4kB 3*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 628kB
Feb  5 10:10:29 Pleiadi kernel: Normal: 20*4kB 40*8kB 1*16kB 0*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 544kB
Feb  5 10:10:29 Pleiadi kernel: 16671 total pagecache pages
Feb  5 10:10:29 Pleiadi kernel: 952 pages in swap cache
Feb  5 10:10:29 Pleiadi kernel: Swap cache stats: add 3777, delete 2825, find 1321/1610
Feb  5 10:10:29 Pleiadi kernel: Free swap  = 143916kB
Feb  5 10:10:29 Pleiadi kernel: Total swap = 151160kB
Feb  5 10:10:29 Pleiadi kernel: 40960 pages RAM
Feb  5 10:10:29 Pleiadi kernel: 1127 pages reserved
Feb  5 10:10:29 Pleiadi kernel: 11955 pages shared
Feb  5 10:10:29 Pleiadi kernel: 32130 pages non-shared

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28
# Tue Jan 13 09:13:10 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_CLASSIC_RCU=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
CONFIG_MPENTIUMII=y
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
# CONFIG_NF_CONNTRACK_IRC is not set
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SIP=m
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
# CONFIG_NF_NAT_SNMP_BASIC is not set
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_FTP=m
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_RFKILL is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# A new alternative FireWire stack is available with EXPERIMENTAL=y
#
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=m
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_PCBC is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=m
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=m
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

