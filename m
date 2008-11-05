Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYKETPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYKETPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYKETP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:15:27 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:38195 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYKETPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:15:23 -0500
Date: Wed, 5 Nov 2008 18:24:50 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Mac802.11/iwlagn call trace in linux-next: Tree for November 5
Message-ID: <20081105172450.GA4514@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20081105184329.54511ab4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20081105184329.54511ab4.sfr@canb.auug.org.au>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc3-next-20081105-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Stephen Rothwell [Wed, Nov 05, 2008 at 06:43:29PM +1100]:
> Hi all,
>=20
> Changes since 20081103:

Call trace reported on Lenovo X200 attached.

Sincerly,

Nico

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2.6.28-rc3-next-20081105-denkbrett"
Content-Transfer-Encoding: quoted-printable

[    0.000000] BIOS EBDA/lowmem at: 0009ec00/0009ec00
[    0.000000] Linux version 2.6.28-rc3-next-20081105-denkbrett (compiler@i=
kn) (gcc version 4.3.2 (Debian 4.3.2-1) ) #11 SMP PREEMPT Wed Nov 5 17:22:5=
9 CET 2008
[    0.000000] Command line: root=3D/dev/sda1 ro init=3D/bin/sh
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
[    0.000000] last_pfn =3D 0x7ca00 max_arch_pfn =3D 0x3ffffffff
[    0.000000] init_memory_mapping: 0000000000000000-000000007ca00000
[    0.000000]  0000000000 - 007ca00000 page 2M
[    0.000000] kernel direct mapping tables up to 7ca00000 @ 8000-b000
[    0.000000] last_map_addr: 7ca00000 end: 7ca00000
[    0.000000] ACPI: RSDP 000F73A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 7C97BD45, 009C (r1 LENOVO TP-6D        1050  LTP =
       0)
[    0.000000] ACPI: FACP 7C97BF00, 00F4 (r3 LENOVO TP-6D        1050 LNVO =
       1)
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
[    0.000000]   #2 [0000200000 - 00006c929c]    TEXT DATA BSS =3D=3D> [000=
0200000 - 00006c929c]
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
[    0.000000]   DMA zone: 1328 pages reserved
[    0.000000]   DMA zone: 2614 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6923 pages used for memmap
[    0.000000]   DMA32 zone: 498526 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7f000000=
:61000000)
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 501140
[    0.000000] Kernel command line: root=3D/dev/sda1 ro init=3D/bin/sh
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.959 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes)
[    0.004000] Memory: 2000036k/2041856k available (2671k kernel code, 4068=
k absent, 37024k reserved, 1298k data, 336k init)
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.004000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4521.91 BogoMIPS (lpj=3D9043836)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.038391] Parsing all Control Methods:
[    0.039157] Table [DSDT](id 0001) - 1541 Objects with 67 Devices 413 Met=
hods 31 Regions
[    0.039819] Parsing all Control Methods:
[    0.040586] Table [SSDT](id 0002) - 11 Objects with 0 Devices 7 Methods =
0 Regions
[    0.041798] Parsing all Control Methods:
[    0.042563] Table [SSDT](id 0003) - 43 Objects with 2 Devices 6 Methods =
0 Regions
[    0.043627] Parsing all Control Methods:
[    0.044425] Table [SSDT](id 0004) - 27 Objects with 0 Devices 16 Methods=
 0 Regions
[    0.045008] Parsing all Control Methods:
[    0.045786] Table [SSDT](id 0005) - 7 Objects with 0 Devices 4 Methods 0=
 Regions
[    0.046423] Parsing all Control Methods:
[    0.047205] Table [SSDT](id 0006) - 12 Objects with 0 Devices 12 Methods=
 0 Regions
