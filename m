Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZFSNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZFSNtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZFSNtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:49:02 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:55055 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZFSNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:48:58 -0400
Date: Fri, 19 Jun 2009 15:47:49 +0200
From: Nico -telmich- Schottelius <nico-linux-20090619@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.30-07040-g0732f87: idr_remove called for id=64 which is not
	allocated. + BUG inotify_inode_mark_entry: Poison overwritten
Message-ID: <20090619134749.GB10571@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-20090619@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-07040-g0732f87 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: multipart/mixed; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I just upgraded to this version and get two call traces
at startup:

[   86.947950] Call Trace:
[   86.948112]  [<ffffffff8119932f>] level2_spare_pgt+0x19132f/0x35e284
[   86.948263]  [<ffffffff81362f36>] ? level2_spare_pgt+0x35af36/0x35e284
[   86.948415]  [<ffffffff810f4281>] level2_spare_pgt+0xec281/0x35e284
[   86.948563]  [<ffffffff810f35b7>] level2_spare_pgt+0xeb5b7/0x35e284
[   86.948712]  [<ffffffff810f1ab8>] level2_spare_pgt+0xe9ab8/0x35e284
[   86.948861]  [<ffffffff810f420c>] level2_spare_pgt+0xec20c/0x35e284
[   86.949049]  [<ffffffff810f4355>] level2_spare_pgt+0xec355/0x35e284
[   86.949199]  [<ffffffff8100b2eb>] level2_spare_pgt+0x32eb/0x35e284
[   86.949825] idr_remove called for id=3D60 which is not allocated.
[   86.949988] Pid: 4812, comm: udevd Not tainted 2.6.30-07040-g0732f87 #34
[   86.952606] Call Trace:
[   86.952758]  [<ffffffff8119932f>] level2_spare_pgt+0x19132f/0x35e284
[   86.952917]  [<ffffffff81362f36>] ? level2_spare_pgt+0x35af36/0x35e284
[   86.953077]  [<ffffffff810f4281>] level2_spare_pgt+0xec281/0x35e284
[   86.953235]  [<ffffffff810f35b7>] level2_spare_pgt+0xeb5b7/0x35e284
[   86.953393]  [<ffffffff810f1ab8>] level2_spare_pgt+0xe9ab8/0x35e284
[   86.953550]  [<ffffffff810f420c>] level2_spare_pgt+0xec20c/0x35e284
[   86.953705]  [<ffffffff810f4355>] level2_spare_pgt+0xec355/0x35e284
[   86.953860]  [<ffffffff8100b2eb>] level2_spare_pgt+0x32eb/0x35e284

Plus this Bug:

