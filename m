Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbZE0Lxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbZE0Lxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762206AbZE0Lxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:53:42 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:43000 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761577AbZE0Lxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:53:30 -0400
Date: Wed, 27 May 2009 13:53:25 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: BUGs: linux-next: Tree for May 27
Message-ID: <20090527115325.GA6790@ikn.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090527181536.4c453593.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
In-Reply-To: <20090527181536.4c453593.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7-next-20090527-06291-gc0f66c0 x86_64)
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

Stephen Rothwell [Wed, May 27, 2009 at 06:15:36PM +1000]:
> Changes since 20090526:

Works on amd64 (x200), but reports some bugs.

dmesg, config, uname:

Linux ikn 2.6.30-rc7-next-20090527-06291-gc0f66c0 #47 SMP PREEMPT Wed May 2=
7 12:58:10 CEST 2009 x86_64 GNU/Linux

[    0.000000] Linux version 2.6.30-rc7-next-20090527-06291-gc0f66c0 (compi=
ler@ikn) (gcc version 4.3.3 (Debian 4.3.3-3) ) #47 SMP PREEMPT Wed May 27 1=
2:58:10 CEST 2009
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-rc7-next-200=
90527-06291-gc0f66c0 root=3D/dev/sda1 ro quiet
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
[    0.000000]   #2 [0000200000 - 000073321c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 000073321c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [0000734000 - 000073414c]              BRK =3D=3D> [000=
0734000 - 000073414c]
[    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #6 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f73e0] f73e0
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
[    0.000000]   DMA zone: 1434 pages reserved
[    0.000000]   DMA zone: 2508 pages, LIFO batch:0
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
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000=
:20000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages at ffff880028023000, static data 6=
8704 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1002317
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.30-rc7-n=
ext-20090527-06291-gc0f66c0 root=3D/dev/sda1 ro quiet
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.805 MHz processor.
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
[    0.004000] Memory: 3949552k/5177344k available (2900k kernel code, 1091=
556k absent, 135328k reserved, 1411k data, 368k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4521.61 BogoMIPS (lpj=3D9043220)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] [ds] sizes: address: 64 bit, bts/pebs record: 24/144 bytes
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20090422
[    0.020046] Setting APIC routing to flat
[    0.020355] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.061187] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4521.91 Bog=
oMIPS (lpj=3D9043826)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.148507] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.148515] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.152018] Brought up 2 CPUs
[    0.152021] Total of 2 processors activated (9043.52 BogoMIPS).
[    0.152092] devtmpfs: initialized
[    0.152097] regulator: core version 0.5
[    0.152097] NET: Registered protocol family 16
[    0.152097] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.152097] ACPI: bus type pci registered
[    0.152097] PCI: Using configuration type 1 for base access
[    0.152097] bio: create slab <bio-0> at 0
[    0.157016] ACPI: EC: EC description table is found, configuring boot EC
[    0.164638] ACPI: BIOS _OSI(Linux) query ignored
[    0.164016] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.188491] ACPI: Interpreter enabled
[    0.188494] ACPI: (supports S0 S3 S5)
[    0.188513] ACPI: Using IOAPIC for interrupt routing
[    0.221199] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.221199] ACPI: EC: driver started in interrupt mode
[    0.221199] ACPI: Power Resource [PUBS] (on)
[    0.224906] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.225298] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.225329] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.225329] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.225329] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.225329] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.225329] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.225329] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.225329] pci 0000:00:03.0: PME# disabled
[    0.228058] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.228065] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.228072] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.228119] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.228123] pci 0000:00:19.0: PME# disabled
[    0.228181] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.228263] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.228345] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.228431] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.228494] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.228499] pci 0000:00:1a.7: PME# disabled
[    0.228546] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.228595] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.228599] pci 0000:00:1b.0: PME# disabled
[    0.228666] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.228670] pci 0000:00:1c.0: PME# disabled
[    0.228740] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.228744] pci 0000:00:1c.1: PME# disabled
[    0.228814] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.228818] pci 0000:00:1c.3: PME# disabled
[    0.228884] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.228966] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.229048] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.229133] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.229197] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.229201] pci 0000:00:1d.7: PME# disabled
[    0.229409] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.229415] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.229421] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.229428] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.229434] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.229441] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.229479] pci 0000:00:1f.2: PME# supported from D3hot
[    0.229482] pci 0000:00:1f.2: PME# disabled
[    0.229516] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.229532] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.229686] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.229788] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.229794] pci 0000:03:00.0: PME# disabled
[    0.229857] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.229910] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.229914] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.229920] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.229985] pci 0000:00:1e.0: transparent bridge
[    0.230015] pci_bus 0000:00: on NUMA node 0
[    0.230023] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.230189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.230266] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.230344] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.236214] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.236388] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.236609] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.236830] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237050] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237271] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237492] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237712] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.237800] SCSI subsystem initialized
[    0.237800] libata version 3.00 loaded.
[    0.237800] PCI: Using ACPI for IRQ routing
[    0.256016] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.256021] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.260757] Failed to register trace events module notifier
[    0.280007] pnp: PnP ACPI init
[    0.280017] ACPI: bus type pnp registered
[    0.341555] pnp: PnP ACPI: found 10 devices
[    0.341557] ACPI: ACPI bus type pnp unregistered
[    0.341566] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.341569] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.341571] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.341574] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.341576] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.341579] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.341582] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.341585] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.341587] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.341590] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.341592] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.341595] system 00:00: iomem range 0x100000-0xbfffffff could not be r=
eserved
[    0.341598] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.341601] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.341608] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.341610] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.341613] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.341616] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.341618] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.341621] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.341623] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.341626] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.341629] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.341632] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.341635] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.341638] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.341641] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.346613] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.346615] pci 0000:00:1c.0:   IO window: disabled
[    0.346620] pci 0000:00:1c.0:   MEM window: disabled
[    0.346623] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.346628] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.346629] pci 0000:00:1c.1:   IO window: disabled
[    0.346634] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.346638] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.346642] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.346645] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.346651] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.346655] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.346662] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.346663] pci 0000:00:1e.0:   IO window: disabled
[    0.346668] pci 0000:00:1e.0:   MEM window: disabled
[    0.346671] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.346682]   alloc irq_desc for 20 on node -1
[    0.346684]   alloc kstat_irqs on node -1
[    0.346688] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.346693] pci 0000:00:1c.0: setting latency timer to 64
[    0.346700]   alloc irq_desc for 21 on node -1
[    0.346701]   alloc kstat_irqs on node -1
[    0.346704] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.346708] pci 0000:00:1c.1: setting latency timer to 64
[    0.346715]   alloc irq_desc for 23 on node -1
[    0.346717]   alloc kstat_irqs on node -1
[    0.346720] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.346724] pci 0000:00:1c.3: setting latency timer to 64
[    0.346730] pci 0000:00:1e.0: setting latency timer to 64
[    0.346734] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.346737] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.346740] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.346742] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.346744] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.346746] pci_bus 0000:05: resource 2 pref mem [0xf2900000-0xf29fffff]
[    0.346749] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.346751] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.346783] NET: Registered protocol family 2
[    0.346854] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.347582] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.349207] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.349678] TCP: Hash tables configured (established 262144 bind 65536)
[    0.349680] TCP reno registered
[    0.349790] NET: Registered protocol family 1
[    0.349980] Simple Boot Flag at 0x35 set to 0x1
[    0.350875] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.353216] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.358882] VFS: Disk quotas dquot_6.5.2
[    0.358961] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.359462] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.362227] msgmni has been set to 7715
[    0.362507] alg: No test for stdrng (krng)
[    0.362514] io scheduler noop registered
[    0.362516] io scheduler anticipatory registered (default)
[    0.362518] io scheduler deadline registered
[    0.362625] io scheduler cfq registered
[    0.362638] pci 0000:00:02.0: Boot video device
[    0.362925]   alloc irq_desc for 24 on node -1
[    0.362927]   alloc kstat_irqs on node -1
[    0.362937] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.362952] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.363129]   alloc irq_desc for 25 on node -1
[    0.363131]   alloc kstat_irqs on node -1
[    0.363138] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.363152] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.363327]   alloc irq_desc for 26 on node -1
[    0.363328]   alloc kstat_irqs on node -1
[    0.363335] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.363350] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.432954] Linux agpgart interface v0.103
[    0.568548] Switched to high resolution mode on CPU 1
[    0.572020] Switched to high resolution mode on CPU 0
[    3.380010] floppy0: no floppy controllers found
[    3.381510] brd: module loaded
[    3.381512] Uniform Multi-Platform E-IDE driver
[    3.381598] ide-gd driver 1.18
[    3.381710] Driver 'sd' needs updating - please use bus_type methods
[    3.381756] ahci 0000:00:1f.2: version 3.0
[    3.381770]   alloc irq_desc for 16 on node -1
[    3.381772]   alloc kstat_irqs on node -1
[    3.381777] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.381810]   alloc irq_desc for 27 on node -1
[    3.381811]   alloc kstat_irqs on node -1
[    3.381818] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.381868] ahci: SSS flag set, parallel bus scan disabled
[    3.381890] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.381893] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.381898] ahci 0000:00:1f.2: setting latency timer to 64
[    3.382066] scsi0 : ahci
[    3.382269] scsi1 : ahci
[    3.382335] scsi2 : ahci
[    3.382405] scsi3 : ahci
[    3.383258] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    3.383262] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    3.383264] ata3: DUMMY
[    3.383265] ata4: DUMMY
[    3.383456] Fusion MPT base driver 3.04.07
[    3.383457] Copyright (c) 1999-2008 LSI Corporation
[    3.383463] Fusion MPT SPI Host driver 3.04.07
[    3.383581] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    3.395472] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.395478] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.395672] mice: PS/2 mouse device common for all mice
[    3.395806] cpuidle: using governor ladder
[    3.395808] cpuidle: using governor menu
[    3.396108] TCP cubic registered
[    3.396111] NET: Registered protocol family 17
[    3.396276] registered taskstats version 1
[    3.402426] input: AT Translated Set 2 keyboard as /class/input/input0
[    3.701203] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.701220] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.709235] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.709238] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.709322] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.709326] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.710307] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    3.710309] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.720323] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.720326] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.720408] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.720411] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.721157] ata1.00: configured for UDMA/100
[    3.740380] ata1.00: configured for UDMA/100
[    3.740383] ata1: EH complete
[    3.740454] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    3.740609] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    3.740621] sd 0:0:0:0: [sda] Write Protect is off
[    3.740623] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.740642] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.740718]  sda: sda1 sda2 sda3
[    3.753756] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.769600] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    3.770444] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    3.774179] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[    3.781387] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    3.782292] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    3.785985] ata2.00: configured for UDMA/133
[    3.910966] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[    3.953408] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.970959] input: TPPS/2 IBM TrackPoint as /class/input/input1
[    4.034205] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    4.049225] devtmpfs: mounted
[    4.049248] Freeing unused kernel memory: 368k freed
[    7.360538] Driver 'sr' needs updating - please use bus_type methods
[    7.372041] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    7.372046] Uniform CD-ROM driver Revision: 3.20
[    7.372150] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    7.481554] input: Power Button as /class/input/input2
[    7.481635] ACPI: Power Button [PWRF]
[    7.481694] input: Lid Switch as /class/input/input3
[    7.482269] ACPI: Lid Switch [LID]
[    7.482328] input: Sleep Button as /class/input/input4
[    7.482375] ACPI: Sleep Button [SLPB]
[    7.500188] thermal LNXTHERM:01: registered as thermal_zone0
[    7.500197] ACPI: Thermal Zone [THM0] (50 C)
[    7.501826] thermal LNXTHERM:02: registered as thermal_zone1
[    7.501834] ACPI: Thermal Zone [THM1] (47 C)
[    7.546444] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20050624)
[    7.547100] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003=
001 INTL 20050624)
[    7.549740] ACPI Warning: Invalid throttling state, reset
[    7.549744]  20090422 processor_throttling-843
[    7.550763] Monitor-Mwait will be used to enter C-1 state
[    7.550766] Monitor-Mwait will be used to enter C-2 state
[    7.550768] Monitor-Mwait will be used to enter C-3 state
[    7.550771] Marking TSC unstable due to TSC halts in idle
[    7.550833] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    7.550877] processor ACPI_CPU:00: registered as cooling_device0
[    7.550881] ACPI: Processor [CPU0] (supports 8 throttling states)
[    7.551450] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20050624)
[    7.552014] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20050624)
[    7.552986] ACPI Warning: Invalid throttling state, reset
[    7.552990]  20090422 processor_throttling-843
[    7.554125] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    7.554153] processor ACPI_CPU:01: registered as cooling_device1
[    7.554156] ACPI: Processor [CPU1] (supports 8 throttling states)
[    7.648500] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.648537] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    7.670107] ACPI: AC Adapter [AC] (on-line)
[    7.827886] ACPI: Battery Slot [BAT0] (battery present)
[    7.846584] ACPI: WMI: Mapper loaded
[    7.886353] Non-volatile memory driver v1.3
[    7.924506] agpgart-intel 0000:00:00.0: Intel Mobile Intel=AE GM45 Expre=
ss Chipset
[    7.925454] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    7.928487] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.001091] Clocksource tsc unstable (delta =3D -311863494 ns)
[    8.124071] cfg80211: Calling CRDA to update world regulatory domain
[    8.284503] usbcore: registered new interface driver usbfs
[    8.284528] usbcore: registered new interface driver hub
[    8.284555] usbcore: registered new device driver usb
[    8.458889] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    8.458892] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    8.458929] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    8.458938] e1000e 0000:00:19.0: setting latency timer to 64
[    8.459032]   alloc irq_desc for 28 on node -1
[    8.459034]   alloc kstat_irqs on node -1
[    8.459043] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    8.503308] rtc_cmos 00:07: RTC can wake from S4
[    8.503413] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    8.503440] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    8.546502] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    8.546505] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.546529] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    8.556670] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.557534] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    8.557544] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    8.557559] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    8.557563] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    8.557593] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    8.561513] ehci_hcd 0000:00:1a.7: debug port 1
[    8.561519] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    8.561533] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    8.576106] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    8.576264] usb usb1: configuration #1 chosen from 1 choice
[    8.576293] hub 1-0:1.0: USB hub found
[    8.576299] hub 1-0:1.0: 6 ports detected
[    8.577047] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    8.577055]   alloc irq_desc for 19 on node -1
[    8.577057]   alloc kstat_irqs on node -1
[    8.577061] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    8.577074] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    8.577077] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    8.577087] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    8.580984] ehci_hcd 0000:00:1d.7: debug port 1
[    8.580990] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    8.581005] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    8.596094] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    8.596231] usb usb2: configuration #1 chosen from 1 choice
[    8.596266] hub 2-0:1.0: USB hub found
[    8.596272] hub 2-0:1.0: 6 ports detected
[    8.649839] uhci_hcd: USB Universal Host Controller Interface driver
[    8.651883] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    8.651892] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    8.651901] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    8.651904] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    8.651918] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    8.651955] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    8.652133] usb usb3: configuration #1 chosen from 1 choice
[    8.652164] hub 3-0:1.0: USB hub found
[    8.652170] hub 3-0:1.0: 2 ports detected
[    8.652277] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    8.652283] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    8.652286] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    8.652293] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    8.652325] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    8.652417] usb usb4: configuration #1 chosen from 1 choice
[    8.652444] hub 4-0:1.0: USB hub found
[    8.652450] hub 4-0:1.0: 2 ports detected
[    8.654913] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    8.654922]   alloc irq_desc for 22 on node -1
[    8.654924]   alloc kstat_irqs on node -1
[    8.654929] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[    8.654938] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    8.654941] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    8.654952] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    8.654993] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    8.655119] usb usb5: configuration #1 chosen from 1 choice
[    8.655148] hub 5-0:1.0: USB hub found
[    8.655154] hub 5-0:1.0: 2 ports detected
[    8.655974] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    8.655980] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    8.655987] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.655990] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    8.656019] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    8.656055] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    8.656173] usb usb6: configuration #1 chosen from 1 choice
[    8.656201] hub 6-0:1.0: USB hub found
[    8.656207] hub 6-0:1.0: 2 ports detected
[    8.656307]   alloc irq_desc for 17 on node -1
[    8.656309]   alloc kstat_irqs on node -1
[    8.656313] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    8.656319] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    8.656322] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    8.656329] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    8.656360] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    8.656453] usb usb7: configuration #1 chosen from 1 choice
[    8.656479] hub 7-0:1.0: USB hub found
[    8.656485] hub 7-0:1.0: 2 ports detected
[    8.656584]   alloc irq_desc for 18 on node -1
[    8.656585]   alloc kstat_irqs on node -1
[    8.656589] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    8.656595] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    8.656598] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    8.656605] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    8.656637] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    8.656726] usb usb8: configuration #1 chosen from 1 choice
[    8.656754] hub 8-0:1.0: USB hub found
[    8.656766] hub 8-0:1.0: 2 ports detected
[    8.857455] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    8.857457] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.857459] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[    8.857461] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[    8.858210] thinkpad_acpi: radio switch found; radios are enabled
[    8.858321] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    8.858324] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    8.866968] Registered led device: tpacpi::thinklight
[    8.867006] Registered led device: tpacpi::power
[    8.867029] Registered led device: tpacpi::standby
[    8.869658] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    8.869991] input: ThinkPad Extra Buttons as /class/input/input5
[    8.885788] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    9.001051] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 3
[    9.088740] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27k
[    9.088743] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    9.088860] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.088868] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.088895] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300A=
GN REV=3D0x24
[    9.122788] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.1=
1a channels
[    9.122855]   alloc irq_desc for 29 on node -1
[    9.122857]   alloc kstat_irqs on node -1
[    9.122873] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[    9.132588] usb 1-5: configuration #1 chosen from 1 choice
[    9.132756] hub 1-5:1.0: USB hub found
[    9.132825] hub 1-5:1.0: 4 ports detected
[    9.203501] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    9.244045] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 4
[    9.259571] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[    9.259596] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.336251] input: HDA Intel Headphone as /class/input/input6
[    9.336373] input: HDA Intel Mic as /class/input/input7
[    9.336441] input: HDA Intel Mic as /class/input/input8
[    9.336508] input: HDA Intel Headphone as /class/input/input9
[    9.382877] usb 1-6: configuration #1 chosen from 1 choice
[    9.493048] usb 2-6: new high speed USB device using ehci_hcd and addres=
s 2
[    9.498764] Linux video capture interface: v2.00
[    9.608732] uvcvideo: Found UVC 1.00 device <unnamed> (17ef:480c)
[    9.610025] input: UVC Camera (17ef:480c) as /class/input/input10
[    9.610087] usbcore: registered new interface driver uvcvideo
[    9.610090] USB Video Class driver (v0.1.0)
[    9.638349] usb 2-6: configuration #1 chosen from 1 choice
[    9.792692] usbcore: registered new interface driver libusual
[    9.876044] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 2
[    9.908076] Initializing USB Mass Storage driver...
[    9.909226] scsi4 : SCSI emulation for USB Mass Storage devices
[    9.909940] usbcore: registered new interface driver usb-storage
[    9.909943] usb-storage: device found at 2
[    9.909945] usb-storage: waiting for device to settle before scanning
[    9.909948] USB Mass Storage support registered.
[   10.044538] usb 4-1: configuration #1 chosen from 1 choice
[   10.116108] usb 1-5.3: new full speed USB device using ehci_hcd and addr=
ess 5
[   10.210718] usb 1-5.3: configuration #1 chosen from 1 choice
[   10.282282] usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[   10.282297] usbcore: registered new interface driver usblp
[   11.096008] hda-intel: azx_get_response timeout, switching to polling mo=
de: last cmd=3D0x010b8000
[   12.522085] loop: module loaded
[   12.885336] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   14.908993] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   14.909197] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   15.077852] usb-storage: device scan complete
[   15.078351] sd 4:0:0:0: [sdb] 7741440 512-byte hardware sectors: (3.96 G=
B/3.69 GiB)
[   15.078968] sd 4:0:0:0: [sdb] Write Protect is off
[   15.078972] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   15.078974] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.081328] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   15.081333]  sdb: sdb1
[   15.083257] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[  126.177634] Intel AES-NI instructions are not detected.
[  126.232543] padlock: VIA PadLock not detected.
[  126.267612] padlock: VIA PadLock Hash Engine not detected.
[  126.282753] isa bounce pool size: 16 pages
[  142.525475] fuse init (API version 7.11)
[  146.140374] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[  146.196173] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[  146.755122] Loading iSCSI transport class v2.0-870.
[  146.797328] iscsi: registered transport (tcp)
[  146.860340] NET: Registered protocol family 10
[  146.860871] lo: Disabled Privacy Extensions
[  146.863803] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  146.946463] iscsi: registered transport (iser)
[  149.228865] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[  149.230516] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  154.692634] lp: driver loaded but no devices found
[  154.704905] ppdev: user-space parallel port driver
[  157.052808] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[  157.053037] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[  157.108298] input: /usr/sbin/thinkpad-keys as /class/input/input11
[  157.983759] RPC: Registered udp transport module.
[  157.983863] RPC: Registered tcp transport module.
[  158.126422] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  158.240808] svc: failed to register lockdv1 RPC service (errno 97).
[  158.243227] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[  158.262220] NFSD: starting 90-second grace period
[  159.580092] eth0: no IPv6 routers present
[  166.754716] Bluetooth: Core ver 2.15
[  166.756623] NET: Registered protocol family 31
[  166.756794] Bluetooth: HCI device and connection manager initialized
[  166.756967] Bluetooth: HCI socket layer initialized
[  166.994135] Bluetooth: L2CAP ver 2.14
[  166.994290] Bluetooth: L2CAP socket layer initialized
[  167.107307] Bluetooth: RFCOMM socket layer initialized
[  167.107462] Bluetooth: RFCOMM TTY layer initialized
[  167.107594] Bluetooth: RFCOMM ver 1.11
[  170.661570] idr_remove called for id=3D40 which is not allocated.
[  170.661792] Pid: 5713, comm: udevd Not tainted 2.6.30-rc7-next-20090527-=
06291-gc0f66c0 #47
[  170.662008] Call Trace:
[  170.662149]  [<ffffffff8036123c>] idr_remove+0x115/0x18f
[  170.662288]  [<ffffffff802d3bcd>] inotify_destroy_mark_entry+0xac/0xc4
[  170.662427]  [<ffffffff802d3161>] inotify_freeing_mark+0x9/0xb
[  170.662565]  [<ffffffff802d1b97>] fsnotify_destroy_mark_by_entry+0x133/0=
x15d
[  170.662704]  [<ffffffff802d3b58>] inotify_destroy_mark_entry+0x37/0xc4
[  170.662843]  [<ffffffff802d3c7b>] sys_inotify_rm_watch+0x96/0xc3
[  170.662981]  [<ffffffff8020afab>] system_call_fastpath+0x16/0x1b
[  171.617193] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.uco=
de
[  171.773244] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[  171.957586] Registered led device: iwl-phy0::radio
[  171.957835] Registered led device: iwl-phy0::assoc
[  171.958035] Registered led device: iwl-phy0::RX
[  171.958223] Registered led device: iwl-phy0::TX
[  171.969594] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  172.202244] ip_tables: (C) 2000-2006 Netfilter Core Team
[  175.037716] wlan0: direct probe to AP 00:03:52:1c:12:11 try 1
[  175.236294] wlan0: direct probe to AP 00:03:52:1c:12:11 try 2
[  175.440112] wlan0: direct probe to AP 00:03:52:1c:12:11 try 3
[  175.636118] wlan0: direct probe to AP 00:03:52:1c:12:11 timed out
[  189.496852] [drm] Initialized drm 1.1.0 20060810
[  189.599450] pci 0000:00:02.0: power state changed by ACPI to D0
[  189.599459] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  189.599462] pci 0000:00:02.0: setting latency timer to 64
[  189.608844]   alloc irq_desc for 30 on node -1
[  189.608847]   alloc kstat_irqs on node -1
[  189.608854] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[  189.617991] acpi device:03: registered as cooling_device2
[  189.618223] input: Video Bus as /class/input/input12
[  189.618314] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[  189.618360] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[  190.451625] set status page addr 0x08da0000
[  260.576844] BUG: unable to handle kernel paging request at ffffffff00000=
000
[  260.576858] IP: [<ffffffff802a4847>] kmem_cache_alloc+0x72/0xf9
[  260.576875] PGD 203067 PUD 0=20
[  260.576884] Oops: 0000 [#1] PREEMPT SMP=20
[  260.576892] last sysfs file: /sys/class/rfkill/rfkill1/state
[  260.576899] CPU 0=20
[  260.576904] Modules linked in: i915 fb drm i2c_algo_bit cfbcopyarea cfbi=
mgblt cfbfillrect xt_multiport iptable_filter ip_tables x_tables rfcomm l2c=
ap bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs kvm_intel kvm u=
input ppdev lp parport autofs4 acpi_cpufreq cpufreq_powersave ib_iser rdma_=
cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp lib=
iscsi scsi_transport_iscsi fuse sha256_generic cryptd aes_x86_64 aes_generi=
c cbc dm_crypt dm_mod loop usblp usb_storage usb_libusual uvcvideo videodev=
 v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_conexant snd_hda_intel snd_h=
da_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss ecb snd_pcm snd_seq_midi =
snd_rawmidi snd_seq_midi_event snd_seq iwlagn iwlcore snd_timer snd_seq_dev=
ice i2c_i801 thinkpad_acpi hwmon rfkill mac80211 uhci_hcd snd ehci_hcd led_=
class rtc_cmos rtc_core video backlight e1000e i2c_core soundcore snd_page_=
alloc usbcore rtc_lib cfg80211 output intel_agp nvram wmi battery ac sg pro=
cessor thermal button sr_mod cdrom
[  260.577097] Pid: 6983, comm: firefox-bin Not tainted 2.6.30-rc7-next-200=
90527-06291-gc0f66c0 #47 7458AH8
[  260.577104] RIP: 0010:[<ffffffff802a4847>]  [<ffffffff802a4847>] kmem_ca=
che_alloc+0x72/0xf9
[  260.577117] RSP: 0018:ffff88012b55feb8  EFLAGS: 00010086
[  260.577123] RAX: 0000000000000000 RBX: 00000000fffffff4 RCX: 00000000000=
00006
[  260.577130] RDX: ffff88013b950d60 RSI: 00000000000000d0 RDI: ffff88013af=
32000
[  260.577136] RBP: ffff88012b55fee8 R08: 0000000000000006 R09: 00000000000=
00006
[  260.577142] R10: 00000000ffffffea R11: 000000d000000001 R12: ffff88013af=
2f300
[  260.577149] R13: ffffffff00000000 R14: ffff88013af32000 R15: 00000000000=
00296
[  260.577157] FS:  00007f35ce5d6710(0000) GS:ffff880028023000(0000) knlGS:=
0000000000000000
[  260.577164] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  260.577170] CR2: ffffffff00000000 CR3: 000000012d449000 CR4: 00000000000=
026f0
[  260.577176] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  260.577182] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  260.577190] Process firefox-bin (pid: 6983, threadinfo ffff88012b55e000,=
 task ffff880130030340)
