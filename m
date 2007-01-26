Return-Path: <linux-kernel-owner+w=401wt.eu-S965578AbXAZJT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbXAZJT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXAZJT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:19:29 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:39156 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965578AbXAZJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:19:25 -0500
Message-ID: <45B9C791.8020009@profihost.com>
Date: Fri, 26 Jan 2007 10:19:13 +0100
From: Stefan Priebe - FH <studium@profihost.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: Stephen Evanchik <evanchsa@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA ahci Bug in 2.6.19.x
References: <45B46FA0.2060901@profihost.com>	 <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>	 <3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>	 <a71293c20701252046o73fabcb9v611dedbb6f6b90e3@mail.gmail.com> <3877989d0701252122s7e5ad92fo5496daf566fd9f97@mail.gmail.com>
In-Reply-To: <3877989d0701252122s7e5ad92fo5496daf566fd9f97@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.134.56.132
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

acpi=off does not help i've already tried that.


Ok here some outputs:
1.) complete dmesg with 2.6.16.27 (works)

Linux version 2.6.16.27amd (root@server275-han) (gcc version 3.3.5 
(Debian 1:3.3.5-13)) #6 SMP Sat Aug 26 14:29:07 CEST 2006
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003bfb0000 (usable)
  BIOS-e820: 000000003bfb0000 - 000000003bfbe000 (ACPI data)
  BIOS-e820: 000000003bfbe000 - 000000003bfe0000 (ACPI NVS)
  BIOS-e820: 000000003bfe0000 - 000000003c000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
ACPI: RSDP (v002 ACPIAM                                ) @ 
0x00000000000fa850
ACPI: XSDT (v001 A M I  OEMXSDT  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0100
ACPI: FADT (v003 A M I  OEMFACP  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0290
ACPI: MADT (v001 A M I  OEMAPIC  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x12000527 MSFT 0x00000097) @ 
0x000000003bfbe040
ACPI: DSDT (v001  A0339 A0339000 0x00000000 INTL 0x02002026) @ 
0x0000000000000000
Scanning NUMA topology in Northbridge 24
Number of nodes 1
Node 0 MemBase 0000000000000000 Limit 000000003bfb0000
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
Bootmem setup node 0 0000000000000000-000000003bfb0000
On node 0 totalpages: 240991
   DMA zone: 2709 pages, LIFO batch:0
   DMA32 zone: 238282 pages, LIFO batch:31
   Normal zone: 0 pages, LIFO batch:0
   HighMem zone: 0 pages, LIFO batch:0
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:15 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 3c000000:c2c00000)
Checking aperture...
CPU 0: aperture @ f0000000 size 128 MB
Built 1 zonelists
Kernel command line: root=/dev/sda6 ro rootflags=quota Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2400.214 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Memory: 962212k/982720k available (2939k kernel code, 20120k reserved, 
1327k data, 220k init)
Calibrating delay using timer specific routine.. 4810.51 BogoMIPS 
(lpj=9621030)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(1) -> Node 0 -> Core 0
Using local APIC timer interrupts.
result 12501128
Detected 12.501 MHz APIC timer.
Brought up 1 CPUs
testing NMI watchdog ... OK.
migration_cost=0
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
PCI: Using MMCONFIG at e0000000
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 8 of bridge 0000:00:02.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:03.0
PCI-DMA: Disabling IOMMU.
pnp: 00:06: ioport range 0x290-0x297 has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: faf00000-fbffffff
   PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:02.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:02.0 to 64
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered (default)
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
Allocate Port Service[0000:00:02.0:pcie02]
Allocate Port Service[0000:00:02.0:pcie03]
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie01]
Allocate Port Service[0000:00:03.0:pcie02]
Allocate Port Service[0000:00:03.0:pcie03]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 16 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
isa bounce pool size: 16 pages
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 6.3.9-k4
Copyright (c) 1999-2005 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
via-rhine.c:v1.10-LK1.2.0-2.6 June-10-2004 Written by Donald Becker
GSI 18 sharing vector 0xD1 and IRQ 18
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 209
eth0: VIA Rhine II at 0x1b800, 00:17:31:13:19:f2, IRQ 209.
eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link 45e1.
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.49.
netconsole: device eth0 not up yet, forcing it
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
netconsole: carrier detect appears untrustworthy, waiting 4 seconds
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
Adaptec aacraid driver (1.1-4 Aug 26 2006 14:27:50)
megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.7 (Release Date: Mon Nov 14 12:27:22 EST 2005)
GDT-HA: Storage RAID Controller Driver. Version: 3.04
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.001.
3ware 9000 Storage Controller device driver for Linux v2.26.02.007.
libata version 1.20 loaded.
ahci 0000:00:0f.0: version 1.2
GSI 19 sharing vector 0xD9 and IRQ 19
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 217
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl IDE mode
ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xFFFFC20000004D00 ctl 0x0 bmdma 0x0 irq 225
ata2: SATA max UDMA/133 cmd 0xFFFFC20000004D80 ctl 0x0 bmdma 0x0 irq 225
ata3: SATA max UDMA/133 cmd 0xFFFFC20000004E00 ctl 0x0 bmdma 0x0 irq 225
ata4: SATA max UDMA/133 cmd 0xFFFFC20000004E80 ctl 0x0 bmdma 0x0 irq 225
ata1: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7469 86:bc01 87:4023 
88:40ff
ata1: dev 0 ATA-7, max UDMA7, 312581808 sectors: LBA48
ata1: dev 0 configured for UDMA/133
scsi0 : ahci
ata2: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7469 86:bc01 87:4023 
88:40ff
ata2: dev 0 ATA-7, max UDMA7, 312581808 sectors: LBA48
ata2: dev 0 configured for UDMA/133
scsi1 : ahci
ata3: no device found (phy stat 00000000)
scsi2 : ahci
ata4: no device found (phy stat 00000000)
scsi3 : ahci
   Vendor: ATA       Model: SAMSUNG HD160JJ   Rev: ZM10
   Type:   Direct-Access                      ANSI SCSI revision: 05
   Vendor: ATA       Model: SAMSUNG HD160JJ   Rev: ZM10
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
  sda: sda1 < sda5 sda6 sda7 >
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
  sdb: sdb1 < sdb5 sdb6 sdb7 >
