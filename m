Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYGKUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYGKUme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbYGKUmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:42:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:34886 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbYGKUmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:42:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Un7eEqo03DCsDwAtdYAvkiTxsVIw6e/AZW/RmIAp8ZhNZHP2n7mEdfoZMz8Bb0keIo
         YVOXhZZ5L365pNWIAxdaM2IRafY/69u2YN2atU5LmenSAAlwehNT9axPgj72Uo7eYCU5
         +TLphnDeVauzRgtWiMppLE2pSu1j9qdwDwudU=
Message-ID: <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
Date: Fri, 11 Jul 2008 13:42:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Cc: "Ingo Molnar" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
In-Reply-To: <20080711203151.GU1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710181634.764954000@linux-os.sc.intel.com>
	 <20080710195320.GA23322@elte.hu>
	 <20080710215617.GM1678@linux-os.sc.intel.com>
	 <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu>
	 <20080711203151.GU1678@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

got:

Linux version 2.6.26-rc9-tip-01763-g74f94b1-dirty (yhlu@linux-zpir)
(gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision
135036] (SUSE Linux) ) #320 SMP Fri Jul 11 13:35:20 PDT 2008
Command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/mydisk11_x86_64.gz rw root=/dev/ram0 debug
show_msr=1 nopat initcall_debug apic=verbose pci=routeirq ip=dhcp
load_ramdisk=1 ramdisk_size=131072
BOOT_IMAGE=kernel.org/bzImage_2.6.26_k8.h
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)....
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)......................
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)......................
 BIOS-e820: 0000000000100000 - 0000000087fe0000 (usable)........................
 BIOS-e820: 0000000087fe0000 - 0000000087fee000 (ACPI data).....................
 BIOS-e820: 0000000087fee000 - 0000000087fff2e0 (ACPI NVS)......................
 BIOS-e820: 0000000087fff2e0 - 0000000088000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000478000000 (usable)
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
Early serial console at I/O port 0x3f8 (options '115200n8')
console [uart0] enabled
PAT support disabled.
last_pfn = 0x478000 max_arch_pfn = 0x3ffffffff
last_pfn = 0x87fe0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
Using GB pages for direct mapping
 0000000000 - 0080000000 page 1G
 0080000000 - 0087e00000 page 2M
 0087e00000 - 0087fe0000 page 4k
kernel direct mapping tables up to 87fe0000 @ 8000-b000
last_map_addr: 87fe0000 end: 87fe0000
init_memory_mapping
Using GB pages for direct mapping
 0100000000 - 0440000000 page 1G
 0440000000 - 0478000000 page 2M
kernel direct mapping tables up to 478000000 @ a000-c000
last_map_addr: 478000000 end: 478000000
RAMDISK: 7e6d7000 - 7ffffe0b
DMI 2.3 present.
ACPI: RSDP 000FA740, 0024 (r2 SUN   )
ACPI: XSDT 87FE0100, 006C (r1 SUN    X6420          14 MSFT       97)
ACPI: FACP 87FE0290, 00F4 (r3 SUN    X6420          14 MSFT       97)
ACPI: DSDT 87FE0500, 876F (r1 SUN    X6420          14 INTL 20060512)
ACPI: FACS 87FEE000, 0040
ACPI: APIC 87FE0390, 00D8 (r1 SUN    X6420          14 MSFT       97)
ACPI: SPCR 87FE0470, 0050 (r1 SUN    X6420          14 MSFT       97)
ACPI: SLIT 87FE04C0, 003C (r1 SUN    X6420          14 MSFT       97)
ACPI: OEMB 87FEE040, 0063 (r1 SUN    X6420          14 MSFT       97)
ACPI: SRAT 87FE8C70, 0220 (r1 AMD    HAMMER          1 AMD         1)
ACPI: HPET 87FE8E90, 0038 (r1 SUN    X6420          14 MSFT       97)
ACPI: IPET 87FE8ED0, 0038 (r1 SUN     X6420         14 MSFT       97)
ACPI: SSDT 87FE8F10, 2854 (r1 A M I  POWERNOW        1 AMD         1)
SRAT: PXM 0 -> APIC 4 -> Node 0
SRAT: PXM 0 -> APIC 5 -> Node 0
SRAT: PXM 0 -> APIC 6 -> Node 0
SRAT: PXM 0 -> APIC 7 -> Node 0
SRAT: PXM 1 -> APIC 8 -> Node 1
SRAT: PXM 1 -> APIC 9 -> Node 1
SRAT: PXM 1 -> APIC 10 -> Node 1
SRAT: PXM 1 -> APIC 11 -> Node 1
SRAT: PXM 2 -> APIC 12 -> Node 2
SRAT: PXM 2 -> APIC 13 -> Node 2
SRAT: PXM 2 -> APIC 14 -> Node 2
SRAT: PXM 2 -> APIC 15 -> Node 2
SRAT: PXM 3 -> APIC 16 -> Node 3
SRAT: PXM 3 -> APIC 17 -> Node 3
SRAT: PXM 3 -> APIC 18 -> Node 3
SRAT: PXM 3 -> APIC 19 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
Entering add_active_range(0, 0x0, 0x9c) 0 entries of 3200 used
SRAT: Node 0 PXM 0 100000-88000000
Entering add_active_range(0, 0x100, 0x87fe0) 1 entries of 3200 used
SRAT: Node 0 PXM 0 100000000-178000000
Entering add_active_range(0, 0x100000, 0x178000) 2 entries of 3200 used
SRAT: Node 1 PXM 1 178000000-278000000
Entering add_active_range(1, 0x178000, 0x278000) 3 entries of 3200 used
SRAT: Node 2 PXM 2 278000000-378000000
Entering add_active_range(2, 0x278000, 0x378000) 4 entries of 3200 used
SRAT: Node 3 PXM 3 378000000-478000000
Entering add_active_range(3, 0x378000, 0x478000) 5 entries of 3200 used
ACPI: SLIT: nodes = 4
 10 13 13 16
 13 10 13 13
 13 13 10 13
 16 13 13 10
