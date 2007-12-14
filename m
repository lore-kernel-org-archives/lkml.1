Return-Path: <linux-kernel-owner+w=401wt.eu-S964823AbXLNA2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823AbXLNA2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765248AbXLNA21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:28:27 -0500
Received: from mail3.key-systems.net ([81.3.43.213]:35694 "HELO
	mail3.key-systems.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764435AbXLNA2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:28:24 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 19:28:23 EST
Subject: Strange ATA problems
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-Dm3iS718mObcR+7kUU44"
Date: Fri, 14 Dec 2007 01:21:39 +0100
Message-Id: <1197591699.3453.38.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Dm3iS718mObcR+7kUU44
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi everybody.

Today I've experienced a very strange problem.

I have a CD/DVD drive connected via USB,... and while woking the system
suddenly freezed (at least those processes that tried to access the
hardsisk).

Looking at dmesg it showed me this:
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNK3] -> GSI 18 (level,
high) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed Sep 12
14:08:38 PDT 2007
usb 1-1: new high speed USB device using ehci_hcd and address 5
usb 1-1: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
scsi 6:0:0:0: CD-ROM            PLEXTOR  DVD-ROM PX-130A  1.03 PQ: 0
ANSI: 0 CCS
sr0: scsi3-mmc drive: 0x/50x cd/rw xa/form2 cdda tray
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr 6:0:0:0: Attached scsi generic sg3 type 5
usb-storage: device scan complete
end_request: I/O error, dev sr0, sector 308688
Buffer I/O error on device sr0, logical block 77172
Buffer I/O error on device sr0, logical block 77173
end_request: I/O error, dev sr0, sector 308688
Buffer I/O error on device sr0, logical block 77172
Buffer I/O error on device sr0, logical block 77173
end_request: I/O error, dev sr0, sector 308816
Buffer I/O error on device sr0, logical block 77204
Buffer I/O error on device sr0, logical block 77205
end_request: I/O error, dev sr0, sector 308816
Buffer I/O error on device sr0, logical block 77204
Buffer I/O error on device sr0, logical block 77205
UDF-fs: No VRS found
tun0: Disabled Privacy Extensions

So I've plugged out the USB connected drive and then those processes
continued.

Anyway, now I got the following stuff:
usb 1-1: USB disconnect, address 5
ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000
status 0x400 next cpb count 0x0 next cpb idx 0x0
ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 4: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 5: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 6: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 7: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 8: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 9: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 10: ctl_flags 0x1f, resp_flags 0x2
ata1: timeout waiting for ADMA IDLE, stat=3D0x400
ata1.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x2 frozen
ata1.00: cmd 61/10:00:2e:07:a8/01:00:0b:00:00/40 tag 0 cdb 0x0 data
139264 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/18:08:07:3f:02/00:00:00:00:00/40 tag 1 cdb 0x0 data
12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:10:b6:a8:23/00:00:0d:00:00/40 tag 2 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:18:f6:37:68/00:00:0d:00:00/40 tag 3 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:20:9e:32:a1/00:00:0d:00:00/40 tag 4 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:28:4f:00:dc/00:00:02:00:00/40 tag 5 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:30:6f:00:dc/00:00:02:00:00/40 tag 6 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:38:3f:03:2c/00:00:05:00:00/40 tag 7 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:40:36:ea:72/00:00:0d:00:00/40 tag 8 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:48:7f:00:c4/00:00:05:00:00/40 tag 9 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:50:47:02:d8/00:00:05:00:00/40 tag 10 cdb 0x0 data
4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA


ata1/sda is my harddisk (at least one of them)
What do does errors mean? Is this probably a hardware failure?
And how can the CD/DVD problem relate to this?

Any ideas?

Thanks and best wishes,
Christoph Anton Mitterer.


