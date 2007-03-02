Return-Path: <linux-kernel-owner+w=401wt.eu-S2992590AbXCBQfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992590AbXCBQfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992597AbXCBQfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:35:21 -0500
Received: from bay0-omc2-s5.bay0.hotmail.com ([65.54.246.141]:46326 "EHLO
	bay0-omc2-s5.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992590AbXCBQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:35:19 -0500
Message-ID: <BAY103-DAV13062D629FC55EB9D69AFEB2870@phx.gbl>
X-Originating-IP: [85.36.106.198]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: panic on 2.6.20
Date: Fri, 2 Mar 2007 17:35:13 +0100
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 02 Mar 2007 16:35:18.0425 (UTC) FILETIME=[C36D8090:01C75CE8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Sorry for posting to this list,
but I got this panic with linux
2.6.20
I have also changed the motherboard
of this server and memtest has not
found any error (ram tested for 10
hours)
May anyone tell me if this could
be an hardware problem?

TIA

Linux version 2.6.20 (root@Pleiadi) (gcc version 3.4.6) #1 SMP Mon Feb 5
09:12:13 CET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009ac00 end:
000000000009ac00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009ac00 size: 0000000000005400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000ce000 size: 0000000000002000 end:
00000000000d0000 type: 2
copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fdf0000 end:
000000003fef0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003fef0000 size: 000000000000b000 end:
000000003fefb000 type: 3
copy_e820_map() start: 000000003fefb000 size: 0000000000005000 end:
000000003ff00000 type: 4
copy_e820_map() start: 000000003ff00000 size: 0000000000080000 end:
000000003ff80000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff80000 size: 0000000000080000 end:
0000000040000000 type: 2
copy_e820_map() start: 00000000e0000000 size: 0000000010000000 end:
00000000f0000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000100400 end:
00000000fed00400 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000100000 end:
00000000fef00000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000100000 end:
00000000ffc00000 type: 2
copy_e820_map() start: 00000000fff00000 size: 0000000000100000 end:
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
 BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
 BIOS-e820: 000000003fef0000 - 000000003fefb000 (ACPI data)
 BIOS-e820: 000000003fefb000 - 000000003ff00000 (ACPI NVS)
 BIOS-e820: 000000003ff00000 - 000000003ff80000 (usable)
 BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6c10
Entering add_active_range(0, 0, 262016) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262016
early_node_map[1] active PFN ranges
    0:        0 ->   262016
On node 0 totalpages: 262016
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32385 pages, LIFO batch:7
DMI present.
ACPI: RSDP (v002 PTLTD                                 ) @ 0x000f6ba0
ACPI: XSDT (v001 PTLTD    XSDT   0x06040001  LTP 0x00000000) @
0x3fef5381
ACPI: FADT (v003 FSC             0x06040001      0x000f4240) @
0x3fef5441
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040001 PTL  0x00000001) @
0x3fefaeb0
ACPI: MCFG (v001 PTLTD    MCFG   0x06040001  LTP 0x00000000) @
0x3fefaf00
ACPI: MADT (v001 PTLTD    APIC   0x06040001  LTP 0x00000000) @
0x3fefaf40
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040001  LTP 0x00000001) @
0x3fefafd8
ACPI: DSDT (v001 FSC    D1649    0x06040001 MSFT 0x02000002) @
0x00000000
ACPI: PM-Timer IO Port: 0xf008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x04] address[0xfec80800] gsi_base[48])
IOAPIC[2]: apic_id 4, version 32, address 0xfec80800, GSI 48-71
ACPI: IOAPIC (id[0x05] address[0xfec84000] gsi_base[72])
IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
ACPI: IOAPIC (id[0x06] address[0xfec84800] gsi_base[96])
IOAPIC[4]: apic_id 6, version 32, address 0xfec84800, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 5 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
Detected 3200.432 MHz processor.
Built 1 zonelists.  Total pages: 259969
Kernel command line: BOOT_IMAGE=Linux ro root=801
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80800)
mapped IOAPIC to ffff9000 (fec84000)
mapped IOAPIC to ffff8000 (fec84800)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1035312k/1048064k available (2004k kernel code, 12104k reserved,
599k data, 188k init, 130496k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0391000 - 0xc03c0000   ( 188 kB)
      .data : 0xc02f5100 - 0xc038b074   ( 599 kB)
      .text : 0xc0100000 - 0xc02f5100   (2004 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 6403.81 BogoMIPS
(lpj=32019099)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000641d 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003180 0000641d
00000000 00000001
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Xeon(TM) CPU 3.20GHz stepping 0a
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.42 BogoMIPS
(lpj=32002104)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000641d 00000000 00000001
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003180 0000641d
00000000 00000001
CPU1: Intel(R) Xeon(TM) CPU 3.20GHz stepping 0a
Total of 2 processors activated (12804.24 BogoMIPS).
ENABLING IO-APIC IRQs
.TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=65
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on 9:5
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region f000-f07f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region f180-f1bf claimed by ICH4 GPIO
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: PXH quirk detected, disabling MSI for SHPC device
Boot video device is 0000:09:05.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEA0.DOB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEA0.DOB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEC0.PXH0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEC0.PXH2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
ACPI: Device [ECP] status [00000008]: functional but not present;
setting present
ACPI: Device [COM1] status [00000008]: functional but not present;
setting present
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
PCI: Bridge: 0000:01:00.0
  IO window: 3000-3fff
  MEM window: de100000-de3fffff
  PREFETCH window: 50000000-501fffff
PCI: Bridge: 0000:01:00.2
  IO window: 4000-4fff
  MEM window: de400000-de4fffff
  PREFETCH window: 50200000-502fffff
PCI: Bridge: 0000:00:02.0
  IO window: 3000-4fff
  MEM window: de100000-de4fffff
  PREFETCH window: 50000000-502fffff
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: de500000-de5fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: de600000-de6fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:06:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:06:00.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: de700000-de7fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 5000-5fff
  MEM window: de800000-dfffffff
  PREFETCH window: 50300000-503fffff
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:01:00.2 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:06:00.0 to 64
ACPI: PCI Interrupt 0000:06:00.2[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:06:00.2 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x5c set to 0x80
highmem bounce pool size: 64 pages
SGI XFS with no debug enabled
io scheduler noop registered
io scheduler deadline registered (default)
Fusion MPT base driver 3.04.03
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.03
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 24 (level, low) -> IRQ 18
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01033000h, Ports=1, MaxQ=222, IRQ=18
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled
scsi 0:0:0:0: Direct-Access     LSILOGIC 1030          IM 1000 PQ: 0
ANSI: 2
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, resync in progress
SCSI device sda: 585728000 512-byte hdwr sectors (299893 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 08
SCSI device sda: write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 585728000 512-byte hdwr sectors (299893 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 08
SCSI device sda: write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:8:0: Processor         SDR      GEM318P          1    PQ: 0
ANSI: 2
 target0:0:8: Beginning Domain Validation
 target0:0:8: Ending Domain Validation
 target0:0:8: asynchronous
scsi 0:1:0:0: Direct-Access     HITACHI  HUS103030FL3800  SK02 PQ: 0
ANSI: 3
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, quiesced, resync in
progress
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now online, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc0:   PhysDisk is now online, out of sync, quiesced
 target0:1:0: Beginning Domain Validation
 target0:1:0: Ending Domain Validation
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, resync in progress
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc0:   PhysDisk is now online, out of sync
 target0:1:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP
(6.25 ns, offset 80)
scsi 0:1:1:0: Direct-Access     HITACHI  HUS103030FL3800  SK02 PQ: 0
ANSI: 3
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, quiesced, resync in
progress
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now online, quiesced
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc0:   PhysDisk is now online, out of sync, quiesced
 target0:1:1: Beginning Domain Validation
 target0:1:1: Ending Domain Validation
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, resync in progress
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 0
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc0:   PhysDisk is now online, out of sync
 target0:1:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP
(6.25 ns, offset 80)
ACPI: PCI Interrupt 0000:02:08.1[B] -> GSI 25 (level, low) -> IRQ 19
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities={Initiator}
scsi1 : ioc1: LSI53C1030, FwRev=01033000h, Ports=1, MaxQ=222, IRQ=19
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now degraded, enabled, resync in progress
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
nf_conntrack version 0.5.0 (8188 buckets, 65504 max)
input: AT Translated Set 2 keyboard as /class/input/input0
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Starting balanced_irq
Using IPI Shortcut mode
Time: tsc clocksource has been installed.
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 188k freed
Adding 875500k swap on /dev/sda9.  Priority:-1 extents:1 across:875500k
tg3.c:v3.72 (January 8, 2007)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:30:05:cb:27:c1
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1]
TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:05:00.0 to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:30:05:c2:56:0e
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1]
TSOcap[1]
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
Intel(R) PRO/1000 Network Driver - version 7.3.15-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 52 (level, low) -> IRQ 20
e1000: 0000:03:04.0: e1000_probe: (PCI-X:100MHz:64-bit)
00:04:23:d0:0f:02
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
XFS mounting filesystem sda5
Ending clean XFS mount for filesystem: sda5
XFS mounting filesystem sda6
Ending clean XFS mount for filesystem: sda6
XFS mounting filesystem sda7
Ending clean XFS mount for filesystem: sda7
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
PM: Writing back config space on device 0000:04:00.0 at offset c (was
1d220000, writing 0)
PM: Writing back config space on device 0000:05:00.0 at offset c (was
90680000, writing 0)
e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
tg3: eth1: Link is up at 100 Mbps, full duplex.
tg3: eth1: Flow control is off for TX and off for RX.
tg3: eth0: Link is up at 10 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
mptbase: ioc0: RAID STATUS CHANGE for PhysDisk 1
mptbase: ioc0:   PhysDisk is now online
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled, resync in progress
mptbase: ioc0: RAID STATUS CHANGE for VolumeID 0
mptbase: ioc0:   volume is now optimal, enabled
BUG: unable to handle kernel paging request at virtual address a0814e49
 printing eip:
c013c22d
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp
nf_conntrack_proto_gre nf_nat_ftp nf_conntrack_ftp e1000 tg3
CPU:    0
EIP:    0060:[<c013c22d>]    Not tainted VLI
EFLAGS: 00010082   (2.6.20 #1)
EIP is at find_lock_page+0x39/0x9c
eax: a0814e49   ebx: a0814e49   ecx: fffffffa   edx: a0814e49
esi: f7e28694   edi: f7e286a4   ebp: 01e452a8   esp: eb585b38
ds: 007b   es: 007b   ss: 0068
Process squid (pid: 29819, ti=eb584000 task=c1969550 task.ti=eb584000)
Stack: f7e28698 00000000 f4f96380 00000250 01e452a8 c013c2c7 00000250
f7e28694
       c1330ce0 f4f96380 00001000 00000000 c01e8caf c01e8a0a f4f96380
f7ed37f4
       00000001 c03bee20 c03bee20 00000000 01e452a7 00010001 00000250
00001000
Call Trace:
 [<c013c2c7>] find_or_create_page+0x37/0x8e
 [<c01e8caf>] _xfs_buf_lookup_pages+0x132/0x2ea
 [<c01e8a0a>] _xfs_buf_initialize+0xc8/0xf6
 [<c01e91a0>] xfs_buf_get_flags+0xf8/0x11d
 [<c01e91e1>] xfs_buf_read_flags+0x1c/0x7f
 [<c01db071>] xfs_trans_read_buf+0x16a/0x34f
 [<c01c1a3f>] xfs_itobp+0x7c/0x242
 [<c01c2e8b>] xfs_iread+0x68/0x1d3
 [<c01b5835>] xfs_dir2_leaf_lookup+0xd8/0xe2
 [<c01c0a4a>] xfs_iget_core+0xe7/0x687
 [<c01c10c2>] xfs_iget+0xd8/0x150
 [<c01dc156>] xfs_dir_lookup_int+0x98/0x10e
 [<c01e1ad8>] xfs_lookup+0x5a/0x90
 [<c01ed58f>] xfs_vn_lookup+0x52/0x93
 [<c015e88c>] real_lookup+0xbb/0x116
 [<c015eb02>] do_lookup+0x90/0xc2
 [<c01ed53d>] xfs_vn_lookup+0x0/0x93
 [<c015f25b>] __link_path_walk+0x727/0xcf1
 [<c015f863>] link_path_walk+0x3e/0xac
 [<c0157457>] get_unused_fd+0x2e/0xb6
 [<c015fb9f>] do_path_lookup+0x11a/0x1ba
 [<c015fca7>] __path_lookup_intent_open+0x50/0x90
 [<c015fd07>] path_lookup_open+0x20/0x25
 [<c01604e3>] open_namei+0x7a/0x550
 [<c01489ec>] do_wp_page+0x20e/0x3e8
 [<c01572d2>] do_filp_open+0x2e/0x5b
 [<c0157457>] get_unused_fd+0x2e/0xb6
 [<c01575c5>] do_sys_open+0x4e/0xdb
 [<c015766e>] sys_open+0x1c/0x20
 [<c0102c24>] syscall_call+0x7/0xb
 =======================
Code: 89 c6 89 f8 89 6c 24 10 89 5c 24 04 89 d5 e8 85 80 1b 00 8d 46 04
89 04 24 89 ea 8b 04 24 e8 6d ea 0c 00 85 c0 89 c3 74 35 89 c2 <8b> 00
f6 c4 40 75 57 f0 ff 42 04 f0 0f ba 2b 00 19 c0 85 c0 74
EIP: [<c013c22d>] find_lock_page+0x39/0x9c SS:ESP 0068:eb585b38

This this the output from:

dmesg | ksymoops

ksymoops 2.4.11 on i686 2.6.20.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.20/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
SGI XFS with no debug enabled
e1000: 0000:03:04.0: e1000_probe: (PCI-X:100MHz:64-bit)
00:04:23:d0:0f:02
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
BUG: unable to handle kernel paging request at virtual address a0814e49
c013c22d
*pde = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c013c22d>]    Not tainted VLI
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010082   (2.6.20 #1)
eax: a0814e49   ebx: a0814e49   ecx: fffffffa   edx: a0814e49
esi: f7e28694   edi: f7e286a4   ebp: 01e452a8   esp: eb585b38
ds: 007b   es: 007b   ss: 0068
Stack: f7e28698 00000000 f4f96380 00000250 01e452a8 c013c2c7 00000250
f7e28694
       c1330ce0 f4f96380 00001000 00000000 c01e8caf c01e8a0a f4f96380
f7ed37f4
       00000001 c03bee20 c03bee20 00000000 01e452a7 00010001 00000250
00001000
Call Trace:
 [<c013c2c7>] find_or_create_page+0x37/0x8e
 [<c01e8caf>] _xfs_buf_lookup_pages+0x132/0x2ea
 [<c01e8a0a>] _xfs_buf_initialize+0xc8/0xf6
 [<c01e91a0>] xfs_buf_get_flags+0xf8/0x11d
 [<c01e91e1>] xfs_buf_read_flags+0x1c/0x7f
 [<c01db071>] xfs_trans_read_buf+0x16a/0x34f
 [<c01c1a3f>] xfs_itobp+0x7c/0x242
 [<c01c2e8b>] xfs_iread+0x68/0x1d3
 [<c01b5835>] xfs_dir2_leaf_lookup+0xd8/0xe2
 [<c01c0a4a>] xfs_iget_core+0xe7/0x687
 [<c01c10c2>] xfs_iget+0xd8/0x150
 [<c01dc156>] xfs_dir_lookup_int+0x98/0x10e
 [<c01e1ad8>] xfs_lookup+0x5a/0x90
 [<c01ed58f>] xfs_vn_lookup+0x52/0x93
 [<c015e88c>] real_lookup+0xbb/0x116
 [<c015eb02>] do_lookup+0x90/0xc2
 [<c01ed53d>] xfs_vn_lookup+0x0/0x93
 [<c015f25b>] __link_path_walk+0x727/0xcf1
 [<c015f863>] link_path_walk+0x3e/0xac
 [<c0157457>] get_unused_fd+0x2e/0xb6
 [<c015fb9f>] do_path_lookup+0x11a/0x1ba
 [<c015fca7>] __path_lookup_intent_open+0x50/0x90
 [<c015fd07>] path_lookup_open+0x20/0x25
 [<c01604e3>] open_namei+0x7a/0x550
 [<c01489ec>] do_wp_page+0x20e/0x3e8
 [<c01572d2>] do_filp_open+0x2e/0x5b
 [<c0157457>] get_unused_fd+0x2e/0xb6
 [<c01575c5>] do_sys_open+0x4e/0xdb
 [<c015766e>] sys_open+0x1c/0x20
 [<c0102c24>] syscall_call+0x7/0xb
Code: 89 c6 89 f8 89 6c 24 10 89 5c 24 04 89 d5 e8 85 80 1b 00 8d 46 04
89 04 24 89 ea 8b 04 24 e8 6d ea 0c 00 85 c0 89 c3 74 35 89 c2 <8b> 00
f6 c4 40 75 57 f0 ff 42 04 f0 0f ba 2b 00 19 c0 85 c0 74


>>EIP; c013c22d <find_lock_page+39/9c>   <=====

>>eax; a0814e49 <phys_startup_32+a0714e49/c0000000>
>>ebx; a0814e49 <phys_startup_32+a0714e49/c0000000>
>>edx; a0814e49 <phys_startup_32+a0714e49/c0000000>
>>ebp; 01e452a8 <phys_startup_32+1d452a8/c0000000>

Trace; c013c2c7 <find_or_create_page+37/8e>
Trace; c01e8caf <_xfs_buf_lookup_pages+132/2ea>
Trace; c01e8a0a <_xfs_buf_initialize+c8/f6>
Trace; c01e91a0 <xfs_buf_get_flags+f8/11d>
Trace; c01e91e1 <xfs_buf_read_flags+1c/7f>
Trace; c01db071 <xfs_trans_read_buf+16a/34f>
Trace; c01c1a3f <xfs_itobp+7c/242>
Trace; c01c2e8b <xfs_iread+68/1d3>
Trace; c01b5835 <xfs_dir2_leaf_lookup+d8/e2>
Trace; c01c0a4a <xfs_iget_core+e7/687>
Trace; c01c10c2 <xfs_iget+d8/150>
Trace; c01dc156 <xfs_dir_lookup_int+98/10e>
Trace; c01e1ad8 <xfs_lookup+5a/90>
Trace; c01ed58f <xfs_vn_lookup+52/93>
Trace; c015e88c <real_lookup+bb/116>
Trace; c015eb02 <do_lookup+90/c2>
Trace; c01ed53d <xfs_vn_lookup+0/93>
Trace; c015f25b <__link_path_walk+727/cf1>
Trace; c015f863 <link_path_walk+3e/ac>
Trace; c0157457 <get_unused_fd+2e/b6>
Trace; c015fb9f <do_path_lookup+11a/1ba>
Trace; c015fca7 <__path_lookup_intent_open+50/90>
Trace; c015fd07 <path_lookup_open+20/25>
Trace; c01604e3 <open_namei+7a/550>
Trace; c01489ec <do_wp_page+20e/3e8>
Trace; c01572d2 <do_filp_open+2e/5b>
Trace; c0157457 <get_unused_fd+2e/b6>
Trace; c01575c5 <do_sys_open+4e/db>
Trace; c015766e <sys_open+1c/20>
Trace; c0102c24 <syscall_call+7/b>

This architecture has variable length instructions, decoding before eip
is unreliable, take these instructions with a pinch of salt.

Code;  c013c202 <find_lock_page+e/9c>
00000000 <_EIP>:
Code;  c013c202 <find_lock_page+e/9c>
   0:   89 c6                     mov    %eax,%esi
Code;  c013c204 <find_lock_page+10/9c>
   2:   89 f8                     mov    %edi,%eax
Code;  c013c206 <find_lock_page+12/9c>
   4:   89 6c 24 10               mov    %ebp,0x10(%esp)
Code;  c013c20a <find_lock_page+16/9c>
   8:   89 5c 24 04               mov    %ebx,0x4(%esp)
Code;  c013c20e <find_lock_page+1a/9c>
   c:   89 d5                     mov    %edx,%ebp
Code;  c013c210 <find_lock_page+1c/9c>
   e:   e8 85 80 1b 00            call   1b8098 <_EIP+0x1b8098>
Code;  c013c215 <find_lock_page+21/9c>
  13:   8d 46 04                  lea    0x4(%esi),%eax
Code;  c013c218 <find_lock_page+24/9c>
  16:   89 04 24                  mov    %eax,(%esp)
Code;  c013c21b <find_lock_page+27/9c>
  19:   89 ea                     mov    %ebp,%edx
Code;  c013c21d <find_lock_page+29/9c>
  1b:   8b 04 24                  mov    (%esp),%eax
Code;  c013c220 <find_lock_page+2c/9c>
  1e:   e8 6d ea 0c 00            call   cea90 <_EIP+0xcea90>
Code;  c013c225 <find_lock_page+31/9c>
  23:   85 c0                     test   %eax,%eax
Code;  c013c227 <find_lock_page+33/9c>
  25:   89 c3                     mov    %eax,%ebx
Code;  c013c229 <find_lock_page+35/9c>
  27:   74 35                     je     5e <_EIP+0x5e>
Code;  c013c22b <find_lock_page+37/9c>
  29:   89 c2                     mov    %eax,%edx

This decode from eip onwards should be reliable

Code;  c013c22d <find_lock_page+39/9c>
00000000 <_EIP>:
Code;  c013c22d <find_lock_page+39/9c>   <=====
   0:   8b 00                     mov    (%eax),%eax   <=====
Code;  c013c22f <find_lock_page+3b/9c>
   2:   f6 c4 40                  test   $0x40,%ah
Code;  c013c232 <find_lock_page+3e/9c>
   5:   75 57                     jne    5e <_EIP+0x5e>
Code;  c013c234 <find_lock_page+40/9c>
   7:   f0 ff 42 04               lock incl 0x4(%edx)
Code;  c013c238 <find_lock_page+44/9c>
   b:   f0 0f ba 2b 00            lock btsl $0x0,(%ebx)
Code;  c013c23d <find_lock_page+49/9c>
  10:   19 c0                     sbb    %eax,%eax
Code;  c013c23f <find_lock_page+4b/9c>
  12:   85 c0                     test   %eax,%eax
Code;  c013c241 <find_lock_page+4d/9c>
  14:   74                        .byte 0x74

EIP: [<c013c22d>] find_lock_page+0x39/0x9c SS:ESP 0068:eb585b38
Warning (Oops_read): Code line not seen, dumping what data is available


>>EIP; c013c22d <find_lock_page+39/9c>   <=====


2 warnings and 1 error issued.  Results may not be reliable.