sd 1:0:0:0: Attached scsi disk sdb
Fusion MPT base driver 3.03.07
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.03.07
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon 64 / Opteron processors (version 1.60.0)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x6 (1400 mV)
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x8 (1350 mV)
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa (1300 mV)
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc (1250 mV)
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12 (1100 mV)
cpu_init done, current fid 0x10, vid 0x6
XFS mounting filesystem sda6
Ending clean XFS mount for filesystem: sda6
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 220k freed
Adding 1349420k swap on /dev/sda7.  Priority:-1 extents:1 across:1349420k



2.) complete dmesg output with 2.6.18.6 (works)
Linux version 2.6.18.3amd (root@neuerserver) (gcc version 3.3.5 (Debian 
1:3.3.5-13)) #2 SMP Wed Dec 20 14:26:51 CET 2006
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003bfb0000 (usable)
  BIOS-e820: 000000003bfb0000 - 000000003bfbe000 (ACPI data)
  BIOS-e820: 000000003bfbe000 - 000000003bfe0000 (ACPI NVS)
  BIOS-e820: 000000003bfe0000 - 000000003c000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
DMI 2.3 present.
ACPI: RSDP (v002 ACPIAM                                ) @ 
0x00000000000fa850
ACPI: XSDT (v001 A M I  OEMXSDT  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0100
ACPI: FADT (v003 A M I  OEMFACP  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0290
ACPI: MADT (v001 A M I  OEMAPIC  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x12000527 MSFT 0x00000097) @ 
0x000000003bfbe040
ACPI: DSDT (v001  A0339 A0339000 0x00000000 INTL 0x02002026) @ 
0x0000000000000000
On node 0 totalpages: 240803
   DMA zone: 2521 pages, LIFO batch:0
   DMA32 zone: 238282 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:15 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 3c000000:c2c00000)
Built 1 zonelists.  Total pages: 240803
Kernel command line: nfs root=/dev/nfs 
nfsroot=85.158.176.245:/PXE/debian/rescue/debian-amd64 ip=dhcp 
BOOT_IMAGE=debian/rescue/debian-amd64/boot/vmlinuz.amd64
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2400.084 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ f0000000 size 128 MB
Memory: 961352k/982720k available (3487k kernel code, 20768k reserved, 
1452k data, 228k init)
Calibrating delay using timer specific routine.. 4804.44 BogoMIPS 
(lpj=9608882)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
SMP alternatives: switching to UP code
Freeing SMP alternatives: 28k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12500453
Detected 12.500 MHz APIC timer.
Brought up 1 CPUs
testing NMI watchdog ... OK.
migration_cost=0
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 8 of bridge 0000:00:02.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:03.0
PCI-DMA: Disabling IOMMU.
pnp: 00:06: ioport range 0x290-0x297 has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: faf00000-fbffffff
   PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:02.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:02.0 to 64
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 177
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie02]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 16 throttling states)
ACPI: Getting cpuindex for acpiid 0x2
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 7.1.9-k4
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
via-rhine.c:v1.10-LK1.4.1 July-24-2006 Written by Donald Becker
GSI 18 sharing vector 0xD1 and IRQ 18
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 209
eth0: VIA Rhine II at 0x1b800, 00:17:31:13:19:f2, IRQ 209.
eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link 45e1.
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.56.
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
Adaptec aacraid driver (1.1-5[2409]-mh2)
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.001.
3ware 9000 Storage Controller device driver for Linux v2.26.02.007.
libata version 2.00 loaded.
ahci 0000:00:0f.0: version 2.0
GSI 19 sharing vector 0xD9 and IRQ 19
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 217
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl IDE mode
ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xFFFFC20000004D00 ctl 0x0 bmdma 0x0 irq 225
ata2: SATA max UDMA/133 cmd 0xFFFFC20000004D80 ctl 0x0 bmdma 0x0 irq 225
ata3: SATA max UDMA/133 cmd 0xFFFFC20000004E00 ctl 0x0 bmdma 0x0 irq 225
ata4: SATA max UDMA/133 cmd 0xFFFFC20000004E80 ctl 0x0 bmdma 0x0 irq 225
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA7, 312581808 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7, max UDMA7, 312581808 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 16
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
   Vendor: ATA       Model: SAMSUNG HD160JJ   Rev: ZM10
   Type:   Direct-Access                      ANSI SCSI revision: 05
   Vendor: ATA       Model: SAMSUNG HD160JJ   Rev: ZM10
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
  sda: sda1 < sda5 sda6 sda7 >