NUMA: Allocated memnodemap from b000 - 13f80
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000178000000
  NODE_DATA [0000000000013f80 - 0000000000018f7f]
  bootmap [0000000000019000 -  0000000000047fff] pages 2f
(9 early reservations) ==> bootmem
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00010ba6d4]    TEXT DATA BSS ==> [0000200000 - 00010ba6d4]
  #3 [007e6d7000 - 007ffffe0b]          RAMDISK ==> [007e6d7000 - 007ffffe0b]
  #4 [000009c800 - 0000100000]    BIOS reserved ==> [000009c800 - 0000100000]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #6 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
  #7 [0000001000 - 000000103c]        ACPI SLIT ==> [0000001000 - 000000103c]
  #8 [000000b000 - 0000013f80]       MEMNODEMAP ==> [000000b000 - 0000013f80]
Bootmem setup node 1 0000000178000000-0000000278000000
  NODE_DATA [0000000178000000 - 0000000178004fff]
  bootmap [0000000178005000 -  0000000178024fff] pages 20
(9 early reservations) ==> bootmem
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 00010ba6d4]    TEXT DATA BSS
  #3 [007e6d7000 - 007ffffe0b]          RAMDISK
  #4 [000009c800 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 000000b000]          PGTABLE
  #7 [0000001000 - 000000103c]        ACPI SLIT
  #8 [000000b000 - 0000013f80]       MEMNODEMAP
Bootmem setup node 2 0000000278000000-0000000378000000
  NODE_DATA [0000000278000000 - 0000000278004fff]
  bootmap [0000000278005000 -  0000000278024fff] pages 20
(9 early reservations) ==> bootmem
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 00010ba6d4]    TEXT DATA BSS
  #3 [007e6d7000 - 007ffffe0b]          RAMDISK
  #4 [000009c800 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 000000b000]          PGTABLE
  #7 [0000001000 - 000000103c]        ACPI SLIT
  #8 [000000b000 - 0000013f80]       MEMNODEMAP
Bootmem setup node 3 0000000378000000-0000000478000000
  NODE_DATA [0000000378000000 - 0000000378004fff]
  bootmap [0000000378005000 -  0000000378024fff] pages 20
(9 early reservations) ==> bootmem
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0000200000 - 00010ba6d4]    TEXT DATA BSS
  #3 [007e6d7000 - 007ffffe0b]          RAMDISK
  #4 [000009c800 - 0000100000]    BIOS reserved
  #5 [0000008000 - 000000a000]          PGTABLE
  #6 [000000a000 - 000000b000]          PGTABLE
  #7 [0000001000 - 000000103c]        ACPI SLIT
  #8 [000000b000 - 0000013f80]       MEMNODEMAP
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000ff780] 000ff780
 [ffffe20000000000-ffffe27fffffffff] PGD ->ffff8800011bd000 on node 0
 [ffffe20000000000-ffffe2003fffffff] PUD ->ffff8800011be000 on node 0
[ffffe20005240000-ffffe200053fffff] potential offnode page_structs
 [ffffe20000000000-ffffe200053fffff] PMD ->
[ffff880001200000-ffff880004bfffff] on node 0
[ffffe20008a40000-ffffe20008bfffff] potential offnode page_structs
 [ffffe20005400000-ffffe20008bfffff] PMD ->
[ffff880178200000-ffff88017b9fffff] on node 1
[ffffe2000c240000-ffffe2000c3fffff] potential offnode page_structs
 [ffffe20008c00000-ffffe2000c3fffff] PMD ->
[ffff880278200000-ffff88027b9fffff] on node 2
 [ffffe2000c400000-ffffe2000fbfffff] PMD ->
[ffff880378200000-ffff88037b9fffff] on node 3
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00478000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x0000009c
    0: 0x00000100 -> 0x00087fe0
    0: 0x00100000 -> 0x00178000
    1: 0x00178000 -> 0x00278000
    2: 0x00278000 -> 0x00378000
    3: 0x00378000 -> 0x00478000
