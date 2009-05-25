Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZEYHVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZEYHVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZEYHVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:21:46 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:36061 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZEYHVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:21:42 -0400
Date: Mon, 25 May 2009 09:21:38 +0200
From: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
To: ipw3945-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: iwlagn (5300) broken: 2.6.30-rc7, linux-next
Message-ID: <20090525072138.GA5568@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-ipw3945-devel@schottelius.org>,
	ipw3945-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: multipart/mixed; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I cannot authenticate agains any AP with

  - 2.6.30-rc5-next-20090514-05233,
  - 2.6.30-rc5-next-20090515-05297-g9bbe396,
  - 2.6.30-rc7

dmesg, .config for 2.6.30-rc6 are attached.

I'm using wpa_supplicant to try to establish the connection.
Sorry for the late report, just switched back to wired lan
the last weeks.

Sincerly,

Nico


[    0.000000] Linux version 2.6.30-rc7 (compiler@ikn) (gcc version 4.3.3 (=
Debian 4.3.3-3) ) #33 SMP PREEMPT Mon May 25 08:43:08 CEST 2009
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-rc7 root=3D/=
dev/sda1 ro quiet
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
[    0.000000] last_pfn =3D 0x13c000 max_arch_pfn =3D 0x100000000
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
[    0.000000] last_pfn =3D 0xbda00 max_arch_pfn =3D 0x100000000
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
[    0.000000]   #2 [0000200000 - 00007a829c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00007a829c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [00007a9000 - 00007a914c]              BRK =3D=3D> [000=
07a9000 - 00007a914c]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff88002820000=
0-ffff88002c7fffff] on node 0
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
[    0.000000]   DMA zone: 1551 pages reserved
[    0.000000]   DMA zone: 2391 pages, LIFO batch:0
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
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
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
[    0.000000] Allocating PCI resources starting at c2000000 (gap: c0000000=
:20000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages at ffff880028023000, static data 7=
9712 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1002200
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-rc7 r=
oot=3D/dev/sda1 ro quiet
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.879 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing 64MB software IO TLB between ffff880020000000 - ffff=
880024000000
[    0.004000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.004000] Memory: 3934740k/5177344k available (3412k kernel code, 1091=
556k absent, 150152k reserved, 1410k data, 424k init)
[    0.004000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4521.75 BogoMIPS (lpj=3D9043516)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20090320
[    0.044167] Setting APIC routing to flat
[    0.044506] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.084544] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.088001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4974.18 Bog=
oMIPS (lpj=3D9948371)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.173543] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.173565] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.176025] Brought up 2 CPUs
[    0.176027] Total of 2 processors activated (9495.94 BogoMIPS).
[    0.176079] CPU0 attaching sched-domain:
[    0.176081]  domain 0: span 0-1 level MC
[    0.176084]   groups: 0 1
[    0.176089] CPU1 attaching sched-domain:
[    0.176091]  domain 0: span 0-1 level MC
[    0.176093]   groups: 1 0
[    0.176251] net_namespace: 1752 bytes
[    0.176275] regulator: core version 0.5
[    0.176275] NET: Registered protocol family 16
[    0.180056] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.180056] ACPI: bus type pci registered
[    0.180123] PCI: Using configuration type 1 for base access
[    0.188399] bio: create slab <bio-0> at 0
[    0.192855] ACPI: EC: EC description table is found, configuring boot EC
[    0.223648] ACPI: BIOS _OSI(Linux) query ignored
[    0.224017] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.249335] ACPI: Interpreter enabled
[    0.249339] ACPI: (supports S0 S3 S5)
[    0.249424] ACPI: Using IOAPIC for interrupt routing
[    0.293986] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.293986] ACPI: EC: driver started in interrupt mode
[    0.296098] ACPI: Power Resource [PUBS] (on)
[    0.302065] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.304658] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.304758] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.304758] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.304758] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.304758] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.304758] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.304758] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.304758] pci 0000:00:03.0: PME# disabled
[    0.304758] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.304758] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.304758] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.304758] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.304758] pci 0000:00:19.0: PME# disabled
[    0.304758] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.304758] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.304758] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.304760] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.304825] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.304830] pci 0000:00:1a.7: PME# disabled
[    0.304883] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.304934] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.304939] pci 0000:00:1b.0: PME# disabled
[    0.305012] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.305017] pci 0000:00:1c.0: PME# disabled
[    0.305093] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.305097] pci 0000:00:1c.1: PME# disabled
[    0.305174] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.305178] pci 0000:00:1c.3: PME# disabled
[    0.305249] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.305338] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.305426] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.305518] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.305582] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.305587] pci 0000:00:1d.7: PME# disabled
[    0.305812] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.305818] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.305825] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.305832] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.305839] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.305846] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.305884] pci 0000:00:1f.2: PME# supported from D3hot
[    0.305888] pci 0000:00:1f.2: PME# disabled
[    0.305928] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.305944] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.306114] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.306217] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.306224] pci 0000:03:00.0: PME# disabled
[    0.306289] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.306349] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.306353] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.306360] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.306428] pci 0000:00:1e.0: transparent bridge
[    0.306459] pci_bus 0000:00: on NUMA node 0
[    0.306476] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.308349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.308634] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.308926] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.332654] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.332985] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.333525] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.334064] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.334602] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.336187] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.336740] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.337282] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.337526] SCSI subsystem initialized
[    0.340122] libata version 3.00 loaded.
[    0.340317] PCI: Using ACPI for IRQ routing
[    0.356105] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.356110] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.381624] pnp: PnP ACPI init
[    0.381638] ACPI: bus type pnp registered
[    0.449449] pnp: PnP ACPI: found 10 devices
[    0.449452] ACPI: ACPI bus type pnp unregistered
[    0.449469] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.449473] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.449476] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.449480] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.449484] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.449489] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.449495] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.449500] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.449506] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.449511] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.449516] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.449522] system 00:00: iomem range 0x100000-0xbfffffff could not be r=
eserved
[    0.449528] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.449533] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.449543] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.449547] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.449551] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.449555] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.449559] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.449563] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.449566] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.449570] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.449574] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.449578] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.449582] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.449586] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.449598] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.456671] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.456673] pci 0000:00:1c.0:   IO window: disabled
[    0.456679] pci 0000:00:1c.0:   MEM window: disabled
[    0.456683] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.456689] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.456691] pci 0000:00:1c.1:   IO window: disabled
[    0.456697] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.456701] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.456707] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.456711] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.456716] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.456721] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.456728] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.456730] pci 0000:00:1e.0:   IO window: disabled
[    0.456735] pci 0000:00:1e.0:   MEM window: disabled
[    0.456739] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.456756] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.456761] pci 0000:00:1c.0: setting latency timer to 64
[    0.456771] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.456775] pci 0000:00:1c.1: setting latency timer to 64
[    0.456785] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.456789] pci 0000:00:1c.3: setting latency timer to 64
[    0.456796] pci 0000:00:1e.0: setting latency timer to 64
[    0.456801] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.456804] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.456807] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.456809] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.456812] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.456814] pci_bus 0000:05: resource 2 pref mem [0xf2900000-0xf29fffff]
[    0.456817] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.456819] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.456867] NET: Registered protocol family 2
[    0.501669] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.502536] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.504115] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.504598] TCP: Hash tables configured (established 262144 bind 65536)
[    0.504601] TCP reno registered
[    0.513745] NET: Registered protocol family 1
[    0.514442] Simple Boot Flag at 0x35 set to 0x1
[    0.516910] microcode: no support for this CPU vendor
[    0.517874] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.533714] VFS: Disk quotas dquot_6.5.2
[    0.533906] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.535627] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.538596] msgmni has been set to 7686
[    0.539112] alg: No test for stdrng (krng)
[    0.539130] io scheduler noop registered
[    0.539132] io scheduler anticipatory registered (default)
[    0.539134] io scheduler deadline registered
[    0.539531] io scheduler cfq registered
[    0.539548] pci 0000:00:02.0: Boot video device
[    0.540117] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.540134] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.540759] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.540774] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.541093] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.541108] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.541603] Switched to high resolution mode on CPU 1
[    0.542761] ACPI: AC Adapter [AC] (on-line)
[    0.543172] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    0.543175] ACPI: Power Button [PWRF]
[    0.543372] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[    0.544011] Switched to high resolution mode on CPU 0
[    0.544054] ACPI: Lid Switch [LID]
[    0.544267] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    0.544273] ACPI: Sleep Button [SLPB]
[    0.546481] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050624)
[    0.547936] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050624)
[    0.564931] ACPI Warning (processor_throttling-0843): Invalid throttling=
 state, reset