sd 0:0:0:0: Attached scsi disk sda
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
  sdb: sdb1 < sdb5 sdb6 sdb7 >
sd 1:0:0:0: Attached scsi disk sdb
Fusion MPT base driver 3.04.01
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.01
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3800+ processors 
(version 2.00.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x6
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1


3.) complete output (2.6.19.2) (with acpi does not work)

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003bfb0000 (usable)
  BIOS-e820: 000000003bfb0000 - 000000003bfbe000 (ACPI data)
  BIOS-e820: 000000003bfbe000 - 000000003bfe0000 (ACPI NVS)
  BIOS-e820: 000000003bfe0000 - 000000003c000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 245680) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP (v002 ACPIAM                                ) @ 
0x00000000000fa850
ACPI: XSDT (v001 A M I  OEMXSDT  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0100
ACPI: FADT (v003 A M I  OEMFACP  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0290
ACPI: MADT (v001 A M I  OEMAPIC  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x12000527 MSFT 0x00000097) @ 
0x000000003bfb0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x12000527 MSFT 0x00000097) @ 
0x000000003bfbe040
ACPI: DSDT (v001  A0339 A0339000 0x00000000 INTL 0x02002026) @ 
0x0000000000000000
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 245680) 1 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
     0:        0 ->      159
     0:      256 ->   245680
On node 0 totalpages: 245583
   DMA zone: 56 pages used for memmap
   DMA zone: 1474 pages reserved
   DMA zone: 2469 pages, LIFO batch:0
   DMA32 zone: 3302 pages used for memmap
   DMA32 zone: 238282 pages, LIFO batch:31
   Normal zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 2, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 3c000000:c2c00000)