[  810.822471] BUG inotify_inode_mark_entry: Poison overwritten
[

(full log + config attached)

Sincerly,

Nico


[    0.000000] Linux version 2.6.30-07040-g0732f87 (compiler@ikn) (gcc vers=
ion 4.3.3 (Debian 4.3.3-10) ) #34 SMP PREEMPT Fri Jun 19 12:01:26 CEST 2009
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-07040-g0732f=
87 root=3D/dev/sda1 ro quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x13c000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xbda00 max_arch_pfn =3D 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] ACPI: RSDP 00000000000f73a0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd97bd45 0009C (v01 LENOVO TP-6D    00001=
050  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd97bf00 000F4 (v03 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd97c2f4 0D910 (v01 LENOVO TP-6D    00001=
050 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd97c0b4 00240 (v01 LENOVO TP-6D    00001=
050 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd989c04 00052 (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd989c56 00078 (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd989cce 0003C (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd989d0a 00038 (v01 LENOVO TP-6D    00001=
050 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd989dc2 00176 (v01 LENOVO TP-6D    00001=
050  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd989f38 00028 (v01 LENOVO TP-6D    00001=
050  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd989f60 000A0 (v16 LENOVO TP-6D    00001=
050 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d203 0055F (v01 LENOVO TP-6D    00001=
050 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000=
000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01               =01 000=
00001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003=
000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003=
000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 013c000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00015df07c]    TEXT DATA BSS =3D=3D> [000=
1000000 - 00015df07c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [00015e0000 - 00015e014c]              BRK =3D=3D> [000=
15e0000 - 00015e014c]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88002860000=
0-ffff88002bdfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff880028023000, static data 8=
5408 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1003648
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-07040=
-g0732f87 root=3D/dev/sda1 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff=
880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 3948988k/5177344k available (3480k kernel code, 1091=
556k absent, 135912k reserved, 1550k data, 432k init)
[    0.000000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2261.013 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4522.02 BogoMIPS (lpj=3D9044052)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] Performance Counters: Core2 events, Intel PMU driver.
[    0.004000] ... version:                 2
[    0.004000] ... bit width:               40
[    0.004000] ... generic counters:        2
[    0.004000] ... value mask:              000000ffffffffff
[    0.004000] ... max period:              000000007fffffff
[    0.004000] ... fixed-purpose counters:  3
[    0.004000] ... counter mask:            0000000700000003
[    0.004000] ACPI: Core revision 20090521
[    0.108504] DMAR:Host address width 36
[    0.108512] DMAR:DRHD (flags: 0x00000000)base: 0x00000000feb03000
[    0.108555] DMAR:DRHD (flags: 0x00000000)base: 0x00000000feb01000
[    0.108596] DMAR:DRHD (flags: 0x00000000)base: 0x00000000feb00000
[    0.108635] DMAR:DRHD (flags: 0x00000001)base: 0x00000000feb02000
[    0.108656] DMAR:RMRR base: 0x00000000f2826c00 end: 0x00000000f28273ff
[    0.108663] DMAR:RMRR base: 0x00000000bdc00000 end: 0x00000000bfffffff
[    0.108671] Setting APIC routing to flat
[    0.109094] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.149290] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.152001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4522.07 Bog=
oMIPS (lpj=3D9044147)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.239417] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.239437] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.240048] Brought up 2 CPUs
[    0.240054] Total of 2 processors activated (9044.09 BogoMIPS).
[    0.240135] CPU0 attaching sched-domain:
[    0.240142]  domain 0: span 0-1 level MC
[    0.240149]   groups: 0 1
[    0.240162] CPU1 attaching sched-domain:
[    0.240168]  domain 0: span 0-1 level MC
[    0.240174]   groups: 1 0
[    0.244744] regulator: core version 0.5
[    0.244744] NET: Registered protocol family 16
[    0.248349] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.248349] ACPI: bus type pci registered
[    0.248477] PCI: Using configuration type 1 for base access
[    0.280469] bio: create slab <bio-0> at 0
[    0.287395] ACPI: EC: EC description table is found, configuring boot EC
[    0.371871] ACPI: BIOS _OSI(Linux) query ignored
[    0.372026] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.411498] ACPI: Interpreter enabled
[    0.411507] ACPI: (supports S0 S3 S5)
[    0.411719] ACPI: Using IOAPIC for interrupt routing
[    0.501029] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.501037] ACPI: EC: driver started in interrupt mode
[    0.501228] ACPI: Power Resource [PUBS] (on)
[    0.517879] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.521102] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.521328] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.521328] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.521328] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.521328] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.521328] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.521328] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.521328] pci 0000:00:03.0: PME# disabled
[    0.521328] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.521328] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.521328] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.521328] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.521328] pci 0000:00:19.0: PME# disabled
[    0.521328] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.521328] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.521328] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.521464] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.521571] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.521581] pci 0000:00:1a.7: PME# disabled
[    0.521706] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.521798] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.521808] pci 0000:00:1b.0: PME# disabled
[    0.522041] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.522050] pci 0000:00:1c.0: PME# disabled
[    0.522194] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.522204] pci 0000:00:1c.1: PME# disabled
[    0.522347] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.522357] pci 0000:00:1c.3: PME# disabled
[    0.522489] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.524156] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.524314] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.524478] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.524585] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.524596] pci 0000:00:1d.7: PME# disabled
[    0.524992] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.525006] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.525021] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.525035] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.525049] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.525063] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.525134] pci 0000:00:1f.2: PME# supported from D3hot
[    0.525143] pci 0000:00:1f.2: PME# disabled
[    0.525221] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.525252] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.525747] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.526137] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.526176] pci 0000:03:00.0: PME# disabled
[    0.526350] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.526467] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.526477] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.526493] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.526611] pci 0000:00:1e.0: transparent bridge
[    0.526667] pci_bus 0000:00: on NUMA node 0
[    0.526718] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.529664] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.530419] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.531196] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.593217] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.596251] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.597632] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.598987] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.600369] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.601727] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.603083] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.604460] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.605018] SCSI subsystem initialized
[    0.605018] libata version 3.00 loaded.
[    0.608289] PCI: Using ACPI for IRQ routing
[    0.628449] DMAR:Device scope device [0000:00:03.02] not found
[    0.628457] DMAR:Device scope device [0000:00:03.02] not found
[    0.628465] DMAR:Device scope device [0000:00:03.03] not found
[    0.628471] DMAR:Device scope device [0000:00:03.03] not found
[    0.628504] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.628519] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.636021] Switched to high resolution mode on CPU 0
[    0.639494] Switched to high resolution mode on CPU 1
[    0.652107] pnp: PnP ACPI init
[    0.652142] ACPI: bus type pnp registered
[    0.735161] pnp: PnP ACPI: found 10 devices
[    0.735168] ACPI: ACPI bus type pnp unregistered
[    0.735212] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.735223] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.735260] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.735270] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.735281] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.735297] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.735312] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.735328] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.735343] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.735359] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.735374] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.735390] system 00:00: iomem range 0x100000-0xbfffffff could not be r=
eserved
[    0.735406] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.735422] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.735450] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.735461] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.735472] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.735483] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.735494] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.735505] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.735516] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.735527] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.735539] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.735550] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.735561] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.735573] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.735584] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.746205] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.746212] pci 0000:00:1c.0:   IO window: disabled
[    0.746223] pci 0000:00:1c.0:   MEM window: disabled
[    0.746232] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.746245] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.746251] pci 0000:00:1c.1:   IO window: disabled
[    0.746263] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.746272] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.746285] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.746293] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.746305] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.746316] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.746330] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.746335] pci 0000:00:1e.0:   IO window: disabled
[    0.746345] pci 0000:00:1e.0:   MEM window: disabled
[    0.746354] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.746390] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.746401] pci 0000:00:1c.0: setting latency timer to 64
[    0.746423] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.746433] pci 0000:00:1c.1: setting latency timer to 64
[    0.746455] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.746466] pci 0000:00:1c.3: setting latency timer to 64
[    0.746480] pci 0000:00:1e.0: setting latency timer to 64
[    0.746490] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.746497] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.746505] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.746513] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.746519] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.746526] pci_bus 0000:05: resource 2 pref mem [0xf2900000-0xf29fffff]
[    0.746533] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.746540] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.746656] NET: Registered protocol family 2
[    0.746925] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.749368] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.752361] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.753186] TCP: Hash tables configured (established 262144 bind 65536)
[    0.753193] TCP reno registered
[    0.753544] NET: Registered protocol family 1
[    0.755554] Simple Boot Flag at 0x35 set to 0x1
[    0.763176] microcode: no support for this CPU vendor
[    0.765612] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.814131] VFS: Disk quotas dquot_6.5.2
[    0.814728] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.819719] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.825558] msgmni has been set to 7714
[    0.826993] alg: No test for stdrng (krng)
[    0.827041] io scheduler noop registered
[    0.827048] io scheduler anticipatory registered (default)
[    0.827054] io scheduler deadline registered
[    0.828108] io scheduler cfq registered
[    0.828148] pci 0000:00:02.0: Boot video device
[    0.829568] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.829599] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.830422] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.830451] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.831386] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.831415] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.835167] ACPI: AC Adapter [AC] (off-line)
[    0.836138] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.836148] ACPI: Power Button [PWRF]
[    0.836705] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[    0.837783] ACPI: Lid Switch [LID]
[    0.838359] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    0.838374] ACPI: Sleep Button [SLPB]
[    0.844636] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050624)
[    0.848752] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050624)
[    0.895036] ACPI Warning: Invalid throttling state, reset 20090521 proce=
ssor_throttling-843
[    0.901351] Monitor-Mwait will be used to enter C-1 state
[    0.905026] Monitor-Mwait will be used to enter C-2 state
[    0.909039] Monitor-Mwait will be used to enter C-3 state
[    0.909062] Marking TSC unstable due to TSC halts in idle
[    0.909370] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.909784] processor ACPI_CPU:00: registered as cooling_device0
[    0.909822] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.915113] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20050624)
[    0.919144] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20050624)
[    0.925058] ACPI Warning: Invalid throttling state, reset 20090521 proce=
ssor_throttling-843
[    0.932534] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.932892] processor ACPI_CPU:01: registered as cooling_device1
[    0.932930] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.002923] thermal LNXTHERM:01: registered as thermal_zone0
[    1.003015] ACPI: Thermal Zone [THM0] (40 C)
[    1.010585] thermal LNXTHERM:02: registered as thermal_zone1
[    1.010659] ACPI: Thermal Zone [THM1] (36 C)
[    1.068889] ACPI: Battery Slot [BAT0] (battery present)
[    1.266639] Linux agpgart interface v0.103
[    1.266838] Platform driver 'floppy' needs updating - please use dev_pm_=
ops
[    4.280045] floppy0: no floppy controllers found
[    4.294269] brd: module loaded
[    4.294275] Uniform Multi-Platform E-IDE driver
[    4.295028] ide-gd driver 1.18
[    4.296357] Driver 'sd' needs updating - please use bus_type methods
[    4.296696] ahci 0000:00:1f.2: version 3.0
[    4.296738] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    4.296849] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    4.296929] ahci: SSS flag set, parallel bus scan disabled
[    4.296977] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    4.296988] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    4.296999] ahci 0000:00:1f.2: setting latency timer to 64
[    4.297450] scsi0 : ahci
[    4.299451] scsi1 : ahci
[    4.300274] scsi2 : ahci
[    4.301083] scsi3 : ahci
[    4.304958] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    4.304967] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    4.304974] ata3: DUMMY
[    4.304978] ata4: DUMMY
[    4.307199] Fusion MPT base driver 3.04.10
[    4.307204] Copyright (c) 1999-2008 LSI Corporation
[    4.307251] Fusion MPT SPI Host driver 3.04.10
[    4.308391] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.309481] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    4.309502] Platform driver 'i8042' needs updating - please use dev_pm_o=
ps
[    4.322399] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.322419] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.323652] mice: PS/2 mouse device common for all mice
[    4.331606] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input3
[    4.334771] cpuidle: using governor ladder
[    4.339884] cpuidle: using governor menu
[    4.341531] TCP cubic registered
[    4.341540] NET: Registered protocol family 17
[    4.348175] registered taskstats version 1
[    4.500055] Clocksource tsc unstable (delta =3D -126386685 ns)
[    4.624178] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.670529] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.670541] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.670880] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.670891] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.671959] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    4.671968] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.681609] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.681621] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.681749] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.681760] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.682890] ata1.00: configured for UDMA/100
[    4.710422] ata1.00: configured for UDMA/100
[    4.710435] ata1: EH complete
[    4.710779] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    4.712720] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.712807] sd 0:0:0:0: [sda] Write Protect is off
[    4.712815] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.712964] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.713714]  sda: sda1 sda2 sda3
[    4.762537] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.867697] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    4.888355] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/input/input4
[    5.032297] ata2: SATA link down (SStatus 0 SControl 300)
[    5.107520] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    5.107693] Freeing unused kernel memory: 432k freed
[    5.107939] Write protecting the kernel read-only data: 4736k
[    9.273416] rtc_cmos 00:07: RTC can wake from S4
[    9.273599] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    9.273632] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.414015] Non-volatile memory driver v1.3
[    9.618811] agpgart-intel 0000:00:00.0: Intel Mobile Intel=C2=AE GM45 Ex=
press Chipset
[    9.621587] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    9.629876] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    9.665834] ACPI: WMI: Mapper loaded
[   10.071321] usbcore: registered new interface driver usbfs
[   10.071383] usbcore: registered new interface driver hub
[   10.073413] usbcore: registered new device driver usb
[   10.407717] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   10.407725] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.407829] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[   10.407853] e1000e 0000:00:19.0: setting latency timer to 64
[   10.408512] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   10.511839] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[   10.511848] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.511887] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[   10.676887] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.687515] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   10.687541] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[   10.687701] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   10.687711] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   10.687841] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[   10.691922] ehci_hcd 0000:00:1a.7: debug port 1
[   10.691935] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   10.692066] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[   10.701320] cfg80211: Calling CRDA to update world regulatory domain
[   10.708063] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   10.708414] usb usb1: configuration #1 chosen from 1 choice
[   10.708520] hub 1-0:1.0: USB hub found
[   10.708543] hub 1-0:1.0: 6 ports detected
[   10.709398] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   10.709417] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[   10.709456] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   10.709461] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   10.709487] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[   10.713466] ehci_hcd 0000:00:1d.7: debug port 1
[   10.713474] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   10.713531] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[   10.721434] uhci_hcd: USB Universal Host Controller Interface driver
[   10.732035] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.732372] usb usb2: configuration #1 chosen from 1 choice
[   10.732476] hub 2-0:1.0: USB hub found
[   10.732497] hub 2-0:1.0: 6 ports detected
[   10.733309] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   10.733322] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[   10.733338] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   10.733343] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   10.733366] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[   10.733452] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[   10.733817] usb usb3: configuration #1 chosen from 1 choice
[   10.733993] hub 3-0:1.0: USB hub found
[   10.734013] hub 3-0:1.0: 2 ports detected
[   10.734160] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[   10.734175] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   10.734180] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   10.734208] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[   10.734274] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[   10.734586] usb usb4: configuration #1 chosen from 1 choice
[   10.734696] hub 4-0:1.0: USB hub found
[   10.734714] hub 4-0:1.0: 2 ports detected
[   10.737422] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   10.737436] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[   10.737448] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   10.737452] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   10.737472] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[   10.737530] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[   10.737809] usb usb5: configuration #1 chosen from 1 choice
[   10.737899] hub 5-0:1.0: USB hub found
[   10.737914] hub 5-0:1.0: 2 ports detected
[   10.738533] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   10.738541] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   10.738552] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.738555] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.738570] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[   10.738625] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[   10.738892] usb usb6: configuration #1 chosen from 1 choice
[   10.738971] hub 6-0:1.0: USB hub found
[   10.738986] hub 6-0:1.0: 2 ports detected
[   10.739087] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[   10.739098] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.739101] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.739114] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[   10.739172] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[   10.739383] usb usb7: configuration #1 chosen from 1 choice
[   10.739459] hub 7-0:1.0: USB hub found
[   10.739483] hub 7-0:1.0: 2 ports detected
[   10.739582] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[   10.739592] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.739595] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.739616] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[   10.739700] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[   10.739917] usb usb8: configuration #1 chosen from 1 choice
[   10.740099] hub 8-0:1.0: USB hub found
[   10.740124] hub 8-0:1.0: 2 ports detected
[   11.081072] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[   11.240108] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 4
[   11.308154] Platform driver 'thinkpad_acpi' needs updating - please use =
dev_pm_ops
[   11.309054] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[   11.309060] thinkpad_acpi: http://ibm-acpi.sf.net/
[   11.309065] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[   11.309071] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[   11.310610] thinkpad_acpi: radio switch found; radios are enabled
[   11.311530] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[   11.311539] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[   11.324700] Registered led device: tpacpi::thinklight
[   11.324803] Registered led device: tpacpi::power
[   11.324855] Registered led device: tpacpi::standby
[   11.327437] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[   11.327815] input: ThinkPad Extra Buttons as /devices/virtual/input/inpu=
t5
[   11.379480] usb 1-6: configuration #1 chosen from 1 choice
[   11.492133] usb 2-6: new high speed USB device using ehci_hcd and addres=
s 2
[   11.635953] usb 2-6: configuration #1 chosen from 1 choice
[   11.642280] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[   11.642283] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   11.642459] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   11.642488] iwlagn 0000:03:00.0: setting latency timer to 64
[   11.642662] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[   11.676958] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[   11.677058] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   11.827220] usbcore: registered new interface driver libusual
[   11.880087] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 2
[   11.956442] Initializing USB Mass Storage driver...
[   11.957751] scsi4 : SCSI emulation for USB Mass Storage devices
[   11.961347] usbcore: registered new interface driver usb-storage
[   11.961362] USB Mass Storage support registered.
[   11.961375] usb-storage: device found at 2
[   11.961379] usb-storage: waiting for device to settle before scanning
[   12.020084] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.050559] usb 4-1: configuration #1 chosen from 1 choice
[   12.292179] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 3
[   12.321881] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   12.322001] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.423503] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input6
[   12.424023] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input7
[   12.424498] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input8
[   12.425095] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input9
[   12.470574] usb 4-2: configuration #1 chosen from 1 choice
[   12.704045] Bluetooth: Core ver 2.15
[   12.709034] NET: Registered protocol family 31
[   12.709037] Bluetooth: HCI device and connection manager initialized
[   12.709040] Bluetooth: HCI socket layer initialized
[   12.806127] Bluetooth: Generic Bluetooth USB driver ver 0.5
[   12.806877] usbcore: registered new interface driver btusb
[   16.734196] loop: module loaded
[   16.961370] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   16.963983] usb-storage: device scan complete
[   17.145534] sd 4:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96 G=
B/3.69 GiB)
[   17.146307] sd 4:0:0:0: [sdb] Write Protect is off
[   17.146316] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   17.146322] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   17.150148] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   17.150381]  sdb: sdb1
[   17.153050] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   17.159434] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   33.986426] Intel AES-NI instructions are not detected.
[   34.076493] padlock: VIA PadLock not detected.
[   34.188428] padlock: VIA PadLock Hash Engine not detected.
[   34.208579] isa bounce pool size: 16 pages
[   36.309571] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0x=
e frozen
[   36.309802] ata2: irq_stat 0x00000040, connection status changed
[   36.309947] ata2: SError: { CommWake DevExch }
[   36.310099] ata2: hard resetting link
[   37.032302] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   37.185168] Monitor-Mwait will be used to enter C-3 state
[   37.189627] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[   37.190470] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[   37.193511] thinkpad_acpi: EC reports that Thermal Table has changed
[   37.194146] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[   37.195779] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[   37.197138] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
[   37.197246] ata2.00: revalidation failed (errno=3D-5)
[   37.285601] ACPI: \_SB_.GDCK - docking
[   37.317359] ata2: hard resetting link
[   37.432139] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 5
[   37.565105] usb 1-5: configuration #1 chosen from 1 choice
[   37.565629] hub 1-5:1.0: USB hub found
[   37.565906] hub 1-5:1.0: 4 ports detected
[   37.637152] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   37.646184] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[   37.647087] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[   37.661372] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[   37.662323] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[   37.666321] ata2.00: configured for UDMA/133
[   37.776692] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[   37.776837] ata2: irq_stat 0x40000001
[   37.785504] ata2.00: configured for UDMA/133
[   37.785651] ata2: EH complete
[   38.807636] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[   39.000560] Driver 'sr' needs updating - please use bus_type methods
[   39.329333] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[   39.329564] Uniform CD-ROM driver Revision: 3.20
[   39.330287] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   39.447866] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   39.448300] sd 4:0:0:0: Attached scsi generic sg1 type 0
[   39.448663] sr 1:0:0:0: Attached scsi generic sg2 type 5
[   53.218800] fuse init (API version 7.11)
[   53.552199] Adding 4982032k swap on /dev/mapper/swap.  Priority:-1 exten=
ts:1 across:4982032k=20
[   56.937414] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   56.992171] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   59.427247] Loading iSCSI transport class v2.0-870.
[   59.528334] iscsi: registered transport (tcp)
[   59.792876] NET: Registered protocol family 10
[   59.793997] lo: Disabled Privacy Extensions
[   59.794760] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   60.200341] iscsi: registered transport (iser)
[   67.397267] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   67.397501] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   67.502307] input: /usr/sbin/thinkpad-keys as /devices/virtual/input/inp=
ut10
[   69.084446] RPC: Registered udp transport module.
[   69.084553] RPC: Registered tcp transport module.
[   69.441848] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   69.618448] svc: failed to register lockdv1 RPC service (errno 97).
[   69.637988] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   69.652488] NFSD: starting 90-second grace period
[   79.757357] Bluetooth: L2CAP ver 2.13
[   79.757510] Bluetooth: L2CAP socket layer initialized
[   79.853714] Bluetooth: RFCOMM socket layer initialized
[   79.853924] Bluetooth: RFCOMM TTY layer initialized
[   79.854069] Bluetooth: RFCOMM ver 1.11
[   84.252917] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.uco=
de
[   84.464753] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   84.694545] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   86.947641] idr_remove called for id=3D64 which is not allocated.
[   86.947802] Pid: 4810, comm: udevd Not tainted 2.6.30-07040-g0732f87 #34
[   86.947950] Call Trace:
[   86.948112]  [<ffffffff8119932f>] level2_spare_pgt+0x19132f/0x35e284
[   86.948263]  [<ffffffff81362f36>] ? level2_spare_pgt+0x35af36/0x35e284
[   86.948415]  [<ffffffff810f4281>] level2_spare_pgt+0xec281/0x35e284
[   86.948563]  [<ffffffff810f35b7>] level2_spare_pgt+0xeb5b7/0x35e284
[   86.948712]  [<ffffffff810f1ab8>] level2_spare_pgt+0xe9ab8/0x35e284
[   86.948861]  [<ffffffff810f420c>] level2_spare_pgt+0xec20c/0x35e284
[   86.949049]  [<ffffffff810f4355>] level2_spare_pgt+0xec355/0x35e284
[   86.949199]  [<ffffffff8100b2eb>] level2_spare_pgt+0x32eb/0x35e284
[   86.949825] idr_remove called for id=3D60 which is not allocated.
[   86.949988] Pid: 4812, comm: udevd Not tainted 2.6.30-07040-g0732f87 #34
[   86.952606] Call Trace:
[   86.952758]  [<ffffffff8119932f>] level2_spare_pgt+0x19132f/0x35e284
[   86.952917]  [<ffffffff81362f36>] ? level2_spare_pgt+0x35af36/0x35e284
[   86.953077]  [<ffffffff810f4281>] level2_spare_pgt+0xec281/0x35e284
[   86.953235]  [<ffffffff810f35b7>] level2_spare_pgt+0xeb5b7/0x35e284
[   86.953393]  [<ffffffff810f1ab8>] level2_spare_pgt+0xe9ab8/0x35e284
[   86.953550]  [<ffffffff810f420c>] level2_spare_pgt+0xec20c/0x35e284
[   86.953705]  [<ffffffff810f4355>] level2_spare_pgt+0xec355/0x35e284
[   86.953860]  [<ffffffff8100b2eb>] level2_spare_pgt+0x32eb/0x35e284
[   88.764709] ip_tables: (C) 2000-2006 Netfilter Core Team
[  232.117923] iwlagn 0000:03:00.0: PCI INT A disabled
[  232.202657] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[  232.202847] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[  232.203074] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  232.203201] iwlagn 0000:03:00.0: setting latency timer to 64
[  232.203269] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[  232.240139] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[  232.240393] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[  232.243138] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  234.436104] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.uco=
de
[  234.447073] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[  234.681367] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  238.775274] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  238.778487] wlan0: authenticated
[  238.778494] wlan0: associate with AP 00:03:52:4d:bd:c1
[  238.976040] wlan0: associate with AP 00:03:52:4d:bd:c1
[  238.986338] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  238.986346] wlan0: associated
[  239.003417] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  245.587910] tun: Universal TUN/TAP device driver, 1.6
[  245.588090] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  245.591820] tun0: Disabled Privacy Extensions
[  249.220128] wlan0: no IPv6 routers present
[  286.089653] [drm] Initialized drm 1.1.0 20060810
[  286.894502] pci 0000:00:02.0: power state changed by ACPI to D0
[  286.894513] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  286.894518] pci 0000:00:02.0: setting latency timer to 64
[  286.920854] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[  286.934210] acpi device:03: registered as cooling_device2
[  286.934898] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/device:02/input/input11
[  286.935042] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[  286.935153] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[  288.232736] set status page addr 0x08da0000
[  300.804823] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank c=
ount for disabled pipe 0
[  313.827517] set status page addr 0x08da0000
[  318.499455] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[  318.499468] BUG inotify_inode_mark_entry: Poison overwritten
[  318.499473] ------------------------------------------------------------=
-----------------
[  318.499477]=20
[  318.499484] INFO: 0xffff88012fc1639c-0xffff88012fc1639c. First byte 0x6a=
 instead of 0x6b
