Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYGEICj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYGEICj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYGEICS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:02:18 -0400
Received: from mx28.mail.ru ([194.67.23.67]:13958 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYGEIBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:01:55 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dbrownell@users.sourceforge.net
Subject: All 2.6.26-rcX hang immediately after loading ohci_hcd
Date: Sat, 5 Jul 2008 11:08:15 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13658582.hNpfZ8aqIt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807051108.20183.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13658582.hNpfZ8aqIt
Content-Type: multipart/mixed;
  boundary="Boundary-01=_g3xbI0qrhVoFVyj"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_g3xbI0qrhVoFVyj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I am sorry for late report but I did not have much time recently (actually
I am leaving for next week tomorrow again without access to my Linux system=
).

All 2.6.26 versions hang on boot immediately after loading OHCI driver. 2.6=
=2E25
is fine; 2.6.26-rc as shipped by Mandriva cooker seems to work as well so t=
he
problem may be in my config (no I did not try different config due to lack =
of
time).

When system hangs SysRq is possible but rebooting (SysRq-B) does not work. =
Pressing
power button after that emits long stack and finally pressing and holding
power button switches it off.

Below is netconsole capture. Configs of 2.6.25 and 2.6.26 attached.

[    0.000000] Linux version 2.6.26-rc8-1avb (bor@cooker) (gcc version 4.3.=
1 20080626 (prerelease) (GCC) ) #6 Sat Jul 5 09:13:03 MSD 2008
[    0.000000] PAT disabled. Not yet verified on this CPU type.
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
[    0.000000] 495MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   126816
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   126816
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
 4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
 4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
 100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: DMI detected: Toshiba
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000=
:dff80000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000000=
ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 00000000000=
ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 00000000001=
00000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 125825
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.26-rc8-1avb root=3DLAB=
EL=3D/ resume=3DLABEL=3Dswap vga=3D791 netconsole=3D@10.0.0.1/eth0,6666@10.=
0.0.2/00:17:42:21:27:e4 1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0407000 soft=3Dc0406000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.687 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        2048
[    0.003333] ... CLASSHASH_SIZE:           1024
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 1024 kB
[    0.003333]  per task-struct memory footprint: 2688 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333] ------------------------------------------------------------=
=2D---------------
[    0.003333]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.003333]   ----------------------------------------------------------=
=2D---------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]   ----------------------------------------------------------=
=2D---------------
[    0.003333]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.003333]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.003333]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.003333]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.003333]   ----------------------------------------------------------=
=2D---------------
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
[    0.003333] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.003333] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.003333] Memory: 493556k/507264k available (1980k kernel code, 13060k=
 reserved, 907k data, 192k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
[    0.003333]     vmalloc : 0xdf800000 - 0xffff4000   ( 519 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[    0.003333]       .init : 0xc03d3000 - 0xc0403000   ( 192 kB)
[    0.003333]       .data : 0xc02ef090 - 0xc03d1f00   ( 907 kB)
[    0.003333]       .text : 0xc0100000 - 0xc02ef090   (1980 kB)
[    0.003333] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.086742] Calibrating delay using timer specific routine.. 1499.18 Bog=
oMIPS (lpj=3D2497889)
[    0.086922] Mount-cache hash table entries: 512
[    0.089318] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.089362] CPU: L2 cache: 256K
[    0.089423] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.089468] Checking 'hlt' instruction... OK.
[    0.100973] Freeing SMP alternatives: 0k freed
[    0.101000] ACPI: Core revision 20080321
[    0.131867] Parsing all Control Methods:
[    0.134066] Table [DSDT](id 0001) - 683 Objects with 60 Devices 195 Meth=
ods 10 Regions
[    0.134121]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[    0.134164] ACPI: setting ELCR to 0200 (from 0a00)
[    0.134741] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[    0.138760] net_namespace: 272 bytes
[    0.140620] NET: Registered protocol family 16
[    0.144064] ACPI: bus type pci registered
[    0.145936] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[    0.145994] PCI: Using configuration type 1 for base access
[    0.146039] Setting up standard PCI resources
[    0.169202] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 3F [_GP=
E] 8 regs on int 0x9
[    0.190343] Completing Region/Field/Buffer/Package initialization:......=
=2E...........................................
[    0.196089] Initialized 7/10 Regions 0/0 Fields 16/16 Buffers 27/27 Pack=
ages (692 nodes)
[    0.196124] Initializing Device/Processor/Thermal objects by executing _=
INI methods:.
[    0.200179] Executed 1 _INI methods requiring 0 _STA executions (examine=
d 64 objects)
[    0.201799] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Ena=
bled 0 Runtime GPEs in this block
[    0.201899] ACPI: Interpreter enabled
[    0.201919] ACPI: (supports S0 S3 S4 S5)
[    0.202299] ACPI: Using PIC for interrupt routing
[    0.253527] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.255672] pci 0000:00:08.0: quirk: region ee00-ee3f claimed by ali7101=
 ACPI
[    0.255721] pci 0000:00:08.0: quirk: region ef00-ef1f claimed by ali7101=
 SMB
[    0.298207] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[    0.299165] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[    0.300186] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[    0.301104] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[    0.302004] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[    0.302905] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[    0.305115] ACPI: Power Resource [PFAN] (off)
[    0.305655] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.305990] pnp: PnP ACPI init
[    0.306179] ACPI: bus type pnp registered
[    0.335776] pnp: PnP ACPI: found 12 devices
[    0.335838] ACPI: ACPI bus type pnp unregistered
[    0.337986] PCI: Using ACPI for IRQ routing
[    0.339734] ACPI: RTC can wake from S4
[    0.340056] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.340088] system 00:00: iomem range 0xe0000-0xeffff could not be reser=
ved
[    0.340117] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.340145] system 00:00: iomem range 0x100000-0x1ef5ffff could not be r=
eserved
[    0.340175] system 00:00: iomem range 0x1ef60000-0x1ef6ffff could not be=
 reserved
[    0.340206] system 00:00: iomem range 0x1f000000-0x1fffffff could not be=
 reserved
[    0.340236] system 00:00: iomem range 0x1ef70000-0x1effffff could not be=
 reserved
[    0.340269] system 00:00: iomem range 0xffe00000-0xffffffff could not be=
 reserved
[    0.340408] system 00:08: ioport range 0x370-0x371 has been reserved
[    0.340435] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.340461] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.340486] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.340511] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.340537] system 00:08: ioport range 0x6c0-0x6ff has been reserved
[    0.340562] system 00:08: ioport range 0xe000-0xe07f has been reserved
[    0.340588] system 00:08: ioport range 0xe080-0xe0ff has been reserved
[    0.340614] system 00:08: ioport range 0xe400-0xe47f has been reserved
[    0.340640] system 00:08: ioport range 0xe480-0xe4ff has been reserved
[    0.340666] system 00:08: ioport range 0xe800-0xe87f has been reserved
[    0.340692] system 00:08: ioport range 0xe880-0xe8ff has been reserved
[    0.340717] system 00:08: ioport range 0xec00-0xec7f has been reserved
[    0.340744] system 00:08: ioport range 0xec80-0xecff has been reserved
[    0.340771] system 00:08: ioport range 0xee00-0xee41 could not be reserv=
ed
[    0.340797] system 00:08: ioport range 0xee90-0xee9f has been reserved
[    0.340848] system 00:08: ioport range 0xeeac-0xeeac has been reserved
[    0.340876] system 00:08: ioport range 0xef00-0xef3f could not be reserv=
ed
[    0.340902] system 00:08: ioport range 0xef40-0xef5f has been reserved
[    0.375989] PCI: Bridge: 0000:00:01.0
[    0.376039]   IO window: disabled.
[    0.376068]   MEM window: 0xf7f00000-0xfdffffff
[    0.376094]   PREFETCH window: 0x0000000048000000-0x00000000480fffff
[    0.376135] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[    0.376154]   IO window: 0x00001000-0x000010ff
[    0.376179]   IO window: 0x00001400-0x000014ff
[    0.376204]   PREFETCH window: 0x30000000-0x33ffffff
[    0.376229]   MEM window: 0x34000000-0x37ffffff
[    0.376255] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[    0.376273]   IO window: 0x00001800-0x000018ff
[    0.376297]   IO window: 0x00001c00-0x00001cff
[    0.376322]   PREFETCH window: 0x38000000-0x3bffffff
[    0.376348]   MEM window: 0x3c000000-0x3fffffff
[    0.376374] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[    0.376392]   IO window: 0x00002000-0x000020ff
[    0.376417]   IO window: 0x00002400-0x000024ff
[    0.376442]   PREFETCH window: 0x40000000-0x43ffffff
[    0.376468]   MEM window: 0x44000000-0x47ffffff
[    0.376614] pci 0000:00:10.0: enabling device (0000 -> 0003)
[    0.378616] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.378660] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
 (level, low) -> IRQ 11
[    0.378752] pci 0000:00:11.0: enabling device (0000 -> 0003)
[    0.380277] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.380301] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    0.380390] pci 0000:00:11.1: enabling device (0000 -> 0003)
[    0.381851] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.381874] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
 (level, low) -> IRQ 11
[    0.381989] NET: Registered protocol family 2
[    0.382802] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[    0.383808] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[    0.384536] TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
[    0.390337] TCP: Hash tables configured (established 16384 bind 16384)
[    0.390588] TCP reno registered
[    0.391185] NET: Registered protocol family 1
[    0.392319] checking if image is initramfs... it is
[    1.069273] Freeing initrd memory: 2903k freed
[    1.074726] audit: initializing netlink socket (disabled)
[    1.074990] type=3D2000 audit(1215239740.073:1): initialized
[    1.119771] msgmni has been set to 970
[    1.121316] io scheduler noop registered
[    1.121356] io scheduler anticipatory registered
[    1.121376] io scheduler deadline registered
[    1.121495] io scheduler cfq registered (default)
[    1.121674] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    1.123775] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng 3072k, total 16384k
[    1.123830] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[    1.123851] vesafb: protected mode interface info at c000:775e
[    1.123872] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
 c00c77e2
[    1.123895] vesafb: scrolling: redraw
[    1.123915] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.191383] Console: switching to colour frame buffer device 128x48
[    1.250875] fb0: VESA VGA frame buffer device
[    1.567873] brd: module loaded
[    1.569187] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    1.569968] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.573266] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.574098] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
 (level, low) -> IRQ 11
[    1.603655] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr 00=
:00:39:d7:14:a1
[    1.605176] netconsole: local port 6665
[    1.605664] netconsole: local IP 10.0.0.1
[    1.606161] netconsole: interface eth0
[    1.606626] netconsole: remote port 6666
[    1.607322] netconsole: remote IP 10.0.0.2
[    1.607836] netconsole: remote ethernet address 00:17:42:21:27:e4
[    1.608618] netconsole: device eth0 not up yet, forcing it
[    1.640596] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[    1.641599] netconsole: carrier detect appears untrustworthy, waiting 4 =
seconds
[    5.643751] console [netcon0] enabled
[   10.518066] Clocksource tsc unstable (delta =3D 4687246341 ns)
[   10.542185] netconsole: network logging started
[   10.567004] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
 irq 1,12
