Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYI1RqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYI1RqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 13:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYI1RqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 13:46:12 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:34585 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbYI1RqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 13:46:08 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc-7: BUG: scheduling while atomic: swapper/0/0x00000102
Date: Sun, 28 Sep 2008 19:45:59 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2381257.BLdxhLxZtz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809281946.03346.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2381257.BLdxhLxZtz
Content-Type: multipart/mixed;
  boundary="Boundary-01=_XL83Ina9BvgJ5pr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_XL83Ina9BvgJ5pr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I got this today:

Sep 28 14:36:15 graviton BUG: scheduling while atomic: swapper/0/0x00000102
Sep 28 14:36:15 graviton Modules linked in:
Sep 28 14:36:15 graviton CPU 0:
Sep 28 14:36:15 graviton Modules linked in:
Sep 28 14:36:15 graviton Pid: 0, comm: swapper Not tainted 2.6.27-rc7 #1
Sep 28 14:36:15 graviton RIP: 0010:[<ffffffff8022ccba>]  [<ffffffff8022ccba=
>]=20
default_idle+0x3a/0x40
Sep 28 14:36:15 graviton RSP: 0018:ffffffff807f9f70  EFLAGS: 00000246
Sep 28 14:36:15 graviton RAX: ffffffff807f9fd8 RBX: ffffffff8082f3e0 RCX:=20
0000000000000000
Sep 28 14:36:15 graviton RDX: ffffffff8084eb20 RSI: 0000000000000092 RDI:=20
ffffffff8088a120
Sep 28 14:36:15 graviton RBP: ffffffff80852700 R08: 0000000000000000 R09:=20
0000000100294985
Sep 28 14:36:15 graviton R10: 00000000ffffffff R11: ffffffff80237d80 R12:=20
ffffffff8025eeb7
Sep 28 14:36:15 graviton R13: 000002bbd7672100 R14: ffffffff802749bd R15:=20
0000000000000092
Sep 28 14:36:15 graviton FS:  00007ffe25b04760(0000) GS:ffffffff807f1280(00=
00)=20
knlGS:0000000000000000
Sep 28 14:36:15 graviton CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Sep 28 14:36:15 graviton CR2: 0000000000000000 CR3: 00000000728b9000 CR4:=20
00000000000006e0
Sep 28 14:36:15 graviton DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
Sep 28 14:36:15 graviton DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
Sep 28 14:36:15 graviton
Sep 28 14:36:15 graviton Call Trace:
Sep 28 14:36:15 graviton [<ffffffff8022cd58>] ? c1e_idle+0x98/0xe0
Sep 28 14:36:15 graviton [<ffffffff80222b9e>] ? cpu_idle+0x5e/0xf0
Sep 28 14:36:15 graviton


I guess I can work-around this when disabling c1e in BIOS, but didn't try t=
hat=20
so far. Any idea. Following the complete dmesg and attached the config