[  318.499503] INFO: Allocated in level2_spare_pgt+0xebf97/0x35e284 age=3D5=
7909 cpu=3D1 pid=3D4798
[  318.499515] INFO: Freed in level2_spare_pgt+0xebcbe/0x35e284 age=3D57887=
 cpu=3D1 pid=3D4810
[  318.499524] INFO: Slab 0xffffea00042724d0 objects=3D22 used=3D5 fp=3D0xf=
fff88012fc16398 flags=3D0x80000000000000c3
[  318.499533] INFO: Object 0xffff88012fc16398 @offset=3D920 fp=3D0xffff880=
12fc16450
[  318.499536]=20
[  318.499542] Bytes b4 0xffff88012fc16388:  00 00 00 00 00 00 00 00 5a 5a =
5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[  318.499581]   Object 0xffff88012fc16398:  6b 6b 6b 6b 6a 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkjkkkkkkkkkkk
[  318.499619]   Object 0xffff88012fc163a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  318.499657]   Object 0xffff88012fc163b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  318.499695]   Object 0xffff88012fc163c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  318.499733]   Object 0xffff88012fc163d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  318.499771]   Object 0xffff88012fc163e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  318.499809]   Object 0xffff88012fc163f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=A5
[  318.499847]  Redzone 0xffff88012fc16408:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[  318.499883]  Padding 0xffff88012fc16448:  5a 5a 5a 5a 5a 5a 5a 5a       =
                  ZZZZZZZZ       =20