[    0.047558]  tbxface-0596 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[    0.048011] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[    0.048387] Setting APIC routing to flat
[    0.048891] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.089102] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.092001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4522.05 Bog=
oMIPS (lpj=3D9044112)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 3072K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.177239] CPU1: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz steppi=
ng 06
[    0.178471] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.180028] Brought up 2 CPUs
[    0.180158] Total of 2 processors activated (9043.97 BogoMIPS).
[    0.180395] net_namespace: 1320 bytes
[    0.184040] regulator: core version 0.5
[    0.184191] NET: Registered protocol family 16
[    0.184217] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.184224] ACPI: bus type pci registered
[    0.184376] PCI: Using configuration type 1 for base access
[    0.194203] evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 3F [_GP=
E] 8 regs on int 0x9
[    0.196266] ACPI: EC: EC description table is found, configuring boot EC
[    0.200636] Completing Region/Field/Buffer/Package initialization:......=
=2E........................................................................=
=2E........................................................................=
=2E........................................................................=
=2E.......................
[    0.227601] Initialized 30/31 Regions 97/97 Fields 51/51 Buffers 71/71 P=
ackages (1650 nodes)
[    0.227936] Initializing Device/Processor/Thermal objects by executing _=
INI methods:<5>ACPI: BIOS _OSI(Linux) query ignored
[    0.229179] ACPI: DMI System Vendor: LENOVO
[    0.229309] ACPI: DMI Product Name: 7458AH8
[    0.229438] ACPI: DMI Product Version: ThinkPad X200
[    0.229568] ACPI: DMI Board Name: 7458AH8
[    0.229697] ACPI: DMI BIOS Vendor: LENOVO
[    0.229825] ACPI: DMI BIOS Date: 07/30/2008
[    0.229954] ACPI: Please send DMI info above to linux-acpi@vger.kernel.o=
rg
[    0.230088] ACPI: If "acpi_osi=3DLinux" works better, please notify linu=
x-acpi@vger.kernel.org
[    0.228025] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.234652] .......
[    0.246829] Executed 7 _INI methods requiring 1 _STA executions (examine=
d 77 objects)
[    0.248227] evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 9 Wake, Ena=
bled 3 Runtime GPEs in this block
[    0.248569] ACPI: Interpreter enabled
[    0.248699] ACPI: (supports S0 S3 S5)
[    0.249002] ACPI: Using IOAPIC for interrupt routing
[    0.292428] ACPI: EC: GPE =3D 0x11, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.292564] ACPI: EC: driver started in interrupt mode
[    0.297519] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.297688] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.297688] pci 0000:00:02.0: reg 10 64bit mmio: [0xf2000000-0xf23fffff]
[    0.297688] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.297688] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.297688] pci 0000:00:02.1: reg 10 64bit mmio: [0xf2400000-0xf24fffff]
[    0.297688] pci 0000:00:03.0: reg 10 64bit mmio: [0xf2826800-0xf282680f]
[    0.297688] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.297688] pci 0000:00:03.0: PME# disabled
[    0.297688] pci 0000:00:19.0: reg 10 32bit mmio: [0xf2600000-0xf261ffff]
[    0.297688] pci 0000:00:19.0: reg 14 32bit mmio: [0xf2625000-0xf2625fff]
[    0.297688] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.297688] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.297688] pci 0000:00:19.0: PME# disabled
[    0.297688] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.297688] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.297688] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.297688] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf2826c00-0xf2826fff]
[    0.297688] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.297722] pci 0000:00:1a.7: PME# disabled
[    0.297923] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf2620000-0xf2623fff]
[    0.297975] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.298112] pci 0000:00:1b.0: PME# disabled
[    0.298322] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.298459] pci 0000:00:1c.0: PME# disabled
[    0.298672] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.298808] pci 0000:00:1c.1: PME# disabled
[    0.299024] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.299160] pci 0000:00:1c.3: PME# disabled
[    0.299389] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.299502] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.299615] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.299732] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf2827000-0xf28273ff]
[    0.299798] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.300010] pci 0000:00:1d.7: PME# disabled
[    0.300426] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.300438] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.300449] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.300461] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.300472] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.300484] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf2826000-0xf28267ff]
[    0.300512] pci 0000:00:1f.2: PME# supported from D3hot
[    0.300646] pci 0000:00:1f.2: PME# disabled
[    0.300827] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf2827400-0xf28274ff]
[    0.300854] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.301072] pci 0000:03:00.0: reg 10 64bit mmio: [0xf2500000-0xf2501fff]
[    0.301157] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.301297] pci 0000:03:00.0: PME# disabled
[    0.301515] pci 0000:00:1c.1: bridge 32bit mmio: [0xf2500000-0xf25fffff]
[    0.301600] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.301608] pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
[    0.301620] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf2900000-0xf29f=
ffff]
[    0.301708] pci 0000:00:1e.0: transparent bridge
[    0.301884] bus 00 -> node 0
[    0.301904] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.302780] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.303180] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.303584] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.316456] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.316535] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.317705] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.318871] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.320054] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.321221] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.322386] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.323553] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.324349] ACPI: Power Resource [PUBS] (on)
[    0.328605] SCSI subsystem initialized
[    0.328605] libata version 3.00 loaded.
[    0.328605] PCI: Using ACPI for IRQ routing
[    0.340029] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.340389] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.362683] pnp: PnP ACPI init
[    0.362825] ACPI: bus type pnp registered
[    0.432411] pnp: PnP ACPI: found 10 devices
[    0.432544] ACPI: ACPI bus type pnp unregistered
[    0.432691] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.432827] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.432962] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.433097] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.433232] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.433367] system 00:00: iomem range 0xd0000-0xd3fff has been reserved
[    0.433503] system 00:00: iomem range 0xdc000-0xdffff could not be reser=
ved
[    0.433639] system 00:00: iomem range 0xe0000-0xe3fff could not be reser=
ved
[    0.433774] system 00:00: iomem range 0xe4000-0xe7fff could not be reser=
ved
[    0.433910] system 00:00: iomem range 0xe8000-0xebfff could not be reser=
ved
[    0.434046] system 00:00: iomem range 0xec000-0xeffff could not be reser=
ved
[    0.434181] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.434317] system 00:00: iomem range 0x100000-0x7effffff could not be r=
eserved
[    0.434530] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be=
 reserved
