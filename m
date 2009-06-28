Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZF1Wbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZF1Wbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZF1Wbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:31:31 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:44072 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZF1Wb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:31:29 -0400
Date: Sun, 28 Jun 2009 18:31:32 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090628223132.GO20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J19t2I20ndwispKK"
Content-Disposition: inline
In-Reply-To: <86802c440906272126s7d3b97afh16069280bd297827@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 18:29:05 up 17 days, 19:56, 23 users,  load average: 0.00, 0.05,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J19t2I20ndwispKK
Content-Type: multipart/mixed; boundary="4TjKedF+bau4YbxU"
Content-Disposition: inline


--4TjKedF+bau4YbxU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Yinghai,

* Yinghai Lu (yhlu.kernel@gmail.com) wrote:
> try 2.6.30

dmesg from 2.6.30 (w/ pci=noapic noapic) attached.  Box didn't boot
again, but we did get a "hung process" message from the kernel after a
while.  I don't have more info than that about the boot w/o pci=noapic
noapic, sorry.  I can try and get that info at another time if this
isn't enough.

	Thanks,

		Stephen

--4TjKedF+bau4YbxU
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg-no-apic-2.6.30"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-1-amd64 (Debian 2.6.30-1) (waldi@debian=
=2Eorg) (gcc version 4.3.3 (Debian 4.3.3-10) ) #1 SMP Sun Jun 14 15:00:29 U=
TC 2009
[    0.000000] Command line: root=3D/dev/cciss/c0d0p1 ro pci=3Dnoapic noapi=
c=20
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe4e000 (usable)
[    0.000000]  BIOS-e820: 000000007fe4e000 - 000000007fe56000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fe56000 - 000000007fe57000 (usable)
[    0.000000]  BIOS-e820: 000000007fe57000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000047ffff000 (usable)
[    0.000000] PCI: Unknown option `noapic'
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn =3D 0x47ffff max_arch_pfn =3D 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000480000000 aka 18432M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 0000000080000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x7fe57 max_arch_pfn =3D 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007fe57000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007fe57000 page 4k
[    0.000000] kernel direct mapping tables up to 7fe57000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000047ffff000
[    0.000000]  0100000000 - 047fe00000 page 2M
[    0.000000]  047fe00000 - 047ffff000 page 4k
[    0.000000] kernel direct mapping tables up to 47ffff000 @ a000-1e000
[    0.000000] RAMDISK: 3772d000 - 37fef723
[    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000007fe4ed00 00074 (v01 HP     ProLiant 00000=
002   =D2=04 0000162E)
[    0.000000] ACPI: FACP 000000007fe4ed80 000F4 (v03 HP     A07      00000=
002   =D2=04 0000162E)
[    0.000000] ACPI: DSDT 000000007fe4ee80 0498A (v01 HP         DSDT 00000=
001 INTL 20030228)
[    0.000000] ACPI: FACS 000000007fe4e100 00040
[    0.000000] ACPI: SPCR 000000007fe4e140 00050 (v01 HP     SPCRRBSU 00000=
001   =D2=04 0000162E)
[    0.000000] ACPI: HPET 000000007fe4e1c0 00038 (v01 HP     ProLiant 00000=
002   =D2=04 0000162E)
[    0.000000] ACPI: SPMI 000000007fe4e200 00040 (v05 HP     ProLiant 00000=
001   =D2=04 0000162E)
[    0.000000] ACPI: ERST 000000007fe4e240 001D0 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)
[    0.000000] ACPI: APIC 000000007fe4e440 000C6 (v01 HP     ProLiant 00000=
002      00000000)
[    0.000000] ACPI: SRAT 000000007fe4e580 001A0 (v01 AMD    FAM_F_10 00000=
002 AMD  00000001)
[    0.000000] ACPI: FFFF 000000007fe4e980 00176 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)
[    0.000000] ACPI: BERT 000000007fe4eb00 00030 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)
[    0.000000] ACPI: HEST 000000007fe4eb40 00170 (v01 HP     ProLiant 00000=
001   =D2=04 0000162E)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 4 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 5 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 6 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 7 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-80000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-180000000
[    0.000000] SRAT: Node 1 PXM 1 180000000-280000000
[    0.000000] SRAT: Node 2 PXM 2 280000000-380000000
[    0.000000] SRAT: Node 3 PXM 3 380000000-480000000
[    0.000000] NUMA: Allocated memnodemap from 19000 - 22040
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-0000000180000000
[    0.000000]   NODE_DATA [0000000000022040 - 000000000002a03f]
[    0.000000]   bootmap [000000000002b000 -  000000000005afff] pages 30
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 0180000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00007d98cc]
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK =3D=3D> [003=
772d000 - 0037fef723]
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000=
009f400 - 0000100000]
[    0.000000]   #5 [00007da000 - 00007da114]              BRK =3D=3D> [000=
07da000 - 00007da114]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE =3D=3D> [000=
000a000 - 0000019000]
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP =3D=3D> [000=
0019000 - 0000022040]
[    0.000000] Bootmem setup node 1 0000000180000000-0000000280000000
[    0.000000]   NODE_DATA [0000000180000000 - 0000000180007fff]
[    0.000000]   bootmap [0000000180008000 -  0000000180027fff] pages 20
[    0.000000] (9 early reservations) =3D=3D> bootmem [0180000000 - 0280000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved
[    0.000000]   #5 [00007da000 - 00007da114]              BRK
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP
[    0.000000] Bootmem setup node 2 0000000280000000-0000000380000000
[    0.000000]   NODE_DATA [0000000280000000 - 0000000280007fff]
[    0.000000]   bootmap [0000000280008000 -  0000000280027fff] pages 20
[    0.000000] (9 early reservations) =3D=3D> bootmem [0280000000 - 0380000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved
[    0.000000]   #5 [00007da000 - 00007da114]              BRK
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP
[    0.000000] Bootmem setup node 3 0000000380000000-000000047ffff000
[    0.000000]   NODE_DATA [0000000380000000 - 0000000380007fff]
[    0.000000]   bootmap [0000000380008000 -  0000000380027fff] pages 20
[    0.000000] (9 early reservations) =3D=3D> bootmem [0380000000 - 047ffff=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
[    0.000000]   #2 [0000200000 - 00007d98cc]    TEXT DATA BSS
[    0.000000]   #3 [003772d000 - 0037fef723]          RAMDISK
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved
[    0.000000]   #5 [00007da000 - 00007da114]              BRK
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE
[    0.000000]   #7 [000000a000 - 0000019000]          PGTABLE
[    0.000000]   #8 [0000019000 - 0000022040]       MEMNODEMAP
[    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
[    0.000000]  [ffffe20000000000-ffffe200053fffff] PMD -> [ffff88002820000=
0-ffff88002b9fffff] on node 0
[    0.000000]  [ffffe20005400000-ffffe20008bfffff] PMD -> [ffff88018020000=
0-ffff8801839fffff] on node 1
[    0.000000]  [ffffe20008c00000-ffffe2000c3fffff] PMD -> [ffff88028020000=
0-ffff8802839fffff] on node 2
[    0.000000]  [ffffe2000c400000-ffffe2000fbfffff] PMD -> [ffff88038020000=
0-ffff8803839fffff] on node 3
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0047ffff
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fe4e
[    0.000000]     0: 0x0007fe56 -> 0x0007fe57
[    0.000000]     0: 0x00100000 -> 0x00180000
[    0.000000]     1: 0x00180000 -> 0x00280000
[    0.000000]     2: 0x00280000 -> 0x00380000
[    0.000000]     3: 0x00380000 -> 0x0047ffff
[    0.000000] On node 0 totalpages: 1048046
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1622 pages reserved
[    0.000000]   DMA zone: 2321 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 505479 pages, LIFO batch:31
[    0.000000]   Normal zone: 7168 pages used for memmap
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034240 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048575
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1034239 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: Skipping IOAPIC probe due to 'noapic' option.
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000] MPTABLE: OEM ID: HP     =20
[    0.000000] MPTABLE: Product ID: PROLIANT   =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] I/O APIC #8 Version 32 at 0xD9CF0000.
[    0.000000] I/O APIC #9 Version 32 at 0xD9FD0000.
[    0.000000] I/O APIC #10 Version 32 at 0xD9FE0000.
[    0.000000] Processors: 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 38
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 000000007fe4e000 - 000000007fe=
56000
[    0.000000] PM: Registered nosave memory: 000000007fe57000 - 00000000800=
00000
[    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000e00=
00000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f00=
00000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec=
00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed=
00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fee=
00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee=
10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffc=
00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000=
:60000000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:4
[    0.000000] PERCPU: Allocated 19 4k pages, static data 76256 bytes
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4127639
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/cciss/c0d0p1 ro pci=3Dnoapi=
c noapic=20
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:710
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2812.754 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 20000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 00000000240=
00000
[    0.004000] Memory: 16463800k/18874364k available (2782k kernel code, 20=
99272k absent, 311292k reserved, 1398k data, 560k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5625.50 BogoMIPS (lpj=3D11251016)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.014472] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.020421] Mount-cache hash table entries: 256
[    0.020747] Initializing cgroup subsys ns
[    0.020811] Initializing cgroup subsys cpuacct
[    0.020876] Initializing cgroup subsys devices
[    0.020939] Initializing cgroup subsys freezer
[    0.021002] Initializing cgroup subsys net_cls
[    0.021117] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.021189] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.021253] CPU 0/0x0 -> Node 0
[    0.021312] tseg: 0000000000
[    0.021325] CPU: Physical Processor ID: 0
[    0.021386] CPU: Processor Core ID: 0
[    0.021454] using C1E aware idle routine
[    0.022097] ACPI: Core revision 20090320
[    0.030314] ACPI: setting ELCR to 0200 (from 8c20)
[    0.030604] Setting APIC routing to flat
[    0.030670] CPU0: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.032001] Booting processor 1 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5625.90 Bog=
oMIPS (lpj=3D11251814)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 1/0x2 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.116602] CPU1: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.117461] Booting processor 2 APIC 0x4 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5625.85 Bog=
oMIPS (lpj=3D11251703)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 2/0x4 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x701060007=
0106
[    0.208627] CPU2: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.209509] Booting processor 3 APIC 0x6 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5625.88 Bog=
oMIPS (lpj=3D11251771)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 3/0x6 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x701060007=
0106
[    0.300702] CPU3: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.301486] Booting processor 4 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#4
[    0.004000] Calibrating delay using timer specific routine.. 5625.92 Bog=
oMIPS (lpj=3D11251846)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 4/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x701060007=
0106
[    0.392533] CPU4: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.393375] Booting processor 5 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#5
[    0.004000] Calibrating delay using timer specific routine.. 5625.85 Bog=
oMIPS (lpj=3D11251704)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 5/0x3 -> Node 1
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x701060007=
0106
[    0.484620] CPU5: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.485462] Booting processor 6 APIC 0x5 ip 0x6000
[    0.004000] Initializing CPU#6
[    0.004000] Calibrating delay using timer specific routine.. 5625.84 Bog=
oMIPS (lpj=3D11251693)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 6/0x5 -> Node 2
[    0.004000] CPU: Physical Processor ID: 2
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x701060007=
0106
[    0.576609] CPU6: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.577468] Booting processor 7 APIC 0x7 ip 0x6000
[    0.004000] Initializing CPU#7
[    0.004000] Calibrating delay using timer specific routine.. 5625.91 Bog=
oMIPS (lpj=3D11251837)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004000] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.004000] CPU 7/0x7 -> Node 3
[    0.004000] CPU: Physical Processor ID: 3
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x701060007=
0106
[    0.668713] CPU7: Dual-Core AMD Opteron(tm) Processor 8220 stepping 03
[    0.669370] Brought up 8 CPUs
[    0.669429] Total of 8 processors activated (45006.69 BogoMIPS).
[    0.669610] CPU0 attaching sched-domain:
[    0.669612]  domain 0: span 0,4 level CPU
[    0.669614]   groups: 0 4
[    0.669618]   domain 1: span 0-7 level NODE
[    0.669620]    groups: 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2=
048) 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2048)
[    0.669628] CPU1 attaching sched-domain:
[    0.669630]  domain 0: span 1,5 level CPU
[    0.669632]   groups: 1 5
[    0.669635]   domain 1: span 0-7 level NODE
[    0.669636]    groups: 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2=
048) 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2048)
[    0.669644] CPU2 attaching sched-domain:
[    0.669646]  domain 0: span 2,6 level CPU
[    0.669648]   groups: 2 6
[    0.669651]   domain 1: span 0-7 level NODE
[    0.669652]    groups: 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2=
048) 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2048)
[    0.669660] CPU3 attaching sched-domain:
[    0.669662]  domain 0: span 3,7 level CPU
[    0.669663]   groups: 3 7
[    0.669666]   domain 1: span 0-7 level NODE
[    0.669668]    groups: 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2=
048) 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2048)
[    0.669676] CPU4 attaching sched-domain:
[    0.669678]  domain 0: span 0,4 level CPU
[    0.669679]   groups: 4 0
[    0.669682]   domain 1: span 0-7 level NODE
[    0.669684]    groups: 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2=
048) 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2048)
[    0.669692] CPU5 attaching sched-domain:
[    0.669693]  domain 0: span 1,5 level CPU
[    0.669695]   groups: 5 1
[    0.669698]   domain 1: span 0-7 level NODE
[    0.669700]    groups: 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2=
048) 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2048)
[    0.669707] CPU6 attaching sched-domain:
[    0.669709]  domain 0: span 2,6 level CPU
[    0.669711]   groups: 6 2
[    0.669714]   domain 1: span 0-7 level NODE
[    0.669715]    groups: 2,6 (__cpu_power =3D 2048) 3,7 (__cpu_power =3D 2=
048) 0,4 (__cpu_power =3D 2048) 1,5 (__cpu_power =3D 2048)
[    0.669723] CPU7 attaching sched-domain:
[    0.669725]  domain 0: span 3,7 level CPU
[    0.669727]   groups: 7 3
[    0.669730]   domain 1: span 0-7 level NODE
[    0.669731]    groups: 3,7 (__cpu_power =3D 2048) 0,4 (__cpu_power =3D 2=
048) 1,5 (__cpu_power =3D 2048) 2,6 (__cpu_power =3D 2048)
[    0.669940] net_namespace: 1936 bytes
[    0.669940] Booting paravirtualized kernel on bare hardware
[    0.669940] regulator: core version 0.5
[    0.669940] NET: Registered protocol family 16
[    0.669940] node 0 link 1: io port [1000, 2fff]
[    0.669940] node 1 link 2: io port [3000, ffff]
[    0.669940] TOM: 0000000080000000 aka 2048M
[    0.669940] node 0 link 1: mmio [d0000000, d9efffff]
[    0.669940] node 1 link 2: mmio [d9f00000, dfefffff]
[    0.669940] node 0 link 1: mmio [e0000000, e3ffffff]
[    0.669940] node 1 link 2: mmio [e4000000, e7ffffff]
[    0.669940] node 0 link 1: mmio [a0000, bffff]
[    0.669940] TOM2: 0000000480000000 aka 18432M
[    0.669940] bus: [00,3f] on node 0 link 1
[    0.669940] bus: 00 index 0 io port: [0, 2fff]
[    0.669940] bus: 00 index 1 mmio: [80000000, d9efffff]
[    0.669940] bus: 00 index 2 mmio: [dff00000, e3ffffff]
[    0.669940] bus: 00 index 3 mmio: [a0000, bffff]
[    0.669940] bus: 00 index 4 mmio: [e8000000, ffffffff]
[    0.669940] bus: 00 index 5 mmio: [480000000, fcffffffff]
[    0.669940] bus: [40,7f] on node 1 link 2
[    0.669940] bus: 40 index 0 io port: [3000, ffff]
[    0.669940] bus: 40 index 1 mmio: [d9f00000, dfefffff]
[    0.669940] bus: 40 index 2 mmio: [e4000000, e7ffffff]
[    0.669940] ACPI: bus type pci registered
[    0.672026] PCI: Using configuration type 1 for base access
[    0.672074] PCI: HP ProLiant DL585 G2 detected, enabling pci=3Dbfsort.
[    0.672266] bio: create slab <bio-0> at 0
[    0.672384] ACPI: EC: Look up EC in DSDT
[    0.680244] ACPI: SSDT 000000007fe58000 00AC4 (v02 HP     PNOWSSDT 00000=
002 HP   00000001)
[    0.680949] ACPI: Interpreter enabled
[    0.681010] ACPI: (supports S0 S4 S5)
[    0.681164] ACPI: Using PIC for interrupt routing
[    0.688194] ACPI: No dock devices found.
[    0.688249] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.688327] pci 0000:00:02.0: reg 10 32bit mmio: [0xd9ce0000-0xd9ce0fff]
[    0.688327] pci 0000:00:02.0: supports D1 D2
[    0.688327] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.688327] pci 0000:00:02.0: PME# disabled
[    0.688327] pci 0000:00:02.1: reg 10 32bit mmio: [0xd9cd0000-0xd9cd00ff]
[    0.688327] pci 0000:00:02.1: supports D1 D2
[    0.688327] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.688327] pci 0000:00:02.1: PME# disabled
[    0.688331] pci 0000:00:06.0: reg 20 io port: [0x500-0x50f]
[    0.688370] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.688415] pci 0000:00:0c.0: PME# disabled
[    0.688476] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.688522] pci 0000:00:0d.0: PME# disabled
[    0.688581] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.688626] pci 0000:00:0e.0: PME# disabled
[    0.688906] pci 0000:01:03.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    0.688911] pci 0000:01:03.0: reg 14 io port: [0x1000-0x10ff]
[    0.688916] pci 0000:01:03.0: reg 18 32bit mmio: [0xd9ef0000-0xd9efffff]
[    0.688930] pci 0000:01:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.688942] pci 0000:01:03.0: supports D1 D2
[    0.688965] pci 0000:01:04.0: reg 10 io port: [0x2800-0x28ff]
[    0.688970] pci 0000:01:04.0: reg 14 32bit mmio: [0xd9ee0000-0xd9ee01ff]
[    0.688996] pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
[    0.689066] pci 0000:01:04.0: PME# disabled
[    0.689154] pci 0000:01:04.2: reg 10 io port: [0x1400-0x14ff]
[    0.689160] pci 0000:01:04.2: reg 14 32bit mmio: [0xd9ed0000-0xd9ed07ff]
[    0.689165] pci 0000:01:04.2: reg 18 32bit mmio: [0xd9ec0000-0xd9ec3fff]
[    0.689171] pci 0000:01:04.2: reg 1c 32bit mmio: [0xd9e00000-0xd9e7ffff]
[    0.689183] pci 0000:01:04.2: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.689197] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    0.689267] pci 0000:01:04.2: PME# disabled
[    0.689368] pci 0000:01:04.4: reg 20 io port: [0x1800-0x181f]
[    0.689389] pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
[    0.689459] pci 0000:01:04.4: PME# disabled
[    0.689543] pci 0000:01:04.6: reg 10 32bit mmio: [0xd9df0000-0xd9df00ff]
[    0.689571] pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
[    0.689640] pci 0000:01:04.6: PME# disabled
[    0.689728] pci 0000:00:09.0: transparent bridge
[    0.689792] pci 0000:00:09.0: bridge io port: [0x1000-0x2fff]
[    0.689794] pci 0000:00:09.0: bridge 32bit mmio: [0xd9d00000-0xd9efffff]
[    0.689797] pci 0000:00:09.0: bridge 32bit mmio pref: [0xd0000000-0xd7ff=
ffff]
[    0.689900] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.689980] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    0.690088] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
[    0.690189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
[    0.690290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
[    0.692195] ACPI: PCI Root Bridge [PCI1] (0000:40)
[    0.692294] pci 0000:40:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.692294] pci 0000:40:0b.0: PME# disabled
[    0.692294] pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.692357] pci 0000:40:0c.0: PME# disabled
[    0.692450] pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.692521] pci 0000:40:0d.0: PME# disabled
[    0.692613] pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.692684] pci 0000:40:0e.0: PME# disabled
[    0.692781] pci 0000:40:10.0: Enabling HT MSI Mapping
[    0.696067] pci 0000:40:11.0: Enabling HT MSI Mapping
[    0.696330] pci 0000:41:01.0: reg 10 64bit mmio: [0xdc000000-0xddffffff]
[    0.696343] pci 0000:41:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.696356] pci 0000:41:01.0: PME# supported from D3hot D3cold
[    0.696425] pci 0000:41:01.0: PME# disabled
[    0.696512] pci 0000:41:02.0: reg 10 64bit mmio: [0xda000000-0xdbffffff]
[    0.696525] pci 0000:41:02.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.696538] pci 0000:41:02.0: PME# supported from D3hot D3cold
[    0.696607] pci 0000:41:02.0: PME# disabled
[    0.696692] pci 0000:40:10.0: bridge 32bit mmio: [0xda000000-0xddffffff]
[    0.696723] pci 0000:42:02.0: reg 10 64bit mmio: [0xdfef0000-0xdfef1fff]
[    0.696727] pci 0000:42:02.0: reg 18 io port: [0x3000-0x30ff]
[    0.696733] pci 0000:42:02.0: reg 1c 64bit mmio: [0xdfe80000-0xdfebffff]
[    0.696740] pci 0000:42:02.0: reg 30 32bit mmio: [0x000000-0x03ffff]
[    0.696753] pci 0000:42:02.0: supports D1
[    0.696776] pci 0000:40:11.0: bridge io port: [0x3000-0x3fff]
[    0.696779] pci 0000:40:11.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]
[    0.696798] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
[    0.696871] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
[    0.697061] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
[    0.697172] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
[    0.697287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
[    0.697392] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
[    0.697626] ACPI: PCI Interrupt Link [LNKW] (IRQs 5 7 10 11) *0, disable=
d.
[    0.700166] ACPI: PCI Interrupt Link [LNKX] (IRQs 5 7 10 11) *0, disable=
d.
[    0.704167] ACPI: PCI Interrupt Link [LNKY] (IRQs 5 7 10 11) *0, disable=
d.
[    0.704580] ACPI: PCI Interrupt Link [LNKZ] (IRQs 5 7 10 11) *0, disable=
d.
[    0.704995] ACPI: PCI Interrupt Link [LNU0] (IRQs *5 7 10 11)
[    0.705360] ACPI: PCI Interrupt Link [LNU2] (IRQs 5 7 10 *11)
[    0.708280] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 7 10 11) *0, disable=
d.
[    0.708695] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 11) *0, disable=
d.
[    0.709112] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 7 10 11) *0, disable=
d.
[    0.709526] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 10 11) *0, disable=
d.
[    0.709823] usbcore: registered new interface driver usbfs
[    0.709823] usbcore: registered new interface driver hub
[    0.709823] usbcore: registered new device driver usb
[    0.709823] PCI: Using ACPI for IRQ routing
[    0.709823] Expanded resource reserved due to conflict with PCI Bus #00
[    0.709823] Expanded resource reserved due to conflict with PCI Bus #00
[    0.724118] PCI-DMA: Disabling AGP.
[    0.724292] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.724292] PCI-DMA: using GART IOMMU.
[    0.724292] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.724831] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.724993] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.744012] Switched to high resolution mode on CPU 0
[    0.744506] Switched to high resolution mode on CPU 4
[    0.744592] Switched to high resolution mode on CPU 2
[    0.744597] Switched to high resolution mode on CPU 6
[    0.744613] Switched to high resolution mode on CPU 1
[    0.744620] Switched to high resolution mode on CPU 5
[    0.744723] Switched to high resolution mode on CPU 3
[    0.744733] Switched to high resolution mode on CPU 7
[    0.756010] pnp: PnP ACPI init
[    0.756089] ACPI: bus type pnp registered
[    0.761634] pnp: PnP ACPI: found 16 devices
[    0.761697] ACPI: ACPI bus type pnp unregistered
[    0.761773] system 00:01: ioport range 0x408-0x40f has been reserved
[    0.761844] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.761914] system 00:01: ioport range 0x700-0x73f has been reserved
[    0.761985] system 00:01: ioport range 0x800-0x8fe has been reserved
[    0.762055] system 00:01: ioport range 0x900-0x9fe has been reserved
[    0.762125] system 00:01: ioport range 0x9ff-0x9ff has been reserved
[    0.762195] system 00:01: ioport range 0xa00-0xafe has been reserved
[    0.762266] system 00:01: ioport range 0xaff-0xaff has been reserved
[    0.762336] system 00:01: ioport range 0xb00-0xbfe has been reserved
[    0.762406] system 00:01: ioport range 0xbff-0xbff has been reserved
[    0.762476] system 00:01: ioport range 0xc80-0xc83 has been reserved
[    0.762547] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
[    0.762617] system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
[    0.762689] system 00:01: ioport range 0xf50-0xf58 has been reserved
[    0.762759] system 00:01: ioport range 0xca0-0xca1 has been reserved
[    0.762830] system 00:01: ioport range 0xca4-0xca5 has been reserved
[    0.762900] system 00:01: ioport range 0xc00-0xc03 has been reserved
[    0.762970] system 00:01: ioport range 0x2f8-0x2ff has been reserved
[    0.768472] pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
[    0.768541] pci 0000:00:09.0:   IO window: 0x1000-0x2fff
[    0.768608] pci 0000:00:09.0:   MEM window: 0xd9d00000-0xd9efffff
[    0.768678] pci 0000:00:09.0:   PREFETCH window: 0x000000d0000000-0x0000=
00d7ffffff
[    0.768777] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:08
[    0.768845] pci 0000:00:0c.0:   IO window: disabled
[    0.768910] pci 0000:00:0c.0:   MEM window: disabled
[    0.768975] pci 0000:00:0c.0:   PREFETCH window: disabled
[    0.769042] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
[    0.769110] pci 0000:00:0d.0:   IO window: disabled
[    0.769175] pci 0000:00:0d.0:   MEM window: disabled
[    0.769240] pci 0000:00:0d.0:   PREFETCH window: disabled
[    0.769309] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
[    0.769376] pci 0000:00:0e.0:   IO window: disabled
[    0.769441] pci 0000:00:0e.0:   MEM window: disabled
[    0.769509] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.769581] pci 0000:00:09.0: setting latency timer to 64
[    0.769585] pci 0000:00:0c.0: setting latency timer to 64
[    0.769588] pci 0000:00:0d.0: setting latency timer to 64
[    0.769591] pci 0000:00:0e.0: setting latency timer to 64
[    0.769597] pci 0000:40:0b.0: PCI bridge, secondary bus 0000:4f
[    0.769665] pci 0000:40:0b.0:   IO window: disabled
[    0.769731] pci 0000:40:0b.0:   MEM window: disabled
[    0.769796] pci 0000:40:0b.0:   PREFETCH window: disabled
[    0.769864] pci 0000:40:0c.0: PCI bridge, secondary bus 0000:4c
[    0.769932] pci 0000:40:0c.0:   IO window: disabled
[    0.769997] pci 0000:40:0c.0:   MEM window: disabled
[    0.770062] pci 0000:40:0c.0:   PREFETCH window: disabled
[    0.770130] pci 0000:40:0d.0: PCI bridge, secondary bus 0000:49
[    0.770198] pci 0000:40:0d.0:   IO window: disabled
[    0.770263] pci 0000:40:0d.0:   MEM window: disabled
[    0.770328] pci 0000:40:0d.0:   PREFETCH window: disabled
[    0.770396] pci 0000:40:0e.0: PCI bridge, secondary bus 0000:46
[    0.770464] pci 0000:40:0e.0:   IO window: disabled
[    0.770529] pci 0000:40:0e.0:   MEM window: disabled
[    0.770594] pci 0000:40:0e.0:   PREFETCH window: disabled
[    0.770663] pci 0000:40:10.0: PCI bridge, secondary bus 0000:41
[    0.770731] pci 0000:40:10.0:   IO window: disabled
[    0.770797] pci 0000:40:10.0:   MEM window: 0xda000000-0xddffffff
[    0.770866] pci 0000:40:10.0:   PREFETCH window: 0x000000d9f00000-0x0000=
00d9ffffff
[    0.770967] pci 0000:40:11.0: PCI bridge, secondary bus 0000:42
[    0.771036] pci 0000:40:11.0:   IO window: 0x3000-0x3fff
[    0.771103] pci 0000:40:11.0:   MEM window: 0xdfe00000-0xdfefffff
[    0.771173] pci 0000:40:11.0:   PREFETCH window: 0x000000de000000-0x0000=
00de0fffff
[    0.771275] pci 0000:40:0b.0: setting latency timer to 64
[    0.771279] pci 0000:40:0c.0: setting latency timer to 64
[    0.771283] pci 0000:40:0d.0: setting latency timer to 64
[    0.771288] pci 0000:40:0e.0: setting latency timer to 64
[    0.771294] pci_bus 0000:00: resource 0 io:  [0x00-0x2fff]
[    0.771296] pci_bus 0000:00: resource 1 mem: [0x80000000-0xd9efffff]
[    0.771299] pci_bus 0000:00: resource 2 mem: [0xdff00000-0xe3ffffff]
[    0.771301] pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
[    0.771303] pci_bus 0000:00: resource 4 mem: [0xe8000000-0xffffffff]
[    0.771305] pci_bus 0000:00: resource 5 mem: [0x480000000-0xfcffffffff]
[    0.771307] pci_bus 0000:01: resource 0 io:  [0x1000-0x2fff]
[    0.771309] pci_bus 0000:01: resource 1 mem: [0xd9d00000-0xd9efffff]
[    0.771311] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    0.771313] pci_bus 0000:01: resource 3 io:  [0x00-0x2fff]
[    0.771315] pci_bus 0000:01: resource 4 mem: [0x80000000-0xd9efffff]
[    0.771317] pci_bus 0000:01: resource 5 mem: [0xdff00000-0xe3ffffff]
[    0.771319] pci_bus 0000:01: resource 6 mem: [0x0a0000-0x0bffff]
[    0.771321] pci_bus 0000:01: resource 7 mem: [0xe8000000-0xffffffff]
[    0.771323] pci_bus 0000:01: resource 8 mem: [0x480000000-0xfcffffffff]
[    0.771326] pci_bus 0000:40: resource 0 io:  [0x3000-0xffff]
[    0.771328] pci_bus 0000:40: resource 1 mem: [0xd9f00000-0xdfefffff]
[    0.771330] pci_bus 0000:40: resource 2 mem: [0xe4000000-0xe7ffffff]
[    0.771333] pci_bus 0000:41: resource 1 mem: [0xda000000-0xddffffff]
[    0.771335] pci_bus 0000:41: resource 2 pref mem [0xd9f00000-0xd9ffffff]
[    0.771337] pci_bus 0000:42: resource 0 io:  [0x3000-0x3fff]
[    0.771339] pci_bus 0000:42: resource 1 mem: [0xdfe00000-0xdfefffff]
[    0.771341] pci_bus 0000:42: resource 2 pref mem [0xde000000-0xde0fffff]
[    0.771558] NET: Registered protocol family 2
[    0.824548] IP route cache hash table entries: 524288 (order: 10, 419430=
4 bytes)
[    0.828927] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.834765] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.835482] TCP: Hash tables configured (established 524288 bind 65536)
[    0.835554] TCP reno registered
[    0.856271] NET: Registered protocol family 1
[    0.856412] Trying to unpack rootfs image as initramfs...
[    1.114138] Freeing initrd memory: 8969k freed
[    1.122618] audit: initializing netlink socket (disabled)
[    1.122702] type=3D2000 audit(1246228060.120:1): initialized
[    1.124178] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.124695] VFS: Disk quotas dquot_6.5.2
[    1.124817] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.124985] msgmni has been set to 32173
[    1.125420] alg: No test for stdrng (krng)
[    1.125596] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    1.125696] io scheduler noop registered
[    1.125760] io scheduler anticipatory registered
[    1.125823] io scheduler deadline registered
[    1.125958] io scheduler cfq registered (default)
[    1.156025] pci 0000:00:0c.0: Found enabled HT MSI Mapping
[    1.156078] pci 0000:00:0d.0: Found enabled HT MSI Mapping
[    1.156153] pci 0000:00:0e.0: Found enabled HT MSI Mapping
[    1.156252] pci 0000:01:03.0: Boot video device
[    1.156269] pci 0000:01:04.4: HCRESET not completed yet!
[    1.156361] pci 0000:40:0b.0: Found enabled HT MSI Mapping
[    1.156440] pci 0000:40:0c.0: Found enabled HT MSI Mapping
[    1.156520] pci 0000:40:0d.0: Found enabled HT MSI Mapping
[    1.156599] pci 0000:40:0e.0: Found enabled HT MSI Mapping
[    1.156920]   alloc irq_desc for 38 on cpu 0 node 0
[    1.156922]   alloc kstat_irqs on cpu 0 node 0
[    1.156932] pcieport-driver 0000:00:0c.0: irq 38 for MSI/MSI-X
[    1.156938] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    1.157065]   alloc irq_desc for 39 on cpu 0 node 0
[    1.157067]   alloc kstat_irqs on cpu 0 node 0
[    1.157071] pcieport-driver 0000:00:0d.0: irq 39 for MSI/MSI-X
[    1.157076] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    1.157185]   alloc irq_desc for 40 on cpu 0 node 0
[    1.157187]   alloc kstat_irqs on cpu 0 node 0
[    1.157193] pcieport-driver 0000:00:0e.0: irq 40 for MSI/MSI-X
[    1.157197] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    1.157341]   alloc irq_desc for 41 on cpu 0 node 0
[    1.157345]   alloc kstat_irqs on cpu 0 node 0
[    1.157358] pcieport-driver 0000:40:0b.0: irq 41 for MSI/MSI-X
[    1.157366] pcieport-driver 0000:40:0b.0: setting latency timer to 64
[    1.157538]   alloc irq_desc for 42 on cpu 0 node 0
[    1.157540]   alloc kstat_irqs on cpu 0 node 0
[    1.157547] pcieport-driver 0000:40:0c.0: irq 42 for MSI/MSI-X
[    1.157553] pcieport-driver 0000:40:0c.0: setting latency timer to 64
[    1.157687]   alloc irq_desc for 43 on cpu 0 node 0
[    1.157689]   alloc kstat_irqs on cpu 0 node 0
[    1.157694] pcieport-driver 0000:40:0d.0: irq 43 for MSI/MSI-X
[    1.157700] pcieport-driver 0000:40:0d.0: setting latency timer to 64
[    1.157836]   alloc irq_desc for 44 on cpu 0 node 0
[    1.157838]   alloc kstat_irqs on cpu 0 node 0
[    1.157844] pcieport-driver 0000:40:0e.0: irq 44 for MSI/MSI-X
[    1.157850] pcieport-driver 0000:40:0e.0: setting latency timer to 64
[    1.162854] Linux agpgart interface v0.103
[    1.162897] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.163076] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.163211] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.163688] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.166165] brd: module loaded
[    1.166297] input: Macintosh mouse button emulation as /devices/virtual/=
input/input0
[    1.166618] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64=
 irq 1,12
[    1.168231] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.168279] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.168551] mice: PS/2 mouse device common for all mice
[    1.168677] rtc_cmos 00:0a: RTC can wake from S4
[    1.168801] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
[    1.168863] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    1.168956] cpuidle: using governor ladder
[    1.168997] cpuidle: using governor menu
[    1.169040] No iBFT detected.
[    1.169443] TCP cubic registered
[    1.169698] NET: Registered protocol family 10
[    1.170418] lo: Disabled Privacy Extensions
[    1.170752] Mobile IPv6
[    1.170791] NET: Registered protocol family 17
[    1.171032] registered taskstats version 1
[    1.171366] rtc_cmos 00:0a: setting system clock to 2009-06-28 22:27:40 =
UTC (1246228060)
[    1.171516] Freeing unused kernel memory: 560k freed
[    1.171850] Write protecting the kernel read-only data: 3792k
[    1.295791] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.296237] ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 11
[    1.296286] PCI: setting IRQ 11 as level-triggered
[    1.296291] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 11 (le=
vel, low) -> IRQ 11
[    1.296405] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    1.296407] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    1.296583] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus =
number 1
[    1.296680] ehci_hcd 0000:00:02.1: debug port 1
[    1.296722] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    1.296732] ehci_hcd 0000:00:02.1: irq 11, io mem 0xd9cd0000
[    1.302965] Uniform Multi-Platform E-IDE driver
[    1.305305] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.308122] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    1.308222] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.308272] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.308331] usb usb1: Product: EHCI Host Controller
[    1.308373] usb usb1: Manufacturer: Linux 2.6.30-1-amd64 ehci_hcd
[    1.308416] usb usb1: SerialNumber: 0000:00:02.1
[    1.308534] usb usb1: configuration #1 chosen from 1 choice
[    1.308606] hub 1-0:1.0: USB hub found
[    1.308654] hub 1-0:1.0: 10 ports detected
[    1.309133] amd74xx 0000:00:06.0: UDMA133 controller
[    1.309177] amd74xx 0000:00:06.0: IDE controller (0x10de:0x0053 rev 0xa3)
[    1.309236] amd74xx 0000:00:06.0: IDE port disabled
[    1.309287] amd74xx 0000:00:06.0: not 100% native mode: will probe irqs =
later
[    1.309337]     ide0: BM-DMA at 0x0500-0x0507
[    1.309381] Probing IDE interface ide0...
[    1.323671] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.0.1 (M=
ay 6, 2009)
[    1.324027] ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 10
[    1.324073] PCI: setting IRQ 10 as level-triggered
[    1.324078] bnx2 0000:41:01.0: PCI INT A -> Link[LNKW] -> GSI 10 (level,=
 low) -> IRQ 10
[    1.333785] SCSI subsystem initialized
[    1.335882] HP CISS Driver (v 3.6.20)
[    1.337112] ACPI: PCI Interrupt Link [LNKY] enabled at IRQ 11
[    1.337167] cciss 0000:42:02.0: PCI INT A -> Link[LNKY] -> GSI 11 (level=
, low) -> IRQ 11
[    1.402244] uhci_hcd: USB Universal Host Controller Interface driver
[    1.402692] ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 10
[    1.402743] uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 10 (le=
vel, low) -> IRQ 10
[    1.402813] uhci_hcd 0000:01:04.4: UHCI Host Controller
[    1.402951] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus =
number 2
[    1.403021] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 =
ports
[    1.403076] uhci_hcd 0000:01:04.4: HCRESET not completed yet!
[    1.403130] uhci_hcd 0000:01:04.4: irq 10, io base 0x00001800
[    1.403222] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.403269] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.403330] usb usb2: Product: UHCI Host Controller
[    1.403371] usb usb2: Manufacturer: Linux 2.6.30-1-amd64 uhci_hcd
[    1.403415] usb usb2: SerialNumber: 0000:01:04.4
[    1.403502] usb usb2: configuration #1 chosen from 1 choice
[    1.403572] hub 2-0:1.0: USB hub found
[    1.403618] hub 2-0:1.0: 2 ports detected
[    1.420265] IRQ 11/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
[    1.420331] cciss0: <0x3220> at PCI 0000:42:02.0 IRQ 11 using DAC
[    1.421294]       blocks=3D 286677120 block_size=3D 512
[    1.421416]       heads=3D255, sectors=3D32, cylinders=3D35132
[    1.421417]=20
[    1.421725]       blocks=3D 286677120 block_size=3D 512
[    1.421844]       heads=3D255, sectors=3D32, cylinders=3D35132
[    1.421845]=20
[    1.421937]  cciss/c0d0: p1 p2
[    1.422442]       blocks=3D 860051248 block_size=3D 512
[    1.422561]       heads=3D255, sectors=3D32, cylinders=3D105399
[    1.422562]=20
[    1.422806]       blocks=3D 860051248 block_size=3D 512
[    1.422922]       heads=3D255, sectors=3D32, cylinders=3D105399
[    1.422923]=20
[    1.423012]  cciss/c0d1: unknown partition table
[    1.672013] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 3
[    1.804443] usb 1-6: New USB device found, idVendor=3D04b4, idProduct=3D=
6560
[    1.804502] usb 1-6: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    1.804624] usb 1-6: configuration #1 chosen from 1 choice
[    1.804834] hub 1-6:1.0: USB hub found
[    1.804962] hub 1-6:1.0: 4 ports detected
[    1.812282] bnx2 0000:41:01.0: firmware: requesting bnx2/bnx2-mips-06-4.=
6.16.fw
[    1.817093] bnx2 0000:41:01.0: firmware: requesting bnx2/bnx2-rv2p-06-4.=
6.16.fw
[    1.820889] eth0: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem dc000000, IRQ 10, node addr 00:1c:c4:f0:94:fa
[    1.821061] bnx2 0000:41:02.0: PCI INT A -> Link[LNKX] -> GSI 10 (level,=
 low) -> IRQ 10
[    1.920263] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 2
[    2.044094] hda: HL-DT-ST DVDRAM GSA-T20L, ATAPI CD/DVD-ROM drive
[    2.067560] usb 2-1: New USB device found, idVendor=3D03f0, idProduct=3D=
1027
[    2.067621] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.067667] usb 2-1: Product: Virtual Keyboard
[    2.067708] usb 2-1: Manufacturer: HP
[    2.067829] usb 2-1: configuration #1 chosen from 1 choice
[    2.079417] usbcore: registered new interface driver hiddev
[    2.084182] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb2/2-1/2-1:1.0/input/input1
[    2.084307] generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.0=
1 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
[    2.090657] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:09=
=2E0/0000:01:04.4/usb2/2-1/2-1:1.1/input/input2
[    2.090786] generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.0=
1 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
[    2.090875] usbcore: registered new interface driver usbhid
[    2.090919] usbhid: v2.6:USB HID core driver
[    2.188014] usb 2-2: new full speed USB device using uhci_hcd and addres=
s 3
[    2.308017] bnx2 0000:41:02.0: firmware: requesting bnx2/bnx2-mips-06-4.=
6.16.fw
[    2.312895] bnx2 0000:41:02.0: firmware: requesting bnx2/bnx2-rv2p-06-4.=
6.16.fw
[    2.317152] eth1: Broadcom NetXtreme II BCM5706 1000Base-T (A2) PCI-X 64=
-bit 100MHz found at mem da000000, IRQ 10, node addr 00:1c:c4:f0:94:fc
[    2.338637] usb 2-2: New USB device found, idVendor=3D03f0, idProduct=3D=
1327
[    2.338695] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.338741] usb 2-2: Product: Virtual Hub
[    2.338781] usb 2-2: Manufacturer: HP
[    2.338902] usb 2-2: configuration #1 chosen from 1 choice
[    2.344102] hub 2-2:1.0: USB hub found
[    2.346329] hub 2-2:1.0: 7 ports detected
[    2.384040] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    2.384822] hda: UDMA/33 mode selected
[    2.385257] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.386392] ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 5
[    2.386436] PCI: setting IRQ 5 as level-triggered
[    2.386440] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 5 (lev=
el, low) -> IRQ 5
[    2.386575] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    2.386578] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    2.386704] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 3
[    2.386778] ohci_hcd 0000:00:02.0: irq 5, io mem 0xd9ce0000
[    2.446034] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.446080] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.446139] usb usb3: Product: OHCI Host Controller
[    2.446181] usb usb3: Manufacturer: Linux 2.6.30-1-amd64 ohci_hcd
[    2.446224] usb usb3: SerialNumber: 0000:00:02.0
[    2.446314] usb usb3: configuration #1 chosen from 1 choice
[    2.446384] hub 3-0:1.0: USB hub found
[    2.446431] hub 3-0:1.0: 10 ports detected
[    2.458769] libata version 3.00 loaded.
[    2.465903] ide-cd driver 5.00
[    2.468063] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048=
kB Cache
[    2.468257] Uniform CD-ROM driver Revision: 3.20
[    2.594975] device-mapper: uevent: version 1.0.3
[    2.595181] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[    2.636308] kjournald starting.  Commit interval 5 seconds
[    2.636317] EXT3-fs: mounted filesystem with ordered data mode.
[    2.820017] usb 3-3: new low speed USB device using ohci_hcd and address=
 2
[    3.037058] usb 3-3: New USB device found, idVendor=3D0624, idProduct=3D=
0341
[    3.037117] usb 3-3: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    3.037164] usb 3-3: Product: HP 336047-B21
[    3.037204] usb 3-3: Manufacturer: Avocent
[    3.037326] usb 3-3: configuration #1 chosen from 1 choice
[    3.056287] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:=
02.0/usb3/3-3/3-3:1.0/input/input3
[    3.056409] generic-usb 0003:0624:0341.0003: input,hidraw2: USB HID v1.1=
0 Keyboard [Avocent HP 336047-B21] on usb-0000:00:02.0-3/input0
[    3.069382] input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:=
02.0/usb3/3-3/3-3:1.1/input/input4
[    3.069497] generic-usb 0003:0624:0341.0004: input,hidraw3: USB HID v1.1=
0 Mouse [Avocent HP 336047-B21] on usb-0000:00:02.0-3/input1
[    3.333460] udev: starting version 141
[    3.405192] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input5
[    3.405263] ACPI: Power Button [PWRF]
[    3.435325] processor ACPI_CPU:00: registered as cooling_device0
[    3.435413] processor ACPI_CPU:01: registered as cooling_device1
[    3.435493] processor ACPI_CPU:02: registered as cooling_device2
[    3.435574] processor ACPI_CPU:03: registered as cooling_device3
[    3.435657] processor ACPI_CPU:04: registered as cooling_device4
[    3.435739] processor ACPI_CPU:05: registered as cooling_device5
[    3.435820] processor ACPI_CPU:06: registered as cooling_device6
[    3.435903] processor ACPI_CPU:07: registered as cooling_device7
[    3.444361] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    3.464688] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.467816] k8temp 0000:00:18.3: Temperature readouts might be wrong - c=
heck erratum #141
[    3.468511] k8temp 0000:00:19.3: Temperature readouts might be wrong - c=
heck erratum #141
[    3.468657] k8temp 0000:00:1a.3: Temperature readouts might be wrong - c=
heck erratum #141
[    3.468789] k8temp 0000:00:1b.3: Temperature readouts might be wrong - c=
heck erratum #141
[    3.471812] shpchp 0000:40:10.0: HPC vendor_id 1022 device_id 7458 ss_vi=
d 0 ss_did 0
[    3.471882] shpchp 0000:40:10.0: Cannot reserve MMIO region
[    3.475646] hpilo 0000:01:04.2: PCI INT B -> Link[LNKX] -> GSI 10 (level=
, low) -> IRQ 10
[    3.475951] shpchp 0000:40:11.0: HPC vendor_id 1022 device_id 7458 ss_vi=
d 0 ss_did 0
[    3.476022] shpchp 0000:40:11.0: Cannot reserve MMIO region
[    3.476139] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.493696] ipmi message handler version 39.2
[    3.524122] IPMI System Interface driver.
[    3.524175] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o ad=
dress 0xca2, slave address 0x20, irq 0
[    3.557512] Error: Driver 'pcspkr' is already registered, aborting...
[    3.690171] ipmi: Found new BMC (man_id: 0x00000b,  prod_id: 0x0000, dev=
_id: 0x11)
[    3.690240] IPMI kcs interface initialized
[    3.690294] ipmi_si: Trying ACPI-specified kcs state machine at i/o addr=
ess 0xca2, slave address 0x0, irq 0
[    3.690359] ipmi_si: duplicate interface
[    3.724348] ipmi_si 0000:01:04.6: PCI INT A -> Link[LNKW] -> GSI 10 (lev=
el, low) -> IRQ 10
[    3.724416] ipmi_si: Trying PCI-specified kcs state machine at mem addre=
ss 0xd9df0000, slave address 0x0, irq 10
[    3.932019] IRQ 10/ipmi_si: IRQF_DISABLED is not guaranteed on shared IR=
Qs
[    3.932072]   Using irq 10
[    4.131150] ipmi: interfacing existing BMC (man_id: 0x00000b, prod_id: 0=
x0000, dev_id: 0x11)
[    4.131241] IPMI kcs interface initialized
[    4.485741] EXT3 FS on cciss/c0d0p1, internal journal
[    5.509026] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    5.509088] All bugs added by David S. Miller <davem@redhat.com>
[    5.516696] ipmi device interface
[    6.549485] kjournald starting.  Commit interval 5 seconds
[    6.549595] EXT3 FS on dm-1, internal journal
[    6.549677] EXT3-fs: mounted filesystem with ordered data mode.
[    6.558196] kjournald starting.  Commit interval 5 seconds
[    6.558300] EXT3 FS on dm-2, internal journal
[    6.558378] EXT3-fs: mounted filesystem with ordered data mode.
[    6.590480] kjournald starting.  Commit interval 5 seconds
[    6.590623] EXT3 FS on dm-4, internal journal
[    6.590699] EXT3-fs: mounted filesystem with ordered data mode.
[    6.598331] kjournald starting.  Commit interval 5 seconds
[    6.598514] EXT3 FS on dm-0, internal journal
[    6.598593] EXT3-fs: mounted filesystem with ordered data mode.
[    6.693332] Adding 16777208k swap on /dev/mapper/vg0-swap.  Priority:-1 =
extents:1 across:16777208k=20
[    7.164426] NET: Registered protocol family 15
[    7.178659] alg: No test for cipher_null (cipher_null-generic)
[    7.178756] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    7.178844] alg: No test for digest_null (digest_null-generic)
[    7.178932] alg: No test for compress_null (compress_null-generic)
[    7.223356] Intel AES-NI instructions are not detected.
[    7.619308] Ethernet Channel Bonding Driver: v3.5.0 (November 4, 2008)
[    7.619374] bonding: MII link monitoring set to 100 ms
[    7.657178] ADDRCONF(NETDEV_UP): bond0: link is not ready
[    7.659749] bonding: bond0: Adding slave eth0.
[    7.789496] bonding: bond0: enslaving eth0 as a backup interface with a =
down link.
[    7.791929] bonding: bond0: Adding slave eth1.
[    7.944004] bonding: bond0: enslaving eth1 as a backup interface with a =
down link.
[    8.378827] Initializing XFRM netlink socket
[   10.973236] bnx2: eth0 NIC Copper Link is Up, 1000 Mbps full duplex
[   11.053511] bonding: bond0: link status up for interface eth0, enabling =
it in 10000 ms.
[   11.298418] bnx2: eth1 NIC Copper Link is Up, 1000 Mbps full duplex
[   11.353508] bonding: bond0: link status up for interface eth1, enabling =
it in 10000 ms.
[   21.053509] bonding: bond0: link status definitely up for interface eth0.
[   21.053558] bonding: bond0: making interface eth0 the new active one.
[   21.053645] bonding: bond0: first active interface up!
[   21.056555] ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   21.353508] bonding: bond0: link status definitely up for interface eth1.
[   31.305513] bond0: no IPv6 routers present
[   32.438602] Fusion MPT base driver 3.04.07
[   32.438647] Copyright (c) 1999-2008 LSI Corporation
[   32.441740] Fusion MPT misc device (ioctl) driver 3.04.07
[   32.441838] mptctl: Registered with Fusion MPT base driver
[   32.441881] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   34.476948] lp: driver loaded but no devices found
[   34.485496] ppdev: user-space parallel port driver

--4TjKedF+bau4YbxU--

--J19t2I20ndwispKK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpH70QACgkQrzgMPqB3kijvpwCZARLeEZ9FvZtiXlFG1kYZf0sk
ytAAoIDscXBCBcpxdvxIlFbnvxxb47le
=7P5B
-----END PGP SIGNATURE-----

--J19t2I20ndwispKK--
