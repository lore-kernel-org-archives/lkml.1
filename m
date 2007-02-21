Return-Path: <linux-kernel-owner+w=401wt.eu-S1422674AbXBUQqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674AbXBUQqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422676AbXBUQqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:46:44 -0500
Received: from aibn55.astro.uni-bonn.de ([131.220.96.55]:55177 "EHLO
	aibn55.astro.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422674AbXBUQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:46:41 -0500
Message-ID: <45DC7769.7030206@astro.uni-bonn.de>
Date: Wed, 21 Feb 2007 17:46:33 +0100
From: Manuel Metz <mmetz@astro.uni-bonn.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <7G2pJ-2iX-23@gated-at.bofh.it> <7G828-3zn-3@gated-at.bofh.it>	<7HpWX-3D2-5@gated-at.bofh.it> <7Hrci-5ou-5@gated-at.bofh.it>	<7HrP4-6t8-1@gated-at.bofh.it> <7Hvzs-3Tj-23@gated-at.bofh.it>	<7IYJ1-281-27@gated-at.bofh.it>	<45D2CEFC.4010900@astro.uni-bonn.de> <45DC3345.5000804@gmail.com>
In-Reply-To: <45DC3345.5000804@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040205020005070905060805"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040205020005070905060805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Does it work if you give 'irqpoll' kernel parameter?
> 

Yes this works with "irqpoll". But as you can see in the attached dmesg
output, now I get a bunch of APIC errors ... ?




--------------040205020005070905060805
Content-Type: text/plain;
 name="dmesg.sata_2.6.20.1.irqpoll"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.sata_2.6.20.1.irqpoll"

Linux version 2.6.20.1 (root@aibn44) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Wed Feb 21 17:06:15 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007fed0000 end: 000000007ffd0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007ffd0000 size: 000000000000e000 end: 000000007ffde000 type: 3
copy_e820_map() start: 000000007ffde000 size: 0000000000022000 end: 0000000080000000 type: 4
copy_e820_map() start: 00000000e0000000 size: 0000000010000000 end: 00000000f0000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
copy_e820_map() start: 00000000ff780000 size: 0000000000880000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffd0000 (usable)
 BIOS-e820: 000000007ffd0000 - 000000007ffde000 (ACPI data)
 BIOS-e820: 000000007ffde000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 524240) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524240
early_node_map[1] active PFN ranges
    0:        0 ->   524240
On node 0 totalpages: 524240
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2303 pages used for memmap
  HighMem zone: 292561 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v002 ACPIAM                                ) @ 0x000fa970
