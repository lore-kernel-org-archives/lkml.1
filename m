Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbXISSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbXISSOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXISSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:14:13 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:8750 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbXISSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:14:11 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba Satellite A40
Date: Wed, 19 Sep 2007 20:14:08 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wbW8GdSKgyZ98DQ"
Message-Id: <200709192014.08443.elendil@planet.nl>
X-OriginalArrivalTime: 19 Sep 2007 18:14:08.0693 (UTC) FILETIME=[DF2C5650:01C7FAE8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_wbW8GdSKgyZ98DQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

When compared with 2.6.22-4, dmesg no longer lists S4 and S5 as supported 
for my Toshiba Satellite A40 laptop (Mobile Intel Pentium 4, 2.8GHz).

-Linux version 2.6.22-2-686 (Debian 2.6.22-4) (waldi@debian.org) ...
+Linux version 2.6.23-rc6 (root@faramir) ...
 [...]
+ACPI: EC: Look up EC in DSDT
 ACPI: Interpreter enabled
-ACPI: (supports S0 S3 S4 S5)
+ACPI: (supports S0 S3)
 ACPI: Using IOAPIC for interrupt routing
 ACPI: PCI Root Bridge [PCI0] (0000:00)

I see no other relevant changes in dmesg (full output below).

Is this a regression or expected?

Cheers,
Frans Pop


--Boundary-00=_wbW8GdSKgyZ98DQ
Content-Type: text/plain;
  charset="utf-8";
  name="tos_A40.lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="tos_A40.lspci"

00:00.0 Host bridge [0600]: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller [8086:3580] (rev 02)
00:00.1 System peripheral [0880]: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller [8086:3584] (rev 02)
00:00.3 System peripheral [0880]: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller [8086:3585] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation 82852/855GM Integrated Graphics Device [8086:3582] (rev 02)
00:02.1 Display controller [0380]: Intel Corporation 82852/855GM Integrated Graphics Device [8086:3582] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 [8086:24c2] (rev 03)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 [8086:24c4] (rev 03)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller [8086:24cd] (rev 03)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 83)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge [8086:24cc] (rev 03)
00:1f.1 IDE interface [0101]: Intel Corporation 82801DBM (ICH4-M) IDE Controller [8086:24ca] (rev 03)
00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller [8086:24c5] (rev 03)
00:1f.6 Modem [0703]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller [8086:24c6] (rev 03)
01:08.0 Ethernet controller [0200]: Intel Corporation 82801DB PRO/100 VE (MOB) Ethernet Controller [8086:103d] (rev 83)
01:0b.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support [1179:0617] (rev 33)

--Boundary-00=_wbW8GdSKgyZ98DQ
Content-Type: text/plain;
  charset="utf-8";
  name="2.6.23-rc6-686.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="2.6.23-rc6-686.dmesg"

Linux version 2.6.23-rc6 (root@faramir) (gcc version 4.2.1 (Debian 4.2.1-4)) #1 SMP Wed Sep 19 16:31:00 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
 BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
 BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ef40000 (usable)
 BIOS-e820: 000000001ef40000 - 000000001ef50000 (ACPI data)
 BIOS-e820: 000000001ef50000 - 000000001f000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
495MB LOWMEM available.
Entering add_active_range(0, 0, 126784) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   126784
  HighMem    126784 ->   126784
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   126784
On node 0 totalpages: 126784
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 958 pages used for memmap
  Normal zone: 121730 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F0180, 0014 (r0 TOSHIB)