[  318.499923] Pid: 8916, comm: dbus-daemon Not tainted 2.6.30-07040-g0732f=
87 #34
[  318.499929] Call Trace:
[  318.499943]  [<ffffffff810b75db>] level2_spare_pgt+0xaf5db/0x35e284
[  318.499956]  [<ffffffff810b7bc4>] level2_spare_pgt+0xafbc4/0x35e284
[  318.499968]  [<ffffffff810b7cf3>] level2_spare_pgt+0xafcf3/0x35e284
[  318.499980]  [<ffffffff810b9c93>] level2_spare_pgt+0xb1c93/0x35e284
[  318.499991]  [<ffffffff810f3f97>] ? level2_spare_pgt+0xebf97/0x35e284
[  318.500002]  [<ffffffff810c9170>] ? level2_spare_pgt+0xc1170/0x35e284
[  318.500014]  [<ffffffff810f3f97>] ? level2_spare_pgt+0xebf97/0x35e284
[  318.500025]  [<ffffffff810b9ea9>] level2_spare_pgt+0xb1ea9/0x35e284
[  318.500038]  [<ffffffff810f3f97>] level2_spare_pgt+0xebf97/0x35e284
[  318.500051]  [<ffffffff8100b2eb>] level2_spare_pgt+0x32eb/0x35e284
[  318.500063] FIX inotify_inode_mark_entry: Restoring 0xffff88012fc1639c-0=
xffff88012fc1639c=3D0x6b
[  318.500067]=20
[  318.500072] FIX inotify_inode_mark_entry: Marking all objects used
[  339.164128] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank c=
ount for disabled pipe 0
[  399.314413] set status page addr 0x08da0000
[  810.822458] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[  810.822471] BUG inotify_inode_mark_entry: Poison overwritten
[  810.822476] ------------------------------------------------------------=
-----------------
[  810.822480]=20
[  810.822488] INFO: 0xffff880139cecc3c-0xffff880139cecc3c. First byte 0x6a=
 instead of 0x6b
