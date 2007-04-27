Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbXD0VDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbXD0VDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbXD0VDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:03:42 -0400
Received: from 85-218-34-145.dclient.lsne.ch ([85.218.34.145]:37473 "EHLO vdr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757292AbXD0VDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:03:37 -0400
Date: Fri, 27 Apr 2007 23:03:30 +0200
From: Gregoire Favre <Gregoire.Favre@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: More than 2Gb problem (dvb related) ?
Message-ID: <20070427210330.GB6722@gmail.com>
References: <20070427111047.GB10284@gmail.com> <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
X-Operating-System: Linux 2.6.21
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 10:46:33PM +0200, Markus Rechberger wrote:
>  just for the completeness, what does dmesg show up?
>  You forgot to mention what device you have too...

Here all in one :

Linux version 2.6.21-rc7 (greg@vdr) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 SMP PREEMPT Mon Apr 23 14:18:37 CEST 2007
Command line: root=/dev/md3 vga=0x507
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
end_pfn_map = 1572864
DMI 2.4 present.
ACPI: RSDP 000FB020, 0024 (r2 ACPIAM)
ACPI: XSDT 7FF90100, 0054 (r1 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ  3000712 MSFT       97)
ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   3000712 MSFT       97)
ACPI: DSDT 7FF905C0, 967B (r1  A0693 A0693000        0 INTL 20060113)
ACPI: FACS 7FF9E000, 0040
ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   3000712 MSFT       97)
ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   3000712 MSFT       97)
ACPI: SLIC 7FF90440, 0176 (r1 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ  3000712 MSFT       97)
ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   3000712 MSFT       97)
ACPI: HPET 7FF99C40, 0038 (r1 MSTEST OEMHPET   3000712 MSFT       97)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 524176) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1572864
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524176
    0:  1048576 ->  1572864
On node 0 totalpages: 1048366
  DMA zone: 56 pages used for memmap
  DMA zone: 1187 pages reserved
  DMA zone: 2755 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505800 pages, LIFO batch:31
  Normal zone: 7168 pages used for memmap
  Normal zone: 517120 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009e000 - 000000000009f000
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Nosave address range: 000000007ff90000 - 000000007ff9e000
Nosave address range: 000000007ff9e000 - 000000007ffe0000
Nosave address range: 000000007ffe0000 - 0000000080000000
Nosave address range: 0000000080000000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fee01000
Nosave address range: 00000000fee01000 - 00000000ffb00000
Nosave address range: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 32768 bytes of per cpu data
Built 1 zonelists.  Total pages: 1025675
Kernel command line: root=/dev/md3 vga=0x507
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 2399.999 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x6a42000 - 0xaa42000
Memory: 4030156k/6291456k available (3128k kernel code, 163124k reserved, 1048k data, 204k init)
Calibrating delay using timer specific routine.. 4804.75 BogoMIPS (lpj=8004414)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16666662
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4801.03 BogoMIPS (lpj=8000049)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=19
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
pnp: 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
pnp: 00:06: ioport range 0x290-0x297 has been reserved
pnp: 00:07: iomem range 0xffafe000-0xffb0cbff could not be reserved
pnp: 00:07: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:07: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0c: iomem range 0x100000-0x7fffffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: cfc00000-d3cfffff
  PREFETCH window: 8fa00000-cf9fffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: cfa00000-cfafffff
PCI: Bridge: 0000:00:1c.5
  IO window: b000-bfff
  MEM window: d3d00000-d3dfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: d3e00000-dfefffff
  PREFETCH window: 88000000-880fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
