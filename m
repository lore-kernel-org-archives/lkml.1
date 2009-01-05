Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZAERFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZAERFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZAERFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:05:38 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:43316 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751816AbZAERF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:05:26 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: 2.6.28: warn_slowpath in orinoco receive path
Date: Mon, 5 Jan 2009 20:05:09 +0300
User-Agent: KMail/1.10.92 (Linux/2.6.28-1avb; KDE/4.1.85; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1452851.jvAoepAzrl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901052005.12428.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1452851.jvAoepAzrl
Content-Type: multipart/mixed;
  boundary="Boundary-01=_H3jYJUfsNa/xcXg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_H3jYJUfsNa/xcXg
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I would appreciate explanation which condition triggers this=20
warn_slowpath. Otherwise does it ring the bell for someone? Network was=20
dead after it till I reloaded modules (orinoco and hermes).

dmesg and config follow.

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-1avb (bor@cooker) (gcc version 4.3.2=20
(GCC) ) #26 Thu Dec 25 20:23:38 MSK 2008
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] PAT WC disabled due to known CPU erratum.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000=20
(reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00=20
(reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI=20
NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000=20
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
[    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI=20
data)
[    0.000000]  BIOS-e820: 000000001ef70000 - 0000000020000000=20
(reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000=20
(reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn =3D 0x1ef60 max_arch_pfn =3D 0x100000
[    0.000000] kernel direct mapping tables up to 1ef60000 @ 7000-d000
[    0.000000] RAMDISK: 1ebd2000 - 1ef4fa31
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814=20
TASM  4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814=20
TASM  4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417=20
MSFT  100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] 495MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ef60000
[    0.000000]   low ram: 00000000 - 1ef60000
[    0.000000]   bootmap 00001000 - 00004dec
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 -=20
001ef60000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D>=20
[0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000944b54]    TEXT DATA BSS =3D=3D>=20
[0000100000 - 0000944b54]
[    0.000000]   #2 [001ebd2000 - 001ef4fa31]          RAMDISK =3D=3D>=20
[001ebd2000 - 001ef4fa31]
[    0.000000]   #3 [0000945000 - 0000949000]    INIT_PG_TABLE =3D=3D>=20
[0000945000 - 0000949000]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved =3D=3D>=20
[000009fc00 - 0000100000]
[    0.000000]   #5 [0000007000 - 0000009000]          PGTABLE =3D=3D>=20
[0000007000 - 0000009000]
[    0.000000]   #6 [0000001000 - 0000005000]          BOOTMAP =3D=3D>=20
[0000001000 - 0000005000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001ef60
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001ef60
[    0.000000] On node 0 totalpages: 126719
[    0.000000] free_area_init_node: node 0, pgdat c03defe0, node_mem_map=20
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 959 pages used for memmap
[    0.000000]   Normal zone: 121761 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] PM: Registered nosave memory: 000000000009f000 -=20
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -=20
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -=20
00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 -=20
00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 -=20
0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. =20
Total pages: 125728
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.28-1avb root=3DLABEL=
=3D/=20
resume=3DLABEL=3Dswap acpi_backlight=3Dvendor=20
netconsole=3D@10.0.0.1/eth0,@10.0.0.2/00:17:42:21:27:e4 vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0428000 soft=3Dc0427000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 747.740 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat,=20
Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2463 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333]=20
=2D------------------------------------------------------------------------=
=2D--
[    0.003333]                                  | spin |wlock |rlock |
mutex | wsem | rsem |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  | =20
ok  |  ok  |  ok  |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]               recursive read-lock:             |  ok  |     =
       =20
|  ok  |
[    0.003333]            recursive read-lock #2:             |  ok  |     =
       =20
|  ok  |
[    0.003333]             mixed read-write-lock:             |  ok  |     =
       =20
|  ok  |
[    0.003333]             mixed write-read-lock:             |  ok  |     =
       =20
|  ok  |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq read-recursion/123:  ok  |
[    0.003333]       soft-irq read-recursion/123:  ok  |
[    0.003333]       hard-irq read-recursion/132:  ok  |
[    0.003333]       soft-irq read-recursion/132:  ok  |
[    0.003333]       hard-irq read-recursion/213:  ok  |
[    0.003333]       soft-irq read-recursion/213:  ok  |
[    0.003333]       hard-irq read-recursion/231:  ok  |
[    0.003333]       soft-irq read-recursion/231:  ok  |
[    0.003333]       hard-irq read-recursion/312:  ok  |
[    0.003333]       soft-irq read-recursion/312:  ok  |
[    0.003333]       hard-irq read-recursion/321:  ok  |
[    0.003333]       soft-irq read-recursion/321:  ok  |
[    0.003333] -------------------------------------------------------
[    0.003333] Good, all 218 testcases passed! |
[    0.003333] ---------------------------------
[    0.003333] Dentry cache hash table entries: 65536 (order: 6, 262144=20
bytes)
[    0.003333] Inode-cache hash table entries: 32768 (order: 5, 131072=20
bytes)
[    0.003333] Memory: 490172k/507264k available (2041k kernel code,=20
16472k reserved, 938k data, 232k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
[    0.003333]     vmalloc : 0xdf760000 - 0xfffeb000   ( 520 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[    0.003333]       .init : 0xc03ea000 - 0xc0424000   ( 232 kB)
[    0.003333]       .data : 0xc02fe5d9 - 0xc03e8f1c   ( 938 kB)
[    0.003333]       .text : 0xc0100000 - 0xc02fe5d9   (2041 kB)
[    0.003333] Checking if this processor honours the WP bit even in=20
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0,=20
CPUs=3D1, Nodes=3D1
[    0.003406] Calibrating delay loop (skipped), value calculated using=20
timer frequency.. 1496.79 BogoMIPS (lpj=3D2492466)
[    0.003557] Mount-cache hash table entries: 512
[    0.005679] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.005718] CPU: L2 cache: 256K
[    0.005736] CPU serial number disabled.
[    0.005782] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.005825] Checking 'hlt' instruction... OK.
[    0.017691] Freeing SMP alternatives: 0k freed
[    0.017711] ACPI: Core revision 20080926
[    0.046162] ACPI: setting ELCR to 0200 (from 0a00)
[    0.049512] Testing tracer nop: PASSED
[    0.053446] net_namespace: 392 bytes
[    0.054906] NET: Registered protocol family 16
[    0.058449] ACPI: bus type pci registered
[    0.060549] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[    0.060599] PCI: Using configuration type 1 for base access
[    0.079809] ACPI: EC: Look up EC in DSDT
[    0.107886] ACPI: Interpreter enabled
[    0.107949] ACPI: (supports S0 S3 S4 S5)
[    0.108158] ACPI: Using PIC for interrupt routing
[    0.163771] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.163934] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.164961] pci 0000:00:00.0: reg 10 32bit mmio:=20
[0xf0000000-0xf3ffffff]
[    0.165292] pci 0000:00:02.0: reg 10 32bit mmio:=20
[0xf7eff000-0xf7efffff]
[    0.165405] pci 0000:00:02.0: PME# supported from D3hot D3cold
[    0.165447] pci 0000:00:02.0: PME# disabled
[    0.165613] pci 0000:00:04.0: reg 20 io port: [0xeff0-0xefff]
[    0.165771] pci 0000:00:06.0: reg 10 io port: [0xed00-0xedff]
[    0.165794] pci 0000:00:06.0: reg 14 32bit mmio:=20
[0xf7efe000-0xf7efefff]
[    0.165892] pci 0000:00:06.0: supports D1 D2
[    0.165900] pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
[    0.165928] pci 0000:00:06.0: PME# disabled
[    0.166329] pci 0000:00:08.0: quirk: region ee00-ee3f claimed by=20
ali7101 ACPI
[    0.166359] pci 0000:00:08.0: quirk: region ef00-ef1f claimed by=20
ali7101 SMB
[    0.166473] pci 0000:00:0a.0: reg 10 32bit mmio:=20
[0xf7efd000-0xf7efdfff]
[    0.166497] pci 0000:00:0a.0: reg 14 io port: [0xeb40-0xeb7f]
[    0.166520] pci 0000:00:0a.0: reg 18 32bit mmio:=20
[0xf7d00000-0xf7dfffff]
[    0.166805] pci 0000:00:0a.0: supports D1 D2
[    0.166814] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot=20
D3cold
[    0.166844] pci 0000:00:0a.0: PME# disabled
[    0.166974] pci 0000:00:10.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.167006] pci 0000:00:10.0: supports D1 D2
[    0.167014] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot=20
D3cold
[    0.167043] pci 0000:00:10.0: PME# disabled
[    0.167157] pci 0000:00:11.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.167288] pci 0000:00:11.1: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.167438] pci 0000:00:12.0: reg 10 32bit mmio:=20
[0xf7cffe00-0xf7cfffff]
[    0.167553] pci 0000:00:12.0: supports D1 D2
[    0.167561] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot=20
D3cold
[    0.167590] pci 0000:00:12.0: PME# disabled
[    0.167780] pci 0000:01:00.0: reg 10 32bit mmio:=20
[0xfc000000-0xfdffffff]
[    0.167803] pci 0000:01:00.0: reg 14 32bit mmio:=20
[0xfbc00000-0xfbffffff]
[    0.167825] pci 0000:01:00.0: reg 18 32bit mmio:=20
[0xf8000000-0xf9ffffff]
[    0.167847] pci 0000:01:00.0: reg 1c 32bit mmio:=20
[0xf7ff8000-0xf7ffffff]
[    0.167892] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.167926] pci 0000:01:00.0: supports D1 D2
[    0.168059] pci 0000:00:01.0: bridge 32bit mmio:=20
[0xf7f00000-0xfdffffff]
[    0.168262] bus 00 -> node 0
[    0.168313] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.169012] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.204220] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[    0.205154] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[    0.206025] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[    0.206967] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[    0.207832] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[    0.208703] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[    0.210233] ACPI: Power Resource [PFAN] (off)
[    0.212958] PCI: Using ACPI for IRQ routing
[    0.214505] pnp: PnP ACPI init
[    0.214505] ACPI: bus type pnp registered
[    0.240351] pnp: PnP ACPI: found 12 devices
[    0.240405] ACPI: ACPI bus type pnp unregistered
[    0.240506] system 00:00: iomem range 0x0-0x9ffff could not be=20
reserved
[    0.240536] system 00:00: iomem range 0xe0000-0xeffff could not be=20
reserved
[    0.240564] system 00:00: iomem range 0xf0000-0xfffff could not be=20
reserved
[    0.240592] system 00:00: iomem range 0x100000-0x1ef5ffff could not=20
be reserved
[    0.240622] system 00:00: iomem range 0x1ef60000-0x1ef6ffff could not=20
be reserved
[    0.240652] system 00:00: iomem range 0x1f000000-0x1fffffff has been=20
reserved
[    0.240679] system 00:00: iomem range 0x1ef70000-0x1effffff has been=20
reserved
[    0.240709] system 00:00: iomem range 0xffe00000-0xffffffff could not=20
be reserved
[    0.240800] system 00:08: ioport range 0x370-0x371 has been reserved
[    0.240827] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.240852] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.240877] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.240903] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.240928] system 00:08: ioport range 0x6c0-0x6ff has been reserved
[    0.240953] system 00:08: ioport range 0xe000-0xe07f has been=20
reserved
[    0.240979] system 00:08: ioport range 0xe080-0xe0ff has been=20
reserved
[    0.241005] system 00:08: ioport range 0xe400-0xe47f has been=20
reserved
[    0.241031] system 00:08: ioport range 0xe480-0xe4ff has been=20
reserved
[    0.241057] system 00:08: ioport range 0xe800-0xe87f has been=20
reserved
[    0.241083] system 00:08: ioport range 0xe880-0xe8ff has been=20
reserved
[    0.241109] system 00:08: ioport range 0xec00-0xec7f has been=20
reserved
[    0.241136] system 00:08: ioport range 0xec80-0xecff has been=20
reserved
[    0.241163] system 00:08: ioport range 0xee00-0xee41 could not be=20
reserved
[    0.241190] system 00:08: ioport range 0xee90-0xee9f has been=20
reserved
[    0.241216] system 00:08: ioport range 0xeeac-0xeeac has been=20
reserved
[    0.241244] system 00:08: ioport range 0xef00-0xef3f could not be=20
reserved
[    0.241270] system 00:08: ioport range 0xef40-0xef5f has been=20
reserved
[    0.281500] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.281554] pci 0000:00:01.0:   IO window: disabled
[    0.281586] pci 0000:00:01.0:   MEM window: 0xf7f00000-0xfdffffff
[    0.281616] pci 0000:00:01.0:   PREFETCH window:=20
0x00000048000000-0x000000480fffff
[    0.281661] pci 0000:00:10.0: CardBus bridge, secondary bus 0000:02
[    0.281683] pci 0000:00:10.0:   IO window: 0x001000-0x0010ff
[    0.281711] pci 0000:00:10.0:   IO window: 0x001400-0x0014ff
[    0.281738] pci 0000:00:10.0:   PREFETCH window:=20
0x30000000-0x33ffffff
[    0.281768] pci 0000:00:10.0:   MEM window: 0x34000000-0x37ffffff
[    0.281797] pci 0000:00:11.0: CardBus bridge, secondary bus 0000:06
[    0.281818] pci 0000:00:11.0:   IO window: 0x001800-0x0018ff
[    0.281845] pci 0000:00:11.0:   IO window: 0x001c00-0x001cff
[    0.281873] pci 0000:00:11.0:   PREFETCH window:=20
0x38000000-0x3bffffff
[    0.281903] pci 0000:00:11.0:   MEM window: 0x3c000000-0x3fffffff
[    0.281932] pci 0000:00:11.1: CardBus bridge, secondary bus 0000:0a
[    0.281953] pci 0000:00:11.1:   IO window: 0x002000-0x0020ff
[    0.281980] pci 0000:00:11.1:   IO window: 0x002400-0x0024ff
[    0.282008] pci 0000:00:11.1:   PREFETCH window:=20
0x40000000-0x43ffffff
[    0.282037] pci 0000:00:11.1:   MEM window: 0x44000000-0x47ffffff
[    0.282102] pci 0000:00:01.0: setting latency timer to 64
[    0.282135] pci 0000:00:10.0: enabling device (0000 -> 0003)
[    0.283989] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.284023] PCI: setting IRQ 11 as level-triggered
[    0.284038] pci 0000:00:10.0: PCI INT A -> Link[LNKC] -> GSI 11=20
(level, low) -> IRQ 11
[    0.284099] pci 0000:00:11.0: enabling device (0000 -> 0003)
[    0.285500] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.285526] pci 0000:00:11.0: PCI INT A -> Link[LNKA] -> GSI 11=20
(level, low) -> IRQ 11
[    0.285585] pci 0000:00:11.1: enabling device (0000 -> 0003)
[    0.287021] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.287048] pci 0000:00:11.1: PCI INT B -> Link[LNKB] -> GSI 11=20
(level, low) -> IRQ 11
[    0.287094] bus: 00 index 0 io port: [0x00-0xffff]
[    0.287113] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.287132] bus: 01 index 0 mmio: [0x0-0x0]
[    0.287149] bus: 01 index 1 mmio: [0xf7f00000-0xfdffffff]
[    0.287168] bus: 01 index 2 mmio: [0x48000000-0x480fffff]
[    0.287186] bus: 01 index 3 mmio: [0x0-0x0]
[    0.287205] bus: 02 index 0 io port: [0x1000-0x10ff]
[    0.287223] bus: 02 index 1 io port: [0x1400-0x14ff]
[    0.287241] bus: 02 index 2 mmio: [0x30000000-0x33ffffff]
[    0.287260] bus: 02 index 3 mmio: [0x34000000-0x37ffffff]
[    0.287280] bus: 06 index 0 io port: [0x1800-0x18ff]
[    0.287298] bus: 06 index 1 io port: [0x1c00-0x1cff]
[    0.287316] bus: 06 index 2 mmio: [0x38000000-0x3bffffff]
[    0.287335] bus: 06 index 3 mmio: [0x3c000000-0x3fffffff]
[    0.287354] bus: 0a index 0 io port: [0x2000-0x20ff]
[    0.287372] bus: 0a index 1 io port: [0x2400-0x24ff]
[    0.287390] bus: 0a index 2 mmio: [0x40000000-0x43ffffff]
[    0.287409] bus: 0a index 3 mmio: [0x44000000-0x47ffffff]
[    0.287493] NET: Registered protocol family 2
[    0.288476] IP route cache hash table entries: 4096 (order: 2, 16384=20
bytes)
[    0.289493] TCP established hash table entries: 16384 (order: 5,=20
131072 bytes)
[    0.290381] TCP bind hash table entries: 16384 (order: 7, 589824=20
bytes)
[    0.296294] TCP: Hash tables configured (established 16384 bind=20
16384)
[    0.296578] TCP reno registered
[    0.297382] NET: Registered protocol family 1
[    0.298791] checking if image is initramfs... it is
[    0.783494] Switched to high resolution mode on CPU 0
[    1.207685] Freeing initrd memory: 3574k freed
[    1.215621] Initializing RT-Tester: OK
[    1.217136] audit: initializing netlink socket (disabled)
[    1.217363] type=3D2000 audit(1230972547.216:1): initialized
[    1.232745] Kprobe smoke test started
[    1.237108] Kprobe smoke test passed successfully
[    1.237220] Testing tracer sched_switch: PASSED
[    1.371020] msgmni has been set to 964
[    1.372429] io scheduler noop registered
[    1.372466] io scheduler anticipatory registered
[    1.372485] io scheduler deadline registered
[    1.372602] io scheduler cfq registered (default)
[    1.372877] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    1.372956] pci 0000:00:0a.0: Firmware left e100 interrupts enabled;=20
disabling
[    1.373052] pci 0000:01:00.0: Boot video device
[    1.375768] vesafb: framebuffer at 0xfc000000, mapped to 0xdf780000,=20
using 3072k, total 16384k
[    1.375822] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[    1.375844] vesafb: protected mode interface info at c000:775e
[    1.375865] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[    1.375887] vesafb: scrolling: redraw
[    1.375908] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.443451] Console: switching to colour frame buffer device 128x48
[    1.508980] fb0: VESA VGA frame buffer device
[    1.895728] brd: module loaded
[    1.896180] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    1.897041] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.899927] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.900957] e100 0000:00:0a.0: PCI INT A -> Link[LNKD] -> GSI 11=20
(level, low) -> IRQ 11
[    1.928753] e100 0000:00:0a.0: PME# disabled
[    1.930542] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:d7:14:a1
[    1.931955] netconsole: local port 6665
[    1.932445] netconsole: local IP 10.0.0.1
[    1.932942] netconsole: interface eth0
[    1.933634] netconsole: remote port 6666
[    1.934125] netconsole: remote IP 10.0.0.2
[    1.934636] netconsole: remote ethernet address 00:17:42:21:27:e4
[    1.935427] netconsole: device eth0 not up yet, forcing it
[    5.966723] netconsole: timeout waiting for carrier
[    5.969264] console [netcon0] enabled
[   11.528019] Clocksource tsc unstable (delta =3D 4686872086 ns)
[   11.553330] netconsole: network logging started
[   11.578938] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at=20
0x60,0x64 irq 1,12
[   11.609537] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.634257] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.661567] mice: PS/2 mouse device common for all mice
[   11.686238] cpuidle: using governor ladder
[   11.709905] cpuidle: using governor menu
[   11.733578] TCP cubic registered
[   11.756852] Using IPI Shortcut mode
[   11.783150] registered taskstats version 1
[   11.807504] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   11.835732] Freeing unused kernel memory: 232k freed
[   11.860389] Write protecting the kernel text: 2044k
[   11.884027] Write protecting the kernel read-only data: 768k
[   11.936955] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input0
[   12.549127] SCSI subsystem initialized
[   12.616973] Driver 'sd' needs updating - please use bus_type methods
[   12.743299] libata version 3.00 loaded.
[   12.783348] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[   12.807440] scsi0 : pata_ali
[   12.831550] scsi1 : pata_ali
[   12.858044] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0=20
irq 14
[   12.880525] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8=20
irq 15
[   13.060904] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[   13.082736] ata1.00: 39070080 sectors, multi 0: LBA=20
[   13.104422] ata1.00: limited to UDMA/33 due to 40-wire cable
[   13.137442] ata1.00: configured for UDMA/33
[   13.357237] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max=20
UDMA/33
[   13.378896] ata2.00: WARNING: ATAPI DMA disabled for reliablity=20
issues.  It can be enabled
[   13.401179] ata2.00: WARNING: via pata_ali.atapi_dma modparam or=20
corresponding sysfs node.
[   13.437232] ata2.00: configured for UDMA/33
[   13.464735] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0=20
DA3O PQ: 0 ANSI: 5
[   13.490601] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[   13.514667] sd 0:0:0:0: [sda] Write Protect is off
[   13.538444] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.538704] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   13.565175] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[   13.589854] sd 0:0:0:0: [sda] Write Protect is off
[   13.614097] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.614306] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   13.638954]  sda: sda1 sda2
[   13.924661] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.968100] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502=20
1313 PQ: 0 ANSI: 5
[   14.253617] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[   14.280221] ReiserFS: sda2: using ordered data mode
[   14.321446] ReiserFS: sda2: journal params: device sda2, size 8192,=20
journal first block 18, max trans len 1024, max batch 900, max commit=20
age 30, max trans age 30
[   14.384649] ReiserFS: sda2: checking transaction log (sda2)
[   14.463139] ReiserFS: sda2: Using r5 hash to sort names
[   17.443514] usbcore: registered new interface driver usbfs
[   17.470805] usbcore: registered new interface driver hub
[   17.497547] usbcore: registered new device driver usb
[   24.394010] Linux agpgart interface v0.103
[   24.405941] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   24.411786] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   24.411813] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[   24.411975] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   24.414541] ohci_hcd 0000:00:02.0: new USB bus registered, assigned=20
bus number 1
[   24.414669] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   24.471787] usb usb1: configuration #1 chosen from 1 choice
[   24.472616] hub 1-0:1.0: USB hub found
[   24.472902] hub 1-0:1.0: 3 ports detected
[   24.558042] input: Power Button (FF) as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   24.570211] ACPI: Power Button (FF) [PWRF]
[   24.570957] input: Lid Switch as=20
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[   24.571415] ACPI: Lid Switch [LID]
[   24.671572] ACPI: AC Adapter [ADP1] (on-line)
[   24.860194] agpgart-ali 0000:00:00.0: ALi M1644 chipset
[   24.871030] agpgart-ali 0000:00:00.0: AGP aperture is 64M @=20
0xf0000000
[   24.985970] ACPI Warning (nspredef-0858): \_SB_.BAT1._BIF: Return=20
Package type mismatch at index 12 - found Integer, expected=20
String/Buffer [20080926]
[   24.987817] ACPI: Battery Slot [BAT1] (battery present)
[   24.988033] ACPI: Battery Slot [BAT2] (battery absent)
[   25.134528] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   25.135654] processor ACPI_CPU:00: registered as cooling_device0
[   25.229799] thermal LNXTHERM:01: registered as thermal_zone0
[   25.231810] ACPI: Thermal Zone [THRM] (58 C)
[   25.335374] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   25.335391] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   25.530744] input: Video Bus as=20
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14/device:15/input/input3
[   25.541008] ACPI: Video Device [VGA] (multi-head: yes  rom: yes =20
post: no)
[   25.658782] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   25.659115] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   25.772344] fan PNP0C0B:00: registered as cooling_device1
[   25.772381] ACPI: Fan [FAN] (off)
[   26.080455] pci 0000:00:08.0: enabling device (0000 -> 0001)
[   26.081621] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[   27.190319] Driver 'sr' needs updating - please use bus_type methods
[   27.272525] input: PC Speaker as=20
/devices/platform/pcspkr/input/input4
[   27.293123] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   27.293149] Uniform CD-ROM driver Revision: 3.20
[   27.294913] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   27.373603] yenta_cardbus 0000:00:10.0: CardBus bridge found=20
[12a3:ab01]
[   27.392891] input: ImPS/2 Generic Wheel Mouse as=20
/devices/platform/i8042/serio1/input/input5
[   27.501376] yenta_cardbus 0000:00:10.0: ISA IRQ mask 0x0000, PCI irq=20
11
[   27.501395] yenta_cardbus 0000:00:10.0: Socket status: 30000011
[   27.507823] yenta_cardbus 0000:00:11.0: CardBus bridge found=20
[1179:0001]
[   27.634301] yenta_cardbus 0000:00:11.0: ISA IRQ mask 0x04b8, PCI irq=20
11
[   27.634320] yenta_cardbus 0000:00:11.0: Socket status: 30000087
[   27.651978] yenta_cardbus 0000:00:11.1: CardBus bridge found=20
[1179:0001]
[   27.777600] yenta_cardbus 0000:00:11.1: ISA IRQ mask 0x04b8, PCI irq=20
11
[   27.777619] yenta_cardbus 0000:00:11.1: Socket status: 30000007
[   28.346808] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card=20
inserted into slot 0
[   29.475993] NET: Registered protocol family 23
[   29.496559] rtc_cmos 00:07: RTC can wake from S4
[   29.498431] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   29.498530] rtc0: alarms up to one year, 114 bytes nvram
[   29.719553] Detected unconfigured Toshiba laptop with ALi ISA bridge=20
SMSC IrDA chip, pre-configuring device.
[   29.719592] Activated ALi 1533 ISA bridge port 0x02e8.
[   29.719609] Activated ALi 1533 ISA bridge port 0x02f8.
[   29.719856] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[   29.719871] smsc_superio_flat(): IrDA not enabled
[   29.719899] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03,=20
irq: 7, mode: 0x02
[   29.719939] SMsC IrDA Controller found
[   29.719942]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3,=20
irq=3D7
[   29.720274] No transceiver found. Defaulting to Fast pin select
[   29.721398] IrDA: Registered device irda0
[   31.286462] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[   31.288154] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   31.288173] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[   36.331414] pcmcia_socket pcmcia_socket1: cs: IO port probe=20
0x100-0x3af: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   36.335268] pcmcia_socket pcmcia_socket1: cs: IO port probe=20
0x3e0-0x4ff: clean.
[   36.336858] pcmcia_socket pcmcia_socket1: cs: IO port probe=20
0x820-0x8ff: clean.
[   36.338236] pcmcia_socket pcmcia_socket1: cs: IO port probe=20
0xc00-0xcf7: clean.
[   36.340781] pcmcia_socket pcmcia_socket1: cs: IO port probe=20
0xa00-0xaff: clean.
[   36.343285] pcmcia_socket pcmcia_socket2: cs: IO port probe=20
0x100-0x3af: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   36.347003] pcmcia_socket pcmcia_socket2: cs: IO port probe=20
0x3e0-0x4ff: clean.
[   36.348764] pcmcia_socket pcmcia_socket2: cs: IO port probe=20
0x820-0x8ff: clean.
[   36.350237] pcmcia_socket pcmcia_socket2: cs: IO port probe=20
0xc00-0xcf7: clean.
[   36.352917] pcmcia_socket pcmcia_socket2: cs: IO port probe=20
0xa00-0xaff: clean.
[   37.131723] pcmcia_socket pcmcia_socket0: cs: IO port probe=20
0x100-0x3af: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   37.135102] pcmcia_socket pcmcia_socket0: cs: IO port probe=20
0x3e0-0x4ff: clean.
[   37.136598] pcmcia_socket pcmcia_socket0: cs: IO port probe=20
0x820-0x8ff: clean.
[   37.138107] pcmcia_socket pcmcia_socket0: cs: IO port probe=20
0xc00-0xcf7: clean.
[   37.140717] pcmcia_socket pcmcia_socket0: cs: IO port probe=20
0xa00-0xaff: clean.
[   37.143049] pcmcia_socket pcmcia_socket0: cs: memory probe=20
0xa0000000-0xa0ffffff: clean.
[   37.211218] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[   37.952307] Marking TSC unstable due to TSC halts in idle
[   38.195106] orinoco 0.15 (David Gibson=20
<hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   38.251851] orinoco_cs 0.15 (David Gibson=20
<hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
[   38.333966] eth1: Hardware identity 0005:0002:0001:0002
[   38.334086] eth1: Station identity  001f:0001:0006:000e
[   38.334098] eth1: Firmware determined as Lucent/Agere 6.14
[   38.334113] eth1: Attempting to download firmware agere_sta_fw.bin
[   38.334143] hermes_dld: AUX enable returned 0
[   38.335147] hermes_dld: AUX disable returned 0
[   38.335155] hermes_dld: Actual PDA length 998, Max allowed 1000
[   38.335163] eth1: Read PDA returned 0
[   38.335177] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[   38.457470] hermes_dld: AUX enable returned 0
[   38.457486] hermes_dld: Enabling volatile, EP 0x000f8000
[   38.458578] hermes_dld: PROGRAM_ENABLE returned 0
[   38.458586] eth1: Program init returned 0
[   38.458596] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[   38.507704] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[   38.511267] eth1: Program returned 0
[   38.511278] hermes_dld: Found record 0x0003 at dd807c1c
[   38.511300] hermes_dld: Found record 0x0005 at dd807ca8
[   38.511320] hermes_dld: Found record 0x0008 at dd807cd2
[   38.511336] hermes_dld: Found record 0x0007 at dd807cc4
[   38.511354] hermes_dld: Found record 0x0006 at dd807cb6
[   38.511374] hermes_dld: Found record 0x0110 at dd807d9a
[   38.511408] hermes_dld: Found record 0x0120 at dd807dba
[   38.511440] hermes_dld: Found record 0x0130 at dd807dda
[   38.511473] hermes_dld: Found record 0x0140 at dd807dfa
[   38.511486] hermes_dld: Found record 0x0150 at dd807e02
[   38.511499] hermes_dld: Using default record 0x0160 at dfa9fb60
[   38.511532] hermes_dld: Found record 0x0101 at dd807d46
[   38.511547] hermes_dld: Found record 0x0103 at dd807d5c
[   38.511567] hermes_dld: Found record 0x0104 at dd807d6c
[   38.511579] hermes_dld: Found record 0x0105 at dd807d72
[   38.511591] hermes_dld: Found record 0x0105 at dd807d72
[   38.511603] hermes_dld: Found record 0x0105 at dd807d72
[   38.511615] hermes_dld: Found record 0x0107 at dd807d7e
[   38.511627] hermes_dld: Found record 0x0109 at dd807d8c
[   38.511645] hermes_dld: Using default record 0x0161 at dfa9fb80
[   38.511850] eth1: Apply PDA returned 0
[   38.511914] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[   38.511942] hermes_dld: AUX disable returned 0
[   38.522588] eth1: Program end returned 0
[   38.522598] eth1: hermes_present returned 1
[   38.523547] eth1: Hardware identity 0005:0002:0001:0002
[   38.523672] eth1: Station identity  001f:0002:0009:0030
[   38.523683] eth1: Firmware determined as Lucent/Agere 9.48
[   38.523692] eth1: Ad-hoc demo mode supported
[   38.523699] eth1: IEEE standard IBSS ad-hoc mode supported
[   38.523707] eth1: WEP supported, 104-bit key
[   38.523715] eth1: WPA-PSK supported
[   38.999361] eth1: MAC address 00:02:2d:26:95:6c
[   38.999477] eth1: Station name "HERMES I"
[   39.000304] eth1: ready
[   39.001172] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[   39.395039] Toshiba System Management Mode driver v1.11 26/9/2001
[   39.483467] Non-volatile memory driver v1.2
[   41.087684] device-mapper: uevent: version 1.0.3
[   41.089609] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)=20
initialised: dm-devel@redhat.com
[   41.398277] device-mapper: multipath: version 1.0.5 loaded
[   41.827636] device-mapper: multipath round-robin: version 1.0.0=20
loaded
[   41.828841] device-mapper: table: 254:0: multipath: error getting=20
device
[   41.828861] device-mapper: ioctl: error adding target to table
[   47.232045] loop: module loaded
[   50.511159] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k
[   54.189125] IrCOMM protocol (Dag Brattli)
[   56.119655] PPP generic driver version 2.4.2
[   63.343791] NET: Registered protocol family 17
[   63.743478] eth1: Lucent/Agere firmware doesn't support manual=20
roaming
[   63.891013] eth1: New link status: Connected (0001)
[ 1124.531915] PM: Syncing filesystems ... done.
[ 1124.584822] Freezing user space processes ... (elapsed 0.01 seconds)=20
done.
[ 1124.596410] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[ 1124.597320] Suspending console(s) (use no_console_suspend to debug)
[ 1124.608047] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1125.186209] sd 0:0:0:0: [sda] Stopping disk
[ 1125.860441] e100 0000:00:0a.0: PCI INT A disabled
[ 1125.917055] ALI 5451 0000:00:06.0: PCI INT A disabled
[ 1125.930491] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[ 1126.714456] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 1126.726970] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 1126.743622] ACPI: Preparing to enter system sleep state S3
[ 1126.743622] Back to C!
[ 1126.755217] ACPI: Waking up from system sleep state S3
[ 1126.775583] pci 0000:00:01.0: setting latency timer to 64
[ 1126.786710] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[ 1126.786752] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[ 1126.842015] usb usb1: root hub lost power or was reset
[ 1126.853399] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[ 1126.853450] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 1126.861881] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 1126.861918] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[ 1126.862154] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 1126.862192] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[ 1127.133613] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[ 1127.146687] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[ 1127.146750] e100 0000:00:0a.0: restoring config space at offset 0x1=20
(was 0x2900003, writing 0x2900007)
[ 1127.173771] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[ 1127.267146] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 1127.267157] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[ 1127.268040] ata2.00: configured for UDMA/33
[ 1128.156705] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[ 1128.156823] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[ 1128.162021] sd 0:0:0:0: [sda] Starting disk
[ 1128.460404] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 1128.460415] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[ 1128.474048] ata1.00: configured for UDMA/33
[ 1128.500031] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[ 1128.500206] sd 0:0:0:0: [sda] Write Protect is off
[ 1128.500214] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1128.500406] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[ 1128.753857] eth1: Attempting to download firmware agere_sta_fw.bin
[ 1128.753890] hermes_dld: AUX enable returned 0
[ 1128.754922] hermes_dld: AUX disable returned 0
[ 1128.754929] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 1128.754935] eth1: Read PDA returned 0
[ 1128.837110] hermes_dld: AUX enable returned 0
[ 1128.837117] hermes_dld: Enabling volatile, EP 0x000f8000
[ 1128.838218] hermes_dld: PROGRAM_ENABLE returned 0
[ 1128.838224] eth1: Program init returned 0
[ 1128.838232] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 1128.886427] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 1128.889710] eth1: Program returned 0
[ 1128.889719] hermes_dld: Found record 0x0003 at d99f201c
[ 1128.889739] hermes_dld: Found record 0x0005 at d99f20a8
[ 1128.889757] hermes_dld: Found record 0x0008 at d99f20d2
[ 1128.889772] hermes_dld: Found record 0x0007 at d99f20c4
[ 1128.889788] hermes_dld: Found record 0x0006 at d99f20b6
[ 1128.889805] hermes_dld: Found record 0x0110 at d99f219a
[ 1128.889837] hermes_dld: Found record 0x0120 at d99f21ba
[ 1128.889868] hermes_dld: Found record 0x0130 at d99f21da
[ 1128.889945] hermes_dld: Found record 0x0140 at d99f21fa
[ 1128.889958] hermes_dld: Found record 0x0150 at d99f2202
[ 1128.889970] hermes_dld: Using default record 0x0160 at dfa9fb60
[ 1128.890001] hermes_dld: Found record 0x0101 at d99f2146
[ 1128.890015] hermes_dld: Found record 0x0103 at d99f215c
[ 1128.890033] hermes_dld: Found record 0x0104 at d99f216c
[ 1128.890044] hermes_dld: Found record 0x0105 at d99f2172
[ 1128.890055] hermes_dld: Found record 0x0105 at d99f2172
[ 1128.890065] hermes_dld: Found record 0x0105 at d99f2172
[ 1128.890076] hermes_dld: Found record 0x0107 at d99f217e
[ 1128.890087] hermes_dld: Found record 0x0109 at d99f218c
[ 1128.890104] hermes_dld: Using default record 0x0161 at dfa9fb80
[ 1128.890318] eth1: Apply PDA returned 0
[ 1128.890381] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[ 1128.890408] hermes_dld: AUX disable returned 0
[ 1128.901046] eth1: Program end returned 0
[ 1128.901054] eth1: hermes_present returned 1
[ 1128.913457] Restarting tasks ... done.
[ 1129.179103] eth1: New link status: Connected (0001)
[ 1410.335391] zsh[6088]: segfault at 3353316 ip b7d044b2 sp bfbb9020=20
error 4 in complist.so[b7cff000+d000]
[ 2584.718922] zsh[7111]: segfault at 3000158 ip b7ceb4b2 sp bfea0b10=20
error 4 in complist.so[b7ce6000+d000]
[ 2818.120380] PM: Syncing filesystems ... done.
[ 2818.138487] Freezing user space processes ... (elapsed 0.54 seconds)=20
done.
[ 2818.678805] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[ 2818.679633] Suspending console(s) (use no_console_suspend to debug)
[ 2818.687643] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 2818.689986] sd 0:0:0:0: [sda] Stopping disk
[ 2819.406805] ALI 5451 0000:00:06.0: PCI INT A disabled
[ 2819.420237] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[ 2820.194260] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 2820.206647] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 2820.222739] ACPI: Preparing to enter system sleep state S3
[ 2820.223138] Back to C!
[ 2820.234368] ACPI: Waking up from system sleep state S3
[ 2820.253540] pci 0000:00:01.0: setting latency timer to 64
[ 2820.266538] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[ 2820.266579] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[ 2820.321845] usb usb1: root hub lost power or was reset
[ 2820.333229] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[ 2820.333280] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 2820.339592] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 2820.339627] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[ 2820.339925] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 2820.339962] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[ 2820.609976] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[ 2820.623183] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[ 2820.650560] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 2820.650574] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[ 2820.651451] ata2.00: configured for UDMA/33
[ 2820.652178] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[ 2821.633199] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[ 2821.633316] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[ 2821.638417] sd 0:0:0:0: [sda] Starting disk
[ 2822.273575] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 2822.273586] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[ 2822.287200] ata1.00: configured for UDMA/33
[ 2822.314324] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[ 2822.314450] sd 0:0:0:0: [sda] Write Protect is off
[ 2822.314458] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 2822.314649] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[ 2822.566743] eth1: Attempting to download firmware agere_sta_fw.bin
[ 2822.566774] hermes_dld: AUX enable returned 0
[ 2822.567806] hermes_dld: AUX disable returned 0
[ 2822.567813] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 2822.567819] eth1: Read PDA returned 0
[ 2822.649994] hermes_dld: AUX enable returned 0
[ 2822.650001] hermes_dld: Enabling volatile, EP 0x000f8000
[ 2822.651102] hermes_dld: PROGRAM_ENABLE returned 0
[ 2822.651107] eth1: Program init returned 0
[ 2822.651116] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 2822.699311] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 2822.702594] eth1: Program returned 0
[ 2822.702602] hermes_dld: Found record 0x0003 at cbee881c
[ 2822.702623] hermes_dld: Found record 0x0005 at cbee88a8
[ 2822.702640] hermes_dld: Found record 0x0008 at cbee88d2
[ 2822.702656] hermes_dld: Found record 0x0007 at cbee88c4
[ 2822.702672] hermes_dld: Found record 0x0006 at cbee88b6
[ 2822.702690] hermes_dld: Found record 0x0110 at cbee899a
[ 2822.702721] hermes_dld: Found record 0x0120 at cbee89ba
[ 2822.702752] hermes_dld: Found record 0x0130 at cbee89da
[ 2822.702783] hermes_dld: Found record 0x0140 at cbee89fa
[ 2822.702796] hermes_dld: Found record 0x0150 at cbee8a02
[ 2822.702807] hermes_dld: Using default record 0x0160 at dfa9fb60
[ 2822.702838] hermes_dld: Found record 0x0101 at cbee8946
[ 2822.702852] hermes_dld: Found record 0x0103 at cbee895c
[ 2822.702871] hermes_dld: Found record 0x0104 at cbee896c
[ 2822.702881] hermes_dld: Found record 0x0105 at cbee8972
[ 2822.702892] hermes_dld: Found record 0x0105 at cbee8972
[ 2822.702903] hermes_dld: Found record 0x0105 at cbee8972
[ 2822.702913] hermes_dld: Found record 0x0107 at cbee897e
[ 2822.702924] hermes_dld: Found record 0x0109 at cbee898c
[ 2822.702941] hermes_dld: Using default record 0x0161 at dfa9fb80
[ 2822.703202] eth1: Apply PDA returned 0
[ 2822.703265] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[ 2822.703292] hermes_dld: AUX disable returned 0
[ 2822.713933] eth1: Program end returned 0
[ 2822.713941] eth1: hermes_present returned 1
[ 2822.726171] Restarting tasks ... done.
[ 2822.952127] eth1: New link status: Connected (0001)
[ 3922.281122] PM: Syncing filesystems ... done.
[ 3922.288532] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[ 3922.296478] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[ 3922.297296] Suspending console(s) (use no_console_suspend to debug)
[ 3922.305315] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3922.789836] sd 0:0:0:0: [sda] Stopping disk
[ 3923.523361] ALI 5451 0000:00:06.0: PCI INT A disabled
[ 3923.536805] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[ 3924.297421] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 3924.309857] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 3924.325918] ACPI: Preparing to enter system sleep state S3
[ 3924.326360] Back to C!
[ 3924.338587] ACPI: Waking up from system sleep state S3
[ 3924.358998] pci 0000:00:01.0: setting latency timer to 64
[ 3924.369751] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[ 3924.369793] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[ 3924.425055] usb usb1: root hub lost power or was reset
[ 3924.436439] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[ 3924.436489] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 3924.443316] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 3924.443351] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[ 3924.443414] ALI 5451 0000:00:06.0: restoring config space at offset=20
0x1 (was 0x2900003, writing 0xc2900003)
[ 3924.443786] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 3924.443821] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[ 3924.723197] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[ 3924.736391] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[ 3924.763349] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[ 3925.020839] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 3925.020849] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[ 3925.022172] ata2.00: configured for UDMA/33
[ 3925.746447] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[ 3925.746565] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[ 3925.751712] sd 0:0:0:0: [sda] Starting disk
[ 3926.696792] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 3926.696803] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[ 3926.710420] ata1.00: configured for UDMA/33
[ 3926.724736] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[ 3926.724863] sd 0:0:0:0: [sda] Write Protect is off
[ 3926.724872] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 3926.725062] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[ 3926.976608] eth1: Attempting to download firmware agere_sta_fw.bin
[ 3926.976641] hermes_dld: AUX enable returned 0
[ 3926.977672] hermes_dld: AUX disable returned 0
[ 3926.977679] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 3926.977685] eth1: Read PDA returned 0
[ 3927.059862] hermes_dld: AUX enable returned 0
[ 3927.059869] hermes_dld: Enabling volatile, EP 0x000f8000
[ 3927.060970] hermes_dld: PROGRAM_ENABLE returned 0
[ 3927.060976] eth1: Program init returned 0
[ 3927.060984] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 3927.109129] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 3927.112404] eth1: Program returned 0
[ 3927.112413] hermes_dld: Found record 0x0003 at ca3be01c
[ 3927.112433] hermes_dld: Found record 0x0005 at ca3be0a8
[ 3927.112450] hermes_dld: Found record 0x0008 at ca3be0d2
[ 3927.112465] hermes_dld: Found record 0x0007 at ca3be0c4
[ 3927.112482] hermes_dld: Found record 0x0006 at ca3be0b6
[ 3927.112500] hermes_dld: Found record 0x0110 at ca3be19a
[ 3927.112531] hermes_dld: Found record 0x0120 at ca3be1ba
[ 3927.112563] hermes_dld: Found record 0x0130 at ca3be1da
[ 3927.112593] hermes_dld: Found record 0x0140 at ca3be1fa
[ 3927.112606] hermes_dld: Found record 0x0150 at ca3be202
[ 3927.112617] hermes_dld: Using default record 0x0160 at dfa9fb60
[ 3927.112648] hermes_dld: Found record 0x0101 at ca3be146
[ 3927.112662] hermes_dld: Found record 0x0103 at ca3be15c
[ 3927.112680] hermes_dld: Found record 0x0104 at ca3be16c
[ 3927.112691] hermes_dld: Found record 0x0105 at ca3be172
[ 3927.112701] hermes_dld: Found record 0x0105 at ca3be172
[ 3927.112712] hermes_dld: Found record 0x0105 at ca3be172
[ 3927.112723] hermes_dld: Found record 0x0107 at ca3be17e
[ 3927.112733] hermes_dld: Found record 0x0109 at ca3be18c
[ 3927.112750] hermes_dld: Using default record 0x0161 at dfa9fb80
[ 3927.113013] eth1: Apply PDA returned 0
[ 3927.113076] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[ 3927.113103] hermes_dld: AUX disable returned 0
[ 3927.123742] eth1: Program end returned 0
[ 3927.123749] eth1: hermes_present returned 1
[ 3927.135992] Restarting tasks ... done.
[ 3927.380416] eth1: New link status: Connected (0001)
[14658.177775] eth1: New link status: AP Out of Range (0004)
[14687.306825] PM: Syncing filesystems ... done.
[14687.336326] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[14687.345126] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[14687.346053] Suspending console(s) (use no_console_suspend to debug)
[14687.353309] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[14687.775706] sd 0:0:0:0: [sda] Stopping disk
[14688.508949] ALI 5451 0000:00:06.0: PCI INT A disabled
[14688.522417] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[14689.300140] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[14689.312128] ohci_hcd 0000:00:02.0: PCI INT A disabled
[14689.328226] ACPI: Preparing to enter system sleep state S3
[14689.328617] Back to C!
[14689.340917] ACPI: Waking up from system sleep state S3
[14689.361710] pci 0000:00:01.0: setting latency timer to 64
[14689.371970] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[14689.372012] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[14689.427324] usb usb1: root hub lost power or was reset
[14689.438709] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[14689.438759] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[14689.445597] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[14689.445632] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[14689.445695] ALI 5451 0000:00:06.0: restoring config space at offset=20
0x1 (was 0x2900003, writing 0xc2900003)
[14689.445882] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[14689.446099] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[14689.725460] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[14689.738663] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[14689.765601] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[14690.022650] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[14690.022660] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[14690.023527] ata2.00: configured for UDMA/33
[14690.748676] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[14690.748792] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[14690.753888] sd 0:0:0:0: [sda] Starting disk
[14691.682376] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[14691.682388] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[14691.696011] ata1.00: configured for UDMA/33
[14691.720021] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[14691.720147] sd 0:0:0:0: [sda] Write Protect is off
[14691.720156] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[14691.720347] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[14691.972213] eth1: Attempting to download firmware agere_sta_fw.bin
[14691.972245] hermes_dld: AUX enable returned 0
[14691.973276] hermes_dld: AUX disable returned 0
[14691.973283] hermes_dld: Actual PDA length 998, Max allowed 1000
[14691.973289] eth1: Read PDA returned 0
[14692.055452] hermes_dld: AUX enable returned 0
[14692.055458] hermes_dld: Enabling volatile, EP 0x000f8000
[14692.056582] hermes_dld: PROGRAM_ENABLE returned 0
[14692.056588] eth1: Program init returned 0
[14692.056596] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[14692.104771] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[14692.108047] eth1: Program returned 0
[14692.108055] hermes_dld: Found record 0x0003 at dddfa01c
[14692.108074] hermes_dld: Found record 0x0005 at dddfa0a8
[14692.108092] hermes_dld: Found record 0x0008 at dddfa0d2
[14692.108107] hermes_dld: Found record 0x0007 at dddfa0c4
[14692.108124] hermes_dld: Found record 0x0006 at dddfa0b6
[14692.108141] hermes_dld: Found record 0x0110 at dddfa19a
[14692.108173] hermes_dld: Found record 0x0120 at dddfa1ba
[14692.108204] hermes_dld: Found record 0x0130 at dddfa1da
[14692.108235] hermes_dld: Found record 0x0140 at dddfa1fa
[14692.108247] hermes_dld: Found record 0x0150 at dddfa202
[14692.108258] hermes_dld: Using default record 0x0160 at dfa9fb60
[14692.108289] hermes_dld: Found record 0x0101 at dddfa146
[14692.108303] hermes_dld: Found record 0x0103 at dddfa15c
[14692.108321] hermes_dld: Found record 0x0104 at dddfa16c
[14692.108332] hermes_dld: Found record 0x0105 at dddfa172
[14692.108342] hermes_dld: Found record 0x0105 at dddfa172
[14692.108353] hermes_dld: Found record 0x0105 at dddfa172
[14692.108364] hermes_dld: Found record 0x0107 at dddfa17e
[14692.108374] hermes_dld: Found record 0x0109 at dddfa18c
[14692.108392] hermes_dld: Using default record 0x0161 at dfa9fb80
[14692.108651] eth1: Apply PDA returned 0
[14692.108715] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[14692.108742] hermes_dld: AUX disable returned 0
[14692.119378] eth1: Program end returned 0
[14692.119385] eth1: hermes_present returned 1
[14692.131360] Restarting tasks ... done.
[14692.265714] eth1: New link status: Connected (0001)
[17674.569165] PM: Syncing filesystems ... done.
[17675.149435] Freezing user space processes ... (elapsed 0.03 seconds)=20
done.
[17675.183176] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[17675.183998] Suspending console(s) (use no_console_suspend to debug)
[17675.192153] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[17675.222450] sd 0:0:0:0: [sda] Stopping disk
[17675.951985] ALI 5451 0000:00:06.0: PCI INT A disabled
[17675.965546] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[17676.718099] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[17676.728489] ohci_hcd 0000:00:02.0: PCI INT A disabled
[17676.744605] ACPI: Preparing to enter system sleep state S3
[17676.744984] Back to C!
[17676.757208] ACPI: Waking up from system sleep state S3
[17676.777962] pci 0000:00:01.0: setting latency timer to 64
[17676.788392] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[17676.788434] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[17676.843930] usb usb1: root hub lost power or was reset
[17676.855287] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[17676.855337] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[17676.863351] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[17676.863388] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[17676.863626] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[17676.863661] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[17677.115161] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[17677.128340] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[17677.158653] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[17677.439011] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[17677.439020] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[17677.445576] ata2.00: configured for UDMA/33
[17678.141728] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[17678.141845] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[17678.146944] sd 0:0:0:0: [sda] Starting disk
[17679.225417] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[17679.225428] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[17679.239043] ata1.00: configured for UDMA/33
[17679.266426] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[17679.266552] sd 0:0:0:0: [sda] Write Protect is off
[17679.266561] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17679.266751] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[17679.518587] eth1: Attempting to download firmware agere_sta_fw.bin
[17679.518618] hermes_dld: AUX enable returned 0
[17679.519646] hermes_dld: AUX disable returned 0
[17679.519653] hermes_dld: Actual PDA length 998, Max allowed 1000
[17679.519659] eth1: Read PDA returned 0
[17679.601830] hermes_dld: AUX enable returned 0
[17679.601836] hermes_dld: Enabling volatile, EP 0x000f8000
[17679.602936] hermes_dld: PROGRAM_ENABLE returned 0
[17679.602942] eth1: Program init returned 0
[17679.602951] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[17679.651091] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[17679.654374] eth1: Program returned 0
[17679.654382] hermes_dld: Found record 0x0003 at d99f2c1c
[17679.654402] hermes_dld: Found record 0x0005 at d99f2ca8
[17679.654419] hermes_dld: Found record 0x0008 at d99f2cd2
[17679.654435] hermes_dld: Found record 0x0007 at d99f2cc4
[17679.654452] hermes_dld: Found record 0x0006 at d99f2cb6
[17679.654469] hermes_dld: Found record 0x0110 at d99f2d9a
[17679.654501] hermes_dld: Found record 0x0120 at d99f2dba
[17679.654532] hermes_dld: Found record 0x0130 at d99f2dda
[17679.654563] hermes_dld: Found record 0x0140 at d99f2dfa
[17679.654575] hermes_dld: Found record 0x0150 at d99f2e02
[17679.654587] hermes_dld: Using default record 0x0160 at dfa9fb60
[17679.654618] hermes_dld: Found record 0x0101 at d99f2d46
[17679.654632] hermes_dld: Found record 0x0103 at d99f2d5c
[17679.654650] hermes_dld: Found record 0x0104 at d99f2d6c
[17679.654661] hermes_dld: Found record 0x0105 at d99f2d72
[17679.654672] hermes_dld: Found record 0x0105 at d99f2d72
[17679.654683] hermes_dld: Found record 0x0105 at d99f2d72
[17679.654693] hermes_dld: Found record 0x0107 at d99f2d7e
[17679.654704] hermes_dld: Found record 0x0109 at d99f2d8c
[17679.654721] hermes_dld: Using default record 0x0161 at dfa9fb80
[17679.654981] eth1: Apply PDA returned 0
[17679.655044] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[17679.655071] hermes_dld: AUX disable returned 0
[17679.665715] eth1: Program end returned 0
[17679.665723] eth1: hermes_present returned 1
[17679.677956] Restarting tasks ... done.
[17679.897126] eth1: New link status: Connected (0001)
[23463.268139] tun: Universal TUN/TAP device driver, 1.6
[23463.268163] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[28673.063444] PM: Syncing filesystems ... done.
[28673.122228] Freezing user space processes ... (elapsed 0.59 seconds)=20
done.
[28673.715381] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[28673.716179] Suspending console(s) (use no_console_suspend to debug)
[28673.724183] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[28673.724668] sd 0:0:0:0: [sda] Stopping disk
[28674.457550] ALI 5451 0000:00:06.0: PCI INT A disabled
[28674.471109] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[28675.234279] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[28675.247383] ohci_hcd 0000:00:02.0: PCI INT A disabled
[28675.263491] ACPI: Preparing to enter system sleep state S3
[28675.263886] Back to C!
[28675.276179] ACPI: Waking up from system sleep state S3
[28675.296494] pci 0000:00:01.0: setting latency timer to 64
[28675.307291] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[28675.307333] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[28675.362591] usb usb1: root hub lost power or was reset
[28675.373976] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[28675.374029] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[28675.380930] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[28675.380966] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[28675.381384] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[28675.381420] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[28675.677389] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[28675.690596] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[28675.717575] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[28675.957911] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[28675.957921] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[28675.964486] ata2.00: configured for UDMA/33
[28676.700612] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[28676.700728] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[28676.705828] sd 0:0:0:0: [sda] Starting disk
[28677.687651] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[28677.687662] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[28677.701279] ata1.00: configured for UDMA/33
[28677.727306] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[28677.727431] sd 0:0:0:0: [sda] Write Protect is off
[28677.727440] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[28677.727631] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[28677.980801] eth1: Attempting to download firmware agere_sta_fw.bin
[28677.980834] hermes_dld: AUX enable returned 0
[28677.981864] hermes_dld: AUX disable returned 0
[28677.981871] hermes_dld: Actual PDA length 998, Max allowed 1000
[28677.981877] eth1: Read PDA returned 0
[28678.064041] hermes_dld: AUX enable returned 0
[28678.064048] hermes_dld: Enabling volatile, EP 0x000f8000
[28678.065160] hermes_dld: PROGRAM_ENABLE returned 0
[28678.065166] eth1: Program init returned 0
[28678.065175] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[28678.113299] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[28678.116577] eth1: Program returned 0
[28678.116585] hermes_dld: Found record 0x0003 at cfa9641c
[28678.116605] hermes_dld: Found record 0x0005 at cfa964a8
[28678.116623] hermes_dld: Found record 0x0008 at cfa964d2
[28678.116638] hermes_dld: Found record 0x0007 at cfa964c4
[28678.116655] hermes_dld: Found record 0x0006 at cfa964b6
[28678.116672] hermes_dld: Found record 0x0110 at cfa9659a
[28678.116703] hermes_dld: Found record 0x0120 at cfa965ba
[28678.116735] hermes_dld: Found record 0x0130 at cfa965da
[28678.116765] hermes_dld: Found record 0x0140 at cfa965fa
[28678.116777] hermes_dld: Found record 0x0150 at cfa96602
[28678.116789] hermes_dld: Using default record 0x0160 at dfa9fb60
[28678.116821] hermes_dld: Found record 0x0101 at cfa96546
[28678.116834] hermes_dld: Found record 0x0103 at cfa9655c
[28678.116853] hermes_dld: Found record 0x0104 at cfa9656c
[28678.116863] hermes_dld: Found record 0x0105 at cfa96572
[28678.116874] hermes_dld: Found record 0x0105 at cfa96572
[28678.116885] hermes_dld: Found record 0x0105 at cfa96572
[28678.116895] hermes_dld: Found record 0x0107 at cfa9657e
[28678.116906] hermes_dld: Found record 0x0109 at cfa9658c
[28678.116923] hermes_dld: Using default record 0x0161 at dfa9fb80
[28678.117137] eth1: Apply PDA returned 0
[28678.117246] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[28678.117273] hermes_dld: AUX disable returned 0
[28678.127909] eth1: Program end returned 0
[28678.127917] eth1: hermes_present returned 1
[28678.140167] Restarting tasks ... done.
[28678.467622] eth1: New link status: Connected (0001)
[32837.809043] kwrited[31962]: segfault at 9079a1cd ip b75e5539 sp=20
bfe2e184 error 4 in libc-2.8.so[b757a000+148000]
[42226.314859] PM: Syncing filesystems ... done.
[42226.970260] Freezing user space processes ... (elapsed 0.12 seconds)=20
done.
[42227.090613] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[42227.091403] Suspending console(s) (use no_console_suspend to debug)
[42227.099461] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[42227.099955] sd 0:0:0:0: [sda] Stopping disk
[42227.829531] ALI 5451 0000:00:06.0: PCI INT A disabled
[42227.842974] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[42228.613957] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[42228.626038] ohci_hcd 0000:00:02.0: PCI INT A disabled
[42228.642133] ACPI: Preparing to enter system sleep state S3
[42228.642530] Back to C!
[42228.654825] ACPI: Waking up from system sleep state S3
[42228.675211] pci 0000:00:01.0: setting latency timer to 64
[42228.685937] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[42228.685978] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[42228.741237] usb usb1: root hub lost power or was reset
[42228.752621] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[42228.752671] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[42228.759516] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[42228.759552] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[42228.759787] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[42228.759822] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[42229.042701] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[42229.055909] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[42229.082886] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[42229.336614] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[42229.336625] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[42229.343177] ata2.00: configured for UDMA/33
[42230.065955] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[42230.066071] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[42230.071166] sd 0:0:0:0: [sda] Starting disk
[42231.012969] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[42231.012980] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[42231.026590] ata1.00: configured for UDMA/33
[42231.044328] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[42231.044456] sd 0:0:0:0: [sda] Write Protect is off
[42231.044464] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[42231.044655] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[42231.296124] eth1: Attempting to download firmware agere_sta_fw.bin
[42231.296156] hermes_dld: AUX enable returned 0
[42231.297186] hermes_dld: AUX disable returned 0
[42231.297193] hermes_dld: Actual PDA length 998, Max allowed 1000
[42231.297199] eth1: Read PDA returned 0
[42231.379375] hermes_dld: AUX enable returned 0
[42231.379382] hermes_dld: Enabling volatile, EP 0x000f8000
[42231.380482] hermes_dld: PROGRAM_ENABLE returned 0
[42231.380488] eth1: Program init returned 0
[42231.380496] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[42231.428642] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[42231.431920] eth1: Program returned 0
[42231.431928] hermes_dld: Found record 0x0003 at cbc7041c
[42231.431948] hermes_dld: Found record 0x0005 at cbc704a8
[42231.431966] hermes_dld: Found record 0x0008 at cbc704d2
[42231.431981] hermes_dld: Found record 0x0007 at cbc704c4
[42231.431997] hermes_dld: Found record 0x0006 at cbc704b6
[42231.432014] hermes_dld: Found record 0x0110 at cbc7059a
[42231.432046] hermes_dld: Found record 0x0120 at cbc705ba
[42231.432077] hermes_dld: Found record 0x0130 at cbc705da
[42231.432108] hermes_dld: Found record 0x0140 at cbc705fa
[42231.432120] hermes_dld: Found record 0x0150 at cbc70602
[42231.432131] hermes_dld: Using default record 0x0160 at dfa9fb60
[42231.432163] hermes_dld: Found record 0x0101 at cbc70546
[42231.432176] hermes_dld: Found record 0x0103 at cbc7055c
[42231.432195] hermes_dld: Found record 0x0104 at cbc7056c
[42231.432206] hermes_dld: Found record 0x0105 at cbc70572
[42231.432217] hermes_dld: Found record 0x0105 at cbc70572
[42231.432227] hermes_dld: Found record 0x0105 at cbc70572
[42231.432238] hermes_dld: Found record 0x0107 at cbc7057e
[42231.432249] hermes_dld: Found record 0x0109 at cbc7058c
[42231.432266] hermes_dld: Using default record 0x0161 at dfa9fb80
[42231.432532] eth1: Apply PDA returned 0
[42231.432595] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[42231.432622] hermes_dld: AUX disable returned 0
[42231.443265] eth1: Program end returned 0
[42231.443273] eth1: hermes_present returned 1
[42231.455482] Restarting tasks ... done.
[42231.739962] eth1: New link status: Connected (0001)
[43838.005824] usb 1-1: new full speed USB device using ohci_hcd and=20
address 2
[43838.299361] usb 1-1: configuration #1 chosen from 1 choice
[43839.316425] Bluetooth: Core ver 2.13
[43839.317891] NET: Registered protocol family 31
[43839.317927] Bluetooth: HCI device and connection manager initialized
[43839.318946] Bluetooth: HCI socket layer initialized
[43841.252502] Bluetooth: HCI USB driver ver 2.10
[43841.255374] usbcore: registered new interface driver hci_usb
[43844.226748] Bluetooth: L2CAP ver 2.11
[43844.226810] Bluetooth: L2CAP socket layer initialized
[43844.539415] Bluetooth: RFCOMM socket layer initialized
[43844.539546] Bluetooth: RFCOMM TTY layer initialized
[43844.539562] Bluetooth: RFCOMM ver 1.10
[43844.890198] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[43845.185333] bluetoothd[5461]: segfault at 38 ip 00000038 sp bfb916bc=20
error 4 in input.so[b7c79000+7000]
[44453.767544] usb 1-1: USB disconnect, address 2
[47820.858067] eth1: New link status: AP Out of Range (0004)
[47947.959938] eth1: Lucent/Agere firmware doesn't support manual=20
roaming
[47949.575958] eth1: New link status: Connected (0001)
[47957.710193] eth1: New link status: Disconnected (0002)
[47958.955481] eth1: New link status: Connected (0001)
[47966.988901] eth1: New link status: Disconnected (0002)
[47968.165254] eth1: New link status: Connected (0001)
[47976.178863] eth1: New link status: Disconnected (0002)
[47977.404271] eth1: New link status: Connected (0001)
[47985.468705] eth1: New link status: Disconnected (0002)
[47986.767998] eth1: New link status: Connected (0001)
[47994.778591] eth1: New link status: Disconnected (0002)
[47996.040753] eth1: New link status: Connected (0001)
[48004.098458] eth1: New link status: Disconnected (0002)
[48005.497074] eth1: New link status: Connected (0001)
[48013.528366] eth1: New link status: Disconnected (0002)
[48014.838936] eth1: New link status: Connected (0001)
[48022.888089] eth1: New link status: Disconnected (0002)
[48024.048153] eth1: New link status: Connected (0001)
[48032.077956] eth1: New link status: Disconnected (0002)
[48033.250517] eth1: New link status: Connected (0001)
[50297.545609] PM: Syncing filesystems ... done.
[50297.646233] Freezing user space processes ... (elapsed 0.03 seconds)=20
done.
[50297.681212] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[50297.682121] Suspending console(s) (use no_console_suspend to debug)
[50297.690173] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[50298.123778] sd 0:0:0:0: [sda] Stopping disk
[50298.862053] ALI 5451 0000:00:06.0: PCI INT A disabled
[50298.875490] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[50299.651050] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[50299.661889] ohci_hcd 0000:00:02.0: PCI INT A disabled
[50299.677907] ACPI: Preparing to enter system sleep state S3
[50299.678389] Back to C!
[50299.690896] ACPI: Waking up from system sleep state S3
[50299.711209] pci 0000:00:01.0: setting latency timer to 64
[50299.722014] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[50299.722055] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[50299.777085] usb usb1: root hub lost power or was reset
[50299.788467] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[50299.788519] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[50299.796891] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[50299.796926] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[50299.797163] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[50299.797199] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[50300.088562] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[50300.101754] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[50300.128732] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[50300.372407] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[50300.372417] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[50300.373281] ata2.00: configured for UDMA/33
[50301.111769] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[50301.111884] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[50301.117033] sd 0:0:0:0: [sda] Starting disk
[50302.052153] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[50302.052163] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[50302.065782] ata1.00: configured for UDMA/33
[50302.092891] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[50302.093016] sd 0:0:0:0: [sda] Write Protect is off
[50302.093025] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[50302.093214] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[50302.345304] eth1: Attempting to download firmware agere_sta_fw.bin
[50302.345337] hermes_dld: AUX enable returned 0
[50302.346366] hermes_dld: AUX disable returned 0
[50302.346373] hermes_dld: Actual PDA length 998, Max allowed 1000
[50302.346379] eth1: Read PDA returned 0
[50302.428546] hermes_dld: AUX enable returned 0
[50302.428552] hermes_dld: Enabling volatile, EP 0x000f8000
[50302.429664] hermes_dld: PROGRAM_ENABLE returned 0
[50302.429670] eth1: Program init returned 0
[50302.429678] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[50302.477826] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[50302.481103] eth1: Program returned 0
[50302.481111] hermes_dld: Found record 0x0003 at d9a9e81c
[50302.481130] hermes_dld: Found record 0x0005 at d9a9e8a8
[50302.481148] hermes_dld: Found record 0x0008 at d9a9e8d2
[50302.481163] hermes_dld: Found record 0x0007 at d9a9e8c4
[50302.481180] hermes_dld: Found record 0x0006 at d9a9e8b6
[50302.481197] hermes_dld: Found record 0x0110 at d9a9e99a
[50302.481228] hermes_dld: Found record 0x0120 at d9a9e9ba
[50302.481259] hermes_dld: Found record 0x0130 at d9a9e9da
[50302.481290] hermes_dld: Found record 0x0140 at d9a9e9fa
[50302.481302] hermes_dld: Found record 0x0150 at d9a9ea02
[50302.481314] hermes_dld: Using default record 0x0160 at dfa9fb60
[50302.481345] hermes_dld: Found record 0x0101 at d9a9e946
[50302.481358] hermes_dld: Found record 0x0103 at d9a9e95c
[50302.481377] hermes_dld: Found record 0x0104 at d9a9e96c
[50302.481388] hermes_dld: Found record 0x0105 at d9a9e972
[50302.481398] hermes_dld: Found record 0x0105 at d9a9e972
[50302.481409] hermes_dld: Found record 0x0105 at d9a9e972
[50302.481420] hermes_dld: Found record 0x0107 at d9a9e97e
[50302.481430] hermes_dld: Found record 0x0109 at d9a9e98c
[50302.481447] hermes_dld: Using default record 0x0161 at dfa9fb80
[50302.481707] eth1: Apply PDA returned 0
[50302.481771] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[50302.481798] hermes_dld: AUX disable returned 0
[50302.492437] eth1: Program end returned 0
[50302.492445] eth1: hermes_present returned 1
[50302.505933] Restarting tasks ... done.
[50302.762852] eth1: New link status: Connected (0001)
[50804.575989] PM: Syncing filesystems ... done.
[50805.172257] Freezing user space processes ... (elapsed 0.03 seconds)=20
done.
[50805.205561] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[50805.206384] Suspending console(s) (use no_console_suspend to debug)
[50805.214344] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[50805.242849] sd 0:0:0:0: [sda] Stopping disk
[50805.958673] ALI 5451 0000:00:06.0: PCI INT A disabled
[50805.972116] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[50806.727296] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[50806.738516] ohci_hcd 0000:00:02.0: PCI INT A disabled
[50806.754618] ACPI: Preparing to enter system sleep state S3
[50806.755007] Back to C!
[50806.767381] ACPI: Waking up from system sleep state S3
[50806.790509] pci 0000:00:01.0: setting latency timer to 64
[50806.801743] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[50806.801784] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[50806.857370] usb usb1: root hub lost power or was reset
[50806.868640] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[50806.868689] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[50806.876988] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[50806.877025] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[50806.877262] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[50806.877297] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[50807.161848] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[50807.175051] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[50807.202006] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[50807.452350] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[50807.452360] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[50807.453221] ata2.00: configured for UDMA/33
[50808.185062] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[50808.185177] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[50808.190275] sd 0:0:0:0: [sda] Starting disk
[50809.115422] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[50809.115434] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[50809.129101] ata1.00: configured for UDMA/33
[50809.153909] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[50809.154036] sd 0:0:0:0: [sda] Write Protect is off
[50809.154045] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[50809.154234] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[50809.405266] eth1: Attempting to download firmware agere_sta_fw.bin
[50809.405299] hermes_dld: AUX enable returned 0
[50809.406328] hermes_dld: AUX disable returned 0
[50809.406334] hermes_dld: Actual PDA length 998, Max allowed 1000
[50809.406341] eth1: Read PDA returned 0
[50809.488505] hermes_dld: AUX enable returned 0
[50809.488512] hermes_dld: Enabling volatile, EP 0x000f8000
[50809.489624] hermes_dld: PROGRAM_ENABLE returned 0
[50809.489630] eth1: Program init returned 0
[50809.489639] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[50809.537788] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[50809.541065] eth1: Program returned 0
[50809.541073] hermes_dld: Found record 0x0003 at cbc2d01c
[50809.541094] hermes_dld: Found record 0x0005 at cbc2d0a8
[50809.541111] hermes_dld: Found record 0x0008 at cbc2d0d2
[50809.541126] hermes_dld: Found record 0x0007 at cbc2d0c4
[50809.541143] hermes_dld: Found record 0x0006 at cbc2d0b6
[50809.541160] hermes_dld: Found record 0x0110 at cbc2d19a
[50809.541192] hermes_dld: Found record 0x0120 at cbc2d1ba
[50809.541223] hermes_dld: Found record 0x0130 at cbc2d1da
[50809.541254] hermes_dld: Found record 0x0140 at cbc2d1fa
[50809.541266] hermes_dld: Found record 0x0150 at cbc2d202
[50809.541278] hermes_dld: Using default record 0x0160 at dfa9fb60
[50809.541309] hermes_dld: Found record 0x0101 at cbc2d146
[50809.541323] hermes_dld: Found record 0x0103 at cbc2d15c
[50809.541341] hermes_dld: Found record 0x0104 at cbc2d16c
[50809.541352] hermes_dld: Found record 0x0105 at cbc2d172
[50809.541363] hermes_dld: Found record 0x0105 at cbc2d172
[50809.541373] hermes_dld: Found record 0x0105 at cbc2d172
[50809.541384] hermes_dld: Found record 0x0107 at cbc2d17e
[50809.541395] hermes_dld: Found record 0x0109 at cbc2d18c
[50809.541412] hermes_dld: Using default record 0x0161 at dfa9fb80
[50809.541673] eth1: Apply PDA returned 0
[50809.541736] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[50809.541763] hermes_dld: AUX disable returned 0
[50809.552398] eth1: Program end returned 0
[50809.552405] eth1: hermes_present returned 1
[50809.565899] Restarting tasks ... done.
[50809.732319] eth1: New link status: Connected (0001)
[55504.827363] zsh[10848]: segfault at 91 ip b7cf94b8 sp bf9b0c70 error=20
4 in complist.so[b7cf4000+d000]
[61631.244919] PM: Syncing filesystems ... done.
[61631.861053] Freezing user space processes ... (elapsed 0.19 seconds)=20
done.
[61632.055044] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[61632.055834] Suspending console(s) (use no_console_suspend to debug)
[61632.063738] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[61632.064206] sd 0:0:0:0: [sda] Stopping disk
[61632.804255] ALI 5451 0000:00:06.0: PCI INT A disabled
[61632.817807] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[61633.571008] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[61633.584090] ohci_hcd 0000:00:02.0: PCI INT A disabled
[61633.600202] ACPI: Preparing to enter system sleep state S3
[61633.600590] Back to C!
[61633.612290] ACPI: Waking up from system sleep state S3
[61633.633469] pci 0000:00:01.0: setting latency timer to 64
[61633.643996] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[61633.644038] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[61633.699298] usb usb1: root hub lost power or was reset
[61633.710682] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[61633.710732] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[61633.719398] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[61633.719436] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[61633.719499] ALI 5451 0000:00:06.0: restoring config space at offset=20
0x1 (was 0x2900003, writing 0xc2900003)
[61633.719687] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[61633.719723] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[61634.017429] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[61634.030633] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[61634.057572] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[61634.241283] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[61634.241294] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[61634.242159] ata2.00: configured for UDMA/33
[61635.040653] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[61635.040768] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[61635.045855] sd 0:0:0:0: [sda] Starting disk
[61635.924352] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[61635.924364] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[61635.937982] ata1.00: configured for UDMA/33
[61635.953595] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[61635.953721] sd 0:0:0:0: [sda] Write Protect is off
[61635.953730] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[61635.953971] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[61636.207494] eth1: Attempting to download firmware agere_sta_fw.bin
[61636.207526] hermes_dld: AUX enable returned 0
[61636.208556] hermes_dld: AUX disable returned 0
[61636.208563] hermes_dld: Actual PDA length 998, Max allowed 1000
[61636.208570] eth1: Read PDA returned 0
[61636.290732] hermes_dld: AUX enable returned 0
[61636.290739] hermes_dld: Enabling volatile, EP 0x000f8000
[61636.291862] hermes_dld: PROGRAM_ENABLE returned 0
[61636.291868] eth1: Program init returned 0
[61636.291876] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[61636.340026] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[61636.343302] eth1: Program returned 0
[61636.343310] hermes_dld: Found record 0x0003 at d9bd301c
[61636.343330] hermes_dld: Found record 0x0005 at d9bd30a8
[61636.343347] hermes_dld: Found record 0x0008 at d9bd30d2
[61636.343362] hermes_dld: Found record 0x0007 at d9bd30c4
[61636.343379] hermes_dld: Found record 0x0006 at d9bd30b6
[61636.343396] hermes_dld: Found record 0x0110 at d9bd319a
[61636.343428] hermes_dld: Found record 0x0120 at d9bd31ba
[61636.343460] hermes_dld: Found record 0x0130 at d9bd31da
[61636.343491] hermes_dld: Found record 0x0140 at d9bd31fa
[61636.343503] hermes_dld: Found record 0x0150 at d9bd3202
[61636.343514] hermes_dld: Using default record 0x0160 at dfa9fb60
[61636.343546] hermes_dld: Found record 0x0101 at d9bd3146
[61636.343560] hermes_dld: Found record 0x0103 at d9bd315c
[61636.343578] hermes_dld: Found record 0x0104 at d9bd316c
[61636.343589] hermes_dld: Found record 0x0105 at d9bd3172
[61636.343600] hermes_dld: Found record 0x0105 at d9bd3172
[61636.343610] hermes_dld: Found record 0x0105 at d9bd3172
[61636.343621] hermes_dld: Found record 0x0107 at d9bd317e
[61636.343632] hermes_dld: Found record 0x0109 at d9bd318c
[61636.343649] hermes_dld: Using default record 0x0161 at dfa9fb80
[61636.343910] eth1: Apply PDA returned 0
[61636.343973] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[61636.344000] hermes_dld: AUX disable returned 0
[61636.354636] eth1: Program end returned 0
[61636.354643] eth1: hermes_present returned 1
[61636.368097] Restarting tasks ... done.
[61636.595445] eth1: New link status: Connected (0001)
[64877.744271] PM: Syncing filesystems ... done.
[64878.267659] Freezing user space processes ... (elapsed 0.01 seconds)=20
done.
[64878.281415] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[64878.282224] Suspending console(s) (use no_console_suspend to debug)
[64878.290151] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[64878.332258] sd 0:0:0:0: [sda] Stopping disk
[64879.063931] ALI 5451 0000:00:06.0: PCI INT A disabled
[64879.077485] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[64879.843113] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[64879.853767] ohci_hcd 0000:00:02.0: PCI INT A disabled
[64879.869871] ACPI: Preparing to enter system sleep state S3
[64879.870264] Back to C!
[64879.882693] ACPI: Waking up from system sleep state S3
[64879.903825] pci 0000:00:01.0: setting latency timer to 64
[64879.917000] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[64879.917041] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[64879.972304] usb usb1: root hub lost power or was reset
[64879.983689] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[64879.983740] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[64879.990761] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[64879.990798] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[64879.991035] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[64879.991070] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[64880.277104] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[64880.290308] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[64880.317269] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[64880.567810] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[64880.567821] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[64880.574648] ata2.00: configured for UDMA/33
[64881.300324] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[64881.300440] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[64881.305536] sd 0:0:0:0: [sda] Starting disk
[64882.337366] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[64882.337378] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[64882.350997] ata1.00: configured for UDMA/33
[64882.375306] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[64882.375432] sd 0:0:0:0: [sda] Write Protect is off
[64882.375440] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[64882.375631] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[64882.627192] eth1: Attempting to download firmware agere_sta_fw.bin
[64882.627225] hermes_dld: AUX enable returned 0
[64882.628253] hermes_dld: AUX disable returned 0
[64882.628260] hermes_dld: Actual PDA length 998, Max allowed 1000
[64882.628266] eth1: Read PDA returned 0
[64882.710433] hermes_dld: AUX enable returned 0
[64882.710440] hermes_dld: Enabling volatile, EP 0x000f8000
[64882.711552] hermes_dld: PROGRAM_ENABLE returned 0
[64882.711558] eth1: Program init returned 0
[64882.711566] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[64882.759690] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[64882.762970] eth1: Program returned 0
[64882.762979] hermes_dld: Found record 0x0003 at cda4881c
[64882.762999] hermes_dld: Found record 0x0005 at cda488a8
[64882.763016] hermes_dld: Found record 0x0008 at cda488d2
[64882.763032] hermes_dld: Found record 0x0007 at cda488c4
[64882.763048] hermes_dld: Found record 0x0006 at cda488b6
[64882.763065] hermes_dld: Found record 0x0110 at cda4899a
[64882.763097] hermes_dld: Found record 0x0120 at cda489ba
[64882.763128] hermes_dld: Found record 0x0130 at cda489da
[64882.763159] hermes_dld: Found record 0x0140 at cda489fa
[64882.763171] hermes_dld: Found record 0x0150 at cda48a02
[64882.763182] hermes_dld: Using default record 0x0160 at dfa9fb60
[64882.763214] hermes_dld: Found record 0x0101 at cda48946
[64882.763227] hermes_dld: Found record 0x0103 at cda4895c
[64882.763246] hermes_dld: Found record 0x0104 at cda4896c
[64882.763256] hermes_dld: Found record 0x0105 at cda48972
[64882.763267] hermes_dld: Found record 0x0105 at cda48972
[64882.763278] hermes_dld: Found record 0x0105 at cda48972
[64882.763288] hermes_dld: Found record 0x0107 at cda4897e
[64882.763299] hermes_dld: Found record 0x0109 at cda4898c
[64882.763316] hermes_dld: Using default record 0x0161 at dfa9fb80
[64882.763577] eth1: Apply PDA returned 0
[64882.763640] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[64882.763667] hermes_dld: AUX disable returned 0
[64882.774301] eth1: Program end returned 0
[64882.774308] eth1: hermes_present returned 1
[64882.787789] Restarting tasks ... done.
[64883.132454] eth1: New link status: Connected (0001)
[66312.934643] PM: Syncing filesystems ... done.
[66313.587821] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[66313.596380] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[66313.597306] Suspending console(s) (use no_console_suspend to debug)
[66313.605260] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[66313.656369] sd 0:0:0:0: [sda] Stopping disk
[66314.377122] ALI 5451 0000:00:06.0: PCI INT A disabled
[66314.390658] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[66315.158435] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[66315.170276] ohci_hcd 0000:00:02.0: PCI INT A disabled
[66315.186392] ACPI: Preparing to enter system sleep state S3
[66315.186788] Back to C!
[66315.199356] ACPI: Waking up from system sleep state S3
[66315.220472] pci 0000:00:01.0: setting latency timer to 64
[66315.233511] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[66315.233553] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[66315.288814] usb usb1: root hub lost power or was reset
[66315.300265] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[66315.300317] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[66315.307547] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[66315.307583] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[66315.307821] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[66315.307856] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[66315.560293] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[66315.573474] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[66315.600465] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[66315.884130] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[66315.884141] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[66315.885005] ata2.00: configured for UDMA/33
[66316.583500] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[66316.583617] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[66316.588980] sd 0:0:0:0: [sda] Starting disk
[66317.563889] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[66317.563901] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[66317.577548] ata1.00: configured for UDMA/33
[66317.595677] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[66317.595800] sd 0:0:0:0: [sda] Write Protect is off
[66317.595809] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[66317.596000] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[66317.847036] eth1: Attempting to download firmware agere_sta_fw.bin
[66317.847068] hermes_dld: AUX enable returned 0
[66317.848097] hermes_dld: AUX disable returned 0
[66317.848104] hermes_dld: Actual PDA length 998, Max allowed 1000
[66317.848110] eth1: Read PDA returned 0
[66317.930277] hermes_dld: AUX enable returned 0
[66317.930284] hermes_dld: Enabling volatile, EP 0x000f8000
[66317.931396] hermes_dld: PROGRAM_ENABLE returned 0
[66317.931402] eth1: Program init returned 0
[66317.931411] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[66317.979552] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[66317.982830] eth1: Program returned 0
[66317.982839] hermes_dld: Found record 0x0003 at cda4841c
[66317.982859] hermes_dld: Found record 0x0005 at cda484a8
[66317.982877] hermes_dld: Found record 0x0008 at cda484d2
[66317.982892] hermes_dld: Found record 0x0007 at cda484c4
[66317.982909] hermes_dld: Found record 0x0006 at cda484b6
[66317.982926] hermes_dld: Found record 0x0110 at cda4859a
[66317.982957] hermes_dld: Found record 0x0120 at cda485ba
[66317.982988] hermes_dld: Found record 0x0130 at cda485da
[66317.983019] hermes_dld: Found record 0x0140 at cda485fa
[66317.983031] hermes_dld: Found record 0x0150 at cda48602
[66317.983043] hermes_dld: Using default record 0x0160 at dfa9fb60
[66317.983074] hermes_dld: Found record 0x0101 at cda48546
[66317.983088] hermes_dld: Found record 0x0103 at cda4855c
[66317.983106] hermes_dld: Found record 0x0104 at cda4856c
[66317.983117] hermes_dld: Found record 0x0105 at cda48572
[66317.983128] hermes_dld: Found record 0x0105 at cda48572
[66317.983138] hermes_dld: Found record 0x0105 at cda48572
[66317.983149] hermes_dld: Found record 0x0107 at cda4857e
[66317.983160] hermes_dld: Found record 0x0109 at cda4858c
[66317.983177] hermes_dld: Using default record 0x0161 at dfa9fb80
[66317.983437] eth1: Apply PDA returned 0
[66317.983500] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[66317.983527] hermes_dld: AUX disable returned 0
[66317.994163] eth1: Program end returned 0
[66317.994170] eth1: hermes_present returned 1
[66318.007648] Restarting tasks ... done.
[66318.318390] eth1: New link status: Connected (0001)
[77688.314910] PM: Syncing filesystems ... done.
[77688.453840] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[77688.462836] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[77688.463674] Suspending console(s) (use no_console_suspend to debug)
[77688.471632] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[77688.523507] sd 0:0:0:0: [sda] Stopping disk
[77689.235987] ALI 5451 0000:00:06.0: PCI INT A disabled
[77689.249402] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[77690.020144] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[77690.032497] ohci_hcd 0000:00:02.0: PCI INT A disabled
[77690.048637] ACPI: Preparing to enter system sleep state S3
[77690.048984] Back to C!
[77690.061223] ACPI: Waking up from system sleep state S3
[77690.081637] pci 0000:00:01.0: setting latency timer to 64
[77690.092386] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[77690.092427] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[77690.147692] usb usb1: root hub lost power or was reset
[77690.159076] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[77690.159125] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[77690.166307] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[77690.166343] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[77690.166406] ALI 5451 0000:00:06.0: restoring config space at offset=20
0x1 (was 0x2900003, writing 0xc2900003)
[77690.166595] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[77690.166630] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[77690.442486] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[77690.455694] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[77690.482702] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[77690.743007] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[77690.743016] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[77690.749571] ata2.00: configured for UDMA/33
[77691.465712] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[77691.466285] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[77691.473702] sd 0:0:0:0: [sda] Starting disk
[77692.529416] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[77692.529428] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[77692.543044] ata1.00: configured for UDMA/33
[77692.563671] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[77692.563799] sd 0:0:0:0: [sda] Write Protect is off
[77692.563808] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[77692.563999] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[77692.815911] eth1: Attempting to download firmware agere_sta_fw.bin
[77692.815944] hermes_dld: AUX enable returned 0
[77692.816975] hermes_dld: AUX disable returned 0
[77692.816981] hermes_dld: Actual PDA length 998, Max allowed 1000
[77692.816987] eth1: Read PDA returned 0
[77692.899163] hermes_dld: AUX enable returned 0
[77692.899170] hermes_dld: Enabling volatile, EP 0x000f8000
[77692.900270] hermes_dld: PROGRAM_ENABLE returned 0
[77692.900276] eth1: Program init returned 0
[77692.900284] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[77692.948425] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[77692.951705] eth1: Program returned 0
[77692.951713] hermes_dld: Found record 0x0003 at d222301c
[77692.951733] hermes_dld: Found record 0x0005 at d22230a8
[77692.951750] hermes_dld: Found record 0x0008 at d22230d2
[77692.951766] hermes_dld: Found record 0x0007 at d22230c4
[77692.951782] hermes_dld: Found record 0x0006 at d22230b6
[77692.951799] hermes_dld: Found record 0x0110 at d222319a
[77692.951831] hermes_dld: Found record 0x0120 at d22231ba
[77692.951862] hermes_dld: Found record 0x0130 at d22231da
[77692.951893] hermes_dld: Found record 0x0140 at d22231fa
[77692.951905] hermes_dld: Found record 0x0150 at d2223202
[77692.951917] hermes_dld: Using default record 0x0160 at dfa9fb60
[77692.951948] hermes_dld: Found record 0x0101 at d2223146
[77692.951961] hermes_dld: Found record 0x0103 at d222315c
[77692.951980] hermes_dld: Found record 0x0104 at d222316c
[77692.951990] hermes_dld: Found record 0x0105 at d2223172
[77692.952001] hermes_dld: Found record 0x0105 at d2223172
[77692.952012] hermes_dld: Found record 0x0105 at d2223172
[77692.952022] hermes_dld: Found record 0x0107 at d222317e
[77692.952033] hermes_dld: Found record 0x0109 at d222318c
[77692.952050] hermes_dld: Using default record 0x0161 at dfa9fb80
[77692.952313] eth1: Apply PDA returned 0
[77692.952377] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[77692.952404] hermes_dld: AUX disable returned 0
[77692.963042] eth1: Program end returned 0
[77692.963049] eth1: hermes_present returned 1
[77692.976549] Restarting tasks ... <6>eth1: New link status: Connected=20
(0001)
[77693.150351] done.
[85470.789475] PM: Syncing filesystems ... done.
[85471.495561] Freezing user space processes ... (elapsed 0.08 seconds)=20
done.
[85471.578492] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[85471.579308] Suspending console(s) (use no_console_suspend to debug)
[85471.587268] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[85471.587765] sd 0:0:0:0: [sda] Stopping disk
[85472.311872] ALI 5451 0000:00:06.0: PCI INT A disabled
[85472.325422] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[85473.101782] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[85473.115036] ohci_hcd 0000:00:02.0: PCI INT A disabled
[85473.131145] ACPI: Preparing to enter system sleep state S3
[85473.131540] Back to C!
[85473.142621] ACPI: Waking up from system sleep state S3
[85473.161743] pci 0000:00:01.0: setting latency timer to 64
[85473.174935] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[85473.174978] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[85473.230246] usb usb1: root hub lost power or was reset
[85473.241630] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[85473.241681] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[85473.247988] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[85473.248023] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[85473.248317] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[85473.248353] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[85473.548377] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[85473.561584] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[85473.588566] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[85473.825572] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[85473.825583] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[85473.826433] ata2.00: configured for UDMA/33
[85474.571603] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[85474.571718] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[85474.583491] sd 0:0:0:0: [sda] Starting disk
[85475.505304] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[85475.505316] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[85475.518936] ata1.00: configured for UDMA/33
[85475.537042] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[85475.537168] sd 0:0:0:0: [sda] Write Protect is off
[85475.537177] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[85475.537367] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[85475.788511] eth1: Attempting to download firmware agere_sta_fw.bin
[85475.788544] hermes_dld: AUX enable returned 0
[85475.789576] hermes_dld: AUX disable returned 0
[85475.789582] hermes_dld: Actual PDA length 998, Max allowed 1000
[85475.789588] eth1: Read PDA returned 0
[85475.871751] hermes_dld: AUX enable returned 0
[85475.871758] hermes_dld: Enabling volatile, EP 0x000f8000
[85475.872881] hermes_dld: PROGRAM_ENABLE returned 0
[85475.872887] eth1: Program init returned 0
[85475.872895] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[85475.921071] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[85475.924350] eth1: Program returned 0
[85475.924358] hermes_dld: Found record 0x0003 at c2bc001c
[85475.924378] hermes_dld: Found record 0x0005 at c2bc00a8
[85475.924395] hermes_dld: Found record 0x0008 at c2bc00d2
[85475.924410] hermes_dld: Found record 0x0007 at c2bc00c4
[85475.924427] hermes_dld: Found record 0x0006 at c2bc00b6
[85475.924444] hermes_dld: Found record 0x0110 at c2bc019a
[85475.924476] hermes_dld: Found record 0x0120 at c2bc01ba
[85475.924508] hermes_dld: Found record 0x0130 at c2bc01da
[85475.924538] hermes_dld: Found record 0x0140 at c2bc01fa
[85475.924551] hermes_dld: Found record 0x0150 at c2bc0202
[85475.924562] hermes_dld: Using default record 0x0160 at dfa9fb60
[85475.924594] hermes_dld: Found record 0x0101 at c2bc0146
[85475.924607] hermes_dld: Found record 0x0103 at c2bc015c
[85475.924626] hermes_dld: Found record 0x0104 at c2bc016c
[85475.924637] hermes_dld: Found record 0x0105 at c2bc0172
[85475.924647] hermes_dld: Found record 0x0105 at c2bc0172
[85475.924658] hermes_dld: Found record 0x0105 at c2bc0172
[85475.924669] hermes_dld: Found record 0x0107 at c2bc017e
[85475.924679] hermes_dld: Found record 0x0109 at c2bc018c
[85475.924696] hermes_dld: Using default record 0x0161 at dfa9fb80
[85475.924957] eth1: Apply PDA returned 0
[85475.925021] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[85475.925048] hermes_dld: AUX disable returned 0
[85475.935690] eth1: Program end returned 0
[85475.935698] eth1: hermes_present returned 1
[85475.949170] Restarting tasks ... done.
[85476.201226] eth1: New link status: Connected (0001)
[89227.527683] PM: Syncing filesystems ... done.
[89228.059563] Freezing user space processes ... (elapsed 0.00 seconds)=20
done.
[89228.069081] Freezing remaining freezable tasks ... (elapsed 0.00=20
seconds) done.
[89228.069942] Suspending console(s) (use no_console_suspend to debug)
[89228.077938] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[89228.155227] sd 0:0:0:0: [sda] Stopping disk
[89228.901496] ALI 5451 0000:00:06.0: PCI INT A disabled
[89228.915051] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[89229.667927] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[89229.681327] ohci_hcd 0000:00:02.0: PCI INT A disabled
[89229.697438] ACPI: Preparing to enter system sleep state S3
[89229.697828] Back to C!
[89229.710398] ACPI: Waking up from system sleep state S3
[89229.730969] pci 0000:00:01.0: setting latency timer to 64
[89229.741237] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[89229.741279] ohci_hcd 0000:00:02.0: restoring config space at offset=20
0xf (was 0x500001ff, writing 0x5000010b)
[89229.796535] usb usb1: root hub lost power or was reset
[89229.807922] pata_ali 0000:00:04.0: restoring config space at offset=20
0x1 (was 0x2900001, writing 0x2900005)
[89229.807972] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[89229.815096] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[89229.815131] ALI 5451 0000:00:06.0: restoring config space at offset=20
0xf (was 0x180201ff, writing 0x1802010b)
[89229.815367] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[89229.815402] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[89230.111332] ali1535_smbus 0000:00:08.0: enabling device (0000 ->=20
0001)
[89230.124541] e100 0000:00:0a.0: restoring config space at offset 0xf=20
(was 0x380801ff, writing 0x3808010b)
[89230.151520] yenta_cardbus 0000:00:10.0: restoring config space at=20
offset 0x6 (was 0x50200, writing 0xb0050200)
[89230.392072] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[89230.392082] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[89230.398607] ata2.00: configured for UDMA/33
[89231.134558] pci 0000:00:12.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[89231.134674] pci 0000:01:00.0: restoring config space at offset 0xf=20
(was 0x1ff, writing 0x10b)
[89231.139935] sd 0:0:0:0: [sda] Starting disk
[89231.964928] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[89231.964939] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[89231.978557] ata1.00: configured for UDMA/33
[89232.004870] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors:=20
(20.0 GB/18.6 GiB)
[89232.004996] sd 0:0:0:0: [sda] Write Protect is off
[89232.005005] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[89232.005195] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[89232.258090] eth1: Attempting to download firmware agere_sta_fw.bin
[89232.258122] hermes_dld: AUX enable returned 0
[89232.259153] hermes_dld: AUX disable returned 0
[89232.259159] hermes_dld: Actual PDA length 998, Max allowed 1000
[89232.259166] eth1: Read PDA returned 0
[89232.341342] hermes_dld: AUX enable returned 0
[89232.341349] hermes_dld: Enabling volatile, EP 0x000f8000
[89232.342438] hermes_dld: PROGRAM_ENABLE returned 0
[89232.342444] eth1: Program init returned 0
[89232.342452] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[89232.390660] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[89232.393941] eth1: Program returned 0
[89232.393949] hermes_dld: Found record 0x0003 at c5c1241c
[89232.393969] hermes_dld: Found record 0x0005 at c5c124a8
[89232.393986] hermes_dld: Found record 0x0008 at c5c124d2
[89232.394002] hermes_dld: Found record 0x0007 at c5c124c4
[89232.394018] hermes_dld: Found record 0x0006 at c5c124b6
[89232.394035] hermes_dld: Found record 0x0110 at c5c1259a
[89232.394067] hermes_dld: Found record 0x0120 at c5c125ba
[89232.394099] hermes_dld: Found record 0x0130 at c5c125da
[89232.394130] hermes_dld: Found record 0x0140 at c5c125fa
[89232.394142] hermes_dld: Found record 0x0150 at c5c12602
[89232.394153] hermes_dld: Using default record 0x0160 at dfa9fb60
[89232.394185] hermes_dld: Found record 0x0101 at c5c12546
[89232.394199] hermes_dld: Found record 0x0103 at c5c1255c
[89232.394217] hermes_dld: Found record 0x0104 at c5c1256c
[89232.394228] hermes_dld: Found record 0x0105 at c5c12572
[89232.394239] hermes_dld: Found record 0x0105 at c5c12572
[89232.394249] hermes_dld: Found record 0x0105 at c5c12572
[89232.394260] hermes_dld: Found record 0x0107 at c5c1257e
[89232.394271] hermes_dld: Found record 0x0109 at c5c1258c
[89232.394288] hermes_dld: Using default record 0x0161 at dfa9fb80
[89232.394549] eth1: Apply PDA returned 0
[89232.394612] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1=20
0x0000, r2 0x0000
[89232.394640] hermes_dld: AUX disable returned 0
[89232.405280] eth1: Program end returned 0
[89232.405288] eth1: hermes_present returned 1
[89232.418782] Restarting tasks ... done.
[89232.548642] eth1: New link status: Connected (0001)
[89479.104958] ------------[ cut here ]------------
[89479.105038] WARNING: at /home/bor/src/linux-git/lib/list_debug.c:30=20
__list_add+0x8f/0xa0()
[89479.105058] list_add corruption. prev->next should be next=20
(dddb3568), but was cbc28978. (prev=3Ddddb3568).
[89479.105075] Modules linked in: bnep rfcomm l2cap hci_usb bluetooth=20
tun autofs4 af_packet irnet ppp_generic slhc ircomm_tty ircomm=20
binfmt_misc loop dm_mirror dm_region_hash dm_log dm_round_robin=20
dm_multipath dm_mod nvram toshiba cryptomgr aead crypto_blkcipher=20
michael_mic crypto_algapi orinoco_cs orinoco hermes_dld hermes pcmcia=20
firmware_class snd_ali5451 snd_ac97_codec ac97_bus snd_seq_dummy=20
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss=20
snd_pcm snd_timer smsc_ircc2 snd_mixer_oss rtc_cmos irda snd rtc_core=20
crc_ccitt rtc_lib yenta_socket pcspkr sr_mod rsrc_nonstatic soundcore=20
evdev psmouse i2c_ali1535 snd_page_alloc cdrom pcmcia_core i2c_core=20
alim1535_wdt fan sg video output toshiba_acpi rfkill thermal backlight=20
processor input_polldev battery ali_agp ac button ohci_hcd agpgart=20
usbcore pata_ali libata sd_mod scsi_mod reiserfs
[89479.106002] Pid: 15746, comm: X Not tainted 2.6.28-1avb #26
[89479.106020] Call Trace:
[89479.106062]  [<c011d3b0>] warn_slowpath+0x60/0x80
[89479.106104]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.106194]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.106218]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
[89479.106254]  [<c02f9c9d>] ? _spin_unlock+0x1d/0x20
[89479.106270]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
[89479.106302]  [<c01ff2a7>] ? delay_tsc+0x17/0x24
[89479.106319]  [<c01ff221>] ? __const_udelay+0x21/0x30
[89479.106376]  [<dfa8b1e2>] ? hermes_bap_seek+0x112/0x1e0 [hermes]
[89479.106396]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
[89479.106418]  [<c018e307>] ? __kmalloc_track_caller+0xb7/0x110
[89479.106448]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
[89479.106465]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
[89479.106482]  [<c020e13f>] __list_add+0x8f/0xa0
[89479.106551]  [<dfd0fcae>] orinoco_interrupt+0xcae/0x16c0 [orinoco]
[89479.106574]  [<c013b0e3>] ? tick_dev_program_event+0x33/0xb0
[89479.106594]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.106613]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.106662]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
[89479.106892]  [<dfe7faa7>] ? usb_hcd_irq+0x97/0xa0 [usbcore]
[89479.106926]  [<c015ba79>] handle_IRQ_event+0x29/0x60
[89479.106947]  [<c015cf89>] handle_level_irq+0x69/0xe0
[89479.106963]  [<c015cf20>] ? handle_level_irq+0x0/0xe0
[89479.106977]  <IRQ>  [<c02ca933>] ? tcp_v4_rcv+0x633/0x6e0
[89479.107025]  [<c0103f0c>] ? common_interrupt+0x28/0x30
[89479.107057]  [<c02a0000>] ? sk_run_filter+0x320/0x7a0
[89479.107078]  [<c020e041>] ? list_del+0x21/0x90
[89479.107106]  [<dfd0d24e>] ? orinoco_rx_isr_tasklet+0x2ce/0x480=20
[orinoco]
[89479.107131]  [<c01402e0>] ? __lock_acquire+0x160/0x1650
[89479.107151]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.107169]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.107200]  [<c012249a>] ? irq_enter+0xa/0x60
[89479.107217]  [<c0104e52>] ? do_IRQ+0xd2/0x130
[89479.107518]  [<c010342c>] ? restore_nocheck_notrace+0x0/0xe
[89479.107542]  [<c0122830>] ? __do_softirq+0x0/0x110
[89479.107561]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
[89479.107583]  [<c01ff678>] ? trace_hardirqs_on_thunk+0xc/0x10
[89479.107602]  [<c0122087>] ? tasklet_action+0x27/0x90
[89479.107620]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
[89479.107638]  [<c01220a3>] ? tasklet_action+0x43/0x90
[89479.107655]  [<c012289f>] ? __do_softirq+0x6f/0x110
[89479.107674]  [<c0122830>] ? __do_softirq+0x0/0x110
[89479.107685]  <IRQ>  [<c015cf20>] ? handle_level_irq+0x0/0xe0
[89479.107715]  [<c012246d>] ? irq_exit+0x5d/0x80
[89479.107732]  [<c0104e52>] ? do_IRQ+0xd2/0x130
[89479.107747]  [<c0103337>] ? sysenter_exit+0xf/0x16
[89479.107765]  [<c013f83d>] ? trace_hardirqs_on_caller+0xfd/0x140
[89479.107782]  [<c0103f0c>] ? common_interrupt+0x28/0x30
[89479.107797] ---[ end trace a1fc0a52df4a729d ]---


--Boundary-01=_H3jYJUfsNa/xcXg
Content-Type: text/plain;
  charset="us-ascii";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28
# Thu Dec 25 18:24:17 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR_32 is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
# CONFIG_X86_DS is not set
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="\"\""
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
CONFIG_HERMES=m
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCI_HERMES is not set
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_CYBLA=m
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=60
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_BRIGHT is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DELL is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=866
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_SQUASHFS_VMALLOC is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_BOOT_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-01=_H3jYJUfsNa/xcXg--

--nextPart1452851.jvAoepAzrl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkliPccACgkQR6LMutpd94yPjQCgiqV52e6Dcqf1BsSB/TiyYtyv
JsgAoIRa5LhcHNsb4lplEuI7wpoRKgrQ
=Eg2c
-----END PGP SIGNATURE-----

--nextPart1452851.jvAoepAzrl--