[  810.822506] INFO: Allocated in level2_spare_pgt+0xebf97/0x35e284 age=3D1=
89590 cpu=3D0 pid=3D3424
[  810.822517] INFO: Freed in level2_spare_pgt+0xebcbe/0x35e284 age=3D18096=
7 cpu=3D0 pid=3D4812
[  810.822527] INFO: Slab 0xffffea00044a53a0 objects=3D22 used=3D21 fp=3D0x=
ffff880139cecc38 flags=3D0x80000000000000c3
[  810.822535] INFO: Object 0xffff880139cecc38 @offset=3D3128 fp=3D0x(null)
[  810.822538]=20
[  810.822543] Bytes b4 0xffff880139cecc28:  00 00 00 00 00 00 00 00 5a 5a =
5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[  810.822578]   Object 0xffff880139cecc38:  6b 6b 6b 6b 6a 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkjkkkkkkkkkkk
[  810.822613]   Object 0xffff880139cecc48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  810.822647]   Object 0xffff880139cecc58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  810.822681]   Object 0xffff880139cecc68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  810.822715]   Object 0xffff880139cecc78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  810.822749]   Object 0xffff880139cecc88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  810.822783]   Object 0xffff880139cecc98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=A5
[  810.822818]  Redzone 0xffff880139cecca8:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[  810.822850]  Padding 0xffff880139cecce8:  5a 5a 5a 5a 5a 5a 5a 5a       =
                  ZZZZZZZZ       =20
