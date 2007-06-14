Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXFNM6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXFNM6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXFNM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:57:58 -0400
Received: from smtp-0-1.linuxrulz.org ([64.191.81.102]:32993 "EHLO
	smtp-0-1.linuxrulz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbXFNM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:57:55 -0400
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 08:57:54 EDT
Message-ID: <4671366B.7090702@lbsd.net>
Date: Thu, 14 Jun 2007 12:36:59 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SATA problems
X-Enigmail-Version: 0.95.0
OpenPGP: id=27702C4E;
	url=pgpkeys.mit.edu
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB42774CFF3C97E61E395F3BF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB42774CFF3C97E61E395F3BF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I'm stumped trying to track down the below intermittent problem.....

I've confirmed this problem on 2.6.19, 2.6.20 and 2.6.21.

Any help greatly appreciated!

Regards
Nigel


Jun 14 07:55:52 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Jun 14 07:55:52 nigel-m2v kernel: ata2.00: cmd
ca/00:18:87:e7:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 12288 out
Jun 14 07:55:52 nigel-m2v kernel:          res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 14 07:55:52 nigel-m2v kernel: ata2: soft resetting port
Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 14 07:56:22 nigel-m2v kernel: ata2.00: qc timeout (cmd 0xef)
Jun 14 07:56:22 nigel-m2v kernel: ata2.00: failed to set xfermode
(err_mask=3D0x4)
Jun 14 07:56:22 nigel-m2v kernel: ata2: failed to recover some devices,
retrying in 5 secs
Jun 14 07:56:27 nigel-m2v kernel: ata2: soft resetting port
Jun 14 07:56:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 14 07:56:27 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 14 07:56:57 nigel-m2v kernel: ata2.00: qc timeout (cmd 0xef)
Jun 14 07:56:57 nigel-m2v kernel: ata2.00: failed to set xfermode
(err_mask=3D0x4)
Jun 14 07:56:57 nigel-m2v kernel: ata2.00: limiting speed to UDMA/133:PIO=
3
Jun 14 07:56:57 nigel-m2v kernel: ata2: failed to recover some devices,
retrying in 5 secs
Jun 14 07:57:02 nigel-m2v kernel: ata2: soft resetting port
Jun 14 07:57:02 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 14 07:57:02 nigel-m2v kernel: rtc: lost 2 interrupts
Jun 14 07:57:02 nigel-m2v kernel: ATA: abnormal status 0x7F on port
0x0001c807
Jun 14 07:57:32 nigel-m2v kernel: ata2.00: qc timeout (cmd 0xef)
Jun 14 07:57:32 nigel-m2v kernel: ata2.00: failed to set xfermode
(err_mask=3D0x4)
Jun 14 07:57:32 nigel-m2v kernel: ata2.00: disabled
Jun 14 07:57:33 nigel-m2v kernel: ata2: EH complete
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 59271
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 192221519
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 24027682
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 140129751
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 17516211
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 93828927
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 11728608
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 191848111
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 23981006
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 23981007
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 138379031
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 17297371
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 138855071
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 17356876
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 59295
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 7404
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: Aborting journal on device sda1.
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 191848111
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 23981006
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: sd 3:0:0:0: SCSI error: return code =3D=

0x00040000
Jun 14 07:57:33 nigel-m2v kernel: end_request: I/O error, dev sda,
sector 93005999
Jun 14 07:57:33 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 11625742
Jun 14 07:57:33 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:57:33 nigel-m2v kernel: ext3_abort called.
Jun 14 07:57:33 nigel-m2v kernel: EXT3-fs error (device sda1):
ext3_journal_start_sb: Detected aborted journal
Jun 14 07:57:33 nigel-m2v kernel: Remounting filesystem read-only
Jun 14 07:57:33 nigel-m2v kernel: sda : READ CAPACITY failed.
Jun 14 07:57:33 nigel-m2v kernel: sda : status=3D0, message=3D00, host=3D=
4,
driver=3D00
Jun 14 07:57:33 nigel-m2v kernel: sda : sense not available.
Jun 14 07:57:33 nigel-m2v kernel: sda: Write Protect is off
Jun 14 07:57:33 nigel-m2v kernel: sda: asking for cache data failed
Jun 14 07:57:33 nigel-m2v kernel: sda: assuming drive cache: write throug=
h
Jun 14 07:58:06 nigel-m2v kernel: printk: 1 messages suppressed.
Jun 14 07:58:06 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 11468802
Jun 14 07:58:06 nigel-m2v kernel: lost page write due to I/O error on sda=
1
Jun 14 07:58:06 nigel-m2v kernel: Buffer I/O error on device sda1,
logical block 11468803
Jun 14 07:58:06 nigel-m2v kernel: lost page write due to I/O error on sda=
1





dmesg after boot...
Linux version 2.6.21.5-0.1 (nkukard@devel-0-2) (gcc version 4.1.2) #1
SMP Wed Jun 13 06:46:04 GMT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009dc00 end:
000000000009dc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009dc00 size: 0000000000002400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000e4000 size: 000000000001c000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 00000000cfeb0000 end:
00000000cffb0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000cffb0000 size: 000000000000e000 end:
00000000cffbe000 type: 3
copy_e820_map() start: 00000000cffbe000 size: 0000000000022000 end:
00000000cffe0000 type: 4
copy_e820_map() start: 00000000cffe0000 size: 0000000000020000 end:
00000000d0000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end:
00000000fec01000 type: 2
copy_e820_map() start: 00000000fecc0000 size: 0000000000001000 end:
00000000fecc1000 type: 2
copy_e820_map() start: 00000000ff780000 size: 0000000000880000 end:
0000000100000000 type: 2
copy_e820_map() start: 0000000100000000 size: 0000000030000000 end:
0000000130000000 type: 1
copy_e820_map() type is E820_RAM
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
 BIOS-e820: 00000000cffb0000 - 00000000cffbe000 (ACPI data)
 BIOS-e820: 00000000cffbe000 - 00000000cffe0000 (ACPI NVS)
 BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Warning only 4GB will be used.
Use a PAE enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1048576
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 6400 pages used for memmap
  HighMem zone: 812800 pages, LIFO batch:31
DMI present.
ACPI: RSDP 000FA960, 0014 (r0 ACPIAM)
ACPI: RSDT CFFB0000, 003C (r1 NEC              4000730 MSFT       97)
ACPI: FACP CFFB0200, 0084 (r2 A_M_I_ OEMFACP   4000730 MSFT       97)
ACPI Warning (tbfadt-0360): Ignoring BIOS FADT r2 C-state control [200701=
26]
ACPI: DSDT CFFB05C0, 4E3F (r1  A0498 A0498000        0 INTL 20060113)
ACPI: FACS CFFBE000, 0040
ACPI: APIC CFFB0390, 0068 (r1 A_M_I_ OEMAPIC   4000730 MSFT       97)
ACPI: MCFG CFFB0400, 003C (r1 A_M_I_ OEMMCFG   4000730 MSFT       97)
ACPI: SLIC CFFB0440, 0176 (r1 NEC              4000730 MSFT       97)
ACPI: OEMB CFFBE040, 0060 (r1 A_M_I_ AMI_OEM   4000730 MSFT       97)
ACPI: HPET CFFB5400, 0038 (r1 A_M_I_ OEMHPET   4000730 MSFT       97)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 16
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
ACPI: HPET id: 0x11068201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
Built 1 zonelists.  Total pages: 1040384
Kernel command line:
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fecc0000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2799.995 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3363908k/4194304k available (3611k kernel code, 42588k reserved,
1387k data, 3460k init, 2490048k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc05e9000 - 0xc094a000   (3460 kB)
      .data : 0xc0486fd7 - 0xc05e1d84   (1387 kB)
      .text : 0xc0100000 - 0xc0486fd7   (3611 kB)
Checking if this processor honours the WP bit even in supervisor mode... =
Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 32-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 5601.64 BogoMIPS
(lpj=3D28008240)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000
00002001 00000000 0000001f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001
00000000 0000001f
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5400+ stepping 03
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5599.39 BogoMIPS
(lpj=3D27996994)
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000
00002001 00000000 0000001f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001
00000000 0000001f
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5400+ stepping 03
Total of 2 processors activated (11201.04 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
Brought up 2 CPUs
migration_cost=3D0
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3D128
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
Error attaching device data
Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:02:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 17 devices
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
libata version 2.20 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a=

report
pnp: 00:06: ioport range 0xc00-0xc0f has been reserved
pnp: 00:06: ioport range 0xd00-0xd0f has been reserved
pnp: 00:06: ioport range 0xa20-0xa2f has been reserved
pnp: 00:06: ioport range 0xa30-0xa3f has been reserved
pnp: 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:10: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:10: iomem range 0xc0000-0xcffff could not be reserved
pnp: 00:10: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:10: iomem range 0x100000-0xcfffffff could not be reserved
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: f9000000-fbbfffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:03.0
  IO window: d000-dfff
  MEM window: fbd00000-fbdfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.1
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: f7f00000-f7ffffff
PCI: Bridge: 0000:00:03.2
  IO window: disabled.
  MEM window: fbc00000-fbcfffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: f7e00000-f7efffff
PCI: Bridge: 0000:00:13.0
  IO window: disabled.
  MEM window: fbf00000-fbffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
  IO window: e000-efff
  MEM window: fbe00000-fbefffff
  PREFETCH window: f0000000-f00fffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:03.0 to 64
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 35 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:03.1 to 64
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 39 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:03.2 to 64
ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 43 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:03.3 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1181799967.780:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered (default)
PCI: MSI quirk detected. MSI deactivated.
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.1:pcie00]
Allocate Port Service[0000:00:03.1:pcie02]
PCI: Setting latency timer of device 0000:00:03.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.2:pcie00]
Allocate Port Service[0000:00:03.2:pcie02]
PCI: Setting latency timer of device 0000:00:03.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.3:pcie00]
Allocate Port Service[0000:00:03.3:pcie02]
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=3D=
xx
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
VP_IDE: chipset revision 7
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237a (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: ST340014A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-ST DVDRAM GSA-4160B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=3D16383/255/63,
UDMA(100)
hda: cache flushes supported
 hda: hda1
hdc: ATAPI 40X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-724.
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver (1.1-5[2423]-mh3)
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
NCR53c406a: no available ports found
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using
iobase=3D and irq=3D options<5>iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.1.11
Copyright(c) 2004-2006 Emulex.  All rights reserved.
seagate: ST0x/TMC-8xx not detected.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
        with "disable_clustering=3D1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.03.10-rc1 Wed Feb 14 10:14:25 PST 2007
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.3.1 (January 23, 2007)
stex: Promise SuperTrak EX Driver version: 3.1.0.1
sata_via 0000:00:0f.0: version 2.1
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21
sata_via 0000:00:0f.0: routed to hard irq line 10
ata1: SATA max UDMA/133 cmd 0x0001cc00 ctl 0x0001c882 bmdma 0x0001c400
irq 21
ata2: SATA max UDMA/133 cmd 0x0001c800 ctl 0x0001c482 bmdma 0x0001c408
irq 21
scsi2 : sata_via
ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x0001cc07
scsi3 : sata_via
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ATA: abnormal status 0x7F on port 0x0001c807
ATA: abnormal status 0x7F on port 0x0001c807
ata2.00: ATA-7: ST3250620AS, 3.AAK, max UDMA/133
ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI=
: 5
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1
sd 3:0:0:0: Attached scsi disk sda
sd 3:0:0:0: Attached scsi generic sg0 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1   1187 MB/s
raid6: int32x2   1091 MB/s
raid6: int32x4    832 MB/s
raid6: int32x8    756 MB/s
raid6: mmxx1     2277 MB/s
raid6: mmxx2     4202 MB/s
raid6: sse1x1    2243 MB/s
raid6: sse1x2    3760 MB/s
raid6: sse2x1    3772 MB/s
raid6: sse2x2    5277 MB/s
raid6: using algorithm sse2x2 (5277 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  8532.400 MB/sec
raid5: using function: pIII_sse (8532.400 MB/sec)
md: multipath personality registered for level -4
md: faulty personality registered for level -5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
device-mapper: multipath emc: version 0.0.3 loaded
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
Freeing unused kernel memory: 3460k freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
hdc: drive_cmd: status=3D0x51 { DriveReady SeekComplete Error }
hdc: drive_cmd: error=3D0x04 { AbortedCommand }
ide: failed opcode was: 0xef
EXT3 FS on hda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 524280k swap on /.swap.  Priority:-1 extents:133 across:541296k
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 21, io mem 0xf8fffc00
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 20 (level, low) -> IRQ 22
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 22, io base 0x0000b480
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[B] -> GSI 22 (level, low) -> IRQ 23
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 23, io base 0x0000b800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[C] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000b880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[D] -> GSI 23 (level, low) -> IRQ 24
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 24, io base 0x0000bc00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-3: new high speed USB device using ehci_hcd and address 4
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usb 2-2: new low speed USB device using uhci_hcd and address 3
usb 2-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: Eleen USB Keyboard as /class/input/input0
input: USB HID v1.10 Keyboard [Eleen USB Keyboard] on usb-0000:00:10.0-1
input: Eleen USB Keyboard as /class/input/input1
input: USB HID v1.10 Mouse [Eleen USB Keyboard] on usb-0000:00:10.0-1
input: KYE NetScroll+ EYE as /class/input/input2
input: USB HID v1.10 Mouse [KYE NetScroll+ EYE] on usb-0000:00:10.0-2
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver usbkbd
drivers/usb/input/usbkbd.c: :USB HID Boot Protocol keyboard driver
usbcore: registered new interface driver usbmouse
drivers/usb/input/usbmouse.c: v1.6:USB HID Boot Protocol mouse driver
usbcore: registered new interface driver libusual
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ACPI: PCI Interrupt 0000:80:01.0[A] -> GSI 17 (level, low) -> IRQ 25
PCI: Setting latency timer of device 0000:80:01.0 to 64
hda_codec: Unknown model for ALC660VD/ALC861VD, trying auto-probe from
BIOS...






lspci -vvv...
00:00.0 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
        Subsystem: VIA Technologies, Inc. VT3351 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [60] HyperTransport: Slave or Primary Interface
                !!! Possibly incomplete decoding
                Command: BaseUnitID=3D0 UnitCnt=3D3 MastHost- DefDir-
                Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
<CRCErr=3D0
                Link Config 0: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D=
16bit
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+
<CRCErr=3D0
                Link Config 1: MLWI=3D8bit MLWO=3D8bit LWI=3D8bit LWO=3D8=
bit
                Revision ID: 1.02
        Capabilities: [58] #00 [0000]

00:00.1 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:00.2 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:00.3 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:00.4 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:00.5 PIC: VIA Technologies, Inc. VT3351 I/O APIC Interrupt Controller
(prog-if 20 [IO(X)-APIC])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:00.6 Host bridge: VIA Technologies, Inc. Unknown device 6238
        Subsystem: Unknown device 0008:0000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:00.7 Host bridge: VIA Technologies, Inc. VT3351 Host Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes

00:01.0 PCI bridge: VIA Technologies, Inc. [K8T890 North / VT8237 South]
PCI Bridge (prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:02.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge
Controller (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: f9000000-fbbfffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dffff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <1us, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1,
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x16
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [70] Message Signalled Interrupts: Mask+ 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000

00:03.0 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge
Controller (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D06, subordinate=3D06, sec-latency=3D=
0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fbd00000-fbdfffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <512ns, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Por=
t 1
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [70] Message Signalled Interrupts: Mask+ 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000

00:03.1 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge
Controller (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000f7f00000-00000000f7fff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Por=
t 2
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed unknown, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [70] Message Signalled Interrupts: Mask+ 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000001  Pending: 00000000

00:03.2 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge
Controller (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fbc00000-fbcfffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <4us, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Por=
t 3
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [70] Message Signalled Interrupts: Mask+ 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000

00:03.3 PCI bridge: VIA Technologies, Inc. K8T890 PCI to PCI Bridge
Controller (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000f7e00000-00000000f7eff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Por=
t 4
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed unknown, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [70] Message Signalled Interrupts: Mask+ 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000

00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port
Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: VIA Technologies, Inc. VT8237A SATA 2-Port Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin B routed to IRQ 21
        Region 0: I/O ports at cc00 [size=3D8]
        Region 1: I/O ports at c880 [size=3D4]
        Region 2: I/O ports at c800 [size=3D8]
        Region 3: I/O ports at c480 [size=3D4]
        Region 4: I/O ports at c400 [size=3D16]
        Region 5: I/O ports at c000 [size=3D256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:0f.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 07)
(prog-if 8a [Master SecP PriP])
        Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=3D8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=3D1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=3D8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=3D1]
        Region 4: I/O ports at fc00 [size=3D16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controll=
er
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 4: I/O ports at b480 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controll=
er
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 23
        Region 4: I/O ports at b800 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controll=
er
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 21
        Region 4: I/O ports at b880 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controll=
er
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 24
        Region 4: I/O ports at bc00 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 64 bytes
        Interrupt: pin C routed to IRQ 21
        Region 0: Memory at f8fffc00 (32-bit, non-prefetchable) [size=3D2=
56]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME+

00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
        Subsystem: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller=

        Subsystem: VIA Technologies, Inc. Unknown device 337e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128
        Capabilities: [58] HyperTransport: Interrupt Discovery and
Configuration

00:13.0 PCI bridge: VIA Technologies, Inc. VT8237A Host Bridge (prog-if
00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D80, subordinate=3D80, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fbf00000-fbffffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [70] Subsystem: VIA Technologies, Inc. VT8237A
Host Bridge

00:13.1 PCI bridge: VIA Technologies, Inc. VT8237A PCI to PCI Bridge
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D07, subordinate=3D07, sec-latency=3D=
0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fbe00000-fbefffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f00ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [60] HyperTransport: MSI Mapping
        Capabilities: [70] Subsystem: VIA Technologies, Inc. VT8237A PCI
to PCI Bridge

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [80] HyperTransport: Host or Secondary Interface
                !!! Possibly incomplete decoding
                Command: WarmRst+ DblEnd-
                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
<CRCErr=3D0
                Link Config: MLWI=3D16bit MLWO=3D16bit LWI=3D16bit LWO=3D=
16bit
                Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: [f0] #0f [0010]

02:00.0 VGA compatible controller: nVidia Corporation NV44 [GeForce 6200
TurboCache(TM)] (rev a1) (prog-if 00 [VGA])
        Subsystem: XFX Pine Group Inc. Unknown device 208f
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 27
        Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=3D1=
6M]
        Region 1: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]=

        Region 3: Memory at f9000000 (64-bit, non-prefetchable) [size=3D1=
6M]
        [virtual] Expansion ROM at fbbe0000 [disabled] [size=3D128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <512ns, L1 <4us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupporte=
d-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1,
Port 0
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x16

04:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit
Ethernet Adapter (rev b0)
        Subsystem: ASUSTeK Computer Inc. Unknown device 8226
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fbcc0000 (64-bit, non-prefetchable) [size=3D2=
56K]
        Expansion ROM at fbca0000 [disabled] [size=3D128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <4us, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupporte=
d-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0=

                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [6c] Vital Product Data

06:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device 6121
(rev b1) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 8212
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at dc00 [size=3D8]
        Region 1: I/O ports at d880 [size=3D4]
        Region 2: I/O ports at d800 [size=3D8]
        Region 3: I/O ports at d480 [size=3D4]
        Region 4: I/O ports at d400 [size=3D16]
        Region 5: Memory at fbdffc00 (32-bit, non-prefetchable) [size=3D1=
K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
Queue=3D0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupporte=
d-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1=

                Link: Latency L0s <256ns, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

07:08.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
Gigabit Ethernet (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ether=
net
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 26
        Region 0: I/O ports at e800 [size=3D256]
        Region 1: Memory at fbeffc00 (32-bit, non-prefetchable) [size=3D2=
56]
        Expansion ROM at f0000000 [disabled] [size=3D128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

80:01.0 Audio device: VIA Technologies, Inc. VIA High Definition Audio
Controller (rev 10)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81e7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 25
        Region 0: Memory at fbffc000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupporte=
d-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown,
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0




--------------enigB42774CFF3C97E61E395F3BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGcTZrKoUGSidwLE4RAveRAKC9B/poKU43LfnCZ962GzcCW6jptACePBq+
hn9gkvasWROC+PuO2XV5O1U=
=PdqX
-----END PGP SIGNATURE-----

--------------enigB42774CFF3C97E61E395F3BF--