Sep 28 15:46:43 graviton syslog-ng[2193]: syslog-ng starting up;=20
version=3D'2.0.9'
Sep 28 15:46:43 graviton Linux version 2.6.27-rc7 (light@graviton) (gcc=20
version 4.3.1 (Gentoo 4.3.1-r1 p1.1) ) #1 SMP PREEMPT Wed Sep 24 18:42:22=20
CEST 2008
Sep 28 15:46:43 graviton Command line: root=3D/dev/md1 init=3D/sbin/init=20
sata_nv.swncq=3D1 snd-hda-intel.enable_msi=3D1
Sep 28 15:46:43 graviton KERNEL supported cpus:
Sep 28 15:46:43 graviton Intel GenuineIntel
Sep 28 15:46:43 graviton AMD AuthenticAMD
Sep 28 15:46:43 graviton Centaur CentaurHauls
Sep 28 15:46:43 graviton BIOS-provided physical RAM map:
Sep 28 15:46:43 graviton BIOS-e820: 0000000000000000 - 000000000009f400=20
(usable)
Sep 28 15:46:43 graviton BIOS-e820: 000000000009f400 - 00000000000a0000=20
(reserved)
Sep 28 15:46:43 graviton BIOS-e820: 00000000000f0000 - 0000000000100000=20
(reserved)
Sep 28 15:46:43 graviton BIOS-e820: 0000000000100000 - 000000007bfe0000=20
(usable)
Sep 28 15:46:43 graviton BIOS-e820: 000000007bfe0000 - 000000007bfe3000 (AC=
PI=20
NVS)
Sep 28 15:46:43 graviton BIOS-e820: 000000007bfe3000 - 000000007bff0000 (AC=
PI=20
data)
Sep 28 15:46:43 graviton BIOS-e820: 000000007bff0000 - 000000007c000000=20
(reserved)
Sep 28 15:46:43 graviton BIOS-e820: 00000000e0000000 - 00000000f0000000=20
(reserved)
Sep 28 15:46:43 graviton BIOS-e820: 00000000fec00000 - 0000000100000000=20
(reserved)
Sep 28 15:46:43 graviton last_pfn =3D 0x7bfe0 max_arch_pfn =3D 0x3ffffffff
Sep 28 15:46:43 graviton x86 PAT enabled: cpu 0, old 0x7040600070406, new=20
0x7010600070106
Sep 28 15:46:43 graviton init_memory_mapping
Sep 28 15:46:43 graviton 0000000000 - 007be00000 page 2M
Sep 28 15:46:43 graviton 007be00000 - 007bfe0000 page 4k
Sep 28 15:46:43 graviton kernel direct mapping tables up to 7bfe0000 @=20
8000-c000
Sep 28 15:46:43 graviton last_map_addr: 7bfe0000 end: 7bfe0000
Sep 28 15:46:43 graviton DMI 2.5 present.
Sep 28 15:46:43 graviton ACPI: RSDP 000F8350, 0024 (r2 RS780 )
Sep 28 15:46:43 graviton ACPI: RSDT 7BFE3000, 0038 (r1 RS780  AWRDACPI=20
42302E31 AWRD        0)
Sep 28 15:46:43 graviton ACPI: FACP 7BFE3080, 0074 (r1 RS780  AWRDACPI=20
42302E31 AWRD        0)
Sep 28 15:46:43 graviton ACPI: DSDT 7BFE3100, 6BFA (r1 RS780  AWRDACPI    =
=20
1000 MSFT  3000000)
Sep 28 15:46:43 graviton ACPI: FACS 7BFE0000, 0040
Sep 28 15:46:43 graviton ACPI: SSDT 7BFE9DC0, 01C4 (r1 PTLTD  POWERNOW     =
  =20
1  LTP        1)
Sep 28 15:46:43 graviton ACPI: HPET 7BFE9FC0, 0038 (r1 RS780  AWRDACPI=20
42302E31 AWRD       98)
Sep 28 15:46:43 graviton ACPI: MCFG 7BFEA000, 003C (r1 RS780  AWRDACPI=20
42302E31 AWRD        0)
Sep 28 15:46:43 graviton ACPI: APIC 7BFE9D00, 0084 (r1 RS780  AWRDACPI=20
42302E31 AWRD        0)
Sep 28 15:46:43 graviton (5 early reservations) =3D=3D> bootmem [0000000000=
 -=20
007bfe0000]
Sep 28 15:46:43 graviton #0 [0000000000 - 0000001000]   BIOS data page =3D=
=3D>=20
[0000000000 - 0000001000]
Sep 28 15:46:43 graviton #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=
=3D>=20
[0000006000 - 0000008000]
Sep 28 15:46:43 graviton #2 [0000200000 - 00008bd6c0]    TEXT DATA BSS =3D=
=3D>=20
[0000200000 - 00008bd6c0]
Sep 28 15:46:43 graviton #3 [000009f000 - 0000100000]    BIOS reserved =3D=
=3D>=20
[000009f000 - 0000100000]
Sep 28 15:46:43 graviton #4 [0000008000 - 000000a000]          PGTABLE =3D=
=3D>=20
[0000008000 - 000000a000]
Sep 28 15:46:43 graviton found SMP MP-table at [ffff8800000f4310] 000f4310
Sep 28 15:46:43 graviton [ffffe20000000000-ffffe20001bfffff] PMD ->=20
[ffff880001200000-ffff880002dfffff] on node 0
Sep 28 15:46:43 graviton Zone PFN ranges:
Sep 28 15:46:43 graviton DMA      0x00000000 -> 0x00001000
Sep 28 15:46:43 graviton DMA32    0x00001000 -> 0x00100000
Sep 28 15:46:43 graviton Normal   0x00100000 -> 0x00100000
Sep 28 15:46:43 graviton Movable zone start PFN for each node
Sep 28 15:46:43 graviton early_node_map[2] active PFN ranges
Sep 28 15:46:43 graviton 0: 0x00000000 -> 0x0000009f
Sep 28 15:46:43 graviton 0: 0x00000100 -> 0x0007bfe0
Sep 28 15:46:43 graviton On node 0 totalpages: 507775
Sep 28 15:46:43 graviton DMA zone: 2114 pages, LIFO batch:0
Sep 28 15:46:43 graviton DMA32 zone: 496888 pages, LIFO batch:31
Sep 28 15:46:43 graviton Detected use of extended apic ids on hypertranspor=
t=20
bus
Sep 28 15:46:43 graviton ACPI: PM-Timer IO Port: 0x4008
Sep 28 15:46:43 graviton ACPI: Local APIC address 0xfee00000
Sep 28 15:46:43 graviton ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Sep 28 15:46:43 graviton ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Sep 28 15:46:43 graviton ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
Sep 28 15:46:43 graviton ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
Sep 28 15:46:43 graviton ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
Sep 28 15:46:43 graviton ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Sep 28 15:46:43 graviton ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Sep 28 15:46:43 graviton ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
Sep 28 15:46:43 graviton ACPI: IOAPIC (id[0x04] address[0xfec00000]=20
gsi_base[0])
Sep 28 15:46:43 graviton IOAPIC[0]: apic_id 4, version 0, address 0xfec0000=
0,=20
GSI 0-23
Sep 28 15:46:43 graviton ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 df=
l=20
dfl)
Sep 28 15:46:43 graviton ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 lo=
w=20
level)
Sep 28 15:46:43 graviton ACPI: IRQ0 used by override.
Sep 28 15:46:43 graviton ACPI: IRQ2 used by override.
Sep 28 15:46:43 graviton ACPI: IRQ9 used by override.
Sep 28 15:46:43 graviton Setting APIC routing to flat
Sep 28 15:46:43 graviton ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Sep 28 15:46:43 graviton Using ACPI (MADT) for SMP configuration information
Sep 28 15:46:43 graviton SMP: Allowing 2 CPUs, 0 hotplug CPUs
Sep 28 15:46:43 graviton Allocating PCI resources starting at 80000000 (gap=
:=20
7c000000:64000000)
Sep 28 15:46:43 graviton PERCPU: Allocating 49056 bytes of per cpu data
Sep 28 15:46:43 graviton NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Sep 28 15:46:43 graviton Built 1 zonelists in Zone order, mobility grouping=
=20
on.  Total pages: 499002
Sep 28 15:46:43 graviton Kernel command line: root=3D/dev/md1 init=3D/sbin/=
init=20
sata_nv.swncq=3D1 snd-hda-intel.enable_msi=3D1
Sep 28 15:46:43 graviton Initializing CPU#0
Sep 28 15:46:43 graviton PID hash table entries: 4096 (order: 12, 32768 byt=
es)
Sep 28 15:46:43 graviton TSC: PIT calibration confirmed by PMTIMER.
Sep 28 15:46:43 graviton TSC: using PIT calibration value
Sep 28 15:46:43 graviton Detected 2000.414 MHz processor.
Sep 28 15:46:43 graviton Console: colour VGA+ 80x25
Sep 28 15:46:43 graviton console [tty0] enabled
Sep 28 15:46:43 graviton Dentry cache hash table entries: 262144 (order: 9,=
=20
2097152 bytes)
Sep 28 15:46:43 graviton Inode-cache hash table entries: 131072 (order: 8,=
=20
1048576 bytes)
Sep 28 15:46:43 graviton Checking aperture...
Sep 28 15:46:43 graviton No AGP bridge found
Sep 28 15:46:43 graviton Node 0: aperture @ 9780000000 size 32 MB
Sep 28 15:46:43 graviton Aperture beyond 4GB. Ignoring.
Sep 28 15:46:43 graviton Memory: 1991520k/2031488k available (4326k kernel=
=20
code, 38960k reserved, 1709k data, 324k init)
Sep 28 15:46:43 graviton CPA: page pool initialized 1 of 1 pages preallocat=
ed
Sep 28 15:46:43 graviton SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3,=20
MinObjects=3D0, CPUs=3D2, Nodes=3D1
Sep 28 15:46:43 graviton hpet clockevent registered
Sep 28 15:46:43 graviton Calibrating delay loop (skipped), value calculated=
=20
using timer frequency.. 4000.82 BogoMIPS (lpj=3D2000414)
Sep 28 15:46:43 graviton Mount-cache hash table entries: 256
Sep 28 15:46:43 graviton CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K =
(64=20
bytes/line)
Sep 28 15:46:43 graviton CPU: L2 Cache: 512K (64 bytes/line)
Sep 28 15:46:43 graviton tseg: 0000000000
Sep 28 15:46:43 graviton CPU: Physical Processor ID: 0
Sep 28 15:46:43 graviton CPU: Processor Core ID: 0
Sep 28 15:46:43 graviton using C1E aware idle routine
Sep 28 15:46:43 graviton ACPI: Core revision 20080609
Sep 28 15:46:43 graviton ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D=
=2D1 pin2=3D-1
Sep 28 15:46:43 graviton CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 380=
0+=20
stepping 02
Sep 28 15:46:43 graviton Using local APIC timer interrupts.
Sep 28 15:46:43 graviton APIC timer calibration result 12502585
Sep 28 15:46:43 graviton Detected 12.502 MHz APIC timer.
Sep 28 15:46:43 graviton Booting processor 1/1 ip 6000
Sep 28 15:46:43 graviton Initializing CPU#1
Sep 28 15:46:43 graviton Calibrating delay using timer specific routine..=20
4000.73 BogoMIPS (lpj=3D2000367)
Sep 28 15:46:43 graviton CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K =
(64=20
bytes/line)
Sep 28 15:46:43 graviton CPU: L2 Cache: 512K (64 bytes/line)
Sep 28 15:46:43 graviton CPU: Physical Processor ID: 0
Sep 28 15:46:43 graviton CPU: Processor Core ID: 1
Sep 28 15:46:43 graviton x86 PAT enabled: cpu 1, old 0x7040600070406, new=20
0x7010600070106
Sep 28 15:46:43 graviton System has C1E enabled
Sep 28 15:46:43 graviton CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 380=
0+=20
stepping 02
Sep 28 15:46:43 graviton Brought up 2 CPUs
Sep 28 15:46:43 graviton Total of 2 processors activated (8001.56 BogoMIPS).
Sep 28 15:46:43 graviton net_namespace: 1152 bytes
Sep 28 15:46:43 graviton xor: automatically using best checksumming functio=
n:=20
generic_sse
Sep 28 15:46:43 graviton Switch to broadcast mode on CPU1
Sep 28 15:46:43 graviton generic_sse:  6120.000 MB/sec
Sep 28 15:46:43 graviton xor: using function: generic_sse (6120.000 MB/sec)
Sep 28 15:46:43 graviton Switch to broadcast mode on CPU0
Sep 28 15:46:43 graviton NET: Registered protocol family 16
Sep 28 15:46:43 graviton No dock devices found.
Sep 28 15:46:43 graviton node 0 link 0: io port [c000, ffff]
Sep 28 15:46:43 graviton TOM: 0000000080000000 aka 2048M
Sep 28 15:46:43 graviton node 0 link 0: mmio [a0000, bffff]
Sep 28 15:46:43 graviton node 0 link 0: mmio [80000000, fd9fffff]
Sep 28 15:46:43 graviton node 0 link 0: mmio [fdc00000, ffffffff]
Sep 28 15:46:43 graviton bus: [00,03] on node 0 link 0
Sep 28 15:46:43 graviton bus: 00 index 0 io port: [0, ffff]
Sep 28 15:46:43 graviton bus: 00 index 1 mmio: [a0000, bffff]
Sep 28 15:46:43 graviton bus: 00 index 2 mmio: [80000000, fdbfffff]
Sep 28 15:46:43 graviton bus: 00 index 3 mmio: [fdc00000, fcffffffff]
Sep 28 15:46:43 graviton ACPI: bus type pci registered
Sep 28 15:46:43 graviton PCI: MCFG configuration 0: base e0000000 segment 0=
=20
buses 0 - 255
Sep 28 15:46:43 graviton PCI: MCFG area at e0000000 reserved in E820
Sep 28 15:46:43 graviton PCI: Using MMCONFIG at e0000000 - efffffff
Sep 28 15:46:43 graviton PCI: Using configuration type 1 for base access
Sep 28 15:46:43 graviton ACPI: EC: Look up EC in DSDT
Sep 28 15:46:43 graviton ACPI: Interpreter enabled
Sep 28 15:46:43 graviton ACPI: (supports S0 S3 S5)
Sep 28 15:46:43 graviton ACPI: Using IOAPIC for interrupt routing
Sep 28 15:46:43 graviton ACPI: PCI Root Bridge [PCI0] (0000:00)
Sep 28 15:46:43 graviton PCI: 0000:00:00.0 reg 1c 64bit mmio: [e0000000,=20
ffffffff]
Sep 28 15:46:43 graviton pci 0000:00:0a.0: PME# supported from D0 D3hot D3c=
old
Sep 28 15:46:43 graviton pci 0000:00:0a.0: PME# disabled
Sep 28 15:46:43 graviton PCI: 0000:00:11.0 reg 10 io port: [ff00, ff07]
Sep 28 15:46:43 graviton PCI: 0000:00:11.0 reg 14 io port: [fe00, fe03]
Sep 28 15:46:43 graviton PCI: 0000:00:11.0 reg 18 io port: [fd00, fd07]
Sep 28 15:46:43 graviton PCI: 0000:00:11.0 reg 1c io port: [fc00, fc03]
Sep 28 15:46:43 graviton PCI: 0000:00:11.0 reg 20 io port: [fb00, fb0f]
Sep 28 15:46:43 graviton PCI: 0000:00:11.0 reg 24 32bit mmio: [fe02f000,=20
fe02f3ff]
Sep 28 15:46:43 graviton pci 0000:00:11.0: set SATA to AHCI mode
Sep 28 15:46:43 graviton PCI: 0000:00:12.0 reg 10 32bit mmio: [fe02e000,=20
fe02efff]
Sep 28 15:46:43 graviton PCI: 0000:00:12.1 reg 10 32bit mmio: [fe02d000,=20
fe02dfff]
Sep 28 15:46:43 graviton PCI: 0000:00:12.2 reg 10 32bit mmio: [fe02c000,=20
fe02c0ff]
Sep 28 15:46:43 graviton pci 0000:00:12.2: supports D1
Sep 28 15:46:43 graviton pci 0000:00:12.2: supports D2
Sep 28 15:46:43 graviton pci 0000:00:12.2: PME# supported from D0 D1 D2 D3h=
ot
Sep 28 15:46:43 graviton pci 0000:00:12.2: PME# disabled
Sep 28 15:46:43 graviton PCI: 0000:00:13.0 reg 10 32bit mmio: [fe02b000,=20
fe02bfff]
Sep 28 15:46:43 graviton PCI: 0000:00:13.1 reg 10 32bit mmio: [fe02a000,=20
fe02afff]
Sep 28 15:46:43 graviton PCI: 0000:00:13.2 reg 10 32bit mmio: [fe029000,=20
fe0290ff]
Sep 28 15:46:43 graviton pci 0000:00:13.2: supports D1
Sep 28 15:46:43 graviton pci 0000:00:13.2: supports D2
Sep 28 15:46:43 graviton pci 0000:00:13.2: PME# supported from D0 D1 D2 D3h=
ot
Sep 28 15:46:43 graviton pci 0000:00:13.2: PME# disabled
Sep 28 15:46:43 graviton PCI: 0000:00:14.1 reg 10 io port: [0, 7]
Sep 28 15:46:43 graviton PCI: 0000:00:14.1 reg 14 io port: [0, 3]
Sep 28 15:46:43 graviton PCI: 0000:00:14.1 reg 18 io port: [0, 7]
Sep 28 15:46:43 graviton PCI: 0000:00:14.1 reg 1c io port: [0, 3]
Sep 28 15:46:43 graviton PCI: 0000:00:14.1 reg 20 io port: [fa00, fa0f]
Sep 28 15:46:43 graviton PCI: 0000:00:14.2 reg 10 64bit mmio: [fe024000,=20
fe027fff]
Sep 28 15:46:43 graviton pci 0000:00:14.2: PME# supported from D0 D3hot D3c=
old
Sep 28 15:46:43 graviton pci 0000:00:14.2: PME# disabled
Sep 28 15:46:43 graviton PCI: 0000:01:05.0 reg 10 32bit mmio: [f8000000,=20
fbffffff]
Sep 28 15:46:43 graviton PCI: 0000:01:05.0 reg 14 io port: [ee00, eeff]
Sep 28 15:46:43 graviton PCI: 0000:01:05.0 reg 18 32bit mmio: [fdef0000,=20
fdefffff]
Sep 28 15:46:43 graviton PCI: 0000:01:05.0 reg 24 32bit mmio: [fdd00000,=20
fddfffff]
Sep 28 15:46:43 graviton pci 0000:01:05.0: supports D1
Sep 28 15:46:43 graviton pci 0000:01:05.0: supports D2
Sep 28 15:46:43 graviton PCI: bridge 0000:00:01.0 io port: [e000, efff]
Sep 28 15:46:43 graviton PCI: bridge 0000:00:01.0 32bit mmio: [fdd00000,=20
fdefffff]
Sep 28 15:46:43 graviton PCI: bridge 0000:00:01.0 64bit mmio pref: [f800000=
0,=20
fbffffff]
Sep 28 15:46:43 graviton PCI: 0000:02:00.0 reg 10 64bit mmio: [fdcfc000,=20
fdcfffff]
Sep 28 15:46:43 graviton PCI: 0000:02:00.0 reg 18 io port: [de00, deff]
Sep 28 15:46:43 graviton PCI: 0000:02:00.0 reg 30 32bit mmio: [0, 1ffff]
Sep 28 15:46:43 graviton pci 0000:02:00.0: supports D1
Sep 28 15:46:43 graviton pci 0000:02:00.0: supports D2
Sep 28 15:46:43 graviton pci 0000:02:00.0: PME# supported from D0 D1 D2 D3h=
ot=20
D3cold
Sep 28 15:46:43 graviton pci 0000:02:00.0: PME# disabled
Sep 28 15:46:43 graviton PCI: bridge 0000:00:0a.0 io port: [d000, dfff]
Sep 28 15:46:43 graviton PCI: bridge 0000:00:0a.0 32bit mmio: [fdc00000,=20
fdcfffff]
Sep 28 15:46:43 graviton PCI: bridge 0000:00:0a.0 64bit mmio pref: [fdf0000=
0,=20
fdffffff]
Sep 28 15:46:43 graviton pci 0000:00:14.4: transparent bridge
Sep 28 15:46:43 graviton PCI: bridge 0000:00:14.4 io port: [c000, cfff]
Sep 28 15:46:43 graviton PCI: bridge 0000:00:14.4 32bit mmio: [fdb00000,=20
fdbfffff]
Sep 28 15:46:43 graviton PCI: bridge 0000:00:14.4 32bit mmio pref: [fda0000=
0,=20
fdafffff]
Sep 28 15:46:43 graviton bus 00 -> node 0
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Routing Table=20
[\_SB_.PCI0.P2P_._PRT]
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Routing Table=20
[\_SB_.PCI0.PCEA._PRT]
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Routing Table=20
[\_SB_.PCI0.AGP_._PRT]
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10=
=20
11) *0, disabled.
Sep 28 15:46:43 graviton Linux Plug and Play Support v0.97 (c) Adam Belay
Sep 28 15:46:43 graviton pnp: PnP ACPI init
Sep 28 15:46:43 graviton ACPI: bus type pnp registered
Sep 28 15:46:43 graviton pnp 00:09: mem resource (0xfed00000-0xfed000ff)=20
overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
Sep 28 15:46:43 graviton pnp 00:09: mem resource (0xffff0000-0xffffffff)=20
overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
Sep 28 15:46:43 graviton pnp 00:09: mem resource (0xfec00000-0xfec00fff)=20
overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
Sep 28 15:46:43 graviton pnp 00:09: mem resource (0xfee00000-0xfee00fff)=20
overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
Sep 28 15:46:43 graviton pnp 00:09: mem resource (0xfff80000-0xfffeffff)=20
overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
Sep 28 15:46:43 graviton pnp: PnP ACPI: found 10 devices
Sep 28 15:46:43 graviton ACPI: ACPI bus type pnp unregistered
Sep 28 15:46:43 graviton SCSI subsystem initialized
Sep 28 15:46:43 graviton libata version 3.00 loaded.
Sep 28 15:46:43 graviton usbcore: registered new interface driver usbfs
Sep 28 15:46:43 graviton usbcore: registered new interface driver hub
Sep 28 15:46:43 graviton usbcore: registered new device driver usb
Sep 28 15:46:43 graviton PCI: Using ACPI for IRQ routing
Sep 28 15:46:43 graviton pci 0000:00:00.0: BAR 3: can't allocate resource
Sep 28 15:46:43 graviton DMAR:parse DMAR table failure.
Sep 28 15:46:43 graviton hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Sep 28 15:46:43 graviton hpet0: 4 32-bit timers, 14318180 Hz
Sep 28 15:46:43 graviton Switched to high resolution mode on CPU 0
Sep 28 15:46:43 graviton Switched to high resolution mode on CPU 1
Sep 28 15:46:43 graviton system 00:01: ioport range 0x4100-0x411f has been=
=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0x228-0x22f has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0x40b-0x40b has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0x4d6-0x4d6 has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xc00-0xc01 has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xc14-0xc14 has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xc50-0xc52 has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xc6c-0xc6d has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xc6f-0xc6f has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xcd0-0xcd1 has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xcd2-0xcd3 has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xcd4-0xcdf has been=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0x4000-0x40fe has been=
=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0x4210-0x4217 has been=
=20
reserved
Sep 28 15:46:43 graviton system 00:01: ioport range 0xb10-0xb1f has been=20
reserved
Sep 28 15:46:43 graviton system 00:07: ioport range 0x4d0-0x4d1 has been=20
reserved
Sep 28 15:46:43 graviton system 00:09: iomem range 0xf0000-0xfffff could no=
t=20
be reserved
Sep 28 15:46:43 graviton system 00:09: iomem range 0x7bfe0000-0x7bffffff co=
uld=20
not be reserved
Sep 28 15:46:43 graviton system 00:09: iomem range 0x0-0x9ffff could not be=
=20
reserved
Sep 28 15:46:43 graviton system 00:09: iomem range 0x100000-0x7bfdffff coul=
d=20
not be reserved
Sep 28 15:46:43 graviton system 00:09: iomem range 0x7c000000-0x7fffffff ha=
s=20
been reserved
Sep 28 15:46:43 graviton pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Sep 28 15:46:43 graviton pci 0000:00:01.0:   IO window: 0xe000-0xefff
Sep 28 15:46:43 graviton pci 0000:00:01.0:   MEM window: 0xfdd00000-0xfdeff=
fff
Sep 28 15:46:43 graviton pci 0000:00:01.0:   PREFETCH window:=20
0x000000f8000000-0x000000fbffffff
Sep 28 15:46:43 graviton pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
Sep 28 15:46:43 graviton pci 0000:00:0a.0:   IO window: 0xd000-0xdfff
Sep 28 15:46:43 graviton pci 0000:00:0a.0:   MEM window: 0xfdc00000-0xfdcff=
fff
Sep 28 15:46:43 graviton pci 0000:00:0a.0:   PREFETCH window:=20
0x000000fdf00000-0x000000fdffffff
Sep 28 15:46:43 graviton pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
Sep 28 15:46:43 graviton pci 0000:00:14.4:   IO window: 0xc000-0xcfff
Sep 28 15:46:43 graviton pci 0000:00:14.4:   MEM window: 0xfdb00000-0xfdbff=
fff
Sep 28 15:46:43 graviton pci 0000:00:14.4:   PREFETCH window:=20
0x000000fda00000-0x000000fdafffff
Sep 28 15:46:43 graviton pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low)=
 ->=20