[   10.595745] serio: i8042 KBD port at 0x60,0x64 irq 1
[   10.619041] serio: i8042 AUX port at 0x60,0x64 irq 12
[   10.645304] mice: PS/2 mouse device common for all mice
[   10.673370] cpuidle: using governor ladder
[   10.693419] cpuidle: using governor menu
[   10.716397] TCP cubic registered
[   10.738180] Using IPI Shortcut mode
[   10.763295] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   10.785628] EDD information not available.
[   10.807931] Freeing unused kernel memory: 192k freed
[   10.830237] Write protecting the kernel text: 1984k
[   10.852275] Write protecting the kernel read-only data: 748k
[   10.894389] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   11.469716] Uniform Multi-Platform E-IDE driver
[   11.490483] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   11.584801] ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slo=
t 0000:00:04.0
[   11.606689] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   11.629813] ALI15X3: not 100% native mode: will probe irqs later
[   11.651074]     ide0: BM-DMA at 0xeff0-0xeff7
[   11.673292]     ide1: BM-DMA at 0xeff8-0xefff
[   11.963681] hda: IC25N020ATDA04-0, ATA DISK drive
[   12.624682] hda: host side 80-wire cable detection failed, limiting max =
speed to UDMA33
[   12.646523] hda: UDMA/33 mode selected
[   13.371118] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
[   14.043361] hdc: UDMA/33 mode selected
[   14.067007] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   14.109511] ide1 at 0x170-0x177,0x376 on irq 15
[   14.133368] hda: max request size: 128KiB
[   14.153830] hda: 39070080 sectors (20003 MB) w/1806KiB Cache, CHS=3D3876=
0/16/63
[   14.177300] hda: cache flushes not supported
[   14.200028]  hda: hda1 hda2
[   14.262322] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   14.284877] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[   14.307056] ide_generic: I/O resource 0x170-0x177 not free.
[   14.703186] ReiserFS: hda2: found reiserfs format "3.6" with standard jo=
urnal
[   14.724938] ReiserFS: hda2: using ordered data mode
[   14.770030] ReiserFS: hda2: journal params: device hda2, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   14.823439] ReiserFS: hda2: checking transaction log (hda2)
[   14.896931] ReiserFS: hda2: Using r5 hash to sort names
[   18.114314] usbcore: registered new interface driver usbfs
[   18.161631] usbcore: registered new interface driver hub
[   18.203151] usbcore: registered new device driver usb
[   24.361967] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input1
[   24.402273] Linux agpgart interface v0.103
[   24.542148] ACPI: Power Button (FF) [PWRF]
[   24.766644] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   24.791994] ACPI: ACPI0007:00 is registered as cooling_device0
[   24.816252] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input2
[   25.051387] ACPI: Lid Switch [LID]
[   25.355110] ACPI: AC Adapter [ADP1] (on-line)
[   25.386789] ACPI: Battery Slot [BAT1] (battery present)
[   25.412244] ACPI: Battery Slot [BAT2] (battery absent)
[   25.732192] ACPI: ACPI Dock Station Driver
[   25.765968] agpgart: Detected ALi M1644 chipset
[   25.805991] agpgart: AGP aperture is 64M @ 0xf0000000
[   25.860853] ACPI: LNXTHERM:01 is registered as thermal_zone0
[   25.885559] ACPI: Thermal Zone [THRM] (64 C)
[   25.916740] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[   25.939948] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   26.045656] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[   26.247874] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   26.272907] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[   26.300391] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   26.329886] pci 0000:00:08.0: enabling device (0000 -> 0001)
[   26.357853] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[   27.055957] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   27.382671] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:0=
0/device:14/device:15/input/input4
[   27.445027] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[   27.479474] hdc: ATAPI 24X DVD-ROM drive, 128kB Cache
[   27.506816] Uniform CD-ROM driver Revision: 3.20
[   27.680962] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 1
[   27.815037] ACPI: Transitioning device [FAN] to D3
[   27.920912] ACPI: PNP0C0B:00 is registered as cooling_device1
[   27.973335] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042=
/serio1/input/input5
[   28.010779] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   28.217737] ACPI: Fan [FAN] (off)
[   28.314585] usb usb1: configuration #1 chosen from 1 choice
[   28.516267] hub 1-0:1.0: USB hub found
[   28.682215] hub 1-0:1.0: 3 ports detected
[   53.586685] SysRq : Changing Loglevel
[   53.586696] Loglevel set to 9
[   58.318313] SysRq : Show State
[   58.320025]   task                PC stack   pid father
[   58.320025] init          S 472102a3     0     1      0
[   58.320025]        de816b0c 00000046 de848000 472102a3 00000006 00000292=
 de816aec de848260=20
[   58.320025]        48f2643c 00000006 00000000 c012531d ddcd64c0 00000000=
 00000292 fffec5ee=20
[   58.320025]        de816b1c de816b48 de816b58 c02e8734 c012fec7 de816bd8=
 c0431e90 c0431e90=20
[   58.320025] Call Trace:
[   58.320025]  [<c012531d>] ? __mod_timer+0x9d/0xe0
[   58.320025]  [<c02e8734>] schedule_timeout+0x74/0xd0
[   58.320025]  [<c012fec7>] ? add_wait_queue+0x37/0x50
[   58.320025]  [<c0124cd0>] ? process_timeout+0x0/0x10
[   58.320025]  [<c02e872f>] ? schedule_timeout+0x6f/0xd0
[   58.320025]  [<c018e175>] do_select+0x4a5/0x5e0
[   58.320025]  [<c018dcd0>] ? do_select+0x0/0x5e0
[   58.320025]  [<c018ea90>] ? __pollwait+0x0/0xe0
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c013d747>] ? __lock_acquire+0x1a7/0xfb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c018e2d7>] ? core_sys_select+0x27/0x360
[   58.320025]  [<c018e496>] core_sys_select+0x1e6/0x360
[   58.320025]  [<c018e2d7>] ? core_sys_select+0x27/0x360
[   58.320025]  [<c01e238d>] ? _atomic_dec_and_lock+0x2d/0x40
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01e238d>] ? _atomic_dec_and_lock+0x2d/0x40
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c02ea9ad>] ? _spin_unlock+0x1d/0x20
[   58.320025]  [<c01e9395>] ? copy_to_user+0x45/0x130
[   58.320025]  [<c0183754>] ? cp_new_stat64+0xe4/0x100
[   58.320025]  [<c018e9d4>] sys_select+0xd4/0x190
[   58.320025]  [<c01031ec>] ? sysenter_past_esp+0xa5/0xb1
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kthreadd      S 5db5adbb     0     2      0
[   58.320025]        de82cfc8 00000046 de849720 5db5adbb 00000006 c013b68d=
 de849720 de849980=20
[   58.320025]        5db5cc30 00000006 00000001 00000246 de9bc260 dea37dd8=
 c03b5600 c03b55e0=20
[   58.320025]        dea37dd8 0000048e de82cfe0 c012f8f4 00000000 c012f7c0=
 00000000 00000000=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c012f8f4>] kthreadd+0x134/0x140
[   58.320025]  [<c012f7c0>] ? kthreadd+0x0/0x140
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] ksoftirqd/0   S cac8b6c3     0     3      2
[   58.320025]        de82dfc4 00000046 de84ae40 cac8b6c3 00000005 de84ae40=
 c0104a3e de84b0a0=20
[   58.320025]        cac9a58f 00000005 de82dfb4 c0407000 debf0000 00000246=
 de82d000 00000000=20
[   58.320025]        c0120c90 00000000 de82dfd0 c0120d15 00000000 de82dfe0=
 c012f93a c012f900=20
[   58.320025] Call Trace:
[   58.320025]  [<c0104a3e>] ? do_softirq+0x4e/0xd0
[   58.320025]  [<c0120c90>] ? ksoftirqd+0x0/0xc0
[   58.320025]  [<c0120d15>] ksoftirqd+0x85/0xc0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] watchdog/0    R running      0     4      2
[   58.320025]        de82efa0 00000046 de84c560 3ccd856b 00000006 00000006=
 de82efa0 de84c7c0=20
[   58.320025]        40335356 00000006 00000000 4030d778 ddcd6be0 4030d778=
 00000006 dde2ae40=20
[   58.320025]        000003b3 c03ab3c0 de82efd0 c0156565 08150484 00000000=
 de816ee4 de82efd0=20
[   58.320025] Call Trace:
[   58.320025]  [<c0156565>] watchdog+0x75/0x1e0
[   58.320025]  [<c01564f0>] ? watchdog+0x0/0x1e0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] events/0      R running      0     5      2
[   58.320025]        de831fa4 00000046 de84dc80 b53a0160 00000006 de831f80=
 c013cf2d de84dee0=20
[   58.320025]        b53b519a 00000006 00000296 de831fb0 ddcd6be0 de831fa4=
 c012fdbe de830028=20
[   58.320025]        de830000 de831fb0 de831fd0 c012c495 de830020 00000000=
 de84dc80 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] khelper       S 8958897a     0     6      2
[   58.320025]        de832fa4 00000046 de858000 8958897a 00000002 de832f80=
 c013cf2d de858260=20
[   58.320025]        8958f01b 00000002 00000296 de832fb0 ddcd6000 de832fa4=
 c012fdbe de830088=20
[   58.320025]        de830060 de832fb0 de832fd0 c012c495 de830080 00000000=
 de858000 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kblockd/0     R running      0    39      2
[   58.320025]        de888fa4 00000046 de86ae40 b6b17b4c 00000006 de888f80=
 c013cf2d de86b0a0=20
[   58.320025]        b6b3230c 00000006 00000000 de888fb0 de9bcbe0 de888fa4=
 c012fdbe de830988=20
[   58.320025]        de830960 de888fb0 de888fd0 c012c495 de830980 00000000=
 de86ae40 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kacpid        R running      0    41      2
[   58.320025]        de88bfa4 00000046 de86dc80 65befb33 00000006 de88bf80=
 c013cf2d de86dee0=20
[   58.320025]        65befb34 00000006 00000296 de88bfb0 debf0be0 de88bfa4=
 c012fdbe de830a48=20
[   58.320025]        de830a20 de88bfb0 de88bfd0 c012c495 de830a40 00000000=
 de86dc80 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kacpi_notify  S 658a4602     0    42      2
[   58.320025]        de88cfa4 00000046 de8b8000 658a4602 00000006 de88cf80=
 c013cf2d de8b8260=20
