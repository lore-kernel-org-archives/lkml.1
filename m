Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbXJEGnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbXJEGnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXJEGmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:42:55 -0400
Received: from azur.resot.net ([217.175.160.20]:37193 "EHLO azur.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbXJEGmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:42:52 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 02:42:51 EDT
From: "werner" <werner@copaya.yi.org>
Subject: Bug in drm  modules of kernel 2.6.23-rc9-git2
To: linux-kernel@vger.kernel.org
X-Originating-IP: 217.175.174.121
X-Mailer: Usermin 1.300
Message-Id: <1191565675.4842@copaya.yi.org>
Date: Fri, 05 Oct 2007 03:27:55 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1191565675"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1191565675
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

attn:  linux-kernel@vger.kernel.org


There is a bug in the drm modules,  w.r.t. radeon and savage grafic cards (at least)
This bug is present on kernel 2.6.23-rc9-git2 ,  it was NOT present on 2.6.23-rc8-git4
nor in the previous kernels.   Without drm, also compiz snapshot don't work longer

I hope you can find and repair this before the 2.6.23 release 

Below is the beginning of dmesg  for the two kernels what I quoted above.

Werner Landgraf
www.copaya.yi.org


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  dmesg 2.6.23-rc9-git2 (drm no working longer ...) =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Linux version 2.6.23-rc9-git2-i486-1mn (root@werner) (gcc version 4.2.0 20061031 (prerelease)) #1 SMP Thu Oct 4 15:32:50 GFT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000000f00000 (usable)
 BIOS-e820: 0000000000f00000 - 0000000001000000 (reserved)
 BIOS-e820: 0000000001000000 - 0000000040000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
128MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 262144) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262144
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262144
On node 0 totalpages: 262144
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 256 pages used for memmap
  HighMem zone: 32512 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.2 present.
