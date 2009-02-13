Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZBMJlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZBMJlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZBMJk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:40:57 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:44702 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZBMJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:40:51 -0500
Date: Fri, 13 Feb 2009 10:40:48 +0100
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090213094048.GC10175@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090213093354.GA10175@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <20090213093354.GA10175@denkbrett.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00211-g37bed90 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Fri, Feb 13, 2009 at 10:33:54AM +0100]:
> [...]

dmesg:


[    0.000000] Linux version 2.6.29-rc4-ikn-00211-g37bed90 (compiler@ikn) (=
gcc version 4.3.2 (Debian 4.3.2-1.1) ) #12 SMP PREEMPT Fri Feb 13 09:40:39 =
CET 2009
[    0.000000] Command line: root=3D/dev/sda1 ro=20
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007c4a1000 (usable)
[    0.000000]  BIOS-e820: 000000007c4a1000 - 000000007c4a7000 (reserved)
[    0.000000]  BIOS-e820: 000000007c4a7000 - 000000007c5b7000 (usable)
[    0.000000]  BIOS-e820: 000000007c5b7000 - 000000007c60f000 (reserved)
[    0.000000]  BIOS-e820: 000000007c60f000 - 000000007c6c6000 (usable)
[    0.000000]  BIOS-e820: 000000007c6c6000 - 000000007c6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c6d1000 - 000000007c6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c6d4000 - 000000007c6d8000 (reserved)
[    0.000000]  BIOS-e820: 000000007c6d8000 - 000000007c6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c6dc000 - 000000007c6df000 (reserved)
[    0.000000]  BIOS-e820: 000000007c6df000 - 000000007c706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c706000 - 000000007c708000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c708000 - 000000007c90f000 (reserved)
[    0.000000]  BIOS-e820: 000000007c90f000 - 000000007c99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007c99f000 - 000000007c9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007c9ff000 - 000000007ca00000 (usable)
[    0.000000]  BIOS-e820: 000000007cc00000 - 000000007f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x7ca00 max_arch_pfn =3D 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] init_memory_mapping: 0000000000000000-000000007ca00000
[    0.000000]  0000000000 - 007ca00000 page 2M
[    0.000000] kernel direct mapping tables up to 7ca00000 @ 8000-b000
[    0.000000] last_map_addr: 7ca00000 end: 7ca00000
[    0.000000] ACPI: RSDP 000F73A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7C97BD45, 009C (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: FACP 7C97BF00, 00F4 (r3 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aCo=
ntrolBlock: 16/32 [20081204]
[    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBl=
ock: 32, using default 16 [20081204]
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_L=
EN (4)
[    0.000000] ACPI: DSDT 7C97C2F4, D910 (r1 LENOVO TP-6D        1050 MSFT =
 3000000)
[    0.000000] ACPI: FACS 7C98E000, 0040
[    0.000000] ACPI: SSDT 7C97C0B4, 0240 (r1 LENOVO TP-6D        1050 MSFT =
 3000000)
[    0.000000] ACPI: ECDT 7C989C04, 0052 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: APIC 7C989C56, 0078 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: MCFG 7C989CCE, 003C (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: HPET 7C989D0A, 0038 (r1 LENOVO TP-6D        1050 LNVO =
       1)
[    0.000000] ACPI: SLIC 7C989DC2, 0176 (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: BOOT 7C989F38, 0028 (r1 LENOVO TP-6D        1050  LTP =
       1)
[    0.000000] ACPI: ASF! 7C989F60, 00A0 (r16 LENOVO TP-6D        1050 PTL =
        1)
[    0.000000] ACPI: SSDT 7C98D203, 055F (r1 LENOVO TP-6D        1050 INTL =
20050513)
[    0.000000] ACPI: TCPA 7C707000, 0032 (r0                        0      =
       0)
[    0.000000] ACPI: DMAR 7C706000, 0120 (r1               =01        1    =
         0)
[    0.000000] ACPI: SSDT 7C6D3000, 0655 (r1  PmRef    CpuPm     3000 INTL =
20050624)
[    0.000000] ACPI: SSDT 7C6D2000, 0274 (r1  PmRef  Cpu0Tst     3000 INTL =
20050624)
[    0.000000] ACPI: SSDT 7C6D1000, 0242 (r1  PmRef    ApTst     3000 INTL =
20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) =3D=3D> bootmem [0000000000 - 007ca00=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000073c3dc]    TEXT DATA BSS =3D=3D> [000=
0200000 - 000073c3dc]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000=
009ec00 - 0000100000]
[    0.000000]   #4 [0000008000 - 0000009000]          PGTABLE =3D=3D> [000=
0008000 - 0000009000]
[    0.000000] found SMP MP-table at [ffff8800000f73e0] 000f73e0
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff88000120000=
0-ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007c4a1
[    0.000000]     0: 0x0007c4a7 -> 0x0007c5b7
[    0.000000]     0: 0x0007c60f -> 0x0007c6c6
[    0.000000]     0: 0x0007c9ff -> 0x0007ca00
[    0.000000] On node 0 totalpages: 509447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1443 pages reserved
[    0.000000]   DMA zone: 2499 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6923 pages used for memmap
[    0.000000]   DMA32 zone: 498526 pages, LIFO batch:31
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
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000=
:61000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 501025
[    0.000000] Kernel command line: root=3D/dev/sda1 ro=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 2261.002 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.004000] Memory: 1999576k/2041856k available (2892k kernel code, 4068=
k absent, 37484k reserved, 1411k data, 348k init)
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4522.00 BogoMIPS (lpj=3D9044008)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20081204
[    0.024048] Setting APIC routing to flat
[    0.024480] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.067050] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4521.97 Bog=
oMIPS (lpj=3D9043956)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.153317] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.154465] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156024] Brought up 2 CPUs
[    0.156124] Total of 2 processors activated (9043.98 BogoMIPS).
[    0.156290] net_namespace: 1752 bytes
[    0.156290] regulator: core version 0.5
[    0.156290] NET: Registered protocol family 16
[    0.156290] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.156290] ACPI: bus type pci registered
[    0.160027] PCI: Using configuration type 1 for base access
[    0.160124] bio: create slab <bio-0> at 0
[    0.164063] ACPI: EC: EC description table is found, configuring boot EC
[    0.172099] ACPI: BIOS _OSI(Linux) query ignored
[    0.172016] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.188308] ACPI: Interpreter enabled
[    0.188409] ACPI: (supports S0 S3 S5)
[    0.188630] ACPI: Using IOAPIC for interrupt routing
[    0.224197] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.224302] ACPI: EC: driver started in interrupt mode
[    0.228003] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.228003] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.228058] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.228064] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.228068] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.228099] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.228149] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.228179] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.228284] pci 0000:00:03.0: PME# disabled
[    0.228284] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.228284] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.228284] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.228284] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.228284] pci 0000:00:19.0: PME# disabled
[    0.228402] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.228481] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.228560] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.228643] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.228705] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.228811] pci 0000:00:1a.7: PME# disabled
[    0.228955] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.229004] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.229109] pci 0000:00:1b.0: PME# disabled
[    0.232002] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.232002] pci 0000:00:1c.0: PME# disabled
[    0.232002] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.232002] pci 0000:00:1c.1: PME# disabled
[    0.232002] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.232002] pci 0000:00:1c.3: PME# disabled
[    0.232002] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.232002] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.232002] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.232002] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.232002] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.232002] pci 0000:00:1d.7: PME# disabled
[    0.232002] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.232002] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.232002] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.232002] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.232002] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.232002] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.232002] pci 0000:00:1f.2: PME# supported from D3hot
[    0.232002] pci 0000:00:1f.2: PME# disabled
[    0.232002] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.232002] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.232002] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.232002] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.232002] pci 0000:03:00.0: PME# disabled
[    0.232002] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.232002] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.232002] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.232002] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.232002] pci 0000:00:1e.0: transparent bridge
[    0.232031] pci_bus 0000:00: on NUMA node 0
[    0.232038] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.232220] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.232301] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.232383] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.240258] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.240851] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.240851] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.240851] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.241505] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.242182] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.242860] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.243539] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.244092] ACPI: Power Resource [PUBS] (on)
[    0.244310] SCSI subsystem initialized
[    0.244310] libata version 3.00 loaded.
[    0.248041] PCI: Using ACPI for IRQ routing
[    0.260054] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.260334] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.284008] pnp: PnP ACPI init
[    0.284113] ACPI: bus type pnp registered
[    0.345257] pnp: PnP ACPI: found 10 devices
[    0.345358] ACPI: ACPI bus type pnp unregistered
[    0.345466] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.345570] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.345675] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.345779] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.345883] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.345987] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.346092] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.346197] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.346302] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.346407] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.346512] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.346617] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.346728] system 00:00: iomem range 0x100000-0x7effffff could not be r=
eserved
[    0.346893] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.347058] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.347225] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.347329] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.347434] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.347538] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.347642] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.347747] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.347851] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.347956] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.348061] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.348167] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.348272] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.348377] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.348482] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.353458] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.353560] pci 0000:00:1c.0:   IO window: disabled
[    0.353665] pci 0000:00:1c.0:   MEM window: disabled
[    0.353768] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.353874] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.353977] pci 0000:00:1c.1:   IO window: disabled
[    0.354081] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.354187] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.354293] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.354396] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.354501] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.354607] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.354785] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.354888] pci 0000:00:1e.0:   IO window: disabled
[    0.354992] pci 0000:00:1e.0:   MEM window: disabled
[    0.355096] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.355210] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.355317] pci 0000:00:1c.0: setting latency timer to 64
[    0.355325] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.355431] pci 0000:00:1c.1: setting latency timer to 64
[    0.355439] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.355545] pci 0000:00:1c.3: setting latency timer to 64
[    0.355551] pci 0000:00:1e.0: setting latency timer to 64
[    0.355554] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.355556] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.355558] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.355560] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.355561] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.355563] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.355564] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.355566] pci_bus 0000:03: resource 1 mem: [0xf2500000-0xf25fffff]
[    0.355567] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.355569] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.355571] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.355572] pci_bus 0000:05: resource 1 mem: [0xf0000000-0xf1ffffff]
[    0.355574] pci_bus 0000:05: resource 2 mem: [0xf2900000-0xf29fffff]
[    0.355576] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.355577] pci_bus 0000:0d: resource 0 mem: [0x0-0x0]
[    0.355579] pci_bus 0000:0d: resource 1 mem: [0x0-0x0]
[    0.355580] pci_bus 0000:0d: resource 2 mem: [0x0-0x0]
[    0.355582] pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
[    0.355583] pci_bus 0000:0d: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.355604] NET: Registered protocol family 2
[    0.402669] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.403216] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.404925] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.405538] TCP: Hash tables configured (established 262144 bind 65536)
[    0.405642] TCP reno registered
[    0.414720] NET: Registered protocol family 1
[    0.415036] Simple Boot Flag at 0x35 set to 0x1
[    0.415955] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.418311] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.420365] VFS: Disk quotas dquot_6.5.2
[    0.420536] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.421066] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.424195] msgmni has been set to 3906
[    0.424512] alg: No test for stdrng (krng)
[    0.424621] io scheduler noop registered
[    0.424722] io scheduler anticipatory registered (default)
[    0.424825] io scheduler deadline registered
[    0.424979] io scheduler cfq registered
[    0.425092] pci 0000:00:02.0: Boot video device
[    0.425335] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.425396] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.425523] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.425580] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.425698] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.425756] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.426423] ACPI: AC Adapter [AC] (on-line)
[    0.472219] ACPI: Battery Slot [BAT0] (battery present)
[    0.472470] input: Power Button (FF) as /class/input/input0
[    0.472627] ACPI: Power Button (FF) [PWRF]
[    0.472798] input: Lid Switch as /class/input/input1
[    0.475266] ACPI: Lid Switch [LID]
[    0.475427] input: Sleep Button (CM) as /class/input/input2
[    0.475534] ACPI: Sleep Button (CM) [SLPB]
[    0.476437] ACPI: SSDT 7C6D6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL =
20050624)
[    0.477324] ACPI: SSDT 7C6D4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL =
20050624)
[    0.482362] Monitor-Mwait will be used to enter C-1 state
[    0.482367] Monitor-Mwait will be used to enter C-2 state
[    0.482371] Monitor-Mwait will be used to enter C-3 state
[    0.482421] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.482708] processor ACPI_CPU:00: registered as cooling_device0
[    0.482866] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.483709] ACPI: SSDT 7C6D5CA0, 01CF (r1  PmRef    ApIst     3000 INTL =
20050624)
[    0.484488] ACPI: SSDT 7C6D5F20, 008D (r1  PmRef    ApCst     3000 INTL =
20050624)
[    0.487061] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.487341] processor ACPI_CPU:01: registered as cooling_device1
[    0.487446] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.532630] thermal LNXTHERM:01: registered as thermal_zone0
[    0.536029] ACPI: Thermal Zone [THM0] (46 C)
[    0.537152] thermal LNXTHERM:02: registered as thermal_zone1
[    0.538543] ACPI: Thermal Zone [THM1] (42 C)
[    0.566388] Switched to high resolution mode on CPU 1
[    0.566390] Switched to high resolution mode on CPU 0
[    0.593533] Linux agpgart interface v0.103
[    3.608008] floppy0: no floppy controllers found
[    3.609317] brd: module loaded
[    3.609492] Uniform Multi-Platform E-IDE driver
[    3.609671] ide-gd driver 1.18
[    3.609878] Driver 'sd' needs updating - please use bus_type methods
[    3.610025] ahci 0000:00:1f.2: version 3.0
[    3.610041] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.610178] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    3.610216] ahci: SSS flag set, parallel bus scan disabled
[    3.610337] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.610505] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.610673] ahci 0000:00:1f.2: setting latency timer to 64
[    3.610826] scsi0 : ahci
[    3.611010] scsi1 : ahci
[    3.611168] scsi2 : ahci
[    3.611326] scsi3 : ahci
[    3.612291] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 27
[    3.612458] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 27
[    3.612623] ata3: DUMMY
[    3.612721] ata4: DUMMY
[    3.932014] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.947549] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.947551] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.947736] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.947738] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.948567] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    3.948671] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.958634] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    3.958636] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    3.958820] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    3.958822] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    3.959694] ata1.00: configured for UDMA/100
[    3.978132] ata1.00: configured for UDMA/100
[    3.978234] ata1: EH complete
[    3.992065] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    3.992351] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    3.992528] sd 0:0:0:0: [sda] Write Protect is off
[    3.992632] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.992650] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.992858] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    3.993034] sd 0:0:0:0: [sda] Write Protect is off
[    3.993136] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.993155] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.993323]  sda: sda1 sda2 sda3
[    4.003227] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.324012] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.388822] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    4.389667] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    4.393403] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[    4.400697] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    4.401540] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    4.405234] ata2.00: configured for UDMA/133
[    4.543461] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[    4.572071] Fusion MPT base driver 3.04.07
[    4.572172] Copyright (c) 1999-2008 LSI Corporation
[    4.572278] Fusion MPT SPI Host driver 3.04.07
[    4.572687] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.572894] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    4.587086] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.587191] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.587384] mice: PS/2 mouse device common for all mice
[    4.636351] cpuidle: using governor ladder
[    4.636886] cpuidle: using governor menu
[    4.637021] Marking TSC unstable due to TSC halts in idle
[    4.637252] oprofile: using NMI interrupt.
[    4.637586] TCP cubic registered
[    4.637687] NET: Registered protocol family 17
[    4.638887] registered taskstats version 1
[    4.643695] input: AT Translated Set 2 keyboard as /class/input/input3
[    4.903916] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[    5.000047] Clocksource tsc unstable (delta =3D -326682444 ns)
[    5.215709] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    5.234693] input: TPPS/2 IBM TrackPoint as /class/input/input4
[    5.403389] VFS: Mounted root (jfs filesystem) readonly on device 8:1.
[    5.403554] Freeing unused kernel memory: 348k freed
[    8.298106] Non-volatile memory driver v1.3
[    8.624366] Driver 'sr' needs updating - please use bus_type methods
[    8.635955] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    8.636143] Uniform CD-ROM driver Revision: 3.20
[    8.636320] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.769432] agpgart-intel 0000:00:00.0: Intel Mobile Intel=AE GM45 Expre=
ss Chipset
[    8.770543] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    8.773652] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.905125] thinkpad_acpi: ThinkPad ACPI Extras v0.22
[    8.905230] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.905332] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[    8.905436] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[    8.906261] thinkpad_acpi: radio switch found; radios are disabled
[    8.906477] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[    8.906647] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[    8.916799] Registered led device: tpacpi::thinklight
[    8.916937] Registered led device: tpacpi::power
[    8.917068] Registered led device: tpacpi:orange:batt
[    8.917184] Registered led device: tpacpi:green:batt
[    8.917300] Registered led device: tpacpi::dock_active
[    8.917416] Registered led device: tpacpi::bay_active
[    8.917535] Registered led device: tpacpi::dock_batt
[    8.917650] Registered led device: tpacpi::unknown_led
[    8.917766] Registered led device: tpacpi::standby
[    8.920089] thinkpad_acpi: Standard ACPI backlight interface available, =
not loading native one.
[    8.920518] input: ThinkPad Extra Buttons as /class/input/input5
[    8.989905] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.990048] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    9.015991] ACPI: WMI: Mapper loaded
[    9.425072] usbcore: registered new interface driver usbfs
[    9.425201] usbcore: registered new interface driver hub
[    9.480093] usbcore: registered new device driver usb
[    9.505846] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    9.505970] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    9.506120] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[    9.506237] e1000e 0000:00:19.0: setting latency timer to 64
[    9.506358] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[    9.523237] rtc_cmos 00:07: RTC can wake from S4
[    9.523437] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    9.523564] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    9.544499] uhci_hcd: USB Universal Host Controller Interface driver
[    9.560141] cfg80211: Calling CRDA to update world regulatory domain
[    9.595522] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[    9.595699] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    9.595831] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
[    9.596477] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    9.596600] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[    9.596726] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    9.596730] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    9.596898] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 1
[    9.597121] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    9.597384] usb usb1: configuration #1 chosen from 1 choice
[    9.597535] hub 1-0:1.0: USB hub found
[    9.597647] hub 1-0:1.0: 2 ports detected
[    9.597899] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    9.598018] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    9.598022] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    9.598160] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 2
[    9.598376] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    9.598596] usb usb2: configuration #1 chosen from 1 choice
[    9.598739] hub 2-0:1.0: USB hub found
[    9.598853] hub 2-0:1.0: 2 ports detected
[    9.599851] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    9.599967] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[    9.600106] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    9.600110] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    9.600256] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 3
[    9.600466] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    9.600676] usb usb3: configuration #1 chosen from 1 choice
[    9.600825] hub 3-0:1.0: USB hub found
[    9.600936] hub 3-0:1.0: 2 ports detected
[    9.602691] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    9.602811] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    9.602958] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    9.602962] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    9.603110] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    9.603327] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    9.603563] usb usb4: configuration #1 chosen from 1 choice
[    9.603707] hub 4-0:1.0: USB hub found
[    9.603819] hub 4-0:1.0: 2 ports detected
[    9.604071] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[    9.604190] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    9.604194] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    9.604330] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 5
[    9.604544] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    9.604751] usb usb5: configuration #1 chosen from 1 choice
[    9.604910] hub 5-0:1.0: USB hub found
[    9.605025] hub 5-0:1.0: 2 ports detected
[    9.605252] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    9.605367] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    9.605370] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    9.605504] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 6
[    9.605710] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    9.605921] usb usb6: configuration #1 chosen from 1 choice
[    9.606066] hub 6-0:1.0: USB hub found
[    9.606180] hub 6-0:1.0: 2 ports detected
[    9.639074] acpi device:03: registered as cooling_device2
[    9.639572] input: Video Bus as /class/input/input6
[    9.654162] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.654275] Warning! ehci_hcd should always be loaded before uhci_hcd an=
d ohci_hcd, not after
[    9.656033] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    9.656156] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[    9.656295] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    9.656299] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    9.656450] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 7
[    9.660547] ehci_hcd 0000:00:1a.7: debug port 1
[    9.660659] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    9.660681] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    9.676021] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    9.676289] usb usb7: configuration #1 chosen from 1 choice
[    9.676441] hub 7-0:1.0: USB hub found
[    9.676555] hub 7-0:1.0: 6 ports detected
[    9.676824] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    9.677869] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    9.677988] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[    9.678126] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    9.678130] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.678269] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 8
[    9.682362] ehci_hcd 0000:00:1d.7: debug port 1
[    9.682474] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    9.682494] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    9.686981] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    9.696039] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.696242] usb usb8: configuration #1 chosen from 1 choice
[    9.696384] hub 8-0:1.0: USB hub found
[    9.696497] hub 8-0:1.0: 6 ports detected
[    9.973665] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[    9.973852] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    9.974035] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    9.974152] iwlagn 0000:03:00.0: setting latency timer to 64
[    9.974187] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[    9.992777] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    9.993057] iwlagn 0000:03:00.0: PCI INT A disabled
[    9.993274] wmaster0 (iwlagn): not using net_device_ops yet
[    9.993586] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   10.104051] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 3
[   10.175307] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   10.175653] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   10.177279] wlan0 (iwlagn): not using net_device_ops yet
[   10.237610] usb 7-5: configuration #1 chosen from 1 choice
[   10.237949] hub 7-5:1.0: USB hub found
[   10.238257] hub 7-5:1.0: 4 ports detected
[   10.361060] usb 7-6: new high speed USB device using ehci_hcd and addres=
s 4
[   10.466139] input: HDA Intel at 0xf2620000 irq 17 Mic as /class/input/in=
put7
[   10.481295] input: HDA Intel at 0xf2620000 irq 17 Mic as /class/input/in=
put8
[   10.493226] input: HDA Intel at 0xf2620000 irq 17 Headphone as /class/in=
put/input9
[   10.502033] usb 7-6: configuration #1 chosen from 1 choice
[   10.616037] usb 8-6: new high speed USB device using ehci_hcd and addres=
s 2
[   10.762733] usb 8-6: configuration #1 chosen from 1 choice
[   10.853609] usbcore: registered new interface driver libusual
[   10.878492] Initializing USB Mass Storage driver...
[   10.879713] scsi4 : SCSI emulation for USB Mass Storage devices
[   10.880188] usb-storage: device found at 2
[   10.880191] usb-storage: waiting for device to settle before scanning
[   10.880193] usbcore: registered new interface driver usb-storage
[   10.880196] USB Mass Storage support registered.
[   11.001183] usb 2-1: new full speed USB device using uhci_hcd and addres=
s 2
[   11.173396] usb 2-1: configuration #1 chosen from 1 choice
[   11.376276] usb 7-5.2: new high speed USB device using ehci_hcd and addr=
ess 5
[   11.471726] usb 7-5.2: configuration #1 chosen from 1 choice
[   11.482357] scsi5 : SCSI emulation for USB Mass Storage devices
[   11.487961] usb-storage: device found at 5
[   11.487966] usb-storage: waiting for device to settle before scanning
[   11.572125] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 6
[   11.667008] usb 7-5.4: configuration #1 chosen from 1 choice
[   11.802931] usblp0: USB Bidirectional printer dev 6 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[   11.803118] usbcore: registered new interface driver usblp
[   13.968284] loop: module loaded
[   14.616050] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   15.880363] isa bounce pool size: 16 pages
[   15.881134] scsi 4:0:0:0: Direct-Access     RICOH    R5U880FlashMedia 00=
00 PQ: 0 ANSI: 2
[   16.073989] sd 4:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[   16.074731] sd 4:0:0:0: [sdb] Write Protect is off
[   16.074736] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   16.074741] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   16.076569] sd 4:0:0:0: [sdb] 1984000 512-byte hardware sectors: (1.01 G=
B/968 MiB)
[   16.077189] sd 4:0:0:0: [sdb] Write Protect is off
[   16.077196] sd 4:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   16.077201] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   16.077208]  sdb: sdb1
[   16.079573] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   16.079781] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   16.081842] usb-storage: device scan complete
[   16.568693] scsi 5:0:0:0: Direct-Access     Generic                CF 1.=
6E PQ: 0 ANSI: 0 CCS
[   16.570628] sd 5:0:0:0: [sdc] 2000880 512-byte hardware sectors: (1.02 G=
B/976 MiB)
[   16.571748] sd 5:0:0:0: [sdc] Write Protect is off
[   16.571755] sd 5:0:0:0: [sdc] Mode Sense: 43 00 00 08
[   16.571760] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[   16.574150] sd 5:0:0:0: [sdc] 2000880 512-byte hardware sectors: (1.02 G=
B/976 MiB)
[   16.575298] sd 5:0:0:0: [sdc] Write Protect is off
[   16.575305] sd 5:0:0:0: [sdc] Mode Sense: 43 00 00 08
[   16.575310] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[   16.575317]  sdc: sdc1
[   16.576974] sd 5:0:0:0: [sdc] Attached SCSI removable disk
[   16.577216] sd 5:0:0:0: Attached scsi generic sg3 type 0
[   16.578757] scsi 5:0:0:1: Direct-Access     Generic                MS 1.=
6E PQ: 0 ANSI: 0 CCS
[   16.589219] sd 5:0:0:1: [sdd] Attached SCSI removable disk
[   16.589389] sd 5:0:0:1: Attached scsi generic sg4 type 0
[   16.590775] scsi 5:0:0:2: Direct-Access     Generic            MMC/SD 1.=
6E PQ: 0 ANSI: 0 CCS
[   16.591884] sd 5:0:0:2: [sde] Attached SCSI removable disk
[   16.592062] sd 5:0:0:2: Attached scsi generic sg5 type 0
[   16.593396] scsi 5:0:0:3: Direct-Access     Generic                SM 1.=
6E PQ: 0 ANSI: 0 CCS
[   16.594502] sd 5:0:0:3: [sdf] Attached SCSI removable disk
[   16.594638] sd 5:0:0:3: Attached scsi generic sg6 type 0
[   16.595097] usb-storage: device scan complete
[   91.168562] fuse init (API version 7.11)
[   91.473246] Adding 4982032k swap on /dev/mapper/swap.  Priority:-1 exten=
ts:1 across:4982032k=20
[   94.096479] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   94.152186] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[   94.674944] Loading iSCSI transport class v2.0-870.
[   94.728723] iscsi: registered transport (tcp)
[   94.851751] NET: Registered protocol family 10
[   94.853003] lo: Disabled Privacy Extensions
[   94.854287] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   95.005249] iscsi: registered transport (iser)
[   97.100889] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[   97.101923] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  103.225227] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[  103.225454] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[  103.309046] input: /usr/sbin/thinkpad-keys as /class/input/input10
[  107.828125] eth0: no IPv6 routers present
[  112.762682] Bluetooth: Core ver 2.14
[  112.785168] NET: Registered protocol family 31
[  112.785306] Bluetooth: HCI device and connection manager initialized
[  112.785442] Bluetooth: HCI socket layer initialized
[  112.853500] Bluetooth: L2CAP ver 2.11
[  112.853609] Bluetooth: L2CAP socket layer initialized
[  112.857898] Bluetooth: RFCOMM socket layer initialized
[  112.858015] Bluetooth: RFCOMM TTY layer initialized
[  112.858120] Bluetooth: RFCOMM ver 1.10
[  113.330284] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[  113.330511] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[  113.330623] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[  113.330709] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[  113.506217] iwlagn loaded firmware version 5.4.1.16
[  113.507447] iwlagn: Radio disabled by HW RF Kill switch
[  113.518808] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  129.846561] [drm] Initialized drm 1.1.0 20060810
[  129.877658] pci 0000:00:02.0: power state changed by ACPI to D0
[  129.877678] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  129.877687] pci 0000:00:02.0: setting latency timer to 64
[  129.934945] pci 0000:00:02.0: irq 30 for MSI/MSI-X
[  129.935021] [drm] Initialized i915 1.6.0 20080730 on minor 0
[  129.988541] [drm:i915_initialize] *ERROR* can not ioremap virtual addres=
s for ring buffer
[  130.592105] eth0: no IPv6 routers present
[  224.847763] Registered led device: iwl-phy0:radio
[  224.847815] Registered led device: iwl-phy0:assoc
[  224.847866] Registered led device: iwl-phy0:RX
[  224.847912] Registered led device: iwl-phy0:TX
[ 1242.453678] ata2.00: disabled
[ 1242.456202] ata2.00: detaching (SCSI 1:0:0:0)
[ 1242.457248] ACPI: \_SB_.GDCK - undocking
[ 1242.463038] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0x=
e frozen
[ 1242.463047] ata2: irq_stat 0x00400040, connection status changed
[ 1242.463054] ata2: SError: { PHYRdyChg DevExch }
[ 1242.463071] ata2: hard resetting link
[ 1242.483562] usb 7-5: USB disconnect, address 3
[ 1242.483569] usb 7-5.2: USB disconnect, address 5
[ 1242.489553] usb 7-5.4: USB disconnect, address 6
[ 1242.489978] usblp0: removed
[ 1243.197140] ata2: SATA link down (SStatus 0 SControl 300)
[ 1243.197158] ata2: EH complete
[ 1264.628473] ACPI: \_SB_.GDCK - undocking
[ 1264.928150] e1000e: eth0 NIC Link is Down
[ 1265.263519] Monitor-Mwait will be used to enter C-3 state
[ 1265.265883] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1268.115702] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0x=
e frozen
[ 1268.115705] ata2: irq_stat 0x00000040, connection status changed
[ 1268.115708] ata2: SError: { CommWake DevExch }
[ 1268.115716] ata2: hard resetting link
[ 1268.721780] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[ 1268.722114] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 1268.837036] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1268.986225] thinkpad_acpi: EC reports that Thermal Table has changed
[ 1268.989938] ACPI: \_SB_.PCI0.SATA.PRT1 - docking
[ 1268.990212] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x100)
[ 1269.092182] ACPI: \_SB_.GDCK - docking
[ 1269.108823] ata2: hard resetting link
[ 1269.229029] usb 7-5: new high speed USB device using ehci_hcd and addres=
s 7
[ 1269.368039] usb 7-5: configuration #1 chosen from 1 choice
[ 1269.368169] hub 7-5:1.0: USB hub found
[ 1269.368253] hub 7-5:1.0: 4 ports detected
[ 1269.425037] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1269.431066] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 1269.431967] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 1269.435913] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX10, max UDMA/133
[ 1269.443139] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 1269.444103] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 1269.448049] ata2.00: configured for UDMA/133
[ 1269.554800] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[ 1269.554804] ata2: irq_stat 0x40000001
[ 1269.563259] ata2.00: configured for UDMA/133
[ 1269.563268] ata2: EH complete
[ 1269.566961] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX=
10 PQ: 0 ANSI: 5
[ 1269.644140] usb 7-5.4: new full speed USB device using ehci_hcd and addr=
ess 8
[ 1269.750512] usb 7-5.4: configuration #1 chosen from 1 choice
[ 1269.756441] usblp0: USB Bidirectional printer dev 8 if 0 alt 1 proto 2 v=
id 0x03F0 pid 0x0B17
[ 1269.897909] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[ 1269.899229] sr 1:0:0:0: Attached scsi CD-ROM sr0
[ 1269.899339] sr 1:0:0:0: Attached scsi generic sg1 type 5
[ 1269.969144] usb 7-5.2: new high speed USB device using ehci_hcd and addr=
ess 9
[ 1270.063776] usb 7-5.2: configuration #1 chosen from 1 choice
[ 1270.064714] scsi6 : SCSI emulation for USB Mass Storage devices
[ 1270.064772] usb-storage: device found at 9
[ 1270.064774] usb-storage: waiting for device to settle before scanning
[ 1275.144895] scsi 6:0:0:0: Direct-Access     Generic                CF 1.=
6E PQ: 0 ANSI: 0 CCS
[ 1275.147604] sd 6:0:0:0: [sdc] 2000880 512-byte hardware sectors: (1.02 G=
B/976 MiB)
[ 1275.148820] sd 6:0:0:0: [sdc] Write Protect is off
[ 1275.148826] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 08
[ 1275.148831] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[ 1275.151317] sd 6:0:0:0: [sdc] 2000880 512-byte hardware sectors: (1.02 G=
B/976 MiB)
[ 1275.152433] sd 6:0:0:0: [sdc] Write Protect is off
[ 1275.152440] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 08
[ 1275.152446] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[ 1275.152453]  sdc: sdc1
[ 1275.154138] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[ 1275.154372] sd 6:0:0:0: Attached scsi generic sg3 type 0
[ 1275.155681] scsi 6:0:0:1: Direct-Access     Generic                MS 1.=
6E PQ: 0 ANSI: 0 CCS
[ 1275.157221] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[ 1275.157399] sd 6:0:0:1: Attached scsi generic sg4 type 0
[ 1275.158814] scsi 6:0:0:2: Direct-Access     Generic            MMC/SD 1.=
6E PQ: 0 ANSI: 0 CCS
[ 1275.159912] sd 6:0:0:2: [sde] Attached SCSI removable disk
[ 1275.160563] sd 6:0:0:2: Attached scsi generic sg5 type 0
[ 1275.161949] scsi 6:0:0:3: Direct-Access     Generic                SM 1.=
6E PQ: 0 ANSI: 0 CCS
[ 1275.163056] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[ 1275.163213] sd 6:0:0:3: Attached scsi generic sg6 type 0
[ 1275.163688] usb-storage: device scan complete
[ 1291.672018] eth0: no IPv6 routers present
[ 2543.158295] PM: Syncing filesystems ... done.
[ 2544.175329] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[ 2544.176160] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 2544.176434] Suspending console(s) (use no_console_suspend to debug)
[ 2544.192266] pci 0000:00:02.0: power state changed by ACPI to D3
[ 2544.868399] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 2544.868523] sd 0:0:0:0: [sda] Stopping disk
[ 2545.247175] iwlagn 0000:03:00.0: PCI INT A disabled
[ 2545.308266] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[ 2545.308342] ehci_hcd 0000:00:1d.7: PME# disabled
[ 2545.328005] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[ 2545.328023] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 2545.328091] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 2545.328157] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 2545.341068] HDA Intel 0000:00:1b.0: PCI INT B disabled
[ 2545.356171] ehci_hcd 0000:00:1a.7: PCI INT D disabled
[ 2545.356246] ehci_hcd 0000:00:1a.7: PME# disabled
[ 2545.374767] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[ 2545.374784] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[ 2545.374852] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 2545.374917] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 2545.430981] e1000e 0000:00:19.0: PME# enabled
[ 2545.431001] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 2545.431009] e1000e 0000:00:19.0: PME# enabled
[ 2545.431013] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 2545.431023] e1000e 0000:00:19.0: PCI INT A disabled
[ 2545.449469] ACPI: Preparing to enter system sleep state S3
[ 2545.472950] Disabling non-boot CPUs ...
[ 2545.475228] kvm: disabling virtualization on CPU1
[ 2545.576073] CPU 1 is now offline
[ 2545.576078] SMP alternatives: switching to UP code
[ 2545.720160] CPU1 is down
[ 2545.720277] Extended CMOS year: 2000
[ 2545.720277] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[ 2545.720277] Back to C!
[ 2545.720277] Extended CMOS year: 2000
[ 2545.720277] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900007, writing 0x900003)
[ 2545.720277] pci 0000:00:02.1: restoring config space at offset 0x1 (was =
0x900000, writing 0x900007)
[ 2545.720277] pci 0000:00:03.0: restoring config space at offset 0xf (was =
0x100, writing 0x10b)
[ 2545.720277] pci 0000:00:03.0: restoring config space at offset 0x1 (was =
0x100006, writing 0x180006)
[ 2545.720277] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 2545.720277] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 2545.720277] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 2545.720277] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[ 2545.720277] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100106, writing 0x100102)
[ 2545.720277] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x7 (was 0xf0, writing 0x200000f0)
[ 2545.720277] pcieport-driver 0000:00:1c.0: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[ 2545.720277] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x7 (was 0xf0, writing 0x200000f0)
[ 2545.720277] pcieport-driver 0000:00:1c.1: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[ 2545.720277] pcieport-driver 0000:00:1c.3: restoring config space at offs=
et 0x1 (was 0x100107, writing 0x100507)
[ 2545.720277] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 2545.720277] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 2545.720277] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 =
(was 0x2900005, writing 0x2900001)
[ 2545.720277] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 =
(was 0x2900106, writing 0x2900102)
[ 2545.720277] pci 0000:00:1e.0: restoring config space at offset 0xf (was =
0x40000, writing 0x400ff)
[ 2545.720277] pci 0000:00:1e.0: restoring config space at offset 0x9 (was =
0x10001, writing 0x1fff1)
[ 2545.720277] pci 0000:00:1e.0: restoring config space at offset 0x8 (was =
0x0, writing 0xfff0)
[ 2545.720277] pci 0000:00:1e.0: restoring config space at offset 0x7 (was =
0x22800000, writing 0x228000f0)
[ 2545.720277] pci 0000:00:1e.0: restoring config space at offset 0x1 (was =
0x100000, writing 0x100107)
[ 2545.720277] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00007, writing 0x2b00407)
[ 2545.720277] Enabling non-boot CPUs ...
[ 2545.720277] SMP alternatives: switching to SMP code
[ 2545.841998] Booting processor 1 APIC 0x1 ip 0x6000
[ 2545.710873] Initializing CPU#1
[ 2545.710873] Calibrating delay using timer specific routine.. 4521.94 Bog=
oMIPS (lpj=3D9043883)
[ 2545.710873] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 2545.710873] CPU: L2 cache: 3072K
[ 2545.710873] [ds] using Core 2/Atom configuration
[ 2545.710873] CPU: Physical Processor ID: 0
[ 2545.710873] CPU: Processor Core ID: 1
[ 2545.710873] CPU1: Thermal monitoring enabled (TM2)
[ 2545.710873] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[ 2545.933279] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[ 2545.933287] kvm: enabling virtualization on CPU1
[ 2545.936014] Switched to high resolution mode on CPU 1
[ 2545.944339] CPU1 is up
[ 2545.944341] ACPI: Waking up from system sleep state S3
[ 2545.983029] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[ 2546.027474] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[ 2546.030814] pci 0000:00:02.0: PME# disabled
[ 2546.030818] pci 0000:00:02.1: PME# disabled
[ 2546.030820] pci 0000:00:03.0: PME# disabled
[ 2546.030875] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[ 2546.030879] e1000e 0000:00:19.0: setting latency timer to 64
[ 2546.030883] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 2546.030886] e1000e 0000:00:19.0: PME# disabled
[ 2546.030888] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 2546.030891] e1000e 0000:00:19.0: PME# disabled
[ 2546.030922] e1000e 0000:00:19.0: irq 28 for MSI/MSI-X
[ 2546.088612] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[ 2546.088618] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[ 2546.088625] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 2546.088648] usb usb1: root hub lost power or was reset
[ 2546.088668] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[ 2546.088675] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 2546.088697] usb usb2: root hub lost power or was reset
[ 2546.089415] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[ 2546.089420] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[ 2546.089426] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[ 2546.089454] usb usb3: root hub lost power or was reset
[ 2546.089473] ehci_hcd 0000:00:1a.7: PME# disabled
[ 2546.090032] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[ 2546.090039] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[ 2546.090046] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 2546.090053] ehci_hcd 0000:00:1a.7: PME# disabled
[ 2546.090072] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[ 2546.090078] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 2546.090095] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[ 2546.090104] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[ 2546.090111] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[ 2546.090547] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 2546.090553] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[ 2546.090559] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 2546.090581] usb usb4: root hub lost power or was reset
[ 2546.090600] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[ 2546.090606] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 2546.090628] usb usb5: root hub lost power or was reset
[ 2546.090647] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[ 2546.090653] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 2546.090675] usb usb6: root hub lost power or was reset
[ 2546.090693] ehci_hcd 0000:00:1d.7: PME# disabled
[ 2546.091413] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[ 2546.091420] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[ 2546.091426] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 2546.091433] ehci_hcd 0000:00:1d.7: PME# disabled
[ 2546.091453] pci 0000:00:1e.0: setting latency timer to 64
[ 2546.091521] ahci 0000:00:1f.2: setting latency timer to 64
[ 2546.091630] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[ 2546.091777] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
[ 2546.103494] sd 0:0:0:0: [sda] Starting disk
[ 2546.122507] Registered led device: iwl-phy0:radio
[ 2546.122554] Registered led device: iwl-phy0:assoc
[ 2546.122599] Registered led device: iwl-phy0:RX
[ 2546.122644] Registered led device: iwl-phy0:TX
[ 2546.412134] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2546.418645] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 2546.419562] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 2546.431335] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 2546.432246] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 2546.436177] ata2.00: configured for UDMA/133
[ 2548.036123] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 2548.093468] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 2548.093474] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 2548.093649] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 2548.093654] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 2548.104468] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 2548.104474] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 2548.104629] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 2548.104634] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 2548.105561] ata1.00: configured for UDMA/100
[ 2548.107674] ata1.00: configured for UDMA/100
[ 2548.120117] ata1: EH complete
[ 2548.120193] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[ 2548.120229] sd 0:0:0:0: [sda] Write Protect is off
[ 2548.120233] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 2548.120283] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 2548.120337] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[ 2548.120367] sd 0:0:0:0: [sda] Write Protect is off
[ 2548.120371] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 2548.120420] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 2548.432937] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: RX/TX
[ 2549.532120] usb 7-6: reset high speed USB device using ehci_hcd and addr=
ess 4
[ 2549.780130] usb 8-6: reset high speed USB device using ehci_hcd and addr=
ess 2
[ 2550.036126] usb 2-1: reset full speed USB device using uhci_hcd and addr=
ess 2
[ 2550.187387] pci 0000:00:02.0: power state changed by ACPI to D0
[ 2550.187422] pci 0000:00:02.0: restoring config space at offset 0x1 (was =
0x900403, writing 0x900003)
[ 2550.187589] pci 0000:00:02.0: power state changed by ACPI to D0
[ 2550.187601] pci 0000:00:02.0: setting latency timer to 64
[ 2550.364242] usb 7-5.2: reset high speed USB device using ehci_hcd and ad=
dress 9
[ 2550.472349] Restarting tasks ... done.
[ 2553.688234] e1000e: eth0 NIC Link is Down
[ 2556.696898] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: None
[ 2556.697753] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 2584.132153] eth0: no IPv6 routers present


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmVQCAACgkQuL75KpiFGIxz4ACg5sKXQlYmYhO14Pwq0otGtmXT
XU8AnjoAtNlsNUdjqfhoFrD8oa61Qxe0
=1dye
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