[   58.320025]        65dc35cf 00000006 00000296 de88cfb0 debf0be0 de88cfa4=
 c012fdbe de830aa8=20
[   58.320025]        de830a80 de88cfb0 de88cfd0 c012c495 de830aa0 00000000=
 de8b8000 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kseriod       S 879f1d36     0   117      2
[   58.320025]        de844f94 00000046 de86c560 879f1d36 00000006 de844f70=
 c013cf2d de86c7c0=20
[   58.320025]        882b0ab9 00000006 00000000 de844fb0 de9bce40 de844f94=
 c012fdbe de844fb0=20
[   58.320025]        c03c43c8 ddd3cc40 de844fd0 c026788b de848000 00000296=
 de86c7c0 1412a8ef=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c026788b>] serio_thread+0x1db/0x370
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c02676b0>] ? serio_thread+0x0/0x370
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] pdflush       S 4100242a     0   145      2
[   58.320025]        dea02fa8 00000046 de85dc80 4100242a 00000000 c013b68d=
 de85dc80 de85dee0=20
[   58.320025]        41013c00 00000000 00000000 dea02f9c c03ab160 c03b7d00=
 c01630c0 dea02fc0=20
[   58.320025]        c01630c0 00000000 dea02fd0 c0163173 de816eec de85dc80=
 00000000 00000000=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c01630c0>] ? pdflush+0x0/0x1b0
[   58.320025]  [<c01630c0>] ? pdflush+0x0/0x1b0
[   58.320025]  [<c0163173>] pdflush+0xb3/0x1b0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] pdflush       S f2440fb0     0   146      2
[   58.320025]        dea00fa8 00000046 de85ae40 f2440fb0 00000005 c013b68d=
 de85ae40 de85b0a0=20
[   58.320025]        f3b5e5ed 00000005 00000000 dea00f9c deadd7c0 c03b7d00=
 c01630c0 dea00fc0=20
[   58.320025]        c01630c0 00000000 dea00fd0 c0163173 de816eec de85ae40=
 00000000 00000000=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c01630c0>] ? pdflush+0x0/0x1b0
[   58.320025]  [<c01630c0>] ? pdflush+0x0/0x1b0
[   58.320025]  [<c0163173>] pdflush+0xb3/0x1b0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kswapd0       S 4110338d     0   147      2
[   58.320025]        de8dff3c 00000046 de859720 4110338d 00000000 de8dff18=
 c013cf2d de859980=20
[   58.320025]        4110c13b 00000000 00000282 de8dffa0 c03ab160 de8dff3c=
 c012fdbe c03b7320=20
[   58.320025]        00000000 00000000 de8dffd0 c0166675 ffffffff c0410920=
 c03b7bdc 00000000=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c0166675>] kswapd+0x465/0x470
[   58.320025]  [<c0118048>] ? hrtick_set+0x98/0xe0
[   58.320025]  [<c02e81bf>] ? schedule+0x2bf/0x4d0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c0166210>] ? kswapd+0x0/0x470
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] aio/0         S 42c76ecc     0   190      2
[   58.320025]        de370fa4 00000046 de38c560 42c76ecc 00000000 de370f80=
 c013cf2d de38c7c0=20
[   58.320025]        42c80f2e 00000000 00000296 de370fb0 c03ab160 de370fa4=
 c012fdbe de897388=20
[   58.320025]        de897360 de370fb0 de370fd0 c012c495 de897380 00000000=
 de38c560 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] reiserfs/0    S 75ba12e3     0   842      2
[   58.320025]        dde1afa4 00000046 de8b9720 75ba12e3 00000003 dde1af80=
 c013cf2d de8b9980=20
[   58.320025]        75ba12e4 00000003 00000296 dde1afb0 ddcd6000 dde1afa4=
 c012fdbe dde19028=20
[   58.320025]        dde19000 dde1afb0 dde1afd0 c012c495 dde19020 00000000=
 de8b9720 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] init          S cf37155a     0   843      1
[   58.320025]        ddc39ee8 00000046 de8bdc80 cf37155a 00000003 c013b68d=
 de8bdc80 de8bdee0=20
[   58.320025]        cfd62cc2 00000003 00000000 00000246 ddcd6000 00000001=
 00000000 de8bdc78=20
[   58.320025]        00000001 00000000 ddc39f78 c011ef68 de8bc560 de8bdc80=
 00000302 de8be12c=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c0126418>] ? do_sigaction+0xf8/0x1a0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] rc.sysinit    S c011ef3f     0   844    843
[   58.320025]        deaeeee8 00000046 de8bc560 c011ef3f deaeeec0 c013b68d=
 de8bc560 de8bc7c0=20
[   58.320025]        deaeeedc 00000246 00000001 00000246 ddcd6980 00000001=
 00000000 de8bc558=20
[   58.320025]        00000001 00000000 deaeef78 c011ef68 de38ae40 de8bc560=
 000067c5 de8bca0c=20
[   58.320025] Call Trace:
[   58.320025]  [<c011ef3f>] ? do_wait+0x77f/0xaa0
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] ksuspend_usbd S 37ade6bf     0   849      2
[   58.320025]        de2b3fa4 00000046 de388000 37ade6bf 00000004 de2b3f80=
 c013cf2d de388260=20
[   58.320025]        37ae27ba 00000004 00000296 de2b3fb0 ddcd6720 de2b3fa4=
 c012fdbe dde19088=20
[   58.320025]        dde19060 de2b3fb0 de2b3fd0 c012c495 dde19080 00000000=
 de388000 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] khubd         S b72dc1c2     0   850      2
[   58.320025]        de2b1f18 00000046 de38dc80 b72dc1c2 00000006 de2b1ef4=
 c013cf2d de38dee0=20
[   58.320025]        b72f94c4 00000006 00000292 de2b1fa4 debf0720 de2b1f18=
 c012fdbe de2b1fa4=20
[   58.320025]        df853b70 00000004 de2b1fd0 df854748 de2b1fbc 00000282=
 de2b1f38 00000282=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<df853b70>] ? hub_thread+0x0/0x10d0 [usbcore]
[   58.320025]  [<df854748>] hub_thread+0xbd8/0x10d0 [usbcore]
[   58.320025]  [<c01338c4>] ? hrtimer_start+0x84/0x140
[   58.320025]  [<c0118048>] ? hrtick_set+0x98/0xe0
[   58.320025]  [<c02e81bf>] ? schedule+0x2bf/0x4d0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<df853b70>] ? hub_thread+0x0/0x10d0 [usbcore]
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] start_udev    S dedbf512     0   905    844
[   58.320025]        deaf1ee8 00000046 de38ae40 dedbf512 00000005 c013b68d=
 de38ae40 de38b0a0=20
[   58.320025]        df1d0452 00000005 00000000 00000246 ddcd6260 00000001=
 00000000 de38ae38=20
[   58.320025]        00000001 00000000 deaf1f78 c011ef68 de014560 de38ae40=
 000067c5 de38b2ec=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c0126418>] ? do_sigaction+0xf8/0x1a0
[   58.320025]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         R running      0   960      1
[   58.320025]        de0aafb0 00000046 de868000 b6965396 00000006 00000001=
 00000246 de868264=20
[   58.320025]        b696b813 00000006 00000000 00000000 ddcd6be0 de0aafb0=
 00000046 01200011=20
[   58.320025]        00000000 b7d79708 de0aa000 c01032ea 01200011 00000000=
 00000000 00000000=20
[   58.320025] Call Trace:
[   58.320025]  [<c01032ea>] work_resched+0x5/0x30
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S ce633fa7     0  1053    960
[   58.320025]        deadbee8 00000046 de095c80 ce633fa7 00000005 c013b68d=
 de095c80 de095ee0=20
[   58.320025]        cfc5c4e1 00000005 00000000 00000246 debf1300 00000001=
 00000000 de095c78=20
[   58.320025]        00000001 00000000 deadbf78 c011ef68 de094560 de095c80=
 00000302 de09612c=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      R running      0  1054   1053
[   58.320025]        00000000 de094560 00000000 deae9c48 00000046 c02e9588=
 deae9be8 c013b68d=20
[   58.320025]        de094560 00000000 00000000 000002db 00000246 00000046=
 deae9c10 c0104a28=20
[   58.320025]        deae9000 deae9c20 00000000 c0158120 deae9c18 c0121115=
 deae9c40 c0104c1d=20
[   58.320025] Call Trace:
[   58.320025]  [<c02e9588>] ? mutex_unlock+0x8/0x10
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c0104a28>] ? do_softirq+0x38/0xd0
[   58.320025]  [<c0158120>] ? handle_level_irq+0x0/0xe0
[   58.320025]  [<c0121115>] ? irq_exit+0x65/0x90
[   58.320025]  [<c0104c1d>] ? do_IRQ+0x9d/0x110
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c010342e>] ? common_interrupt+0x2e/0x34
[   58.320025]  [<dfc5007b>] ? agp_3_5_enable+0x46b/0x7b0 [agpgart]
[   58.320025]  [<c0130000>] ? __kfifo_put+0x60/0x90
[   58.320025]  [<c02ea967>] ? _spin_unlock_irqrestore+0x37/0x60
[   58.320025]  [<dfc752cb>] ? ohci_hub_status_data+0x26b/0x470 [ohci_hcd]
[   58.320025]  [<c01c3528>] ? sysfs_add_file_mode+0x58/0x90
[   58.320025]  [<df855d15>] ? usb_hcd_poll_rh_status+0x45/0x150 [usbcore]
[   58.320025]  [<df8561f8>] ? usb_add_hcd+0x3d8/0x650 [usbcore]
[   58.320025]  [<c027683f>] ? pcibios_set_master+0x1f/0x90
[   58.320025]  [<df8617a1>] ? usb_hcd_pci_probe+0x131/0x2c0 [usbcore]
[   58.320025]  [<c02ea9ad>] ? _spin_unlock+0x1d/0x20
[   58.320025]  [<df861670>] ? usb_hcd_pci_probe+0x0/0x2c0 [usbcore]
[   58.320025]  [<c01fbd2e>] ? pci_device_probe+0x5e/0x80
[   58.320025]  [<c0254c47>] ? driver_probe_device+0x87/0x1b0
[   58.320025]  [<c0254de9>] ? __driver_attach+0x79/0x80
[   58.320025]  [<c02544fb>] ? bus_for_each_dev+0x5b/0x80
[   58.320025]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   58.320025]  [<c0254aa9>] ? driver_attach+0x19/0x20
[   58.320025]  [<c0254d70>] ? __driver_attach+0x0/0x80
[   58.320025]  [<c0253e8f>] ? bus_add_driver+0x1cf/0x250
[   58.320025]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   58.320025]  [<c0254f9c>] ? driver_register+0x6c/0x150
[   58.320025]  [<c01fbf5e>] ? __pci_register_driver+0x4e/0x90
[   58.320025]  [<dfc56041>] ? ohci_hcd_mod_init+0x41/0x45 [ohci_hcd]
[   58.320025]  [<c0144fe4>] ? sys_init_module+0x114/0x1aa0
[   58.320025]  [<dfc96000>] ? snd_minor_info_read+0x0/0x290 [snd]
[   58.320025]  [<df850960>] ? usb_root_hub_lost_power+0x0/0x40 [usbcore]
[   58.320025]  [<c01031b1>] ? sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S d89d2fe8     0  1065    960
[   58.320025]        de04eee8 00000046 de0ddc80 d89d2fe8 00000005 c013b68d=
 de0ddc80 de0ddee0=20