[    0.434757] system 00:00: iomem range 0xfed4c000-0xffffffff could not be=
 reserved
[    0.434979] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.435114] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.435249] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.435384] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.435519] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.435654] system 00:02: ioport range 0x1600-0x1641 has been reserved
[    0.435789] system 00:02: ioport range 0x1600-0x161b has been reserved
[    0.435926] system 00:02: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.436062] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.436199] system 00:02: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.436339] system 00:02: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.436475] system 00:02: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.436612] system 00:02: iomem range 0xfed45000-0xfed4bfff has been res=
erved
[    0.442355] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.442489] pci 0000:00:1c.0:   IO window: disabled
[    0.442625] pci 0000:00:1c.0:   MEM window: disabled
[    0.442771] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.442910] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.443042] pci 0000:00:1c.1:   IO window: disabled
[    0.443179] pci 0000:00:1c.1:   MEM window: 0xf2500000-0xf25fffff
[    0.443315] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.443452] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.443587] pci 0000:00:1c.3:   IO window: 0x2000-0x2fff
[    0.443724] pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf1ffffff
[    0.443861] pci 0000:00:1c.3:   PREFETCH window: 0x000000f2900000-0x0000=
00f29fffff
[    0.444080] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
[    0.444212] pci 0000:00:1e.0:   IO window: disabled
[    0.444347] pci 0000:00:1e.0:   MEM window: disabled
[    0.444481] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.444636] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.444774] pci 0000:00:1c.0: setting latency timer to 64
[    0.444790] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.444927] pci 0000:00:1c.1: setting latency timer to 64
[    0.444943] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.445080] pci 0000:00:1c.3: setting latency timer to 64
[    0.445092] pci 0000:00:1e.0: setting latency timer to 64
[    0.445100] bus: 00 index 0 io port: [0x00-0xffff]
[    0.445231] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.445364] bus: 02 index 0 mmio: [0x0-0x0]
[    0.445493] bus: 02 index 1 mmio: [0x0-0x0]
[    0.445623] bus: 02 index 2 mmio: [0x0-0x0]
[    0.445752] bus: 02 index 3 mmio: [0x0-0x0]
[    0.445882] bus: 03 index 0 mmio: [0x0-0x0]
[    0.446011] bus: 03 index 1 mmio: [0xf2500000-0xf25fffff]
[    0.446143] bus: 03 index 2 mmio: [0x0-0x0]
[    0.446273] bus: 03 index 3 mmio: [0x0-0x0]
[    0.446403] bus: 05 index 0 io port: [0x2000-0x2fff]
[    0.446534] bus: 05 index 1 mmio: [0xf0000000-0xf1ffffff]
[    0.446679] bus: 05 index 2 mmio: [0xf2900000-0xf29fffff]
[    0.446811] bus: 05 index 3 mmio: [0x0-0x0]
[    0.446940] bus: 0d index 0 mmio: [0x0-0x0]
[    0.447069] bus: 0d index 1 mmio: [0x0-0x0]
[    0.447198] bus: 0d index 2 mmio: [0x0-0x0]
[    0.447328] bus: 0d index 3 io port: [0x00-0xffff]
[    0.447459] bus: 0d index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.447606] NET: Registered protocol family 2
[    0.486774] IP route cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.488005] TCP established hash table entries: 262144 (order: 10, 41943=
04 bytes)
[    0.490852] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.491805] TCP: Hash tables configured (established 262144 bind 65536)
[    0.491940] TCP reno registered
[    0.502841] NET: Registered protocol family 1
[    0.503438] Simple Boot Flag at 0x35 set to 0x1
[    0.505753] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
[    0.511690] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.518052] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.523204] msgmni has been set to 3907
[    0.523755] io scheduler noop registered
[    0.523886] io scheduler anticipatory registered (default)
[    0.524018] io scheduler deadline registered
[    0.524291] io scheduler cfq registered
[    0.524442] pci 0000:00:02.0: Boot video device
[    0.616576] Switched to high resolution mode on CPU 0
[    0.616582] Switched to high resolution mode on CPU 1
[    0.619731] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.619790] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.619969] pcieport-driver 0000:00:1c.0: irq 47 for MSI/MSI-X
[    0.619992] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.620099] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.620264] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.620322] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.620494] pcieport-driver 0000:00:1c.1: irq 46 for MSI/MSI-X
[    0.620517] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.620597] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.620757] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.620814] pcieport-driver 0000:00:1c.3: found MSI capability
[    0.620986] pcieport-driver 0000:00:1c.3: irq 45 for MSI/MSI-X
[    0.621009] pci_express 0000:00:1c.3:pcie00: allocate port service
[    0.621100] pci_express 0000:00:1c.3:pcie02: allocate port service
[    0.622561] ACPI: AC Adapter [AC] (off-line)
[    0.654229] ACPI Warning (nspredef-0858): \_SB_.PCI0.LPC_.EC__.BAT0._BIF=
: Return Package type mismatch at index 9 - found Buffer, expected String [=
20080926]
[    0.663377] ACPI: Battery Slot [BAT0] (battery present)
[    0.663788] input: Power Button (FF) as /class/input/input0
[    0.663924] ACPI: Power Button (FF) [PWRF]
[    0.664218] input: Lid Switch as /class/input/input1
[    0.664973] ACPI: Lid Switch [LID]
[    0.665287] input: Sleep Button (CM) as /class/input/input2
[    0.665427] ACPI: Sleep Button (CM) [SLPB]
[    0.667524] ACPI: SSDT 7C6D6C20, 02C8 (r1  PmRef  Cpu0Ist     3000 INTL =
20050624)
[    0.667928] Parsing all Control Methods:
[    0.668714] Table [SSDT](id 0018) - 6 Objects with 0 Devices 4 Methods 0=
 Regions