[    0.564935]  [20090320]
[    0.567058] Monitor-Mwait will be used to enter C-1 state
[    0.567093] Monitor-Mwait will be used to enter C-2 state
[    0.567161] Monitor-Mwait will be used to enter C-3 state
[    0.567172] Marking TSC unstable due to TSC halts in idle
[    0.567286] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.567438] processor ACPI_CPU:00: registered as cooling_device0
[    0.567444] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.569452] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20050624)
[    0.570892] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20050624)
[    0.573310] ACPI Warning (processor_throttling-0843): Invalid throttling=
 state, reset
[    0.573313]  [20090320]
[    0.575343] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.575471] processor ACPI_CPU:01: registered as cooling_device1
[    0.575477] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.628325] thermal LNXTHERM:01: registered as thermal_zone0
[    0.628359] ACPI: Thermal Zone [THM0] (49 C)
[    0.631543] thermal LNXTHERM:02: registered as thermal_zone1
[    0.631570] ACPI: Thermal Zone [THM1] (47 C)
[    0.683220] ACPI: Battery Slot [BAT0] (battery present)
[    0.723485] Linux agpgart interface v0.103
[    3.736020] floppy0: no floppy controllers found
[    3.740586] brd: module loaded
[    3.740588] Uniform Multi-Platform E-IDE driver
[    3.740882] ide-gd driver 1.18
[    3.741315] Driver 'sd' needs updating - please use bus_type methods
[    3.741439] ahci 0000:00:1f.2: version 3.0
[    3.741460] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.741511] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.741550] ahci: SSS flag set, parallel bus scan disabled
[    3.741574] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.741577] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.741582] ahci 0000:00:1f.2: setting latency timer to 64
[    3.741791] scsi0 : ahci
[    3.742498] scsi1 : ahci
[    3.742774] scsi2 : ahci
[    3.743071] scsi3 : ahci
[    3.745143] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    3.745147] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    3.745149] ata3: DUMMY
[    3.745151] ata4: DUMMY
[    3.745700] Fusion MPT base driver 3.04.07
[    3.745702] Copyright (c) 1999-2008 LSI Corporation
[    3.745719] Fusion MPT SPI Host driver 3.04.07
[    3.746137] ieee1394: raw1394: /dev/raw1394 device initialized
[    3.746498] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    3.760540] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.760548] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.761080] mice: PS/2 mouse device common for all mice
[    3.762711] cpuidle: using governor ladder
[    3.764510] cpuidle: using governor menu
[    3.765084] TCP cubic registered
[    3.765087] NET: Registered protocol family 17
[    3.767740] registered taskstats version 1
[    3.768695] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input3
[    4.001105] Clocksource tsc unstable (delta =3D -203151558 ns)
[    4.073172] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.118870] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.118880] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.119002] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.119012] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.119876] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    4.119884] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.129952] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.129962] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.130086] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.130095] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.131020] ata1.00: configured for UDMA/100
[    4.158913] ata1.00: configured for UDMA/100
[    4.158922] ata1: EH complete
[    4.159327] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    4.161240] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.161323] sd 0:0:0:0: [sda] Write Protect is off
[    4.161330] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.161475] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.162095]  sda: sda1 sda2 sda3
[    4.210851] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.305510] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    4.324148] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/seri=
o1/input/input4
[    4.480138] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.522643] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    4.523490] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    4.527176] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[    4.537481] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    4.538337] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    4.542190] ata2.00: configured for UDMA/133
[    4.671560] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[    4.754556] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    4.754722] Freeing unused kernel memory: 424k freed
[    4.755043] Write protecting the kernel read-only data: 4536k
[    8.839744] rtc_cmos 00:07: RTC can wake from S4
[    8.839943] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    8.839979] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.001462] Non-volatile memory driver v1.3
[    9.379136] ACPI: WMI: Mapper loaded
[    9.552317] agpgart-intel 0000:00:00.0: Intel Mobile Intel=AE GM45 Expre=
ss Chipset
[    9.555068] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    9.563253] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    9.702087] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    9.702097] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    9.702199] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    9.702223] e1000e 0000:00:19.0: setting latency timer to 64
[    9.702490] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    9.791630] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    9.791639] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    9.791678] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[   10.229384] cfg80211: Calling CRDA to update world regulatory domain
[   10.426713] usbcore: registered new interface driver usbfs
[   10.426776] usbcore: registered new interface driver hub
[   10.426888] usbcore: registered new device driver usb
[   10.451554] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.453030] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   10.453042] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[   10.453235] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   10.453239] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   10.453357] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[   10.457311] ehci_hcd 0000:00:1a.7: debug port 1
[   10.457317] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   10.457348] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[   10.476101] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   10.476369] usb usb1: configuration #1 chosen from 1 choice
[   10.476454] hub 1-0:1.0: USB hub found
[   10.476469] hub 1-0:1.0: 6 ports detected
[   10.477939] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   10.477956] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[   10.477989] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   10.477993] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   10.478076] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[   10.482028] ehci_hcd 0000:00:1d.7: debug port 1
[   10.482034] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   10.482063] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[   10.500125] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.500391] usb usb2: configuration #1 chosen from 1 choice
[   10.500473] hub 2-0:1.0: USB hub found
[   10.500499] hub 2-0:1.0: 6 ports detected
[   10.650021] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[   10.847525] uhci_hcd: USB Universal Host Controller Interface driver
[   10.857182] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   10.857205] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[   10.857236] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   10.857244] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   10.857514] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[   10.857654] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[   10.858437] usb usb3: configuration #1 chosen from 1 choice
[   10.858669] hub 3-0:1.0: USB hub found
[   10.858736] hub 3-0:1.0: 2 ports detected
[   10.859349] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[   10.859375] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   10.859383] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   10.859585] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[   10.859696] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[   10.860322] usb usb4: configuration #1 chosen from 1 choice
[   10.860567] hub 4-0:1.0: USB hub found
[   10.860606] hub 4-0:1.0: 2 ports detected
[   10.862191] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   10.862214] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[   10.862240] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   10.862248] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   10.862485] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[   10.862597] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[   10.863175] usb usb5: configuration #1 chosen from 1 choice
[   10.863439] hub 5-0:1.0: USB hub found
[   10.863478] hub 5-0:1.0: 2 ports detected
[   10.865635] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   10.865653] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   10.865679] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.865688] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.865947] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[   10.866079] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[   10.866784] usb usb6: configuration #1 chosen from 1 choice
[   10.866988] hub 6-0:1.0: USB hub found
[   10.867026] hub 6-0:1.0: 2 ports detected
[   10.867690] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[   10.867716] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.867724] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.867927] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[   10.868067] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[   10.868760] usb usb7: configuration #1 chosen from 1 choice
[   10.869016] hub 7-0:1.0: USB hub found
[   10.869055] hub 7-0:1.0: 2 ports detected
[   10.869711] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[   10.869737] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.869745] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.869921] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[   10.870034] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[   10.870625] usb usb8: configuration #1 chosen from 1 choice
[   10.870828] hub 8-0:1.0: USB hub found
[   10.870880] hub 8-0:1.0: 2 ports detected
[   10.896113] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 3
[   11.028984] usb 1-5: configuration #1 chosen from 1 choice
[   11.029392] hub 1-5:1.0: USB hub found
[   11.029584] hub 1-5:1.0: 4 ports detected
[   11.141093] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 4
[   11.193555] Driver 'sr' needs updating - please use bus_type methods
[   11.205698] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[   11.205710] Uniform CD-ROM driver Revision: 3.20
[   11.206318] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   11.282277] usb 1-6: configuration #1 chosen from 1 choice
[   11.396086] usb 2-6: new high speed USB device using ehci_hcd and addres=
s 2
[   11.539896] usb 2-6: configuration #1 chosen from 1 choice
[   11.653056] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 2
[   11.653611] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[   11.653618] thinkpad_acpi: http://ibm-acpi.sf.net/
[   11.653624] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[   11.653630] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[   11.655275] thinkpad_acpi: radio switch found; radios are enabled
[   11.656201] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[   11.656209] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[   11.689372] Registered led device: tpacpi::thinklight
[   11.689682] Registered led device: tpacpi::power
[   11.689824] Registered led device: tpacpi::standby
[   11.693602] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[   11.694223] input: ThinkPad Extra Buttons as /devices/virtual/input/inpu=
t5
[   11.828349] usb 4-1: configuration #1 chosen from 1 choice
[   11.828851] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.829160] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   11.852540] usbcore: registered new interface driver libusual
[   11.957125] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[   11.957135] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[   11.957312] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   11.957328] iwlagn 0000:03:00.0: setting latency timer to 64
[   11.957674] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[   11.977183] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[   11.977301] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[   12.145060] Initializing USB Mass Storage driver...
[   12.145520] scsi4 : SCSI emulation for USB Mass Storage devices
[   12.146013] usb-storage: device found at 2
[   12.146020] usb-storage: waiting for device to settle before scanning
[   12.146122] usbcore: registered new interface driver usb-storage
[   12.146153] USB Mass Storage support registered.
[   12.252146] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.596696] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   12.596921] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.690692] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/input/input6
[   12.691213] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/inp=
ut/input7
[   12.691664] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/inp=
ut/input8
[   12.692108] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/input/input9
[   17.145160] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   17.146086] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   17.150999] usb-storage: device scan complete
[   17.318878] sd 4:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96 G=
B/3.69 GiB)
[   17.319622] sd 4:0:0:0: [sdb] Write Protect is off
[   17.319630] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   17.319636] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   17.322454] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   17.322591]  sdb: sdb1
[   17.325294] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   19.491382] loop: module loaded
[   19.965488] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   25.208051] Intel AES-NI instructions are not detected.
[   60.774604] fuse init (API version 7.11)
[   64.756571] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   64.812214] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   67.824928] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[   75.821179] NET: Registered protocol family 10
[   75.824149] lo: Disabled Privacy Extensions
[   78.075485] Loading iSCSI transport class v2.0-870.
[   78.167844] iscsi: registered transport (tcp)
[   78.459587] iscsi: registered transport (iser)
[   86.752105] eth0: no IPv6 routers present
[   87.510396] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   87.510631] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   87.626835] input: /usr/sbin/thinkpad-keys as /devices/virtual/input/inp=
ut10
[   88.838568] RPC: Registered udp transport module.
[   88.838720] RPC: Registered tcp transport module.
[   89.121374] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   89.291589] svc: failed to register lockdv1 RPC service (errno 97).
[   89.295534] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   89.312322] NFSD: starting 90-second grace period
[   98.267352] Bluetooth: Core ver 2.15
[   98.270531] NET: Registered protocol family 31
[   98.270675] Bluetooth: HCI device and connection manager initialized
[   98.270824] Bluetooth: HCI socket layer initialized
[   98.342444] Bluetooth: L2CAP ver 2.13
[   98.342589] Bluetooth: L2CAP socket layer initialized
[   98.410174] Bluetooth: RFCOMM socket layer initialized
[   98.410379] Bluetooth: RFCOMM TTY layer initialized
[   98.410524] Bluetooth: RFCOMM ver 1.11
[  103.061679] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[  103.087303] ip_tables: (C) 2000-2006 Netfilter Core Team
[  103.439449] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[  103.686328] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  106.716528] wlan0: authenticate with AP 00:03:52:1c:18:71
[  106.718503] wlan0: authenticated
[  106.718512] wlan0: associate with AP 00:03:52:1c:18:71
[  106.916177] wlan0: associate with AP 00:03:52:1c:18:71
[  106.918120] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D1 aid=3D0)
[  106.918128] wlan0: AP denied association (code=3D1)
[  107.116202] wlan0: associate with AP 00:03:52:1c:18:71
[  107.118167] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D1 aid=3D0)
[  107.118174] wlan0: AP denied association (code=3D1)
[  107.316128] wlan0: association with AP 00:03:52:1c:18:71 timed out
[  131.832717] [drm] Initialized drm 1.1.0 20060810
[  132.079759] pci 0000:00:02.0: power state changed by ACPI to D0
[  132.079782] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  132.079794] pci 0000:00:02.0: setting latency timer to 64
[  132.163211] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[  132.185373] acpi device:03: registered as cooling_device2
[  132.187301] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/device:02/input/input11
[  132.187607] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[  132.187886] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[  133.089364] set status page addr 0x08da0000
[  243.192345] iwlagn 0000:03:00.0: PCI INT A disabled
[  243.304966] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[  243.304971] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[  243.305090] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  243.305122] iwlagn 0000:03:00.0: setting latency timer to 64
[  243.305210] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[  243.337281] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[  243.337366] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[  243.338184] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  245.441513] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[  245.493091] iwlagn 0000:03:00.0: loaded firmware version 5.4.1.16
[  245.737314] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  249.867702] wlan0: authenticate with AP 00:03:52:1c:18:71
[  249.875512] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  249.878565] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  249.905107] wlan0: authenticated
[  249.905116] wlan0: associate with AP 00:03:52:4d:bd:c1
[  249.907466] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  249.907473] wlan0: associated
[  249.914879] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  249.920414] wlan0: disassociating by local choice (reason=3D3)
[  249.935823] wlan0: authenticate with AP 00:03:52:1c:18:71
[  250.026193] wlan0: authenticate with AP 00:03:52:1c:18:71
[  250.030259] wlan0: authenticate with AP 00:03:52:1c:18:71
[  250.030313] wlan0: authenticated
[  250.030319] wlan0: associate with AP 00:03:52:1c:18:71
[  250.054947] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  250.054955] wlan0: associated
[  250.061078] wlan0: disassociating by local choice (reason=3D3)
[  250.076398] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  250.182475] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  250.183507] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  250.380163] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  250.580141] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  250.592714] wlan0: authenticated
[  250.592723] wlan0: associate with AP 00:03:52:1b:f8:31
[  250.594870] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  250.594878] wlan0: associated
[  250.601994] wlan0: disassociating by local choice (reason=3D3)
[  250.707306] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  250.709306] wlan0: authenticated
[  250.709313] wlan0: associate with AP 00:03:52:4e:f3:d1
[  250.711452] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  250.711459] wlan0: associated
[  250.718720] wlan0: disassociating by local choice (reason=3D3)
[  250.735506] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  250.821948] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  250.826518] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  251.025062] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  251.224137] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  251.424129] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  255.841558] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  256.040202] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  256.240149] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  256.242222] wlan0: authenticated
[  256.242229] wlan0: associate with AP 00:03:52:4d:e7:91
[  256.440150] wlan0: associate with AP 00:03:52:4d:e7:91
[  256.443936] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  256.443943] wlan0: associated
[  256.446729] wlan0: disassociating by local choice (reason=3D3)
[  256.553761] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  256.752142] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  256.952094] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  257.152186] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  260.584113] wlan0: no IPv6 routers present
[  261.561636] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  261.562739] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  261.760119] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  261.960149] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  262.160134] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  268.349488] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[  268.404268] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[  268.406199] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  271.300946] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[  271.302384] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  272.598680] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  272.600594] wlan0: authenticated
[  272.600602] wlan0: associate with AP 00:03:52:4d:bd:c1
[  272.602832] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  272.602841] wlan0: associated
[  272.607497] wlan0: disassociating by local choice (reason=3D3)
[  272.624720] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  272.722140] wlan0: authenticate with AP 00:03:52:1c:18:71
[  272.725094] wlan0: authenticated
[  272.725102] wlan0: associate with AP 00:03:52:1c:18:71
[  272.925079] wlan0: associate with AP 00:03:52:1c:18:71
[  272.927241] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  272.927248] wlan0: associated
[  272.938773] wlan0: disassociating by local choice (reason=3D3)
[  273.066995] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  273.264150] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  273.265931] wlan0: authenticated
[  273.265938] wlan0: associate with AP 00:03:52:1b:f8:31
[  273.268168] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  273.268175] wlan0: associated
[  273.278407] wlan0: disassociating by local choice (reason=3D3)
[  273.388504] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  273.390481] wlan0: authenticated
[  273.390488] wlan0: associate with AP 00:03:52:4d:d3:21
[  273.392643] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  273.392650] wlan0: associated
[  273.401201] wlan0: disassociating by local choice (reason=3D3)
[  273.523516] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  273.720169] wlan0: direct probe to AP 00:03:52:1c:33:01 try 2
[  273.920138] wlan0: direct probe to AP 00:03:52:1c:33:01 try 3
[  274.120235] wlan0: direct probe to AP 00:03:52:1c:33:01 timed out
[  278.531192] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  278.534987] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  278.538292] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  278.736169] wlan0: direct probe to AP 00:03:52:1c:33:01 try 2
[  278.936089] wlan0: direct probe to AP 00:03:52:1c:33:01 try 3
[  279.136134] wlan0: direct probe to AP 00:03:52:1c:33:01 timed out
[  281.428095] eth0: no IPv6 routers present
[  286.710174] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  286.908162] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  286.909937] wlan0: authenticated
[  286.909943] wlan0: associate with AP 00:03:52:4d:bd:c1
[  286.912246] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  286.912253] wlan0: associated
[  286.921805] wlan0: disassociating by local choice (reason=3D3)
[  287.030333] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  287.034216] wlan0 direct probe responded
[  287.034224] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  287.039292] wlan0: authenticated
[  287.039299] wlan0: associate with AP 00:03:52:4d:bd:c1
[  287.041453] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  287.041461] wlan0: associated
[  287.050919] wlan0: disassociating by local choice (reason=3D3)
[  287.063840] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  287.163396] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  287.165252] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  287.168459] wlan0 direct probe responded
[  287.168467] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  287.368124] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  287.568130] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  287.577169] wlan0: authenticated
[  287.577176] wlan0: associate with AP 00:03:52:1b:f8:31
[  287.579328] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  287.579335] wlan0: associated
[  287.581779] wlan0: disassociating by local choice (reason=3D3)
[  287.598308] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  287.701966] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  287.705256] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  287.904087] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  288.104085] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  288.304067] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  292.707890] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  292.710858] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  292.712835] wlan0: authenticated
[  292.712842] wlan0: associate with AP 00:03:52:4d:d3:21
[  292.714941] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  292.714948] wlan0: associated
[  292.720727] wlan0: disassociating by local choice (reason=3D3)
[  292.826256] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  292.828167] wlan0: authenticated
[  292.828174] wlan0: associate with AP 00:03:52:4d:e7:91
[  292.830317] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  292.830324] wlan0: associated
[  292.836866] wlan0: disassociating by local choice (reason=3D3)
[  292.984590] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  293.184127] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  293.384162] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  293.584150] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  297.963051] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  297.965450] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  297.968090] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  298.169097] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  298.368077] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  298.568172] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  298.573125] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  298.772129] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  298.972127] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  299.172125] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  306.494530] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  306.501658] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  306.502820] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  306.506092] wlan0 direct probe responded
[  306.506099] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  306.704128] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  306.706096] wlan0: authenticated
[  306.706103] wlan0: associate with AP 00:03:52:4d:bd:c1
[  306.708396] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  306.708403] wlan0: associated
[  306.716363] wlan0: disassociating by local choice (reason=3D3)
[  306.833643] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  306.836845] wlan0 direct probe responded
[  306.836852] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  307.036136] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  307.237095] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  307.238917] wlan0: authenticated
[  307.238925] wlan0: associate with AP 00:03:52:1b:f8:31
[  307.241020] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  307.241028] wlan0: associated
[  307.245698] wlan0: disassociating by local choice (reason=3D3)
[  307.352593] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  307.354779] wlan0 direct probe responded
[  307.354787] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  307.357426] wlan0: authenticated
[  307.357435] wlan0: associate with AP 00:03:52:4d:d3:21
[  307.556151] wlan0: associate with AP 00:03:52:4d:d3:21
[  307.558282] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  307.558289] wlan0: associated
[  307.565312] wlan0: disassociating by local choice (reason=3D3)
[  307.579752] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  307.670397] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  307.672027] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  307.873135] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  308.073092] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  308.272165] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  312.679936] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  312.685298] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  312.687123] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  312.884107] wlan0: direct probe to AP 00:03:52:1c:33:01 try 2
[  313.084148] wlan0: direct probe to AP 00:03:52:1c:33:01 try 3
[  313.284143] wlan0: direct probe to AP 00:03:52:1c:33:01 timed out
[  323.797684] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  323.799650] wlan0: authenticated
[  323.799657] wlan0: associate with AP 00:03:52:4d:bd:c1
[  323.801763] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  323.801770] wlan0: associated
[  323.812524] wlan0: disassociating by local choice (reason=3D3)
[  323.934135] wlan0: authenticate with AP 00:03:52:1c:18:71
[  323.936354] wlan0: authenticated
[  323.936361] wlan0: associate with AP 00:03:52:1c:18:71
[  323.938518] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  323.938526] wlan0: associated
[  323.945743] wlan0: disassociating by local choice (reason=3D3)
[  323.960781] wlan0: authenticate with AP 00:03:52:1b:f5:b1
[  324.054221] wlan0: direct probe to AP 00:03:52:1c:18:71 try 1
[  324.056421] wlan0 direct probe responded
[  324.056428] wlan0: authenticate with AP 00:03:52:1c:18:71
[  324.253160] wlan0: authenticate with AP 00:03:52:1c:18:71
[  324.256923] wlan0: authenticated
[  324.256931] wlan0: associate with AP 00:03:52:1c:18:71
[  324.259213] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  324.259220] wlan0: associated
[  324.264861] wlan0: disassociating by local choice (reason=3D3)
[  324.280797] wlan0: authenticate with AP 00:03:52:1b:f5:b1
[  324.385768] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  324.387535] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  324.584109] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  324.585906] wlan0: authenticated
[  324.585914] wlan0: associate with AP 00:03:52:1b:f8:31
[  324.588001] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  324.588030] wlan0: associated
[  324.595307] wlan0: disassociating by local choice (reason=3D3)
[  324.700732] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  324.900098] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[  325.101037] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 3
[  325.300124] wlan0: direct probe to AP 00:03:52:4d:de:d1 timed out
[  329.715946] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  329.718105] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  329.916124] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  330.116184] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  330.316216] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  337.623924] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  337.632277] wlan0: direct probe to AP 00:03:52:4d:bd:c1 try 1
[  337.632347] wlan0 direct probe responded
[  337.632353] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  337.635024] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  337.636961] wlan0: authenticated
[  337.636969] wlan0: associate with AP 00:03:52:4d:bd:c1
[  337.642619] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  337.642626] wlan0: associated
[  337.650356] wlan0: disassociating by local choice (reason=3D3)
[  337.661561] wlan0: direct probe to AP 00:03:52:4e:f3:d1 try 1
[  337.773437] wlan0: direct probe to AP 00:03:52:1c:18:71 try 1
[  337.775165] wlan0: direct probe to AP 00:03:52:1c:18:71 try 1
[  337.777321] wlan0 direct probe responded
[  337.777328] wlan0: authenticate with AP 00:03:52:1c:18:71
[  337.780326] wlan0: authenticated
[  337.780335] wlan0: associate with AP 00:03:52:1c:18:71
[  337.980123] wlan0: associate with AP 00:03:52:1c:18:71
[  337.982278] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  337.982286] wlan0: associated
[  337.985576] wlan0: disassociating by local choice (reason=3D3)
[  338.071656] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  338.268137] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[  338.272351] wlan0 direct probe responded
[  338.272358] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  338.473069] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  338.672113] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  338.673834] wlan0: authenticated
[  338.673838] wlan0: associate with AP 00:03:52:1b:f8:31
[  338.675903] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  338.675907] wlan0: associated
[  338.681435] wlan0: disassociating by local choice (reason=3D3)
[  338.784358] wlan0: direct probe to AP 00:03:52:4e:f3:d1 try 1
[  338.788689] wlan0 direct probe responded
[  338.788693] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  338.790541] wlan0: authenticated
[  338.790548] wlan0: associate with AP 00:03:52:4e:f3:d1
[  338.988165] wlan0: associate with AP 00:03:52:4e:f3:d1
[  338.990295] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  338.990302] wlan0: associated
[  338.996647] wlan0: disassociating by local choice (reason=3D3)
[  339.010389] wlan0: direct probe to AP 00:03:52:1c:62:01 try 1
[  339.120804] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  339.123792] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  339.320138] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  339.520152] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  339.720143] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  344.132579] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  344.332174] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  344.532205] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  344.547324] wlan0 direct probe responded
[  344.547331] wlan0: authenticate with AP 00:03:52:1b:f5:b1
[  344.744145] wlan0: authenticate with AP 00:03:52:1b:f5:b1
[  344.944127] wlan0: authenticate with AP 00:03:52:1b:f5:b1
[  345.144147] wlan0: authentication with AP 00:03:52:1b:f5:b1 timed out
[  352.169873] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  352.171857] wlan0: authenticated
[  352.171866] wlan0: associate with AP 00:03:52:4d:bd:c1
[  352.179470] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  352.181406] wlan0: authenticated
[  352.181414] wlan0: associate with AP 00:03:52:4d:bd:c1
[  352.183670] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  352.183677] wlan0: associated
[  352.224650] wlan0: disassociating by local choice (reason=3D3)
[  352.238976] wlan0: direct probe to AP 00:03:52:1c:62:01 try 1
[  352.345866] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  352.347570] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  352.544136] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  352.548577] wlan0: authenticated
[  352.548586] wlan0: associate with AP 00:03:52:1b:f8:31
[  352.550684] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  352.550692] wlan0: associated
[  352.557194] wlan0: disassociating by local choice (reason=3D3)
[  352.574607] wlan0: direct probe to AP 00:03:52:1c:62:01 try 1
[  352.684474] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  352.691079] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  352.692993] wlan0: authenticated
[  352.693000] wlan0: associate with AP 00:03:52:4d:d3:21
[  352.716148] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  352.716157] wlan0: associated
[  352.725244] wlan0: disassociating by local choice (reason=3D3)
[  352.740472] wlan0: direct probe to AP 00:03:52:1c:62:01 try 1
[  352.834611] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  352.835737] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  352.837365] wlan0: authenticated
[  352.837373] wlan0: associate with AP 00:03:52:4e:f3:d1
[  353.037040] wlan0: associate with AP 00:03:52:4e:f3:d1
[  353.039661] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  353.039669] wlan0: associated
[  353.046670] wlan0: disassociating by local choice (reason=3D3)
[  353.066639] wlan0: direct probe to AP 00:03:52:1c:62:01 try 1
[  353.181290] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  353.184152] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  353.385078] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  353.585076] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  353.785071] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  358.187295] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  358.188403] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  358.389079] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  358.390856] wlan0: authenticated
[  358.390863] wlan0: associate with AP 00:03:52:4d:e7:91
[  358.393358] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  358.393366] wlan0: associated
[  358.400222] wlan0: disassociating by local choice (reason=3D3)
[  358.508583] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  358.708147] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  358.908152] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  359.108055] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  363.524646] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  363.525656] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  363.724131] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  363.924143] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  364.124190] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  374.587026] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  374.588954] wlan0: authenticated
[  374.588961] wlan0: associate with AP 00:03:52:4d:bd:c1
[  374.591137] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  374.591145] wlan0: associated
[  374.596094] wlan0: disassociating by local choice (reason=3D3)
[  374.715554] wlan0: authenticate with AP 00:03:52:1c:18:71
[  374.717563] wlan0: authenticated
[  374.717570] wlan0: associate with AP 00:03:52:1c:18:71
[  374.916135] wlan0: associate with AP 00:03:52:1c:18:71
[  374.918303] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  374.918311] wlan0: associated
[  374.927485] wlan0: disassociating by local choice (reason=3D3)
[  374.938336] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  375.049804] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  375.051799] wlan0: authenticated
[  375.051806] wlan0: associate with AP 00:03:52:4d:d3:21
[  375.053982] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  375.053990] wlan0: associated
[  375.060938] wlan0: disassociating by local choice (reason=3D3)
[  375.078436] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  375.184711] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  375.187675] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  375.384161] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  375.385949] wlan0: authenticated
[  375.385956] wlan0: associate with AP 00:03:52:1b:f8:31
[  375.388177] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  375.388184] wlan0: associated
[  375.394803] wlan0: disassociating by local choice (reason=3D3)
[  375.424086] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  375.522637] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  375.527645] wlan0: authenticated
[  375.527653] wlan0: associate with AP 00:03:52:4e:f3:d1
[  375.724184] wlan0: associate with AP 00:03:52:4e:f3:d1
[  375.726351] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  375.726359] wlan0: associated
[  375.738386] wlan0: disassociating by local choice (reason=3D3)
[  375.752747] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  375.846762] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  375.847916] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  376.044153] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  376.244103] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  376.444204] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  380.853754] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  380.856517] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  380.858123] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  381.056136] wlan0: direct probe to AP 00:03:52:1c:33:01 try 2
[  381.256153] wlan0: direct probe to AP 00:03:52:1c:33:01 try 3
[  381.456182] wlan0: direct probe to AP 00:03:52:1c:33:01 timed out
[  388.929721] wlan0: authenticate with AP 00:03:52:4d:bd:c1
[  388.931718] wlan0: authenticated
[  388.931724] wlan0: associate with AP 00:03:52:4d:bd:c1
[  388.933883] wlan0: RX AssocResp from 00:03:52:4d:bd:c1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  388.933891] wlan0: associated
[  388.939456] wlan0: disassociating by local choice (reason=3D3)
[  388.952864] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  389.067526] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  389.071041] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  389.071096] wlan0: authenticated
[  389.071102] wlan0: associate with AP 00:03:52:4d:d3:21
[  389.095730] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  389.095737] wlan0: associated
[  389.103784] wlan0: disassociating by local choice (reason=3D3)
[  389.225326] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  389.424111] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
[  389.428854] wlan0 direct probe responded
[  389.428862] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  389.628091] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  389.828163] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  389.829959] wlan0: authenticated
[  389.829967] wlan0: associate with AP 00:03:52:1b:f8:31
[  389.834193] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  389.834201] wlan0: associated
[  389.841119] wlan0: disassociating by local choice (reason=3D3)
[  389.861155] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  389.967657] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  389.968882] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  390.168312] wlan0: authenticate with AP 00:03:52:4e:f3:d1
[  390.170459] wlan0: authenticated
[  390.170467] wlan0: associate with AP 00:03:52:4e:f3:d1
[  390.172608] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  390.172615] wlan0: associated
[  390.177104] wlan0: disassociating by local choice (reason=3D3)
[  390.315294] wlan0: direct probe to AP 00:03:52:1c:33:01 try 1
[  390.512205] wlan0: direct probe to AP 00:03:52:1c:33:01 try 2
[  390.712146] wlan0: direct probe to AP 00:03:52:1c:33:01 try 3
[  390.912076] wlan0: direct probe to AP 00:03:52:1c:33:01 timed out
[  395.324064] wlan0: direct probe to AP 00:03:52:1c:18:71 try 1
[  395.325229] wlan0: authenticate with AP 00:03:52:1c:18:71
[  395.328490] wlan0: authenticate with AP 00:03:52:1c:18:71
[  395.328543] wlan0: authenticated
[  395.328549] wlan0: associate with AP 00:03:52:1c:18:71
[  395.352226] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  395.352235] wlan0: associated
[  395.359441] wlan0: disassociating by local choice (reason=3D3)
[  395.482941] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  395.680143] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  395.682917] wlan0: authenticated
[  395.682924] wlan0: associate with AP 00:03:52:4d:e7:91
[  395.686423] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  395.686431] wlan0: associated
[  395.693823] wlan0: disassociating by local choice (reason=3D3)
[  395.708033] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  395.801836] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  395.803411] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  396.000123] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[  396.200069] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 3
[  396.400130] wlan0: direct probe to AP 00:03:52:4d:de:d1 timed out
[  400.817905] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  400.818993] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  400.820614] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  401.016166] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 2
[  401.216118] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 3
[  401.416096] wlan0: direct probe to AP 00:03:52:4d:de:d1 timed out
[  408.794213] wlan0: direct probe to AP 00:03:52:1c:18:71 try 1
[  408.796442] wlan0 direct probe responded
[  408.796448] wlan0: authenticate with AP 00:03:52:1c:18:71
[  408.996141] wlan0: authenticate with AP 00:03:52:1c:18:71
[  408.997923] wlan0: authenticated
[  408.997931] wlan0: associate with AP 00:03:52:1c:18:71
[  409.000149] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  409.000157] wlan0: associated
[  409.007339] wlan0: disassociating by local choice (reason=3D3)
[  409.117396] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
[  409.119599] wlan0 direct probe responded
[  409.119606] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  409.316133] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  409.516134] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  409.524343] wlan0: authenticated
[  409.524351] wlan0: associate with AP 00:03:52:1b:f8:31
[  409.526509] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D3)
[  409.526516] wlan0: associated
[  409.566601] wlan0: disassociating by local choice (reason=3D3)
[  409.688578] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  409.888131] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  410.088128] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  410.288098] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  414.694076] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  414.696813] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  414.698556] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 1
[  414.896131] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 2
[  415.096126] wlan0: direct probe to AP 00:03:52:1b:f5:b1 try 3
[  415.296122] wlan0: direct probe to AP 00:03:52:1b:f5:b1 timed out
[  422.718814] wlan0: authenticate with AP 00:03:52:1c:18:71
[  422.725523] wlan0: authenticate with AP 00:03:52:1c:18:71
[  422.727533] wlan0: authenticated
[  422.727540] wlan0: associate with AP 00:03:52:1c:18:71
[  422.735012] wlan0: RX AssocResp from 00:03:52:1c:18:71 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  422.735020] wlan0: associated
[  422.739230] wlan0: disassociating by local choice (reason=3D3)
[  422.863619] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  422.865551] wlan0: authenticated
[  422.865558] wlan0: associate with AP 00:03:52:1b:f8:31
[  422.867693] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  422.867701] wlan0: associated
[  422.876858] wlan0: disassociating by local choice (reason=3D3)
[  423.001185] wlan0: authenticate with AP 00:03:52:4d:e7:91
[  423.003129] wlan0: authenticated
[  423.003135] wlan0: associate with AP 00:03:52:4d:e7:91
[  423.005298] wlan0: RX AssocResp from 00:03:52:4d:e7:91 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  423.005305] wlan0: associated
[  423.013260] wlan0: disassociating by local choice (reason=3D3)
[  423.028675] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  423.122049] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  423.123203] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  423.320184] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  423.323848] wlan0: authenticated
[  423.323856] wlan0: associate with AP 00:03:52:4d:d3:21
[  423.327331] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  423.327340] wlan0: associated
[  423.332676] wlan0: disassociating by local choice (reason=3D3)
[  423.349448] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  423.455193] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  423.456395] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 1
[  423.656049] wlan0: direct probe to AP 00:03:52:4d:d3:21 try 2
[  423.659169] wlan0 direct probe responded
[  423.659176] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  423.660980] wlan0: authenticated
[  423.660986] wlan0: associate with AP 00:03:52:4d:d3:21
[  423.860142] wlan0: associate with AP 00:03:52:4d:d3:21
[  423.862331] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  423.862338] wlan0: associated
[  423.868642] wlan0: disassociating by local choice (reason=3D3)
[  423.976704] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 1
[  424.176168] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 2
[  424.376153] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 3
[  424.576135] wlan0: direct probe to AP 00:03:52:4d:e8:81 timed out
[  428.985679] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 1
[  428.987448] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 1
[  428.989170] wlan0: direct probe to AP 00:03:52:4d:e8:81 try 1
[  428.993567] wlan0 direct probe responded
[  428.993574] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  429.192139] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  429.392181] wlan0: authenticate with AP 00:03:52:4d:e8:81
[  429.393959] wlan0: authenticated
[  429.393968] wlan0: associate with AP 00:03:52:4d:e8:81
[  429.592160] wlan0: associate with AP 00:03:52:4d:e8:81
[  429.594317] wlan0: RX AssocResp from 00:03:52:4d:e8:81 (capab=3D0x421 st=
atus=3D0 aid=3D1)
[  429.594325] wlan0: associated
[  429.599706] wlan0: disassociating by local choice (reason=3D3)
[  429.610444] wlan0: direct probe to AP 00:03:52:4d:de:d1 try 1
[  429.724924] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[  429.728169] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[  429.928094] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[  430.128121] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[  430.328079] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[  434.731513] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[  434.736490] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[  434.741711] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 1
[  434.940071] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 2
[  435.140186] wlan0: direct probe to AP 00:03:52:1b:f4:e1 try 3
[  435.340181] wlan0: direct probe to AP 00:03:52:1b:f4:e1 timed out
[  445.752641] wlan0: authenticate with AP 00:03:52:1b:f8:31
[  445.754630] wlan0: authenticated
[  445.754638] wlan0: associate with AP 00:03:52:1b:f8:31
[  445.756740] wlan0: RX AssocResp from 00:03:52:1b:f8:31 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  445.756747] wlan0: associated
[  445.762269] wlan0: disassociating by local choice (reason=3D3)
[  445.895523] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  445.897522] wlan0: authenticated
[  445.897529] wlan0: associate with AP 00:03:52:4d:d3:21
[  445.899689] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  445.899696] wlan0: associated
[  445.910408] wlan0: disassociating by local choice (reason=3D3)
[  446.018024] wlan0: authenticate with AP 00:03:52:4d:e4:f1
[  446.216156] wlan0: authenticate with AP 00:03:52:4d:e4:f1
[  446.416138] wlan0: authenticate with AP 00:03:52:4d:e4:f1
[  446.616081] wlan0: authentication with AP 00:03:52:4d:e4:f1 timed out
[  448.065142] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 1
[  448.066739] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 1
[  448.067828] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 1
[  448.264187] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 2
[  448.464148] wlan0: direct probe to AP 00:03:52:4d:e4:f1 try 3
[  448.664093] wlan0: direct probe to AP 00:03:52:4d:e4:f1 timed out
[  456.107311] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  456.112318] wlan0: authenticate with AP 00:03:52:4d:d3:21
[  456.114225] wlan0: authenticated
[  456.114228] wlan0: associate with AP 00:03:52:4d:d3:21
[  456.116339] wlan0: RX AssocResp from 00:03:52:4d:d3:21 (capab=3D0x421 st=
atus=3D0 aid=3D2)
[  456.116342] wlan0: associated
[  456.119940] wlan0: disassociating by local choice (reason=3D3)
[  456.227895] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  456.424181] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  456.624142] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  456.824178] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out
[  461.234932] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  461.236122] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 1
[  461.437089] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 2
[  461.637170] wlan0: direct probe to AP 00:03:52:4d:c1:81 try 3
[  461.836162] wlan0: direct probe to AP 00:03:52:4d:c1:81 timed out

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--OwLcNYc0lM97+oe1
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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

--OwLcNYc0lM97+oe1--

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoaRwEACgkQuL75KpiFGIwmQACeM2yMA5bxvQ4w6kMpvlioD674
ibgAnid1mrJzjt7w6V/PP/m+/RYBtX9L
=kdEN
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