[   58.320025]        d9be36d5 00000005 00000000 00000246 debf0e40 00000001=
 00000000 de0ddc78=20
[   58.320025]        00000001 00000000 de04ef78 c011ef68 de0d9720 de0ddc80=
 00000302 de0de12c=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      R running      0  1066   1065
[   58.320025]        de2acde4 00000046 de0d9720 b6b2c3e7 00000006 c013b68d=
 de0d9720 de0d9980=20
[   58.320025]        b6b40dba 00000006 00000000 de2acdd8 debf04c0 c01d6220=
 de2acddc c0410910=20
[   58.320025]        c13a5560 de2ace30 de2acdf0 c02e83e4 de2ace28 de2acdf8=
 c015b575 de2ace00=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   58.320025]  [<c02e83e4>] io_schedule+0x14/0x20
[   58.320025]  [<c015b575>] sync_page+0x35/0x60
[   58.320025]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   58.320025]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   58.320025]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   58.320025]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   58.320025]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   58.320025]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   58.320025]  [<c0134016>] ? up_read+0x16/0x30
[   58.320025]  [<c0180281>] do_sync_read+0xd1/0x110
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c02ea9ad>] ? _spin_unlock+0x1d/0x20
[   58.320025]  [<c0180d29>] vfs_read+0x99/0x140
[   58.320025]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   58.320025]  [<c0180e8d>] sys_read+0x3d/0x70
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S db91966c     0  1069    960
[   58.320025]        de051ee8 00000046 de000000 db91966c 00000005 c013b68d=
 de000000 de000260=20
[   58.320025]        dbdffb74 00000005 00000000 00000246 debf1560 00000001=
 00000000 ddfffff8=20
[   58.320025]        00000001 00000000 de051f78 c011ef68 de001720 de000000=
 00000302 de0004ac=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      D 5e6ef0dd     0  1070   1069
[   58.320025]        de348d50 00000046 de001720 5e6ef0dd 00000006 c06939fc=
 00000000 de001980=20
[   58.320025]        5e708933 00000006 00000000 de001720 deadd7c0 de001bcc=
 00000000 7fffffff=20
[   58.320025]        de82ff28 de001720 de348d9c c02e8765 de001bcc de82ff38=
 c02e99f1 de348d74=20
[   58.320025] Call Trace:
[   58.320025]  [<c02e8765>] schedule_timeout+0xa5/0xd0
[   58.320025]  [<c02e99f1>] ? __down+0x51/0x90
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c02e99f8>] __down+0x58/0x90
[   58.320025]  [<c01346ac>] down+0x3c/0x40
[   58.320025]  [<c0254d99>] __driver_attach+0x29/0x80
[   58.320025]  [<c02544fb>] bus_for_each_dev+0x5b/0x80
[   58.320025]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   58.320025]  [<c0254aa9>] driver_attach+0x19/0x20
[   58.320025]  [<c0254d70>] ? __driver_attach+0x0/0x80
[   58.320025]  [<c0253e8f>] bus_add_driver+0x1cf/0x250
[   58.320025]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   58.320025]  [<c0254f9c>] driver_register+0x6c/0x150
[   58.320025]  [<c01fbf5e>] __pci_register_driver+0x4e/0x90
[   58.320025]  [<dfc61017>] i2c_ali1535_init+0x17/0x19 [i2c_ali1535]
[   58.320025]  [<c0144fe4>] sys_init_module+0x114/0x1aa0
[   58.320025]  [<dfcd58d2>] ? snd_interval_ratnum+0x1d2/0x280 [snd_pcm]
[   58.320025]  [<dfcd5a64>] ? snd_interval_list+0xe4/0x170 [snd_pcm]
[   58.320025]  [<dfcc4000>] ? pcmcia_release_socket+0x0/0x20 [pcmcia_core]
[   58.320025]  [<dfcd60f4>] ? snd_pcm_hw_rule_step+0x74/0xe0 [snd_pcm]
[   58.320025]  [<dfcd5d84>] ? snd_pcm_hw_rule_ratdens+0x64/0x2f0 [snd_pcm]
[   58.320025]  [<c0121e70>] ? __request_region+0x0/0xd0
[   58.320025]  [<dfcd611c>] ? snd_pcm_hw_rule_step+0x9c/0xe0 [snd_pcm]
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevsettle    R running      0  1075    905
[   58.320025]        de06cf18 00000046 de014560 b5566a3a 00000006 de01486d=
 de06cf18 de0147c0=20
[   58.320025]        b557f607 00000006 00000000 b85126d3 deadce40 00000000=
 00000282 de06cf44=20
[   58.320025]        00000001 de06cfa4 de06cf2c c02e960e 00000001 00000001=
 00000001 de06cf98=20
[   58.320025] Call Trace:
[   58.320025]  [<c02e960e>] do_nanosleep+0x7e/0xb0
[   58.320025]  [<c0133a1e>] hrtimer_nanosleep+0x9e/0x110
[   58.320025]  [<c01331e0>] ? hrtimer_wakeup+0x0/0x20
[   58.320025]  [<c02e95fb>] ? do_nanosleep+0x6b/0xb0
[   58.320025]  [<c0133af0>] sys_nanosleep+0x60/0x70
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S e165556f     0  1078    960
[   58.320025]        deaccee8 00000046 de092e40 e165556f 00000005 c013b68d=
 de092e40 de0930a0=20
[   58.320025]        e1a3d311 00000005 00000000 00000246 deadda20 00000001=
 00000000 de092e38=20
[   58.320025]        00000001 00000000 deaccf78 c011ef68 de005c80 de092e40=
 00000302 de0932ec=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      R running      0  1079   1078
[   58.320025]        de009f18 00000046 de005c80 b5608af3 00000006 de005f8d=
 de009f18 de005ee0=20
[   58.320025]        b5934b9b 00000006 00000000 bb878fa3 deadcbe0 00000000=
 00000282 de009f44=20
[   58.320025]        00000001 de009fa4 de009f2c c02e960e 00000001 00000001=
 00000001 de009f98=20
[   58.320025] Call Trace:
[   58.320025]  [<c02e960e>] do_nanosleep+0x7e/0xb0
[   58.320025]  [<c0133a1e>] hrtimer_nanosleep+0x9e/0x110
[   58.320025]  [<c01331e0>] ? hrtimer_wakeup+0x0/0x20
[   58.320025]  [<c02e95fb>] ? do_nanosleep+0x6b/0xb0
[   58.320025]  [<c0133af0>] sys_nanosleep+0x60/0x70
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S deb4dfc1     0  1080    960
[   58.320025]        de994ee8 00000046 de074560 deb4dfc1 00000005 c013b68d=
 de074560 de0747c0=20
[   58.320025]        e320051d 00000005 00000000 00000246 deadc4c0 00000001=
 00000000 de074558=20
[   58.320025]        00000001 00000000 de994f78 c011ef68 dea70000 de074560=
 00000302 de074a0c=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      D a8daf7fc     0  1081   1080
[   58.320025]        de05cd50 00000046 dea70000 a8daf7fc 00000006 c06939fc=
 00000000 dea70260=20
[   58.320025]        a8dc479d 00000006 00000000 dea70000 deadc720 dea704ac=
 00000000 7fffffff=20
[   58.320025]        de82ff28 dea70000 de05cd9c c02e8765 dea704ac de82ff38=
 c02e99f1 de05cd74=20
[   58.320025] Call Trace:
[   58.320025]  [<c02e8765>] schedule_timeout+0xa5/0xd0
[   58.320025]  [<c02e99f1>] ? __down+0x51/0x90
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c02e99f8>] __down+0x58/0x90
[   58.320025]  [<c01346ac>] down+0x3c/0x40
[   58.320025]  [<c0254d99>] __driver_attach+0x29/0x80
[   58.320025]  [<c02544fb>] bus_for_each_dev+0x5b/0x80
[   58.320025]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   58.320025]  [<c0254aa9>] driver_attach+0x19/0x20
[   58.320025]  [<c0254d70>] ? __driver_attach+0x0/0x80
[   58.320025]  [<c0253e8f>] bus_add_driver+0x1cf/0x250
[   58.320025]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   58.320025]  [<c0254f9c>] driver_register+0x6c/0x150
[   58.320025]  [<c01fbf5e>] __pci_register_driver+0x4e/0x90
[   58.320025]  [<dfcaa017>] yenta_socket_init+0x17/0x19 [yenta_socket]
[   58.320025]  [<c0144fe4>] sys_init_module+0x114/0x1aa0
[   58.320025]  [<c02527a0>] ? device_remove_file+0x0/0x20
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S e48c6d94     0  1082    960
[   58.320025]        de05eee8 00000046 dea71720 e48c6d94 00000005 c013b68d=
 dea71720 dea71980=20
[   58.320025]        e4c98977 00000005 00000000 00000246 deadc260 00000001=
 00000000 dea71718=20
[   58.320025]        00000001 00000000 de05ef78 c011ef68 dea72e40 dea71720=
 00000302 dea71bcc=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      R running      0  1083   1082
[   58.320025]        de028f18 00000046 dea72e40 b5888d4f 00000006 dea7314d=
 de028f18 dea730a0=20
[   58.320025]        b590c4c2 00000006 00000000 bb85030f de89cbe0 00000000=
 00000282 de028f44=20
[   58.320025]        00000001 de028fa4 de028f2c c02e960e 00000001 00000001=
 00000001 de028f98=20
[   58.320025] Call Trace:
[   58.320025]  [<c02e960e>] do_nanosleep+0x7e/0xb0
[   58.320025]  [<c0133a1e>] hrtimer_nanosleep+0x9e/0x110
[   58.320025]  [<c01331e0>] ? hrtimer_wakeup+0x0/0x20
[   58.320025]  [<c02e95fb>] ? do_nanosleep+0x6b/0xb0
[   58.320025]  [<c0133af0>] sys_nanosleep+0x60/0x70
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S 1a90f2dc     0  1124    960
[   58.320025]        de0cbee8 00000046 de071720 1a90f2dc 00000006 c013b68d=
 de071720 de071980=20