[    0.669799] ACPI: SSDT 7C6D4020, 087A (r1  PmRef  Cpu0Cst     3001 INTL =
20050624)
[    0.670302] Parsing all Control Methods:
[    0.671094] Table [SSDT](id 0019) - 16 Objects with 0 Devices 1 Methods =
0 Regions
[    0.682044] Monitor-Mwait will be used to enter C-1 state
[    0.682051] Monitor-Mwait will be used to enter C-2 state
[    0.682057] Monitor-Mwait will be used to enter C-3 state
[    0.682066] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.682627] processor ACPI0007:00: registered as cooling_device0
[    0.682784] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.684506] ACPI: SSDT 7C6D5CA0, 01CF (r1  PmRef    ApIst     3000 INTL =
20050624)
[    0.684965] Parsing all Control Methods:
[    0.685764] Table [SSDT](id 0026) - 12 Objects with 0 Devices 12 Methods=
 0 Regions
[    0.686586] ACPI: SSDT 7C6D5F20, 008D (r1  PmRef    ApCst     3000 INTL =
20050624)
[    0.686963] Parsing all Control Methods:
[    0.687761] Table [SSDT](id 0028) - 3 Objects with 0 Devices 3 Methods 0=
 Regions
[    0.692535] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.692944] processor ACPI0007:01: registered as cooling_device1
[    0.693094] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.721033] Marking TSC unstable due to possible TSC halt in C2
[    0.743823] thermal LNXTHERM:01: registered as thermal_zone0
[    0.748048] ACPI: Thermal Zone [THM0] (33 C)
[    0.750721] thermal LNXTHERM:02: registered as thermal_zone1
[    0.753730] ACPI: Thermal Zone [THM1] (31 C)
[    0.889076] Linux agpgart interface v0.103
[    1.000234] Clocksource tsc unstable (delta =3D -132158243 ns)
[    3.904279] floppy0: no floppy controllers found
[    3.911047] brd: module loaded
[    3.911476] Uniform Multi-Platform E-IDE driver
[    3.911995] ide-gd driver 1.18
[    3.912858] Driver 'sd' needs updating - please use bus_type methods
[    3.913164] ahci 0000:00:1f.2: version 3.0
[    3.913193] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    3.913404] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    3.913497] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
3 impl SATA mode
[    3.913713] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part=20
[    3.913930] ahci 0000:00:1f.2: setting latency timer to 64
[    3.914288] scsi0 : ahci
[    3.914754] scsi1 : ahci
[    3.915243] scsi2 : ahci
[    3.915661] scsi3 : ahci
[    3.917398] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282610=
0 irq 44
[    3.917613] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf282618=
0 irq 44
[    3.917824] ata3: DUMMY
[    3.917949] ata4: DUMMY
[    4.236260] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.281202] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.281210] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.281489] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.281497] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.282525] ata1.00: ATA-8: ST9250827AS, 3.CMF, max UDMA/100
[    4.282660] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    4.292119] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    4.292126] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    4.292359] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    4.292365] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    4.293401] ata1.00: configured for UDMA/100
[    4.321098] ata1.00: configured for UDMA/100
[    4.321238] ata1: EH complete
[    4.640265] ata2: SATA link down (SStatus 0 SControl 300)
[    4.704418] scsi 0:0:0:0: Direct-Access     ATA      ST9250827AS      3.=
CM PQ: 0 ANSI: 5
[    4.705234] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.705477] sd 0:0:0:0: [sda] Write Protect is off
[    4.705610] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.705659] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.705981] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 =
GB/232 GiB)
[    4.706217] sd 0:0:0:0: [sda] Write Protect is off
[    4.706350] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.706397] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.706614]  sda: sda1 sda2 sda3
[    4.759219] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.759848] Fusion MPT base driver 3.04.07
[    4.759978] Copyright (c) 1999-2008 LSI Corporation
[    4.760161] Fusion MPT SPI Host driver 3.04.07
[    4.761757] ieee1394: raw1394: /dev/raw1394 device initialized
[    4.762365] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 =
irq 1,12
[    4.772701] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.772851] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.773502] mice: PS/2 mouse device common for all mice
[    4.814339] oprofile: using NMI interrupt.
[    4.815160] TCP cubic registered
[    4.815298] NET: Registered protocol family 17
[    4.817532] registered taskstats version 1
[    4.819404] input: AT Translated Set 2 keyboard as /class/input/input3
[    5.066396] elantech.c: unexpected magic knock result 0x00, 0x02, 0x64.
[    5.384927] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    5.403381] input: TPPS/2 IBM TrackPoint as /class/input/input4
[    5.505153] VFS: Mounted root (jfs filesystem) readonly.
[    5.505321] Freeing unused kernel memory: 336k freed
[   17.741795] input: PC Speaker as /class/input/input5
[   18.324065] usbcore: registered new interface driver usbfs
[   18.324192] usbcore: registered new interface driver hub
[   18.329521] usbcore: registered new device driver usb
[   18.351555] Non-volatile memory driver v1.2
[   18.449514] agpgart-intel 0000:00:00.0: Intel Mobile Intel? GM45 Express=
 Chipset