On node 0 totalpages: 1048444
  DMA zone: 56 pages used for memmap
  DMA zone: 115 pages reserved
  DMA zone: 3825 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 538648 pages, LIFO batch:31
  Normal zone: 6720 pages used for memmap
  Normal zone: 484800 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 1 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 2 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
On node 3 totalpages: 1048576
  DMA zone: 0 pages used for memmap
  DMA32 zone: 0 pages used for memmap
  Normal zone: 14336 pages used for memmap
  Normal zone: 1034240 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x13] enabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x01] address[0xbdeff000] gsi_base[24])
IOAPIC[1]: apic_id 1, version 0, address 0xbdeff000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x0 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 16 CPUs, 0 hotplug CPUs
init_cpu_to_node:
cpu 0 -> apicid 4 -> node 0
cpu 1 -> apicid 5 -> node 0
cpu 2 -> apicid 6 -> node 0
cpu 3 -> apicid 7 -> node 0
cpu 4 -> apicid 8 -> node 1
cpu 5 -> apicid 9 -> node 1
cpu 6 -> apicid 10 -> node 1
cpu 7 -> apicid 11 -> node 1
cpu 8 -> apicid 12 -> node 2
cpu 9 -> apicid 13 -> node 2
cpu 10 -> apicid 14 -> node 2
cpu 11 -> apicid 15 -> node 2
cpu 12 -> apicid 16 -> node 3
cpu 13 -> apicid 17 -> node 3
cpu 14 -> apicid 18 -> node 3
cpu 15 -> apicid 19 -> node 3
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
mapped IOAPIC to ffffffffff5f9000 (00000000bdeff000)
Allocating PCI resources starting at 90000000 (gap: 88000000:76c00000)
PERCPU: Allocating 53312 bytes of per cpu data
per cpu data for cpu0 on node0 at 00000000010e4000
per cpu data for cpu1 on node0 at 00000000010f2000
per cpu data for cpu2 on node0 at 0000000001100000
per cpu data for cpu3 on node0 at 000000000110e000
per cpu data for cpu4 on node1 at 000000017ba18000
per cpu data for cpu5 on node1 at 000000017ba26000
per cpu data for cpu6 on node1 at 000000017ba34000
per cpu data for cpu7 on node1 at 000000017ba42000
per cpu data for cpu8 on node2 at 000000027ba18000
per cpu data for cpu9 on node2 at 000000027ba26000
per cpu data for cpu10 on node2 at 000000027ba34000
per cpu data for cpu11 on node2 at 000000027ba42000
per cpu data for cpu12 on node3 at 000000037ba18000
per cpu data for cpu13 on node3 at 000000037ba26000
per cpu data for cpu14 on node3 at 000000037ba34000
per cpu data for cpu15 on node3 at 000000037ba42000
NR_CPUS: 128, nr_cpu_ids: 16, nr_node_ids 4
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 4129993
Policy zone: Normal
Kernel command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/mydisk11_x86_64.gz rw root=/dev/ram0 debug
show_msr=1 nopat initcall_debug apic=verbose pci=routeirq ip=dhcp
load_ramdisk=1 ramdisk_size=131072
BOOT_IMAGE=kernel.org/bzImage_2.6.26_k8.h
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 2293.903 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console handover: boot [uart0] -> real [ttyS0]
Checking aperture...
No AGP bridge found
Node 0: aperture @ a21c000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
numa_free_all_bootmem node 0 done
numa_free_all_bootmem node 1 done
numa_free_all_bootmem node 2 done
numa_free_all_bootmem node 3 done
Memory: 16437296k/18743296k available (8383k kernel code, 339392k
reserved, 4020k data, 988k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=4
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer
frequency.. <6>4587.80 BogoMIPS (lpj=9175600)
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/4 -> Node 0
Enable MMCONFIG on AMD Family 10h
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 1289 Objects with 114 Devices 462 Methods 26 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 80 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
Setting APIC routing to physical flat
Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (0 vs 4)
Pid: 1, comm: swapper Not tainted 2.6.26-rc9-tip-01763-g74f94b1-dirty #320

Call Trace:
 [<ffffffff80a21505>] ? set_cpu_sibling_map+0x38c/0x3bd
 [<ffffffff80245215>] ? read_xapic_id+0x25/0x3e
 [<ffffffff80e5a2c3>] ? verify_local_APIC+0x139/0x1b9
 [<ffffffff80245215>] ? read_xapic_id+0x25/0x3e
 [<ffffffff80e589af>] ? native_smp_prepare_cpus+0x224/0x2e9
 [<ffffffff80e4881a>] ? kernel_init+0x64/0x341
 [<ffffffff8022a439>] ? child_rip+0xa/0x11
 [<ffffffff80e487b6>] ? kernel_init+0x0/0x341
 [<ffffffff8022a42f>] ? child_rip+0x0/0x11


guess read_apic_id changing cuase some problem...

YH