[  260.577195] Stack:
[  260.577199]  000000d02b55fec8 00000000fffffff4 000000000131f230 ffff8801=
2b55ff28
[  260.577208]  0000000000000000 ffff8801385c0c00 ffff88012b55ff78 ffffffff=
802d3953
[  260.577219]  ffff88012b55ff48 01002fc630cf2924 ffff88012b282768 ffff8801=
2d5659c0
[  260.577231] Call Trace:
[  260.577236]  [<ffffffff802d3953>] sys_inotify_add_watch+0x2b2/0x2c7
[  260.577249]  [<ffffffff8020afab>] system_call_fastpath+0x16/0x1b
[  260.577260] Code: bb ea ff ff 49 63 46 08 49 39 04 24 76 0b 4c 89 e6 4c =
89 f7 e8 4b f0 ff ff 4d 8b 6c 24 08 4d 85 ed 0f 84 81 00 00 00 49 63 46 1c =
<49> 8b 44 05 00 49 ff 0c 24 49 89 44 24 08 eb 3b 49 8d 5c 24 48=20
[  260.577343] RIP  [<ffffffff802a4847>] kmem_cache_alloc+0x72/0xf9
[  260.577353]  RSP <ffff88012b55feb8>
[  260.577358] CR2: ffffffff00000000
[  260.577363] ---[ end trace dfca3e81fb7b3059 ]---
[  783.281336] BUG: unable to handle kernel paging request at ffffffff00000=
000
[  783.281351] IP: [<ffffffff802a4847>] kmem_cache_alloc+0x72/0xf9
[  783.281369] PGD 203067 PUD 0=20
[  783.281378] Oops: 0000 [#2] PREEMPT SMP=20
[  783.281386] last sysfs file: /sys/class/rfkill/rfkill1/state
[  783.281393] CPU 0=20
[  783.281398] Modules linked in: i915 fb drm i2c_algo_bit cfbcopyarea cfbi=
mgblt cfbfillrect xt_multiport iptable_filter ip_tables x_tables rfcomm l2c=
ap bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs kvm_intel kvm u=
input ppdev lp parport autofs4 acpi_cpufreq cpufreq_powersave ib_iser rdma_=
cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp lib=
iscsi scsi_transport_iscsi fuse sha256_generic cryptd aes_x86_64 aes_generi=
c cbc dm_crypt dm_mod loop usblp usb_storage usb_libusual uvcvideo videodev=
 v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_conexant snd_hda_intel snd_h=
da_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss ecb snd_pcm snd_seq_midi =
snd_rawmidi snd_seq_midi_event snd_seq iwlagn iwlcore snd_timer snd_seq_dev=
ice i2c_i801 thinkpad_acpi hwmon rfkill mac80211 uhci_hcd snd ehci_hcd led_=
class rtc_cmos rtc_core video backlight e1000e i2c_core soundcore snd_page_=
alloc usbcore rtc_lib cfg80211 output intel_agp nvram wmi battery ac sg pro=
cessor thermal button sr_mod cdrom
[  783.281597] Pid: 9307, comm: firefox-bin Tainted: G      D    2.6.30-rc7=
-next-20090527-06291-gc0f66c0 #47 7458AH8
[  783.281604] RIP: 0010:[<ffffffff802a4847>]  [<ffffffff802a4847>] kmem_ca=
che_alloc+0x72/0xf9
[  783.281617] RSP: 0018:ffff8801224cdeb8  EFLAGS: 00010086
[  783.281623] RAX: 0000000000000000 RBX: 00000000fffffff4 RCX: 00000000000=
00000
[  783.281630] RDX: ffff88013b950d60 RSI: 00000000000000d0 RDI: ffff88013af=
32000
[  783.281636] RBP: ffff8801224cdee8 R08: 0000000000000000 R09: 00000000000=
00000
[  783.281643] R10: 00000000ffffffea R11: 000000d0225d6000 R12: ffff88013af=
2f300
[  783.281650] R13: ffffffff00000000 R14: ffff88013af32000 R15: 00000000000=
00296
[  783.281657] FS:  00007f5008683710(0000) GS:ffff880028023000(0000) knlGS:=
0000000000000000
[  783.281664] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  783.281671] CR2: ffffffff00000000 CR3: 00000001231b0000 CR4: 00000000000=
026f0
[  783.281677] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  783.281683] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  783.281691] Process firefox-bin (pid: 9307, threadinfo ffff8801224cc000,=
 task ffff88012392a100)