IRQ 18
Sep 28 15:46:43 graviton pci 0000:00:0a.0: setting latency timer to 64
Sep 28 15:46:43 graviton bus: 00 index 0 io port: [0, ffff]
Sep 28 15:46:43 graviton bus: 00 index 1 mmio: [0, ffffffffffffffff]
Sep 28 15:46:43 graviton bus: 01 index 0 io port: [e000, efff]
Sep 28 15:46:43 graviton bus: 01 index 1 mmio: [fdd00000, fdefffff]
Sep 28 15:46:43 graviton bus: 01 index 2 mmio: [f8000000, fbffffff]
Sep 28 15:46:43 graviton bus: 01 index 3 mmio: [0, 0]
Sep 28 15:46:43 graviton bus: 02 index 0 io port: [d000, dfff]
Sep 28 15:46:43 graviton bus: 02 index 1 mmio: [fdc00000, fdcfffff]
Sep 28 15:46:43 graviton bus: 02 index 2 mmio: [fdf00000, fdffffff]
Sep 28 15:46:43 graviton bus: 02 index 3 mmio: [0, 0]
Sep 28 15:46:43 graviton bus: 03 index 0 io port: [c000, cfff]
Sep 28 15:46:43 graviton bus: 03 index 1 mmio: [fdb00000, fdbfffff]
Sep 28 15:46:43 graviton bus: 03 index 2 mmio: [fda00000, fdafffff]
Sep 28 15:46:43 graviton bus: 03 index 3 io port: [0, ffff]
Sep 28 15:46:43 graviton bus: 03 index 4 mmio: [0, ffffffffffffffff]
Sep 28 15:46:43 graviton NET: Registered protocol family 2
Sep 28 15:46:43 graviton IP route cache hash table entries: 65536 (order: 7=
,=20
524288 bytes)
Sep 28 15:46:43 graviton TCP established hash table entries: 262144 (order:=
=20
10, 4194304 bytes)
Sep 28 15:46:43 graviton TCP bind hash table entries: 65536 (order: 8, 1048=
576=20
bytes)
Sep 28 15:46:43 graviton TCP: Hash tables configured (established 262144 bi=
nd=20
65536)
Sep 28 15:46:43 graviton TCP reno registered
Sep 28 15:46:43 graviton NET: Registered protocol family 1
Sep 28 15:46:43 graviton HugeTLB registered 2 MB page size, pre-allocated 0=
=20
pages
Sep 28 15:46:43 graviton Installing knfsd (copyright (C) 1996=20
okir@monad.swb.de).
Sep 28 15:46:43 graviton msgmni has been set to 3890
Sep 28 15:46:43 graviton async_tx: api initialized (sync-only)
Sep 28 15:46:43 graviton Block layer SCSI generic (bsg) driver version 0.4=
=20
loaded (major 254)
Sep 28 15:46:43 graviton io scheduler noop registered
Sep 28 15:46:43 graviton io scheduler anticipatory registered
Sep 28 15:46:43 graviton io scheduler deadline registered (default)
Sep 28 15:46:43 graviton io scheduler cfq registered
Sep 28 15:46:43 graviton pci 0000:01:05.0: Boot video device
Sep 28 15:46:43 graviton pcieport-driver 0000:00:0a.0: setting latency time=
r=20
to 64
Sep 28 15:46:43 graviton pcieport-driver 0000:00:0a.0: found MSI capability
Sep 28 15:46:43 graviton pci_express 0000:00:0a.0:pcie00: allocate port=20
service
Sep 28 15:46:43 graviton input: Power Button (FF) as /class/input/input0
Sep 28 15:46:43 graviton ACPI: Power Button (FF) [PWRF]
Sep 28 15:46:43 graviton input: Power Button (CM) as /class/input/input1
Sep 28 15:46:43 graviton ACPI: Power Button (CM) [PWRB]
Sep 28 15:46:43 graviton fan PNP0C0B:00: registered as cooling_device0
Sep 28 15:46:43 graviton ACPI: Fan [FAN] (on)
Sep 28 15:46:43 graviton processor ACPI0007:00: registered as cooling_devic=
e1
Sep 28 15:46:43 graviton processor ACPI0007:01: registered as cooling_devic=
e2
Sep 28 15:46:43 graviton ACPI: Expecting a [Reference] package element, fou=
nd=20
type 0
Sep 28 15:46:43 graviton thermal LNXTHERM:01: registered as thermal_zone0
Sep 28 15:46:43 graviton ACPI: Thermal Zone [THRM] (23 C)
Sep 28 15:46:43 graviton lp: driver loaded but no devices found
Sep 28 15:46:43 graviton Real Time Clock Driver v1.12ac
Sep 28 15:46:43 graviton hpet_resources: 0xfed00000 is busy
Sep 28 15:46:43 graviton Non-volatile memory driver v1.2
Sep 28 15:46:43 graviton Linux agpgart interface v0.103
Sep 28 15:46:43 graviton Serial: 8250/16550 driver4 ports, IRQ sharing=20
disabled
Sep 28 15:46:43 graviton loop: module loaded
Sep 28 15:46:43 graviton sky2 0000:02:00.0: PCI INT A -> GSI 18 (level,=20
low) -> IRQ 18
Sep 28 15:46:43 graviton sky2 0000:02:00.0: setting latency timer to 64
Sep 28 15:46:43 graviton sky2 0000:02:00.0: v1.22 addr 0xfdcfc000 irq 18=20
Yukon-2 EC Ultra rev 3
Sep 28 15:46:43 graviton sky2 eth0: addr 00:18:37:04:39:c2
Sep 28 15:46:43 graviton tun: Universal TUN/TAP device driver, 1.6
Sep 28 15:46:43 graviton tun: (C) 1999-2004 Max Krasnyansky=20
<maxk@qualcomm.com>
Sep 28 15:46:43 graviton Driver 'sd' needs updating - please use bus_type=20
methods
Sep 28 15:46:43 graviton Driver 'sr' needs updating - please use bus_type=20
methods
Sep 28 15:46:43 graviton ahci 0000:00:11.0: version 3.0
Sep 28 15:46:43 graviton ahci 0000:00:11.0: PCI INT A -> GSI 22 (level,=20
low) -> IRQ 22
Sep 28 15:46:43 graviton ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports=
 3=20