PERCPU: Allocating 36352 bytes of per cpu data
Built 1 zonelists.  Total pages: 240751
Kernel command line: nfs root=/dev/nfs 
nfsroot=85.158.176.245:/PXE/debian/rescue/debian-amd64 ip=dhcp 
BOOT_IMAGE=debian/rescue/debian-amd64/boot/vmlinuz.amd64
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ f0000000 size 128 MB
Memory: 961140k/982720k available (3530k kernel code, 20980k reserved, 
1474k data, 264k init)
Calibrating delay using timer specific routine.. 4804.06 BogoMIPS 
(lpj=9608139)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
SMP alternatives: switching to UP code
Freeing SMP alternatives: 32k freed
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 12501046
Detected 12.501 MHz APIC timer.
Brought up 1 CPUs
testing NMI watchdog ... OK.
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2400.198 MHz processor.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 8 of bridge 0000:00:02.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:03.0
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
PCI-DMA: Disabling IOMMU.
pnp: 00:06: ioport range 0x290-0x297 has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: faf00000-fbffffff
   PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:02.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 27
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 31 (level, low) -> IRQ 31
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie02]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 16 throttling states)
ACPI: Getting cpuindex for acpiid 0x2
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 7.2.9-k4
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 23
eth0: VIA Rhine II at 0x1b800, 00:17:31:13:19:f2, IRQ 23.
eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link 45e1.
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.57.
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
Adaptec aacraid driver (1.1-5[2409]-mh2)
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.001.
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
ahci 0000:00:0f.0: version 2.0
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl IDE mode
ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xFFFFC20000004D00 ctl 0x0 bmdma 0x0 irq 1277
ata2: SATA max UDMA/133 cmd 0xFFFFC20000004D80 ctl 0x0 bmdma 0x0 irq 1277
ata3: SATA max UDMA/133 cmd 0xFFFFC20000004E00 ctl 0x0 bmdma 0x0 irq 1277
ata4: SATA max UDMA/133 cmd 0xFFFFC20000004E80 ctl 0x0 bmdma 0x0 irq 1277
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 04(08)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ata1: COMRESET failed (device not ready)
ata1: hardreset failed, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ata1: COMRESET failed (device not ready)
ata1: hardreset failed, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0x80)
ata1: port failed to respond (30 secs, Status 0x80)
ata1: COMRESET failed (device not ready)
ata1: reset failed, giving up
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 08(08)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: reset failed, giving up
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
Fusion MPT base driver 3.04.02
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.02
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3800+ processors 
(version 2.00.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x6
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Sending DHCP requests ., OK
IP-Config: Got DHCP answer from 85.158.176.245, my address is 85.158.176.246
IP-Config: Complete:
       device=eth0, addr=85.158.176.246, mask=255.255.255.0, 
gw=85.158.176.1,
      host=85.158.176.246, domain=, nis-domain=(none),
      bootserver=85.158.176.245, rootserver=85.158.176.245, rootpath=
Looking up port of RPC 100003/2 on 85.158.176.245
Looking up port of RPC 100005/1 on 85.158.176.245
VFS: Mounted root (nfs filesystem) readonly.
Freeing unused kernel memory: 264k freed



4.) complete output (2.6.19.2) (acpi=off does not work)
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003bfb0000 (usable)
  BIOS-e820: 000000003bfb0000 - 000000003bfbe000 (ACPI data)
  BIOS-e820: 000000003bfbe000 - 000000003bfe0000 (ACPI NVS)
  BIOS-e820: 000000003bfe0000 - 000000003c000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
  BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 245680) 1 entries of 256 used
end_pfn_map = 1048576
DMI 2.3 present.
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 245680) 1 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
     0:        0 ->      159
     0:      256 ->   245680
On node 0 totalpages: 245583
   DMA zone: 56 pages used for memmap
   DMA zone: 1474 pages reserved
   DMA zone: 2469 pages, LIFO batch:0
   DMA32 zone: 3302 pages used for memmap
   DMA32 zone: 238282 pages, LIFO batch:31
   Normal zone: 0 pages used for memmap
