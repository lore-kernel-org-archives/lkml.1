Return-Path: <linux-kernel-owner+w=401wt.eu-S1764453AbXHNPmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764453AbXHNPmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764483AbXHNPlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:41:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:35905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764658AbXHNPle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:41:34 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX187TWgfJ5U7LYb9ihs+lg/ypJm7SsKG1K7JeDs+SH
	MxVuCZBdIVpJaQ
Date: Tue, 14 Aug 2007 17:41:26 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Subject: 2.6.23-rc3 Suspend troubles within Xorg
Message-Id: <20070814174126.86e9ea7d.delist@gmx.net>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

<sry, quite long mail>

Troubles STR (STD not tried) here on a thinkpad T20 with 2.6.23-rc3.
Happens if echo mem > /s/p/state or doing it in a script after
unloading madwifi and snd-cs46xx modules (as they have never ever been
able to suspend properly) _inside_ an xsession. If I switch to console
beforehand STR works well.

Inside X STR switches to console and hangs there about 7-10 secs at
"Stopping tasks..." then the error below appears and looks like it
takes a second try "Stopping tasks..." w/o success. Last known good is
2.6.22.2(-ck1).

Regards,
ritch

<  long kern.log bootup & error ahead  >
Aug 14 16:48:04 tp kernel: Linux version 2.6.23-rc3 (root@tp) (gcc version 4.1.3 20070629 (prerelease) (Debian 4.1.2-13)) #1 Tue Aug 14 16:25:53 CEST 2007
Aug 14 16:48:04 tp kernel: BIOS-provided physical RAM map:
Aug 14 16:48:04 tp kernel:  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Aug 14 16:48:04 tp kernel:  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Aug 14 16:48:04 tp kernel:  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Aug 14 16:48:04 tp kernel:  BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
Aug 14 16:48:04 tp kernel:  BIOS-e820: 000000000fff0000 - 000000000fffec00 (ACPI data)
Aug 14 16:48:04 tp kernel:  BIOS-e820: 000000000fffec00 - 0000000010000000 (ACPI NVS)
Aug 14 16:48:04 tp kernel:  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Aug 14 16:48:04 tp kernel: 255MB LOWMEM available.
Aug 14 16:48:04 tp kernel: Entering add_active_range(0, 0, 65520) 0 entries of 256 used
Aug 14 16:48:04 tp kernel: Zone PFN ranges:
Aug 14 16:48:04 tp kernel:   DMA             0 ->     4096
Aug 14 16:48:04 tp kernel:   Normal       4096 ->    65520
Aug 14 16:48:04 tp kernel: Movable zone start PFN for each node
Aug 14 16:48:04 tp kernel: early_node_map[1] active PFN ranges
Aug 14 16:48:04 tp kernel:     0:        0 ->    65520
Aug 14 16:48:04 tp kernel: On node 0 totalpages: 65520
Aug 14 16:48:04 tp kernel:   DMA zone: 32 pages used for memmap
Aug 14 16:48:04 tp kernel:   DMA zone: 0 pages reserved
Aug 14 16:48:04 tp kernel:   DMA zone: 4064 pages, LIFO batch:0
Aug 14 16:48:04 tp kernel:   Normal zone: 479 pages used for memmap
Aug 14 16:48:04 tp kernel:   Normal zone: 60945 pages, LIFO batch:15
Aug 14 16:48:04 tp kernel:   Movable zone: 0 pages used for memmap
Aug 14 16:48:04 tp kernel: DMI 2.3 present.
Aug 14 16:48:04 tp kernel: ACPI: RSDP 000F7170, 0014 (r0 PTLTD )
Aug 14 16:48:04 tp kernel: ACPI: RSDT 0FFF4E36, 002C (r1 PTLTD    RSDT    6041220  LTP        0)
Aug 14 16:48:04 tp kernel: ACPI: FACP 0FFFEB65, 0074 (r1 IBM    TP-T20    6041220             0)
Aug 14 16:48:04 tp kernel: ACPI: DSDT 0FFF4E62, 9D03 (r1 IBM    TP-T20    6041220 MSFT  100000C)
Aug 14 16:48:04 tp kernel: ACPI: FACS 0FFFF000, 0040
Aug 14 16:48:04 tp kernel: ACPI: BOOT 0FFFEBD9, 0027 (r1 PTLTD  $SBFTBL$  6041220  LTP        1)
Aug 14 16:48:04 tp kernel: ACPI: PM-Timer IO Port: 0x1008
Aug 14 16:48:04 tp kernel: Allocating PCI resources starting at 20000000 (gap: 10000000:eff80000)
Aug 14 16:48:04 tp kernel: swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
Aug 14 16:48:04 tp kernel: swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
Aug 14 16:48:04 tp kernel: swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
Aug 14 16:48:04 tp kernel: Built 1 zonelists in Zone order.  Total pages: 65009
Aug 14 16:48:04 tp kernel: Kernel command line: root=/dev/hda3 ro vga=5 resume=/dev/hda6
Aug 14 16:48:04 tp kernel: Enabling fast FPU save and restore... done.
Aug 14 16:48:04 tp kernel: Enabling unmasked SIMD FPU exception support... done.
Aug 14 16:48:04 tp kernel: Initializing CPU#0
Aug 14 16:48:04 tp kernel: PID hash table entries: 1024 (order: 10, 4096 bytes)
Aug 14 16:48:04 tp kernel: Detected 697.013 MHz processor.
Aug 14 16:48:04 tp kernel: Console: colour VGA+ 80x34
Aug 14 16:48:04 tp kernel: console [tty0] enabled
Aug 14 16:48:04 tp kernel: Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Aug 14 16:48:04 tp kernel: Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Aug 14 16:48:04 tp kernel: Memory: 256268k/262080k available (2029k kernel code, 5312k reserved, 670k data, 152k init, 0k highmem)
Aug 14 16:48:04 tp kernel: virtual kernel memory layout:
Aug 14 16:48:04 tp kernel:     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
Aug 14 16:48:04 tp kernel:     vmalloc : 0xd0800000 - 0xffff4000   ( 759 MB)
Aug 14 16:48:04 tp kernel:     lowmem  : 0xc0000000 - 0xcfff0000   ( 255 MB)
Aug 14 16:48:04 tp kernel:       .init : 0xc03a6000 - 0xc03cc000   ( 152 kB)
Aug 14 16:48:04 tp kernel:       .data : 0xc02fb4f4 - 0xc03a2e04   ( 670 kB)
Aug 14 16:48:04 tp kernel:       .text : 0xc0100000 - 0xc02fb4f4   (2029 kB)
Aug 14 16:48:04 tp kernel: Checking if this processor honours the WP bit even in supervisor mode... Ok.
Aug 14 16:48:04 tp kernel: SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Aug 14 16:48:04 tp kernel: Calibrating delay using timer specific routine.. 1394.73 BogoMIPS (lpj=6973685)
Aug 14 16:48:04 tp kernel: Mount-cache hash table entries: 512
Aug 14 16:48:04 tp kernel: CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
Aug 14 16:48:04 tp kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Aug 14 16:48:04 tp kernel: CPU: L2 cache: 256K
Aug 14 16:48:04 tp kernel: CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
Aug 14 16:48:04 tp kernel: Compat vDSO mapped to ffffe000.
Aug 14 16:48:04 tp kernel: CPU: Intel Pentium III (Coppermine) stepping 06
Aug 14 16:48:04 tp kernel: Checking 'hlt' instruction... OK.
Aug 14 16:48:04 tp kernel: ACPI: Core revision 20070126
Aug 14 16:48:04 tp kernel: ACPI: setting ELCR to 0200 (from 0c28)
Aug 14 16:48:04 tp kernel: NET: Registered protocol family 16
Aug 14 16:48:04 tp kernel: ACPI: bus type pci registered
Aug 14 16:48:04 tp kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=7
Aug 14 16:48:04 tp kernel: PCI: Using configuration type 1
Aug 14 16:48:04 tp kernel: Setting up standard PCI resources
Aug 14 16:48:04 tp kernel: ACPI: EC: Look up EC in DSDT
Aug 14 16:48:04 tp kernel: ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
Aug 14 16:48:04 tp kernel: ACPI: Interpreter enabled
Aug 14 16:48:04 tp kernel: ACPI: (supports S0 S1 S3)
Aug 14 16:48:04 tp kernel: ACPI: Using PIC for interrupt routing
Aug 14 16:48:04 tp kernel: ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
Aug 14 16:48:04 tp kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 14 16:48:04 tp kernel: PCI: Firmware left 0000:00:03.0 e100 interrupts enabled, disabling
Aug 14 16:48:04 tp kernel: PCI quirk: region 1000-103f claimed by PIIX4 ACPI
Aug 14 16:48:04 tp kernel: PCI quirk: region 1040-104f claimed by PIIX4 SMB
Aug 14 16:48:04 tp kernel: PIIX4 devres C PIO at 15e8-15ef
Aug 14 16:48:04 tp kernel: PIIX4 devres I PIO at 03f0-03f7
Aug 14 16:48:04 tp kernel: PIIX4 devres J PIO at 002e-002f
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 9 10 11)
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11)
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11)
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
Aug 14 16:48:04 tp kernel: ACPI: Power Resource [PSER] (off)
Aug 14 16:48:04 tp kernel: ACPI: Power Resource [PSIO] (on)
Aug 14 16:48:04 tp kernel: Linux Plug and Play Support v0.97 (c) Adam Belay
Aug 14 16:48:04 tp kernel: pnp: PnP ACPI init
Aug 14 16:48:04 tp kernel: ACPI: bus type pnp registered
Aug 14 16:48:04 tp kernel: pnp: PnP ACPI: found 15 devices
Aug 14 16:48:04 tp kernel: ACPI: ACPI bus type pnp unregistered
Aug 14 16:48:04 tp kernel: PCI: Using ACPI for IRQ routing
Aug 14 16:48:04 tp kernel: PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Aug 14 16:48:04 tp kernel: ACPI: RTC can wake from S4
Aug 14 16:48:04 tp kernel: Time: tsc clocksource has been installed.
Aug 14 16:48:04 tp kernel: pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
Aug 14 16:48:04 tp kernel: pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
Aug 14 16:48:04 tp kernel: pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
Aug 14 16:48:04 tp kernel: pnp: 00:00: iomem range 0xc8000-0xcbfff could not be reserved
Aug 14 16:48:04 tp kernel: pnp: 00:02: ioport range 0x1000-0x103f has been reserved
Aug 14 16:48:04 tp kernel: pnp: 00:02: ioport range 0x1040-0x104f has been reserved
Aug 14 16:48:04 tp kernel: pnp: 00:02: ioport range 0xfe00-0xfe0f has been reserved
Aug 14 16:48:04 tp kernel: pnp: 00:09: ioport range 0x15e0-0x15ef has been reserved
Aug 14 16:48:04 tp kernel: PCI: Bridge: 0000:00:01.0
Aug 14 16:48:04 tp kernel:   IO window: disabled.
Aug 14 16:48:04 tp kernel:   MEM window: f0000000-f7ffffff
Aug 14 16:48:04 tp kernel:   PREFETCH window: 30000000-300fffff
Aug 14 16:48:04 tp kernel: PCI: Bus 2, cardbus bridge: 0000:00:02.0
Aug 14 16:48:04 tp kernel:   IO window: 00001400-000014ff
Aug 14 16:48:04 tp kernel:   IO window: 00001c00-00001cff
Aug 14 16:48:04 tp kernel:   PREFETCH window: 20000000-23ffffff
Aug 14 16:48:04 tp kernel:   MEM window: 24000000-27ffffff
Aug 14 16:48:04 tp kernel: PCI: Bus 6, cardbus bridge: 0000:00:02.1
Aug 14 16:48:04 tp kernel:   IO window: 00002000-000020ff
Aug 14 16:48:04 tp kernel:   IO window: 00002400-000024ff
Aug 14 16:48:04 tp kernel:   PREFETCH window: 28000000-2bffffff
Aug 14 16:48:04 tp kernel:   MEM window: 2c000000-2fffffff
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 3
Aug 14 16:48:04 tp kernel: PCI: setting IRQ 3 as level-triggered
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 3 (level, low) -> IRQ 3
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
Aug 14 16:48:04 tp kernel: PCI: setting IRQ 5 as level-triggered
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LNKB] -> GSI 5 (level, low) -> IRQ 5
Aug 14 16:48:04 tp kernel: NET: Registered protocol family 2
Aug 14 16:48:04 tp kernel: IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
Aug 14 16:48:04 tp kernel: TCP established hash table entries: 8192 (order: 4, 65536 bytes)
Aug 14 16:48:04 tp kernel: TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
Aug 14 16:48:04 tp kernel: TCP: Hash tables configured (established 8192 bind 8192)
Aug 14 16:48:04 tp kernel: TCP reno registered
Aug 14 16:48:04 tp kernel: Simple Boot Flag at 0x35 set to 0x1
Aug 14 16:48:04 tp kernel: io scheduler noop registered
Aug 14 16:48:04 tp kernel: io scheduler anticipatory registered
Aug 14 16:48:04 tp kernel: io scheduler cfq registered (default)
Aug 14 16:48:04 tp kernel: Limiting direct PCI/PCI transfers.
Aug 14 16:48:04 tp kernel: Boot video device is 0000:01:00.0
Aug 14 16:48:04 tp kernel: ACPI: AC Adapter [AC] (on-line)
Aug 14 16:48:04 tp kernel: ACPI: Battery Slot [BAT0] (battery present)
Aug 14 16:48:04 tp kernel: input: Power Button (FF) as /devices/virtual/input/input0
Aug 14 16:48:04 tp kernel: ACPI: Power Button (FF) [PWRF]
Aug 14 16:48:04 tp kernel: input: Lid Switch as /devices/virtual/input/input1
Aug 14 16:48:04 tp kernel: ACPI: Lid Switch [LID]
Aug 14 16:48:04 tp kernel: input: Sleep Button (CM) as /devices/virtual/input/input2
Aug 14 16:48:04 tp kernel: ACPI: Sleep Button (CM) [SLPB]
Aug 14 16:48:04 tp kernel: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Aug 14 16:48:04 tp kernel: ACPI: Processor [CPU] (supports 8 throttling states)
Aug 14 16:48:04 tp kernel: ACPI: Thermal Zone [THM0] (66 C)
Aug 14 16:48:04 tp kernel: Real Time Clock Driver v1.12ac
Aug 14 16:48:04 tp kernel: Non-volatile memory driver v1.2
Aug 14 16:48:04 tp kernel: Serial: 8250/16550 driver $Revision: 1.90 $ 1 ports, IRQ sharing disabled
Aug 14 16:48:04 tp kernel: pnp: Device 00:0c activated.
Aug 14 16:48:04 tp kernel: 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
Aug 14 16:48:04 tp kernel: PCI: setting IRQ 10 as level-triggered
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
Aug 14 16:48:04 tp kernel: Couldn't register serial port 0000:00:03.1: -28
Aug 14 16:48:04 tp kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Aug 14 16:48:04 tp kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Aug 14 16:48:04 tp kernel: PIIX4: IDE controller at PCI slot 0000:00:07.1
Aug 14 16:48:04 tp kernel: PIIX4: chipset revision 1
Aug 14 16:48:04 tp kernel: PIIX4: not 100% native mode: will probe irqs later
Aug 14 16:48:04 tp kernel:     ide0: BM-DMA at 0x1850-0x1857, BIOS settings: hda:DMA, hdb:pio
Aug 14 16:48:04 tp kernel:     ide1: BM-DMA at 0x1858-0x185f, BIOS settings: hdc:DMA, hdd:pio
Aug 14 16:48:04 tp kernel: Probing IDE interface ide0...
Aug 14 16:48:04 tp kernel: Marking TSC unstable due to: possible TSC halt in C2.
Aug 14 16:48:04 tp kernel: Time: acpi_pm clocksource has been installed.
Aug 14 16:48:04 tp kernel: Switched to high resolution mode on CPU 0
Aug 14 16:48:04 tp kernel: hda: SAMSUNG MP0402H, ATA DISK drive
Aug 14 16:48:04 tp kernel: Clocksource tsc unstable (delta = -499205651 ns)
Aug 14 16:48:04 tp kernel: hda: selected mode 0x42
Aug 14 16:48:04 tp kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Aug 14 16:48:04 tp kernel: Probing IDE interface ide1...
Aug 14 16:48:04 tp kernel: hdc: TOSHIBA DVD-ROM SD-C2302, ATAPI CD/DVD-ROM drive
Aug 14 16:48:04 tp kernel: hdc: selected mode 0x42
Aug 14 16:48:04 tp kernel: ide1 at 0x170-0x177,0x376 on irq 15
Aug 14 16:48:04 tp kernel: hda: max request size: 512KiB
Aug 14 16:48:04 tp kernel: hda: 78242976 sectors (40060 MB) w/8192KiB Cache, CHS=16383/255/63, UDMA(33)
Aug 14 16:48:04 tp kernel: hda: cache flushes supported
Aug 14 16:48:04 tp kernel:  hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 >
Aug 14 16:48:04 tp kernel: Yenta: CardBus bridge found at 0000:00:02.0 [1014:0130]
Aug 14 16:48:04 tp kernel: Yenta: Using INTVAL to route CSC interrupts to PCI
Aug 14 16:48:04 tp kernel: Yenta: Routing CardBus interrupts to PCI
Aug 14 16:48:04 tp kernel: Yenta TI: socket 0000:00:02.0, mfunc 0x00001000, devctl 0x66
Aug 14 16:48:04 tp kernel: Yenta: ISA IRQ mask 0x0890, PCI irq 3
Aug 14 16:48:04 tp kernel: Socket status: 30000006
Aug 14 16:48:04 tp kernel: Yenta: CardBus bridge found at 0000:00:02.1 [1014:0130]
Aug 14 16:48:04 tp kernel: Yenta: Using INTVAL to route CSC interrupts to PCI
Aug 14 16:48:04 tp kernel: Yenta: Routing CardBus interrupts to PCI
Aug 14 16:48:04 tp kernel: Yenta TI: socket 0000:00:02.1, mfunc 0x00001000, devctl 0x66
Aug 14 16:48:04 tp kernel: Yenta: ISA IRQ mask 0x0890, PCI irq 5
Aug 14 16:48:04 tp kernel: Socket status: 30000020
Aug 14 16:48:04 tp kernel: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Aug 14 16:48:04 tp kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 14 16:48:04 tp kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 14 16:48:04 tp kernel: mice: PS/2 mouse device common for all mice
Aug 14 16:48:04 tp kernel: input: PC Speaker as /devices/platform/pcspkr/input/input3
Aug 14 16:48:04 tp kernel: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Aug 14 16:48:04 tp kernel: Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
Aug 14 16:48:04 tp kernel: ALSA device list:
Aug 14 16:48:04 tp kernel:   No soundcards found.
Aug 14 16:48:04 tp kernel: nf_conntrack version 0.5.0 (4096 buckets, 16384 max)
Aug 14 16:48:04 tp kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Aug 14 16:48:04 tp kernel: TCP cubic registered
Aug 14 16:48:04 tp kernel: NET: Registered protocol family 1
Aug 14 16:48:04 tp kernel: NET: Registered protocol family 17
Aug 14 16:48:04 tp kernel: Using IPI Shortcut mode
Aug 14 16:48:04 tp kernel: ReiserFS: hda3: found reiserfs format "3.6" with standard journal
Aug 14 16:48:04 tp kernel: ReiserFS: hda3: using ordered data mode
Aug 14 16:48:04 tp kernel: ReiserFS: hda3: journal params: device hda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 14 16:48:04 tp kernel: ReiserFS: hda3: checking transaction log (hda3)
Aug 14 16:48:04 tp kernel: ReiserFS: hda3: Using r5 hash to sort names
Aug 14 16:48:04 tp kernel: VFS: Mounted root (reiserfs filesystem) readonly.
Aug 14 16:48:04 tp kernel: Freeing unused kernel memory: 152k freed
Aug 14 16:48:04 tp kernel: pccard: CardBus card inserted into slot 1
Aug 14 16:48:04 tp kernel: Linux agpgart interface v0.102
Aug 14 16:48:04 tp kernel: e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
Aug 14 16:48:04 tp kernel: e100: Copyright(c) 1999-2006 Intel Corporation
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
Aug 14 16:48:04 tp kernel: ath_hal: module license 'Proprietary' taints kernel.
Aug 14 16:48:04 tp kernel: ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133)
Aug 14 16:48:04 tp kernel: usbcore: registered new interface driver usbfs
Aug 14 16:48:04 tp kernel: usbcore: registered new interface driver hub
Aug 14 16:48:04 tp kernel: usbcore: registered new device driver usb
Aug 14 16:48:04 tp kernel: wlan: 0.8.4.2 (svn r2652)
Aug 14 16:48:04 tp kernel: Floppy drive(s): fd0 is 1.44M
Aug 14 16:48:04 tp kernel: FDC 0 is a National Semiconductor PC87306
Aug 14 16:48:04 tp kernel: USB Universal Host Controller Interface driver v3.0
Aug 14 16:48:04 tp kernel: cs: IO port probe 0x100-0x3af: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
Aug 14 16:48:04 tp kernel: cs: IO port probe 0x820-0x8ff: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0xc00-0xcf7: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0xa00-0xaff: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0x100-0x3af: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
Aug 14 16:48:04 tp kernel: cs: IO port probe 0x820-0x8ff: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0xc00-0xcf7: clean.
Aug 14 16:48:04 tp kernel: cs: IO port probe 0xa00-0xaff: clean.
Aug 14 16:48:04 tp kernel: ath_pci: 0.9.4.5 (svn r2652)
Aug 14 16:48:04 tp kernel: hda: selected mode 0x42
Aug 14 16:48:04 tp kernel: ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
Aug 14 16:48:04 tp kernel: e100: eth0: e100_probe: addr 0xe8120000, irq 10, MAC addr 00:03:47:1F:C2:55
Aug 14 16:48:04 tp kernel: agpgart: Detected an Intel 440BX Chipset.
Aug 14 16:48:04 tp kernel: agpgart: AGP aperture is 64M @ 0xf8000000
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Aug 14 16:48:04 tp kernel: PCI: setting IRQ 11 as level-triggered
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
Aug 14 16:48:04 tp kernel: uhci_hcd 0000:00:07.2: UHCI Host Controller
Aug 14 16:48:04 tp kernel: uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
Aug 14 16:48:04 tp kernel: uhci_hcd 0000:00:07.2: irq 11, io base 0x00001860
Aug 14 16:48:04 tp kernel: usb usb1: configuration #1 chosen from 1 choice
Aug 14 16:48:04 tp kernel: hub 1-0:1.0: USB hub found
Aug 14 16:48:04 tp kernel: hub 1-0:1.0: 2 ports detected
Aug 14 16:48:04 tp kernel: hda: cache flushes supported
Aug 14 16:48:04 tp kernel: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Aug 14 16:48:04 tp kernel: PCI: Enabling device 0000:06:00.0 (0000 -> 0002)
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [LNKB] -> GSI 5 (level, low) -> IRQ 5
Aug 14 16:48:04 tp kernel: ath_pci: switching rfkill capability off
Aug 14 16:48:04 tp kernel: input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input5
Aug 14 16:48:04 tp kernel: ath_rate_onoe: 1.0 (svn r2652)
Aug 14 16:48:04 tp kernel: ath_pci: switching per-packet transmit power control off
Aug 14 16:48:04 tp kernel: wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
Aug 14 16:48:04 tp kernel: wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Aug 14 16:48:04 tp kernel: wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
Aug 14 16:48:04 tp kernel: wifi0: H/W encryption support: WEP AES AES_CCM TKIP
Aug 14 16:48:04 tp kernel: wifi0: mac 5.9 phy 4.3 radio 4.6
Aug 14 16:48:04 tp kernel: wifi0: Use hw queue 1 for WME_AC_BE traffic
Aug 14 16:48:04 tp kernel: wifi0: Use hw queue 0 for WME_AC_BK traffic
Aug 14 16:48:04 tp kernel: wifi0: Use hw queue 2 for WME_AC_VI traffic
Aug 14 16:48:04 tp kernel: wifi0: Use hw queue 3 for WME_AC_VO traffic
Aug 14 16:48:04 tp kernel: wifi0: Use hw queue 8 for CAB traffic
Aug 14 16:48:04 tp kernel: wifi0: Use hw queue 9 for beacons
Aug 14 16:48:04 tp kernel: wifi0: Atheros 5212: mem=0x2c000000, irq=5
Aug 14 16:48:04 tp kernel: ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LNKA] -> GSI 3 (level, low) -> IRQ 3
Aug 14 16:48:04 tp kernel: Activating CLKRUN hack for Thinkpad.
Aug 14 16:48:04 tp kernel: cs46xx: failure waiting for FIFO command to complete
Aug 14 16:48:04 tp kernel: gameport: CS46xx Gameport is pci0000:00:05.0/gameport0, speed 1807kHz
Aug 14 16:48:04 tp kernel: hda: selected mode 0x42
Aug 14 16:48:04 tp kernel: hda: cache flushes supported
Aug 14 16:48:04 tp kernel: Adding 417680k swap on /dev/hda6.  Priority:-1 extents:1 across:417680k
Aug 14 16:48:04 tp kernel: thinkpad_acpi: ThinkPad ACPI Extras v0.15
Aug 14 16:48:04 tp kernel: thinkpad_acpi: http://ibm-acpi.sf.net/
Aug 14 16:48:04 tp kernel: thinkpad_acpi: ThinkPad BIOS IYET61WW (1.22 ), EC unknown
Aug 14 16:48:04 tp kernel: input: ThinkPad Extra Buttons as /devices/virtual/input/input6
Aug 14 16:48:04 tp kernel: kjournald starting.  Commit interval 5 seconds
Aug 14 16:48:04 tp kernel: EXT3 FS on hda1, internal journal
Aug 14 16:48:04 tp kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug 14 16:48:04 tp kernel: ReiserFS: hda5: found reiserfs format "3.6" with standard journal
Aug 14 16:48:04 tp kernel: ReiserFS: hda5: using ordered data mode
Aug 14 16:48:04 tp kernel: ReiserFS: hda5: journal params: device hda5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 14 16:48:04 tp kernel: ReiserFS: hda5: checking transaction log (hda5)
Aug 14 16:48:04 tp kernel: ReiserFS: hda5: Using r5 hash to sort names
Aug 14 16:48:04 tp kernel: ReiserFS: hda8: found reiserfs format "3.6" with standard journal
Aug 14 16:48:04 tp kernel: ReiserFS: hda8: using ordered data mode
Aug 14 16:48:04 tp kernel: ReiserFS: hda8: journal params: device hda8, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 14 16:48:04 tp kernel: ReiserFS: hda8: checking transaction log (hda8)
Aug 14 16:48:04 tp kernel: ReiserFS: hda8: Using r5 hash to sort names
Aug 14 16:48:04 tp kernel: ReiserFS: hda7: found reiserfs format "3.6" with standard journal
Aug 14 16:48:04 tp kernel: ReiserFS: hda7: using ordered data mode
Aug 14 16:48:04 tp kernel: ReiserFS: hda7: journal params: device hda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
Aug 14 16:48:04 tp kernel: ReiserFS: hda7: checking transaction log (hda7)
Aug 14 16:48:04 tp kernel: ReiserFS: hda7: Using r5 hash to sort names
Aug 14 16:48:04 tp kernel: IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Aug 14 16:48:09 tp kernel: NET: Registered protocol family 10
Aug 14 16:48:09 tp kernel: lo: Disabled Privacy Extensions
Aug 14 16:48:09 tp kernel: ADDRCONF(NETDEV_UP): eth0: link is not ready
Aug 14 16:48:16 tp kernel: [drm] Initialized drm 1.1.0 20060810
Aug 14 16:48:16 tp kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 3 (level, low) -> IRQ 3
Aug 14 16:48:16 tp kernel: [drm] Initialized savage 2.4.1 20050313 on minor 0
Aug 14 16:48:16 tp kernel: mtrr: base(0xf2000000) is not aligned on a size(0x5000000) boundary
Aug 14 16:48:19 tp kernel: ath0: no IPv6 routers present
Aug 14 16:49:38 tp kernel: Stopping tasks ... 1>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c013e9d0>] filemap_fault+0x0/0x3d0
Aug 14 16:49:38 tp kernel:  [<c0148413>] handle_mm_fault+0xe3/0x590
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c016680d>] sys_select+0x4d/0x1c0
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: dbus-daemon   D 00000003     0  2316      1
Aug 14 16:49:38 tp kernel:        cb819eb0 00200086 0000000a 00000003 00000000 00000000 080a3820 428edff4 
Aug 14 16:49:38 tp kernel:        cb819f10 c0136c65 bf90a160 c012147a 00000001 0000000c 00000001 0000000e 
Aug 14 16:49:38 tp kernel:        cb819fb8 cb819f90 ce796484 bf90a160 080a3820 428edff4 cb819fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0159efe>] rw_copy_check_uvector+0x7e/0x100
Aug 14 16:49:38 tp kernel:  [<c015a840>] do_readv_writev+0x120/0x190
Aug 14 16:49:38 tp kernel:  [<c028d000>] sock_aio_write+0x0/0x110
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gconfd-2      D 00000007     0  2318      1
Aug 14 16:49:38 tp kernel:        cb7c5eb0 00200086 0000001b 00000007 00000000 00000000 00003c30 428edff4 
Aug 14 16:49:38 tp kernel:        cb7c5f10 c0136c65 0824c720 c012147a 00000003 0000000f 00000003 00000010 
Aug 14 16:49:38 tp kernel:        cb7c5fb8 cb7c5f90 ce797944 0824c720 00003c30 428edff4 cb7c5fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-keyring D 00000003     0  2321      1
Aug 14 16:49:38 tp kernel:        cafbfeb0 00200082 00000003 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:49:38 tp kernel:        cafbff10 c0136c65 080634e8 c012147a ce7ead80 cadfe4c4 ce7eacec 00000000 
Aug 14 16:49:38 tp kernel:        cafbffb8 cafbff90 cce2f944 080634e8 ffffffff 428edff4 cafbffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c013e9d0>] filemap_fault+0x0/0x3d0
Aug 14 16:49:38 tp kernel:  [<c0148413>] handle_mm_fault+0xe3/0x590
Aug 14 16:49:38 tp kernel:  [<c0111c2b>] do_page_fault+0x18b/0x6b0
Aug 14 16:49:38 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-setting D 00000016     0  2323      1
Aug 14 16:49:38 tp kernel:        cafdfeb0 00200086 00000009 00000016 00000000 00000000 ffffffff 428edff4 
Aug 14 16:49:38 tp kernel:        cafdff10 c0136c65 081a1b08 c012147a 00000003 0000000f 00000003 00000010 
Aug 14 16:49:38 tp kernel:        cafdffb8 cafdff90 ce796ee4 081a1b08 ffffffff 428edff4 cafdffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c0164faf>] do_ioctl+0x1f/0x70
Aug 14 16:49:38 tp kernel:  [<c016505c>] vfs_ioctl+0x5c/0x250
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-setting D fffffe00     0  2325      1
Aug 14 16:49:38 tp kernel:        ca9d9eb0 00200086 00000000 fffffe00 00000000 00000000 42a25b70 4d72aa50 
Aug 14 16:49:38 tp kernel:        ca9d9f10 c0136c65 00000011 c012147a ca9d9ed8 ca9d9f60 ca98af80 c015a286 
Aug 14 16:49:38 tp kernel:        ca9d9fb8 ca9d9f90 cf065e74 00000011 42a25b70 4d72aa50 ca9d9fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c01080fc>] convert_fxsr_from_user+0x1c/0xf0
Aug 14 16:49:38 tp kernel:  [<c015ab31>] vfs_read+0xa1/0x130
Aug 14 16:49:38 tp kernel:  [<c015a1c0>] do_sync_read+0x0/0x110
Aug 14 16:49:38 tp kernel:  [<c015af68>] sys_read+0x68/0x70
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: metacity      D 00000003     0  2332   2262
Aug 14 16:49:38 tp kernel:        ca52feb0 00200082 00000007 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:49:38 tp kernel:        ca52ff10 c0136c65 0810fb00 c012147a 00000003 0000000c 00000001 0000000d 
Aug 14 16:49:38 tp kernel:        ca52ffb8 ca52ff90 ce3ff414 0810fb00 ffffffff 428edff4 ca52ffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c01204f4>] __group_send_sig_info+0x54/0x90
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c011af92>] it_real_fn+0x12/0x20
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c0164faf>] do_ioctl+0x1f/0x70
Aug 14 16:49:38 tp kernel:  [<c016505c>] vfs_ioctl+0x5c/0x250
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: nautilus      D 00000004     0  2335   2262
Aug 14 16:49:38 tp kernel:        ca617eb0 00000086 0000000d 00000004 00000000 00000000 00000e9d 428edff4 
Aug 14 16:49:38 tp kernel:        ca617f10 c0136c65 0831f0d0 c012147a 00000003 0000000c 00000003 0000000d 
Aug 14 16:49:38 tp kernel:        ca617fb8 ca617f90 ca6129b4 0831f0d0 00000e9d 428edff4 ca617fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c0163d04>] __user_walk+0x14/0x20
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c014a701>] remove_vma+0x41/0x50
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-panel   D 00000003     0  2336   2262
Aug 14 16:49:38 tp kernel:        ca571eb0 00000082 00000001 00000003 00000000 00000000 00000003 428edff4 
Aug 14 16:49:38 tp kernel:        ca571f10 c0136c65 080db7a8 c012147a ca571ed8 ca571f60 ca140f80 c015a286 
Aug 14 16:49:38 tp kernel:        ca571fb8 ca571f90 ca612ee4 080db7a8 00000003 428edff4 ca571fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-volume- D 00000004     0  2338      1
Aug 14 16:49:38 tp kernel:        ca0dfeb0 00200082 0000000a 00000004 00000000 00000000 00003a92 428edff4 
Aug 14 16:49:38 tp kernel:        ca0dff10 c0136c65 080a0058 c012147a 00000003 0000000c 00000003 0000000d 
Aug 14 16:49:38 tp kernel:        ca0dffb8 ca0dff90 ca613944 080a0058 00003a92 428edff4 ca0dffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0147be1>] unmap_vmas+0x281/0x450
Aug 14 16:49:38 tp kernel:  [<c0149625>] free_pgtables+0x85/0xb0
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: bonobo-activa D 00000006     0  2348      1
Aug 14 16:49:38 tp kernel:        ca3abeb0 00200082 00000002 00000006 00000000 00000000 ffffffff 428edff4 
Aug 14 16:49:38 tp kernel:        ca3abf10 c0136c65 080738b8 c012147a c12ccf80 00000000 ca3fc4d0 c014a701 
Aug 14 16:49:38 tp kernel:        ca3abfb8 ca3abf90 ca613e74 080738b8 ffffffff 428edff4 ca3abfb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c014a701>] remove_vma+0x41/0x50
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0159c39>] sys_close+0x69/0xa0
Aug 14 16:49:38 tp kernel:  [<c0163164>] do_path_lookup+0x64/0x180
Aug 14 16:49:38 tp kernel:  [<c016aa04>] dput+0x94/0x100
Aug 14 16:49:38 tp kernel:  [<c016aa04>] dput+0x94/0x100
Aug 14 16:49:38 tp kernel:  [<c015aa56>] vfs_write+0x106/0x140
Aug 14 16:49:38 tp kernel:  [<c021b3e0>] write_null+0x0/0x10
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: bonobo-activa D 0000000a     0  2354      1
Aug 14 16:49:38 tp kernel:        c9d81eb0 00200082 0000000d 0000000a 00000000 00000000 ffffffff 428edff4 
Aug 14 16:49:38 tp kernel:        c9d81f10 c0136c65 080b0f38 c012147a 00000003 00000010 00000003 00000011 
Aug 14 16:49:38 tp kernel:        c9d81fb8 c9d81f90 ce3fe484 080b0f38 ffffffff 428edff4 c9d81fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0131c08>] sys_futex+0x98/0x100
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-vfs-dae D 00000003     0  2350      1
Aug 14 16:49:38 tp kernel:        ca2f9eb0 00200082 00000008 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:49:38 tp kernel:        ca2f9f10 c0136c65 0807a418 c012147a 00000003 00000011 00000001 00000012 
Aug 14 16:49:38 tp kernel:        ca2f9fb8 ca2f9f90 cfbdf944 0807a418 ffffffff 428edff4 ca2f9fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0159efe>] rw_copy_check_uvector+0x7e/0x100
Aug 14 16:49:38 tp kernel:  [<c015a840>] do_readv_writev+0x120/0x190
Aug 14 16:49:38 tp kernel:  [<c028d000>] sock_aio_write+0x0/0x110
Aug 14 16:49:38 tp kernel:  [<c015a8ec>] vfs_writev+0x3c/0x50
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: unclutter     D 00000003     0  2355   2262
Aug 14 16:49:38 tp kernel:        c9d99eb0 00200082 00000001 00000003 00000000 00000000 00000003 428edff4 
Aug 14 16:49:38 tp kernel:        c9d99f10 c0136c65 0804c650 c012147a c9d99ed8 c9d99f60 c9d75580 c015a286 
Aug 14 16:49:38 tp kernel:        c9d99fb8 c9d99f90 ca613414 0804c650 00000003 428edff4 c9d99fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c0113712>] update_curr+0x172/0x180
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:49:38 tp kernel:  [<c016505c>] vfs_ioctl+0x5c/0x250
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: gnome-power-m D 00000003     0  2358      1
Aug 14 16:49:38 tp kernel:        c9ea9eb0 00200082 00000001 00000003 00000000 00000000 00000003 428edff4 
Aug 14 16:49:38 tp kernel:        c9ea9f10 c0136c65 080a3840 c012147a c9ea9ed8 c9ea9f60 c9e12000 c015a286 
Aug 14 16:49:38 tp kernel:        c9ea9fb8 c9ea9f90 c9e74484 080a3840 00000003 428edff4 c9ea9fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c012b2dc>] hrtimer_interrupt+0x18c/0x1e0
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: sensors-apple D 00000004     0  2375      1
Aug 14 16:49:38 tp kernel:        c901feb0 00200082 0000000a 00000004 00000000 00000000 00000bb4 428edff4 
Aug 14 16:49:38 tp kernel:        c901ff10 c0136c65 080a9a58 c012147a 00000003 0000000c 00000003 0000000e 
Aug 14 16:49:38 tp kernel:        c901ffb8 c901ff90 c97faee4 080a9a58 00000bb4 428edff4 c901ffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: multiload-app D 00000004     0  2377      1
Aug 14 16:49:38 tp kernel:        c906feb0 00200086 0000000a 00000004 00000000 00000000 0000018b 428edff4 
Aug 14 16:49:38 tp kernel:        c906ff10 c0136c65 080a4198 c012147a 00000003 0000000c 00000003 0000000e 
Aug 14 16:49:38 tp kernel:        c906ffb8 c906ff90 c97fb944 080a4198 0000018b 428edff4 c906ffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: cpufreq-apple D 00000004     0  2379      1
Aug 14 16:49:38 tp kernel:        c90bfeb0 00200082 0000000a 00000004 00000000 00000000 000003e8 428edff4 
Aug 14 16:49:38 tp kernel:        c90bff10 c0136c65 080a7840 c012147a 00000003 0000000c 00000003 0000000e 
Aug 14 16:49:38 tp kernel:        c90bffb8 c90bff90 c90bc484 080a7840 000003e8 428edff4 c90bffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0173209>] simple_read_from_buffer+0x79/0xd0
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: rxvt          D 00000000     0  2398      1
Aug 14 16:49:38 tp kernel:        c7d03eb0 00000086 c7d03e9c 00000000 00000000 00000000 00000000 00000000 
Aug 14 16:49:38 tp kernel:        c7d03f10 c0136c65 00000007 c012147a c7d03ed8 c7d03f60 c8d6c280 c015a286 
Aug 14 16:49:38 tp kernel:        c7d03fb8 c7d03f90 c92bb414 00000007 00000000 00000000 c7d03fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c016680d>] sys_select+0x4d/0x1c0
Aug 14 16:49:38 tp kernel:  [<c011f5ca>] recalc_sigpending+0xa/0x20
Aug 14 16:49:38 tp kernel:  [<c011f625>] sigprocmask+0x45/0xb0
Aug 14 16:49:38 tp kernel:  [<c012190d>] sys_rt_sigprocmask+0xad/0xd0
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: bash          D 000053dd     0  2399   2398
Aug 14 16:49:38 tp kernel:        c7869eb0 00000086 00000000 000053dd 00000000 00000000 081beb88 00000000 
Aug 14 16:49:38 tp kernel:        c7869f10 c0136c65 ffffffff c012147a 000053dd 0000fb98 00000000 c03d120c 
Aug 14 16:49:38 tp kernel:        c7869fb8 c7869f90 c92ba484 ffffffff 081beb88 00000000 c7869fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c02f909b>] __sched_text_start+0x13b/0x2e0
Aug 14 16:49:38 tp kernel:  [<c01198f2>] do_wait+0x522/0xa80
Aug 14 16:49:38 tp kernel:  [<c0113a20>] default_wake_function+0x0/0x10
Aug 14 16:49:38 tp kernel:  [<c0119e81>] sys_wait4+0x31/0x40
Aug 14 16:49:38 tp kernel:  [<c0119eb5>] sys_waitpid+0x25/0x30
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: su            D 00005a74     0  2424   2399
Aug 14 16:49:38 tp kernel:        c7581eb0 00000082 00000000 00005a74 00000000 00000000 00000979 bf8e8088 
Aug 14 16:49:38 tp kernel:        c7581f10 c0136c65 ffffffff c012147a 00005a74 0000b4e8 00000001 c03d120c 
Aug 14 16:49:38 tp kernel:        c7581fb8 c7581f90 c90bcee4 ffffffff 00000979 bf8e8088 c7581fb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c02f909b>] __sched_text_start+0x13b/0x2e0
Aug 14 16:49:38 tp kernel:  [<c01198f2>] do_wait+0x522/0xa80
Aug 14 16:49:38 tp kernel:  [<c01131ac>] update_stats_wait_end+0x8c/0xc0
Aug 14 16:49:38 tp kernel:  [<c0113a20>] default_wake_function+0x0/0x10
Aug 14 16:49:38 tp kernel:  [<c0119e81>] sys_wait4+0x31/0x40
Aug 14 16:49:38 tp kernel:  [<c0119eb5>] sys_waitpid+0x25/0x30
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel: bash          R running      0  2425   2424
Aug 14 16:49:38 tp kernel: gnome-screens D 00000003     0  2456      1
Aug 14 16:49:38 tp kernel:        c719feb0 00200082 00000008 00000003 00000000 00000000 00007530 428edff4 
Aug 14 16:49:38 tp kernel:        c719ff10 c0136c65 08092358 c012147a 00000003 0000000c 00000003 0000000d 
Aug 14 16:49:38 tp kernel:        c719ffb8 c719ff90 c9e74ee4 08092358 00007530 428edff4 c719ffb8 c0103631 
Aug 14 16:49:38 tp kernel: Call Trace:
Aug 14 16:49:38 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:49:38 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:49:38 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:49:38 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:49:38 tp kernel:  [<c01204f4>] __group_send_sig_info+0x54/0x90
Aug 14 16:49:38 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:49:38 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:49:38 tp kernel:  [<c011af92>] it_real_fn+0x12/0x20
Aug 14 16:49:38 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:49:38 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:49:38 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:49:38 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:49:38 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:49:38 tp kernel:  =======================
Aug 14 16:49:38 tp kernel:  tpb
Aug 14 16:49:38 tp kernel: Restarting tasks ... done.
Aug 14 16:50:01 tp kernel: Stopping tasks ... c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c011f5ca>] recalc_sigpending+0xa/0x20
Aug 14 16:50:01 tp kernel:  [<c0120c41>] dequeue_signal+0x51/0x140
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c013e9d0>] filemap_fault+0x0/0x3d0
Aug 14 16:50:01 tp kernel:  [<c0148413>] handle_mm_fault+0xe3/0x590
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c016680d>] sys_select+0x4d/0x1c0
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: dbus-daemon   D 00000003     0  2316      1
Aug 14 16:50:01 tp kernel:        cb819eb0 00200086 0000000a 00000003 00000000 00000000 080a3820 428edff4 
Aug 14 16:50:01 tp kernel:        cb819f10 c0136c65 bf90a160 c012147a 00000001 0000000c 00000001 0000000e 
Aug 14 16:50:01 tp kernel:        cb819fb8 cb819f90 ce796484 bf90a160 080a3820 428edff4 cb819fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0159efe>] rw_copy_check_uvector+0x7e/0x100
Aug 14 16:50:01 tp kernel:  [<c015a840>] do_readv_writev+0x120/0x190
Aug 14 16:50:01 tp kernel:  [<c028d000>] sock_aio_write+0x0/0x110
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gconfd-2      D 00000007     0  2318      1
Aug 14 16:50:01 tp kernel:        cb7c5eb0 00200086 0000001b 00000007 00000000 00000000 00006b85 428edff4 
Aug 14 16:50:01 tp kernel:        cb7c5f10 c0136c65 0824c720 c012147a 00000003 0000000f 00000003 00000010 
Aug 14 16:50:01 tp kernel:        cb7c5fb8 cb7c5f90 ce797944 0824c720 00006b85 428edff4 cb7c5fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-keyring D 00000003     0  2321      1
Aug 14 16:50:01 tp kernel:        cafbfeb0 00200082 00000003 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        cafbff10 c0136c65 080634e8 c012147a ce7ead80 cadfe4c4 ce7eacec 00000000 
Aug 14 16:50:01 tp kernel:        cafbffb8 cafbff90 cce2f944 080634e8 ffffffff 428edff4 cafbffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c013e9d0>] filemap_fault+0x0/0x3d0
Aug 14 16:50:01 tp kernel:  [<c0148413>] handle_mm_fault+0xe3/0x590
Aug 14 16:50:01 tp kernel:  [<c0111c2b>] do_page_fault+0x18b/0x6b0
Aug 14 16:50:01 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-setting D 00000016     0  2323      1
Aug 14 16:50:01 tp kernel:        cafdfeb0 00200086 00000009 00000016 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        cafdff10 c0136c65 081a1b08 c012147a 00000003 0000000f 00000003 00000010 
Aug 14 16:50:01 tp kernel:        cafdffb8 cafdff90 ce796ee4 081a1b08 ffffffff 428edff4 cafdffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c0164faf>] do_ioctl+0x1f/0x70
Aug 14 16:50:01 tp kernel:  [<c016505c>] vfs_ioctl+0x5c/0x250
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-setting D fffffe00     0  2325      1
Aug 14 16:50:01 tp kernel:        ca9d9eb0 00200086 00000000 fffffe00 00000000 00000000 42a25b70 4d72aa50 
Aug 14 16:50:01 tp kernel:        ca9d9f10 c0136c65 00000011 c012147a ca9d9ed8 ca9d9f60 ca98af80 c015a286 
Aug 14 16:50:01 tp kernel:        ca9d9fb8 ca9d9f90 cf065e74 00000011 42a25b70 4d72aa50 ca9d9fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c01080fc>] convert_fxsr_from_user+0x1c/0xf0
Aug 14 16:50:01 tp kernel:  [<c015ab31>] vfs_read+0xa1/0x130
Aug 14 16:50:01 tp kernel:  [<c015a1c0>] do_sync_read+0x0/0x110
Aug 14 16:50:01 tp kernel:  [<c015af68>] sys_read+0x68/0x70
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: metacity      D 00000003     0  2332   2262
Aug 14 16:50:01 tp kernel:        ca52feb0 00200082 00000007 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        ca52ff10 c0136c65 0810fb00 c012147a 00000003 0000000c 00000001 0000000d 
Aug 14 16:50:01 tp kernel:        ca52ffb8 ca52ff90 ce3ff414 0810fb00 ffffffff 428edff4 ca52ffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c0164faf>] do_ioctl+0x1f/0x70
Aug 14 16:50:01 tp kernel:  [<c016505c>] vfs_ioctl+0x5c/0x250
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: nautilus      D 00000003     0  2335   2262
Aug 14 16:50:01 tp kernel:        ca617eb0 00000086 00000001 00000003 00000000 00000000 00000003 428edff4 
Aug 14 16:50:01 tp kernel:        ca617f10 c0136c65 081989e8 c012147a ca617ed8 ca617f60 ca225100 c015a286 
Aug 14 16:50:01 tp kernel:        ca617fb8 ca617f90 ca6129b4 081989e8 00000003 428edff4 ca617fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-panel   D 00000003     0  2336   2262
Aug 14 16:50:01 tp kernel:        ca571eb0 00000082 00000001 00000003 00000000 00000000 00000003 428edff4 
Aug 14 16:50:01 tp kernel:        ca571f10 c0136c65 080db7a8 c012147a ca571ed8 ca571f60 ca140f80 c015a286 
Aug 14 16:50:01 tp kernel:        ca571fb8 ca571f90 ca612ee4 080db7a8 00000003 428edff4 ca571fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-volume- D 00000004     0  2338      1
Aug 14 16:50:01 tp kernel:        ca0dfeb0 00200082 0000000a 00000004 00000000 00000000 00003a7c 428edff4 
Aug 14 16:50:01 tp kernel:        ca0dff10 c0136c65 080a0058 c012147a 00000003 0000000c 00000003 0000000d 
Aug 14 16:50:01 tp kernel:        ca0dffb8 ca0dff90 ca613944 080a0058 00003a7c 428edff4 ca0dffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0147be1>] unmap_vmas+0x281/0x450
Aug 14 16:50:01 tp kernel:  [<c0149625>] free_pgtables+0x85/0xb0
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: bonobo-activa D 00000006     0  2348      1
Aug 14 16:50:01 tp kernel:        ca3abeb0 00200082 00000002 00000006 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        ca3abf10 c0136c65 080738b8 c012147a c12ccf80 00000000 ca3fc4d0 c014a701 
Aug 14 16:50:01 tp kernel:        ca3abfb8 ca3abf90 ca613e74 080738b8 ffffffff 428edff4 ca3abfb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c014a701>] remove_vma+0x41/0x50
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c01476b3>] do_wp_page+0x283/0x3e0
Aug 14 16:50:01 tp kernel:  [<c014876c>] handle_mm_fault+0x43c/0x590
Aug 14 16:50:01 tp kernel:  [<c0111c2b>] do_page_fault+0x18b/0x6b0
Aug 14 16:50:01 tp kernel:  [<c015aa56>] vfs_write+0x106/0x140
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: bonobo-activa D 0000000a     0  2354      1
Aug 14 16:50:01 tp kernel:        c9d81eb0 00200082 0000000d 0000000a 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        c9d81f10 c0136c65 080b0f38 c012147a 00000003 00000010 00000003 00000011 
Aug 14 16:50:01 tp kernel:        c9d81fb8 c9d81f90 ce3fe484 080b0f38 ffffffff 428edff4 c9d81fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0131c08>] sys_futex+0x98/0x100
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-vfs-dae D 00000003     0  2350      1
Aug 14 16:50:01 tp kernel:        ca2f9eb0 00200082 00000008 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        ca2f9f10 c0136c65 0807a418 c012147a 00000003 00000011 00000001 00000012 
Aug 14 16:50:01 tp kernel:        ca2f9fb8 ca2f9f90 cfbdf944 0807a418 ffffffff 428edff4 ca2f9fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0159efe>] rw_copy_check_uvector+0x7e/0x100
Aug 14 16:50:01 tp kernel:  [<c015a840>] do_readv_writev+0x120/0x190
Aug 14 16:50:01 tp kernel:  [<c028d000>] sock_aio_write+0x0/0x110
Aug 14 16:50:01 tp kernel:  [<c015a8ec>] vfs_writev+0x3c/0x50
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: unclutter     D 00000003     0  2355   2262
Aug 14 16:50:01 tp kernel:        c9d99eb0 00200082 00000001 00000003 00000000 00000000 ffffffff 428edff4 
Aug 14 16:50:01 tp kernel:        c9d99f10 c0136c65 0804c650 c012147a c9d99ed8 c9d99f60 c9d75580 c015a286 
Aug 14 16:50:01 tp kernel:        c9d99fb8 c9d99f90 ca613414 0804c650 ffffffff 428edff4 c9d99fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c0113712>] update_curr+0x172/0x180
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c015abb9>] vfs_read+0x129/0x130
Aug 14 16:50:01 tp kernel:  [<c016505c>] vfs_ioctl+0x5c/0x250
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: gnome-power-m D 00000004     0  2358      1
Aug 14 16:50:01 tp kernel:        c9ea9eb0 00200082 00000009 00000004 00000000 00000000 0000137e 428edff4 
Aug 14 16:50:01 tp kernel:        c9ea9f10 c0136c65 081c0d28 c012147a 00000003 0000000c 00000003 0000000d 
Aug 14 16:50:01 tp kernel:        c9ea9fb8 c9ea9f90 c9e74484 081c0d28 0000137e 428edff4 c9ea9fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c012b2dc>] hrtimer_interrupt+0x18c/0x1e0
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: sensors-apple D 00000004     0  2375      1
Aug 14 16:50:01 tp kernel:        c901feb0 00200082 0000000a 00000004 00000000 00000000 000009a8 428edff4 
Aug 14 16:50:01 tp kernel:        c901ff10 c0136c65 080a9a58 c012147a 00000003 0000000c 00000003 0000000e 
Aug 14 16:50:01 tp kernel:        c901ffb8 c901ff90 c97faee4 080a9a58 000009a8 428edff4 c901ffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: multiload-app D 00000004     0  2377      1
Aug 14 16:50:01 tp kernel:        c906feb0 00200086 0000000a 00000004 00000000 00000000 0000018b 428edff4 
Aug 14 16:50:01 tp kernel:        c906ff10 c0136c65 080a4198 c012147a 00000003 0000000c 00000003 0000000e 
Aug 14 16:50:01 tp kernel:        c906ffb8 c906ff90 c97fb944 080a4198 0000018b 428edff4 c906ffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: cpufreq-apple D 00000004     0  2379      1
Aug 14 16:50:01 tp kernel:        c90bfeb0 00200082 0000000a 00000004 00000000 00000000 000003e7 428edff4 
Aug 14 16:50:01 tp kernel:        c90bff10 c0136c65 080a7840 c012147a 00000003 0000000c 00000003 0000000e 
Aug 14 16:50:01 tp kernel:        c90bffb8 c90bff90 c90bc484 080a7840 000003e7 428edff4 c90bffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: rxvt          D 00000000     0  2398      1
Aug 14 16:50:01 tp kernel:        c7d03eb0 00000086 c7d03e9c 00000000 00000000 00000000 00000000 00000000 
Aug 14 16:50:01 tp kernel:        c7d03f10 c0136c65 00000007 c012147a c7d03ed8 c7d03f60 c8d6c280 c015a286 
Aug 14 16:50:01 tp kernel:        c7d03fb8 c7d03f90 c92bb414 00000007 00000000 00000000 c7d03fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c015a286>] do_sync_read+0xc6/0x110
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c016680d>] sys_select+0x4d/0x1c0
Aug 14 16:50:01 tp kernel:  [<c011f5ca>] recalc_sigpending+0xa/0x20
Aug 14 16:50:01 tp kernel:  [<c011f625>] sigprocmask+0x45/0xb0
Aug 14 16:50:01 tp kernel:  [<c012190d>] sys_rt_sigprocmask+0xad/0xd0
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: bash          D 000003ad     0  2399   2398
Aug 14 16:50:01 tp kernel:        c7869eb0 00000086 00000000 000003ad 00000000 00000000 081beb88 00000000 
Aug 14 16:50:01 tp kernel:        c7869f10 c0136c65 ffffffff c012147a 000003ad 00002c1a 00000001 c03d120c 
Aug 14 16:50:01 tp kernel:        c7869fb8 c7869f90 c92ba484 ffffffff 081beb88 00000000 c7869fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c02f909b>] __sched_text_start+0x13b/0x2e0
Aug 14 16:50:01 tp kernel:  [<c01198f2>] do_wait+0x522/0xa80
Aug 14 16:50:01 tp kernel:  [<c0113a20>] default_wake_function+0x0/0x10
Aug 14 16:50:01 tp kernel:  [<c0119e81>] sys_wait4+0x31/0x40
Aug 14 16:50:01 tp kernel:  [<c0119eb5>] sys_waitpid+0x25/0x30
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: su            D 00000209     0  2424   2399
Aug 14 16:50:01 tp kernel:        c7581eb0 00000082 00000000 00000209 00000000 00000000 00000979 bf8e8088 
Aug 14 16:50:01 tp kernel:        c7581f10 c0136c65 ffffffff c012147a c01e56d4 00001661 00000001 c03d120c 
Aug 14 16:50:01 tp kernel:        c7581fb8 c7581f90 c90bcee4 ffffffff 00000979 bf8e8088 c7581fb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c01e56d4>] rb_erase+0x184/0x280
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c02f909b>] __sched_text_start+0x13b/0x2e0
Aug 14 16:50:01 tp kernel:  [<c01198f2>] do_wait+0x522/0xa80
Aug 14 16:50:01 tp kernel:  [<c01131ac>] update_stats_wait_end+0x8c/0xc0
Aug 14 16:50:01 tp kernel:  [<c0113a20>] default_wake_function+0x0/0x10
Aug 14 16:50:01 tp kernel:  [<c0119e81>] sys_wait4+0x31/0x40
Aug 14 16:50:01 tp kernel:  [<c0119eb5>] sys_waitpid+0x25/0x30
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel: bash          R running      0  2425   2424
Aug 14 16:50:01 tp kernel: gnome-screens D 00000003     0  2456      1
Aug 14 16:50:01 tp kernel:        c719feb0 00200082 00000008 00000003 00000000 00000000 000021e5 428edff4 
Aug 14 16:50:01 tp kernel:        c719ff10 c0136c65 08092358 c012147a 00000003 0000000c 00000003 0000000d 
Aug 14 16:50:01 tp kernel:        c719ffb8 c719ff90 c9e74ee4 08092358 000021e5 428edff4 c719ffb8 c0103631 
Aug 14 16:50:01 tp kernel: Call Trace:
Aug 14 16:50:01 tp kernel:  [<c0136c65>] refrigerator+0x55/0x80
Aug 14 16:50:01 tp kernel:  [<c012147a>] get_signal_to_deliver+0x3ca/0x3f0
Aug 14 16:50:01 tp kernel:  [<c0103631>] do_notify_resume+0x91/0x6e0
Aug 14 16:50:01 tp kernel:  [<c0127ef0>] autoremove_wake_function+0x0/0x50
Aug 14 16:50:01 tp kernel:  [<c01204f4>] __group_send_sig_info+0x54/0x90
Aug 14 16:50:01 tp kernel:  [<c02f1789>] unix_ioctl+0x89/0xc0
Aug 14 16:50:01 tp kernel:  [<c028d3df>] sock_ioctl+0xbf/0x220
Aug 14 16:50:01 tp kernel:  [<c011af92>] it_real_fn+0x12/0x20
Aug 14 16:50:01 tp kernel:  [<c028d320>] sock_ioctl+0x0/0x220
Aug 14 16:50:01 tp kernel:  [<c012bcd1>] do_gettimeofday+0x31/0xf0
Aug 14 16:50:01 tp kernel:  [<c01e81d0>] copy_to_user+0x30/0x60
Aug 14 16:50:01 tp kernel:  [<c0104002>] work_notifysig+0x13/0x19
Aug 14 16:50:01 tp kernel:  [<c02f0000>] xfrm_state_walk+0xb0/0xf0
Aug 14 16:50:01 tp kernel:  =======================
Aug 14 16:50:01 tp kernel:  tpb
Aug 14 16:50:01 tp kernel: Restarting tasks ... done.
Aug 14 16:50:16 tp kernel: Kernel logging (proc) stopped.
Aug 14 16:50:16 tp kernel: Kernel log daemon terminating.
Aug 14 16:51:05 tp kernel: klogd 1.5.0#1, log source = /proc/kmsg started.
