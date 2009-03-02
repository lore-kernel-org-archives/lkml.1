Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbZCBBlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbZCBBlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZCBBlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:41:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbZCBBlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:41:21 -0500
Message-ID: <49AB3930.4080204@redhat.com>
Date: Sun, 01 Mar 2009 20:41:04 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com> <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
Content-Type: multipart/mixed;
 boundary="------------020201000307090008070007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020201000307090008070007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This dmesg is from a 2.6.25 kernel which works fine. I can gather other 
debugging info from the booting kernels if needed. But its a challenge 
to debug the bad kernel being efifb is initialized very late (so you 
never even get to the video initialization and cant see any logged 
messages) and since its a MacBook I dont have a real serial port for 
serial console. The efi map is for MacBook has a different layout from 
other EFI systems I have to test on. 2.6.29 kernel works on every EFI 
system I have except MacBook.

Brian

--------------020201000307090008070007
Content-Type: text/plain;
 name="dmesg.mac-efi.good"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.mac-efi.good"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.25-0.204.rc8.git4.fc9.x86_64 (mockbuild@) (gcc version 4.3.0 20080404 (Red Hat 4.3.0-6) (GCC) ) #1 SMP Mon Apr 7 10:25:52 EDT 2008
Command line: ro root=UUID=aa77bc4f-ce1e-46c2-ab72-8e693c722055
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (ACPI NVS)
 BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000a0000 - 00000000000c0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007eef0000 (usable)
 BIOS-e820: 000000007eef0000 - 000000007f0f1000 (ACPI NVS)
 BIOS-e820: 000000007f0f1000 - 000000007fe53000 (usable)
 BIOS-e820: 000000007fe53000 - 000000007fe79000 (reserved)
 BIOS-e820: 000000007fe79000 - 000000007fe89000 (usable)
 BIOS-e820: 000000007fe89000 - 000000007feb3000 (reserved)
 BIOS-e820: 000000007feb3000 - 000000007feb9000 (usable)
 BIOS-e820: 000000007feb9000 - 000000007febf000 (reserved)
 BIOS-e820: 000000007febf000 - 000000007fed2000 (usable)
 BIOS-e820: 000000007fed2000 - 000000007fed4000 (ACPI NVS)
 BIOS-e820: 000000007fed4000 - 000000007fed7000 (ACPI data)
 BIOS-e820: 000000007fed7000 - 000000007feda000 (ACPI NVS)
 BIOS-e820: 000000007feda000 - 000000007fedb000 (ACPI data)
 BIOS-e820: 000000007fedb000 - 000000007feef000 (ACPI NVS)
 BIOS-e820: 000000007feef000 - 000000007feff000 (ACPI data)
 BIOS-e820: 000000007feff000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f00f8000 - 00000000f00f9000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fffa0000 - 00000000fffd0000 (reserved)
Entering add_active_range(0, 0, 143) 0 entries of 3200 used
Entering add_active_range(0, 144, 160) 1 entries of 3200 used
Entering add_active_range(0, 256, 519920) 2 entries of 3200 used
Entering add_active_range(0, 520433, 523859) 3 entries of 3200 used
Entering add_active_range(0, 523897, 523913) 4 entries of 3200 used
Entering add_active_range(0, 523955, 523961) 5 entries of 3200 used
Entering add_active_range(0, 523967, 523986) 6 entries of 3200 used
end_pfn_map = 1048528
EFI v1.10 by Apple 
 ACPI=0x7fefe000  ACPI 2.0=0x7fefe014  SMBIOS=0x7fed3000 