[   58.320025]        271b53c4 00000006 00000000 00000246 deaddc80 00000001=
 00000000 de071718=20
[   58.320025]        00000001 00000000 de0cbf78 c011ef68 dea74560 de071720=
 00000302 de071bcc=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] sh            S 3388d4e9     0  1126   1124
[   58.320025]        dea57ee8 00000046 dea74560 3388d4e9 00000006 c013b68d=
 dea74560 dea747c0=20
[   58.320025]        348c6452 00000006 00000000 00000246 de9bd560 00000001=
 00000000 dea74558=20
[   58.320025]        00000001 00000000 dea57f78 c011ef68 de85c560 dea74560=
 000067c5 dea74a0c=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c0126418>] ? do_sigaction+0xf8/0x1a0
[   58.320025]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      D b2802ac1     0  1135   1126
[   58.320025]        deae0de4 00000046 de85c560 b2802ac1 00000006 c013b68d=
 de85c560 de85c7c0=20
[   58.320025]        b35f83b4 00000006 00000000 deae0dd8 de9bd0a0 c01d6220=
 deae0ddc c0410910=20
[   58.320025]        c13af440 deae0e30 deae0df0 c02e83e4 deae0e28 deae0df8=
 c015b575 deae0e00=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   58.320025]  [<c02e83e4>] io_schedule+0x14/0x20
[   58.320025]  [<c015b575>] sync_page+0x35/0x60
[   58.320025]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   58.320025]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   58.320025]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   58.320025]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   58.320025]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   58.320025]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   58.320025]  [<c0180281>] do_sync_read+0xd1/0x110
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c0105e5b>] ? sys_mmap2+0x5b/0xc0
[   58.320025]  [<c0180d29>] vfs_read+0x99/0x140
[   58.320025]  [<c01e9395>] ? copy_to_user+0x45/0x130
[   58.320025]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   58.320025]  [<c0180e8d>] sys_read+0x3d/0x70
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S 3d7eb847     0  1147    960
[   58.320025]        dea7dee8 00000046 dde29720 3d7eb847 00000006 c013b68d=
 dde29720 dde29980=20
[   58.320025]        40b0b016 00000006 00000000 00000246 de0f7300 00000001=
 00000000 dde29718=20
[   58.320025]        00000001 00000000 dea7df78 c011ef68 dde28000 dde29720=
 00000302 dde29bcc=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c012cf6f>] ? find_get_pid+0x3f/0x60
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] sh            S 4949f9a5     0  1148   1147
[   58.320025]        dea6eee8 00000046 dde28000 4949f9a5 00000006 c013b68d=
 dde28000 dde28260=20
[   58.320025]        4b9633ca 00000006 00000000 00000246 de0f7a20 00000001=
 00000000 dde27ff8=20
[   58.320025]        00000001 00000000 dea6ef78 c011ef68 de015c80 dde28000=
 000067c5 dde284ac=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c011ef68>] do_wait+0x7a8/0xaa0
[   58.320025]  [<c0126418>] ? do_sigaction+0xf8/0x1a0
[   58.320025]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c011f2d4>] sys_wait4+0x74/0xd0
[   58.320025]  [<c011f355>] sys_waitpid+0x25/0x30
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] modprobe      D b167e55f     0  1154   1148
[   58.320025]        dea2dde4 00000046 de015c80 b167e55f 00000006 c013b68d=
 de015c80 de015ee0=20
[   58.320025]        b1b0e7ae 00000006 00000000 dea2ddd8 de9bd7c0 c01d6220=
 dea2dddc c0410910=20
[   58.320025]        c1391e00 dea2de30 dea2ddf0 c02e83e4 dea2de28 dea2ddf8=
 c015b575 dea2de00=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   58.320025]  [<c02e83e4>] io_schedule+0x14/0x20
[   58.320025]  [<c015b575>] sync_page+0x35/0x60
[   58.320025]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   58.320025]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   58.320025]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   58.320025]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   58.320025]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   58.320025]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   58.320025]  [<c0180281>] do_sync_read+0xd1/0x110
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c0180d29>] vfs_read+0x99/0x140
[   58.320025]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   58.320025]  [<c0180e8d>] sys_read+0x3d/0x70
[   58.320025]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] kpsmoused     S 5db68431     0  1166      2
[   58.320025]        de2e2fa4 00000046 de9c8000 5db68431 00000006 de2e2f80=
 c013cf2d de9c8260=20
[   58.320025]        5db6c51d 00000006 00000296 de2e2fb0 de9bc260 de2e2fa4=
 c012fdbe dde19808=20
[   58.320025]        dde197e0 de2e2fb0 de2e2fd0 c012c495 dde19800 00000000=
 de9c8000 c012fbf0=20
[   58.320025] Call Trace:
[   58.320025]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320025]  [<c012fdbe>] ? prepare_to_wait+0x3e/0x70
[   58.320025]  [<c012c495>] worker_thread+0xc5/0xf0
[   58.320025]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320025]  [<c012c3d0>] ? worker_thread+0x0/0xf0
[   58.320025]  [<c012f93a>] kthread+0x3a/0x70
[   58.320025]  [<c012f900>] ? kthread+0x0/0x70
[   58.320025]  [<c010350f>] kernel_thread_helper+0x7/0x18
[   58.320025]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320025] udevd         S ad20cf5e     0  1236    960
[   58.320025]        de9eeb0c 00000046 de9cdc80 ad20cf5e 00000006 c013b68d=
 de9cdc80 de9cdee0=20
[   58.320025]        afcfa001 00000006 00000000 de9eeb00 de9bda20 de896800=
 00000292 00000004=20
[   58.320025]        00000008 00000000 de9eeb58 c02e8765 c012fec7 de9eebd8=
 00000000 de9eeb3c=20
[   58.320025] Call Trace:
[   58.320025]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320025]  [<c02e8765>] schedule_timeout+0xa5/0xd0
[   58.320025]  [<c012fec7>] ? add_wait_queue+0x37/0x50
[   58.320025]  [<c018eafd>] ? __pollwait+0x6d/0xe0
[   58.320025]  [<c018601f>] ? pipe_poll+0x2f/0xb0
[   58.320025]  [<c018e175>] do_select+0x4a5/0x5e0
[   58.320025]  [<c018dcd0>] ? do_select+0x0/0x5e0
[   58.320025]  [<c018ea90>] ? __pollwait+0x0/0xe0
[   58.320025]  [<c0115960>] ? default_wake_function+0x0/0x10
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320025]  [<c02ea842>] ? _read_unlock_irq+0x22/0x30
[   58.320025]  [<c015b83f>] ? find_lock_page+0x7f/0xa0
[   58.320025]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320026]  [<c013d747>] ? __lock_acquire+0x1a7/0xfb0
[   58.320026]  [<c0168f67>] ? __do_fault+0x197/0x380
[   58.320026]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320026]  [<c0168f6f>] ? __do_fault+0x19f/0x380
[   58.320026]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320026]  [<c018e2d7>] ? core_sys_select+0x27/0x360
[   58.320026]  [<c018e496>] core_sys_select+0x1e6/0x360
[   58.320026]  [<c018e2d7>] ? core_sys_select+0x27/0x360
[   58.320026]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320026]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320026]  [<c02ea965>] ? _spin_unlock_irqrestore+0x35/0x60
[   58.320026]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320026]  [<c018e93f>] sys_select+0x3f/0x190
[   58.320026]  [<c010329b>] ? restore_nocheck+0x12/0x15
[   58.320026]  [<c02ec840>] ? do_page_fault+0x0/0x830
[   58.320026]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320026]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320026]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320026] udevd         D a5781daa     0  1237   1236
[   58.320026]        deae3da0 00000046 de9cae40 a5781daa 00000006 c013b68d=
 de9cae40 de9cb0a0=20
[   58.320026]        ad960a7b 00000006 00000000 deae3d94 de9bd300 c01d6220=
 deae3d98 c0410910=20
[   58.320026]        c1391020 deae3dec deae3dac c02e83e4 deae3de4 deae3db4=
 c015b575 deae3dbc=20
[   58.320026] Call Trace:
[   58.320026]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320026]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   58.320026]  [<c02e83e4>] io_schedule+0x14/0x20
[   58.320026]  [<c015b575>] sync_page+0x35/0x60
[   58.320026]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   58.320026]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   58.320026]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   58.320026]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   58.320026]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   58.320026]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   58.320026]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   58.320026]  [<c0180281>] do_sync_read+0xd1/0x110
[   58.320026]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   58.320026]  [<c013d00d>] ? debug_check_no_locks_freed+0x9d/0x150
[   58.320026]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   58.320026]  [<c016d371>] ? __vma_link+0x41/0x70
[   58.320026]  [<c016d3f6>] ? vma_link+0x56/0xf0
[   58.320026]  [<c0180d29>] vfs_read+0x99/0x140
[   58.320026]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   58.320026]  [<c018561a>] kernel_read+0x3a/0x50
[   58.320026]  [<c01856d9>] prepare_binprm+0xa9/0xd0
[   58.320026]  [<c0185d21>] do_execve+0x1a1/0x240
[   58.320026]  [<c01018f3>] sys_execve+0x43/0x70
[   58.320026]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320026]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320026] udevd         ? b6a2896a     0  1252    960
[   58.320026]        de00df50 00000046 de072e40 b6a2896a 00000006 c013b68d=
 de072e40 de0730a0=20
[   58.320026]        b6c45488 00000006 00000000 de00df44 de9bcbe0 c03cfa00=
 de072e40 00000010=20
[   58.320026]        de072e40 00000001 de00df94 c011f94e 00000000 00000000=
 de6a4be0 ddcdfd80=20
[   58.320026] Call Trace:
[   58.320026]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   58.320026]  [<c011f94e>] do_exit+0x53e/0x710
[   58.320026]  [<c011fb4f>] do_group_exit+0x2f/0x90
[   58.320026]  [<c011fbc3>] sys_exit_group+0x13/0x20
[   58.320026]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   58.320026]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320026] udevd         R running      0  1253    960
[   58.320026]        dea5dfb0 00000046 de075c80 b6cef07c 00000006 080600d8=
 dea5dfa8 de075ee4=20
[   58.320026]        b6cf553d 00000006 00000000 dea5dfa4 de9bc000 b7ec3ff4=
 00000046 b7ec3ff4=20
[   58.320026]        080559cd c02ec840 dea5d000 c01032ea b7ec3ff4 00003d3d=
 3d3d3d3d 080559cd=20