[   18.450539] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[   18.453685] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   18.558379] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[   18.558497] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   18.558648] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ=
 20
[   18.558766] e1000e 0000:00:19.0: setting latency timer to 64
[   18.558861] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   18.629105] cfg80211: Calling CRDA to update world regulatory domain
[   18.647828] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:=
09:46:11
[   18.648058] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[   18.648228] 0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: 1008ff-0ff
[   18.714735] ACPI: WMI: Mapper loaded
[   18.748351] rtc_cmos 00:07: RTC can wake from S4
[   18.748651] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   18.748827] rtc0: alarms up to one month, y3k, 114 bytes nvram, , hpet i=
rqs irqs
[   18.817041] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   18.818103] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[   18.818263] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> I=
RQ 23
[   18.818468] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   18.818475] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   18.818707] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[   18.822859] ehci_hcd 0000:00:1a.7: debug port 1
[   18.823000] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[   18.823027] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[   18.836025] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   18.836401] usb usb1: configuration #1 chosen from 1 choice
[   18.836608] hub 1-0:1.0: USB hub found
[   18.836757] hub 1-0:1.0: 6 ports detected
[   18.837194] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[   18.838222] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   18.838378] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> I=
RQ 19
[   18.838554] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   18.838561] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   18.838767] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[   18.842909] ehci_hcd 0000:00:1d.7: debug port 1
[   18.843069] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   18.843098] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[   18.856257] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   18.856651] usb usb2: configuration #1 chosen from 1 choice
[   18.856881] hub 2-0:1.0: USB hub found
[   18.857038] hub 2-0:1.0: 6 ports detected
[   18.861646] uhci_hcd: USB Universal Host Controller Interface driver
[   18.862564] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[   18.862718] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> I=
RQ 20
[   18.862873] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   18.862880] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   18.863090] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[   18.863376] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[   18.863751] usb usb3: configuration #1 chosen from 1 choice
[   18.863956] hub 3-0:1.0: USB hub found
[   18.864130] hub 3-0:1.0: 2 ports detected
[   18.864493] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[   18.864641] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   18.864648] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   18.864866] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[   18.865131] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[   18.865455] usb usb4: configuration #1 chosen from 1 choice
[   18.865672] hub 4-0:1.0: USB hub found
[   18.865815] hub 4-0:1.0: 2 ports detected
[   18.866976] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[   18.867124] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> I=
RQ 22
[   18.867269] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   18.867275] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   18.867466] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[   18.867733] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[   18.868067] usb usb5: configuration #1 chosen from 1 choice
[   18.868270] hub 5-0:1.0: USB hub found
[   18.868413] hub 5-0:1.0: 2 ports detected
[   18.871784] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   18.871927] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   18.872093] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   18.872100] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   18.872290] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[   18.872621] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[   18.872941] usb usb6: configuration #1 chosen from 1 choice
[   18.873157] hub 6-0:1.0: USB hub found
[   18.873303] hub 6-0:1.0: 2 ports detected
[   18.873669] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> I=
RQ 17
[   18.873816] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   18.873823] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   18.874010] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[   18.874270] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[   18.874580] usb usb7: configuration #1 chosen from 1 choice
[   18.874787] hub 7-0:1.0: USB hub found
[   18.874927] hub 7-0:1.0: 2 ports detected
[   18.875309] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[   18.875466] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   18.875472] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   18.875663] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[   18.875925] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[   18.876256] usb usb8: configuration #1 chosen from 1 choice
[   18.876456] hub 8-0:1.0: USB hub found
[   18.876596] hub 8-0:1.0: 2 ports detected
[   19.037369] acpi device:03: registered as cooling_device2
[   19.038183] input: Video Bus as /class/input/input6
[   19.073102] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   19.076442] acpi device:0a: registered as cooling_device3
[   19.077140] input: Video Bus as /class/input/input7
[   19.113113] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: n=
o)
[   19.214006] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27ks
[   19.214173] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[   19.214341] vendor=3D8086 device=3D2942
[   19.214443] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   19.214553] iwlagn 0000:03:00.0: setting latency timer to 64
[   19.214586] iwlagn: Detected Intel Wireless WiFi Link 5300AGN REV=3D0x24
[   19.248034] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[   19.252638] thinkpad_acpi: ThinkPad ACPI Extras v0.21
[   19.252741] thinkpad_acpi: http://ibm-acpi.sf.net/
[   19.252842] thinkpad_acpi: ThinkPad BIOS 6DET28WW (1.05 ), EC 7XHT21WW-1=
=2E03
[   19.252947] thinkpad_acpi: Lenovo ThinkPad X200, model 7458AH8
[   19.253337] vendor=3D8086 device=3D2942
[   19.253445] iwlagn 0000:03:00.0: PCI INT A disabled
[   19.253823] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   19.253921] thinkpad_acpi: radio switch found; radios are disabled
[   19.254140] thinkpad_acpi: This ThinkPad has standard ACPI backlight bri=
ghtness control, supported by the ACPI video driver
[   19.254310] thinkpad_acpi: Disabling thinkpad-acpi brightness events by =
default...
[   19.260018] usb 1-6: new high speed USB device using ehci_hcd and addres=
s 3
[   19.261363] Registered led device: tpacpi::thinklight
[   19.261516] Registered led device: tpacpi::power
[   19.261635] Registered led device: tpacpi:orange:batt
[   19.261753] Registered led device: tpacpi:green:batt
[   19.261868] Registered led device: tpacpi::dock_active
[   19.261983] Registered led device: tpacpi::bay_active
[   19.262098] Registered led device: tpacpi::dock_batt
[   19.262213] Registered led device: tpacpi::unknown_led
[   19.262330] Registered led device: tpacpi::standby
[   19.269391] thinkpad_acpi: Lenovo BIOS switched to ACPI backlight contro=
l mode
[   19.269559] thinkpad_acpi: standard ACPI backlight interface available, =
not loading native one...
[   19.270007] input: ThinkPad Extra Buttons as /class/input/input8
[   19.295617] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[   19.295815] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   19.397435] usb 1-6: configuration #1 chosen from 1 choice
[   19.640084] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 2
[   19.805453] usb 4-1: configuration #1 chosen from 1 choice
[   20.133091] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   28.219377] alg: No test for stdrng (krng)
[   28.235014] alg: No test for stdrng (ansi_cprng)
[   65.301850] loop: module loaded
[   66.498773] Adding 4982032k swap on /dev/mapper/swap.  Priority:-1 exten=
ts:1 across:4982032k
[   68.852596] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   68.908323] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   73.485857] NET: Registered protocol family 10
[   73.487026] lo: Disabled Privacy Extensions
[   73.488315] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   76.088587] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is like=
ly not the best way to go about it
[   76.088813] thinkpad_acpi: please consider using the driver defaults, an=
d refer to up-to-date thinkpad-acpi documentation
[   76.168584] input: /usr/sbin/thinkpad-keys as /class/input/input9
[   82.369240] warning: `avahi-daemon' uses 32-bit capabilities (legacy sup=
port in use)
[   84.123509] Bluetooth: Core ver 2.13
[   84.123669] NET: Registered protocol family 31
[   84.125721] Bluetooth: HCI device and connection manager initialized
[   84.125840] Bluetooth: HCI socket layer initialized
[   84.142022] Bluetooth: L2CAP ver 2.11
[   84.142123] Bluetooth: L2CAP socket layer initialized
[   84.149638] Bluetooth: RFCOMM socket layer initialized
[   84.149750] Bluetooth: RFCOMM TTY layer initialized
[   84.149856] Bluetooth: RFCOMM ver 1.10
[   84.538500] vendor=3D8086 device=3D2942
[   84.538642] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   84.538860] iwlagn 0000:03:00.0: restoring config space at offset 0x1 (w=
as 0x100102, writing 0x100106)
[   84.538970] iwlagn 0000:03:00.0: irq 42 for MSI/MSI-X
[   84.539050] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.uco=
de
[   84.748853] iwlagn: Radio disabled by HW RF Kill switch
[   84.765997] ------------[ cut here ]------------
[   84.766145] WARNING: at net/mac80211/main.c:236 ieee80211_hw_config+0x71=
/0x79 [mac80211]()
[   84.766360] Modules linked in: rfcomm l2cap bluetooth uinput autofs4 ipv=
6 cpufreq_powersave md_mod loop sha256_generic ansi_cprng krng chainiv rng =
aes_x86_64 aes_generic cbc dm_crypt dm_mod arc4 ecb cryptomgr aead crypto_b=
lkcipher snd_hda_intel snd_pcm iwlagn iwlcore thinkpad_acpi snd_page_alloc =
snd_hwdep snd_seq rfkill hwmon snd_timer snd_seq_device video backlight mac=
80211 uhci_hcd i2c_i801 ehci_hcd output led_class rtc_cmos rtc_core rtc_lib=
 wmi snd i2c_core cfg80211 e1000e intel_agp nvram usbcore soundcore pcspkr
[   84.769696] Pid: 4050, comm: NetworkManager Not tainted 2.6.28-rc3-next-=
20081105-denkbrett #11
[   84.769912] Call Trace:
[   84.770049]  [<ffffffff802337f1>] warn_on_slowpath+0x51/0x75
[   84.770188]  [<ffffffff8046d200>] ip_mc_inc_group+0xdb/0x1d4
[   84.770327]  [<ffffffff8043f6ef>] rt_cache_flush+0x1f/0x100
[   84.770465]  [<ffffffff80433f1f>] qdisc_create_dflt+0x34/0x4a
[   84.770613]  [<ffffffffa0159342>] iwl4965_mac_config+0x219/0x236 [iwlagn]
[   84.770767]  [<ffffffffa00cf76e>] ieee80211_hw_config+0x71/0x79 [mac8021=
1]
[   84.770923]  [<ffffffffa00daa6d>] ieee80211_open+0x5b5/0x6d1 [mac80211]
[   84.771062]  [<ffffffff8043c0dd>] __nla_reserve+0x1e/0x46
[   84.771199]  [<ffffffff80424c60>] dev_open+0x74/0xb0
[   84.771333]  [<ffffffff8042463a>] dev_change_flags+0xab/0x169
[   84.771470]  [<ffffffff8042bd63>] do_setlink+0x2b0/0x373
[   84.771607]  [<ffffffff8042cca3>] rtnetlink_rcv_msg+0x0/0x1eb
[   84.771743]  [<ffffffff8042bfbc>] rtnl_setlink+0x10b/0x10d
[   84.771880]  [<ffffffff8042cca3>] rtnetlink_rcv_msg+0x0/0x1eb
[   84.772017]  [<ffffffff8043bf39>] netlink_rcv_skb+0x34/0x7f
[   84.772164]  [<ffffffff8042cc9d>] rtnetlink_rcv+0x1f/0x25
[   84.772299]  [<ffffffff8043ba36>] netlink_unicast+0x203/0x274
[   84.772436]  [<ffffffff8041e469>] __alloc_skb+0x61/0x123
[   84.772571]  [<ffffffff8043bd12>] netlink_sendmsg+0x26b/0x27e
[   84.772707]  [<ffffffff80417acb>] sock_sendmsg+0xe2/0xff
[   84.772844]  [<ffffffff80245ed4>] autoremove_wake_function+0x0/0x2e
[   84.772982]  [<ffffffff80416bfd>] move_addr_to_kernel+0x25/0x36
[   84.773135]  [<ffffffff80417cff>] sys_sendmsg+0x217/0x28a
[   84.773270]  [<ffffffff8043adca>] netlink_insert+0xfe/0x121
[   84.773406]  [<ffffffff804186f5>] move_addr_to_user+0x41/0x58
[   84.773542]  [<ffffffff80418bb1>] sys_getsockname+0x7a/0xaa
[   84.773679]  [<ffffffff8020b3fb>] system_call_fastpath+0x16/0x1b
[   84.773814] ---[ end trace 673baf482615c06a ]---
[   84.774570] ADDRCONF(NETDEV_UP): wlan0: link is not ready

--x+6KMIRAuhnl3hBn--

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkR1uIACgkQuL75KpiFGIwynQCgmHfHn8kXdIPrL35DzhdAqXuX
ixoAnRbfZRsZ76RXlGw58AsU3RjsBwT1
=fUa0
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