Kernel-defined memdescdoesn't match the one from EFI!
EFI: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000008b000) (0MB)
EFI: mem01: type=2, attr=0xf, range=[0x000000000008b000-0x000000000008d000) (0MB)
EFI: mem02: type=7, attr=0xf, range=[0x000000000008d000-0x000000000008f000) (0MB)
EFI: mem03: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
EFI: mem04: type=7, attr=0xf, range=[0x0000000000090000-0x00000000000a0000) (0MB)
EFI: mem05: type=7, attr=0xf, range=[0x0000000000100000-0x000000007b677000) (1973MB)
EFI: mem06: type=2, attr=0xf, range=[0x000000007b677000-0x000000007b679000) (0MB)
EFI: mem07: type=7, attr=0xf, range=[0x000000007b679000-0x000000007b67c000) (0MB)
EFI: mem08: type=2, attr=0xf, range=[0x000000007b67c000-0x000000007c728000) (16MB)
EFI: mem09: type=1, attr=0xf, range=[0x000000007c728000-0x000000007c760000) (0MB)
EFI: mem10: type=2, attr=0xf, range=[0x000000007c760000-0x000000007c7ea000) (0MB)
EFI: mem11: type=4, attr=0xf, range=[0x000000007c7ea000-0x000000007ca57000) (2MB)
EFI: mem12: type=2, attr=0xf, range=[0x000000007ca57000-0x000000007ca9a000) (0MB)
EFI: mem13: type=1, attr=0xf, range=[0x000000007ca9a000-0x000000007cab6000) (0MB)
EFI: mem14: type=7, attr=0xf, range=[0x000000007cab6000-0x000000007d39c000) (8MB)
EFI: mem15: type=2, attr=0xf, range=[0x000000007d39c000-0x000000007d70d000) (3MB)
EFI: mem16: type=4, attr=0xf, range=[0x000000007d70d000-0x000000007ea40000) (19MB)
EFI: mem17: type=7, attr=0xf, range=[0x000000007ea40000-0x000000007ea4f000) (0MB)
EFI: mem18: type=4, attr=0xf, range=[0x000000007ea4f000-0x000000007ea78000) (0MB)
EFI: mem19: type=7, attr=0xf, range=[0x000000007ea78000-0x000000007ea79000) (0MB)
EFI: mem20: type=4, attr=0xf, range=[0x000000007ea79000-0x000000007eb0d000) (0MB)
EFI: mem21: type=7, attr=0xf, range=[0x000000007eb0d000-0x000000007ec02000) (0MB)
EFI: mem22: type=4, attr=0xf, range=[0x000000007ec02000-0x000000007eef0000) (2MB)
EFI: mem23: type=10, attr=0xf, range=[0x000000007eef0000-0x000000007f0f1000) (2MB)
EFI: mem24: type=4, attr=0xf, range=[0x000000007f0f1000-0x000000007f1cc000) (0MB)
EFI: mem25: type=7, attr=0xf, range=[0x000000007f1cc000-0x000000007f1cd000) (0MB)
EFI: mem26: type=4, attr=0xf, range=[0x000000007f1cd000-0x000000007fc72000) (10MB)
EFI: mem27: type=7, attr=0xf, range=[0x000000007fc72000-0x000000007fcd0000) (0MB)
EFI: mem28: type=3, attr=0xf, range=[0x000000007fcd0000-0x000000007fe4a000) (1MB)
EFI: mem29: type=7, attr=0xf, range=[0x000000007fe4a000-0x000000007fe53000) (0MB)
EFI: mem30: type=5, attr=0x800000000000000f, range=[0x000000007fe53000-0x000000007fe79000) (0MB)
EFI: mem31: type=7, attr=0xf, range=[0x000000007fe79000-0x000000007fe89000) (0MB)
EFI: mem32: type=6, attr=0x800000000000000f, range=[0x000000007fe89000-0x000000007feb3000) (0MB)
EFI: mem33: type=7, attr=0xf, range=[0x000000007feb3000-0x000000007feb9000) (0MB)
EFI: mem34: type=0, attr=0xf, range=[0x000000007feb9000-0x000000007febf000) (0MB)
EFI: mem35: type=7, attr=0xf, range=[0x000000007febf000-0x000000007fed2000) (0MB)
EFI: mem36: type=10, attr=0xf, range=[0x000000007fed2000-0x000000007fed4000) (0MB)
EFI: mem37: type=9, attr=0xf, range=[0x000000007fed4000-0x000000007fed7000) (0MB)
EFI: mem38: type=10, attr=0xf, range=[0x000000007fed7000-0x000000007feda000) (0MB)
EFI: mem39: type=9, attr=0xf, range=[0x000000007feda000-0x000000007fedb000) (0MB)
EFI: mem40: type=10, attr=0xf, range=[0x000000007fedb000-0x000000007feef000) (0MB)
EFI: mem41: type=9, attr=0xf, range=[0x000000007feef000-0x000000007feff000) (0MB)
EFI: mem42: type=6, attr=0x800000000000000f, range=[0x000000007feff000-0x000000007ff00000) (0MB)
EFI: mem43: type=0, attr=0x8000000000000000, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
EFI: mem44: type=0, attr=0x8000000000000000, range=[0x000000007ff00000-0x0000000080000000) (1MB)
EFI: mem45: type=11, attr=0x8000000000000000, range=[0x00000000f00f8000-0x00000000f00f9000) (0MB)
EFI: mem46: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
EFI: mem47: type=11, attr=0x8000000000000000, range=[0x00000000fffa0000-0x00000000fffd0000) (0MB)
DMI 2.4 present.
ACPI: RSDP 7FEFE014, 0024 (r2 APPLE )
ACPI: XSDT 7FEFE1C0, 007C (r1 APPLE   Apple00       70       1000013)
ACPI: FACP 7FEFC000, 00F4 (r3 APPLE   Apple00       70 Loki       5F)
ACPI: DSDT 7FEF1000, 48A8 (r1 APPLE  MacBookP    30001 INTL 20061109)
ACPI: FACS 7FEDB000, 0040
ACPI: HPET 7FEFB000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: APIC 7FEFA000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: MCFG 7FEF9000, 003C (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ASF! 7FEF8000, 00A5 (r32 APPLE   Apple00        1 Loki       5F)
ACPI: SBST 7FEF7000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ECDT 7FEF6000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: SSDT 7FEDA000, 0137 (r1 APPLE  SataAhci     1000 INTL 20061109)
ACPI: SSDT 7FED6000, 04DC (r1  APPLE    CpuPm     3000 INTL 20061109)
ACPI: SSDT 7FED5000, 025F (r1  APPLE  Cpu0Tst     3000 INTL 20061109)
ACPI: SSDT 7FED4000, 00A6 (r1  APPLE  Cpu1Tst     3000 INTL 20061109)
ACPI: DMI detected: Apple
No NUMA configuration found
Faking a node at 0000000000000000-000000007fed2000
Entering add_active_range(0, 0, 143) 0 entries of 3200 used
Entering add_active_range(0, 144, 160) 1 entries of 3200 used
Entering add_active_range(0, 256, 519920) 2 entries of 3200 used
Entering add_active_range(0, 520433, 523859) 3 entries of 3200 used
Entering add_active_range(0, 523897, 523913) 4 entries of 3200 used
Entering add_active_range(0, 523955, 523961) 5 entries of 3200 used
Entering add_active_range(0, 523967, 523986) 6 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007fed2000
  NODE_DATA [000000000000c000 - 0000000000013fff]
  bootmap [0000000000014000 -  0000000000023fdf] pages 10
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-75a73b] TEXT DATA BSS
early res: 3 [7d39c000-7d70cd69] RAMDISK
early res: 4 [8000-bfff] PGTABLE
No mptable found.
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0:        0 ->      143
    0:      144 ->      160
    0:      256 ->   519920
    0:   520433 ->   523859
    0:   523897 ->   523913
    0:   523955 ->   523961
    0:   523967 ->   523986