Allocating PCI resources starting at 50000000 (gap: 40000000:bfff0000)
Built 1 zonelists in Zone order.  Total pages: 260096
Kernel command line: BOOT_IMAGE=3D2623rc9git2 ro root=3D302 4 root=3D/dev/hda2 devfs=3Dnomount noapic nolapic acpi=3Dht
mapped APIC to ffffb000 (0180d000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 999.646 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1033016k/1048576k available (3099k kernel code, 13956k reserved, 1098k data, 408k init, 131072k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0521000 - 0xc0587000   ( 408 kB)
      .data : 0xc0406e85 - 0xc0519804   (1098 kB)
      .text : 0xc0100000 - 0xc0406e85   (3099 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=3D22, HWalign=3D32, Order=3D0-1, MinObjects=3D4, CPUs=3D1, Nodes=3D1
Calibrating delay using timer specific routine.. 2001.41 BogoMIPS (lpj=3D4002837)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: CLK_CTL MSR was fff7f37f. Reprogramming to 2007f37f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f9ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 16k freed
CPU0: AMD Athlon(tm) Processor stepping 01
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xfb160, last bus=3D1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fbc30
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbc60, dseg 0xf0000
PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Disabling VIA memory write queue (PCI ID 0305, rev 03): [55] 8d & 1f -> 0d
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Using IRQ router VIA [1106/0686] at 0000:00:07.0
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread C1902000 could not acquire Mutex [3] [20070126]
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:07: iomem range 0xfffe0000-0xffffffff could not be reserved
pnp: 00:07: iomem range 0x100000-0x3fffffff could not be reserved
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: 00:08: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:08: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:08: iomem range 0xf8000-0xfffff could not be reserved
pnp: 00:08: iomem range 0xd0000-0xd3fff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: e0000000-e1ffffff
  PREFETCH window: c0000000-dfffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
Time: tsc clocksource has been installed.
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
audit(1191552419.264:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Applying VIA southbridge workaround.
PCI: VIA PCI bridge detected. Disabling DAC.
PCI: Disabling Via external APIC routing
pci 0000:00:07.2: uhci_check_and_reset_hc: legsup =3D 0xa03a
pci 0000:00:07.2: Performing full reset
pci 0000:00:07.3: uhci_check_and_reset_hc: legsup =3D 0x2010
pci 0000:00:07.3: Performing full reset
Boot video device is 0000:01:00.0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xc0000000, mapped to 0xf8800000, using 3072k, total 16384k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
vesafb: protected mode interface info at c000:57d1
vesafb: pmi: set display start =3D c00c5865, set palette =3D c00c58b1
vesafb: pmi: ports =3D c010 c016 c054 c038 c03c c05c c000 c004 c0b0 c0b2 c0b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:0d' and the driver 'serial'
00:0d: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
pnp: match found with the PnP device '00:0e' and the driver 'serial'
00:0e: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
Floppy drive(s): fd0 is 1.44M, fd1 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: module loaded
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3Dxx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Clocksource tsc unstable (delta =3D 83963947 ns)
Time: pit clocksource has been installed.
hda: Maxtor 6L300R0, ATA DISK drive
hdb: HL-DT-ST DVDRAM GSA-4165B, ATAPI CD/DVD-ROM drive
hda: host side 80-wire cable detection failed, limiting max speed to UDMA33
hda: selected mode 0x42
hdb: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
hdd: LITE-ON LTR-52246S, ATAPI CD/DVD-ROM drive
hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: selected mode 0x42
hdd: selected mode 0x42
ide1 at 0x170-0x177,0x376 on irq 15
pnp: the driver 'ide' has been registered
hda: max request size: 512KiB
hda: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=3D36483/255/63, UDMA(33)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 hda12 >
hdb: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:04' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 5
Cannot allocate resource for EISA slot 6
EISA: Detected 0 cards.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: hda2: couldn't mount because of unsupported optional features (40).
kjournald2 starting.  Commit interval 5 seconds
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
VFS: Mounted root (ext4dev filesystem) readonly.
Freeing unused kernel memory: 408k freed
8139too Fast Ethernet driver 0.9.28
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:08.0
PCI: Sharing IRQ 10 with 0000:00:0c.0
eth0: RealTek RTL8139 at 0xdc00, 00:10:b5:8f:73:86, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139B'
PCI: setting IRQ 5 as level-triggered
PCI: Found IRQ 5 for device 0000:00:09.0
PCI: Sharing IRQ 5 with 0000:00:0d.0
eth1: RealTek RTL8139 at 0xe000, 00:08:a1:6d:38:47, IRQ 5
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
No module found in object
USB Universal Host Controller Interface driver v3.0
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:07.2
PCI: Sharing IRQ 11 with 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:0d.2
uhci_hcd 0000:00:07.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: detected 2 ports
uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:07.2: Performing full reset
uhci_hcd 0000:00:07.2: irq 9, io base 0x0000d400
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.23-rc9-git2-i486-1mn uhci_hcd
usb usb1: SerialNumber: 0000:00:07.2
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
via_agp: Unknown symbol agp_bridge
via_agp: Unknown symbol agp3_generic_sizes
via_agp: Unknown symbol global_cache_flush
via_agp: Unknown symbol agp_generic_enable
via_agp: Unknown symbol agp_generic_insert_memory
via_agp: Unknown symbol agp_generic_destroy_page
via_agp: Unknown symbol agp_off
via_agp: Unknown symbol agp_remove_bridge
via_agp: Unknown symbol agp_generic_mask_memory
via_agp: Unknown symbol agp_generic_alloc_by_type
via_agp: Unknown symbol agp_generic_free_by_type
via_agp: Unknown symbol agp_alloc_bridge
via_agp: Unknown symbol agp_add_bridge
via_agp: Unknown symbol get_agp_version
via_agp: Unknown symbol agp_generic_remove_memory
via_agp: Unknown symbol agp_generic_create_gatt_table
via_agp: Unknown symbol agp_generic_type_to_mask_type
via_agp: Unknown symbol agp_generic_free_gatt_table
via_agp: Unknown symbol agp_generic_alloc_page
via_agp: Unknown symbol agp_put_bridge
libata version 2.21 loaded.
drivers/usb/core/inode.c: creating file '001'
PCI: Found IRQ 11 for device 0000:00:07.3
PCI: Sharing IRQ 11 with 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:0d.2
uhci_hcd 0000:00:07.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: detected 2 ports
uhci_hcd 0000:00:07.3: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:07.3: Performing full reset
uhci_hcd 0000:00:07.3: irq 9, io base 0x0000d800
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.23-rc9-git2-i486-1mn uhci_hcd
usb usb2: SerialNumber: 0000:00:07.3
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:07.2: port 1 portsc 018a,00
hub 1-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
uhci_hcd 0000:00:07.2: port 2 portsc 018a,00
hub 1-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s
Linux video capture interface: v2.00
input: PC Speaker as /class/input/input2
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
i2c-core: driver [tveeprom] registered
parport_pc: VIA parallel port: io=3D0x378, irq=3D7
drivers/usb/core/inode.c: creating file '001'
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
vt596_smbus 0000:00:07.4: VT596_smba =3D 0x5000
i2c-adapter i2c-0: adapter [SMBus Via Pro adapter at 5000] registered
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:07.3: port 1 portsc 009b,00
hub 2-0:1.0: port 1, status 0101, change 0003, 12 Mb/s
PCI: Found IRQ 11 for device 0000:00:0d.2
PCI: Sharing IRQ 11 with 0000:00:0a.0
ohci1394: fw-host0: Remapped memory spaces reg 0xf8b4a000
ohci1394: fw-host0: Soft reset finished
ohci1394: fw-host0: Iso contexts reg: 000000a8 implemented: 0000000f
ohci1394: fw-host0: Iso contexts reg: 00000098 implemented: 000000ff
ohci1394: fw-host0: Receive DMA ctx=3D0 initialized
ohci1394: fw-host0: Receive DMA ctx=3D0 initialized
ohci1394: fw-host0: Transmit DMA ctx=3D0 initialized
ohci1394: fw-host0: Transmit DMA ctx=3D1 initialized
ohci1394: fw-host0: physUpperBoundOffset=3D00000000
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D[e3007000-e30077ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
ieee1394: CSR: setting expire to 25, HZ=3D250
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: ep0 maxpacket =3D 8
usb 2-1: default language 0x0409
usb 2-1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 2-1: Product: hp LaserJet 1010
usb 2-1: Manufacturer: Hewlett-Packard
usb 2-1: SerialNumber: 00CNFD758052
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:07.3: port 2 portsc 018a,00
hub 2-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s
gameport: EMU10K1 is pci0000:00:0d.1/gameport0, io 0xec00, speed 1242kHz
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb1: suspend_rh (auto-stop)
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
PCI: Found IRQ 11 for device 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:0d.2
bttv0: Bt848 (rev 18) at 0000:00:0a.0, irq: 11, latency: 32, mmio: 0xe3005000
bttv0: using:  *** UNKNOWN/GENERIC ***  [card=3D0,autodetected]
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ff27ff [init]
i2c-adapter i2c-1: adapter [bt848 #0 [sw]] registered
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x50
i2c-adapter i2c-1: master_xfer[0] W, addr=3D0x50, len=3D0
pnp: the driver 'rtc_cmos' has been registered
pnp: match found with the PnP device '00:03' and the driver 'rtc_cmos'
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
pnp: Device 00:03 does not support disabling.
rtc_cmos: probe of 00:03 failed with error -16
i2c-adapter i2c-1: NAK from device addr 0x50 msg #0
i2c-adapter i2c-1: master_xfer[0] W, addr=3D0x50, len=3D1
i2c-adapter i2c-1: NAK from device addr 0x50 msg #0
tveeprom 1-0050: Huh, no eeprom present (err=3D-121)?
bttv0: tuner type unset
bttv0: i2c: checking for MSP34xx @ 0x80... <7>i2c-adapter i2c-1: master_xfer[0] R, addr=3D0x40, len=3D1
ohci1394: fw-host0: IntEvent: 00020010
ohci1394: fw-host0: irq_handler: Bus reset requested
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Got RQPkt interrupt status=3D0x00008409
ohci1394: fw-host0: IntEvent: 00010000
ohci1394: fw-host0: SelfID interrupt received (phyid 0, root)
ohci1394: fw-host0: SelfID packet 0x807f8c52 received
ieee1394: Including SelfID 0x528c7f80
ohci1394: fw-host0: SelfID for this node is 0x807f8c52
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=3Dffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ... irm_id: 0xFFC0 node_id: 0xFFC0
ieee1394: NodeMgr: Processing reset for host 0
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=3D0 ... discarded
i2c-adapter i2c-1: NAK from device addr 0x40 msg #0
not found
bttv0: i2c: checking for TDA9875 @ 0xb0... <7>i2c-adapter i2c-1: master_xfer[0] R, addr=3D0x58, len=3D1
ieee1394: send packet at S100: 003c0000 ffc3ffff
ohci1394: fw-host0: Inserting packet for node 0-00:0000, tlabel=3D0, tcode=3D0x0, speed=3D0
ohci1394: fw-host0: Starting transmit DMA ctx=3D0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=3D0x00008011
ohci1394: fw-host0: Packet sent to node 60 tcode=3D0xE tLabel=3D0 ack=3D0x11 spd=3D0 data=3D0x00000000 ctx=3D0
ieee1394: send packet local: ffc00140 ffc0ffff f0000400
ieee1394: received packet: ffc00140 ffc0ffff f0000400
ieee1394: send packet local: ffc00160 ffc00000 00000000 72840404
ieee1394: received packet: ffc00160 ffc00000 00000000 72840404
ieee1394: send packet local: ffc00540 ffc0ffff f0000404
ieee1394: received packet: ffc00540 ffc0ffff f0000404
ieee1394: send packet local: ffc00560 ffc00000 00000000 34393331
ieee1394: received packet: ffc00560 ffc00000 00000000 34393331
ieee1394: send packet local: ffc00940 ffc0ffff f0000408
ieee1394: received packet: ffc00940 ffc0ffff f0000408
ieee1394: send packet local: ffc00960 ffc00000 00000000 32a264e0
ieee1394: received packet: ffc00960 ffc00000 00000000 32a264e0
ieee1394: send packet local: ffc00d40 ffc0ffff f000040c
ieee1394: received packet: ffc00d40 ffc0ffff f000040c
ieee1394: send packet local: ffc00d60 ffc00000 00000000 003c0200
ieee1394: received packet: ffc00d60 ffc00000 00000000 003c0200
ieee1394: send packet local: ffc01140 ffc0ffff f0000410
ieee1394: received packet: ffc01140 ffc0ffff f0000410
ieee1394: send packet local: ffc01160 ffc00000 00000000 152d0131
ieee1394: received packet: ffc01160 ffc00000 00000000 152d0131
ieee1394: send packet local: ffc01550 ffc0ffff f0000400 04000000
ieee1394: received packet: ffc01550 ffc0ffff f0000400 04000000
ieee1394: send packet local: ffc01570 ffc00000 00000000 04000000
ieee1394: received packet: ffc01570 ffc00000 00000000 04000000
ieee1394: NodeMgr: raw=3D0xe064a232 irmc=3D1 cmc=3D1 isc=3D1 bmc=3D0 pmc=3D0 cyc_clk_acc=3D100 max_rec=3D2048 max_rom=3D1024 gen=3D3 lspd=3D2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c0031012d15]
i2c-adapter i2c-1: NAK from device addr 0x58 msg #0
not found
bttv0: i2c: checking for TDA7432 @ 0x8a... <7>i2c-adapter i2c-1: master_xfer[0] R, addr=3D0x45, len=3D1
i2c-adapter i2c-1: NAK from device addr 0x45 msg #0
not found
bttv0: registered device video0
bttv0: registered device vbi0
PCI: Found IRQ 5 for device 0000:00:0d.0
PCI: Sharing IRQ 5 with 0000:00:09.0
AC'97 0 analog subsections not ready
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
usb usb1: suspend_rh
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
eth1: link down
usblp 2-1:1.0: usb_probe_interface
usblp 2-1:1.0: usb_probe_interface - got id
usb_endpoint usbdev2.2_ep01: ep_device_release called for usbdev2.2_ep01
usb_endpoint usbdev2.2_ep81: ep_device_release called for usbdev2.2_ep81
usb_endpoint usbdev2.2_ep82: ep_device_release called for usbdev2.2_ep82
drivers/usb/core/file.c: looking for a minor, starting at 0
usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0C17
usbcore: registered new interface driver usblp
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EXT4-fs warning: mounting fs with errors, running e2fsck is recommended
EXT4 FS on hda2, internal journal
lp0: using parport0 (interrupt-driven).
lp0: console ready
PPP generic driver version 2.4.2
NET: Registered protocol family 24
No module found in object
via_agp: Unknown symbol agp_bridge
via_agp: Unknown symbol agp3_generic_sizes
via_agp: Unknown symbol global_cache_flush
via_agp: Unknown symbol agp_generic_enable
via_agp: Unknown symbol agp_generic_insert_memory
via_agp: Unknown symbol agp_generic_destroy_page
via_agp: Unknown symbol agp_off
via_agp: Unknown symbol agp_remove_bridge
via_agp: Unknown symbol agp_generic_mask_memory
via_agp: Unknown symbol agp_generic_alloc_by_type
via_agp: Unknown symbol agp_generic_free_by_type
via_agp: Unknown symbol agp_alloc_bridge
via_agp: Unknown symbol agp_add_bridge
via_agp: Unknown symbol get_agp_version
via_agp: Unknown symbol agp_generic_remove_memory
via_agp: Unknown symbol agp_generic_create_gatt_table
via_agp: Unknown symbol agp_generic_type_to_mask_type
via_agp: Unknown symbol agp_generic_free_gatt_table
via_agp: Unknown symbol agp_generic_alloc_page
via_agp: Unknown symbol agp_put_bridge
No module found in object
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
No module found in object
drm: Unknown symbol agp_bind_memory
drm: Unknown symbol agp_enable
drm: Unknown symbol agp_find_bridge
drm: Unknown symbol agp_backend_acquire
drm: Unknown symbol agp_free_memory
drm: Unknown symbol agp_allocate_memory
drm: Unknown symbol agp_unbind_memory
drm: Unknown symbol agp_copy_info
drm: Unknown symbol agp_backend_release
radeon: Unknown symbol drm_open
radeon: Unknown symbol drm_fasync
radeon: Unknown symbol drm_poll
radeon: Unknown symbol drm_get_resource_len
radeon: Unknown symbol drm_core_get_reg_ofs
radeon: Unknown symbol drm_irq_uninstall
radeon: Unknown symbol drm_ioctl
radeon: Unknown symbol drm_exit
radeon: Unknown symbol drm_getsarea
radeon: Unknown symbol drm_debug
radeon: Unknown symbol drm_core_ioremapfree
radeon: Unknown symbol drm_core_get_map_ofs
radeon: Unknown symbol drm_init
radeon: Unknown symbol drm_addmap
radeon: Unknown symbol drm_get_resource_start
radeon: Unknown symbol drm_vbl_send_signals
radeon: Unknown symbol drm_ati_pcigart_init
radeon: Unknown symbol drm_core_ioremap
radeon: Unknown symbol drm_mmap
radeon: Unknown symbol drm_order
radeon: Unknown symbol drm_ati_pcigart_cleanup
radeon: Unknown symbol drm_core_reclaim_buffers
radeon: Unknown symbol drm_release
No module found in object
drm: Unknown symbol agp_bind_memory
drm: Unknown symbol agp_enable
drm: Unknown symbol agp_find_bridge
drm: Unknown symbol agp_backend_acquire
drm: Unknown symbol agp_free_memory
drm: Unknown symbol agp_allocate_memory
drm: Unknown symbol agp_unbind_memory
drm: Unknown symbol agp_copy_info
drm: Unknown symbol agp_backend_release
No module found in object
drm: Unknown symbol agp_bind_memory
drm: Unknown symbol agp_enable
drm: Unknown symbol agp_find_bridge
drm: Unknown symbol agp_backend_acquire
drm: Unknown symbol agp_free_memory
drm: Unknown symbol agp_allocate_memory
drm: Unknown symbol agp_unbind_memory
drm: Unknown symbol agp_copy_info
drm: Unknown symbol agp_backend_release
savage: Unknown symbol drm_open
savage: Unknown symbol drm_fasync
savage: Unknown symbol drm_poll
savage: Unknown symbol drm_get_resource_len
savage: Unknown symbol drm_core_get_reg_ofs
savage: Unknown symbol drm_ioctl
savage: Unknown symbol drm_exit
savage: Unknown symbol drm_getsarea
savage: Unknown symbol drm_debug
savage: Unknown symbol drm_core_ioremapfree
savage: Unknown symbol drm_core_get_map_ofs
savage: Unknown symbol drm_init
savage: Unknown symbol drm_addmap
savage: Unknown symbol drm_get_resource_start
savage: Unknown symbol drm_core_ioremap
savage: Unknown symbol drm_mmap
savage: Unknown symbol drm_core_reclaim_buffers
savage: Unknown symbol drm_release
Capability LSM initialized
fuse init (API version 7.8)
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald2 starting.  Commit interval 5 seconds
EXT4-fs warning: maximal mount count reached, running e2fsck is recommended
EXT4 FS on hda12, internal journal
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
......

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D dmesg 2.6.23-rc8-git4  (still good/without drm problem ) =3D=3D=3D=3D=3D=3D=3D
Linux version 2.6.23-rc8-git4-i486-1mn (root@werner) (gcc version 4.2.0 20061031 (prerelease)) #1 SMP Mon Oct 1 10:26:32 GFT 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000000f00000 (usable)
 BIOS-e820: 0000000000f00000 - 0000000001000000 (reserved)
 BIOS-e820: 0000000001000000 - 0000000040000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
128MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 262144) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262144
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   262144
On node 0 totalpages: 262144
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 256 pages used for memmap
  HighMem zone: 32512 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.2 present.
Allocating PCI resources starting at 50000000 (gap: 40000000:bfff0000)
Built 1 zonelists in Zone order.  Total pages: 260096
Kernel command line: BOOT_IMAGE=3D2623rc8git4 ro root=3D302 4 root=3D/dev/hda2 devfs=3Dnomount noapic nolapic acpi=3Dht
mapped APIC to ffffb000 (0180d000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 999.604 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1033016k/1048576k available (3099k kernel code, 13956k reserved, 1098k data, 408k init, 131072k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0521000 - 0xc0587000   ( 408 kB)
      .data : 0xc0406e45 - 0xc0519804   (1098 kB)
      .text : 0xc0100000 - 0xc0406e45   (3099 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=3D22, HWalign=3D32, Order=3D0-1, MinObjects=3D4, CPUs=3D1, Nodes=3D1
Calibrating delay using timer specific routine.. 2001.49 BogoMIPS (lpj=3D4002985)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: CLK_CTL MSR was fff7f37f. Reprogramming to 2007f37f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f9ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 16k freed
CPU0: AMD Athlon(tm) Processor stepping 01
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.10 entry at 0xfb160, last bus=3D1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fbc30
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbc60, dseg 0xf0000
PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Disabling VIA memory write queue (PCI ID 0305, rev 03): [55] 8d & 1f -> 0d
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Using IRQ router VIA [1106/0686] at 0000:00:07.0
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread C1902000 could not acquire Mutex [3] [20070126]
pnp: the driver 'system' has been registered
pnp: match found with the PnP device '00:07' and the driver 'system'
pnp: 00:07: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:07: iomem range 0xfffe0000-0xffffffff could not be reserved
pnp: 00:07: iomem range 0x100000-0x3fffffff could not be reserved
pnp: match found with the PnP device '00:08' and the driver 'system'
pnp: 00:08: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:08: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:08: iomem range 0xf8000-0xfffff could not be reserved
pnp: 00:08: iomem range 0xd0000-0xd3fff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: e0000000-e1ffffff
  PREFETCH window: c0000000-dfffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
Time: tsc clocksource has been installed.
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
audit: initializing netlink socket (disabled)
audit(1191553668.264:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Applying VIA southbridge workaround.
PCI: VIA PCI bridge detected. Disabling DAC.
PCI: Disabling Via external APIC routing
pci 0000:00:07.2: uhci_check_and_reset_hc: legsup =3D 0xa03a
pci 0000:00:07.2: Performing full reset
pci 0000:00:07.3: uhci_check_and_reset_hc: legsup =3D 0x2010
pci 0000:00:07.3: Performing full reset
Boot video device is 0000:01:00.0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xc0000000, mapped to 0xf8800000, using 3072k, total 16384k
vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
vesafb: protected mode interface info at c000:57d1
vesafb: pmi: set display start =3D c00c5865, set palette =3D c00c58b1
vesafb: pmi: ports =3D c010 c016 c054 c038 c03c c05c c000 c004 c0b0 c0b2 c0b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
pnp: the driver 'serial' has been registered
pnp: match found with the PnP device '00:0d' and the driver 'serial'
00:0d: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
pnp: match found with the PnP device '00:0e' and the driver 'serial'
00:0e: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
Floppy drive(s): fd0 is 1.44M, fd1 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
loop: module loaded
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3Dxx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
Clocksource tsc unstable (delta =3D 83987942 ns)
Time: pit clocksource has been installed.
hda: Maxtor 6L300R0, ATA DISK drive
hdb: HL-DT-ST DVDRAM GSA-4165B, ATAPI CD/DVD-ROM drive
hda: host side 80-wire cable detection failed, limiting max speed to UDMA33
hda: selected mode 0x42
hdb: selected mode 0x42
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
hdd: LITE-ON LTR-52246S, ATAPI CD/DVD-ROM drive
hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
hdc: selected mode 0x42
hdd: selected mode 0x42
ide1 at 0x170-0x177,0x376 on irq 15
pnp: the driver 'ide' has been registered
hda: max request size: 512KiB
hda: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=3D36483/255/63, UDMA(33)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 hda12 >
hdb: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
pnp: the driver 'i8042 kbd' has been registered
pnp: match found with the PnP device '00:04' and the driver 'i8042 kbd'
pnp: the driver 'i8042 aux' has been registered
pnp: match found with the PnP device '00:0a' and the driver 'i8042 aux'
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 5
Cannot allocate resource for EISA slot 6
EISA: Detected 0 cards.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input1
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: hda2: couldn't mount because of unsupported optional features (40).
kjournald2 starting.  Commit interval 5 seconds
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
VFS: Mounted root (ext4dev filesystem) readonly.
Freeing unused kernel memory: 408k freed
8139too Fast Ethernet driver 0.9.28
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:08.0
PCI: Sharing IRQ 10 with 0000:00:0c.0
eth0: RealTek RTL8139 at 0xdc00, 00:10:b5:8f:73:86, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139B'
PCI: setting IRQ 5 as level-triggered
PCI: Found IRQ 5 for device 0000:00:09.0
PCI: Sharing IRQ 5 with 0000:00:0d.0
eth1: RealTek RTL8139 at 0xe000, 00:08:a1:6d:38:47, IRQ 5
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
USB Universal Host Controller Interface driver v3.0
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:07.2
PCI: Sharing IRQ 11 with 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:0d.2
uhci_hcd 0000:00:07.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: detected 2 ports
uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:07.2: Performing full reset
uhci_hcd 0000:00:07.2: irq 9, io base 0x0000d400
usb usb1: default language 0x0409
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.23-rc8-git4-i486-1mn uhci_hcd
usb usb1: SerialNumber: 0000:00:07.2
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 2ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
Linux video capture interface: v2.00
Linux agpgart interface v0.102
drivers/usb/core/inode.c: creating file '001'
PCI: Found IRQ 11 for device 0000:00:07.3
PCI: Sharing IRQ 11 with 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:0d.2
uhci_hcd 0000:00:07.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: detected 2 ports
uhci_hcd 0000:00:07.3: uhci_check_and_reset_hc: cmd =3D 0x0000
uhci_hcd 0000:00:07.3: Performing full reset
uhci_hcd 0000:00:07.3: irq 9, io base 0x0000d800
usb usb2: default language 0x0409
usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.23-rc8-git4-i486-1mn uhci_hcd
usb usb2: SerialNumber: 0000:00:07.3
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:07.2: port 1 portsc 018a,00
hub 1-0:1.0: port 1, status 0300, change 0003, 1.5 Mb/s
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x300
uhci_hcd 0000:00:07.2: port 2 portsc 018a,00
hub 1-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s
libata version 2.21 loaded.
i2c-core: driver [tveeprom] registered
hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
input: PC Speaker as /class/input/input2
drivers/usb/core/inode.c: creating file '001'
gameport: EMU10K1 is pci0000:00:0d.1/gameport0, io 0xec00, speed 1242kHz
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:07.3: port 1 portsc 009b,00
hub 2-0:1.0: port 1, status 0101, change 0003, 12 Mb/s
vt596_smbus 0000:00:07.4: VT596_smba =3D 0x5000
i2c-adapter i2c-0: adapter [SMBus Via Pro adapter at 5000] registered
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
PCI: Found IRQ 11 for device 0000:00:0d.2
PCI: Sharing IRQ 11 with 0000:00:0a.0
ohci1394: fw-host0: Remapped memory spaces reg 0xf8b7e000
ohci1394: fw-host0: Soft reset finished
ohci1394: fw-host0: Iso contexts reg: 000000a8 implemented: 0000000f
ohci1394: fw-host0: Iso contexts reg: 00000098 implemented: 000000ff
ohci1394: fw-host0: Receive DMA ctx=3D0 initialized
ohci1394: fw-host0: Receive DMA ctx=3D0 initialized
ohci1394: fw-host0: Transmit DMA ctx=3D0 initialized
ohci1394: fw-host0: Transmit DMA ctx=3D1 initialized
ohci1394: fw-host0: physUpperBoundOffset=3D00000000
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[11]  MMIO=3D[e3007000-e30077ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
ieee1394: CSR: setting expire to 25, HZ=3D250
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
parport_pc: VIA parallel port: io=3D0x378, irq=3D7
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: ep0 maxpacket =3D 8
usb 2-1: default language 0x0409
usb 2-1: new device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
usb 2-1: Product: hp LaserJet 1010
usb 2-1: Manufacturer: Hewlett-Packard
usb 2-1: SerialNumber: 00CNFD758052
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usb 2-1:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:07.3: port 2 portsc 018a,00
hub 2-0:1.0: port 2, status 0300, change 0003, 1.5 Mb/s
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 256M @ 0xb0000000
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x300
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
PCI: Found IRQ 11 for device 0000:00:0a.0
PCI: Sharing IRQ 11 with 0000:00:0d.2
bttv0: Bt848 (rev 18) at 0000:00:0a.0, irq: 11, latency: 32, mmio: 0xe3005000
usb usb1: suspend_rh (auto-stop)
bttv0: using:  *** UNKNOWN/GENERIC ***  [card=3D0,autodetected]
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ff27ff [init]
i2c-adapter i2c-1: adapter [bt848 #0 [sw]] registered
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x50
i2c-adapter i2c-1: master_xfer[0] W, addr=3D0x50, len=3D0
i2c-adapter i2c-1: NAK from device addr 0x50 msg #0
i2c-adapter i2c-1: master_xfer[0] W, addr=3D0x50, len=3D1
i2c-adapter i2c-1: NAK from device addr 0x50 msg #0
tveeprom 1-0050: Huh, no eeprom present (err=3D-121)?
bttv0: tuner type unset
bttv0: i2c: checking for MSP34xx @ 0x80... <7>i2c-adapter i2c-1: master_xfer[0] R, addr=3D0x40, len=3D1
pnp: the driver 'rtc_cmos' has been registered
pnp: match found with the PnP device '00:03' and the driver 'rtc_cmos'
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
pnp: Device 00:03 does not support disabling.
rtc_cmos: probe of 00:03 failed with error -16
ohci1394: fw-host0: IntEvent: 00020010
ohci1394: fw-host0: irq_handler: Bus reset requested
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Got RQPkt interrupt status=3D0x00008409
ohci1394: fw-host0: IntEvent: 00010000
ohci1394: fw-host0: SelfID interrupt received (phyid 0, root)
ohci1394: fw-host0: SelfID packet 0x807f8c52 received
ieee1394: Including SelfID 0x528c7f80
ohci1394: fw-host0: SelfID for this node is 0x807f8c52
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=3Dffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ... irm_id: 0xFFC0 node_id: 0xFFC0
ieee1394: NodeMgr: Processing reset for host 0
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=3D0 ... discarded
i2c-adapter i2c-1: NAK from device addr 0x40 msg #0
not found
bttv0: i2c: checking for TDA9875 @ 0xb0... <7>i2c-adapter i2c-1: master_xfer[0] R, addr=3D0x58, len=3D1
i2c-adapter i2c-1: NAK from device addr 0x58 msg #0
not found
bttv0: i2c: checking for TDA7432 @ 0x8a... <7>i2c-adapter i2c-1: master_xfer[0] R, addr=3D0x45, len=3D1
i2c-adapter i2c-1: NAK from device addr 0x45 msg #0
not found
bttv0: registered device video0
bttv0: registered device vbi0
ieee1394: send packet at S100: 003c0000 ffc3ffff
ohci1394: fw-host0: Inserting packet for node 0-00:0000, tlabel=3D0, tcode=3D0x0, speed=3D0
ohci1394: fw-host0: Starting transmit DMA ctx=3D0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=3D0x00008011
ohci1394: fw-host0: Packet sent to node 60 tcode=3D0xE tLabel=3D0 ack=3D0x11 spd=3D0 data=3D0x00000000 ctx=3D0
ieee1394: send packet local: ffc00140 ffc0ffff f0000400
ieee1394: received packet: ffc00140 ffc0ffff f0000400
ieee1394: send packet local: ffc00160 ffc00000 00000000 72840404
ieee1394: received packet: ffc00160 ffc00000 00000000 72840404
PCI: Found IRQ 5 for device 0000:00:0d.0
PCI: Sharing IRQ 5 with 0000:00:09.0
ieee1394: send packet local: ffc00540 ffc0ffff f0000404
ieee1394: received packet: ffc00540 ffc0ffff f0000404
ieee1394: send packet local: ffc00560 ffc00000 00000000 34393331
ieee1394: received packet: ffc00560 ffc00000 00000000 34393331
ieee1394: send packet local: ffc00940 ffc0ffff f0000408
ieee1394: received packet: ffc00940 ffc0ffff f0000408
ieee1394: send packet local: ffc00960 ffc00000 00000000 32a264e0
ieee1394: received packet: ffc00960 ffc00000 00000000 32a264e0
ieee1394: send packet local: ffc00d40 ffc0ffff f000040c
ieee1394: received packet: ffc00d40 ffc0ffff f000040c
ieee1394: send packet local: ffc00d60 ffc00000 00000000 003c0200
ieee1394: received packet: ffc00d60 ffc00000 00000000 003c0200
ieee1394: send packet local: ffc01140 ffc0ffff f0000410
ieee1394: received packet: ffc01140 ffc0ffff f0000410
ieee1394: send packet local: ffc01160 ffc00000 00000000 152d0131
ieee1394: received packet: ffc01160 ffc00000 00000000 152d0131
ieee1394: send packet local: ffc01550 ffc0ffff f0000400 04000000
ieee1394: received packet: ffc01550 ffc0ffff f0000400 04000000
ieee1394: send packet local: ffc01570 ffc00000 00000000 04000000
ieee1394: received packet: ffc01570 ffc00000 00000000 04000000
ieee1394: NodeMgr: raw=3D0xe064a232 irmc=3D1 cmc=3D1 isc=3D1 bmc=3D0 pmc=3D0 cyc_clk_acc=3D100 max_rec=3D2048 max_rom=3D1024 gen=3D3 lspd=3D2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c0031012d15]
AC'97 0 analog subsections not ready
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
usb usb1: suspend_rh
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
eth1: link down
usblp 2-1:1.0: usb_probe_interface
usblp 2-1:1.0: usb_probe_interface - got id
usb_endpoint usbdev2.2_ep01: ep_device_release called for usbdev2.2_ep01
usb_endpoint usbdev2.2_ep81: ep_device_release called for usbdev2.2_ep81
usb_endpoint usbdev2.2_ep82: ep_device_release called for usbdev2.2_ep82
drivers/usb/core/file.c: looking for a minor, starting at 0
usblp0: USB Bidirectional printer dev 2 if 0 alt 1 proto 2 vid 0x03F0 pid 0x0C17
usbcore: registered new interface driver usblp
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EXT4-fs warning: mounting fs with errors, running e2fsck is recommended
EXT4 FS on hda2, internal journal
lp0: using parport0 (interrupt-driven).
lp0: console ready
PPP generic driver version 2.4.2
NET: Registered protocol family 24
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
Capability LSM initialized
fuse init (API version 7.8)
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald2 starting.  Commit interval 5 seconds
EXT4-fs warning: maximal mount count reached, running e2fsck is recommended
EXT4 FS on hda12, internal journal
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
........






=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
*** www.copaya.yi.org / www.monkey.is-a-geek.net ***
O =FAnico servidor comunit=E1rio na Guiana-Francesa.  Situado no local, r=E1pido, imuno contra guerras / desastres na Europa.   Servi=E7o n=E3o-comercial e gratuito de:  http (forum, p=E1gina web), irc (chat), ftp (download), name (subdomain) .

--bound1191565675--