[   58.320026] Call Trace:
[   58.320026]  [<c02ec840>] ? do_page_fault+0x0/0x830
[   58.320026]  [<c01032ea>] work_resched+0x5/0x30
[   58.320026]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   58.320026] Sched Debug Version: v0.07, 2.6.26-rc8-1avb #6
[   58.320026] now at 60540.767378 msecs
[   58.320026]   .sysctl_sched_latency                    : 20.000000
[   58.320026]   .sysctl_sched_min_granularity            : 4.000000
[   58.320026]   .sysctl_sched_wakeup_granularity         : 10.000000
[   58.320026]   .sysctl_sched_child_runs_first           : 0.000001
[   58.320026]   .sysctl_sched_features                   : 895
[   58.320026]=20
[   58.320026] cpu#0, 747.687 MHz
[   58.320026]   .nr_running                    : 11
[   58.320026]   .load                          : 198340
[   58.320026]   .nr_switches                   : 10789
[   58.320026]   .nr_load_updates               : 14165
[   58.320026]   .nr_uninterruptible            : 5
[   58.320026]   .jiffies                       : 4294894791
[   58.320026]   .next_balance                  : 0.000000
[   58.320026]   .curr->pid                     : 1054
[   58.320026]   .clock                         : 58316.705834
[   58.320026]   .cpu_load[0]                   : 198340
[   58.320026]   .cpu_load[1]                   : 198340
[   58.320026]   .cpu_load[2]                   : 198340
[   58.320026]   .cpu_load[3]                   : 198340
[   58.320026]   .cpu_load[4]                   : 198340
[   58.320026]=20
[   58.320026] cfs_rq[0]:
[   58.320026]   .exec_clock                    : 46509.620486
[   58.320026]   .MIN_vruntime                  : 11100.368286
[   58.320026]   .min_vruntime                  : 8513.874346
[   58.320026]   .max_vruntime                  : 11149.105542
[   58.320026]   .spread                        : 48.737256
[   58.320026]   .spread0                       : 0.000000
[   58.320026]   .nr_running                    : 10
[   58.320026]   .load                          : 20818
[   58.320026]   .bkl_count                     : 0
[   58.320026]   .nr_spread_over                : 33
[   58.320026]=20
[   58.320026] runnable tasks:
[   58.320026]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[   58.320026] ------------------------------------------------------------=
=2D---------------------------------------------
[   58.320026]       watchdog/0     4         1.212733         8     0     =
    1.212733         0.393162         0.029773
[   58.320026]         events/0     5     11120.115860       123   115     =
11120.115860         9.492749     52205.957266
[   58.320026]        kblockd/0    39     11124.304754       744   115     =
11124.304754        36.535713     28226.864834
[   58.320026]           kacpid    41     11100.368286         5   115     =
11100.368286         6.311670     43931.786247
[   58.320026]            udevd   960     11149.105542       248   116     =
11149.105542       460.966881       258.525566
[   58.320026] R       modprobe  1054     30153.604213        29   118     =
30153.604213     29795.168980      1057.612071
[   58.320026]         modprobe  1066     11129.105542        83   118     =
11129.105542       174.110297      2749.024671
[   58.320026]       udevsettle  1075     11120.368286        68   120     =
11120.368286        12.454980      3387.241480
[   58.320026]         modprobe  1079     11123.455590        75   118     =
11123.455590        74.767454      3152.972631
[   58.320026]         modprobe  1083     11122.877599        73   118     =
11122.877599        62.496969      2977.616936
[   58.320026]            udevd  1253     11148.798902         2   118     =
11148.798902         1.495564         0.000000
[   58.320026]=20
[   67.677809] SysRq : HELP : loglevel0-8 reBoot show-all-locks(D) tErm Ful=
l kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showT=
asks Unmount shoW-blocked-tasks=20
[   77.361220] SysRq : Show Locks Held
[   77.363356]=20
[   77.363356] Showing all locks held in the system:
[   77.363356] 5 locks held by modprobe/1054:
[   77.363356]  #0:  (&serio->lock){++..}, at: [<c0267d11>] serio_interrupt=
+0x21/0x80
[   77.363356]  #1:  (&dev->event_lock){++..}, at: [<c026c498>] input_event=
+0x48/0x80
[   77.363356]  #2:  (rcu_read_lock){..--}, at: [<c026ab80>] input_pass_eve=
nt+0x0/0xb0
[   77.363356]  #3:  (sysrq_key_table_lock){++..}, at: [<c025015a>] __handl=
e_sysrq+0x1a/0x150
[   77.363356]  #4:  (tasklist_lock){..??}, at: [<c013c157>] debug_show_all=
_locks+0x37/0x190
[   77.363356]=20
[   77.363356] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   77.363356]=20
[   83.195391] SysRq : Show Blocked State
[   83.196709]   task                PC stack   pid father
[   83.196709] modprobe      D 5e6ef0dd     0  1070   1069
[   83.196709]        de348d50 00000046 de001720 5e6ef0dd 00000006 c06939fc=
 00000000 de001980=20
[   83.196709]        5e708933 00000006 00000000 de001720 deadd7c0 de001bcc=
 00000000 7fffffff=20
[   83.196709]        de82ff28 de001720 de348d9c c02e8765 de001bcc de82ff38=
 c02e99f1 de348d74=20
[   83.196709] Call Trace:
[   83.196709]  [<c02e8765>] schedule_timeout+0xa5/0xd0
[   83.196709]  [<c02e99f1>] ? __down+0x51/0x90
[   83.196709]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   83.196709]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   83.196709]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   83.196709]  [<c02e99f8>] __down+0x58/0x90
[   83.196709]  [<c01346ac>] down+0x3c/0x40
[   83.196709]  [<c0254d99>] __driver_attach+0x29/0x80
[   83.196709]  [<c02544fb>] bus_for_each_dev+0x5b/0x80
[   83.196709]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   83.196709]  [<c0254aa9>] driver_attach+0x19/0x20
[   83.196709]  [<c0254d70>] ? __driver_attach+0x0/0x80
[   83.196709]  [<c0253e8f>] bus_add_driver+0x1cf/0x250
[   83.196709]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   83.196709]  [<c0254f9c>] driver_register+0x6c/0x150
[   83.196709]  [<c01fbf5e>] __pci_register_driver+0x4e/0x90
[   83.196709]  [<dfc61017>] i2c_ali1535_init+0x17/0x19 [i2c_ali1535]
[   83.196709]  [<c0144fe4>] sys_init_module+0x114/0x1aa0
[   83.196709]  [<dfcd58d2>] ? snd_interval_ratnum+0x1d2/0x280 [snd_pcm]
[   83.196709]  [<dfcd5a64>] ? snd_interval_list+0xe4/0x170 [snd_pcm]
[   83.196709]  [<dfcc4000>] ? pcmcia_release_socket+0x0/0x20 [pcmcia_core]
[   83.196709]  [<dfcd60f4>] ? snd_pcm_hw_rule_step+0x74/0xe0 [snd_pcm]
[   83.196709]  [<dfcd5d84>] ? snd_pcm_hw_rule_ratdens+0x64/0x2f0 [snd_pcm]
[   83.196709]  [<c0121e70>] ? __request_region+0x0/0xd0
[   83.196709]  [<dfcd611c>] ? snd_pcm_hw_rule_step+0x9c/0xe0 [snd_pcm]
[   83.196709]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   83.196709]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   83.196709] modprobe      D a8daf7fc     0  1081   1080
[   83.196709]        de05cd50 00000046 dea70000 a8daf7fc 00000006 c06939fc=
 00000000 dea70260=20
[   83.196709]        a8dc479d 00000006 00000000 dea70000 deadc720 dea704ac=
 00000000 7fffffff=20
[   83.196709]        de82ff28 dea70000 de05cd9c c02e8765 dea704ac de82ff38=
 c02e99f1 de05cd74=20
[   83.196709] Call Trace:
[   83.196709]  [<c02e8765>] schedule_timeout+0xa5/0xd0
[   83.196709]  [<c02e99f1>] ? __down+0x51/0x90
[   83.196709]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   83.196709]  [<c02ea922>] ? _spin_unlock_irq+0x22/0x30
[   83.196709]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   83.196709]  [<c02e99f8>] __down+0x58/0x90
[   83.196709]  [<c01346ac>] down+0x3c/0x40
[   83.196709]  [<c0254d99>] __driver_attach+0x29/0x80
[   83.196709]  [<c02544fb>] bus_for_each_dev+0x5b/0x80
[   83.196709]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   83.196709]  [<c0254aa9>] driver_attach+0x19/0x20
[   83.196709]  [<c0254d70>] ? __driver_attach+0x0/0x80
[   83.196709]  [<c0253e8f>] bus_add_driver+0x1cf/0x250
[   83.196709]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   83.196709]  [<c0254f9c>] driver_register+0x6c/0x150
[   83.196709]  [<c01fbf5e>] __pci_register_driver+0x4e/0x90
[   83.196709]  [<dfcaa017>] yenta_socket_init+0x17/0x19 [yenta_socket]
[   83.196709]  [<c0144fe4>] sys_init_module+0x114/0x1aa0
[   83.196709]  [<c02527a0>] ? device_remove_file+0x0/0x20
[   83.196709]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   83.196709]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   83.196709] modprobe      D b2802ac1     0  1135   1126
[   83.196709]        deae0de4 00000046 de85c560 b2802ac1 00000006 c013b68d=
 de85c560 de85c7c0=20
[   83.196709]        b35f83b4 00000006 00000000 deae0dd8 de9bd0a0 c01d6220=
 deae0ddc c0410910=20
[   83.196709]        c13af440 deae0e30 deae0df0 c02e83e4 deae0e28 deae0df8=
 c015b575 deae0e00=20
[   83.196709] Call Trace:
[   83.196709]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   83.196709]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   83.196709]  [<c02e83e4>] io_schedule+0x14/0x20
[   83.196709]  [<c015b575>] sync_page+0x35/0x60
[   83.196709]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   83.196709]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   83.196709]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   83.196709]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   83.196709]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   83.196709]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   83.196709]  [<c0180281>] do_sync_read+0xd1/0x110
[   83.196709]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   83.196709]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   83.196709]  [<c0105e5b>] ? sys_mmap2+0x5b/0xc0
[   83.196709]  [<c0180d29>] vfs_read+0x99/0x140
[   83.196709]  [<c01e9395>] ? copy_to_user+0x45/0x130
[   83.196709]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   83.196709]  [<c0180e8d>] sys_read+0x3d/0x70
[   83.196709]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   83.196709]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   83.196709] modprobe      D b167e55f     0  1154   1148
[   83.196709]        dea2dde4 00000046 de015c80 b167e55f 00000006 c013b68d=
 de015c80 de015ee0=20
[   83.196709]        b1b0e7ae 00000006 00000000 dea2ddd8 de9bd7c0 c01d6220=
 dea2dddc c0410910=20
[   83.196709]        c1391e00 dea2de30 dea2ddf0 c02e83e4 dea2de28 dea2ddf8=
 c015b575 dea2de00=20
