Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZA0Sic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZA0Sic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZA0SiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:38:23 -0500
Received: from mx33.mail.ru ([194.67.23.194]:28660 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZA0SiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:38:18 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com
Subject: [2.6.29-rc2] fb_mmap: circular locking dependency on hibernation
Date: Tue, 27 Jan 2009 21:37:53 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1398193.r780PQfP9Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901272137.57757.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1398193.r780PQfP9Y
Content-Type: multipart/mixed;
  boundary="Boundary-01=_FS1fJSZ8SIevdLG"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_FS1fJSZ8SIevdLG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I do not know if this is new; I usually do not hibernate at all and was=20
testing another driver actually. I do not remember such issues in 2.6.28=20
though. Dmesg follows; config attached.

[    0.000000] Linux version 2.6.29-rc2-1avb (bor@cooker) (gcc version 4.3.=
2=20
(GCC) ) #11 Tue Jan 20 19:30:32 MSK 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] PAT WC disabled due to known CPU erratum.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
[    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn =3D 0x1ef60 max_arch_pfn =3D 0x100000
[    0.000000] kernel direct mapping tables up to 1ef60000 @ 7000-d000
[    0.000000] RAMDISK: 1ebcf000 - 1ef4f86c
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match=20
PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] 495MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ef60000
[    0.000000]   low ram: 00000000 - 1ef60000
[    0.000000]   bootmap 00001000 - 00004dec
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 001ef60=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D>=20
[0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000973d98]    TEXT DATA BSS =3D=3D>=20
[0000100000 - 0000973d98]
[    0.000000]   #2 [001ebcf000 - 001ef4f86c]          RAMDISK =3D=3D>=20
[001ebcf000 - 001ef4f86c]
[    0.000000]   #3 [0000974000 - 0000978000]    INIT_PG_TABLE =3D=3D>=20
[0000974000 - 0000978000]
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
[    0.000000] free_area_init_node: node 0, pgdat c03caa00, node_mem_map=20
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 959 pages used for memmap
[    0.000000]   Normal zone: 121761 pages, LIFO batch:31
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
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l=20
pages: 125728
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.29-rc2-1avb root=3DLAB=
EL=3D/=20
resume=3DLABEL=3Dswap acpi_backlight=3Dvendor=20
netconsole=3D@10.0.0.1/eth0,@10.0.0.2/00:17:42:21:27:e4 vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0414000 soft=3Dc0413000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 747.638 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2591 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333]=20
=2D------------------------------------------------------------------------=
=2D--
[    0.003333]                                  | spin |wlock |rlock |mutex=
=20
| wsem | rsem |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
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
[    0.003333] Memory: 489984k/507264k available (2103k kernel code, 16676k=
=20
reserved, 795k data, 232k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
[    0.003333]     vmalloc : 0xdf760000 - 0xfffeb000   ( 520 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[    0.003333]       .init : 0xc03d6000 - 0xc0410000   ( 232 kB)
[    0.003333]       .data : 0xc030dee5 - 0xc03d4e00   ( 795 kB)
[    0.003333]       .text : 0xc0100000 - 0xc030dee5   (2103 kB)
[    0.003333] Checking if this processor honours the WP bit even in=20
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0,=20
CPUs=3D1, Nodes=3D1
[    0.003387] Calibrating delay loop (skipped), value calculated using=20
timer frequency.. 1495.57 BogoMIPS (lpj=3D2492126)
[    0.003552] Mount-cache hash table entries: 512
[    0.005949] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.005998] CPU: L2 cache: 256K
[    0.006015] CPU serial number disabled.
[    0.006073] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.006122] Checking 'hlt' instruction... OK.
[    0.017647] Freeing SMP alternatives: 0k freed
[    0.017668] ACPI: Core revision 20081204
[    0.046435] ACPI: setting ELCR to 0200 (from 0a00)
[    0.049570] Testing tracer nop: PASSED
[    0.054405] net_namespace: 732 bytes
[    0.056093] NET: Registered protocol family 16
[    0.059534] ACPI: bus type pci registered
[    0.061588] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[    0.061638] PCI: Using configuration type 1 for base access
[    0.072918] bio: create slab <bio-0> at 0
[    0.083510] ACPI: EC: Look up EC in DSDT
[    0.111712] ACPI: Interpreter enabled
[    0.111777] ACPI: (supports S0 S3 S4 S5)
[    0.112198] ACPI: Using PIC for interrupt routing
[    0.171477] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.171654] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.172771] pci 0000:00:00.0: reg 10 32bit mmio: [0xf0000000-0xf3ffffff]
[    0.173162] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7eff000-0xf7efffff]
[    0.173362] pci 0000:00:02.0: PME# supported from D3hot D3cold
[    0.173401] pci 0000:00:02.0: PME# disabled
[    0.173569] pci 0000:00:04.0: reg 20 io port: [0xeff0-0xefff]
[    0.173753] pci 0000:00:06.0: reg 10 io port: [0xed00-0xedff]
[    0.173777] pci 0000:00:06.0: reg 14 32bit mmio: [0xf7efe000-0xf7efefff]
[    0.173903] pci 0000:00:06.0: supports D1 D2
[    0.173911] pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
[    0.173939] pci 0000:00:06.0: PME# disabled
[    0.174346] pci 0000:00:08.0: quirk: region ee00-ee3f claimed by ali7101=
=20
ACPI
[    0.174377] pci 0000:00:08.0: quirk: region ef00-ef1f claimed by ali7101=
=20
SMB
[    0.174497] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7efd000-0xf7efdfff]
[    0.174521] pci 0000:00:0a.0: reg 14 io port: [0xeb40-0xeb7f]
[    0.174545] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7d00000-0xf7dfffff]
[    0.174657] pci 0000:00:0a.0: supports D1 D2
[    0.174665] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.174694] pci 0000:00:0a.0: PME# disabled
[    0.174822] pci 0000:00:10.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.174882] pci 0000:00:10.0: supports D1 D2
[    0.174890] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.174919] pci 0000:00:10.0: PME# disabled
[    0.175033] pci 0000:00:11.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.175198] pci 0000:00:11.1: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.175375] pci 0000:00:12.0: reg 10 32bit mmio: [0xf7cffe00-0xf7cfffff]
[    0.175519] pci 0000:00:12.0: supports D1 D2
[    0.175527] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.175556] pci 0000:00:12.0: PME# disabled
[    0.175744] pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfdffffff]
[    0.175768] pci 0000:01:00.0: reg 14 32bit mmio: [0xfbc00000-0xfbffffff]
[    0.175790] pci 0000:01:00.0: reg 18 32bit mmio: [0xf8000000-0xf9ffffff]
[    0.175813] pci 0000:01:00.0: reg 1c 32bit mmio: [0xf7ff8000-0xf7ffffff]
[    0.175859] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.175929] pci 0000:01:00.0: supports D1 D2
[    0.176064] pci 0000:00:01.0: bridge 32bit mmio: [0xf7f00000-0xfdffffff]
[    0.176270] pci_bus 0000:00: on NUMA node 0
[    0.176318] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.177084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.214680] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[    0.215642] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[    0.216547] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[    0.217589] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[    0.218493] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[    0.219394] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[    0.221045] ACPI: Power Resource [PFAN] (off)
[    0.224275] PCI: Using ACPI for IRQ routing
[    0.227664] pnp: PnP ACPI init
[    0.227664] ACPI: bus type pnp registered
[    0.254556] pnp: PnP ACPI: found 12 devices
[    0.254615] ACPI: ACPI bus type pnp unregistered
[    0.254732] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.254763] system 00:00: iomem range 0xe0000-0xeffff could not be=20
reserved
[    0.254792] system 00:00: iomem range 0xf0000-0xfffff could not be=20
reserved
[    0.254820] system 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[    0.254850] system 00:00: iomem range 0x1ef60000-0x1ef6ffff could not be=
=20
reserved
[    0.254881] system 00:00: iomem range 0x1f000000-0x1fffffff has been=20
reserved
[    0.254908] system 00:00: iomem range 0x1ef70000-0x1effffff has been=20
reserved
[    0.254939] system 00:00: iomem range 0xffe00000-0xffffffff could not be=
=20
reserved
[    0.255031] system 00:08: ioport range 0x370-0x371 has been reserved
[    0.255058] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.255084] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.255110] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.255135] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.255161] system 00:08: ioport range 0x6c0-0x6ff has been reserved
[    0.255187] system 00:08: ioport range 0xe000-0xe07f has been reserved
[    0.255213] system 00:08: ioport range 0xe080-0xe0ff has been reserved
[    0.255240] system 00:08: ioport range 0xe400-0xe47f has been reserved
[    0.255267] system 00:08: ioport range 0xe480-0xe4ff has been reserved
[    0.255294] system 00:08: ioport range 0xe800-0xe87f has been reserved
[    0.255321] system 00:08: ioport range 0xe880-0xe8ff has been reserved
[    0.255348] system 00:08: ioport range 0xec00-0xec7f has been reserved
[    0.255376] system 00:08: ioport range 0xec80-0xecff has been reserved
[    0.255404] system 00:08: ioport range 0xee00-0xee41 could not be=20
reserved
[    0.255432] system 00:08: ioport range 0xee90-0xee9f has been reserved
[    0.255458] system 00:08: ioport range 0xeeac-0xeeac has been reserved
[    0.255487] system 00:08: ioport range 0xef00-0xef3f could not be=20
reserved
[    0.255514] system 00:08: ioport range 0xef40-0xef5f has been reserved
[    0.294689] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.294746] pci 0000:00:01.0:   IO window: disabled
[    0.294778] pci 0000:00:01.0:   MEM window: 0xf7f00000-0xfdffffff
[    0.294808] pci 0000:00:01.0:   PREFETCH window:=20
0x00000048000000-0x000000480fffff
[    0.294855] pci 0000:00:10.0: CardBus bridge, secondary bus 0000:02
[    0.294877] pci 0000:00:10.0:   IO window: 0x001000-0x0010ff
[    0.294904] pci 0000:00:10.0:   IO window: 0x001400-0x0014ff
[    0.294932] pci 0000:00:10.0:   PREFETCH window: 0x30000000-0x33ffffff
[    0.294962] pci 0000:00:10.0:   MEM window: 0x34000000-0x37ffffff
[    0.294992] pci 0000:00:11.0: CardBus bridge, secondary bus 0000:06
[    0.295013] pci 0000:00:11.0:   IO window: 0x001800-0x0018ff
[    0.295040] pci 0000:00:11.0:   IO window: 0x001c00-0x001cff
[    0.295068] pci 0000:00:11.0:   PREFETCH window: 0x38000000-0x3bffffff
[    0.295098] pci 0000:00:11.0:   MEM window: 0x3c000000-0x3fffffff
[    0.295128] pci 0000:00:11.1: CardBus bridge, secondary bus 0000:0a
[    0.295149] pci 0000:00:11.1:   IO window: 0x002000-0x0020ff
[    0.295176] pci 0000:00:11.1:   IO window: 0x002400-0x0024ff
[    0.295204] pci 0000:00:11.1:   PREFETCH window: 0x40000000-0x43ffffff
[    0.295234] pci 0000:00:11.1:   MEM window: 0x44000000-0x47ffffff
[    0.295300] pci 0000:00:01.0: setting latency timer to 64
[    0.295334] pci 0000:00:10.0: enabling device (0000 -> 0003)
[    0.297239] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.297270] PCI: setting IRQ 11 as level-triggered
[    0.297283] pci 0000:00:10.0: PCI INT A -> Link[LNKC] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.297342] pci 0000:00:11.0: enabling device (0000 -> 0003)
[    0.298804] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.298830] pci 0000:00:11.0: PCI INT A -> Link[LNKA] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.298887] pci 0000:00:11.1: enabling device (0000 -> 0003)
[    0.300381] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.300407] pci 0000:00:11.1: PCI INT B -> Link[LNKB] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.300454] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.300463] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.300473] pci_bus 0000:01: resource 0 mem: [0x0-0x0]
[    0.300482] pci_bus 0000:01: resource 1 mem: [0xf7f00000-0xfdffffff]
[    0.300491] pci_bus 0000:01: resource 2 mem: [0x48000000-0x480fffff]
[    0.300500] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.300511] pci_bus 0000:02: resource 0 io:  [0x1000-0x10ff]
[    0.300519] pci_bus 0000:02: resource 1 io:  [0x1400-0x14ff]
[    0.300528] pci_bus 0000:02: resource 2 mem: [0x30000000-0x33ffffff]
[    0.300538] pci_bus 0000:02: resource 3 mem: [0x34000000-0x37ffffff]
[    0.300549] pci_bus 0000:06: resource 0 io:  [0x1800-0x18ff]
[    0.300558] pci_bus 0000:06: resource 1 io:  [0x1c00-0x1cff]
[    0.300567] pci_bus 0000:06: resource 2 mem: [0x38000000-0x3bffffff]
[    0.300576] pci_bus 0000:06: resource 3 mem: [0x3c000000-0x3fffffff]
[    0.300587] pci_bus 0000:0a: resource 0 io:  [0x2000-0x20ff]
[    0.300596] pci_bus 0000:0a: resource 1 io:  [0x2400-0x24ff]
[    0.300605] pci_bus 0000:0a: resource 2 mem: [0x40000000-0x43ffffff]
[    0.300614] pci_bus 0000:0a: resource 3 mem: [0x44000000-0x47ffffff]
[    0.300756] NET: Registered protocol family 2
[    0.301970] IP route cache hash table entries: 4096 (order: 2, 16384=20
bytes)
[    0.303014] TCP established hash table entries: 16384 (order: 5, 131072=
=20
bytes)
[    0.303884] TCP bind hash table entries: 16384 (order: 7, 655360 bytes)
[    0.310494] TCP: Hash tables configured (established 16384 bind 16384)
[    0.310774] TCP reno registered
[    0.311551] NET: Registered protocol family 1
[    0.313040] checking if image is initramfs... it is
[    0.796938] Switched to high resolution mode on CPU 0
[    1.225537] Freeing initrd memory: 3586k freed
[    1.234331] Initializing RT-Tester: OK
[    1.235665] audit: initializing netlink socket (disabled)
[    1.235913] type=3D2000 audit(1233033829.233:1): initialized
[    1.244706] Kprobe smoke test started
[    1.256339] Kprobe smoke test passed successfully
[    1.256455] Testing tracer sched_switch: PASSED
[    1.397402] msgmni has been set to 964
[    1.398991] io scheduler noop registered
[    1.399027] io scheduler anticipatory registered
[    1.399046] io scheduler deadline registered
[    1.399175] io scheduler cfq registered (default)
[    1.399463] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    1.399544] pci 0000:00:0a.0: Firmware left e100 interrupts enabled;=20
disabling
[    1.399644] pci 0000:01:00.0: Boot video device
[    1.402760] vesafb: framebuffer at 0xfc000000, mapped to 0xdf780000,=20
using 3072k, total 16384k
[    1.402811] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[    1.402833] vesafb: protected mode interface info at c000:775e
[    1.402854] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[    1.402876] vesafb: scrolling: redraw
[    1.402896] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.470527] Console: switching to colour frame buffer device 128x48
[    1.536053] fb0: VESA VGA frame buffer device
[    1.989186] brd: module loaded
[    1.989638] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    1.990749] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.993859] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.994598] e100 0000:00:0a.0: PCI INT A -> Link[LNKD] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    2.022604] e100 0000:00:0a.0: PME# disabled
[    2.024489] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:d7:14:a1
[    2.025918] netconsole: local port 6665
[    2.026404] netconsole: local IP 10.0.0.1
[    2.026983] netconsole: interface eth0
[    2.027451] netconsole: remote port 6666
[    2.027938] netconsole: remote IP 10.0.0.2
[    2.028447] netconsole: remote ethernet address 00:17:42:21:27:e4
[    2.029235] netconsole: device eth0 not up yet, forcing it
[    2.045232] e100: eth0: e100_request_firmware: Failed to load firmware=20
"e100/d101m_ucode.bin": -22
[    2.047191] netconsole: failed to open eth0
[    2.047723] netconsole: cleaning up
[    2.049470] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[    2.056103] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.056902] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.060664] mice: PS/2 mouse device common for all mice
[    2.062107] cpuidle: using governor ladder
[    2.086864] cpuidle: using governor menu
[    2.111329] TCP cubic registered
[    2.135419] Using IPI Shortcut mode
[    2.162752] registered taskstats version 1
[    2.187758] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.214215] Freeing unused kernel memory: 232k freed
[    2.239579] Write protecting the kernel text: 2104k
[    2.264192] Write protecting the kernel read-only data: 624k
[    2.310598] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input0
[    2.948066] SCSI subsystem initialized
[    3.019183] Driver 'sd' needs updating - please use bus_type methods
[    3.151165] libata version 3.00 loaded.
[    3.193858] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[    3.218466] scsi0 : pata_ali
[    3.242920] scsi1 : pata_ali
[    3.270335] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq=
=20
14
[    3.293472] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq=
=20
15
[    3.474174] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[    3.496903] ata1.00: 39070080 sectors, multi 0: LBA=20
[    3.519237] ata1.00: limited to UDMA/33 due to 40-wire cable
[    3.554007] ata1.00: configured for UDMA/33
[    3.577923] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0=20
DA3O PQ: 0 ANSI: 5
[    3.602301] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[    3.625312] sd 0:0:0:0: [sda] Write Protect is off
[    3.648050] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.648233] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.673855] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[    3.698086] sd 0:0:0:0: [sda] Write Protect is off
[    3.721993] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.722171] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.746873]  sda: sda1 sda2
[    3.803338] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.027278] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[    4.051749] ata2.00: WARNING: ATAPI DMA disabled for reliablity issues. =
=20
It can be enabled
[    4.076231] ata2.00: WARNING: via pata_ali.atapi_dma modparam or=20
corresponding sysfs node.
[    4.113805] ata2.00: configured for UDMA/33
[    4.142905] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502=20
1313 PQ: 0 ANSI: 5
[    4.432426] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[    4.459136] ReiserFS: sda2: using ordered data mode
[    4.499571] ReiserFS: sda2: journal params: device sda2, size 8192,=20
journal first block 18, max trans len 1024, max batch 900, max commit age=20
30, max trans age 30
[    4.562985] ReiserFS: sda2: checking transaction log (sda2)
[    7.527891] ReiserFS: sda2: replayed 9 transactions in 3 seconds
[    7.940596] ReiserFS: sda2: Using r5 hash to sort names
[   10.425258] usbcore: registered new interface driver usbfs
[   10.452859] usbcore: registered new interface driver hub
[   10.479901] usbcore: registered new device driver usb
[   16.423816] Linux agpgart interface v0.103
[   16.532621] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   16.537079] ACPI: AC Adapter [ADP1] (on-line)
[   16.543204] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   16.543233] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[   16.543553] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   16.545988] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[   16.546113] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   16.611443] usb usb1: configuration #1 chosen from 1 choice
[   16.612643] hub 1-0:1.0: USB hub found
[   16.612907] hub 1-0:1.0: 3 ports detected
[   16.642710] input: Power Button (FF) as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   16.656970] ACPI: Power Button (FF) [PWRF]
[   16.657791] input: Lid Switch as=20
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[   16.658561] ACPI: Lid Switch [LID]
[   16.788645] agpgart-ali 0000:00:00.0: ALi M1644 chipset
[   16.803507] ACPI Warning (nspredef-0940): \_SB_.BAT1._BIF: Return Packag=
e=20
type mismatch at index 12 - found Integer, expected String/Buffer [20081204]
[   16.805021] ACPI: Battery Slot [BAT1] (battery present)
[   16.805246] ACPI: Battery Slot [BAT2] (battery absent)
[   16.814244] agpgart-ali 0000:00:00.0: AGP aperture is 64M @ 0xf0000000
[   16.818024] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   16.818893] processor ACPI_CPU:00: registered as cooling_device0
[   17.005413] thermal LNXTHERM:01: registered as thermal_zone0
[   17.019715] ACPI: Thermal Zone [THRM] (60 C)
[   17.060281] input: Video Bus as=20
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14/device:15/input/input3
[   17.070242] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post:=20
no)
[   17.135012] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   17.135340] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   17.200916] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   17.200932] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   17.287612] pci 0000:00:08.0: enabling device (0000 -> 0001)
[   17.288765] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[   17.370347] fan PNP0C0B:00: registered as cooling_device1
[   17.370387] ACPI: Fan [FAN] (off)
[   17.757062] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   18.120823] Driver 'sr' needs updating - please use bus_type methods
[   18.159398] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   18.159422] Uniform CD-ROM driver Revision: 3.20
[   18.160790] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   18.494394] input: ImPS/2 Generic Wheel Mouse as=20
/devices/platform/i8042/serio1/input/input5
[   18.593472] yenta_cardbus 0000:00:10.0: CardBus bridge found [12a3:ab01]
[   18.720976] yenta_cardbus 0000:00:10.0: ISA IRQ mask 0x0000, PCI irq 11
[   18.720994] yenta_cardbus 0000:00:10.0: Socket status: 30000011
[   18.728048] yenta_cardbus 0000:00:11.0: CardBus bridge found [1179:0001]
[   18.854406] yenta_cardbus 0000:00:11.0: ISA IRQ mask 0x04b8, PCI irq 11
[   18.854424] yenta_cardbus 0000:00:11.0: Socket status: 30000087
[   18.882722] yenta_cardbus 0000:00:11.1: CardBus bridge found [1179:0001]
[   18.967841] rtc_cmos 00:07: RTC can wake from S4
[   18.969586] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   18.969689] rtc0: alarms up to one year, 114 bytes nvram
[   19.007604] yenta_cardbus 0000:00:11.1: ISA IRQ mask 0x04b8, PCI irq 11
[   19.007620] yenta_cardbus 0000:00:11.1: Socket status: 30000007
[   19.360232] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[   20.391374] NET: Registered protocol family 23
[   20.611982] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[   20.612023] Activated ALi 1533 ISA bridge port 0x02e8.
[   20.612039] Activated ALi 1533 ISA bridge port 0x02f8.
[   20.612293] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[   20.612308] smsc_superio_flat(): IrDA not enabled
[   20.612336] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x02
[   20.612375] SMsC IrDA Controller found
[   20.612378]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[   20.612604] No transceiver found. Defaulting to Fast pin select
[   20.612646] irda0 (): not using net_device_ops yet
[   20.613795] IrDA: Registered device irda0
[   22.425819] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[   22.427551] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   22.427570] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[   26.013014] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   26.016539] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   26.018111] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   26.019497] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   26.022164] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   26.181618] Marking TSC unstable due to TSC halts in idle
[   26.293407] Clocksource tsc unstable (delta =3D -353272291 ns)
[   26.627092] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   26.630428] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   26.631944] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   26.633656] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   26.636193] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   26.638326] pcmcia_socket pcmcia_socket0: cs: memory probe=20
0xa0000000-0xa0ffffff: clean.
[   26.652582] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[   26.661524] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   26.681139] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   26.682650] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   26.684258] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   26.686839] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   26.906667] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[   27.102349] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[   27.184457] eth1: Hardware identity 0005:0002:0001:0002
[   27.184576] eth1: Station identity  001f:0001:0006:000e
[   27.184588] eth1: Firmware determined as Lucent/Agere 6.14
[   27.184602] eth1: Attempting to download firmware agere_sta_fw.bin
[   27.184631] hermes_dld: AUX enable returned 0
[   27.185636] hermes_dld: AUX disable returned 0
[   27.185645] hermes_dld: Actual PDA length 998, Max allowed 1000
[   27.185652] eth1: Read PDA returned 0
[   27.185665] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[   27.353708] hermes_dld: AUX enable returned 0
[   27.353724] hermes_dld: Enabling volatile, EP 0x000f8000
[   27.354815] hermes_dld: PROGRAM_ENABLE returned 0
[   27.354823] eth1: Program init returned 0
[   27.354833] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[   27.402930] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[   27.406209] eth1: Program returned 0
[   27.406219] hermes_dld: Found record 0x0003 at dde3a81c
[   27.406240] hermes_dld: Found record 0x0005 at dde3a8a8
[   27.406259] hermes_dld: Found record 0x0008 at dde3a8d2
[   27.406276] hermes_dld: Found record 0x0007 at dde3a8c4
[   27.406294] hermes_dld: Found record 0x0006 at dde3a8b6
[   27.406314] hermes_dld: Found record 0x0110 at dde3a99a
[   27.406347] hermes_dld: Found record 0x0120 at dde3a9ba
[   27.406380] hermes_dld: Found record 0x0130 at dde3a9da
[   27.406412] hermes_dld: Found record 0x0140 at dde3a9fa
[   27.406426] hermes_dld: Found record 0x0150 at dde3aa02
[   27.406439] hermes_dld: Using default record 0x0160 at dfaaeb60
[   27.406472] hermes_dld: Found record 0x0101 at dde3a946
[   27.406488] hermes_dld: Found record 0x0103 at dde3a95c
[   27.406508] hermes_dld: Found record 0x0104 at dde3a96c
[   27.406520] hermes_dld: Found record 0x0105 at dde3a972
[   27.406532] hermes_dld: Found record 0x0105 at dde3a972
[   27.406544] hermes_dld: Found record 0x0105 at dde3a972
[   27.406556] hermes_dld: Found record 0x0107 at dde3a97e
[   27.406568] hermes_dld: Found record 0x0109 at dde3a98c
[   27.406587] hermes_dld: Using default record 0x0161 at dfaaeb80
[   27.406851] eth1: Apply PDA returned 0
[   27.406916] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[   27.406945] hermes_dld: AUX disable returned 0
[   27.417580] eth1: Program end returned 0
[   27.417589] eth1: hermes_present returned 1
[   27.418413] eth1: Hardware identity 0005:0002:0001:0002
[   27.418540] eth1: Station identity  001f:0002:0009:0030
[   27.418552] eth1: Firmware determined as Lucent/Agere 9.48
[   27.418560] eth1: Ad-hoc demo mode supported
[   27.418567] eth1: IEEE standard IBSS ad-hoc mode supported
[   27.418574] eth1: WEP supported, 104-bit key
[   27.418582] eth1: WPA-PSK supported
[   27.763503] eth1: MAC address 00:02:2d:26:95:6c
[   27.763619] eth1: Station name "HERMES I"
[   27.764340] eth1: ready
[   27.765187] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[   28.224255] Toshiba System Management Mode driver v1.11 26/9/2001
[   28.515772] Non-volatile memory driver v1.3
[   29.719444] device-mapper: uevent: version 1.0.3
[   29.721544] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
=20
dm-devel@redhat.com
[   29.879406] device-mapper: multipath: version 1.0.5 loaded
[   30.306641] device-mapper: multipath round-robin: version 1.0.0 loaded
[   30.308093] device-mapper: table: 254:0: multipath: error getting device
[   30.308112] device-mapper: ioctl: error adding target to table
[   35.035611] loop: module loaded
[   37.628002] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k=20
[   42.476006] IrCOMM protocol (Dag Brattli)
[   45.000236] PPP generic driver version 2.4.2
[   54.746498] NET: Registered protocol family 17
[   55.513822] eth1: Lucent/Agere firmware doesn't support manual roaming
[   55.696197] eth1: New link status: Connected (0001)
[ 1655.597137] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 1667.668995] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 1672.023101] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 1676.156634] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 1676.157098] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 1676.165387] orinoco_cs_config: mem =3D 00010100
[ 1676.165411] orinoco_cs_config: iobase =3D 00010100, spacing =3D 0
[ 1676.248321] eth1: Hardware identity 0005:0002:0001:0002
[ 1676.248442] eth1: Station identity  001f:0001:0006:000e
[ 1676.248453] eth1: Firmware determined as Lucent/Agere 6.14
[ 1676.253946] eth1: Attempting to download firmware agere_sta_fw.bin
[ 1676.253991] hermes_dld: AUX enable returned 0
[ 1676.254997] hermes_dld: AUX disable returned 0
[ 1676.255005] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 1676.255012] eth1: Read PDA returned 0
[ 1676.255025] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 1676.406694] hermes_dld: AUX enable returned 0
[ 1676.406711] hermes_dld: Enabling volatile, EP 0x000f8000
[ 1676.407791] hermes_dld: PROGRAM_ENABLE returned 0
[ 1676.407799] eth1: Program init returned 0
[ 1676.407809] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 1676.455929] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 1676.459209] eth1: Program returned 0
[ 1676.459219] hermes_dld: Found record 0x0003 at cb4d8c1c
[ 1676.459241] hermes_dld: Found record 0x0005 at cb4d8ca8
[ 1676.459260] hermes_dld: Found record 0x0008 at cb4d8cd2
[ 1676.459277] hermes_dld: Found record 0x0007 at cb4d8cc4
[ 1676.459295] hermes_dld: Found record 0x0006 at cb4d8cb6
[ 1676.459315] hermes_dld: Found record 0x0110 at cb4d8d9a
[ 1676.459349] hermes_dld: Found record 0x0120 at cb4d8dba
[ 1676.459382] hermes_dld: Found record 0x0130 at cb4d8dda
[ 1676.459414] hermes_dld: Found record 0x0140 at cb4d8dfa
[ 1676.459428] hermes_dld: Found record 0x0150 at cb4d8e02
[ 1676.459441] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 1676.459474] hermes_dld: Found record 0x0101 at cb4d8d46
[ 1676.459489] hermes_dld: Found record 0x0103 at cb4d8d5c
[ 1676.459509] hermes_dld: Found record 0x0104 at cb4d8d6c
[ 1676.459521] hermes_dld: Found record 0x0105 at cb4d8d72
[ 1676.459534] hermes_dld: Found record 0x0105 at cb4d8d72
[ 1676.459546] hermes_dld: Found record 0x0105 at cb4d8d72
[ 1676.459558] hermes_dld: Found record 0x0107 at cb4d8d7e
[ 1676.459571] hermes_dld: Found record 0x0109 at cb4d8d8c
[ 1676.459589] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 1676.459805] eth1: Apply PDA returned 0
[ 1676.459902] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 1676.459932] hermes_dld: AUX disable returned 0
[ 1676.470577] eth1: Program end returned 0
[ 1676.470586] eth1: hermes_present returned 1
[ 1676.471402] eth1: Hardware identity 0005:0002:0001:0002
[ 1676.471530] eth1: Station identity  001f:0002:0009:0030
[ 1676.471541] eth1: Firmware determined as Lucent/Agere 9.48
[ 1676.471549] eth1: Ad-hoc demo mode supported
[ 1676.471556] eth1: IEEE standard IBSS ad-hoc mode supported
[ 1676.471563] eth1: WEP supported, 104-bit key
[ 1676.471571] eth1: WPA-PSK supported
[ 1676.513945] eth1: MAC address 00:02:2d:26:95:6c
[ 1676.514064] eth1: Station name "HERMES I"
[ 1676.515375] eth1: ready
[ 1676.520650] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 1787.688813] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 1794.179963] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 1794.180421] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 1794.401279] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 1794.614507] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 1794.699011] eth1: Hardware identity 0005:0002:0001:0002
[ 1794.699131] eth1: Station identity  001f:0001:0006:000e
[ 1794.699143] eth1: Firmware determined as Lucent/Agere 6.14
[ 1794.709414] eth1: Attempting to download firmware agere_sta_fw.bin
[ 1794.709463] hermes_dld: AUX enable returned 0
[ 1794.710593] hermes_dld: AUX disable returned 0
[ 1794.710602] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 1794.710610] eth1: Read PDA returned 0
[ 1794.714455] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 1794.850396] hermes_dld: AUX enable returned 0
[ 1794.850413] hermes_dld: Enabling volatile, EP 0x000f8000
[ 1794.851504] hermes_dld: PROGRAM_ENABLE returned 0
[ 1794.851512] eth1: Program init returned 0
[ 1794.851521] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 1794.899782] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 1794.903062] eth1: Program returned 0
[ 1794.903073] hermes_dld: Found record 0x0003 at de9bfc1c
[ 1794.903095] hermes_dld: Found record 0x0005 at de9bfca8
[ 1794.903114] hermes_dld: Found record 0x0008 at de9bfcd2
[ 1794.903131] hermes_dld: Found record 0x0007 at de9bfcc4
[ 1794.903149] hermes_dld: Found record 0x0006 at de9bfcb6
[ 1794.903216] hermes_dld: Found record 0x0110 at de9bfd9a
[ 1794.903250] hermes_dld: Found record 0x0120 at de9bfdba
[ 1794.903283] hermes_dld: Found record 0x0130 at de9bfdda
[ 1794.903316] hermes_dld: Found record 0x0140 at de9bfdfa
[ 1794.903329] hermes_dld: Found record 0x0150 at de9bfe02
[ 1794.903343] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 1794.903376] hermes_dld: Found record 0x0101 at de9bfd46
[ 1794.903391] hermes_dld: Found record 0x0103 at de9bfd5c
[ 1794.903411] hermes_dld: Found record 0x0104 at de9bfd6c
[ 1794.903423] hermes_dld: Found record 0x0105 at de9bfd72
[ 1794.903435] hermes_dld: Found record 0x0105 at de9bfd72
[ 1794.903448] hermes_dld: Found record 0x0105 at de9bfd72
[ 1794.903460] hermes_dld: Found record 0x0107 at de9bfd7e
[ 1794.903472] hermes_dld: Found record 0x0109 at de9bfd8c
[ 1794.903490] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 1794.903706] eth1: Apply PDA returned 0
[ 1794.903771] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 1794.903800] hermes_dld: AUX disable returned 0
[ 1794.914439] eth1: Program end returned 0
[ 1794.914448] eth1: hermes_present returned 1
[ 1794.915265] eth1: Hardware identity 0005:0002:0001:0002
[ 1794.915392] eth1: Station identity  001f:0002:0009:0030
[ 1794.915403] eth1: Firmware determined as Lucent/Agere 9.48
[ 1794.915412] eth1: Ad-hoc demo mode supported
[ 1794.915419] eth1: IEEE standard IBSS ad-hoc mode supported
[ 1794.915426] eth1: WEP supported, 104-bit key
[ 1794.915434] eth1: WPA-PSK supported
[ 1794.978414] eth1: MAC address 00:02:2d:26:95:6c
[ 1794.978531] eth1: Station name "HERMES I"
[ 1794.979367] eth1: ready
[ 1794.984388] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 1796.155223] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 1796.449939] eth1: New link status: Connected (0001)
[ 1815.463060] PM: Syncing filesystems ... done.
[ 1815.517782] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 1815.557683] Freezing user space processes ... (elapsed 0.02 seconds)=20
done.
[ 1815.582733] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.
[ 1815.583550] Suspending console(s) (use no_console_suspend to debug)
[ 1815.595005] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 1816.048237] sd 0:0:0:0: [sda] Stopping disk
[ 1816.749538] pci 0000:01:00.0: power state changed by ACPI to D3
[ 1816.764397] e100 0000:00:0a.0: PME# enabled
[ 1816.764649] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[ 1816.764818] e100 0000:00:0a.0: PCI INT A disabled
[ 1816.833679] ALI 5451 0000:00:06.0: PCI INT A disabled
[ 1816.846939] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[ 1817.633557] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 1817.646806] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 1817.646913] ohci_hcd 0000:00:02.0: PME# disabled
[ 1817.676801] ACPI: Preparing to enter system sleep state S3
[ 1817.676801] Back to C!
[ 1817.676801] ohci_hcd 0000:00:02.0: restoring config space at offset 0xf=
=20
(was 0x500001ff, writing 0x5000010b)
[ 1817.676801] pci 0000:00:12.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[ 1817.676801] pci 0000:01:00.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[ 1817.692557] ACPI: Waking up from system sleep state S3
[ 1817.718909] agpgart-ali 0000:00:00.0: PME# disabled
[ 1817.718963] pci 0000:00:01.0: setting latency timer to 64
[ 1817.718997] ohci_hcd 0000:00:02.0: PME# disabled
[ 1817.729980] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[ 1817.730011] ohci_hcd 0000:00:02.0: PME# disabled
[ 1817.785281] usb usb1: root hub lost power or was reset
[ 1817.796890] pata_ali 0000:00:04.0: restoring config space at offset 0x1=
=20
(was 0x2900001, writing 0x2900005)
[ 1817.796944] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 1817.806834] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 1817.806872] ALI 5451 0000:00:06.0: restoring config space at offset 0xf=
=20
(was 0x180201ff, writing 0x1802010b)
[ 1817.807118] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 1817.807359] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[ 1818.093261] pci 0000:00:07.0: PME# disabled
[ 1818.093287] ali1535_smbus 0000:00:08.0: enabling device (0000 -> 0001)
[ 1818.106618] e100 0000:00:0a.0: restoring config space at offset 0xf (was=
=20
0x380801ff, writing 0x3808010b)
[ 1818.106682] e100 0000:00:0a.0: restoring config space at offset 0x1 (was=
=20
0x2900003, writing 0x2900007)
[ 1818.106721] e100 0000:00:0a.0: wake-up capability disabled by ACPI
[ 1818.106735] e100 0000:00:0a.0: PME# disabled
[ 1818.106811] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x6 (was 0x50200, writing 0xb0050200)
[ 1818.380552] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 1818.380562] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[ 1818.381301] ata2.00: configured for UDMA/33
[ 1819.089989] pci 0000:00:12.0: PME# disabled
[ 1819.090024] pci 0000:01:00.0: PME# disabled
[ 1819.095464] sd 0:0:0:0: [sda] Starting disk
[ 1820.043600] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 1820.043611] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[ 1820.057223] ata1.00: configured for UDMA/33
[ 1820.081412] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[ 1820.081695] sd 0:0:0:0: [sda] Write Protect is off
[ 1820.081704] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1820.081894] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[ 1820.334337] eth1: Attempting to download firmware agere_sta_fw.bin
[ 1820.334371] hermes_dld: AUX enable returned 0
[ 1820.335394] hermes_dld: AUX disable returned 0
[ 1820.335401] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 1820.335407] eth1: Read PDA returned 0
[ 1820.417580] hermes_dld: AUX enable returned 0
[ 1820.417587] hermes_dld: Enabling volatile, EP 0x000f8000
[ 1820.418687] hermes_dld: PROGRAM_ENABLE returned 0
[ 1820.418693] eth1: Program init returned 0
[ 1820.418701] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 1820.466864] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 1820.470139] eth1: Program returned 0
[ 1820.470147] hermes_dld: Found record 0x0003 at cb4d901c
[ 1820.470167] hermes_dld: Found record 0x0005 at cb4d90a8
[ 1820.470184] hermes_dld: Found record 0x0008 at cb4d90d2
[ 1820.470200] hermes_dld: Found record 0x0007 at cb4d90c4
[ 1820.470216] hermes_dld: Found record 0x0006 at cb4d90b6
[ 1820.470234] hermes_dld: Found record 0x0110 at cb4d919a
[ 1820.470265] hermes_dld: Found record 0x0120 at cb4d91ba
[ 1820.470296] hermes_dld: Found record 0x0130 at cb4d91da
[ 1820.470327] hermes_dld: Found record 0x0140 at cb4d91fa
[ 1820.470339] hermes_dld: Found record 0x0150 at cb4d9202
[ 1820.470351] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 1820.470382] hermes_dld: Found record 0x0101 at cb4d9146
[ 1820.470396] hermes_dld: Found record 0x0103 at cb4d915c
[ 1820.470415] hermes_dld: Found record 0x0104 at cb4d916c
[ 1820.470425] hermes_dld: Found record 0x0105 at cb4d9172
[ 1820.470436] hermes_dld: Found record 0x0105 at cb4d9172
[ 1820.470447] hermes_dld: Found record 0x0105 at cb4d9172
[ 1820.470458] hermes_dld: Found record 0x0107 at cb4d917e
[ 1820.470469] hermes_dld: Found record 0x0109 at cb4d918c
[ 1820.470486] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 1820.470700] eth1: Apply PDA returned 0
[ 1820.470763] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 1820.470790] hermes_dld: AUX disable returned 0
[ 1820.481427] eth1: Program end returned 0
[ 1820.481435] eth1: hermes_present returned 1
[ 1820.493041] Restarting tasks ... done.
[ 1820.709053] eth1: New link status: Connected (0001)
[ 5502.449614] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 5511.899442] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 5518.002795] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 5526.646261] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 5526.646720] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 5526.654184] orinoco_cs_config: mem =3D 00010100
[ 5526.654208] orinoco_cs_config: iobase =3D 00010100, spacing =3D 0
[ 5526.736410] eth1: Hardware identity 0005:0002:0001:0002
[ 5526.736527] eth1: Station identity  001f:0001:0006:000e
[ 5526.736538] eth1: Firmware determined as Lucent/Agere 6.14
[ 5526.736553] eth1: Attempting to download firmware agere_sta_fw.bin
[ 5526.736583] hermes_dld: AUX enable returned 0
[ 5526.737587] hermes_dld: AUX disable returned 0
[ 5526.737595] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 5526.737602] eth1: Read PDA returned 0
[ 5526.737615] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 5526.925490] hermes_dld: AUX enable returned 0
[ 5526.925504] hermes_dld: Enabling volatile, EP 0x000f8000
[ 5526.926606] hermes_dld: PROGRAM_ENABLE returned 0
[ 5526.926616] eth1: Program init returned 0
[ 5526.926626] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 5526.974783] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 5526.978054] eth1: Program returned 0
[ 5526.978065] hermes_dld: Found record 0x0003 at cb5da41c
[ 5526.978086] hermes_dld: Found record 0x0005 at cb5da4a8
[ 5526.978105] hermes_dld: Found record 0x0008 at cb5da4d2
[ 5526.978122] hermes_dld: Found record 0x0007 at cb5da4c4
[ 5526.978140] hermes_dld: Found record 0x0006 at cb5da4b6
[ 5526.978160] hermes_dld: Found record 0x0110 at cb5da59a
[ 5526.978193] hermes_dld: Found record 0x0120 at cb5da5ba
[ 5526.978226] hermes_dld: Found record 0x0130 at cb5da5da
[ 5526.978259] hermes_dld: Found record 0x0140 at cb5da5fa
[ 5526.978273] hermes_dld: Found record 0x0150 at cb5da602
[ 5526.978285] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 5526.978319] hermes_dld: Found record 0x0101 at cb5da546
[ 5526.978334] hermes_dld: Found record 0x0103 at cb5da55c
[ 5526.978354] hermes_dld: Found record 0x0104 at cb5da56c
[ 5526.978366] hermes_dld: Found record 0x0105 at cb5da572
[ 5526.978378] hermes_dld: Found record 0x0105 at cb5da572
[ 5526.978390] hermes_dld: Found record 0x0105 at cb5da572
[ 5526.978402] hermes_dld: Found record 0x0107 at cb5da57e
[ 5526.978415] hermes_dld: Found record 0x0109 at cb5da58c
[ 5526.978433] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 5526.978649] eth1: Apply PDA returned 0
[ 5526.978714] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 5526.978743] hermes_dld: AUX disable returned 0
[ 5526.989388] eth1: Program end returned 0
[ 5526.989397] eth1: hermes_present returned 1
[ 5526.990206] eth1: Hardware identity 0005:0002:0001:0002
[ 5526.990334] eth1: Station identity  001f:0002:0009:0030
[ 5526.990345] eth1: Firmware determined as Lucent/Agere 9.48
[ 5526.990354] eth1: Ad-hoc demo mode supported
[ 5526.990361] eth1: IEEE standard IBSS ad-hoc mode supported
[ 5526.990368] eth1: WEP supported, 104-bit key
[ 5526.990376] eth1: WPA-PSK supported
[ 5527.040888] eth1: MAC address 00:02:2d:26:95:6c
[ 5527.041004] eth1: Station name "HERMES I"
[ 5527.042275] eth1: ready
[ 5527.048493] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 5539.026347] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 5548.606257] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 5548.606707] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 5548.783994] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 5548.994266] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 5549.077400] eth1: Hardware identity 0005:0002:0001:0002
[ 5549.077519] eth1: Station identity  001f:0001:0006:000e
[ 5549.077530] eth1: Firmware determined as Lucent/Agere 6.14
[ 5549.082742] eth1: Attempting to download firmware agere_sta_fw.bin
[ 5549.082785] hermes_dld: AUX enable returned 0
[ 5549.083923] hermes_dld: AUX disable returned 0
[ 5549.083932] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 5549.083940] eth1: Read PDA returned 0
[ 5549.087324] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 5549.209754] hermes_dld: AUX enable returned 0
[ 5549.209771] hermes_dld: Enabling volatile, EP 0x000f8000
[ 5549.210850] hermes_dld: PROGRAM_ENABLE returned 0
[ 5549.210858] eth1: Program init returned 0
[ 5549.210868] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 5549.258969] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 5549.262246] eth1: Program returned 0
[ 5549.262256] hermes_dld: Found record 0x0003 at de9bf81c
[ 5549.262278] hermes_dld: Found record 0x0005 at de9bf8a8
[ 5549.262297] hermes_dld: Found record 0x0008 at de9bf8d2
[ 5549.262314] hermes_dld: Found record 0x0007 at de9bf8c4
[ 5549.262332] hermes_dld: Found record 0x0006 at de9bf8b6
[ 5549.262352] hermes_dld: Found record 0x0110 at de9bf99a
[ 5549.262386] hermes_dld: Found record 0x0120 at de9bf9ba
[ 5549.262419] hermes_dld: Found record 0x0130 at de9bf9da
[ 5549.262452] hermes_dld: Found record 0x0140 at de9bf9fa
[ 5549.262466] hermes_dld: Found record 0x0150 at de9bfa02
[ 5549.262478] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 5549.262511] hermes_dld: Found record 0x0101 at de9bf946
[ 5549.262527] hermes_dld: Found record 0x0103 at de9bf95c
[ 5549.262547] hermes_dld: Found record 0x0104 at de9bf96c
[ 5549.262559] hermes_dld: Found record 0x0105 at de9bf972
[ 5549.262571] hermes_dld: Found record 0x0105 at de9bf972
[ 5549.262583] hermes_dld: Found record 0x0105 at de9bf972
[ 5549.262595] hermes_dld: Found record 0x0107 at de9bf97e
[ 5549.262607] hermes_dld: Found record 0x0109 at de9bf98c
[ 5549.262626] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 5549.262889] eth1: Apply PDA returned 0
[ 5549.262955] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 5549.262984] hermes_dld: AUX disable returned 0
[ 5549.273627] eth1: Program end returned 0
[ 5549.273636] eth1: hermes_present returned 1
[ 5549.274449] eth1: Hardware identity 0005:0002:0001:0002
[ 5549.274575] eth1: Station identity  001f:0002:0009:0030
[ 5549.274587] eth1: Firmware determined as Lucent/Agere 9.48
[ 5549.274595] eth1: Ad-hoc demo mode supported
[ 5549.274602] eth1: IEEE standard IBSS ad-hoc mode supported
[ 5549.274609] eth1: WEP supported, 104-bit key
[ 5549.274618] eth1: WPA-PSK supported
[ 5549.314286] eth1: MAC address 00:02:2d:26:95:6c
[ 5549.314404] eth1: Station name "HERMES I"
[ 5549.315259] eth1: ready
[ 5549.320270] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 5550.497592] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 5550.777305] eth1: New link status: Connected (0001)
[ 6809.469178] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 6845.475579] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 6848.596759] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 6855.326095] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 6855.326550] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 6855.333756] orinoco_cs_config: mem =3D 00010100
[ 6855.333780] orinoco_cs_config: iobase =3D 00010100, spacing =3D 0
[ 6855.417190] eth1: Hardware identity 0005:0002:0001:0002
[ 6855.417308] eth1: Station identity  001f:0001:0006:000e
[ 6855.417319] eth1: Firmware determined as Lucent/Agere 6.14
[ 6855.417731] eth1: Attempting to download firmware agere_sta_fw.bin
[ 6855.417763] hermes_dld: AUX enable returned 0
[ 6855.418768] hermes_dld: AUX disable returned 0
[ 6855.418776] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 6855.418784] eth1: Read PDA returned 0
[ 6855.418798] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 6855.644099] hermes_dld: AUX enable returned 0
[ 6855.644117] hermes_dld: Enabling volatile, EP 0x000f8000
[ 6855.645196] hermes_dld: PROGRAM_ENABLE returned 0
[ 6855.645204] eth1: Program init returned 0
[ 6855.645214] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 6855.693417] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 6855.696695] eth1: Program returned 0
[ 6855.696705] hermes_dld: Found record 0x0003 at db5d081c
[ 6855.696727] hermes_dld: Found record 0x0005 at db5d08a8
[ 6855.696746] hermes_dld: Found record 0x0008 at db5d08d2
[ 6855.696763] hermes_dld: Found record 0x0007 at db5d08c4
[ 6855.696781] hermes_dld: Found record 0x0006 at db5d08b6
[ 6855.696800] hermes_dld: Found record 0x0110 at db5d099a
[ 6855.696834] hermes_dld: Found record 0x0120 at db5d09ba
[ 6855.696867] hermes_dld: Found record 0x0130 at db5d09da
[ 6855.696899] hermes_dld: Found record 0x0140 at db5d09fa
[ 6855.696913] hermes_dld: Found record 0x0150 at db5d0a02
[ 6855.696926] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 6855.696959] hermes_dld: Found record 0x0101 at db5d0946
[ 6855.696974] hermes_dld: Found record 0x0103 at db5d095c
[ 6855.696994] hermes_dld: Found record 0x0104 at db5d096c
[ 6855.697006] hermes_dld: Found record 0x0105 at db5d0972
[ 6855.697018] hermes_dld: Found record 0x0105 at db5d0972
[ 6855.697031] hermes_dld: Found record 0x0105 at db5d0972
[ 6855.697043] hermes_dld: Found record 0x0107 at db5d097e
[ 6855.697055] hermes_dld: Found record 0x0109 at db5d098c
[ 6855.697073] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 6855.697289] eth1: Apply PDA returned 0
[ 6855.697354] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 6855.697382] hermes_dld: AUX disable returned 0
[ 6855.708018] eth1: Program end returned 0
[ 6855.708028] eth1: hermes_present returned 1
[ 6855.708846] eth1: Hardware identity 0005:0002:0001:0002
[ 6855.708974] eth1: Station identity  001f:0002:0009:0030
[ 6855.708985] eth1: Firmware determined as Lucent/Agere 9.48
[ 6855.708994] eth1: Ad-hoc demo mode supported
[ 6855.709001] eth1: IEEE standard IBSS ad-hoc mode supported
[ 6855.709008] eth1: WEP supported, 104-bit key
[ 6855.709016] eth1: WPA-PSK supported
[ 6855.761332] eth1: MAC address 00:02:2d:26:95:6c
[ 6855.761448] eth1: Station name "HERMES I"
[ 6855.763034] eth1: ready
[ 6855.767920] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 6857.736999] orinoco_irq_tasklet called
[ 6874.174334] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 6974.787788] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 6977.244642] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 6980.846116] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 6980.846578] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 6980.858892] orinoco_cs_config: mem =3D 00010100
[ 6980.858917] orinoco_cs_config: iobase =3D 00010100, spacing =3D 0
[ 6980.941885] eth1: Hardware identity 0005:0002:0001:0002
[ 6980.942005] eth1: Station identity  001f:0001:0006:000e
[ 6980.942016] eth1: Firmware determined as Lucent/Agere 6.14
[ 6980.947751] eth1: Attempting to download firmware agere_sta_fw.bin
[ 6980.947795] hermes_dld: AUX enable returned 0
[ 6980.948858] hermes_dld: AUX disable returned 0
[ 6980.948867] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 6980.948875] eth1: Read PDA returned 0
[ 6980.949026] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 6981.124174] hermes_dld: AUX enable returned 0
[ 6981.124191] hermes_dld: Enabling volatile, EP 0x000f8000
[ 6981.125282] hermes_dld: PROGRAM_ENABLE returned 0
[ 6981.125290] eth1: Program init returned 0
[ 6981.125301] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 6981.173510] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 6981.176787] eth1: Program returned 0
[ 6981.176797] hermes_dld: Found record 0x0003 at cb5db41c
[ 6981.176819] hermes_dld: Found record 0x0005 at cb5db4a8
[ 6981.176838] hermes_dld: Found record 0x0008 at cb5db4d2
[ 6981.176855] hermes_dld: Found record 0x0007 at cb5db4c4
[ 6981.176873] hermes_dld: Found record 0x0006 at cb5db4b6
[ 6981.176893] hermes_dld: Found record 0x0110 at cb5db59a
[ 6981.176926] hermes_dld: Found record 0x0120 at cb5db5ba
[ 6981.176959] hermes_dld: Found record 0x0130 at cb5db5da
[ 6981.176992] hermes_dld: Found record 0x0140 at cb5db5fa
[ 6981.177005] hermes_dld: Found record 0x0150 at cb5db602
[ 6981.177019] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 6981.177052] hermes_dld: Found record 0x0101 at cb5db546
[ 6981.177067] hermes_dld: Found record 0x0103 at cb5db55c
[ 6981.177087] hermes_dld: Found record 0x0104 at cb5db56c
[ 6981.177099] hermes_dld: Found record 0x0105 at cb5db572
[ 6981.177111] hermes_dld: Found record 0x0105 at cb5db572
[ 6981.177123] hermes_dld: Found record 0x0105 at cb5db572
[ 6981.177136] hermes_dld: Found record 0x0107 at cb5db57e
[ 6981.177148] hermes_dld: Found record 0x0109 at cb5db58c
[ 6981.177166] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 6981.177383] eth1: Apply PDA returned 0
[ 6981.177448] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 6981.177478] hermes_dld: AUX disable returned 0
[ 6981.188120] eth1: Program end returned 0
[ 6981.188130] eth1: hermes_present returned 1
[ 6981.188945] eth1: Hardware identity 0005:0002:0001:0002
[ 6981.189073] eth1: Station identity  001f:0002:0009:0030
[ 6981.189084] eth1: Firmware determined as Lucent/Agere 9.48
[ 6981.189093] eth1: Ad-hoc demo mode supported
[ 6981.189100] eth1: IEEE standard IBSS ad-hoc mode supported
[ 6981.189107] eth1: WEP supported, 104-bit key
[ 6981.189116] eth1: WPA-PSK supported
[ 6981.235504] eth1: MAC address 00:02:2d:26:95:6c
[ 6981.235622] eth1: Station name "HERMES I"
[ 6981.237111] eth1: ready
[ 6981.242087] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 6982.094203] orinoco_irq_tasklet called
[ 6989.363836] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 7294.746774] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 7297.297428] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 7301.789418] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 7301.789871] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 7301.790700] orinoco_cs_config: mem =3D 00010100
[ 7301.790710] orinoco_cs_config: iobase =3D 00010100, spacing =3D 0
[ 7301.879237] eth1: Hardware identity 0005:0002:0001:0002
[ 7301.879365] eth1: Station identity  001f:0001:0006:000e
[ 7301.879378] eth1: Firmware determined as Lucent/Agere 6.14
[ 7301.882473] eth1: Attempting to download firmware agere_sta_fw.bin
[ 7301.882518] hermes_dld: AUX enable returned 0
[ 7301.883633] hermes_dld: AUX disable returned 0
[ 7301.883642] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 7301.883650] eth1: Read PDA returned 0
[ 7301.887122] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 7302.010646] hermes_dld: AUX enable returned 0
[ 7302.010662] hermes_dld: Enabling volatile, EP 0x000f8000
[ 7302.011752] hermes_dld: PROGRAM_ENABLE returned 0
[ 7302.011760] eth1: Program init returned 0
[ 7302.011769] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 7302.059935] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 7302.063209] eth1: Program returned 0
[ 7302.063220] hermes_dld: Found record 0x0003 at da7e941c
[ 7302.063241] hermes_dld: Found record 0x0005 at da7e94a8
[ 7302.063260] hermes_dld: Found record 0x0008 at da7e94d2
[ 7302.063277] hermes_dld: Found record 0x0007 at da7e94c4
[ 7302.063295] hermes_dld: Found record 0x0006 at da7e94b6
[ 7302.063315] hermes_dld: Found record 0x0110 at da7e959a
[ 7302.063349] hermes_dld: Found record 0x0120 at da7e95ba
[ 7302.063382] hermes_dld: Found record 0x0130 at da7e95da
[ 7302.063414] hermes_dld: Found record 0x0140 at da7e95fa
[ 7302.063428] hermes_dld: Found record 0x0150 at da7e9602
[ 7302.063441] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 7302.063474] hermes_dld: Found record 0x0101 at da7e9546
[ 7302.063490] hermes_dld: Found record 0x0103 at da7e955c
[ 7302.063509] hermes_dld: Found record 0x0104 at da7e956c
[ 7302.063522] hermes_dld: Found record 0x0105 at da7e9572
[ 7302.063534] hermes_dld: Found record 0x0105 at da7e9572
[ 7302.063546] hermes_dld: Found record 0x0105 at da7e9572
[ 7302.063558] hermes_dld: Found record 0x0107 at da7e957e
[ 7302.063570] hermes_dld: Found record 0x0109 at da7e958c
[ 7302.063589] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 7302.063803] eth1: Apply PDA returned 0
[ 7302.063869] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 7302.063898] hermes_dld: AUX disable returned 0
[ 7302.074535] eth1: Program end returned 0
[ 7302.074544] eth1: hermes_present returned 1
[ 7302.075360] eth1: Hardware identity 0005:0002:0001:0002
[ 7302.075487] eth1: Station identity  001f:0002:0009:0030
[ 7302.075499] eth1: Firmware determined as Lucent/Agere 9.48
[ 7302.075507] eth1: Ad-hoc demo mode supported
[ 7302.075514] eth1: IEEE standard IBSS ad-hoc mode supported
[ 7302.075521] eth1: WEP supported, 104-bit key
[ 7302.075529] eth1: WPA-PSK supported
[ 7302.123262] eth1: MAC address 00:02:2d:26:95:6c
[ 7302.123380] eth1: Station name "HERMES I"
[ 7302.124728] eth1: ready
[ 7302.129732] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 7303.543710] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 7303.764870] eth1: New link status: Connected (0001)
[ 8305.769395] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot=
=20
0
[ 8314.102846] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 8317.290790] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[ 8322.322634] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[ 8322.323093] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[ 8322.330460] orinoco_cs_config: mem =3D 00010100
[ 8322.330484] orinoco_cs_config: iobase =3D 00010100, spacing =3D 0
[ 8322.412797] eth1: Hardware identity 0005:0002:0001:0002
[ 8322.412914] eth1: Station identity  001f:0001:0006:000e
[ 8322.412926] eth1: Firmware determined as Lucent/Agere 6.14
[ 8322.421875] eth1: Attempting to download firmware agere_sta_fw.bin
[ 8322.421918] hermes_dld: AUX enable returned 0
[ 8322.423056] hermes_dld: AUX disable returned 0
[ 8322.423065] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 8322.423073] eth1: Read PDA returned 0
[ 8322.426865] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[ 8322.549971] hermes_dld: AUX enable returned 0
[ 8322.549988] hermes_dld: Enabling volatile, EP 0x000f8000
[ 8322.551067] hermes_dld: PROGRAM_ENABLE returned 0
[ 8322.551076] eth1: Program init returned 0
[ 8322.551086] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[ 8322.599269] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[ 8322.602501] eth1: Program returned 0
[ 8322.602510] hermes_dld: Found record 0x0003 at da7e9c1c
[ 8322.602580] hermes_dld: Found record 0x0005 at da7e9ca8
[ 8322.602600] hermes_dld: Found record 0x0008 at da7e9cd2
[ 8322.602617] hermes_dld: Found record 0x0007 at da7e9cc4
[ 8322.602635] hermes_dld: Found record 0x0006 at da7e9cb6
[ 8322.602655] hermes_dld: Found record 0x0110 at da7e9d9a
[ 8322.602689] hermes_dld: Found record 0x0120 at da7e9dba
[ 8322.602722] hermes_dld: Found record 0x0130 at da7e9dda
[ 8322.602755] hermes_dld: Found record 0x0140 at da7e9dfa
[ 8322.602768] hermes_dld: Found record 0x0150 at da7e9e02
[ 8322.602781] hermes_dld: Using default record 0x0160 at dfaaeb60
[ 8322.602815] hermes_dld: Found record 0x0101 at da7e9d46
[ 8322.602830] hermes_dld: Found record 0x0103 at da7e9d5c
[ 8322.602850] hermes_dld: Found record 0x0104 at da7e9d6c
[ 8322.602862] hermes_dld: Found record 0x0105 at da7e9d72
[ 8322.602874] hermes_dld: Found record 0x0105 at da7e9d72
[ 8322.602886] hermes_dld: Found record 0x0105 at da7e9d72
[ 8322.602898] hermes_dld: Found record 0x0107 at da7e9d7e
[ 8322.602911] hermes_dld: Found record 0x0109 at da7e9d8c
[ 8322.602929] hermes_dld: Using default record 0x0161 at dfaaeb80
[ 8322.603145] eth1: Apply PDA returned 0
[ 8322.603210] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[ 8322.603239] hermes_dld: AUX disable returned 0
[ 8322.613880] eth1: Program end returned 0
[ 8322.613889] eth1: hermes_present returned 1
[ 8322.614695] eth1: Hardware identity 0005:0002:0001:0002
[ 8322.614822] eth1: Station identity  001f:0002:0009:0030
[ 8322.614833] eth1: Firmware determined as Lucent/Agere 9.48
[ 8322.614841] eth1: Ad-hoc demo mode supported
[ 8322.614848] eth1: IEEE standard IBSS ad-hoc mode supported
[ 8322.614856] eth1: WEP supported, 104-bit key
[ 8322.614864] eth1: WPA-PSK supported
[ 8322.654749] eth1: MAC address 00:02:2d:26:95:6c
[ 8322.654867] eth1: Station name "HERMES I"
[ 8322.656396] eth1: ready
[ 8322.661285] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[ 8323.978313] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 8324.229756] eth1: New link status: Connected (0001)
[11629.643087] PM: Syncing filesystems ... done.
[11630.186755] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[11630.419902] Freezing user space processes ... (elapsed 0.07 seconds)=20
done.
[11630.497044] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.
[11630.497764] Suspending console(s) (use no_console_suspend to debug)
[11630.506847] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[11630.507372] sd 0:0:0:0: [sda] Stopping disk
[11631.202124] pci 0000:01:00.0: power state changed by ACPI to D3
[11631.216170] e100 0000:00:0a.0: PME# enabled
[11631.216386] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[11631.285918] ALI 5451 0000:00:06.0: PCI INT A disabled
[11631.299262] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[11632.082428] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[11632.095668] ohci_hcd 0000:00:02.0: PCI INT A disabled
[11632.095774] ohci_hcd 0000:00:02.0: PME# disabled
[11632.125164] ACPI: Preparing to enter system sleep state S3
[11632.125584] Back to C!
[11632.125584] ohci_hcd 0000:00:02.0: restoring config space at offset 0xf=
=20
(was 0x500001ff, writing 0x5000010b)
[11632.125584] pci 0000:00:12.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[11632.125584] pci 0000:01:00.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[11632.139243] ACPI: Waking up from system sleep state S3
[11632.160038] agpgart-ali 0000:00:00.0: PME# disabled
[11632.160093] pci 0000:00:01.0: setting latency timer to 64
[11632.160127] ohci_hcd 0000:00:02.0: PME# disabled
[11632.172328] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[11632.172360] ohci_hcd 0000:00:02.0: PME# disabled
[11632.227629] usb usb1: root hub lost power or was reset
[11632.239210] pata_ali 0000:00:04.0: restoring config space at offset 0x1=
=20
(was 0x2900001, writing 0x2900005)
[11632.239262] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[11632.246377] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[11632.246413] ALI 5451 0000:00:06.0: restoring config space at offset 0xf=
=20
(was 0x180201ff, writing 0x1802010b)
[11632.246660] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[11632.246694] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[11632.515609] pci 0000:00:07.0: PME# disabled
[11632.515636] ali1535_smbus 0000:00:08.0: enabling device (0000 -> 0001)
[11632.528969] e100 0000:00:0a.0: restoring config space at offset 0xf (was=
=20
0x380801ff, writing 0x3808010b)
[11632.529056] e100 0000:00:0a.0: wake-up capability disabled by ACPI
[11632.529070] e100 0000:00:0a.0: PME# disabled
[11632.529147] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x6 (was 0x50200, writing 0xb0050200)
[11632.823109] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[11632.823119] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[11632.829623] ata2.00: configured for UDMA/33
[11633.512307] pci 0000:00:12.0: PME# disabled
[11633.512337] pci 0000:01:00.0: PME# disabled
[11633.517814] sd 0:0:0:0: [sda] Starting disk
[11634.395960] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[11634.395971] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[11634.409588] ata1.00: configured for UDMA/33
[11634.435091] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[11634.435219] sd 0:0:0:0: [sda] Write Protect is off
[11634.435228] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[11634.435418] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[11634.689684] eth1: Attempting to download firmware agere_sta_fw.bin
[11634.689715] hermes_dld: AUX enable returned 0
[11634.690745] hermes_dld: AUX disable returned 0
[11634.690752] hermes_dld: Actual PDA length 998, Max allowed 1000
[11634.690758] eth1: Read PDA returned 0
[11634.772931] hermes_dld: AUX enable returned 0
[11634.772938] hermes_dld: Enabling volatile, EP 0x000f8000
[11634.774038] hermes_dld: PROGRAM_ENABLE returned 0
[11634.774043] eth1: Program init returned 0
[11634.774052] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[11634.822310] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[11634.825591] eth1: Program returned 0
[11634.825601] hermes_dld: Found record 0x0003 at ddeae81c
[11634.825621] hermes_dld: Found record 0x0005 at ddeae8a8
[11634.825639] hermes_dld: Found record 0x0008 at ddeae8d2
[11634.825654] hermes_dld: Found record 0x0007 at ddeae8c4
[11634.825671] hermes_dld: Found record 0x0006 at ddeae8b6
[11634.825688] hermes_dld: Found record 0x0110 at ddeae99a
[11634.825720] hermes_dld: Found record 0x0120 at ddeae9ba
[11634.825752] hermes_dld: Found record 0x0130 at ddeae9da
[11634.825783] hermes_dld: Found record 0x0140 at ddeae9fa
[11634.825795] hermes_dld: Found record 0x0150 at ddeaea02
[11634.825807] hermes_dld: Using default record 0x0160 at dfaaeb60
[11634.825839] hermes_dld: Found record 0x0101 at ddeae946
[11634.825852] hermes_dld: Found record 0x0103 at ddeae95c
[11634.825871] hermes_dld: Found record 0x0104 at ddeae96c
[11634.825882] hermes_dld: Found record 0x0105 at ddeae972
[11634.825893] hermes_dld: Found record 0x0105 at ddeae972
[11634.825904] hermes_dld: Found record 0x0105 at ddeae972
[11634.825914] hermes_dld: Found record 0x0107 at ddeae97e
[11634.825925] hermes_dld: Found record 0x0109 at ddeae98c
[11634.825943] hermes_dld: Using default record 0x0161 at dfaaeb80
[11634.826157] eth1: Apply PDA returned 0
[11634.826220] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[11634.826247] hermes_dld: AUX disable returned 0
[11634.836892] eth1: Program end returned 0
[11634.836899] eth1: hermes_present returned 1
[11634.848626] Restarting tasks ... <6>eth1: New link status: Connected=20
(0001)
[11634.998438] done.
[11715.652477]=20
[11715.652498] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[11715.652520] [ INFO: possible circular locking dependency detected ]
[11715.652534] 2.6.29-rc2-1avb #11
[11715.652541] -------------------------------------------------------
[11715.652550] s2disk/25519 is trying to acquire lock:
[11715.652562]  (&fb_info->lock){--..}, at: [<c0223017>] fb_mmap+0x97/0x170
[11715.652623]=20
[11715.652625] but task is already holding lock:
[11715.652632]  (&mm->mmap_sem){----}, at: [<c010639e>] sys_mmap2+0x8e/0xc0
[11715.652669]=20
[11715.652671] which lock already depends on the new lock.
[11715.652675]=20
[11715.652681]=20
[11715.652683] the existing dependency chain (in reverse order) is:
[11715.652691]=20
[11715.652693] -> #1 (&mm->mmap_sem){----}:
[11715.652707]        [<c0144ecf>] __lock_acquire+0x129f/0x1930
[11715.652730]        [<c01455bc>] lock_acquire+0x5c/0x80
[11715.652742]        [<c0181e57>] might_fault+0x77/0xa0
[11715.652764]        [<c0209325>] copy_from_user+0x35/0x130
[11715.652782]        [<c0223ef5>] fb_ioctl+0x1d5/0x3f0
[11715.652797]        [<c01a51d0>] vfs_ioctl+0x20/0x80
[11715.652832]        [<c01a53e2>] do_vfs_ioctl+0x72/0x570
[11715.652845]        [<c01a5919>] sys_ioctl+0x39/0x70
[11715.652857]        [<c0103371>] sysenter_do_call+0x12/0x31
[11715.652870]        [<ffffffff>] 0xffffffff
[11715.652973]=20
[11715.652975] -> #0 (&fb_info->lock){--..}:
[11715.652988]        [<c014503c>] __lock_acquire+0x140c/0x1930
[11715.653000]        [<c01455bc>] lock_acquire+0x5c/0x80
[11715.653011]        [<c030761a>] mutex_lock_nested+0xba/0x2f0
[11715.653032]        [<c0223017>] fb_mmap+0x97/0x170
[11715.653044]        [<c0188996>] mmap_region+0x1d6/0x530
[11715.653067]        [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
[11715.653079]        [<c01063bd>] sys_mmap2+0xad/0xc0
[11715.653091]        [<c0103371>] sysenter_do_call+0x12/0x31
[11715.653102]        [<ffffffff>] 0xffffffff
[11715.653116]=20
[11715.653119] other info that might help us debug this:
[11715.653122]=20
[11715.653130] 1 lock held by s2disk/25519:
[11715.653137]  #0:  (&mm->mmap_sem){----}, at: [<c010639e>]=20
sys_mmap2+0x8e/0xc0
[11715.653156]=20
[11715.653158] stack backtrace:
[11715.653170] Pid: 25519, comm: s2disk Not tainted 2.6.29-rc2-1avb #11
[11715.653179] Call Trace:
[11715.653190]  [<c0306248>] ? printk+0x18/0x20
[11715.653202]  [<c01437df>] print_circular_bug_tail+0xcf/0xe0
[11715.653213]  [<c014503c>] __lock_acquire+0x140c/0x1930
[11715.653224]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
[11715.653242]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
[11715.653254]  [<c0140dc5>] ? lock_release_holdtime+0x35/0x210
[11715.653265]  [<c01455bc>] lock_acquire+0x5c/0x80
[11715.653277]  [<c0223017>] ? fb_mmap+0x97/0x170
[11715.653287]  [<c030761a>] mutex_lock_nested+0xba/0x2f0
[11715.653298]  [<c0223017>] ? fb_mmap+0x97/0x170
[11715.653309]  [<c0223017>] ? fb_mmap+0x97/0x170
[11715.653335]  [<c019514d>] ? kmem_cache_alloc+0xad/0x100
[11715.653347]  [<c0223017>] fb_mmap+0x97/0x170
[11715.653358]  [<c0188996>] mmap_region+0x1d6/0x530
[11715.653371]  [<c0186a9d>] ? arch_get_unmapped_area_topdown+0x10d/0x170
[11715.653383]  [<c0188ec3>] do_mmap_pgoff+0x1d3/0x2f0
[11715.653395]  [<c01063bd>] sys_mmap2+0xad/0xc0
[11715.653406]  [<c0103371>] sysenter_do_call+0x12/0x31
[11718.835886] Syncing filesystems ... done.
[11718.850067] Freezing user space processes ... (elapsed 0.04 seconds)=20
done.
[11718.892540] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.
[11718.897405] PM: Shrinking memory...  =08-=08\=08|=08/=08-=08\=08|=08done=
 (63537 pages=20
freed)
[11728.581385] PM: Freed 254148 kbytes in 9.68 seconds (26.25 MB/s)
[11728.581398] Suspending console(s) (use no_console_suspend to debug)
[11728.788933] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[11728.829518] e100 0000:00:0a.0: PME# enabled
[11728.829949] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[11728.885899] ALI 5451 0000:00:06.0: PCI INT A disabled
[11728.899188] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[11729.683443] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[11729.683482] ohci_hcd 0000:00:02.0: PCI INT A disabled
[11729.683551] ohci_hcd 0000:00:02.0: PME# disabled
[11729.686408] ACPI: Preparing to enter system sleep state S4
[11729.687501] PM: Saving platform NVS memory
[11729.688022] PM: Creating hibernation image:=20
[11729.689188] PM: Need to copy 60138 pages
[11729.689188] PM: Restoring platform NVS memory
[11729.689188] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1=
=20
(was 0x2900007, writing 0x2900003)
[11729.695297] ACPI: Waking up from system sleep state S4
[11729.708644] agpgart-ali 0000:00:00.0: PME# disabled
[11729.708685] pci 0000:00:01.0: setting latency timer to 64
[11729.708710] ohci_hcd 0000:00:02.0: PME# disabled
[11729.708741] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[11729.708763] ohci_hcd 0000:00:02.0: PME# disabled
[11729.760920] usb usb1: root hub lost power or was reset
[11729.760994] pata_ali 0000:00:04.0: restoring config space at offset 0x1=
=20
(was 0x2900001, writing 0x2900005)
[11729.761030] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[11731.061770] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[11731.061829] ALI 5451 0000:00:06.0: restoring config space at offset 0x1=
=20
(was 0xc2900007, writing 0xc2900003)
[11731.061981] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[11731.062006] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[11731.222663] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[11731.222675] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[11731.236136] ata1.00: configured for UDMA/33
[11731.236399] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[11731.236487] sd 0:0:0:0: [sda] Write Protect is off
[11731.236496] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[11731.236629] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[11731.352259] pci 0000:00:07.0: PME# disabled
[11731.352283] ali1535_smbus 0000:00:08.0: enabling device (0000 -> 0001)
[11731.365579] e100 0000:00:0a.0: restoring config space at offset 0xf (was=
=20
0x38080100, writing 0x3808010b)
[11731.365612] e100 0000:00:0a.0: restoring config space at offset 0x6 (was=
=20
0x0, writing 0xf7d00000)
[11731.365626] e100 0000:00:0a.0: restoring config space at offset 0x5 (was=
=20
0x1, writing 0xeb41)
[11731.365639] e100 0000:00:0a.0: restoring config space at offset 0x4 (was=
=20
0x0, writing 0xf7efd000)
[11731.365652] e100 0000:00:0a.0: restoring config space at offset 0x3 (was=
=20
0x0, writing 0x4008)
[11731.365668] e100 0000:00:0a.0: restoring config space at offset 0x1 (was=
=20
0x2900000, writing 0x2900007)
[11731.365695] e100 0000:00:0a.0: wake-up capability disabled by ACPI
[11731.365706] e100 0000:00:0a.0: PME# disabled
[11731.365740] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0xf (was 0x34001ff, writing 0x5c001ff)
[11731.365779] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x4 (was 0x48201000, writing 0x48100000)
[11731.365793] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x3 (was 0x24008, writing 0x2a808)
[11731.365809] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x1 (was 0x2100003, writing 0x2100007)
[11731.509243] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[11731.509252] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[11731.532672] ata2.00: configured for UDMA/33
[11732.076399] yenta_cardbus 0000:00:11.0: restoring config space at offset=
=20
0xf (was 0x10001ff, writing 0x58001ff)
[11732.076439] yenta_cardbus 0000:00:11.0: restoring config space at offset=
=20
0x4 (was 0x48202000, writing 0x48101000)
[11732.076454] yenta_cardbus 0000:00:11.0: restoring config space at offset=
=20
0x3 (was 0x824000, writing 0x82a800)
[11732.076471] yenta_cardbus 0000:00:11.0: restoring config space at offset=
=20
0x1 (was 0x4900003, writing 0x4900007)
[11732.212253] yenta_cardbus 0000:00:11.1: restoring config space at offset=
=20
0xf (was 0x10002ff, writing 0x58002ff)
[11732.212294] yenta_cardbus 0000:00:11.1: restoring config space at offset=
=20
0x4 (was 0x48203000, writing 0x48102000)
[11732.212308] yenta_cardbus 0000:00:11.1: restoring config space at offset=
=20
0x3 (was 0x824000, writing 0x82a800)
[11732.212325] yenta_cardbus 0000:00:11.1: restoring config space at offset=
=20
0x1 (was 0x4900003, writing 0x4900007)
[11732.348911] pci 0000:00:12.0: PME# disabled
[11732.348930] pci 0000:01:00.0: PME# disabled
[11732.352500] sd 0:0:0:0: [sda] Starting disk
[11732.630082] eth1: Attempting to download firmware agere_sta_fw.bin
[11732.630135] hermes_dld: AUX enable returned 0
[11732.632308] hermes_dld: AUX disable returned 0
[11732.632315] hermes_dld: Actual PDA length 998, Max allowed 1000
[11732.632321] eth1: Read PDA returned 0
[11732.632332] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[11792.632415] eth1: Cannot find firmware agere_sta_fw.bin
[11792.632430] eth1: Error -2 re-initializing firmware
[11792.632444] PM: Device 0.0 failed to restore: error -5
[11792.719661] Restarting tasks ... done.
[11799.239948] toshiba_acpi: Re-enabled hotkeys


--Boundary-01=_FS1fJSZ8SIevdLG
Content-Type: text/plain;
  charset="us-ascii";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc2
# Sat Jan 17 15:11:19 2009
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
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUPS is not set
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
CONFIG_KALLSYMS_STRIP_GENERATED=y
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
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
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
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
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
CONFIG_SCHED_OMIT_FRAME_POINTER=y
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
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
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
# CONFIG_PCI_STUB is not set
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
CONFIG_COMPAT_NET_DEV_OPS=y
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
# CONFIG_DCB is not set

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
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
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
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
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
# CONFIG_BLK_DEV_IT8172 is not set
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
# CONFIG_LIBFC is not set
# CONFIG_FCOE is not set
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
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
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
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_HOSTAP is not set
CONFIG_HERMES=m
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCI_HERMES is not set
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
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
# CONFIG_SENSORS_ADT7475 is not set
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
# CONFIG_SENSORS_LTC4245 is not set
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
# CONFIG_SMSC_SCH311X_WDT is not set
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
# CONFIG_MFD_PCF50633 is not set
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
# CONFIG_BACKLIGHT_GENERIC is not set
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
# CONFIG_SND_HRTIMER is not set
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
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_TOPSEED is not set
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
# CONFIG_USB_OXU210HP_HCD is not set
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
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
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

#
# OTG and related infrastructure
#
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
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m

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
CONFIG_BTRFS_FS=m
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
CONFIG_MISC_FILESYSTEMS=y
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
CONFIG_DEBUG_NOTIFIERS=y
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
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
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
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_HW_BRANCH_TRACER is not set
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
CONFIG_GENERIC_FIND_LAST_BIT=y
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

--Boundary-01=_FS1fJSZ8SIevdLG--

--nextPart1398193.r780PQfP9Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl/VIUACgkQR6LMutpd94yknACgy8O4+77VdusJf/+l48M8WEmu
Uv0AoLky1MREMVA13nL3Wj7/zHi2YZY4
=7MPZ
-----END PGP SIGNATURE-----

--nextPart1398193.r780PQfP9Y--