total demsg:
usb-dib0700.force_lna_activation=3D1 iommu=3Dsoft=20
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009b000 (usable)
 BIOS-e820: 000000000009b000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000da000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff80000 (usable)
 BIOS-e820: 000000007ff80000 - 000000007ff91000 (ACPI data)
 BIOS-e820: 000000007ff91000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 0000000080000000 - 000000009ff80000 (usable)
 BIOS-e820: 000000009ff80000 - 00000000a0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000160000000 (usable)
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524160) 1 entries of 3200 used
Entering add_active_range(0, 524288, 655232) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1441792) 3 entries of 3200 used
end_pfn_map =3D 1441792
DMI present.
ACPI: RSDP 000F78F0, 0014 (r0 PTLTD )
ACPI: RSDT 7FF8B258, 0038 (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP 7FF90B06, 0074 (r1 NVIDIA CK8S      6040000 PTL_    F4240)
ACPI: DSDT 7FF8B290, 5876 (r1 NVIDIA      CK8  6040000 MSFT  100000E)
ACPI: FACS 7FF91FC0, 0040
ACPI: SPCR 7FF90B7A, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: APIC 7FF90BCA, 009E (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 7FF90C68, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 7FF90C90, 0370 (r1 PTLTD  POWERNOW  6040000  LTP        1)
Scanning NUMA topology in Northbridge 24
CPU has 2 num_cores
Number of nodes 2
Node 0 using interleaving mode 1/0
No NUMA configuration found
Faking a node at 0000000000000000-0000000160000000
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524160) 1 entries of 3200 used
Entering add_active_range(0, 524288, 655232) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 1441792) 3 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000160000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1441792
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      155
    0:      256 ->   524160
    0:   524288 ->   655232
    0:  1048576 ->  1441792
On node 0 totalpages: 1048219
  DMA zone: 56 pages used for memmap
  DMA zone: 1368 pages reserved
  DMA zone: 2571 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 636728 pages, LIFO batch:31
  Normal zone: 5376 pages used for memmap
  Normal zone: 387840 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xd0000000] gsi_base[24])