Gbps 0xf impl SATA mode
Sep 28 15:46:43 graviton ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm l=
ed=20
clo pmp pio=20
Sep 28 15:46:43 graviton scsi0 : ahci
Sep 28 15:46:43 graviton scsi1 : ahci
Sep 28 15:46:43 graviton scsi2 : ahci
Sep 28 15:46:43 graviton scsi3 : ahci
Sep 28 15:46:43 graviton ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port=
=20
0xfe02f100 irq 317
Sep 28 15:46:43 graviton ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port=
=20
0xfe02f180 irq 317
Sep 28 15:46:43 graviton ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port=
=20
0xfe02f200 irq 317
Sep 28 15:46:43 graviton ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port=
=20
0xfe02f280 irq 317
Sep 28 15:46:43 graviton ata1: softreset failed (device not ready)
Sep 28 15:46:43 graviton ata1: failed due to HW bug, retry pmp=3D0
Sep 28 15:46:43 graviton ata1: SATA link up 3.0 Gbps (SStatus 123 SControl=
=20
300)
Sep 28 15:46:43 graviton ata1.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
Sep 28 15:46:43 graviton ata1.00: 625142448 sectors, multi 1: LBA48 NCQ (de=
pth=20
31/32)
Sep 28 15:46:43 graviton ata1.00: configured for UDMA/133
Sep 28 15:46:43 graviton ata2: softreset failed (device not ready)
Sep 28 15:46:43 graviton ata2: failed due to HW bug, retry pmp=3D0
Sep 28 15:46:43 graviton ata2: SATA link up 3.0 Gbps (SStatus 123 SControl=
=20
300)
Sep 28 15:46:43 graviton ata2.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
Sep 28 15:46:43 graviton ata2.00: 625142448 sectors, multi 1: LBA48 NCQ (de=
pth=20
31/32)
Sep 28 15:46:43 graviton ata2.00: configured for UDMA/133
Sep 28 15:46:43 graviton ata3: softreset failed (device not ready)
Sep 28 15:46:43 graviton ata3: failed due to HW bug, retry pmp=3D0
Sep 28 15:46:43 graviton ata3: SATA link up 3.0 Gbps (SStatus 123 SControl=
=20
300)
Sep 28 15:46:43 graviton ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
Sep 28 15:46:43 graviton ata3.00: 625142448 sectors, multi 1: LBA48 NCQ (de=
pth=20
31/32)
Sep 28 15:46:43 graviton ata3.00: configured for UDMA/133
Sep 28 15:46:43 graviton ata4: SATA link down (SStatus 0 SControl 300)
Sep 28 15:46:43 graviton scsi 0:0:0:0: Direct-Access     ATA      ST3320620=
AS     =20
3.AA PQ: 0 ANSI: 5
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] 625142448 512-byte hardware sect=
ors=20
(320073 MB)
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Write Protect is off
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] 625142448 512-byte hardware sect=
ors=20
(320073 MB)
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Write Protect is off
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Sep 28 15:46:43 graviton sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
Sep 28 15:46:43 graviton sd 0:0:0:0: [sda] Attached SCSI disk
Sep 28 15:46:43 graviton sd 0:0:0:0: Attached scsi generic sg0 type 0
Sep 28 15:46:43 graviton scsi 1:0:0:0: Direct-Access     ATA      ST3320620=
AS     =20
3.AA PQ: 0 ANSI: 5
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] 625142448 512-byte hardware sect=
ors=20
(320073 MB)
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Write Protect is off
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] 625142448 512-byte hardware sect=
ors=20
(320073 MB)
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Write Protect is off
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Sep 28 15:46:43 graviton sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 sdb8 sdb9 >
Sep 28 15:46:43 graviton sd 1:0:0:0: [sdb] Attached SCSI disk
Sep 28 15:46:43 graviton sd 1:0:0:0: Attached scsi generic sg1 type 0
Sep 28 15:46:43 graviton scsi 2:0:0:0: Direct-Access     ATA      ST3320620=
AS     =20
3.AA PQ: 0 ANSI: 5
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] 625142448 512-byte hardware sect=
ors=20
(320073 MB)
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Write Protect is off
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] 625142448 512-byte hardware sect=
ors=20
(320073 MB)
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Write Protect is off
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Write cache: enabled, read cache=
:=20
enabled, doesn't support DPO or FUA
Sep 28 15:46:43 graviton sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 sdc9 >
Sep 28 15:46:43 graviton sd 2:0:0:0: [sdc] Attached SCSI disk
Sep 28 15:46:43 graviton sd 2:0:0:0: Attached scsi generic sg2 type 0
Sep 28 15:46:43 graviton pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (lev=
el,=20
low) -> IRQ 16
Sep 28 15:46:43 graviton scsi4 : pata_atiixp
Sep 28 15:46:43 graviton scsi5 : pata_atiixp
Sep 28 15:46:43 graviton ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma=
=20
0xfa00 irq 14
Sep 28 15:46:43 graviton ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma=
=20
0xfa08 irq 15
Sep 28 15:46:43 graviton ata5.01: NODEV after polling detection
Sep 28 15:46:43 graviton ata5.00: ATAPI: NU      DVDRW DDW-081, BX32, max=20
UDMA/33
Sep 28 15:46:43 graviton ata5.00: configured for UDMA/33
Sep 28 15:46:43 graviton isa bounce pool size: 16 pages
Sep 28 15:46:43 graviton scsi 4:0:0:0: CD-ROM            NU       DVDRW=20
DDW-081    BX32 PQ: 0 ANSI: 5
Sep 28 15:46:43 graviton sr0: scsi3-mmc drive: 12x/40x writer cd/rw xa/form=
2=20
cdda tray
Sep 28 15:46:43 graviton Uniform CD-ROM driver Revision: 3.20
Sep 28 15:46:43 graviton sr 4:0:0:0: Attached scsi CD-ROM sr0
Sep 28 15:46:43 graviton sr 4:0:0:0: Attached scsi generic sg3 type 5
Sep 28 15:46:43 graviton ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level,=
=20
low) -> IRQ 17
Sep 28 15:46:43 graviton ehci_hcd 0000:00:12.2: EHCI Host Controller
Sep 28 15:46:43 graviton ehci_hcd 0000:00:12.2: new USB bus registered,=20
assigned bus number 1
Sep 28 15:46:43 graviton ehci_hcd 0000:00:12.2: debug port 1
Sep 28 15:46:43 graviton ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
Sep 28 15:46:43 graviton ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00,=
=20
driver 10 Dec 2004
Sep 28 15:46:43 graviton usb usb1: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 1-0:1.0: USB hub found
Sep 28 15:46:43 graviton hub 1-0:1.0: 6 ports detected
Sep 28 15:46:43 graviton usb usb1: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0002
Sep 28 15:46:43 graviton usb usb1: New USB device strings: Mfr=3D3, Product=
=3D2,=20
SerialNumber=3D1
Sep 28 15:46:43 graviton usb usb1: Product: EHCI Host Controller
Sep 28 15:46:43 graviton usb usb1: Manufacturer: Linux 2.6.27-rc7 ehci_hcd
Sep 28 15:46:43 graviton usb usb1: SerialNumber: 0000:00:12.2
Sep 28 15:46:43 graviton ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level,=
=20
low) -> IRQ 19
Sep 28 15:46:43 graviton ehci_hcd 0000:00:13.2: EHCI Host Controller
Sep 28 15:46:43 graviton ehci_hcd 0000:00:13.2: new USB bus registered,=20
assigned bus number 2
Sep 28 15:46:43 graviton ehci_hcd 0000:00:13.2: debug port 1
Sep 28 15:46:43 graviton ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
Sep 28 15:46:43 graviton ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00,=
=20
driver 10 Dec 2004
Sep 28 15:46:43 graviton usb usb2: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 2-0:1.0: USB hub found
Sep 28 15:46:43 graviton hub 2-0:1.0: 6 ports detected
Sep 28 15:46:43 graviton usb usb2: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0002
Sep 28 15:46:43 graviton usb usb2: New USB device strings: Mfr=3D3, Product=
=3D2,=20
SerialNumber=3D1
Sep 28 15:46:43 graviton usb usb2: Product: EHCI Host Controller
Sep 28 15:46:43 graviton usb usb2: Manufacturer: Linux 2.6.27-rc7 ehci_hcd
Sep 28 15:46:43 graviton usb usb2: SerialNumber: 0000:00:13.2
Sep 28 15:46:43 graviton ohci_hcd: 2006 August 04 USB 1.1 'Open' Host=20
Controller (OHCI) Driver
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level,=
=20
low) -> IRQ 16
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.0: OHCI Host Controller
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.0: new USB bus registered,=20
assigned bus number 3
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
Sep 28 15:46:43 graviton usb usb3: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 3-0:1.0: USB hub found
Sep 28 15:46:43 graviton hub 3-0:1.0: 3 ports detected
Sep 28 15:46:43 graviton usb 2-1: new high speed USB device using ehci_hcd =
and=20
address 2
Sep 28 15:46:43 graviton usb usb3: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0001
Sep 28 15:46:43 graviton usb usb3: New USB device strings: Mfr=3D3, Product=
=3D2,=20
SerialNumber=3D1
Sep 28 15:46:43 graviton usb usb3: Product: OHCI Host Controller
Sep 28 15:46:43 graviton usb usb3: Manufacturer: Linux 2.6.27-rc7 ohci_hcd
Sep 28 15:46:43 graviton usb usb3: SerialNumber: 0000:00:12.0
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level,=
=20
low) -> IRQ 16
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.1: OHCI Host Controller
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.1: new USB bus registered,=20
assigned bus number 4
Sep 28 15:46:43 graviton ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
Sep 28 15:46:43 graviton usb usb4: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 4-0:1.0: USB hub found
Sep 28 15:46:43 graviton hub 4-0:1.0: 3 ports detected
Sep 28 15:46:43 graviton usb 2-1: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 2-1:1.0: USB hub found
Sep 28 15:46:43 graviton hub 2-1:1.0: 3 ports detected
Sep 28 15:46:43 graviton usb usb4: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0001
Sep 28 15:46:43 graviton usb usb4: New USB device strings: Mfr=3D3, Product=
=3D2,=20
SerialNumber=3D1
Sep 28 15:46:43 graviton usb usb4: Product: OHCI Host Controller
Sep 28 15:46:43 graviton usb usb4: Manufacturer: Linux 2.6.27-rc7 ohci_hcd
Sep 28 15:46:43 graviton usb usb4: SerialNumber: 0000:00:12.1
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level,=
=20
low) -> IRQ 18
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.0: OHCI Host Controller
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.0: new USB bus registered,=20
assigned bus number 5
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
Sep 28 15:46:43 graviton usb usb5: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 5-0:1.0: USB hub found
Sep 28 15:46:43 graviton hub 5-0:1.0: 3 ports detected
Sep 28 15:46:43 graviton usb 2-1: New USB device found, idVendor=3D056d,=20
idProduct=3D0000
Sep 28 15:46:43 graviton usb 2-1: New USB device strings: Mfr=3D1, Product=
=3D2,=20
SerialNumber=3D0
Sep 28 15:46:43 graviton usb 2-1: Product: USB HUB
Sep 28 15:46:43 graviton usb 2-1: Manufacturer: EIZO
Sep 28 15:46:43 graviton usb usb5: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0001
Sep 28 15:46:43 graviton usb usb5: New USB device strings: Mfr=3D3, Product=
=3D2,=20
SerialNumber=3D1
Sep 28 15:46:43 graviton usb usb5: Product: OHCI Host Controller
Sep 28 15:46:43 graviton usb usb5: Manufacturer: Linux 2.6.27-rc7 ohci_hcd
Sep 28 15:46:43 graviton usb usb5: SerialNumber: 0000:00:13.0
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level,=
=20
low) -> IRQ 18
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.1: OHCI Host Controller
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.1: new USB bus registered,=20
assigned bus number 6
Sep 28 15:46:43 graviton ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
Sep 28 15:46:43 graviton usb usb6: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton hub 6-0:1.0: USB hub found
Sep 28 15:46:43 graviton hub 6-0:1.0: 3 ports detected
Sep 28 15:46:43 graviton usb 2-1.2: new full speed USB device using ehci_hc=
d=20
and address 5
Sep 28 15:46:43 graviton usb 2-1.2: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton usb 2-1.2: New USB device found, idVendor=3D1a86,=
=20
idProduct=3D7584
Sep 28 15:46:43 graviton usb 2-1.2: New USB device strings: Mfr=3D0, Produc=
t=3D2,=20
SerialNumber=3D0
Sep 28 15:46:43 graviton usb 2-1.2: Product: USB2.0-Print=20
Sep 28 15:46:43 graviton usb 2-1.3: new full speed USB device using ehci_hc=
d=20
and address 6
Sep 28 15:46:43 graviton usb usb6: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0001
Sep 28 15:46:43 graviton usb usb6: New USB device strings: Mfr=3D3, Product=
=3D2,=20
SerialNumber=3D1
Sep 28 15:46:43 graviton usb usb6: Product: OHCI Host Controller
Sep 28 15:46:43 graviton usb usb6: Manufacturer: Linux 2.6.27-rc7 ohci_hcd
Sep 28 15:46:43 graviton usb usb6: SerialNumber: 0000:00:13.1
Sep 28 15:46:43 graviton usb 2-1.3: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton usb 2-1.3: New USB device found, idVendor=3D056d,=
=20
idProduct=3D0002
Sep 28 15:46:43 graviton usb 2-1.3: New USB device strings: Mfr=3D4, Produc=
t=3D14,=20
SerialNumber=3D0
Sep 28 15:46:43 graviton usb 2-1.3: Product: EIZO USB HID Monitor
Sep 28 15:46:43 graviton usb 2-1.3: Manufacturer: EIZO
Sep 28 15:46:43 graviton usblp0: USB Bidirectional printer dev 5 if 0 alt 0=
=20
proto 2 vid 0x1A86 pid 0x7584
Sep 28 15:46:43 graviton usbcore: registered new interface driver usblp
Sep 28 15:46:43 graviton Initializing USB Mass Storage driver...
Sep 28 15:46:43 graviton usb 5-2: new low speed USB device using ohci_hcd a=
nd=20
address 2
Sep 28 15:46:43 graviton usb 5-2: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton usb 5-2: New USB device found, idVendor=3D04d9,=20
idProduct=3D0499
Sep 28 15:46:43 graviton usb 5-2: New USB device strings: Mfr=3D0, Product=
=3D0,=20
SerialNumber=3D0
Sep 28 15:46:43 graviton usbcore: registered new interface driver usb-stora=
ge
Sep 28 15:46:43 graviton USB Mass Storage support registered.
Sep 28 15:46:43 graviton usb 6-3: new full speed USB device using ohci_hcd =
and=20
address 2
Sep 28 15:46:43 graviton usb 6-3: configuration #1 chosen from 1 choice
Sep 28 15:46:43 graviton usblp1: USB Bidirectional printer dev 2 if 0 alt 1=
=20
proto 2 vid 0x03F0 pid 0x1004
Sep 28 15:46:43 graviton usb 6-3: New USB device found, idVendor=3D03f0,=20
idProduct=3D1004
Sep 28 15:46:43 graviton usb 6-3: New USB device strings: Mfr=3D1, Product=
=3D2,=20
SerialNumber=3D3
Sep 28 15:46:43 graviton usb 6-3: Product: DeskJet 970C
Sep 28 15:46:43 graviton usb 6-3: Manufacturer: Hewlett-Packard
Sep 28 15:46:43 graviton usb 6-3: SerialNumber: ES97N1305KJQ
Sep 28 15:46:43 graviton usbcore: registered new interface driver libusual
Sep 28 15:46:43 graviton PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 i=
rq=20
1
Sep 28 15:46:43 graviton PNP: PS/2 appears to have AUX port disabled, if th=
is=20
is incorrect please boot with i8042.nopnp
Sep 28 15:46:43 graviton serio: i8042 KBD port at 0x60,0x64 irq 1
Sep 28 15:46:43 graviton mice: PS/2 mouse device common for all mice
Sep 28 15:46:43 graviton input: AT Translated Set 2 keyboard=20
as /class/input/input2
Sep 28 15:46:43 graviton i2c /dev entries driver
Sep 28 15:46:43 graviton md: raid0 personality registered for level 0
Sep 28 15:46:43 graviton md: raid1 personality registered for level 1
Sep 28 15:46:43 graviton raid6: int64x1   1906 MB/s
Sep 28 15:46:43 graviton raid6: int64x2   2507 MB/s
Sep 28 15:46:43 graviton raid6: int64x4   2207 MB/s
Sep 28 15:46:43 graviton raid6: int64x8   1699 MB/s
Sep 28 15:46:43 graviton raid6: sse2x1    2769 MB/s
Sep 28 15:46:43 graviton raid6: sse2x2    3554 MB/s
Sep 28 15:46:43 graviton raid6: sse2x4    3726 MB/s
Sep 28 15:46:43 graviton raid6: using algorithm sse2x4 (3726 MB/s)
Sep 28 15:46:43 graviton md: raid6 personality registered for level 6
Sep 28 15:46:43 graviton md: raid5 personality registered for level 5
Sep 28 15:46:43 graviton md: raid4 personality registered for level 4
Sep 28 15:46:43 graviton md: multipath personality registered for level -4
Sep 28 15:46:43 graviton device-mapper: uevent: version 1.0.3
Sep 28 15:46:43 graviton device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)=20
initialised: dm-devel@redhat.com
Sep 28 15:46:43 graviton cpuidle: using governor ladder
Sep 28 15:46:43 graviton cpuidle: using governor menu
Sep 28 15:46:43 graviton drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl=
)=20
failed
Sep 28 15:46:43 graviton usbhid: timeout initializing reports
Sep 28 15:46:43 graviton HID device claimed by neither input, hiddev nor=20
hidraw
Sep 28 15:46:43 graviton input: HID 04d9:0499 as /class/input/input3
Sep 28 15:46:43 graviton input: USB HID v1.10 Mouse [HID 04d9:0499] on=20
usb-0000:00:13.0-2
Sep 28 15:46:43 graviton usbcore: registered new interface driver usbhid
Sep 28 15:46:43 graviton usbhid: v2.6:USB HID core driver
Sep 28 15:46:43 graviton Advanced Linux Sound Architecture Driver Version=20
1.0.17.
Sep 28 15:46:43 graviton HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level=
,=20
low) -> IRQ 16
Sep 28 15:46:43 graviton ALSA device list:
Sep 28 15:46:43 graviton #0: HDA ATI SB at 0xfe024000 irq 16
Sep 28 15:46:43 graviton ip_tables: (C) 2000-2006 Netfilter Core Team
Sep 28 15:46:43 graviton TCP cubic registered
Sep 28 15:46:43 graviton NET: Registered protocol family 17
Sep 28 15:46:43 graviton RPC: Registered udp transport module.
Sep 28 15:46:43 graviton RPC: Registered tcp transport module.
Sep 28 15:46:43 graviton Installing 9P2000 support
Sep 28 15:46:43 graviton powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Cor=
e=20
Processor 3800+ processors (2 cpu cores) (version 2.20.00)
Sep 28 15:46:43 graviton powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xe
Sep 28 15:46:43 graviton powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x10
Sep 28 15:46:43 graviton powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
Sep 28 15:46:43 graviton md: Autodetecting RAID arrays.
Sep 28 15:46:43 graviton md: Scanned 15 and added 15 devices.
Sep 28 15:46:43 graviton md: autorun ...
Sep 28 15:46:43 graviton md: considering sdc9 ...
Sep 28 15:46:43 graviton md:  adding sdc9 ...
Sep 28 15:46:43 graviton md: sdc8 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sdc7 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sdc6 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sdc1 has different UUID to sdc9
Sep 28 15:46:43 graviton md:  adding sdb9 ...
Sep 28 15:46:43 graviton md: sdb8 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sdb7 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sdb6 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sdb1 has different UUID to sdc9
Sep 28 15:46:43 graviton md:  adding sda9 ...
Sep 28 15:46:43 graviton md: sda8 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sda7 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sda6 has different UUID to sdc9
Sep 28 15:46:43 graviton md: sda1 has different UUID to sdc9
Sep 28 15:46:43 graviton md: created md4
Sep 28 15:46:43 graviton md: bind<sda9>
Sep 28 15:46:43 graviton md: bind<sdb9>
Sep 28 15:46:43 graviton md: bind<sdc9>
Sep 28 15:46:43 graviton md: running: <sdc9><sdb9><sda9>
Sep 28 15:46:43 graviton raid5: device sdc9 operational as raid disk 0
Sep 28 15:46:43 graviton raid5: device sdb9 operational as raid disk 1
Sep 28 15:46:43 graviton raid5: device sda9 operational as raid disk 2
Sep 28 15:46:43 graviton raid5: allocated 4268kB for md4
Sep 28 15:46:43 graviton raid5: raid level 5 set md4 active with 3 out of 4=
=20
devices, algorithm 2
Sep 28 15:46:43 graviton RAID5 conf printout:
Sep 28 15:46:43 graviton --- rd:4 wd:3
Sep 28 15:46:43 graviton disk 0, o:1, dev:sdc9
Sep 28 15:46:43 graviton disk 1, o:1, dev:sdb9
Sep 28 15:46:43 graviton disk 2, o:1, dev:sda9
Sep 28 15:46:43 graviton md: considering sdc8 ...
Sep 28 15:46:43 graviton md:  adding sdc8 ...
Sep 28 15:46:43 graviton md: sdc7 has different UUID to sdc8
Sep 28 15:46:43 graviton md: sdc6 has different UUID to sdc8
Sep 28 15:46:43 graviton md: sdc1 has different UUID to sdc8
Sep 28 15:46:43 graviton md:  adding sdb8 ...
Sep 28 15:46:43 graviton md: sdb7 has different UUID to sdc8
Sep 28 15:46:43 graviton md: sdb6 has different UUID to sdc8
Sep 28 15:46:43 graviton md: sdb1 has different UUID to sdc8
Sep 28 15:46:43 graviton md:  adding sda8 ...
Sep 28 15:46:43 graviton md: sda7 has different UUID to sdc8
Sep 28 15:46:43 graviton md: sda6 has different UUID to sdc8
Sep 28 15:46:43 graviton md: sda1 has different UUID to sdc8
Sep 28 15:46:43 graviton md: created md3
Sep 28 15:46:43 graviton md: bind<sda8>
Sep 28 15:46:43 graviton md: bind<sdb8>
Sep 28 15:46:43 graviton md: bind<sdc8>
Sep 28 15:46:43 graviton md: running: <sdc8><sdb8><sda8>
Sep 28 15:46:43 graviton raid5: device sdc8 operational as raid disk 0
Sep 28 15:46:43 graviton raid5: device sdb8 operational as raid disk 1
Sep 28 15:46:43 graviton raid5: device sda8 operational as raid disk 2
Sep 28 15:46:43 graviton raid5: allocated 4268kB for md3
Sep 28 15:46:43 graviton raid5: raid level 5 set md3 active with 3 out of 4=
=20
devices, algorithm 2
Sep 28 15:46:43 graviton RAID5 conf printout:
Sep 28 15:46:43 graviton --- rd:4 wd:3
Sep 28 15:46:43 graviton disk 0, o:1, dev:sdc8
Sep 28 15:46:43 graviton disk 1, o:1, dev:sdb8
Sep 28 15:46:43 graviton disk 2, o:1, dev:sda8
Sep 28 15:46:43 graviton md: considering sdc7 ...
Sep 28 15:46:43 graviton md:  adding sdc7 ...
Sep 28 15:46:43 graviton md: sdc6 has different UUID to sdc7
Sep 28 15:46:43 graviton md: sdc1 has different UUID to sdc7
Sep 28 15:46:43 graviton md:  adding sdb7 ...
Sep 28 15:46:43 graviton md: sdb6 has different UUID to sdc7
Sep 28 15:46:43 graviton md: sdb1 has different UUID to sdc7
Sep 28 15:46:43 graviton md:  adding sda7 ...
Sep 28 15:46:43 graviton md: sda6 has different UUID to sdc7
Sep 28 15:46:43 graviton md: sda1 has different UUID to sdc7
Sep 28 15:46:43 graviton md: created md2
Sep 28 15:46:43 graviton md: bind<sda7>
Sep 28 15:46:43 graviton md: bind<sdb7>
Sep 28 15:46:43 graviton md: bind<sdc7>
Sep 28 15:46:43 graviton md: running: <sdc7><sdb7><sda7>
Sep 28 15:46:43 graviton md2: setting max_sectors to 128, segment boundary =
to=20
32767
Sep 28 15:46:43 graviton raid0: looking at sdc7
Sep 28 15:46:43 graviton raid0:   comparing sdc7(2939776) with sdc7(2939776)
Sep 28 15:46:43 graviton raid0:   END
Sep 28 15:46:43 graviton raid0:   =3D=3D> UNIQUE
Sep 28 15:46:43 graviton raid0: 1 zones
Sep 28 15:46:43 graviton raid0: looking at sdb7
Sep 28 15:46:43 graviton raid0:   comparing sdb7(2939776) with sdc7(2939776)
Sep 28 15:46:43 graviton raid0:   EQUAL
Sep 28 15:46:43 graviton raid0: looking at sda7
Sep 28 15:46:43 graviton raid0:   comparing sda7(2939776) with sdc7(2939776)
Sep 28 15:46:43 graviton raid0:   EQUAL
Sep 28 15:46:43 graviton raid0: FINAL 1 zones
Sep 28 15:46:43 graviton raid0: too few disks (3 of 4) - aborting!
Sep 28 15:46:43 graviton md: pers->run() failed ...
Sep 28 15:46:43 graviton md: do_md_run() returned -12
Sep 28 15:46:43 graviton md: md2 stopped.
Sep 28 15:46:43 graviton md: unbind<sdc7>
Sep 28 15:46:43 graviton md: export_rdev(sdc7)
Sep 28 15:46:43 graviton md: unbind<sdb7>
Sep 28 15:46:43 graviton md: export_rdev(sdb7)
Sep 28 15:46:43 graviton md: unbind<sda7>
Sep 28 15:46:43 graviton md: export_rdev(sda7)
Sep 28 15:46:43 graviton md: considering sdc6 ...
Sep 28 15:46:43 graviton md:  adding sdc6 ...
Sep 28 15:46:43 graviton md: sdc1 has different UUID to sdc6
Sep 28 15:46:43 graviton md:  adding sdb6 ...
Sep 28 15:46:43 graviton md: sdb1 has different UUID to sdc6
Sep 28 15:46:43 graviton md:  adding sda6 ...
Sep 28 15:46:43 graviton md: sda1 has different UUID to sdc6
Sep 28 15:46:43 graviton md: created md1
Sep 28 15:46:43 graviton md: bind<sda6>
Sep 28 15:46:43 graviton md: bind<sdb6>
Sep 28 15:46:43 graviton md: bind<sdc6>
Sep 28 15:46:43 graviton md: running: <sdc6><sdb6><sda6>
Sep 28 15:46:43 graviton raid5: device sdc6 operational as raid disk 0
Sep 28 15:46:43 graviton raid5: device sdb6 operational as raid disk 1
Sep 28 15:46:43 graviton raid5: device sda6 operational as raid disk 2
Sep 28 15:46:43 graviton raid5: allocated 4268kB for md1
Sep 28 15:46:43 graviton raid5: raid level 5 set md1 active with 3 out of 4=
=20
devices, algorithm 2
Sep 28 15:46:43 graviton RAID5 conf printout:
Sep 28 15:46:43 graviton --- rd:4 wd:3
Sep 28 15:46:43 graviton disk 0, o:1, dev:sdc6
Sep 28 15:46:43 graviton disk 1, o:1, dev:sdb6
Sep 28 15:46:43 graviton disk 2, o:1, dev:sda6
Sep 28 15:46:43 graviton md: considering sdc1 ...
Sep 28 15:46:43 graviton md:  adding sdc1 ...
Sep 28 15:46:43 graviton md:  adding sdb1 ...
Sep 28 15:46:43 graviton md:  adding sda1 ...
Sep 28 15:46:43 graviton md: created md0
Sep 28 15:46:43 graviton md: bind<sda1>
Sep 28 15:46:43 graviton md: bind<sdb1>
Sep 28 15:46:43 graviton md: bind<sdc1>
Sep 28 15:46:43 graviton md: running: <sdc1><sdb1><sda1>
Sep 28 15:46:43 graviton raid1: raid set md0 active with 3 out of 4 mirrors
Sep 28 15:46:43 graviton md: ... autorun DONE.
Sep 28 15:46:43 graviton EXT3-fs: mounted filesystem with writeback data mo=
de.
Sep 28 15:46:43 graviton VFS: Mounted root (ext3 filesystem) readonly.
Sep 28 15:46:43 graviton Freeing unused kernel memory: 324k freed
Sep 28 15:46:43 graviton kjournald starting.  Commit interval 5 seconds
Sep 28 15:46:43 graviton Clocksource tsc unstable (delta =3D -249179131 ns)
Sep 28 15:46:43 graviton EXT3 FS on md1, internal journal
Sep 28 15:46:43 graviton kjournald starting.  Commit interval 5 seconds
Sep 28 15:46:43 graviton EXT3 FS on md3, internal journal
Sep 28 15:46:43 graviton EXT3-fs: mounted filesystem with writeback data mo=
de.
Sep 28 15:46:43 graviton sky2 eth0: enabling interface
Sep 28 15:46:43 graviton Adding 506008k swap on /dev/sda5.  Priority:-1=20
extents:1 across:506008k
Sep 28 15:46:43 graviton Adding 506008k swap on /dev/sdb5.  Priority:-2=20
extents:1 across:506008k
Sep 28 15:46:43 graviton Adding 506008k swap on /dev/sdc5.  Priority:-3=20
extents:1 across:506008k
Sep 28 15:46:43 graviton sky2 eth0: Link is up at 1000 Mbps, full duplex, f=
low=20
control both
Sep 28 15:46:44 graviton NFSD: Using /var/lib/nfs/v4recovery as the NFSv4=20
state recovery directory
Sep 28 15:46:44 graviton NFSD: starting 90-second grace period
Sep 28 15:46:47 graviton dhcpd: WARNING: Host declarations are global.  The=
y=20
are not limited to the scope you declared them in.
Sep 28 15:46:47 graviton dhcpd: Wrote 0 deleted host decls to leases file.
Sep 28 15:46:47 graviton dhcpd: Wrote 0 new dynamic host decls to leases fi=
le.
Sep 28 15:46:47 graviton dhcpd: Wrote 0 leases to leases file.
Sep 28 13:46:42 graviton kdm: :0[2411]: pam_unix(kde-np:session): session=20
opened for user light by (uid=3D0)
Sep 28 13:46:43 graviton sshd[2446]: Server listening on 0.0.0.0 port 22.
Sep 28 13:47:46 graviton dhcpd: DHCPDISCOVER from [...] via eth0
Sep 28 13:47:46 graviton dhcpd: DHCPOFFER on 192.168.0.3 to [...] via eth0
Sep 28 13:47:50 graviton dhcpd: DHCPREQUEST for 192.168.0.3 (192.168.0.1) f=
rom=20
00:50:8d:f1:fb:e3 via eth0
Sep 28 13:47:50 graviton dhcpd: DHCPACK on 192.168.0.3 to [...] via eth0
Sep 28 11:47:50 graviton in.tftpd[2618]: RRQ from 192.168.0.3=20
filename /pxelinux.0
Sep 28 11:47:50 graviton in.tftpd[2618]: tftp: client does not accept optio=
ns
Sep 28 11:47:50 graviton in.tftpd[2619]: RRQ from 192.168.0.3=20
filename /pxelinux.0
Sep 28 11:47:51 graviton in.tftpd[2620]: RRQ from 192.168.0.3=20
filename /pxelinux.cfg/01-00-50-8d-f1-fb-e3
Sep 28 11:47:51 graviton in.tftpd[2621]: RRQ from 192.168.0.3=20
filename //bzImage.tachyon
Sep 28 13:48:00 graviton dhcpd: DHCPDISCOVER from [...] via eth0
Sep 28 13:48:00 graviton dhcpd: DHCPOFFER on 192.168.0.3 to [...] via eth0
Sep 28 13:48:00 graviton dhcpd: DHCPREQUEST for 192.168.0.3 (192.168.0.1) f=
rom=20
[...] via eth0
Sep 28 13:48:00 graviton dhcpd: DHCPACK on 192.168.0.3 to [...] via eth0
Sep 28 13:48:00 graviton mountd[2237]: authenticated mount request from=20
192.168.0.3:755 for /diskless/tachyon (/diskless/tachyon)
Sep 28 13:50:00 graviton su[2655]: Successful su for root by light
Sep 28 13:50:00 graviton su[2655]: + pts/1 light:root
Sep 28 13:50:00 graviton su[2655]: pam_unix(su:session): session opened for=
=20
user root by (uid=3D1000)
Sep 28 13:50:15 graviton /etc/init.d/nfs[2679]: WARNING: nfs has already be=
en=20
started
Sep 28 13:50:17 graviton mountd[2237]: Caught signal 15, un-registering and=
=20
exiting.
Sep 28 13:50:17 graviton nfsd: last server has exited, flushing export cache
Sep 28 13:50:18 graviton NFSD: Using /var/lib/nfs/v4recovery as the NFSv4=20
state recovery directory
Sep 28 13:50:18 graviton NFSD: starting 90-second grace period
Sep 28 13:50:39 graviton CIFS VFS: cifs_mount failed w/return code =3D -22
Sep 28 13:51:05 graviton mountd[2718]: authenticated mount request from=20
192.168.0.1:785 for /diskless/tachyon (/diskless/tachyon)
Sep 28 13:51:36 graviton mountd[2718]: authenticated unmount request from=20
192.168.0.1:827 for /diskless/tachyon (/diskless/tachyon)
Sep 28 13:52:57 graviton dhcpd: DHCPDISCOVER from [...] via eth0
Sep 28 13:52:57 graviton dhcpd: DHCPOFFER on 192.168.0.3 to [...] via eth0
Sep 28 13:53:01 graviton dhcpd: DHCPREQUEST for 192.168.0.3 (192.168.0.1) f=
rom=20
[...] via eth0
Sep 28 13:53:01 graviton dhcpd: DHCPACK on 192.168.0.3 to [...] via eth0
Sep 28 11:53:01 graviton in.tftpd[2805]: RRQ from 192.168.0.3=20
filename /pxelinux.0
Sep 28 11:53:01 graviton in.tftpd[2805]: tftp: client does not accept optio=
ns
Sep 28 11:53:01 graviton in.tftpd[2806]: RRQ from 192.168.0.3=20
filename /pxelinux.0
Sep 28 11:53:01 graviton in.tftpd[2807]: RRQ from 192.168.0.3=20
filename /pxelinux.cfg/01-00-50-8d-f1-fb-e3
Sep 28 11:53:01 graviton in.tftpd[2808]: RRQ from 192.168.0.3=20
filename //bzImage.tachyon
Sep 28 13:53:10 graviton dhcpd: DHCPDISCOVER from [...] via eth0
Sep 28 13:53:10 graviton dhcpd: DHCPOFFER on 192.168.0.3 to [...] via eth0
Sep 28 13:53:10 graviton dhcpd: DHCPREQUEST for 192.168.0.3 (192.168.0.1) f=
rom=20
[...] via eth0
Sep 28 13:53:10 graviton dhcpd: DHCPACK on 192.168.0.3 to [...] via eth0
Sep 28 13:53:10 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:782 for /diskless/tachyon (/diskless/tachyon)
Sep 28 13:53:14 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:687 for /diskless/tachyon (/diskless/tachyon)
Sep 28 13:53:35 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:698 for /mnt/raid5 (/mnt/raid5)
Sep 28 13:53:35 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:700 for /home/light (/home/light)
Sep 28 13:53:35 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:701 for /var1/portage (/var1/portage)
Sep 28 13:53:35 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:702 for /var1/lportage (/var1/lportage)
Sep 28 13:53:35 graviton mountd[2718]: authenticated mount request from=20
192.168.0.3:703 for /var1/overlays (/var1/overlays)
Sep 28 12:13:34 graviton -- MARK --
Sep 28 12:33:34 graviton -- MARK --
Sep 28 14:36:15 graviton BUG: scheduling while atomic: swapper/0/0x00000102
Sep 28 14:36:15 graviton Modules linked in:
Sep 28 14:36:15 graviton CPU 0:
Sep 28 14:36:15 graviton Modules linked in:
Sep 28 14:36:15 graviton Pid: 0, comm: swapper Not tainted 2.6.27-rc7 #1
Sep 28 14:36:15 graviton RIP: 0010:[<ffffffff8022ccba>]  [<ffffffff8022ccba=
>]=20
default_idle+0x3a/0x40
Sep 28 14:36:15 graviton RSP: 0018:ffffffff807f9f70  EFLAGS: 00000246
Sep 28 14:36:15 graviton RAX: ffffffff807f9fd8 RBX: ffffffff8082f3e0 RCX:=20
0000000000000000
Sep 28 14:36:15 graviton RDX: ffffffff8084eb20 RSI: 0000000000000092 RDI:=20
ffffffff8088a120
Sep 28 14:36:15 graviton RBP: ffffffff80852700 R08: 0000000000000000 R09:=20
0000000100294985
Sep 28 14:36:15 graviton R10: 00000000ffffffff R11: ffffffff80237d80 R12:=20
ffffffff8025eeb7
Sep 28 14:36:15 graviton R13: 000002bbd7672100 R14: ffffffff802749bd R15:=20
0000000000000092
Sep 28 14:36:15 graviton FS:  00007ffe25b04760(0000) GS:ffffffff807f1280(00=
00)=20
knlGS:0000000000000000
Sep 28 14:36:15 graviton CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Sep 28 14:36:15 graviton CR2: 0000000000000000 CR3: 00000000728b9000 CR4:=20
00000000000006e0
Sep 28 14:36:15 graviton DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
Sep 28 14:36:15 graviton DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
Sep 28 14:36:15 graviton=20
Sep 28 14:36:15 graviton Call Trace:
Sep 28 14:36:15 graviton [<ffffffff8022cd58>] ? c1e_idle+0x98/0xe0
Sep 28 14:36:15 graviton [<ffffffff80222b9e>] ? cpu_idle+0x5e/0xf0
Sep 28 14:36:15 graviton=20
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--Boundary-01=_XL83Ina9BvgJ5pr
Content-Type: application/x-bzip2;
  name=".config.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename=".config.bz2"

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

--Boundary-01=_XL83Ina9BvgJ5pr--

--nextPart2381257.BLdxhLxZtz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjfwtsACgkQxU2n/+9+t5hOLQCgkq+LIH0qEcVsHHP42Etd6AEa
9hcAoLOtsnAC3376xvEkxyAJGP41shSe
=ghHx
-----END PGP SIGNATURE-----

--nextPart2381257.BLdxhLxZtz--