[  783.281696] Stack:
[  783.281700]  000000d0224cdec8 00000000fffffff4 0000000001406c30 ffff8801=
224cdf28
[  783.281710]  0000000000000000 ffff880138963800 ffff8801224cdf78 ffffffff=
802d3953
[  783.281721]  000000000005409d 01002fc600800001 ffff880125685330 ffff8801=
2b9ac300
[  783.281733] Call Trace:
[  783.281738]  [<ffffffff802d3953>] sys_inotify_add_watch+0x2b2/0x2c7
[  783.281751]  [<ffffffff8020afab>] system_call_fastpath+0x16/0x1b
[  783.281762] Code: bb ea ff ff 49 63 46 08 49 39 04 24 76 0b 4c 89 e6 4c =
89 f7 e8 4b f0 ff ff 4d 8b 6c 24 08 4d 85 ed 0f 84 81 00 00 00 49 63 46 1c =
<49> 8b 44 05 00 49 ff 0c 24 49 89 44 24 08 eb 3b 49 8d 5c 24 48=20
[  783.281850] RIP  [<ffffffff802a4847>] kmem_cache_alloc+0x72/0xf9
[  783.281861]  RSP <ffff8801224cdeb8>
[  783.281865] CR2: ffffffff00000000
[  783.281871] ---[ end trace dfca3e81fb7b305a ]---
[  945.329405] BUG: unable to handle kernel paging request at ffffffff00000=
000
[  945.329411] IP: [<ffffffff802a4847>] kmem_cache_alloc+0x72/0xf9
[  945.329419] PGD 203067 PUD 0=20
[  945.329422] Oops: 0000 [#3] PREEMPT SMP=20
[  945.329424] last sysfs file: /sys/class/rfkill/rfkill1/state
[  945.329427] CPU 0=20
[  945.329429] Modules linked in: i915 fb drm i2c_algo_bit cfbcopyarea cfbi=
mgblt cfbfillrect xt_multiport iptable_filter ip_tables x_tables rfcomm l2c=
ap bluetooth nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs kvm_intel kvm u=
input ppdev lp parport autofs4 acpi_cpufreq cpufreq_powersave ib_iser rdma_=
cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp lib=
iscsi scsi_transport_iscsi fuse sha256_generic cryptd aes_x86_64 aes_generi=
c cbc dm_crypt dm_mod loop usblp usb_storage usb_libusual uvcvideo videodev=
 v4l1_compat v4l2_compat_ioctl32 snd_hda_codec_conexant snd_hda_intel snd_h=
da_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss ecb snd_pcm snd_seq_midi =
snd_rawmidi snd_seq_midi_event snd_seq iwlagn iwlcore snd_timer snd_seq_dev=
ice i2c_i801 thinkpad_acpi hwmon rfkill mac80211 uhci_hcd snd ehci_hcd led_=
class rtc_cmos rtc_core video backlight e1000e i2c_core soundcore snd_page_=
alloc usbcore rtc_lib cfg80211 output intel_agp nvram wmi battery ac sg pro=
cessor thermal button sr_mod cdrom
[  945.329496] Pid: 9788, comm: firefox-bin Tainted: G      D    2.6.30-rc7=
-next-20090527-06291-gc0f66c0 #47 7458AH8
[  945.329498] RIP: 0010:[<ffffffff802a4847>]  [<ffffffff802a4847>] kmem_ca=
che_alloc+0x72/0xf9
[  945.329502] RSP: 0018:ffff8801259fbeb8  EFLAGS: 00010086
[  945.329504] RAX: 0000000000000000 RBX: 00000000fffffff4 RCX: 00000000000=
00006
[  945.329506] RDX: ffff88013b950d60 RSI: 00000000000000d0 RDI: ffff88013af=
32000
[  945.329508] RBP: ffff8801259fbee8 R08: 0000000000000006 R09: 00000000000=
00006
[  945.329511] R10: 00000000ffffffea R11: 000000d000000001 R12: ffff88013af=
2f300
[  945.329513] R13: ffffffff00000000 R14: ffff88013af32000 R15: 00000000000=
00296
[  945.329515] FS:  00007ffb3a235710(0000) GS:ffff880028023000(0000) knlGS:=
0000000000000000
[  945.329518] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  945.329520] CR2: ffffffff00000000 CR3: 000000012d46b000 CR4: 00000000000=
026f0
[  945.329522] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  945.329524] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  945.329527] Process firefox-bin (pid: 9788, threadinfo ffff8801259fa000,=
 task ffff8801344ef680)
