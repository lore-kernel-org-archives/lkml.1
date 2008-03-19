Return-Path: <linux-kernel-owner+w=401wt.eu-S936611AbYCSVN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936611AbYCSVN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761920AbYCST7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36140 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbYCST72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:28 -0400
Date: Wed, 19 Mar 2008 09:21:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: marcel@holtmann.org, maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: bluetooth still corrupts memory in 2.6.25-rc6
Message-ID: <20080319082115.GA14543@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...just leave ppp-over-cellphone-over-bluetooth running, and do
s2ram...

Linux version 2.6.25-rc6 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #186 SMP Wed Mar 19 00:46:05 CET 2008
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
Kernel command line: root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps vga=791 init=/tmp/swsusp-init acpi_sleep=s3_bios,s3_mode no_console_suspend
Unknown boot option `psmouse.psmouse_proto=imps': ignoring
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.808 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2061008k/2087744k available (5277k kernel code, 25612k reserved, 2021k data, 324k init, 1170240k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc092c000 - 0xc097d000   ( 324 kB)
      .data : 0xc0727446 - 0xc09208a8   (2021 kB)
      .text : 0xc0200000 - 0xc0727446   (5277 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 3661.67 BogoMIPS (lpj=7323359)
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
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.55 BogoMIPS (lpj=7315103)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Total of 2 processors activated (7319.23 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 580118 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 448 bytes
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
pnpacpi: exceeded the max number of mem resources: 12
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
Time: hpet clocksource has been installed.
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
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
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
ACPI: device:03 is registered as cooling_device0
input: Video Bus as /class/input/input3
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
ACPI: SSDT 7F6F1D26, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 002B) - 6 Objects with 0 Devices 4 Methods 0 Regions
ACPI: SSDT 7F6F1FEB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 002C) - 13 Objects with 0 Devices 1 Methods 0 Regions
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device1
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 0036) - 4 Objects with 0 Devices 4 Methods 0 Regions
ACPI: SSDT 7F6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
Parsing all Control Methods:
Table [SSDT](id 0037) - 1 Objects with 0 Devices 1 Methods 0 Regions
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device2
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THM0] (57 C)
ACPI: LNXTHERM:02 is registered as thermal_zone1
ACPI: Thermal Zone [THM1] (57 C)
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
input: ThinkPad Extra Buttons as /class/input/input4
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
usb usb1: Manufacturer: Linux 2.6.25-rc6 ehci_hcd
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
usb usb2: Manufacturer: Linux 2.6.25-rc6 uhci_hcd
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
usb usb3: Manufacturer: Linux 2.6.25-rc6 uhci_hcd
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
usb usb4: Manufacturer: Linux 2.6.25-rc6 uhci_hcd
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
usb usb5: Manufacturer: Linux 2.6.25-rc6 uhci_hcd
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
input: AT Translated Set 2 keyboard as /class/input/input5
input: PC Speaker as /class/input/input6
input: PS/2 Generic Mouse as /class/input/input7
proc_dir_entry 'rtc' already registered
Pid: 1, comm: swapper Not tainted 2.6.25-rc6 #186
 [<c02aa890>] proc_register+0xd0/0x150
 [<c02aaa0f>] create_proc_entry+0x4f/0xb0
 [<c05390ae>] rtc_proc_add_device+0x1e/0x40
 [<c0537f88>] rtc_device_register+0x1d8/0x210
 [<c0539970>] cmos_do_probe+0x120/0x330
 [<c03ccc85>] compare_pnp_id+0x25/0xc0
 [<c03ccdbf>] pnp_device_probe+0x4f/0xb0
 [<c04120c8>] driver_probe_device+0x88/0x170
 [<c06f6653>] klist_next+0x53/0xa0
 [<c04122fa>] __driver_attach+0x7a/0x80
 [<c041148a>] bus_for_each_dev+0x3a/0x60
 [<c03ccd70>] pnp_device_probe+0x0/0xb0
 [<c0411f46>] driver_attach+0x16/0x20
 [<c0412280>] __driver_attach+0x0/0x80
 [<c0411cf9>] bus_add_driver+0xa9/0x210
 [<c03ccbf0>] pnp_device_remove+0x0/0x30
 [<c03ccd70>] pnp_device_probe+0x0/0xb0
 [<c041248b>] driver_register+0x3b/0xf0
 [<c092c511>] kernel_init+0x121/0x2f0
 [<c0203ba2>] ret_from_fork+0x6/0x1c
 [<c092c3f0>] kernel_init+0x0/0x2f0
 [<c092c3f0>] kernel_init+0x0/0x2f0
 [<c0204867>] kernel_thread_helper+0x7/0x10
 =======================
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Bluetooth: HCI USB driver ver 2.9
usbcore: registered new interface driver hci_usb
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
EDAC MC: Ver: 2.1.0 Mar 18 2008
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
Freeing unused kernel memory: 324k freed
Failed to execute /tmp/swsusp-init.  Attempting defaults...
EXT3 FS on sda4, internal journal
Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwclock.
pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: rootfid is (01234567.ffffffff.08051a38.00000000)
coda: Unexpected interruption.
Failure of coda_cnode_make for root: error -4
Clocksource tsc unstable (delta = -64447043 ns)
iwl3945: version magic '2.6.25-rc5 SMP mod_unload 686 ' should be '2.6.25-rc6 SMP mod_unload 686 '
PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100102, writing 100106)
iwl3945: version magic '2.6.25-rc5 SMP mod_unload 686 ' should be '2.6.25-rc6 SMP mod_unload 686 '
iwl3945: version magic '2.6.25-rc5 SMP mod_unload 686 ' should be '2.6.25-rc6 SMP mod_unload 686 '
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: RX authentication from 00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX AssocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
wlan0: associated
acpiphp_glue: cannot get bridge info
acpiphp_glue: cannot get bridge info
acpiphp_glue: cannot get bridge info
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
ACPI: Preparing to enter system sleep state S3
sleepy: scsi_bus_suspend start
sleepy: sd_suspend start
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
sleepy: sd_suspend done
sd 0:0:0:0: suspended
ahci: autosuspend disabled
sleepy: scsi_bus_suspend done
drm_sysfs_suspend
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:15:00.2 disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:03:00.0 disabled
ACPI: PCI interrupt for device 0000:02:00.0 disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
sleepy: ahci_pci_device_suspend done
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 is down
Device_power_down
 hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
Back to C!
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.58 BogoMIPS (lpj=7315160)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
CPU1 is up
ACPI: EC: missing OBF confirmation, don't expect it any longer.
ACPI: EC: missing write data confirmation, don't expect it any longer.
PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900003, writing 900007)
PCI: Setting latency timer of device 0000:00:02.0 to 64
PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900003)
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was 20006050, writing 6050)
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PM: Writing back config space on device 0000:00:1c.3 at offset f (was 40400, writing 4040b)
PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e421e421)
PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing ebf0ea00)
PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 20000000, writing 8070)
PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100107)
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb2: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb3: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb4: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.3 to 64
usb usb5: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
sleepy: ahci_pci_device_resume start
PCI: Setting latency timer of device 0000:00:1f.2 to 64
do_resume done
reset_controller
init_controller
ata_host_resume
all ok
sleepy: ahci_pci_device_resume done
PCI: Setting latency timer of device 0000:02:00.0 to 64
PM: Writing back config space on device 0000:15:00.2 at offset 4 (was 0, writing e4301800)
PM: Writing back config space on device 0000:15:00.2 at offset 3 (was 800000, writing 804000)
PM: Writing back config space on device 0000:15:00.2 at offset 1 (was 2100000, writing 2100006)
sleepy: scsi_bus_resume start
sleepy: sd_resume start
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
autoresume_sdev_work
sleepy: sd_resume done
sd 0:0:0:0: resumed
sleepy: scsi_bus_resume done
autoresume_sdev_work: have mutex
autoresume_sdev_work: resume_sdev done
autoresume_sdev_work: may be suspendable
autoresume_sdev_work: done
autoresume_sdev_work
autoresume_sdev_work: have mutex
autoresume_sdev_work: resume_sdev done
autoresume_sdev_work: may be suspendable
autoresume_sdev_work: done
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
wlan0: No ProbeResp from current AP 00:11:2f:0e:95:a0 - assume out of range
PM: Finishing wakeup.
Restarting tasks ... <6>usb 5-1: USB disconnect, address 2
done.
usb 5-2: USB disconnect, address 3
usb 5-2: new full speed USB device using uhci_hcd and address 4
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
usb 5-1: new full speed USB device using uhci_hcd and address 5
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: BCM2045B
usb 5-1: Manufacturer: Broadcom Corp
hci_cmd_task: hci0 command tx timeout
acpiphp_glue: cannot get bridge info
acpiphp_glue: cannot get bridge info
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
ACPI: Preparing to enter system sleep state S3
sleepy: scsi_bus_suspend start
sleepy: sd_suspend start
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
sleepy: sd_suspend done
sd 0:0:0:0: suspended
ahci: autosuspend disabled
sleepy: scsi_bus_suspend done
drm_sysfs_suspend
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:15:00.2 disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:03:00.0 disabled
ACPI: PCI interrupt for device 0000:02:00.0 disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
sleepy: ahci_pci_device_suspend done
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
__tx_submit: hci0 tx submit failed urb e34dca24 type 2 err -113
__tx_submit: hci0 tx submit failed urb f7151e4c type 2 err -113
__tx_submit: hci0 tx submit failed urb f1ce0e4c type 2 err -113
__tx_submit: hci0 tx submit failed urb f7151abc type 2 err -113
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 is down
Device_power_down
 hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
Back to C!
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.59 BogoMIPS (lpj=7315186)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
CPU1 is up
PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900003, writing 900007)
PCI: Setting latency timer of device 0000:00:02.0 to 64
PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900003)
PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PM: Writing back config space on device 0000:00:1c.3 at offset f (was 40400, writing 4040b)
PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e421e421)
PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing ebf0ea00)
PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 20000000, writing 20008070)
PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100107)
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb2: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb3: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb4: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.3 to 64
usb usb5: root hub lost power or was reset
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
sleepy: ahci_pci_device_resume start
PCI: Setting latency timer of device 0000:00:1f.2 to 64
do_resume done
reset_controller
init_controller
ata_host_resume
all ok
sleepy: ahci_pci_device_resume done
PCI: Setting latency timer of device 0000:02:00.0 to 64
PM: Writing back config space on device 0000:15:00.2 at offset 4 (was 0, writing e4301800)
PM: Writing back config space on device 0000:15:00.2 at offset 3 (was 800000, writing 804000)
PM: Writing back config space on device 0000:15:00.2 at offset 1 (was 2100000, writing 2100006)
sleepy: scsi_bus_resume start
sleepy: sd_resume start
sd 0:0:0:0: [sda] Starting disk
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
autoresume_sdev_work
sleepy: sd_resume done
sd 0:0:0:0: resumed
sleepy: scsi_bus_resume done
autoresume_sdev_work: have mutex
autoresume_sdev_work: resume_sdev done
autoresume_sdev_work: may be suspendable
autoresume_sdev_work: done
autoresume_sdev_work
autoresume_sdev_work: have mutex
autoresume_sdev_work: resume_sdev done
autoresume_sdev_work: may be suspendable
autoresume_sdev_work: done
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Finishing wakeup.
Restarting tasks ... <6>usb 5-1: USB disconnect, address 5
slab error in verify_redzone_free(): cache `size-1024': memory outside object was overwritten
Pid: 264, comm: khubd Not tainted 2.6.25-rc6 #186
 [<c0270baf>] cache_free_debugcheck+0x18f/0x220
 [<c07252bc>] __mutex_lock_slowpath+0x10c/0x1c0
 [<c0562603>] hci_usb_close+0xd3/0x120
 [<c0270d96>] kfree+0x56/0xc0
 [<c0562603>] hci_usb_close+0xd3/0x120
 [<c056311d>] hci_usb_disconnect+0x2d/0x90
 [<c0506328>] usb_disable_interface+0x28/0x40
 [<c0509040>] usb_unbind_interface+0x50/0xa0
 [<c0411ef1>] __device_release_driver+0x51/0x90
 [<c041231e>] device_release_driver+0x1e/0x40
 [<c04117f0>] bus_remove_device+0x60/0x90
 [<c040fb93>] device_del+0xe3/0x150
 [<c050629e>] usb_disable_device+0x7e/0xe0
 [<c0501b06>] usb_disconnect+0x96/0x120
 [<c0502f2e>] hub_thread+0x33e/0xd20
 [<c072445c>] schedule+0x32c/0x830
 [<c021ec25>] try_to_wake_up+0x55/0x1d0
 [<c0239190>] autoremove_wake_function+0x0/0x50
 [<c0502bf0>] hub_thread+0x0/0xd20
 [<c0238ea2>] kthread+0x42/0x70
 [<c0238e60>] kthread+0x0/0x70
 [<c0204867>] kernel_thread_helper+0x7/0x10
 =======================
e3505734: redzone 1:0x5a5a5a5ad84156c5, redzone 2:0xffffffffd84156c5.
------------[ cut here ]------------
kernel BUG at /data/l/linux/mm/slab.c:2906!
invalid opcode: 0000 [#1] SMP 
Modules linked in:

Pid: 264, comm: khubd Not tainted (2.6.25-rc6 #186)
EIP: 0060:[<c0270c38>] EFLAGS: 00010002 CPU: 0
EIP is at cache_free_debugcheck+0x218/0x220
EAX: e3505730 EBX: f7c01800 ECX: e35042b8 EDX: 00000005
ESI: e3505734 EDI: d84156c5 EBP: 5a5a5a5a ESP: f7d91e28
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process khubd (pid: 264, ti=f7d90000 task=f7d8b980 task.ti=f7d90000)
Stack: c07fce50 e3505734 d84156c5 5a5a5a5a d84156c5 ffffffff c0562603 e3504280 
       d84156c5 ffffffff f7c01800 f7c06388 e350573c 00000282 c0270d96 e34dca24 
       e34dca10 00000000 f76ac578 c0562603 f76ac548 0000000c f70631e0 f76ac4c0 
Call Trace:
 [<c0562603>] hci_usb_close+0xd3/0x120
 [<c0270d96>] kfree+0x56/0xc0
 [<c0562603>] hci_usb_close+0xd3/0x120
 [<c056311d>] hci_usb_disconnect+0x2d/0x90
 [<c0506328>] usb_disable_interface+0x28/0x40
 [<c0509040>] usb_unbind_interface+0x50/0xa0
 [<c0411ef1>] __device_release_driver+0x51/0x90
 [<c041231e>] device_release_driver+0x1e/0x40
 [<c04117f0>] bus_remove_device+0x60/0x90
 [<c040fb93>] device_del+0xe3/0x150
 [<c050629e>] usb_disable_device+0x7e/0xe0
 [<c0501b06>] usb_disconnect+0x96/0x120
 [<c0502f2e>] hub_thread+0x33e/0xd20
 [<c072445c>] schedule+0x32c/0x830
 [<c021ec25>] try_to_wake_up+0x55/0x1d0
 [<c0239190>] autoremove_wake_function+0x0/0x50
 [<c0502bf0>] hub_thread+0x0/0xd20
 [<c0238ea2>] kthread+0x42/0x70
 [<c0238e60>] kthread+0x0/0x70
 [<c0204867>] kernel_thread_helper+0x7/0x10
 =======================
Code: 3d 00 40 02 00 0f 85 3b fe ff ff 8b 52 0c e9 33 fe ff ff 0f 0b eb fe 8b 52 0c e9 6d fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b eb fe 8d 74 26 00 55 57 56 53 83 ec 10 89 44 24 08 89 54 
EIP: [<c0270c38>] cache_free_debugcheck+0x218/0x220 SS:ESP 0068:f7d91e28
---[ end trace 4ee36c05f33330e1 ]---
done.
slab error in verify_redzone_free(): cache `size-1024': memory outside object was overwritten
Pid: 4, comm: ksoftirqd/0 Tainted: G      D  2.6.25-rc6 #186
 [<c0270baf>] cache_free_debugcheck+0x18f/0x220
 [<c0270af1>] cache_free_debugcheck+0xd1/0x220
 [<c02890cc>] free_fdtable_rcu+0x4c/0x70
 [<c0270d96>] kfree+0x56/0xc0
 [<c02890cc>] free_fdtable_rcu+0x4c/0x70
 [<c0252783>] __rcu_process_callbacks+0x63/0x180
 [<c02528b7>] rcu_process_callbacks+0x17/0x30
 [<c022b5a2>] __do_softirq+0x72/0xf0
 [<c022b710>] ksoftirqd+0x0/0xd0
 [<c022b657>] do_softirq+0x37/0x40
 [<c022b764>] ksoftirqd+0x54/0xd0
 [<c0238ea2>] kthread+0x42/0x70
 [<c0238e60>] kthread+0x0/0x70
 [<c0204867>] kernel_thread_helper+0x7/0x10
 =======================
e3505b48: redzone 1:0xd84156c5c0562603, redzone 2:0xd84156c5635688c0.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