[   83.196709] Call Trace:
[   83.196709]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   83.196709]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   83.196709]  [<c02e83e4>] io_schedule+0x14/0x20
[   83.196709]  [<c015b575>] sync_page+0x35/0x60
[   83.196709]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   83.196709]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   83.196709]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   83.196709]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   83.196709]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   83.196709]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   83.196709]  [<c0180281>] do_sync_read+0xd1/0x110
[   83.196709]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   83.196709]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   83.196709]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   83.196709]  [<c0180d29>] vfs_read+0x99/0x140
[   83.196709]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   83.196709]  [<c0180e8d>] sys_read+0x3d/0x70
[   83.196709]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   83.196709]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   83.196709] udevd         D a5781daa     0  1237   1236
[   83.196709]        deae3da0 00000046 de9cae40 a5781daa 00000006 c013b68d=
 de9cae40 de9cb0a0=20
[   83.196709]        ad960a7b 00000006 00000000 deae3d94 de9bd300 c01d6220=
 deae3d98 c0410910=20
[   83.196709]        c1391020 deae3dec deae3dac c02e83e4 deae3de4 deae3db4=
 c015b575 deae3dbc=20
[   83.196709] Call Trace:
[   83.196709]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[   83.196709]  [<c01d6220>] ? blk_backing_dev_unplug+0x0/0x10
[   83.196709]  [<c02e83e4>] io_schedule+0x14/0x20
[   83.196709]  [<c015b575>] sync_page+0x35/0x60
[   83.196709]  [<c015b5a8>] sync_page_killable+0x8/0x40
[   83.196709]  [<c02e8839>] __wait_on_bit_lock+0x49/0x80
[   83.196709]  [<c015b5a0>] ? sync_page_killable+0x0/0x40
[   83.196709]  [<c015b47a>] __lock_page_killable+0xaa/0xb0
[   83.196709]  [<c012fc40>] ? wake_bit_function+0x0/0x60
[   83.196709]  [<c015da9f>] generic_file_aio_read+0x37f/0x5e0
[   83.196709]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   83.196709]  [<c0180281>] do_sync_read+0xd1/0x110
[   83.196709]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[   83.196709]  [<c013d00d>] ? debug_check_no_locks_freed+0x9d/0x150
[   83.196709]  [<c012fbf0>] ? autoremove_wake_function+0x0/0x50
[   83.196709]  [<c016d371>] ? __vma_link+0x41/0x70
[   83.196709]  [<c016d3f6>] ? vma_link+0x56/0xf0
[   83.196709]  [<c0180d29>] vfs_read+0x99/0x140
[   83.196709]  [<c01801b0>] ? do_sync_read+0x0/0x110
[   83.196709]  [<c018561a>] kernel_read+0x3a/0x50
[   83.196709]  [<c01856d9>] prepare_binprm+0xa9/0xd0
[   83.196709]  [<c0185d21>] do_execve+0x1a1/0x240
[   83.196709]  [<c01018f3>] sys_execve+0x43/0x70
[   83.196709]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   83.196709]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   83.196709] Sched Debug Version: v0.07, 2.6.26-rc8-1avb #6
[   83.196709] now at 86235.679635 msecs
[   83.196709]   .sysctl_sched_latency                    : 20.000000
[   83.196709]   .sysctl_sched_min_granularity            : 4.000000
[   83.196709]   .sysctl_sched_wakeup_granularity         : 10.000000
[   83.196709]   .sysctl_sched_child_runs_first           : 0.000001
[   83.196709]   .sysctl_sched_features                   : 895
[   83.196709]=20
[   83.196709] cpu#0, 747.687 MHz
[   83.196709]   .nr_running                    : 11
[   83.196709]   .load                          : 198340
[   83.196709]   .nr_switches                   : 10789
[   83.196709]   .nr_load_updates               : 20617
[   83.196709]   .nr_uninterruptible            : 5
[   83.196709]   .jiffies                       : 4294902254
[   83.196709]   .next_balance                  : 0.000000
[   83.196709]   .curr->pid                     : 1054
[   83.196709]   .clock                         : 83193.385151
[   83.196709]   .cpu_load[0]                   : 198340
[   83.196709]   .cpu_load[1]                   : 198340
[   83.196709]   .cpu_load[2]                   : 198340
[   83.196709]   .cpu_load[3]                   : 198340
[   83.196709]   .cpu_load[4]                   : 198340
[   83.196709]=20
[   83.196709] cfs_rq[0]:
[   83.196709]   .exec_clock                    : 71386.299803
[   83.196709]   .MIN_vruntime                  : 11100.368286
[   83.196709]   .min_vruntime                  : 8513.874346
[   83.196709]   .max_vruntime                  : 11149.105542
[   83.196709]   .spread                        : 48.737256
[   83.196709]   .spread0                       : 0.000000
[   83.196709]   .nr_running                    : 10
[   83.196709]   .load                          : 20818
[   83.196709]   .bkl_count                     : 0
[   83.196709]   .nr_spread_over                : 33
[   83.196709]=20
[   83.196709] runnable tasks:
[   83.196709]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[   83.196709] ------------------------------------------------------------=
=2D---------------------------------------------
[   83.196709]       watchdog/0     4         1.212733         8     0     =
    1.212733         0.393162         0.029773
[   83.196709]         events/0     5     11120.115860       123   115     =
11120.115860         9.492749     52205.957266
[   83.196709]        kblockd/0    39     11124.304754       744   115     =
11124.304754        36.535713     28226.864834
[   83.196709]           kacpid    41     11100.368286         5   115     =
11100.368286         6.311670     43931.786247
[   83.196709]            udevd   960     11149.105542       248   116     =
11149.105542       460.966881       258.525566
[   83.196709] R       modprobe  1054     46215.218078        29   118     =
46215.218078     54671.848297      1057.612071
[   83.196709]         modprobe  1066     11129.105542        83   118     =
11129.105542       174.110297      2749.024671
[   83.196709]       udevsettle  1075     11120.368286        68   120     =
11120.368286        12.454980      3387.241480
[   83.196709]         modprobe  1079     11123.455590        75   118     =
11123.455590        74.767454      3152.972631
[   83.196709]         modprobe  1083     11122.877599        73   118     =
11122.877599        62.496969      2977.616936
[   83.196709]            udevd  1253     11148.798902         2   118     =
11148.798902         1.495564         0.000000
[   83.196709]=20
[   88.367739] SysRq : HELP : loglevel0-8 reBoot show-all-locks(D) tErm Ful=
l kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showT=
asks Unmount shoW-blocked-tasks=20
[   96.044467] SysRq : Show Regs
[   96.046699]=20
[   96.046699] Pid: 1054, comm: modprobe Not tainted (2.6.26-rc8-1avb #6)
[   96.046699] EIP: 0060:[<c01215a3>] EFLAGS: 00000206 CPU: 0
[   96.046699] EIP is at __do_softirq+0x43/0xc0
[   96.046699] EAX: 000027d2 EBX: c0431400 ECX: 00000000 EDX: 00000001
[   96.046699] ESI: 00000102 EDI: 0000000a EBP: c0406ff8 ESP: c0406fec
[   96.046699]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   96.046699] CR0: 8005003b CR2: 080559cd CR3: 1e089000 CR4: 00000690
[   96.046699] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   96.046699] DR6: ffff0ff0 DR7: 00000400
[   96.046699]  [<c0104a7e>] do_softirq+0x8e/0xd0
[   96.046699]  [<c0158120>] ? handle_level_irq+0x0/0xe0
[   96.046699]  [<c0121115>] irq_exit+0x65/0x90
[   96.046699]  [<c0104c1d>] do_IRQ+0x9d/0x110
[   96.046699]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[   96.046699]  [<c010342e>] common_interrupt+0x2e/0x34
[   96.046699]  [<dfc5007b>] ? agp_3_5_enable+0x46b/0x7b0 [agpgart]
[   96.046699]  [<c0130000>] ? __kfifo_put+0x60/0x90
[   96.046699]  [<c02ea967>] ? _spin_unlock_irqrestore+0x37/0x60
[   96.046699]  [<dfc752cb>] ohci_hub_status_data+0x26b/0x470 [ohci_hcd]
[   96.046699]  [<c01c3528>] ? sysfs_add_file_mode+0x58/0x90
[   96.046699]  [<df855d15>] usb_hcd_poll_rh_status+0x45/0x150 [usbcore]
[   96.046699]  [<df8561f8>] usb_add_hcd+0x3d8/0x650 [usbcore]
[   96.046699]  [<c027683f>] ? pcibios_set_master+0x1f/0x90
[   96.046699]  [<df8617a1>] usb_hcd_pci_probe+0x131/0x2c0 [usbcore]
[   96.046699]  [<c02ea9ad>] ? _spin_unlock+0x1d/0x20
[   96.046699]  [<df861670>] ? usb_hcd_pci_probe+0x0/0x2c0 [usbcore]
[   96.046699]  [<c01fbd2e>] pci_device_probe+0x5e/0x80
[   96.046699]  [<c0254c47>] driver_probe_device+0x87/0x1b0
[   96.046699]  [<c0254de9>] __driver_attach+0x79/0x80
[   96.046699]  [<c02544fb>] bus_for_each_dev+0x5b/0x80
[   96.046699]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   96.046699]  [<c0254aa9>] driver_attach+0x19/0x20
[   96.046699]  [<c0254d70>] ? __driver_attach+0x0/0x80
[   96.046699]  [<c0253e8f>] bus_add_driver+0x1cf/0x250
[   96.046699]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[   96.046699]  [<c0254f9c>] driver_register+0x6c/0x150
[   96.046699]  [<c01fbf5e>] __pci_register_driver+0x4e/0x90
[   96.046699]  [<dfc56041>] ohci_hcd_mod_init+0x41/0x45 [ohci_hcd]
[   96.046699]  [<c0144fe4>] sys_init_module+0x114/0x1aa0
[   96.046699]  [<dfc96000>] ? snd_minor_info_read+0x0/0x290 [snd]
[   96.046699]  [<df850960>] ? usb_root_hub_lost_power+0x0/0x40 [usbcore]
[   96.046699]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[   96.046699]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[  104.163876] SysRq : Emergency Remount R/O
[  104.808448] SysRq : Emergency Sync
[  105.407702] SysRq : Resetting

<=3D Power button pressed