ACPI: RSDT 1EF40000, 0038 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: FACP 1EF40060, 0084 (r2 TOSHIB 750      20030101 TASM  4010000)
ACPI: DSDT 1EF40558, 4B72 (r1 TOSHIB A000C    20031216 MSFT  100000E)
ACPI: FACS 000EEE00, 0040
ACPI: SSDT 1EF402CA, 0082 (r1 TOSHIB A000C    20030917 MSFT  100000E)
ACPI: DBGP 1EF400E4, 0034 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: BOOT 1EF40038, 0028 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: APIC 1EF40118, 0062 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: PM-Timer IO Port: 0xd808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 1f000000:dfc00000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 00000000000ee000
swsusp: Registered nosave memory region: 00000000000ee000 - 00000000000ef000
swsusp: Registered nosave memory region: 00000000000ef000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 125794
Kernel command line: root=/dev/hda3 ro vga=791
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 2793.139 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 493688k/507136k available (1710k kernel code, 12840k reserved, 654k data, 232k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdf800000 - 0xff7fe000   ( 511 MB)
    lowmem  : 0xc0000000 - 0xdef40000   ( 495 MB)
      .init : 0xc0355000 - 0xc038f000   ( 232 kB)
      .data : 0xc02abb3c - 0xc034f6dc   ( 654 kB)
      .text : 0xc0100000 - 0xc02abb3c   (1710 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5590.71 BogoMIPS (lpj=11181437)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Hyper-Threading is disabled
CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b080 00004400 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: Intel Mobile Intel(R) Pentium(R) 4     CPU 2.80GHz stepping 09
Total of 1 processors activated (5590.71 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd2fe, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region d800-d87f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region eec0-eeff claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Cannot allocate resource region 4 of device 0000:00:1d.0
PCI: Cannot allocate resource region 4 of device 0000:00:1d.1
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x1ef3ffff could not be reserved
PCI: Bus 2, cardbus bridge: 0000:01:0b.0
  IO window: 0000c000-0000c0ff
  IO window: 0000c400-0000c4ff
  PREFETCH window: 28000000-2bffffff
  MEM window: 30000000-33ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: cff00000-cfffffff
  PREFETCH window: 28000000-2bffffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PCI: Enabling device 0000:01:0b.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:01:0b.0[A] -> GSI 18 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 196608 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 5478k freed
Simple Boot Flag at 0x7c set to 0x1
audit: initializing netlink socket (disabled)
audit(1190222757.716:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Firmware left 0000:01:08.0 e100 interrupts enabled, disabling
vesafb: framebuffer at 0xd8000000, mapped to 0xdf880000, using 3072k, total 16192k
vesafb: mode is 1024x768x16, linelength=2048, pages=9
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
PCI: Enabling device 0000:00:1f.6 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:1f.6[B] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 232k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Transitioning device [FAN] to D3
ACPI: Transitioning device [FAN] to D3
ACPI: Fan [FAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Thermal Zone [THRM] (71 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
SCSI subsystem initialized
usbcore: registered new device driver usb
libata version 2.21 loaded.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:01:08.0[A] -> GSI 20 (level, low) -> IRQ 18
e100: eth0: e100_probe: addr 0xcffff000, irq 18, MAC addr 00:08:0D:17:BF:F5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 19, io base 0x000018c0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 20, io base 0x000018e0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0x2c080000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH4: chipset revision 3
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xbfa0-0xbfa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xbfa8-0xbfaf, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: HTS541080G9AT00, ATA DISK drive
hda: selected mode 0x45
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Clocksource tsc unstable (delta = -473964036 ns)
hdc: TOSHIBA DVD-ROM SD-R6112, ATAPI CD/DVD-ROM drive
hdc: selected mode 0x42
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/7539KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input1
Real Time Clock Driver v1.12ac
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0xd860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
pnp: Device 00:09 activated.
parport_pc 00:09: reported by Plug and Play ACPI
pnp: Device 00:09 disabled.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Linux agpgart interface v0.102
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
intel_rng: FWH not detected
agpgart: Detected an Intel 855GM Chipset.
agpgart: Detected 16252K stolen memory.
agpgart: AGP aperture is 128M @ 0xd8000000
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input3
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
ACPI: AC Adapter [ADP1] (on-line)
input: Video Bus as /class/input/input5
ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
ACPI: Battery Slot [BAT1] (battery present)
input: PS/2 Mouse as /class/input/input6
input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
Yenta: CardBus bridge found at 0000:01:0b.0 [1179:0001]
Yenta: ISA IRQ mask 0x04b8, PCI irq 16
Socket status: 30000007
pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
cs: IO port probe 0xc000-0xcfff: clean.
pcmcia: parent PCI bridge Memory window: 0xcff00000 - 0xcfffffff
pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
ACPI: PCI Interrupt 0000:00:1f.6[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.6 to 64
PCI: Enabling device 0000:00:1f.5 (0000 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.5 to 64
cs: IO port probe 0x100-0x3af: excluding 0x1e0-0x1e7
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
intel8x0_measure_ac97_clock: measured 55275 usecs
intel8x0: clocking to 48000
EXT3 FS on hda3, internal journal
toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
fuse init (API version 7.8)
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth0: no IPv6 routers present

--Boundary-00=_wbW8GdSKgyZ98DQ--