On node 0 totalpages: 523290
  DMA zone: 56 pages used for memmap
  DMA zone: 1377 pages reserved
  DMA zone: 2566 pages, LIFO batch:0
  DMA32 zone: 7107 pages used for memmap
  DMA32 zone: 512184 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000008f000 - 0000000000090000
PM: Registered nosave memory: 00000000000a0000 - 00000000000c0000
PM: Registered nosave memory: 00000000000c0000 - 0000000000100000
PM: Registered nosave memory: 000000007eef0000 - 000000007f0f1000
PM: Registered nosave memory: 000000007fe53000 - 000000007fe79000
PM: Registered nosave memory: 000000007fe89000 - 000000007feb3000
PM: Registered nosave memory: 000000007feb9000 - 000000007febf000
Allocating PCI resources starting at 88000000 (gap: 80000000:700f8000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 43120 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514750
Policy zone: DMA32
Kernel command line: ro root=UUID=aa77bc4f-ce1e-46c2-ab72-8e693c722055
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 2194.497 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2055152k/2095944k available (2652k kernel code, 38008k reserved, 1391k data, 352k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 4392.83 BogoMIPS (lpj=2196417)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12468724
Detected 12.468 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.80 BogoMIPS (lpj=2194400)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=224 bytes
sizeof(task_struct)=6256 bytes
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000003
  groups: 00000000,00000001 00000000,00000002
  domain 1: span 00000000,00000003
   groups: 00000000,00000003
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000003
  groups: 00000000,00000002 00000000,00000001
  domain 1: span 00000000,00000003
   groups: 00000000,00000003
net_namespace: 1016 bytes
Time: 18:18:25  Date: 02/18/09
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
ACPI: EC: non-query interrupt received, switching to interrupt mode
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:parse DMAR table failure.
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:07: ioport range 0x680-0x69f has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x810-0x817 has been reserved
system 00:07: ioport range 0x400-0x47f has been reserved
system 00:07: ioport range 0x500-0x53f has been reserved
system 00:07: ioport range 0x1640-0x164f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: 5000-5fff
  MEM window: 0x90000000-0x930fffff
  PREFETCH window: 0x0000000080000000-0x000000008fffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0x9b400000-0x9b4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: 0x97400000-0x9b3fffff
  PREFETCH window: 0x0000000093100000-0x00000000970fffff
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: 0x97300000-0x973fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.5
  IO window: 3000-3fff
  MEM window: 0x97200000-0x972fffff
  PREFETCH window: 0x000000009b600000-0x000000009b6fffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0x97100000-0x971fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Enabling device 0000:00:1c.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Enabling device 0000:00:1c.2 (0000 -> 0003)
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3523k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1234981105.471:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1a.0: Performing full reset
pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1a.1: Performing full reset
pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.2: Performing full reset
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
efifb: dmi detected MacBookPro3,1 - framebuffer at 0000000080030000 (1440x900, stride 8192)
efifb: probing for efifb
efifb: framebuffer at 0x80030000, mapped to 0xffffc20000900000, using 7200k, total 7200k
efifb: mode is 1440x900x32, linelength=8192, pages=1
efifb: scrolling: redraw
efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
Console: switching to colour frame buffer device 180x56
fb0: EFI VGA frame buffer device
ACPI: SSDT 7FED9A98, 02FE (r1  APPLE  Cpu0Ist     3000 INTL 20061109)
ACPI: SSDT 7FED7C18, 02A0 (r1  APPLE  Cpu0Cst     3001 INTL 20061109)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7FED8F18, 00C8 (r1  APPLE  Cpu1Ist     3000 INTL 20061109)
ACPI: SSDT 7FED7F18, 0085 (r1  APPLE  Cpu1Cst     3000 INTL 20061109)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 13:507:342
Freeing unused kernel memory: 352k freed
Write protecting the kernel read-only data: 1120k
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
PCI: Enabling device 0000:00:1a.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
Clocksource tsc unstable (delta = -249790719 ns)
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: supports USB remote wakeup
ehci_hcd 0000:00:1a.7: irq 21, io mem 0x9b504c00
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 20, io mem 0x9b504800
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: Single TT
hub 2-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 1 not reset yet, waiting 50ms
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 ehci_hcd
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0002
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
hub 2-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.0: Performing full reset
uhci_hcd 0000:00:1a.0: irq 20, io base 0x000060c0
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
usb 2-4: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
usb 2-4: skipped 1 descriptor after configuration
usb 2-4: skipped 5 descriptors after interface
usb 2-4: skipped 1 descriptor after endpoint
usb 2-4: skipped 22 descriptors after interface
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
usb 2-4: default language 0x0409
uhci_hcd 0000:00:1a.1: irq 16, io base 0x000060a0
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
usb 2-4: uevent
usb 2-4: usb_probe_device
usb 2-4: configuration #1 chosen from 1 choice
hub 4-0:1.0: 2 ports detected
usb 2-4: adding 2-4:1.0 (config #1, interface 0)
usb 2-4:1.0: uevent
usb 2-4: adding 2-4:1.1 (config #1, interface 1)
usb 2-4:1.1: uevent
usb 2-4: adding 2-4:1.2 (config #1, interface 2)
usb 2-4:1.2: uevent
drivers/usb/core/inode.c: creating file '002'
usb 2-4: New USB device found, idVendor=05ac, idProduct=8502
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-4: Product: Built-in iSight
usb 2-4: Manufacturer: Apple Inc.
usb 2-4: SerialNumber: C07BA2BF3B1A93DB (03.00)
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
hub 2-0:1.0: port 5, status 0501, change 0001, 480 Mb/s
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: debounce: port 5: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 5 low speed --> companion
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 6, status 0501, change 0001, 480 Mb/s
usb usb4: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
hub 2-0:1.0: debounce: port 6: total 100ms stable 100ms status 0x501
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
hub 2-0:1.0: port 6 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1a.0: port 1 portsc 009b,00
hub 3-0:1.0: port 1, status 0101, change 0003, 12 Mb/s
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '006'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: irq 18, io base 0x00006060
usb usb6: default language 0x0409
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb usb6: uevent
usb usb6: usb_probe_device
usb usb6: configuration #1 chosen from 1 choice
usb usb6: adding 6-0:1.0 (config #1, interface 0)
usb 6-0:1.0: uevent
hub 6-0:1.0: usb_probe_interface
hub 6-0:1.0: usb_probe_interface - got id
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
hub 6-0:1.0: standalone hub
hub 6-0:1.0: no power switching (usb 1.0)
hub 6-0:1.0: individual port over-current protection
hub 6-0:1.0: power on to power good time: 2ms
hub 6-0:1.0: local power source is good
hub 6-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '007'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00006040
usb usb7: default language 0x0409
usb usb7: uevent
usb usb7: usb_probe_device
usb usb7: configuration #1 chosen from 1 choice
usb usb7: adding 7-0:1.0 (config #1, interface 0)
usb 7-0:1.0: uevent
hub 7-0:1.0: usb_probe_interface
hub 7-0:1.0: usb_probe_interface - got id
hub 7-0:1.0: USB hub found
usb 3-1: skipped 1 descriptor after interface
usb 3-1: skipped 1 descriptor after interface
usb 3-1: uevent
hub 7-0:1.0: 2 ports detected
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
hub 7-0:1.0: standalone hub
hub 7-0:1.0: no power switching (usb 1.0)
hub 7-0:1.0: individual port over-current protection
hub 7-0:1.0: power on to power good time: 2ms
hub 7-0:1.0: local power source is good
hub 7-0:1.0: trying to enable port power on non-switchable hub
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usbhid 3-1:1.0: usb_probe_interface
usbhid 3-1:1.0: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input1
uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
input,hidraw0: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1a.0-1
usb 3-1: adding 3-1:1.1 (config #1, interface 1)
usb 3-1:1.1: uevent
usbhid 3-1:1.1: usb_probe_interface
usbhid 3-1:1.1: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input2
drivers/usb/core/inode.c: creating file '001'
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
input,hidraw1: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1a.0-1
drivers/usb/core/inode.c: creating file '002'
usb 3-1: New USB device found, idVendor=05ac, idProduct=1000
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0040
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:1d.1: port 2 portsc 008a,00
hub 6-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb4: suspend_rh (auto-stop)
usb usb7: Manufacturer: Linux 2.6.25-0.204.rc8.git4.fc9.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 6-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:1d.2: port 1 portsc 01ab,00
hub 7-0:1.0: port 1, status 0301, change 0003, 1.5 Mb/s
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
hub 7-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 18 (level, low) -> IRQ 18
usb 7-1: new low speed USB device using uhci_hcd and address 2
usb 7-1: skipped 1 descriptor after interface
usb 7-1: default language 0x0409
usb 7-1: uevent
usb 7-1: usb_probe_device
usb 7-1: configuration #1 chosen from 1 choice
usb usb5: suspend_rh (auto-stop)
usb 7-1: adding 7-1:1.0 (config #1, interface 0)
usb 7-1:1.0: uevent
usbhid 7-1:1.0: usb_probe_interface
usbhid 7-1:1.0: usb_probe_interface - got id
drivers/usb/core/file.c: looking for a minor, starting at 96
hiddev96hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-1
drivers/usb/core/inode.c: creating file '002'
usb 7-1: New USB device found, idVendor=05ac, idProduct=8242
usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-1: Product: IR Receiver
usb 7-1: Manufacturer: Apple Computer, Inc.
uhci_hcd 0000:00:1d.2: port 2 portsc 009b,00
hub 7-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1a.7: suspend root hub
usb 7-2: new full speed USB device using uhci_hcd and address 3
usb 7-2: ep0 maxpacket = 8
usb 7-2: skipped 1 descriptor after interface
usb 7-2: skipped 1 descriptor after interface
usb 7-2: skipped 1 descriptor after interface
usb 7-2: default language 0x0409
usb 7-2: uevent
usb 7-2: usb_probe_device
usb 7-2: configuration #1 chosen from 1 choice
usb 7-2: adding 7-2:1.0 (config #1, interface 0)
usb 7-2:1.0: uevent
usbhid 7-2:1.0: usb_probe_interface
usbhid 7-2:1.0: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input3
uhci_hcd 0000:00:1d.2: reserve dev 3 ep83-INT, period 8, phase 4, 17 us
input,hidraw3: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2
usb 7-2: adding 7-2:1.1 (config #1, interface 1)
usb 7-2:1.1: uevent
usbhid 7-2:1.1: usb_probe_interface
usbhid 7-2:1.1: usb_probe_interface - got id
usb 7-2: adding 7-2:1.2 (config #1, interface 2)
usb 7-2:1.2: uevent
usbhid 7-2:1.2: usb_probe_interface
usbhid 7-2:1.2: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.2/input/input4
uhci_hcd 0000:00:1d.2: reserve dev 3 ep84-INT, period 8, phase 4, 12 us
input,hidraw4: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2
drivers/usb/core/inode.c: creating file '003'
usb 7-2: New USB device found, idVendor=05ac, idProduct=021a
usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-2: Product: Apple Internal Keyboard / Trackpad
usb 7-2: Manufacturer: Apple Computer
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0x9b504000 port 0x9b504100 irq 2298
ata2: DUMMY
ata3: DUMMY
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb6: suspend_rh (auto-stop)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:8192 avtab hash slots allocated. Num of rules:171094
SELinux:8192 avtab hash slots allocated. Num of rules:171094
security:  5 users, 12 roles, 2293 types, 115 bools, 1 sens, 1024 cats
security:  72 classes, 171094 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
SELinux: policy loaded with handle_unknown=allow
type=1403 audit(1234981115.944:2): policy loaded auid=4294967295 ses=4294967295
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-1: uevent
usb 3-1:1.0: uevent
usb 3-1:1.1: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb usb6: uevent
usb 6-0:1.0: uevent
usb usb7: uevent
usb 7-0:1.0: uevent
usb 7-1: uevent
usb 7-1:1.0: uevent
usb 7-2: uevent
usb 7-2:1.0: uevent
usb 7-2:1.1: uevent
usb 7-2:1.2: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-4: uevent
usb 2-4:1.0: uevent
usb 2-4:1.1: uevent
usb 2-4:1.2: uevent
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
ACPI: Power Button (FF) [PWRF]
ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:0c:00.0 to 64
sky2 0000:0c:00.0: v1.21 addr 0x97200000 irq 17 Yukon-EC Ultra (0xb4) rev 3
sky2 eth0: addr 00:1b:63:a0:59:d6
PCI: Enabling device 0000:0b:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:0b:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:0b:00.0 to 64
ath5k_pci 0000:0b:00.0: registered as 'phy0'
ath5k phy0: Device not yet supported.
ACPI: PCI interrupt for device 0000:0b:00.0 disabled
appletouch 7-2:1.1: usb_probe_interface
appletouch 7-2:1.1: usb_probe_interface - got id
appletouch: Geyser mode initialized.
input: appletouch as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.1/input/input6
usbcore: registered new interface driver appletouch
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
Linux video capture interface: v2.00
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x6108 ctl 0x611c bmdma 0x60e0 irq 21
ata5: PATA max UDMA/100 cmd 0x6100 ctl 0x6118 bmdma 0x60e8 irq 21
iTCO_vendor_support: vendor-support=0
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: PC Speaker as /devices/platform/pcspkr/input/input7
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ACPI: Battery Slot [BAT0] (battery present)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input8
ACPI: Lid Switch [LID0]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/device:03/input/input9
ACPI: AC Adapter [ADP1] (on-line)
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input10
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input11
ACPI: Sleep Button (CM) [SLPB]
uvcvideo 2-4:1.0: usb_probe_interface
uvcvideo 2-4:1.0: usb_probe_interface - got id
uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8502)
usb 2-4: link qh4-0001/ffff81007d8e6140 start 3 [1/0 us]
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
ata4.00: ATAPI: HL-DT-ST DVDRW  GSA-S10N, AP09, max UDMA/33
ata4.00: configured for UDMA/33
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRW  GSA-S10N  AP09 PQ: 0 ANSI: 5
scsi 3:0:0:0: Attached scsi generic sg1 type 5
PCI: Enabling device 0000:00:1f.3 (0000 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 20 (level, low) -> IRQ 20
PCI: Enabling device 0000:00:1b.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA sound/pci/hda/hda_intel.c:1810: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0x1
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Surround Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Center Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave LFE Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Side Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Headphone Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Surround Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Center Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave LFE Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Side Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Headphone Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Mono Playback Switch, skipped
ACPI: PCI Interrupt 0000:0d:03.0[A] -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:0d:03.0, OHCI version 1.10
firewire_core: created device fw0: GUID 001cb3fffea2a2ae, S800
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

--------------020201000307090008070007--
