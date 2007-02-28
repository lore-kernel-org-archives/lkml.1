Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXB1Oit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXB1Oit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbXB1Oit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:38:49 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:44916 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbXB1Oir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:38:47 -0500
Date: Wed, 28 Feb 2007 09:38:45 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 SATA error
In-Reply-To: <45E58FC7.7020102@shaw.ca>
Message-ID: <Pine.LNX.4.64.0702280936140.28570@mtl.rackplans.net>
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no> <45E58FC7.7020102@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Robert Hancock wrote:
> Gerhard Mack wrote:
> > hello, 
> > Can someone tell me what this means?
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
> > ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288
> > out
> >          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata1: port is slow to respond, please be patient (Status 0xd0)
> > ata1: port failed to respond (30 secs, Status 0xd0)
> > ata1: soft resetting port
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > ata1.00: configured for UDMA/100
> > ata1: EH complete
> > SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
> > sda: Write Protect is off
> > sda: Mode Sense: 00 3a 00 00
> > SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
> > DPO
> > or FUA
> 
> Some command timed out, apparently. From this one can't easily say why. Please
> send full dmesg.
> 


Linux version 2.6.20 (root@mgerhard) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #10 SMP PREEMPT Mon Feb 26 14:48:53 EST 2007
Command line: root=/dev/sda3 ro 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003def0000 (usable)
 BIOS-e820: 000000003def0000 - 000000003def3000 (ACPI NVS)
 BIOS-e820: 000000003def3000 - 000000003df00000 (ACPI data)
 BIOS-e820: 000000003e000000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 253680) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP (v002 Nvidia                                ) @ 0x00000000000f7560
ACPI: XSDT (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003def30c0
ACPI: FADT (v003 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003defb3c0
ACPI: SSDT (v001 PTLTD  POWERNOW 0x00000001  LTP 0x00000001) @ 0x000000003defb5c0
ACPI: HPET (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000098) @ 0x000000003defb840
ACPI: MCFG (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003defb8c0
ACPI: MADT (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003defb500
ACPI: DSDT (v001 NVIDIA ASUSACPI 0x00001000 MSFT 0x0100000e) @ 0x0000000000000000
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 253680) 1 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   253680
On node 0 totalpages: 253583
  DMA zone: 56 pages used for memmap
  DMA zone: 1831 pages reserved
  DMA zone: 2112 pages, LIFO batch:0
  DMA32 zone: 3412 pages used for memmap
  DMA32 zone: 246172 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfefff000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000f0000
Nosave address range: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 33152 bytes of per cpu data
Built 1 zonelists.  Total pages: 248284
Kernel command line: root=/dev/sda3 ro 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ fa9c000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 991204k/1014720k available (3834k kernel code, 22888k reserved, 2637k data, 256k init)
Calibrating delay using timer specific routine.. 4413.54 BogoMIPS (lpj=2206772)
Security Framework v1.0.0 initialized
Capability LSM initialized
Failure registering Root Plug module with the kernel
Failure registering Root Plug  module with primary security module.
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12526126
Detected 12.526 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4409.15 BogoMIPS (lpj=2204576)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 0 cycles, maxerr 548 cycles)
Brought up 2 CPUs
testing NMI watchdog ... OK.
time.c: Using 25.000000 MHz WALL HPET GTOD HPET timer.
time.c: Detected 2204.598 MHz processor.
migration_cost=389
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000
PCI: No mmconfig possible on device 00:18
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:05.0
PCI: Transparent bridge - 0000:00:10.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
SCSI subsystem initialized
libata version 2.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[fdbff000-fdbff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
PCI: Bridge: 0000:00:02.0
  IO window: a000-afff
  MEM window: fd800000-fd8fffff
  PREFETCH window: fd700000-fd7fffff
PCI: Bridge: 0000:00:03.0
  IO window: 8000-8fff
  MEM window: fde00000-fdefffff
  PREFETCH window: fdd00000-fddfffff
PCI: Bridge: 0000:00:04.0
  IO window: b000-bfff
  MEM window: fdc00000-fdcfffff
  PREFETCH window: fd900000-fd9fffff
PCI: Bridge: 0000:00:10.0
  IO window: 9000-9fff
  MEM window: fdb00000-fdbfffff
  PREFETCH window: fda00000-fdafffff
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:10.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie03]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie03]
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie03]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (40 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfefff000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using monotonic_clock().
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing enabled
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: loaded (max 8 devices)
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:816a bound to 0000:00:14.0
PPP generic driver version 2.4.2
NET: Registered protocol family 24
Linux Tulip driver version 1.1.14 (May 11, 2002)
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 16
tulip0:  MII transceiver #1 config 1000 status 786d advertising 01e1.
eth1: ADMtek Comet rev 17 at MMIO 0xfdbfe000, 00:4C:69:6E:75:79, IRQ 16.
Linux video capture interface: v2.00
SCSI Media Changer driver v0.25 
sata_nv 0000:00:0e.0: version 3.2
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:0e.0 to 64
ata1: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xE000 irq 22
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xE008 irq 22
scsi0 : sata_nv
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/100, 488397168 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 1
ata1.00: configured for UDMA/100
scsi1 : sata_nv
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d8000101f761]
ata2: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x977
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JS-60N 10.0 PQ: 0 ANSI: 5
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:0f.0 to 64
ata3: SATA max UDMA/133 cmd 0x9E0 ctl 0xBE2 bmdma 0xCC00 irq 21
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xB62 bmdma 0xCC08 irq 21
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x9E7
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x967
pata_amd 0000:00:0d.0: version 0.2.7
PCI: Setting latency timer of device 0000:00:0d.0 to 64
ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF400 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF408 irq 15
scsi4 : pata_amd
ata5.00: ATAPI, max UDMA/33
ata5.00: configured for UDMA/33
scsi5 : pata_amd
ATA: abnormal status 0x7F on port 0x177
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL11 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
video1394: Installed video1394 module
ieee1394: raw1394: /dev/raw1394 device initialized
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [APCL] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: irq 20, io mem 0xfe02e000
ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 23, io mem 0xfe02f000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
Initializing USB Mass Storage driver...
usb 1-6: new high speed USB device using ehci_hcd and address 3
usb 1-6: configuration #1 chosen from 1 choice
usb 2-4: new low speed USB device using ohci_hcd and address 2
usb 2-4: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:0b.0-4
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver catc
drivers/usb/net/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver kaweth
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
drivers/usb/net/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27)
usbcore: registered new interface driver rtl8150
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver zaurus
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input3
i2c /dev entries driver
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x4c40
input: AT Translated Set 2 keyboard as /class/input/input4
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09 09:56:17 2007 UTC).
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:10.1 to 64
ALSA device list:
  #0: HDA NVidia at 0xfe024000 irq 22
netem: version 1.2
u32 classifier
    Performance counters on
    OLD policer on 
nf_conntrack version 0.5.0 (3963 buckets, 31704 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ processors (version 2.00.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
ReiserFS: sda3: found reiserfs format "3.6" with standard journal
ReiserFS: sda3: using ordered data mode
ReiserFS: sda3: journal params: device sda3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda3: checking transaction log (sda3)
ReiserFS: sda3: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 256k freed
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
sd 6:0:0:0: Attached scsi removable disk sdb
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:1: Attached scsi removable disk sdc
sd 6:0:0:1: Attached scsi generic sg3 type 0
sd 6:0:0:2: Attached scsi removable disk sdd
sd 6:0:0:2: Attached scsi generic sg4 type 0
sd 6:0:0:3: Attached scsi removable disk sde
sd 6:0:0:3: Attached scsi generic sg5 type 0
Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1 across:1004052k
ReiserFS: sda1: found reiserfs format "3.6" with standard journal
ReiserFS: sda1: using ordered data mode
ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: sda1: checking transaction log (sda1)
ReiserFS: sda1: Using r5 hash to sort names
0000:04:08.0: tulip_stop_rxtx() failed
eth1: Setting full-duplex based on MII#1 link partner capability of c1e1.
eth1: no IPv6 routers present
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9746  Fri Dec 15 10:19:35 PST 2006
**WARNING** I2C adapter driver [NVIDIA i2c adapter 0 at 0:05.0] forgot to specify physical device; fix it!
**WARNING** I2C adapter driver [NVIDIA i2c adapter 1 at 0:05.0] forgot to specify physical device; fix it!
**WARNING** I2C adapter driver [NVIDIA i2c adapter 2 at 0:05.0] forgot to specify physical device; fix it!
usb 2-3: new full speed USB device using ohci_hcd and address 3
usb 2-3: configuration #1 chosen from 1 choice
cdc_acm 2-3:1.0: ttyACM0: USB ACM device
usbcore: registered new interface driver cdc_acm
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
usb 2-3: USB disconnect, address 3
usb 2-3: new full speed USB device using ohci_hcd and address 4
usb 2-3: configuration #1 chosen from 1 choice
cdc_acm 2-3:1.0: ttyACM0: USB ACM device
usb 2-3: USB disconnect, address 4
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:88:e6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:88:e6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
ata1.00: limiting speed to UDMA/66
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:88:de:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/66
ata1: EH complete
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
ata1.00: limiting speed to UDMA/44
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:70:ec:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/44
ata1: EH complete
ata1.00: limiting speed to UDMA/33
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:70:ec:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/33
ata1: EH complete
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: limiting speed to UDMA/25
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:00:d8:16:24/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/25
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: limiting speed to UDMA/16
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd ca/00:18:00:4f:1b/00:00:00:00:00/e6 tag 0 cdb 0x0 data 12288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for UDMA/16
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: limiting speed to PIO4
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
ata1.00: cmd 35/00:b8:48:50:07/00:00:15:00:00/e0 tag 0 cdb 0x0 data 94208 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: configured for PIO4
ata1: EH complete
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA


--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