IOAPIC[1]: apic_id 5, address 0xd0000000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xd0001000] gsi_base[28])
IOAPIC[2]: apic_id 6, address 0xd0001000, GSI 28-31
ACPI: IOAPIC (id[0x07] address[0xd0800000] gsi_base[32])
IOAPIC[3]: apic_id 7, address 0xd0800000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at a4000000 (gap: a0000000:40000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 30120 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 1027139
Policy zone: Normal
Kernel command line: root=3D/dev/sda1 ro mce=3Dbootlog snd-ice1724.index=3D=
0
snd-intel8x0.index=3D1 snd-intel8x0.ac97_quirk=3Dhp_only
dvb-usb-dib0700.force_lna_activation=3D1 iommu=3Dsoft=20
Unknown boot option `dvb-usb-dib0700.force_lna_activation=3D1': ignoring
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2210.196 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ ac000000 size 64 MB
CPU 1: aperture @ ac000000 size 64 MB
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x104f000 - 0x504f000
Memory: 4042276k/5767168k available (3210k kernel code, 150600k
reserved, 1430k data, 300k init)
Calibrating delay using timer specific routine.. 4421.73 BogoMIPS
(lpj=3D2210867)
Security Framework v1.0.0 initialized
Capability LSM initialized
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 12557933
Detected 12.557 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4419.72 BogoMIPS
(lpj=3D2209861)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 275 stepping 02
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4419.73 BogoMIPS
(lpj=3D2209865)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
Dual Core AMD Opteron(tm) Processor 275 stepping 02
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4419.72 BogoMIPS
(lpj=3D2209861)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
Dual Core AMD Opteron(tm) Processor 275 stepping 02
Brought up 4 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:09.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Root Bridge [PCI2] (0000:10)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 48 49 50 51) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LUS2] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 52 53 54 55) *0, disabled.
ACPI: PCI Interrupt Link [LSI1] (IRQs 52 53 54 55) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a
report
pnp: 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:00: iomem range 0xfefff000-0xfeffffff has been reserved
pnp: 00:02: ioport range 0x8000-0x807f has been reserved
pnp: 00:02: ioport range 0x8080-0x80ff has been reserved
pnp: 00:02: ioport range 0x8400-0x847f has been reserved
pnp: 00:02: ioport range 0x8480-0x84ff has been reserved
pnp: 00:02: ioport range 0x8800-0x887f has been reserved
pnp: 00:02: ioport range 0x8880-0x88ff has been reserved
pnp: 00:02: ioport range 0xa000-0xa03f has been reserved
pnp: 00:02: ioport range 0xa040-0xa07f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: b0100000-b01fffff
  PREFETCH window: disabled.
PCI: Failed to allocate mem resource #6:20000@d0000000 for 0000:02:00.0
PCI: Bridge: 0000:00:0e.0
  IO window: 2000-2fff
  MEM window: b1000000-b2ffffff
  PREFETCH window: c0000000-cfffffff
Time: acpi_pm clocksource has been installed.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:10:0a.0
  IO window: 3000-3fff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:0b.0
  IO window: 4000-4fff
  MEM window: d0100000-d05fffff
  PREFETCH window: a4000000-a41fffff
PCI: Bridge: 0000:80:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:80:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Simple Boot Flag at 0x36 set to 0x1
audit: initializing netlink socket (disabled)
audit(1197561911.480:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
Boot video device is 0000:02:00.0
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0a.0
subordinate bus.
AMD8131 rev 12 detected, disabling PCI-X MMRBC
PCI: MSI quirk detected. PCI_BUS_FLAGS_NO_MSI set for 0000:10:0b.0
subordinate bus.
AMD8131 rev 12 detected, disabling PCI-X MMRBC
PCI: Found disabled HT MSI Mapping on 0000:80:0e.0
PCI: Found enabled HT MSI Mapping on 0000:80:00.0
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
PCI: Setting latency timer of device 0000:80:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:80:0e.0:pcie00]
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing
disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
nbd: registered device at major 43
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 23 (level,
high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 010f1:2895 bound to 0000:00:0a.0
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 55
ACPI: PCI Interrupt 0000:80:0a.0[A] -> Link [LMAC] -> GSI 55 (level,
high) -> IRQ 55
PCI: Setting latency timer of device 0000:80:0a.0 to 64
forcedeth: using HIGHDMA
eth1: forcedeth.c: subsystem: 010f1:2895 bound to 0000:80:0a.0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Linux video capture interface: v2.00
pwc: Philips webcam module version 10.0.13 loaded.
pwc: Supports Philips PCA645/646, PCVC675/680/690,
PCVC720[40]/730/740/750 & PCVC830/840.
pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung
MPC-C10 and MPC-C30,
pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite
VCS-UC300 and VCS-UM100.
usbcore: registered new interface driver Philips webcam
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=3Dxx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 242
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev f2) UDMA133 controller
    ide0: BM-DMA at 0x1c00-0x1c07, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0x1c08-0x1c0f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: Hitachi HDT725025VLAT80, ATA DISK drive
hdb: PLEXTOR DVDR PX-760A, ATAPI CD/DVD-ROM drive
hda: selected mode 0x46
hdb: selected mode 0x44
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
hda: max request size: 512KiB
hda: 488397168 sectors (250059 MB) w/7372KiB Cache, CHS=3D30401/255/63,
UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
hdb: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
Uniform CD-ROM driver Revision: 3.20
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LTID] -> GSI 22 (level,
high) -> IRQ 22
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xffffc2000143a480 ctl 0xffffc2000143a4a0
bmdma 0x0000000000011c10 irq 22
ata2: SATA max UDMA/133 cmd 0xffffc2000143a580 ctl 0xffffc2000143a5a0
bmdma 0x0000000000011c18 irq 22
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: HDT722525DLA380, V44OA80A, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: HDT722525DLA380, V44OA80A, max UDMA/133
ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0
ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw
segs 61
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0
ANSI: 5
ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw
segs 61
sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 21 (level,
high) -> IRQ 21
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0xffffc2000143c480 ctl 0xffffc2000143c4a0
bmdma 0x0000000000011c20 irq 21
ata4: SATA max UDMA/133 cmd 0xffffc2000143c580 ctl 0xffffc2000143c5a0
bmdma 0x0000000000011c28 irq 21
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3750640AS, 3.AAK, max UDMA/133
ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0
ANSI: 5
ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw
segs 61
sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors (750156 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.05
ACPI: PCI Interrupt 0000:12:06.0[A] -> GSI 30 (level, low) -> IRQ 30
mptbase: Initiating ioc0 bringup
ioc0: LSI53C1030 B2: Capabilities=3D{Initiator,Target}
scsi4 : ioc0: LSI53C1030 B2, FwRev=3D01032700h, Ports=3D1, MaxQ=3D255, IRQ=
=3D30
ACPI: PCI Interrupt 0000:12:06.1[B] -> GSI 31 (level, low) -> IRQ 31
mptbase: Initiating ioc1 bringup
ioc1: LSI53C1030 B2: Capabilities=3D{Initiator,Target}
scsi5 : ioc1: LSI53C1030 B2, FwRev=3D01032700h, Ports=3D1, MaxQ=3D255, IRQ=
=3D31
Fusion MPT misc device (ioctl) driver 3.04.05
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=3D10,220)
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:05.0[A] -> Link [LNK4] -> GSI 19 (level,
high) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[19]
MMIO=3D[b0104000-b01047ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS2] -> GSI 20 (level,
high) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 20, io mem 0xb0001000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ACPI: PCI Interrupt 0000:12:04.2[C] -> GSI 30 (level, low) -> IRQ 30
ehci_hcd 0000:12:04.2: EHCI Host Controller
ehci_hcd 0000:12:04.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:12:04.2: irq 30, io mem 0xd0100000
ehci_hcd 0000:12:04.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 23 (level,
high) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.0: irq 23, io mem 0xb0000000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 10 ports detected
Initializing USB Mass Storage driver...
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 3-2: new low speed USB device using ohci_hcd and address 2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e0810000238d2d]
usb 3-2: configuration #1 chosen from 1 choice
usb 3-3: new full speed USB device using ohci_hcd and address 3
usb 3-3: configuration #1 chosen from 1 choice
pwc: Logitech QuickCam 4000 Pro USB webcam detected.
pwc: Registered as /dev/video0.
usb 3-4: new full speed USB device using ohci_hcd and address 4
usb 3-4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input2
input: PS2++ Logitech MX Mouse
as /devices/platform/i8042/serio1/input/input3
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0xa000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0xa040
smsc47b397: found SMSC LPC47B397-NC (base address 0x0480, revision 1)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
usbcore: registered new interface driver hiddev
input: Microsoft Natural=C2=AE Ergonomic Keyboard 4000
as /devices/pci0000:00/0000:00:02.0/usb3/3-2/3-2:1.0/input/input4
input: USB HID v1.11 Keyboard [Microsoft Natural=C2=AE Ergonomic Keyboard
4000] on usb-0000:00:02.0-2
input: Microsoft Natural=C2=AE Ergonomic Keyboard 4000
as /devices/pci0000:00/0000:00:02.0/usb3/3-2/3-2:1.1/input/input5
input: USB HID v1.11 Device [Microsoft Natural=C2=AE Ergonomic Keyboard 400=
0]
on usb-0000:00:02.0-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20
09:12:58 2007 UTC).
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LACI] -> GSI 22 (level,
high) -> IRQ 22
PCI: Setting latency timer of device 0000:00:04.0 to 64
AC'97 0 analog subsections not ready
intel8x0_measure_ac97_clock: measured 50837 usecs
intel8x0: clocking to 46776
ACPI: PCI Interrupt 0000:11:04.0[A] -> GSI 24 (level, low) -> IRQ 24
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  #0: Terratec Aureon 7.1-Universe at 0x3080, irq 24
  #1: NVidia CK804 with AD1981B at irq 22
  #2: USB Device 0x46d:0x8b2 at usb-0000:00:02.0-3, full speed
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
NET: Registered protocol family 15
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 300k freed
dib0700: loaded with support for 2 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
i2c-adapter i2c-2: SMBus Quick command not supported, can't probe for
chips
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for
chips
DVB: registering frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 =3D 1220)
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for
chips
DVB: registering frontend 1 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 =3D 1220)
dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully initialized and
connected.
usbcore: registered new interface driver dvb_usb_dib0700
Adding 8446968k swap on /dev/hda7.  Priority:-1 extents:1
across:8446968k
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth1: no link during initialization.
ADDRCONF(NETDEV_UP): eth1: link is not ready
PPP generic driver version 2.4.2
NET: Registered protocol family 24
eth2: no IPv6 routers present
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNK3] -> GSI 18 (level,
high) -> IRQ 18
PCI: Setting latency timer of device 0000:02:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed Sep 12
14:08:38 PDT 2007
usb 1-1: new high speed USB device using ehci_hcd and address 5
usb 1-1: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
scsi 6:0:0:0: CD-ROM            PLEXTOR  DVD-ROM PX-130A  1.03 PQ: 0
ANSI: 0 CCS
sr0: scsi3-mmc drive: 0x/50x cd/rw xa/form2 cdda tray
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr 6:0:0:0: Attached scsi generic sg3 type 5
usb-storage: device scan complete
end_request: I/O error, dev sr0, sector 308688
Buffer I/O error on device sr0, logical block 77172
Buffer I/O error on device sr0, logical block 77173
end_request: I/O error, dev sr0, sector 308688
Buffer I/O error on device sr0, logical block 77172
Buffer I/O error on device sr0, logical block 77173
end_request: I/O error, dev sr0, sector 308816
Buffer I/O error on device sr0, logical block 77204
Buffer I/O error on device sr0, logical block 77205
end_request: I/O error, dev sr0, sector 308816
Buffer I/O error on device sr0, logical block 77204
Buffer I/O error on device sr0, logical block 77205
UDF-fs: No VRS found
tun0: Disabled Privacy Extensions
usb 1-1: USB disconnect, address 5
ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000
status 0x400 next cpb count 0x0 next cpb idx 0x0
ata1: CPB 0: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 1: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 2: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 3: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 4: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 5: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 6: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 7: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 8: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 9: ctl_flags 0x1f, resp_flags 0x2
ata1: CPB 10: ctl_flags 0x1f, resp_flags 0x2
ata1: timeout waiting for ADMA IDLE, stat=3D0x400
ata1.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x2 frozen
ata1.00: cmd 61/10:00:2e:07:a8/01:00:0b:00:00/40 tag 0 cdb 0x0 data
139264 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/18:08:07:3f:02/00:00:00:00:00/40 tag 1 cdb 0x0 data
12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:10:b6:a8:23/00:00:0d:00:00/40 tag 2 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:18:f6:37:68/00:00:0d:00:00/40 tag 3 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:20:9e:32:a1/00:00:0d:00:00/40 tag 4 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:28:4f:00:dc/00:00:02:00:00/40 tag 5 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:30:6f:00:dc/00:00:02:00:00/40 tag 6 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:38:3f:03:2c/00:00:05:00:00/40 tag 7 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:40:36:ea:72/00:00:0d:00:00/40 tag 8 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:48:7f:00:c4/00:00:05:00:00/40 tag 9 cdb 0x0 data 4096
out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: cmd 61/08:50:47:02:d8/00:00:05:00:00/40 tag 10 cdb 0x0 data
4096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

--=-Dm3iS718mObcR+7kUU44
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQ/DCCBXQw
ggNcoAMCAQICAjh/MA0GCSqGSIb3DQEBBQUAMFQxFDASBgNVBAoTC0NBY2VydCBJbmMuMR4wHAYD
VQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAaBgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3Qw
HhcNMDcxMDI0MTkyNzQxWhcNMDkxMDIzMTkyNzQxWjB8MSEwHwYDVQQDExhDaHJpc3RvcGggQW50
b24gTWl0dGVyZXIxJDAiBgkqhkiG9w0BCQEWFWNhbGVzdHlvQHNjaWVudGlhLm5ldDExMC8GCSqG
SIb3DQEJARYibWFpbEBjaHJpc3RvcGguYW50b24ubWl0dGVyZXIubmFtZTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAPgLlUBy3NRbH25w8pOnhF+qtj4GN04aG7ur+JsXTcEkFNOZWZ5I
al2PaQWP7GfEEp5lL0w/LdYXPfnLNohp4l/Nb+db8aHUeVBYgGBTPGF+mJHfJGeochfvZo78u6Bp
KkCrDAw2BKN1JNxw+OxmWuunCmXSFM9gqRfBnfmc25P6ba9tQlDXGLKZA8/JKXLMKcTTS7dIkroE
bM5FTSaAmGWkvwnD6fpxjFgWNLXjagNqlQD6+q+a//+gXNOGP34aZ3qPnLPR/gUi/yqrQuAVvGep
GAhl4B1Kn+c7eROoodq33Ghomoznh8hogBkDJXp+Xq4k8measwtN99ZUdMaFeJsCAwEAAaOCASYw
ggEiMAwGA1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZp
Y2F0ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4QgQB
MDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9yZzBEBgNV
HREEPTA7gRVjYWxlc3R5b0BzY2llbnRpYS5uZXSBIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRl
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


--=-Dm3iS718mObcR+7kUU44--