ACPI: XSDT (v001 A M I  OEMXSDT  0x02000615 MSFT 0x00000097) @ 0x7ffd0100
ACPI: FADT (v003 A M I  OEMFACP  0x02000615 MSFT 0x00000097) @ 0x7ffd0290
ACPI: MADT (v001 A M I  OEMAPIC  0x02000615 MSFT 0x00000097) @ 0x7ffd0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x02000615 MSFT 0x00000097) @ 0x7ffd03f0
ACPI: OEMB (v001 A M I  AMI_OEM  0x02000615 MSFT 0x00000097) @ 0x7ffde040
ACPI: DSDT (v001  A0304 A0304001 0x00000001 INTL 0x02002026) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:11 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:11 APIC version 16
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
Detected 2000.124 MHz processor.
Built 1 zonelists.  Total pages: 520145
Kernel command line: root=/dev/sda1 ro irqpoll
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074160k/2096960k available (2948k kernel code, 21576k reserved, 843k data, 224k init, 1179456k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc04ba000 - 0xc04f2000   ( 224 kB)
      .data : 0xc03e11d5 - 0xc04b3f8c   ( 843 kB)
      .text : 0xc0100000 - 0xc03e11d5   (2948 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4007.23 BogoMIPS (lpj=8014471)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 15k freed
ACPI: Core revision 20060707
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 01
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4000.38 BogoMIPS (lpj=8000765)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000 00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410 00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 01
Total of 2 processors activated (8007.61 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization across 2 CPUs: 
CPU#0 had 283 usecs TSC skew, fixed it up.
CPU#1 had -283 usecs TSC skew, fixed it up.
Brought up 2 CPUs
migration_cost=243
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on 0:0
PCI: No mmconfig possible on 0:1
PCI: No mmconfig possible on 0:f
PCI: No mmconfig possible on 0:10
PCI: No mmconfig possible on 0:11
PCI: No mmconfig possible on 0:13
PCI: No mmconfig possible on 0:18
PCI: No mmconfig possible on 1:0
PCI: No mmconfig possible on 5:c
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.P7P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7.P7P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
libata version 2.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: fd800000-fe8fffff
  PREFETCH window: f9700000-fd6fffff
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.1
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.0
  IO window: disabled.
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
  IO window: c000-cfff
  MEM window: fea00000-feafffff
  PREFETCH window: 88000000-880fffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
PCI: Setting latency timer of device 0000:02:00.1 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with ACLs, no debug enabled
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
ACPI: Processor [CPU1] (supports 16 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 64M @ 0xdc000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:05:0c.0[A] -> GSI 17 (level, low) -> IRQ 16
eth0: RTL8169s/8110s at 0xf8804c00, 00:11:6b:32:45:74, IRQ 16
pata_via 0000:00:0f.1: version 0.2.1
ata1: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xFC00 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xFC08 irq 15
scsi0 : pata_via
ata1.00: ATA-7, max UDMA/133, 240121728 sectors: LBA 
ata1.00: ata1: dev 0 multi count 16
ata1.01: ATA-7, max UDMA/133, 240121728 sectors: LBA 
ata1.01: ata1: dev 1 multi count 16
ata1.00: configured for UDMA/133
ata1.01: configured for UDMA/133
scsi1 : pata_via
ata2.00: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y120L0   YAR4 PQ: 0 ANSI: 5
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Direct-Access     ATA      Maxtor 6Y120P0   YAR4 PQ: 0 ANSI: 5
SCSI device sdb: 240121728 512-byte hdwr sectors (122942 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 240121728 512-byte hdwr sectors (122942 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 0:0:1:0: Attached scsi disk sdb
sd 0:0:1:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-R1202 1026 PQ: 0 ANSI: 5
scsi 1:0:0:0: Attached scsi generic sg2 type 5
usbmon: debugfs is not available
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 22 (level, low) -> IRQ 17
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: irq 17, io mem 0xfebff800
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 20 (level, low) -> IRQ 18
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 18, io base 0x0000e080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[C] -> GSI 22 (level, low) -> IRQ 17
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 17, io base 0x0000e000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 19
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 19, io base 0x0000dc00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[D] -> GSI 23 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 20, io base 0x0000d880
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
hub 4-2:1.0: USB hub found
hub 4-2:1.0: 4 ports detected
usb 4-2.1: new low speed USB device using uhci_hcd and address 3
usb 4-2.1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:10.2-2.1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
input: PC Speaker as /class/input/input5
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09 09:56:17 2007 UTC).
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (version 2.00.00)
powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
Starting balanced_irq
Using IPI Shortcut mode
Time: acpi_pm clocksource has been installed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 224k freed
ahci 0000:00:0f.0: version 2.0
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 19
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl IDE mode
ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part 
ata3: SATA max UDMA/133 cmd 0xF8834D00 ctl 0x0 bmdma 0x0 irq 223
ata4: SATA max UDMA/133 cmd 0xF8834D80 ctl 0x0 bmdma 0x0 irq 223
ata5: SATA max UDMA/133 cmd 0xF8834E00 ctl 0x0 bmdma 0x0 irq 223
ata6: SATA max UDMA/133 cmd 0xF8834E80 ctl 0x0 bmdma 0x0 irq 223
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
APIC error on CPU0: 00(08)
APIC error on CPU1: 00(08)
ata3.00: ATA-6, max UDMA/100, 625142448 sectors: LBA48 
ata3.00: ata3: dev 0 multi count 16
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
ata3.00: configured for UDMA/100
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 300)
scsi5 : ahci
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200SD-01K 08.0 PQ: 0 ANSI: 5
SCSI device sdc: 625142448 512-byte hdwr sectors (320073 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 625142448 512-byte hdwr sectors (320073 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc:<7>APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
 sdc1
sd 2:0:0:0: Attached scsi disk sdc
sd 2:0:0:0: Attached scsi generic sg3 type 0
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:01.0 to 64
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
Adding 979848k swap on /dev/sda4.  Priority:-1 extents:1 across:979848k
EXT3 FS on sda1, internal journal
it87: Found IT8712F chip at 0xd00, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
kjournald starting.  Commit interval 5 seconds
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 15
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
r8169: eth0: link up
ttyS1: LSR safety check engaged!
ttyS1: LSR safety check engaged!
process `syslogd' is using obsolete setsockopt SO_BSDCOMPAT
ttyS1: LSR safety check engaged!
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU1: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU0: 08(08)
APIC error on CPU1: 08(08)
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present

--------------040205020005070905060805--