[  117.510302] BUG: spinlock trylock failure on UP on CPU#0, modprobe/1054
[  117.513343]  lock: c03c2040, .magic: dead4ead, .owner: modprobe/1054, .o=
wner_cpu: 0
[  117.513343] Pid: 1054, comm: modprobe Not tainted 2.6.26-rc8-1avb #6
[  117.513343]  [<c01f6c4d>] spin_bug+0x9d/0xe0
[  117.513343]  [<c01f6d25>] _raw_spin_trylock+0x25/0x50
[  117.513343]  [<c02eabf5>] _spin_lock_irqsave+0x45/0x70
[  117.513343]  [<c025015a>] ? __handle_sysrq+0x1a/0x150
[  117.513343]  [<c025015a>] __handle_sysrq+0x1a/0x150
[  117.513343]  [<c02502b1>] handle_sysrq+0x21/0x30
[  117.513343]  [<c0248b07>] kbd_event+0x3d7/0x770
[  117.513343]  [<c026ac2c>] input_pass_event+0xac/0xb0
[  117.513343]  [<c026ab80>] ? input_pass_event+0x0/0xb0
[  117.513343]  [<c026b762>] input_handle_event+0xa2/0x450
[  117.513343]  [<c02eac11>] ? _spin_lock_irqsave+0x61/0x70
[  117.513343]  [<c026c4b8>] input_event+0x68/0x80
[  117.513343]  [<dfc651a5>] acpi_button_notify+0x59/0xb9 [button]
[  117.513343]  [<dfc65221>] acpi_button_notify_fixed+0x1c/0x20 [button]
[  117.513343]  [<c0217b5e>] acpi_ev_fixed_event_detect+0xb6/0xcb
[  117.513343]  [<c0218562>] acpi_ev_sci_xrupt_handler+0xc/0x1b
[  117.513343]  [<c0211c92>] acpi_irq+0xe/0x23
[  117.513343]  [<c0156dd9>] handle_IRQ_event+0x29/0x60
[  117.513343]  [<c0158189>] handle_level_irq+0x69/0xe0
[  117.513343]  [<c0104c43>] do_IRQ+0xc3/0x110
[  117.513343]  [<c010342e>] common_interrupt+0x2e/0x34
[  117.513343]  [<c012b440>] ? emergency_restart+0x0/0x10
[  117.513343]  [<c0250483>] ? sysrq_handle_reboot+0x13/0x20
[  117.513343]  [<c0250235>] __handle_sysrq+0xf5/0x150
[  117.513343]  [<c02502b1>] handle_sysrq+0x21/0x30
[  117.513343]  [<c0248b07>] kbd_event+0x3d7/0x770
[  117.513343]  [<c02ea97f>] ? _spin_unlock_irqrestore+0x4f/0x60
[  117.513343]  [<c026ac2c>] input_pass_event+0xac/0xb0
[  117.513343]  [<c026ab80>] ? input_pass_event+0x0/0xb0
[  117.513343]  [<c026b762>] input_handle_event+0xa2/0x450
[  117.513343]  [<c026c4b8>] input_event+0x68/0x80
[  117.513343]  [<c026fe29>] atkbd_interrupt+0x5d9/0x660
[  117.513343]  [<c0267d29>] serio_interrupt+0x39/0x80
[  117.513343]  [<c0268873>] i8042_interrupt+0xb3/0x260
[  117.513343]  [<c01074c7>] ? native_sched_clock+0x77/0xb0
[  117.513343]  [<c0158180>] ? handle_level_irq+0x60/0xe0
[  117.513343]  [<c013b68d>] ? lock_release_holdtime+0x2d/0x1b0
[  117.513343]  [<c0156dd9>] handle_IRQ_event+0x29/0x60
[  117.513343]  [<c0158189>] handle_level_irq+0x69/0xe0
[  117.513343]  [<c0158120>] ? handle_level_irq+0x0/0xe0
[  117.513343]  [<c0104c16>] do_IRQ+0x96/0x110
[  117.513343]  [<c013cea5>] ? trace_hardirqs_on+0x75/0x140
[  117.513343]  [<c010342e>] common_interrupt+0x2e/0x34
[  117.513343]  [<c0130000>] ? __kfifo_put+0x60/0x90
[  117.513343]  [<c01215a3>] ? __do_softirq+0x43/0xc0
[  117.513343]  [<c0104a7e>] do_softirq+0x8e/0xd0
[  117.513343]  [<c0158120>] ? handle_level_irq+0x0/0xe0
[  117.513343]  [<c0121115>] irq_exit+0x65/0x90
[  117.513343]  [<c0104c1d>] do_IRQ+0x9d/0x110
[  117.513343]  [<c013cf2d>] ? trace_hardirqs_on+0xfd/0x140
[  117.513343]  [<c010342e>] common_interrupt+0x2e/0x34
[  117.513343]  [<dfc5007b>] ? agp_3_5_enable+0x46b/0x7b0 [agpgart]
[  117.513343]  [<c0130000>] ? __kfifo_put+0x60/0x90
[  117.513343]  [<c02ea967>] ? _spin_unlock_irqrestore+0x37/0x60
[  117.513343]  [<dfc752cb>] ohci_hub_status_data+0x26b/0x470 [ohci_hcd]
[  117.513343]  [<c01c3528>] ? sysfs_add_file_mode+0x58/0x90
[  117.513343]  [<df855d15>] usb_hcd_poll_rh_status+0x45/0x150 [usbcore]
[  117.513343]  [<df8561f8>] usb_add_hcd+0x3d8/0x650 [usbcore]
[  117.513343]  [<c027683f>] ? pcibios_set_master+0x1f/0x90
[  117.513343]  [<df8617a1>] usb_hcd_pci_probe+0x131/0x2c0 [usbcore]
[  117.513343]  [<c02ea9ad>] ? _spin_unlock+0x1d/0x20
[  117.513343]  [<df861670>] ? usb_hcd_pci_probe+0x0/0x2c0 [usbcore]
[  117.513343]  [<c01fbd2e>] pci_device_probe+0x5e/0x80
[  117.513343]  [<c0254c47>] driver_probe_device+0x87/0x1b0
[  117.513343]  [<c0254de9>] __driver_attach+0x79/0x80
[  117.513343]  [<c02544fb>] bus_for_each_dev+0x5b/0x80
[  117.513343]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[  117.513343]  [<c0254aa9>] driver_attach+0x19/0x20
[  117.513343]  [<c0254d70>] ? __driver_attach+0x0/0x80
[  117.513343]  [<c0253e8f>] bus_add_driver+0x1cf/0x250
[  117.513343]  [<c01fbc70>] ? pci_device_remove+0x0/0x40
[  117.513343]  [<c0254f9c>] driver_register+0x6c/0x150
[  117.513343]  [<c01fbf5e>] __pci_register_driver+0x4e/0x90
[  117.513343]  [<dfc56041>] ohci_hcd_mod_init+0x41/0x45 [ohci_hcd]
[  117.513343]  [<c0144fe4>] sys_init_module+0x114/0x1aa0
[  117.513343]  [<dfc96000>] ? snd_minor_info_read+0x0/0x290 [snd]
[  117.513343]  [<df850960>] ? usb_root_hub_lost_power+0x0/0x40 [usbcore]
[  117.513343]  [<c01031b1>] sysenter_past_esp+0x6a/0xb1
[  117.513343]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

--Boundary-01=_g3xbI0qrhVoFVyj
Content-Type: text/plain;
  charset="us-ascii";
  name="config-2.6.25-1avb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config-2.6.25-1avb"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc7
# Wed Mar 26 07:30:46 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
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
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
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
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
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
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
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
# CONFIG_MWINCHIP2 is not set
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
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
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
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
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
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
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
# CONFIG_COMPAT_VDSO is not set

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
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
CONFIG_ACPI_DOCK=m
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
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
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
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
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
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
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

#
# Networking
#
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
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
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
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

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
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
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
# CONFIG_WDC_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
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
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

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
CONFIG_SCSI_CONSTANTS=y
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
# CONFIG_ISCSI_TCP is not set
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
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
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
CONFIG_DM_MULTIPATH_EMC=m
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
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
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
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
# CONFIG_NETCONSOLE_DYNAMIC is not set
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
# CONFIG_INPUT_POLLDEV is not set

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
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
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
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
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
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
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
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
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
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
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

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
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
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
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
# CONFIG_FB_EFI is not set
# CONFIG_FB_HECUBA is not set
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
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
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
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
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
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
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
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=60

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
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
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
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
CONFIG_USB_PERSIST=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
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
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
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
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
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
# CONFIG_USB_AUERSWALD is not set
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
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# Conflicting RTC option has been selected, check GEN_RTC and RTC
#

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

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

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
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
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
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

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
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
# CONFIG_CODA_FS_OLD_API is not set
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
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
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
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_ITU_T is not set
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

--Boundary-01=_g3xbI0qrhVoFVyj
Content-Type: text/plain;
  charset="us-ascii";
  name="config-2.6.26-rc8-1avb"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config-2.6.26-rc8-1avb"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26-rc8
# Fri Jul  4 20:35:39 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
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
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
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
# CONFIG_TASKSTATS is not set
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
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_PROC_PAGE_MONITOR=y
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
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
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
# CONFIG_MWINCHIP2 is not set
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
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
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
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
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
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
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
# CONFIG_COMPAT_VDSO is not set

#
# Power management options
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
CONFIG_ACPI_DOCK=m
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
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
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
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
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
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
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

#
# Networking
#
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
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

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
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_IDE_MAX_HWIFS=4
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
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
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
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
# CONFIG_BLK_DEV_HD_ONLY is not set
# CONFIG_BLK_DEV_HD is not set

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
CONFIG_SCSI_CONSTANTS=y
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
# CONFIG_ISCSI_TCP is not set
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
CONFIG_DM_MULTIPATH_EMC=m
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
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
# CONFIG_NETDEVICES_MULTIQUEUE is not set
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
# CONFIG_NETCONSOLE_DYNAMIC is not set
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
# CONFIG_INPUT_POLLDEV is not set

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
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
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
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
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
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_PCA_PLATFORM is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
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
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
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

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set

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
# CONFIG_FB_EFI is not set
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
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
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
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
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
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
# CONFIG_SND_PCSP is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
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
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=60

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# ALSA SoC audio for Freescale SOCs
#

#
# SoC Audio for the Texas Instruments OMAP
#

#
# Open Sound System
#
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
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
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

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
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
# CONFIG_USB_MON is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
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
# CONFIG_USB_AUERSWALD is not set
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
# CONFIG_USB_GADGET is not set
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

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
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
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
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
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

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
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
# CONFIG_CODA_FS_OLD_API is not set
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
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
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
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_NONPROMISC_DEVMEM=y
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

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=m
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
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
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

--Boundary-01=_g3xbI0qrhVoFVyj--

--nextPart13658582.hNpfZ8aqIt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhvHeAACgkQR6LMutpd94z0zgCgyDh+du+LQmyctIZdxSvqExti
nDcAoIhj8dSs7vNZ3DdCYWrWokfmHTsv
=f9FO
-----END PGP SIGNATURE-----

--nextPart13658582.hNpfZ8aqIt--