[  945.329528] Stack:
[  945.329530]  000000d0259fbec8 00000000fffffff4 00000000011bba20 ffff8801=
259fbf28
[  945.329533]  0000000000000000 ffff88013a5d9f00 ffff8801259fbf78 ffffffff=
802d3953
[  945.329537]  ffff8801259fbf48 01002fc62b86e164 ffff88012b282768 ffff8801=
27c680c0
[  945.329541] Call Trace:
[  945.329543]  [<ffffffff802d3953>] sys_inotify_add_watch+0x2b2/0x2c7
[  945.329548]  [<ffffffff8020b1ad>] tracesys+0xd0/0xd5
[  945.329551] Code: bb ea ff ff 49 63 46 08 49 39 04 24 76 0b 4c 89 e6 4c =
89 f7 e8 4b f0 ff ff 4d 8b 6c 24 08 4d 85 ed 0f 84 81 00 00 00 49 63 46 1c =
<49> 8b 44 05 00 49 ff 0c 24 49 89 44 24 08 eb 3b 49 8d 5c 24 48=20
[  945.329579] RIP  [<ffffffff802a4847>] kmem_cache_alloc+0x72/0xf9
[  945.329583]  RSP <ffff8801259fbeb8>
[  945.329584] CR2: ffffffff00000000
[  945.329586] ---[ end trace dfca3e81fb7b305b ]---



--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--OwLcNYc0lM97+oe1
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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
3Vhj310W/R9NtIhEBloBAA==

--OwLcNYc0lM97+oe1--

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkodKbUACgkQuL75KpiFGIx+rgCgsVsSOWMMsK055a/SK86zjVaN
hawAoOzfL+vn6t4x/FykN9lHb3SWcqR+
=Jq+A
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