[  810.822885] Pid: 11206, comm: xulrunner-stub Not tainted 2.6.30-07040-g0=
732f87 #34
[  810.822891] Call Trace:
[  810.822904]  [<ffffffff810b75db>] level2_spare_pgt+0xaf5db/0x35e284
[  810.822915]  [<ffffffff810b7bc4>] level2_spare_pgt+0xafbc4/0x35e284
[  810.822927]  [<ffffffff810b7cf3>] level2_spare_pgt+0xafcf3/0x35e284
[  810.822938]  [<ffffffff810b9c93>] level2_spare_pgt+0xb1c93/0x35e284
[  810.822949]  [<ffffffff810f3f97>] ? level2_spare_pgt+0xebf97/0x35e284
[  810.822960]  [<ffffffff810c9170>] ? level2_spare_pgt+0xc1170/0x35e284
[  810.822970]  [<ffffffff810f3f97>] ? level2_spare_pgt+0xebf97/0x35e284
[  810.822981]  [<ffffffff810b9ea9>] level2_spare_pgt+0xb1ea9/0x35e284
[  810.822992]  [<ffffffff810f3f97>] level2_spare_pgt+0xebf97/0x35e284
[  810.823005]  [<ffffffff8100b2eb>] level2_spare_pgt+0x32eb/0x35e284
[  810.823015] FIX inotify_inode_mark_entry: Restoring 0xffff880139cecc3c-0=
xffff880139cecc3c=3D0x6b
[  810.823019]=20
[  810.823025] FIX inotify_inode_mark_entry: Marking all objects used

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--RASg3xLB4tUQ4RcS
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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
+tIEgsBRqn6P3tlt/D/KZgIb0GQBAA==

--RASg3xLB4tUQ4RcS--

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko7lwUACgkQuL75KpiFGIzvjACg2AMtfY88Dyp05bMSvUge08p9
I5MAn19QZrh89aqP7OmV2QeJJCP8Ys/Z
=I0ZJ
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