SGI XFS with large block/inode numbers, no debug enabled
io scheduler noop registered
io scheduler cfq registered (default)
vesafb: framebuffer at 0xa0000000, mapped to 0xffffc20000080000, using 2560k, total 524288k
vesafb: mode is 1280x1024x8, linelength=1280, pages=1
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
ACPI: SSDT 7FF9E0C0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
ACPI: SSDT 7FF9E290, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 19 (level, low) -> IRQ 19
skge 1.10 addr 0xdfef4000 irq 19 chip Yukon-Lite rev 9
skge eth0: addr 00:1a:92:4b:02:5a
ahci 0000:00:1f.2: version 2.1
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
ata1: SATA max UDMA/133 cmd 0xffffc20000036900 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata2: SATA max UDMA/133 cmd 0xffffc20000036980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata3: SATA max UDMA/133 cmd 0xffffc20000036a00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata4: SATA max UDMA/133 cmd 0xffffc20000036a80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata5: SATA max UDMA/133 cmd 0xffffc20000036b00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata6: SATA max UDMA/133 cmd 0xffffc20000036b80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
ata1.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: SAMSUNG HD401LJ, ZZ100-15, max UDMA7
ata2.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI, max UDMA/100
ata3.00: configured for UDMA/100
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD401LJ  ZZ10 PQ: 0 ANSI: 5
SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: CD-ROM            LITE-ON  DVDRW SH-16A7S   WS04 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 125x/125x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg2 type 5
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xdffff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdffff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-3: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 2-3: configuration #1 chosen from 1 choice
hub 2-3:1.0: USB hub found
hub 2-3:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 2-3.1: new high speed USB device using ehci_hcd and address 4
usb 2-3.1: configuration #1 chosen from 1 choice
hub 2-3.1:1.0: USB hub found
hub 2-3.1:1.0: 4 ports detected
usb 2-3.2: new high speed USB device using ehci_hcd and address 5
usb 2-3.2: configuration #1 chosen from 1 choice
usb 7-1: new full speed USB device using uhci_hcd and address 2
usb 7-1: configuration #1 chosen from 1 choice
hub 7-1:1.0: USB hub found
hub 7-1:1.0: 4 ports detected
usb 7-1.1: new low speed USB device using uhci_hcd and address 3
usb 7-1.1: configuration #1 chosen from 1 choice
usb 7-1.4: new full speed USB device using uhci_hcd and address 4
usb 7-1.4: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Logitech Logitech Gaming Keyboard as /class/input/input0
input: USB HID v1.10 Keyboard [Logitech Logitech Gaming Keyboard] on usb-0000:00:1d.2-1.1
input: Logitech Logitech Gaming Keyboard as /class/input/input1
input,hiddev96: USB HID v1.10 Device [Logitech Logitech Gaming Keyboard] on usb-0000:00:1d.2-1.1
input: G15 Keyboard G15 Keyboard as /class/input/input2
input,hiddev97: USB HID v1.11 Keypad [G15 Keyboard G15 Keyboard] on usb-0000:00:1d.2-1.4
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0f03:PS2M] at 0x60,0x64 irq 12
PNP: PS/2 controller doesn't have KBD irq; using default 1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
ALSA device list:
  No soundcards found.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