Intel MultiProcessor Specification v1.1
MPTABLE: OEM ID: TEMPLATE MPTABLE: Product ID:  MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
I/O APIC #1 at 0xFEC00000.
I/O APIC #2 at 0xFECC0000.
Setting APIC routing to flat
Processors: 1
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e4000
Nosave address range: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 3c000000:c2c00000)
PERCPU: Allocating 36352 bytes of per cpu data
Built 1 zonelists.  Total pages: 240751
Kernel command line: nfs root=/dev/nfs 
nfsroot=85.158.176.245:/PXE/debian/rescue/debian-amd64 ip=dhcp acpi=off 
BOOT_IMAGE=debian/rescue/debian-amd64/boot/vmlinuz.amd64
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
CPU 0: aperture @ f0000000 size 128 MB
Memory: 961140k/982720k available (3530k kernel code, 20980k reserved, 
1474k data, 264k init)
Calibrating delay using timer specific routine.. 4818.82 BogoMIPS 
(lpj=9637645)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
SMP alternatives: switching to UP code
Freeing SMP alternatives: 32k freed
Using local APIC timer interrupts.
result 12500751
Detected 12.500 MHz APIC timer.
Brought up 1 CPUs
testing NMI watchdog ... OK.
time.c: Using 1.193182 MHz WALL PIT GTOD PIT/TSC timer.
time.c: Detected 2400.142 MHz processor.
NET: Registered protocol family 16
PCI: Using configuration type 1
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:13.1
PCI: Using IRQ router default [1106/3287] at 0000:00:11.0
PCI->APIC IRQ transform: 0000:00:02.0[A] -> IRQ 27
PCI->APIC IRQ transform: 0000:00:03.0[A] -> IRQ 31
PCI->APIC IRQ transform: 0000:00:0f.0[B] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:10.0[A] -> IRQ 20
PCI->APIC IRQ transform: 0000:00:10.1[C] -> IRQ 22
PCI->APIC IRQ transform: 0000:00:10.2[B] -> IRQ 21
PCI->APIC IRQ transform: 0000:00:10.3[D] -> IRQ 23
PCI->APIC IRQ transform: 0000:00:12.0[A] -> IRQ 23
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 16
PCI: Cannot allocate resource region 8 of bridge 0000:00:02.0
PCI: Cannot allocate resource region 8 of bridge 0000:00:03.0
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
PCI-DMA: Disabling IOMMU.
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: faf00000-fbffffff
   PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:02.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie02]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie02]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 7.2.9-k4
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
eth0: VIA Rhine II at 0x1b800, 00:17:31:13:19:f2, IRQ 23.
eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link 45e1.
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.57.
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
Adaptec aacraid driver (1.1-5[2409]-mh2)
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.4.9 (Release Date: Sun Jul 16 12:27:22 EST 2006)
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.001.
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
ahci 0000:00:0f.0: version 2.0
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl IDE mode
ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xFFFFC20000000D00 ctl 0x0 bmdma 0x0 irq 1277
ata2: SATA max UDMA/133 cmd 0xFFFFC20000000D80 ctl 0x0 bmdma 0x0 irq 1277
ata3: SATA max UDMA/133 cmd 0xFFFFC20000000E00 ctl 0x0 bmdma 0x0 irq 1277
ata4: SATA max UDMA/133 cmd 0xFFFFC20000000E80 ctl 0x0 bmdma 0x0 irq 1277
scsi0 : ahci
ata1: SATA link down (SStatus 601 SControl 300)
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 04(08)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: reset failed, giving up
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
Fusion MPT base driver 3.04.02
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.02
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3800+ processors 
(version 2.00.00)
powernow-k8:    0 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xc
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xa
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    4 : fid 0x10 (2400 MHz), vid 0x6
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Sending DHCP requests ., OK
IP-Config: Got DHCP answer from 85.158.176.245, my address is 85.158.176.246
IP-Config: Complete:
       device=eth0, addr=85.158.176.246, mask=255.255.255.0, 
gw=85.158.176.1,
      host=85.158.176.246, domain=, nis-domain=(none),
      bootserver=85.158.176.245, rootserver=85.158.176.245, rootpath=
Looking up port of RPC 100003/2 on 85.158.176.245
Looking up port of RPC 100005/1 on 85.158.176.245
VFS: Mounted root (nfs filesystem) readonly.
Freeing unused kernel memory: 264k freed


Stefan

Luming Yu schrieb:
> On 1/26/07, Stephen Evanchik <evanchsa@gmail.com> wrote:
>> On 1/25/07, Luming Yu <luming.yu@gmail.com> wrote:
>> > From the log:
>> > 2.6.18.3:
>> > ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 217
>> > 2.6.20-rc5:
>> > "ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21"
>> >
>> > Sounds like acpi interrupt configure problem. Please try acpi=off 
>> first.
>>
>>
>> Still does not recognize the SATA device (and the machine fails to
>> come up). I tested this with 2.6.19.2, 2.6.20-rc5 and -rc6 this
>> evening. I am going to build a vanilla 2.6.18 and see if that still
>> works as I am currently running an FC5 kernel.
>>
> Is there any difference in dmesg with acpi=off?
> what is your sata driver?

