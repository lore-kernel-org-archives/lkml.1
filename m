Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbXE2Sap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbXE2Sap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbXE2Sae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:30:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54496 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754573AbXE2Sac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:30:32 -0400
Date: Tue, 29 May 2007 11:30:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1: SLUB
In-Reply-To: <465C6D4B.90403@oracle.com>
Message-ID: <Pine.LNX.4.64.0705291126190.24395@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <20070528212250.eb38af64.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705291012120.23611@schroedinger.engr.sgi.com>
 <465C6D4B.90403@oracle.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-2000842699-1180463431=:24395"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-2000842699-1180463431=:24395
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 29 May 2007, Randy Dunlap wrote:

> Nope, still no booty.

Your .configs boot fine here (until it panics since I \have another root=20
fs)

root (hd0,0)
 Filesystem type is reiserfs, partition type 0x83
kernel /boot/vmlinuz root=3D/dev/hda1 console=3DttyS0,115200
   [Linux-bzImage, setup=3D0x2800, size=3D0x245d88]

=EEinux version 2.6.22-rc2-mm1slub (christoph@qirst.com) (gcc version 4.1.2=
=20
20061115 (prerelease) (Deb
an 4.1.1-21)) #37 SMP Tue May 29 11:24:17 PDT 2007
Command line: root=3D/dev/hda1 console=3DttyS0,115200
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
end_pfn_map =3D 1048576
DMI 2.2 present.
ACPI: RSDP 000F6EB0, 0014 (r0 AWARD )
ACPI: RSDT 3FFF3000, 002C (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF30C0, 3AA4 (r1 AWARD  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF6B80, 005A (r1 AWARD  AWRDACPI 42302E31 AWRD        0)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262128
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 dfl dfl)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 -=20
00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 -=20
00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 -=20
0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PERCPU: Allocating 33416 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:=20
256420
Kernel command line: root=3D/dev/hda1 console=3DttyS0,115200
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2199.446 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ e0000000 size 128 MB
Memory: 1023688k/1048512k available (3194k kernel code, 24184k reserved,=20
1723k data, 228k init)
SLUB: Genslabs=3D23, HWalign=3D64, Order=3D0-3, MinObjects=3D16, Processors=
=3D1,=20
Nodes=3D1
Calibrating delay using timer specific routine.. 4400.89 BogoMIPS=20
(lpj=3D8801786)
kswapd reclaim order set to 3
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
SMP alternatives: switching to UP code
Freeing SMP alternatives: 25k freed
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 13746556
Detected 13.746 MHz APIC timer.
Brought up 1 CPUs
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,=20
disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,=20
disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,=20
disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a=
=20
report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 128M @ 0xe0000000
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
NET: Registered protocol family 2
Time: tsc clocksource has been installed.
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
microcode: CPU0 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit: initializing netlink socket (disabled)
audit(1180463170.232:1): initialized
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [FUTS]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
ppdev: user-space parallel port driver
Software Watchdog Timer: 0.07 initialized. soft_noboot=3D0 soft_margin=3D60=
=20
sec (nowayout=3D 0)
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is=
=20
60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 64000K size 1024 blocksize
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
via-rhine: Broken BIOS detected, avoid_D3 enabled.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with=20
idebus=3Dxx
hda: WDC WD2500JB-00KFA0, ATA DISK drive
hdc: ST3160023A, ATA DISK drive
hdd: Maxtor 4A160J0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=3D30401/255/63
hda: cache flushes supported
 hda: hda1 hda2 < hda5 >
hdc: max request size: 512KiB
hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=3D19457/255/63
hdc: cache flushes supported
 hdc: hdc1
hdd: max request size: 512KiB
hdd: 320173056 sectors (163928 MB) w/2048KiB Cache, CHS=3D19929/255/63
hdd: cache flushes supported
 hdd: hdd1 hdd2 hdd3 hdd4
ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.3: irq 23, io mem 0xec021000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: new device found, idVendor=3D0000, idProduct=3D0000
usb usb1: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.22-rc2-mm1slub ehci_hcd
usb usb1: SerialNumber: 0000:00:03.3
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 20, io mem 0xec023000
usb usb2: new device found, idVendor=3D0000, idProduct=3D0000
usb usb2: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.22-rc2-mm1slub ohci_hcd
usb usb2: SerialNumber: 0000:00:03.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 21, io mem 0xec024000
usb usb3: new device found, idVendor=3D0000, idProduct=3D0000
usb usb3: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.22-rc2-mm1slub ohci_hcd
usb usb3: SerialNumber: 0000:00:03.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:03.2: irq 22, io mem 0xec020000
usb usb4: new device found, idVendor=3D0000, idProduct=3D0000
usb usb4: new device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.22-rc2-mm1slub ohci_hcd
usb usb4: SerialNumber: 0000:00:03.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
USB Universal Host Controller Interface driver v3.0
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
i2c /dev entries driver
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation=20
<jketreno@linux.intel.com>
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ processors (1 cpu=20
cores) (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x2
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x6
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x6
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
List of all partitions:
0300  244198584 hda driver: ide-disk
  0301  241191846 hda1
  0302          1 hda2
  0305    3004123 hda5
1600  156290904 hdc driver: ide-disk
  1601  156288321 hdc1
1640  160086528 hdd driver: ide-disk
  1641   39070048 hdd1
  1642   39070080 hdd2
  1643   39070080 hdd3
  1644   42869452 hdd4
No filesystem could mount root, tried:  ext3 ext2 msdos vfat iso9660
Kernel panic - not syncing: VFS: Unable to mount root fs on=20
unknown-block(3,1)

---1700579579-2000842699-1180463431=:24395--