logips2pp: Detected unknown logitech mouse model 105
input: ImExPS/2 Logitech Explorer Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb6 ...
md:  adding sdb6 ...
md: sdb5 has different UUID to sdb6
md: sdb2 has different UUID to sdb6
md:  adding sda6 ...
md: sda5 has different UUID to sdb6
md: sda2 has different UUID to sdb6
md: created md4
md: bind<sda6>
md: bind<sdb6>
md: running: <sdb6><sda6>
md4: setting max_sectors to 128, segment boundary to 32767
raid0: looking at sdb6
raid0:   comparing sdb6(360329792) with sdb6(360329792)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sda6
raid0:   comparing sda6(360329792) with sdb6(360329792)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 720659584 blocks.
raid0 : conf->hash_spacing is 720659584 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
md: considering sdb5 ...
md:  adding sdb5 ...
md: sdb2 has different UUID to sdb5
md:  adding sda5 ...
md: sda2 has different UUID to sdb5
md: created md3
md: bind<sda5>
md: bind<sdb5>
md: running: <sdb5><sda5>
raid1: raid set md3 active with 2 out of 2 mirrors
md: considering sdb2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 204k freed
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
saa7146: register extension 'budget_ci dvb'.
Linux video capture interface: v2.00
cx2388x alsa driver version 0.0.6 loaded
cx2388x cx88-mpeg Driver Manager version 0.0.6 loaded
cx2388x v4l2 driver version 0.0.6 loaded
nvidia: module license 'NVIDIA' taints kernel.
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.13 addr 0xd3dfc000 irq 17 Yukon-EC Ultra (0xb4) rev 2
sky2 eth1: addr 00:1a:92:4b:0d:62
ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[dfeff000-dfeff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem ffffc20000060c00 (revision 1, irq 22) (0x13c2,0x100f).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-CI PCI).
adapter has MAC addr = 00:d0:5c:23:a3:9b
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input4
DVB: registering frontend 0 (ST STV0299 DVB-S)...
ACPI: PCI Interrupt 0000:04:02.1[A] -> GSI 23 (level, low) -> IRQ 23
cx88[0]: Your board isn't known (yet) to the driver.  You can
cx88[0]: try to pick one of the existing card configs via
cx88[0]: card=<n> insmod option.  Updating to the latest
cx88[0]: version might help as well.
cx88[0]: Here is a list of valid choices for the card=<n> insmod option:
cx88[0]:    card=0 -> UNKNOWN/GENERIC
cx88[0]:    card=1 -> Hauppauge WinTV 34xxx models
cx88[0]:    card=2 -> GDI Black Gold
cx88[0]:    card=3 -> PixelView
cx88[0]:    card=4 -> ATI TV Wonder Pro
cx88[0]:    card=5 -> Leadtek Winfast 2000XP Expert
cx88[0]:    card=6 -> AverTV Studio 303 (M126)
cx88[0]:    card=7 -> MSI TV-@nywhere Master
cx88[0]:    card=8 -> Leadtek Winfast DV2000
cx88[0]:    card=9 -> Leadtek PVR 2000
cx88[0]:    card=10 -> IODATA GV-VCP3/PCI
cx88[0]:    card=11 -> Prolink PlayTV PVR
cx88[0]:    card=12 -> ASUS PVR-416
cx88[0]:    card=13 -> MSI TV-@nywhere
cx88[0]:    card=14 -> KWorld/VStream XPert DVB-T
cx88[0]:    card=15 -> DViCO FusionHDTV DVB-T1
cx88[0]:    card=16 -> KWorld LTV883RF
cx88[0]:    card=17 -> DViCO FusionHDTV 3 Gold-Q
cx88[0]:    card=18 -> Hauppauge Nova-T DVB-T
cx88[0]:    card=19 -> Conexant DVB-T reference design
cx88[0]:    card=20 -> Provideo PV259
cx88[0]:    card=21 -> DViCO FusionHDTV DVB-T Plus
cx88[0]:    card=22 -> pcHDTV HD3000 HDTV
cx88[0]:    card=23 -> digitalnow DNTV Live! DVB-T
cx88[0]:    card=24 -> Hauppauge WinTV 28xxx (Roslyn) models
cx88[0]:    card=25 -> Digital-Logic MICROSPACE Entertainment Center (MEC)
cx88[0]:    card=26 -> IODATA GV/BCTV7E
cx88[0]:    card=27 -> PixelView PlayTV Ultra Pro (Stereo)
cx88[0]:    card=28 -> DViCO FusionHDTV 3 Gold-T
cx88[0]:    card=29 -> ADS Tech Instant TV DVB-T PCI
cx88[0]:    card=30 -> TerraTec Cinergy 1400 DVB-T
cx88[0]:    card=31 -> DViCO FusionHDTV 5 Gold
cx88[0]:    card=32 -> AverMedia UltraTV Media Center PCI 550
cx88[0]:    card=33 -> Kworld V-Stream Xpert DVD
cx88[0]:    card=34 -> ATI HDTV Wonder
cx88[0]:    card=35 -> WinFast DTV1000-T
cx88[0]:    card=36 -> AVerTV 303 (M126)
cx88[0]:    card=37 -> Hauppauge Nova-S-Plus DVB-S
cx88[0]:    card=38 -> Hauppauge Nova-SE2 DVB-S
cx88[0]:    card=39 -> KWorld DVB-S 100
cx88[0]:    card=40 -> Hauppauge WinTV-HVR1100 DVB-T/Hybrid
cx88[0]:    card=41 -> Hauppauge WinTV-HVR1100 DVB-T/Hybrid (Low Profile)
cx88[0]:    card=42 -> digitalnow DNTV Live! DVB-T Pro
cx88[0]:    card=43 -> KWorld/VStream XPert DVB-T with cx22702
cx88[0]:    card=44 -> DViCO FusionHDTV DVB-T Dual Digital
cx88[0]:    card=45 -> KWorld HardwareMpegTV XPert
cx88[0]:    card=46 -> DViCO FusionHDTV DVB-T Hybrid
cx88[0]:    card=47 -> pcHDTV HD5500 HDTV
cx88[0]:    card=48 -> Kworld MCE 200 Deluxe
cx88[0]:    card=49 -> PixelView PlayTV P7000
cx88[0]:    card=50 -> NPG Tech Real TV FM Top 10
cx88[0]:    card=51 -> WinFast DTV2000 H
cx88[0]:    card=52 -> Geniatech DVB-S
cx88[0]:    card=53 -> Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T
cx88[0]:    card=54 -> Norwood Micro TV Tuner
cx88[0]:    card=55 -> Shenzhen Tungsten Ages Tech TE-DTV-250 / Swann OEM
cx88[0]:    card=56 -> Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder
CORE cx88[0]: subsystem: 0070:6902, board: UNKNOWN/GENERIC [card=0,autodetected]
TV tuner -1 at 0x1fe, Radio tuner -1 at 0x1fe
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88[0]/2: cx2388x 8802 Driver Manager
CORE cx88[1]: subsystem: 14f1:0084, board: Geniatech DVB-S [card=52,autodetected]
TV tuner 4 at 0x1fe, Radio tuner -1 at 0x1fe
cx88[1]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:04:05.2[A] -> GSI 20 (level, low) -> IRQ 20
cx88[1]/2: found at 0000:04:05.2, rev: 3, irq: 20, latency: 64, mmio: 0xda000000
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
cx88[0]/0: found at 0000:04:02.0, rev: 5, irq: 23, latency: 64, mmio: 0xdb000000
cx2388x dvb driver version 0.0.6 loaded
cx8802_register_driver() ->registering driver type=dvb access=shared
CORE cx88[1]: subsystem: 14f1:0084, board: Geniatech DVB-S [card=52]
cx88[1]/2: cx2388x based dvb card
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[1]/0: found at 0000:04:05.0, rev: 3, irq: 20, latency: 64, mmio: 0xd9000000
cx88[1]/0: registered device video1 [v4l2]
cx88[1]/0: registered device vbi1
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  1.0-9755  Mon Feb 26 23:16:31 PST 2007
DVB: registering new adapter (cx88[1]).
DVB: registering frontend 1 (Conexant CX24123/CX24109)...
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80001205f74]
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     SMSC     223 U HS-CF      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:1: Direct-Access     SMSC     223 U HS-MS      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:2: Direct-Access     SMSC     223 U HS-SM      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:3: Direct-Access     SMSC     223 U HS-SD/MMC  3.60 PQ: 0 ANSI: 0
sd 6:0:0:0: Attached scsi removable disk sdc
sd 6:0:0:0: Attached scsi generic sg3 type 0
sd 6:0:0:1: Attached scsi removable disk sdd
sd 6:0:0:1: Attached scsi generic sg4 type 0
sd 6:0:0:2: Attached scsi removable disk sde
sd 6:0:0:2: Attached scsi generic sg5 type 0
sd 6:0:0:3: Attached scsi removable disk sdf
sd 6:0:0:3: Attached scsi generic sg6 type 0
EXT3 FS on md3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Filesystem "dm-7": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-7
Ending clean XFS mount for filesystem: dm-7
Filesystem "dm-11": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-11
Ending clean XFS mount for filesystem: dm-11
Adding 1004052k swap on /dev/sda3.  Priority:1 extents:1 across:1004052k
Adding 1004052k swap on /dev/sdb3.  Priority:1 extents:1 across:1004052k
sky2 eth1: enabling interface
sky2 eth1: ram buffer 0K
skge eth0: enabling interface
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
cdrom: This disc doesn't have any tracks I recognize!

Thank,
-- 
Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre
