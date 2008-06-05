Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbYFEU7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbYFEU7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762823AbYFEU7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:59:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43816 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYFEU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:59:29 -0400
Date: Thu, 5 Jun 2008 12:21:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org
Subject: Re: 2.6.25 -> 2.6.26-rc1: pcmcia flash card changed name from hda
	to hdc
Message-ID: <20080605102146.GA1552@elf.ucw.cz>
References: <20080515132313.GA1558@elf.ucw.cz> <200805162140.49501.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805162140.49501.bzolnier@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > After update to 2.6.26-rc1, CF card (in pcmcia slot) moved from hda to
> > hdc on thinkpad x60 (and broke my scripts).
> > 
> > Is that intentional?
> 
> Please send dmesgs for 2.6.25 and 2.6.26-rc1 so we can tell more.

Sorry it took me so long...
								Pavel

2.6.26-rc5: flash card is at /dev/hdc.

Linux version 2.6.26-rc5 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #303 SMP Thu Jun 5 12:04:18 CEST 2008
PAT disabled. Not yet verified on this CPU type.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
1142MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at [c00f67f0] 000f67f0
Entering add_active_range(0, 0, 521936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   521936
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   521936
On node 0 totalpages: 521936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2286 pages used for memmap
  HighMem zone: 290274 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F67C0, 0024 (r2 LENOVO)
ACPI: XSDT 7F6D191C, 0084 (r1 LENOVO TP-7B        2140  LTP        0)
ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2140 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080321]
ACPI: DSDT 7F6D1D90, CFB9 (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: FACS 7F6F4000, 0040
ACPI: SSDT 7F6D1BB4, 01DC (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: ECDT 7F6DED49, 0052 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: TCPA 7F6DED9B, 0032 (r2 LENOVO TP-7B        2140 LNVO        1)
ACPI: APIC 7F6DEDCD, 0068 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: MCFG 7F6DEE35, 003C (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: HPET 7F6DEE71, 0038 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: BOOT 7F6DEFD8, 0028 (r1 LENOVO TP-7B        2140  LTP        1)
ACPI: SSDT 7F6F2645, 025F (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F28A4, 00A6 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F294A, 04F7 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F2E41, 01D8 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
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
Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37800 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517858
Kernel command line: root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps vga=791 init=/tmp/swsusp-init acpi_sleep=s3_bios,s3_mode no_console_suspend
Unknown boot option `psmouse.psmouse_proto=imps': ignoring
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
Detected 1828.826 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1920 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2059068k/2087744k available (5320k kernel code, 27516k reserved, 2458k data, 320k init, 1170240k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff7f000 - 0xfffff000   ( 512 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc09a1000 - 0xc09f1000   ( 320 kB)
      .data : 0xc0732126 - 0xc09989e8   (2458 kB)
      .text : 0xc0200000 - 0xc0732126   (5320 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 32 of 32 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 3662.00 BogoMIPS (lpj=7324006)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 1592 Objects with 69 Devices 429 Methods 28 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 11 Objects with 0 Devices 7 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 7 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 4 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0005) - 14 Objects with 0 Devices 5 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0006) - 14 Objects with 1 Devices 2 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.55 BogoMIPS (lpj=7315115)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 580008 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
Total of 2 processors activated (7319.56 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
net_namespace: 548 bytes
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver 
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Is dependent on dock

ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
ACPI: EC: EC description table is found, configuring boot EC
Completing Region/Field/Buffer/Package initialization:........................................................................................................................................................................................................................................................................
Initialized 28/28 Regions 126/126 Fields 54/54 Buffers 56/56 Packages (1651 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:...<6>ACPI: EC: non-query interrupt received, switching to interrupt mode
....
Executed 7 _INI methods requiring 2 _STA executions (examined 76 objects)
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 2 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
ACPI: RTC can wake from S4
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:00: iomem range 0xcc000-0xcffff could not be reserved
system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
system 00:00: iomem range 0xdc000-0xdffff has been reserved
system 00:00: iomem range 0xe0000-0xe3fff has been reserved
system 00:00: iomem range 0xe4000-0xe7fff has been reserved
system 00:00: iomem range 0xe8000-0xebfff has been reserved
system 00:00: iomem range 0xec000-0xeffff has been reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
system 00:00: iomem range 0xfed41000-0xffffffff could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x165f could not be reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
system 00:02: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: 0xee000000-0xee0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-4fff
  MEM window: 0xec000000-0xedffffff
  PREFETCH window: 0x00000000e4000000-0x00000000e40fffff
PCI: Bridge: 0000:00:1c.2
  IO window: 5000-6fff
  MEM window: 0xe8000000-0xe9ffffff
  PREFETCH window: 0x00000000e4100000-0x00000000e41fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 7000-8fff
  MEM window: 0xea000000-0xebffffff
  PREFETCH window: 0x00000000e4200000-0x00000000e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 0x00009000-0x000090ff
  IO window: 0x00009400-0x000094ff
  PREFETCH window: 0xe0000000-0xe3ffffff
  MEM window: 0x88000000-0x8bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-cfff
  MEM window: 0xe4300000-0xe7ffffff
  PREFETCH window: 0x00000000e0000000-0x00000000e3ffffff
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1c.3 to 64
pci 0000:00:1e.0: enabling device (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x35 set to 0x1
highmem bounce pool size: 64 pages
NTFS driver 2.1.29 [Flags: R/O DEBUG].
JFFS2 version 2.2. (NAND) ÂŠ 2001-2006 Red Hat, Inc.
fuse init (API version 7.9)
msgmni has been set to 1737 for ipc namespace c091f1c0
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:02.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 3072k, total 7872k
vesafb: mode is 1024x768x16, linelength=2048, pages=4
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 102x42
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 7F6F1D26, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 0023) - 0 Objects with 0 Devices 0 Methods 0 Regions
ACPI: SSDT 7F6F1FEB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 0024) - 0 Objects with 0 Devices 0 Methods 0 Regions
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 002E) - 0 Objects with 0 Devices 0 Methods 0 Regions
ACPI: SSDT 7F6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 002F) - 0 Objects with 0 Devices 0 Methods 0 Regions
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM0] (65 C)
ACPI: LNXTHERM:02 is registered as thermal_zone1
ACPI: Thermal Zone [THM1] (65 C)
lp: driver loaded but no devices found
Non-volatile memory driver v1.2
intel_rng: FWH not detected
cs5535_gpio: DIVIL not found
Linux agpgart interface v0.103
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets
intelfb: Version 0.9.5
intelfb: Cannot reserve FB region.
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
floppy0: no floppy controllers found
loop: module loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.20
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7BETD3WW (2.14 ), EC 7BHT40WW-1.13
thinkpad_acpi: Lenovo ThinkPad X60, model 17097HU
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
thinkpad_acpi: Lenovo BIOS switched to ACPI backlight control mode
thinkpad_acpi: standard ACPI backlight interface available, not loading native one...
input: ThinkPad Extra Buttons as /class/input/input3
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:02:00.0: Disabling L1 ASPM
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:25:19:04
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 2, PHY: 2, PBA No: 005302-003
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
usbcore: registered new interface driver catc
catc: v2.8 CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
usbcore: registered new interface driver zd1211rw
usbcore: registered new interface driver zd1201
[w35und]driver init
usbcore: registered new interface driver w35und
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2008 Intel Corporation
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
ACPI: PCI interrupt for device 0000:03:00.0 disabled
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
ICH7: not 100% native mode: will probe irqs later
ICH7: IDE port disabled
    ide0: BM-DMA at 0x1810-0x1817
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
ahci: autosuspend disabled
scsi1 : ahci
ahci: autosuspend disabled
scsi2 : ahci
ahci: autosuspend disabled
scsi3 : ahci
ahci: autosuspend disabled
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: ATA-7: HTS541060G9SA00, MB3IC60H, max UDMA/100
ata1.00: 117210240 sectors, multi 16: LBA48 
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      HTS541060G9SA00  MB3I PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:201c]
Yenta: ISA IRQ mask 0x0cb8, PCI irq 16
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26-rc5 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26-rc5 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26-rc5 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.26-rc5 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.26-rc5 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
usb 5-2: new full speed USB device using uhci_hcd and address 3
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
input: PC Speaker as /class/input/input5
input: PS/2 Generic Mouse as /class/input/input6
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
Bluetooth: Generic Bluetooth USB driver ver 0.1
usbcore: registered new interface driver btusb
EDAC MC: Ver: 2.1.0 Jun  5 2008
cpuidle: using governor ladder
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 18)
mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
PCI: Setting latency timer of device 0000:15:00.2 to 64
Registered led device: mmc0
mmc0: SDHCI at 0xe4301800 irq 18 DMA
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16.
hda_intel: probe_mask set to 0x1 for device 17aa:2010
PCI: Setting latency timer of device 0000:00:1b.0 to 64
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel at 0xee240000 irq 17
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Installing 9P2000 support
Using IPI No-Shortcut mode
PM: Resume from partition /dev/sda1
PM: Checking hibernation image.
PM: Resume from disk failed.
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory c09a1000..c09f1000
Write protecting the kernel text: 5324k
Write protecting the kernel read-only data: 1916k
Failed to execute /tmp/swsusp-init.  Attempting defaults...
EXT3 FS on sda4, internal journal
Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwclock.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051a38.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
Clocksource tsc unstable (delta = -62807698 ns)
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff 0xe4e70000-0xe523ffff 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
pcmcia: registering new device pcmcia0.0
Probing IDE interface ide1...
hdc: SunDisk SDP3B-20, CFA DISK drive
hdd: SunDisk SDP3B-20, CFA DISK drive
ide-probe: ignoring undecoded slave
ide1 at 0x9100-0x9107,0x910e on irq 16
hdc: max request size: 128KiB
hdc: 40960 sectors (20 MB) w/1KiB Cache, CHS=640/2/32
 hdc:hdc: set_geometry_intr: status=0x51 { DriveReady SeekComplete Error }
hdc: set_geometry_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hdc1 hdc3
ide-cs: hdc: Vpp = 0.0


2.6.25 : flash card is on /dev/hda

Linux version 2.6.25 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #276 SMP Sat Apr 19 14:17:17 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
1142MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f67f0] 000f67f0
Entering add_active_range(0, 0, 521936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   521936
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   521936
On node 0 totalpages: 521936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2285 pages used for memmap
  HighMem zone: 290275 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F67C0, 0024 (r2 LENOVO)
ACPI: XSDT 7F6D191C, 0084 (r1 LENOVO TP-7B        2140  LTP        0)
ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2140 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7F6D1D90, CFB9 (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: FACS 7F6F4000, 0040
ACPI: SSDT 7F6D1BB4, 01DC (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: ECDT 7F6DED49, 0052 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: TCPA 7F6DED9B, 0032 (r2 LENOVO TP-7B        2140 LNVO        1)
ACPI: APIC 7F6DEDCD, 0068 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: MCFG 7F6DEE35, 003C (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: HPET 7F6DEE71, 0038 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: BOOT 7F6DEFD8, 0028 (r1 LENOVO TP-7B        2140  LTP        1)
ACPI: SSDT 7F6F2645, 025F (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F28A4, 00A6 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F294A, 04F7 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F2E41, 01D8 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
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
Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517859
Kernel command line: root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps vga=791 init=/tmp/swsusp-init 
Unknown boot option `psmouse.psmouse_proto=imps': ignoring
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.784 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1920 bytes
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2059572k/2087744k available (5337k kernel code, 27008k reserved, 2448k data, 328k init, 1170240k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff7f000 - 0xfffff000   ( 512 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc09a4000 - 0xc09f6000   ( 328 kB)
      .data : 0xc07367b7 - 0xc099a908   (2448 kB)
      .text : 0xc0200000 - 0xc07367b7   (5337 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 32 of 32 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 3661.82 BogoMIPS (lpj=7323647)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1592 Objects with 69 Devices 429 Methods 28 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 11 Objects with 0 Devices 7 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 7 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 4 Objects with 0 Devices 3 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0005) - 14 Objects with 0 Devices 5 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0006) - 14 Objects with 1 Devices 2 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.57 BogoMIPS (lpj=7315159)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Total of 2 processors activated (7319.40 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 579766 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 508 bytes
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver 
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Is dependent on dock

ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
ACPI: bus type pci registered
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 2 Runtime GPEs in this block
ACPI: EC: EC description table is found, configuring boot EC
Completing Region/Field/Buffer/Package initialization:.............................................................................................................................................................................................................................................................
Initialized 28/28 Regions 126/126 Fields 54/54 Buffers 45/56 Packages (1651 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:...<6>ACPI: EC: non-query interrupt received, switching to interrupt mode
....
Executed 7 _INI methods requiring 2 _STA executions (examined 76 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
irda_init()
NET: Registered protocol family 23
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
ACPI: RTC can wake from S4
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:00: iomem range 0xcc000-0xcffff could not be reserved
system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0x0-0x0 could not be reserved
system 00:00: iomem range 0xdc000-0xdffff has been reserved
system 00:00: iomem range 0xe0000-0xe3fff has been reserved
system 00:00: iomem range 0xe4000-0xe7fff has been reserved
system 00:00: iomem range 0xe8000-0xebfff has been reserved
system 00:00: iomem range 0xec000-0xeffff has been reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
system 00:00: iomem range 0xfed41000-0xffffffff could not be reserved
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x165f could not be reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: 0xee000000-0xee0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-4fff
  MEM window: 0xec000000-0xedffffff
  PREFETCH window: 0x00000000e4000000-0x00000000e40fffff
PCI: Bridge: 0000:00:1c.2
  IO window: 5000-6fff
  MEM window: 0xe8000000-0xe9ffffff
  PREFETCH window: 0x00000000e4100000-0x00000000e41fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 7000-8fff
  MEM window: 0xea000000-0xebffffff
  PREFETCH window: 0x00000000e4200000-0x00000000e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 0x00009000-0x000090ff
  IO window: 0x00009400-0x000094ff
  PREFETCH window: 0xe0000000-0xe3ffffff
  MEM window: 0x88000000-0x8bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-cfff
  MEM window: 0xe4300000-0xe7ffffff
  PREFETCH window: 0x00000000e0000000-0x00000000e3ffffff
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
highmem bounce pool size: 64 pages
NTFS driver 2.1.29 [Flags: R/O DEBUG].
JFFS2 version 2.2. (NAND) ÂŠ 2001-2006 Red Hat, Inc.
fuse init (API version 7.9)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:02.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 3072k, total 7872k
vesafb: mode is 1024x768x16, linelength=2048, pages=4
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 102x42
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 7F6F1D26, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 001E) - 6 Objects with 0 Devices 4 Methods 0 Regions
ACPI: SSDT 7F6F1FEB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 001F) - 13 Objects with 0 Devices 1 Methods 0 Regions
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 0029) - 4 Objects with 0 Devices 4 Methods 0 Regions
ACPI: SSDT 7F6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 002A) - 1 Objects with 0 Devices 1 Methods 0 Regions
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM0] (65 C)
ACPI: LNXTHERM:02 is registered as thermal_zone1
ACPI: Thermal Zone [THM1] (67 C)
lp: driver loaded but no devices found
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
intel_rng: FWH not detected
cs5535_gpio: DIVIL not found
Linux agpgart interface v0.103
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
intelfb: Version 0.9.4
intelfb: Cannot reserve FB region.
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
floppy0: no floppy controllers found
loop: module loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.19
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7BETD3WW (2.14 ), EC 7BHT40WW-1.13
thinkpad_acpi: Lenovo ThinkPad X60
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: standard ACPI backlight interface available, not loading native one...
input: ThinkPad Extra Buttons as /class/input/input3
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
e1000e 0000:02:00.0: Disabling L1 ASPM
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:25:19:04
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 2, PHY: 2, PBA No: 005302-003
pcnet32.c:v1.34 14.Aug.2007 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
usbcore: registered new interface driver catc
/data/l/linux/drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
usbcore: registered new interface driver zd1211rw
usbcore: registered new interface driver zd1201
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.23kds
iwl3945: Copyright(c) 2003-2007 Intel Corporation
PCI: Setting latency timer of device 0000:03:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
ACPI: PCI interrupt for device 0000:03:00.0 disabled
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
ICH7: not 100% native mode: will probe irqs later
ICH7: IDE port disabled
    ide0: BM-DMA at 0x1810-0x1817, BIOS settings: hda:PIO, hdb:PIO
Probing IDE interface ide0...
Probing IDE interface ide0...
Probing IDE interface ide1...
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
ahci: autosuspend disabled
scsi1 : ahci
ahci: autosuspend disabled
scsi2 : ahci
ahci: autosuspend disabled
scsi3 : ahci
ahci: autosuspend disabled
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HTS541060G9SA00, MB3IC60H, max UDMA/100
ata1.00: 117210240 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      HTS541060G9SA00  MB3I PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:201c]
Yenta: ISA IRQ mask 0x0cb8, PCI irq 16
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
usb 5-1: new full speed USB device using uhci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
usb 5-2: new full speed USB device using uhci_hcd and address 3
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usbcore: registered new interface driver cdc_acm
/data/l/linux/drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
input: PC Speaker as /class/input/input5
input: PS/2 Generic Mouse as /class/input/input6
proc_dir_entry 'rtc' already registered
Pid: 1, comm: swapper Not tainted 2.6.25 #276
 [<c02b0a05>] proc_register+0xd5/0x150
 [<c02b0b7f>] create_proc_entry+0x4f/0xb0
 [<c054247e>] rtc_proc_add_device+0x1e/0x40
 [<c05412a8>] rtc_device_register+0x1f8/0x230
 [<c0735224>] _write_unlock+0x14/0x20
 [<c0542d60>] cmos_do_probe+0x120/0x330
 [<c03d3ad5>] compare_pnp_id+0x25/0xc0
 [<c03d3c0f>] pnp_device_probe+0x4f/0xb0
 [<c0419328>] driver_probe_device+0x88/0x170
 [<c07352c4>] _spin_unlock+0x14/0x20
 [<c0704bdd>] klist_next+0x5d/0xa0
 [<c0419560>] __driver_attach+0x80/0x90
 [<c041869c>] bus_for_each_dev+0x3c/0x60
 [<c03d3bc0>] pnp_device_probe+0x0/0xb0
 [<c0419186>] driver_attach+0x16/0x20
 [<c04194e0>] __driver_attach+0x0/0x90
 [<c0418f2f>] bus_add_driver+0xaf/0x210
 [<c03d3a40>] pnp_device_remove+0x0/0x30
 [<c03d3bc0>] pnp_device_probe+0x0/0xb0
 [<c041970b>] driver_register+0x3b/0xf0
 [<c09a4511>] kernel_init+0x121/0x2f0
 [<c0220d0b>] finish_task_switch+0x5b/0xc0
 [<c09a43f0>] kernel_init+0x0/0x2f0
 [<c09a43f0>] kernel_init+0x0/0x2f0
 [<c02047b3>] kernel_thread_helper+0x7/0x14
 =======================
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
Bluetooth: Generic Bluetooth USB driver ver 0.1
usbcore: registered new interface driver btusb
EDAC MC: Ver: 2.1.0 Apr 15 2008
cpuidle: using governor ladder
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 18)
sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
PCI: Setting latency timer of device 0000:15:00.2 to 64
mmc0: SDHCI at 0xe4301800 irq 18 DMA
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
usbcore: registered new interface driver usbhid
/data/l/linux/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
hda_intel: probe_mask set to 0x1 for device 17aa:2010
PCI: Setting latency timer of device 0000:00:1b.0 to 64
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: HDA Intel at 0xee240000 irq 17
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
IrCOMM protocol (Dag Brattli)
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.5
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Installing 9P2000 support
Using IPI No-Shortcut mode
PM: Resume from partition /dev/sda1
PM: Checking hibernation image.
PM: Resume from disk failed.
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory c09a4000..c09f6000
Write protecting the kernel read-only data: 1940k
Failed to execute /tmp/swsusp-init.  Attempting defaults...
EXT3 FS on sda4, internal journal
Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwclock.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
Clocksource tsc unstable (delta = -65390459 ns)
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051a38.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
pccard: PCMCIA card inserted into slot 0
cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xdc000-0xfffff
cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff 0xe4e70000-0xe523ffff 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
pcmcia: registering new device pcmcia0.0
Probing IDE interface ide0...
hda: SunDisk SDP3B-20, CFA DISK drive
hdb: SunDisk SDP3B-20, CFA DISK drive
ide-probe: ignoring undecoded slave
ide0 at 0x9100-0x9107,0x910e on irq 16
hda: max request size: 128KiB
hda: 40960 sectors (20 MB) w/1KiB Cache, CHS=640/2/32
 hda:hda: set_geometry_intr: status=0x51 { DriveReady SeekComplete Error }
hda: set_geometry_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hda1 hda3
ide-cs: hda: Vpp = 0.0


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
