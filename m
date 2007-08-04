Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbXHDSif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbXHDSif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765005AbXHDSiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:38:16 -0400
Received: from mx5.mail.ru ([194.67.23.25]:1401 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbXHDSiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:38:09 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.23-rc2: check_irq_resend on resume (ali15x3)
Date: Sat, 4 Aug 2007 22:37:59 +0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18833763.pu9pzsvt1L";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708042238.00368.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18833763.pu9pzsvt1L
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Just noticed this; I do not remember having seen it before, but I also do n=
ot=20
check dmesg every time after resume.

[   54.154078] pnp: Failed to activate device 00:05.
[   54.154120] pnp: Failed to activate device 00:06.
[   54.159608] pnp: Device 00:09 activated.
[   54.205284] WARNING: at /home/bor/src/linux-git/kernel/irq/resend.c:70=20
check_irq_resend()
[   54.205299]  [<c01047fa>] show_trace_log_lvl+0x1a/0x30
[   54.205332]  [<c0105292>] show_trace+0x12/0x20
[   54.205343]  [<c01052f5>] dump_stack+0x15/0x20
[   54.205353]  [<c014ce7e>] check_irq_resend+0x9e/0xb0
[   54.205388]  [<c014c991>] enable_irq+0xb1/0xc0
[   54.205397]  [<df82f6fa>] ide_config_drive_speed+0x18a/0x3e0 [ide_core]
[   54.205570]  [<df80f3cc>] ali15x3_tune_drive+0x1c/0x20 [alim15x3]
[   54.205592]  [<df82da33>] ide_do_request+0x8a3/0xa10 [ide_core]
[   54.205623]  [<df82dc60>] ide_do_drive_cmd+0xc0/0x110 [ide_core]
[   54.205652]  [<df82c868>] generic_ide_resume+0x98/0xe0 [ide_core]
[   54.205681]  [<c023793c>] resume_device+0x4c/0xa0
[   54.205717]  [<c02379ee>] dpm_resume+0x5e/0x90
[   54.205727]  [<c0237a46>] device_resume+0x26/0x40
[   54.205736]  [<c0141849>] hibernation_snapshot+0x69/0xd0
[   54.205747]  [<c0141a1c>] hibernate+0xac/0x170
[   54.205755]  [<c01407ae>] state_store+0xbe/0xd0
[   54.205764]  [<c01ab2d2>] subsys_attr_store+0x32/0x50
[   54.205784]  [<c01ab5ab>] sysfs_write_file+0xdb/0x120
[   54.205795]  [<c016f8b9>] vfs_write+0x99/0x130
[   54.205819]  [<c016fe2d>] sys_write+0x3d/0x70
[   54.205829]  [<c0104112>] sysenter_past_esp+0x5f/0x99
[   54.205839]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   54.206084] hda: selected mode 0x42
[   54.225580] hdc: selected mode 0x42
[   54.228619] usb usb1: root hub lost power or was reset
[   54.714012] eth1: PRI 31 variant 2 version 9.48
[   54.714075] eth1: NIC 5 variant 2 version 1.02
[   54.810451] Restarting tasks ... <5>toshiba_acpi: Re-enabled hotkeys
[   54.925054] done.
[   54.925134] swsusp: Basic memory bitmaps freed
[   59.560144] eth1: PRI 31 variant 2 version 9.48
[   59.560231] eth1: NIC 5 variant 2 version 1.02
[   59.835398] eth1: PRI 31 variant 2 version 9.48
[   59.835487] eth1: NIC 5 variant 2 version 1.02
[   60.079468] eth1: PRI 31 variant 2 version 9.48
[   60.079553] eth1: NIC 5 variant 2 version 1.02

PnP:

{pts/1}% lspnp
00:00 PNP0c01 System board
00:01 PNP0a03 PCI bus
00:02 PNP0200 AT DMA controller
00:03 PNP0800 AT speaker
00:04 PNP0c04 Math coprocessor
00:05 PNP0303 IBM enhanced keyboard (101/102-key, PS/2 mouse support)
00:06 PNP0f13 PS/2 port for PS/2-style mice
00:07 PNP0b00 AT real-time clock
00:08 PNP0c02 Motherboard resources
00:09 PNP0501 16550A-compatible serial port
00:0a SMCf010 SMC Fast Infrared Port
00:0b PNP0401 ECP printer port

PCI

{pts/1}% sudo lspci -nnv
00:00.0 Host bridge [0600]: ALi Corporation M1644/M1644T Northbridge+Triden=
t=20
[10b9:1644] (rev 01)
        Flags: bus master, medium devsel, latency 0
        Memory at f0000000 (32-bit, prefetchable) [size=3D64M]
        Capabilities: [b0] AGP version 2.0
        Capabilities: [a4] Power Management version 1

00:01.0 PCI bridge [0604]: ALi Corporation PCI to AGP Controller [10b9:5247=
]=20
(prog-if 00 [Normal decode])
        Flags: bus master, slow devsel, latency 0
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
        Memory behind bridge: f7f00000-fdffffff
        Prefetchable memory behind bridge: 48000000-480fffff

00:02.0 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:523=
7]=20
(rev 03) (prog-if 10 [OHCI])
        Subsystem: Toshiba America Info Systems Unknown device [1179:0004]
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at f7eff000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [60] Power Management version 2

00:04.0 IDE interface [0101]: ALi Corporation M5229 IDE [10b9:5229] (rev c3=
)=20
(prog-if f0)
        Subsystem: Toshiba America Info Systems Unknown device [1179:0004]
        Flags: bus master, medium devsel, latency 64, IRQ 255
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled]=
=20
[size=3D8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled]=
=20
[size=3D1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled]=
=20
[size=3D8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled]=
=20
[size=3D1]
        I/O ports at eff0 [size=3D16]
        Capabilities: [60] Power Management version 2

00:06.0 Multimedia audio controller [0401]: ALi Corporation M5451 PCI AC-Li=
nk=20
Controller Audio Device [10b9:5451] (rev 01)
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Flags: bus master, medium devsel, latency 64, IRQ 11
        I/O ports at ed00 [size=3D256]
        Memory at f7efe000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [dc] Power Management version 2

00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge=20
[Aladdin IV/V/V+] [10b9:1533]
        Subsystem: Toshiba America Info Systems Unknown device [1179:0004]
        Flags: bus master, medium devsel, latency 0
        Capabilities: [a0] Power Management version 1

00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller [P=
MU]=20
[10b9:7101]
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Flags: medium devsel

00:0a.0 Ethernet controller [0200]: Intel Corporation 82557/8/9 Ethernet Pr=
o=20
100 [8086:1229] (rev 08)
        Subsystem: Toshiba America Info Systems 8255x-based Fast Ethernet=20
[1179:0003]
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at f7efd000 (32-bit, non-prefetchable) [size=3D4K]
        I/O ports at eb40 [size=3D64]
        Memory at f7d00000 (32-bit, non-prefetchable) [size=3D1M]
        Capabilities: [dc] Power Management version 2

00:10.0 CardBus bridge [0607]: Texas Instruments PCI1410 PC card Cardbus=20
Controller [104c:ac50] (rev 01)
        Subsystem: Lucent Technologies Unknown device [12a3:ab01]
        Flags: bus master, medium devsel, latency 168, IRQ 11
        Memory at 48100000 (32-bit, non-prefetchable) [size=3D4K]
        Bus: primary=3D00, secondary=3D02, subordinate=3D05, sec-latency=3D=
176
        Memory window 0: 30000000-33fff000 (prefetchable)
        Memory window 1: 34000000-37fff000
        I/O window 0: 00001000-000010ff
        I/O window 1: 00001400-000014ff
        16-bit legacy interface ports at 0001

00:11.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to=
=20
Cardbus Bridge with ZV Support [1179:0617] (rev 32)
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Flags: bus master, slow devsel, latency 168, IRQ 11
        Memory at 48101000 (32-bit, non-prefetchable) [size=3D4K]
        Bus: primary=3D00, secondary=3D06, subordinate=3D09, sec-latency=3D0
        Memory window 0: 38000000-3bfff000 (prefetchable)
        Memory window 1: 3c000000-3ffff000
        I/O window 0: 00001800-000018ff
        I/O window 1: 00001c00-00001cff
        16-bit legacy interface ports at 0001

00:11.1 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to=
=20
Cardbus Bridge with ZV Support [1179:0617] (rev 32)
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Flags: bus master, slow devsel, latency 168, IRQ 11
        Memory at 48102000 (32-bit, non-prefetchable) [size=3D4K]
        Bus: primary=3D00, secondary=3D0a, subordinate=3D0d, sec-latency=3D0
        Memory window 0: 40000000-43fff000 (prefetchable)
        Memory window 1: 44000000-47fff000
        I/O window 0: 00002000-000020ff
        I/O window 1: 00002400-000024ff
        16-bit legacy interface ports at 0001

00:12.0 System peripheral [0880]: Toshiba America Info Systems SD TypA=20
Controller [1179:0805] (rev 03)
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Flags: medium devsel, IRQ 11
        Memory at f7cffe00 (32-bit, non-prefetchable) [size=3D512]
        Capabilities: [80] Power Management version 2

01:00.0 VGA compatible controller [0300]: Trident Microsystems CyberBlade=20
XPAi1 [1023:8820] (rev 82) (prog-if 00 [VGA])
        Subsystem: Toshiba America Info Systems Unknown device [1179:0001]
        Flags: bus master, 66MHz, medium devsel, latency 8, IRQ 11
        Memory at fc000000 (32-bit, non-prefetchable) [size=3D32M]
        Memory at fbc00000 (32-bit, non-prefetchable) [size=3D4M]
        Memory at f8000000 (32-bit, non-prefetchable) [size=3D32M]
        Memory at f7ff8000 (32-bit, non-prefetchable) [size=3D32K]
        [virtual] Expansion ROM at 48000000 [disabled] [size=3D64K]
        Capabilities: [80] AGP version 2.0
        Capabilities: [90] Power Management version 2



dmesg

[    0.000000] Linux version 2.6.23-rc2-1avb (bor@cooker) (gcc version 4.2.=
1=20
20070704 (prerelease) (4.2.1-3mdv2008.0)) #1 Sat Aug 4 12:35:45 MSD 2007
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
[    0.000000] Entering add_active_range(0, 0, 126816) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   126816
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   126816
[    0.000000] On node 0 totalpages: 126816
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 958 pages used for memmap
[    0.000000]   Normal zone: 121762 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 -=
=20
00000000000ee000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ee000 -=
=20
00000000000ef000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ef000 -=
=20
0000000000100000
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 125826
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.23-rc2-1avb root=3DLAB=
EL=3D/=20
resume=3DLABEL=3Dswap splash=3Dsilent vga=3D791 elevator=3Danticipatory
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.765 MHz processor.
[  383.938241] Console: colour dummy device 80x25
[  383.938274] console [tty0] enabled
[  383.938466] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[  383.938480] ... MAX_LOCKDEP_SUBCLASSES:    8
[  383.938489] ... MAX_LOCK_DEPTH:          30
[  383.938499] ... MAX_LOCKDEP_KEYS:        2048
[  383.938508] ... CLASSHASH_SIZE:           1024
[  383.938517] ... MAX_LOCKDEP_ENTRIES:     8192
[  383.938525] ... MAX_LOCKDEP_CHAINS:      16384
[  383.938534] ... CHAINHASH_SIZE:          8192
[  383.938543]  memory used by lock dependency info: 1024 kB
[  383.938553]  per task-struct memory footprint: 1680 bytes
[  383.938565] ------------------------
[  383.938573] | Locking API testsuite:
[ =20
383.938582] ---------------------------------------------------------------=
=2D------------
[  383.938596]                                  | spin |wlock |rlock |mutex=
 |=20
wsem | rsem |
[ =20
383.938611]   -------------------------------------------------------------=
=2D------------
[  383.938651]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.941601]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.943807]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.946051]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.948298]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.950612]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.952924]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.955251]                     double unlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.957375]                   initialize held:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  383.959487]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[ =20
383.961676]   -------------------------------------------------------------=
=2D------------
[  383.961691]               recursive read-lock:             | =20
ok  |             |  ok  |
[  383.962411]            recursive read-lock #2:             | =20
ok  |             |  ok  |
[  383.963129]             mixed read-write-lock:             | =20
ok  |             |  ok  |
[  383.963853]             mixed write-read-lock:             | =20
ok  |             |  ok  |
[ =20
383.964577]   -------------------------------------------------------------=
=2D------------
[  383.964591]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  383.965667]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  383.966750]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  383.967818]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  383.968887]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[  383.969960]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[  383.971031]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  383.972099]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  383.973173]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  383.974241]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  383.975314]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  383.976415]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  383.977515]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  383.978612]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  383.979707]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  383.980807]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  383.981909]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  383.983007]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  383.984106]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  383.985185]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  383.986268]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  383.987360]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  383.988454]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  383.989554]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  383.990653]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  383.991748]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  383.992851]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  383.993950]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  383.995053]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  383.996150]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  383.997251]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  383.998347]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  383.999448]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  384.000541]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  384.001639]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  384.002736]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  384.003838]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  384.004935]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  384.006039]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  384.007137]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  384.008238]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  384.009337]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  384.010441]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  384.011540]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  384.012647]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  384.013743]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  384.014848]       hard-irq read-recursion/123:  ok  |
[  384.015221]       soft-irq read-recursion/123:  ok  |
[  384.015597]       hard-irq read-recursion/132:  ok  |
[  384.015973]       soft-irq read-recursion/132:  ok  |
[  384.016349]       hard-irq read-recursion/213:  ok  |
[  384.016722]       soft-irq read-recursion/213:  ok  |
[  384.017098]       hard-irq read-recursion/231:  ok  |
[  384.017472]       soft-irq read-recursion/231:  ok  |
[  384.017847]       hard-irq read-recursion/312:  ok  |
[  384.018219]       soft-irq read-recursion/312:  ok  |
[  384.018594]       hard-irq read-recursion/321:  ok  |
[  384.018967]       soft-irq read-recursion/321:  ok  |
[  384.019343] -------------------------------------------------------
[  384.019355] Good, all 218 testcases passed! |
[  384.019364] ---------------------------------
[  384.021000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[  384.023953] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[  384.129545] Memory: 495708k/507264k available (1764k kernel code, 10936k=
=20
reserved, 808k data, 184k init, 0k highmem)
[  384.129622] virtual kernel memory layout:
[  384.129626]     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
[  384.129630]     vmalloc : 0xdf800000 - 0xffff4000   ( 519 MB)
[  384.129634]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[  384.129638]       .init : 0xc0386000 - 0xc03b4000   ( 184 kB)
[  384.129642]       .data : 0xc02b9353 - 0xc0383464   ( 808 kB)
[  384.129646]       .text : 0xc0100000 - 0xc02b9353   (1764 kB)
[  384.129685] Checking if this processor honours the WP bit even in=20
supervisor mode... Ok.
[  384.129940] SLUB: Genslabs=3D22, HWalign=3D32, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1,=20
Nodes=3D1
[  384.213336] Calibrating delay using timer specific routine.. 1498.39=20
BogoMIPS (lpj=3D2496628)
[  384.213547] Mount-cache hash table entries: 512
[  384.214702] CPU: After generic identify, caps: 0383f9ff 00000000 0000000=
0=20
00000000 00000000 00000000 00000000 00000000
[  384.214746] CPU: L1 I cache: 16K, L1 D cache: 16K
[  384.214780] CPU: L2 cache: 256K
[  384.214797] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040=20
00000000 00000000 00000000 00000000
[  384.214840] Compat vDSO mapped to ffffe000.
[  384.214898] CPU: Intel Pentium III (Coppermine) stepping 0a
[  384.214924] Checking 'hlt' instruction... OK.
[  384.227289] ACPI: Core revision 20070126
[  384.235808] ACPI: setting ELCR to 0200 (from 0a00)
[  384.239027] NET: Registered protocol family 16
[  384.240944] ACPI: bus type pci registered
[  384.242672] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[  384.242714] PCI: Using configuration type 1
[  384.242724] Setting up standard PCI resources
[  384.262669] ACPI: Interpreter enabled
[  384.262726] ACPI: (supports S0 S3)
[  384.262845] ACPI: Using PIC for interrupt routing
[  384.296833] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  384.298368] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[  384.298399] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[  384.300707] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  384.301242] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[  384.324026] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[  384.324713] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[  384.325351] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[  384.325989] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[  384.326718] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[  384.327373] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[  384.328577] ACPI: Power Resource [PFAN] (off)
[  384.328905] Linux Plug and Play Support v0.97 (c) Adam Belay
[  384.329144] pnp: PnP ACPI init
[  384.329276] ACPI: bus type pnp registered
[  384.348764] pnp: Device 00:0a activated.
[  384.348824]  00:0a: SMCf010 not responding at SIR 0x100, FIR 0x2e8;=20
auto-configuring
[  384.350388] pnp: Device 00:0a disabled.
[  384.355877] pnp: Device 00:0a activated.
[  384.355907]  00:0a: not responding at SIR 0x100, FIR 0x2e8; swapping=20
SIR/FIR and reconfiguring
[  384.357438] pnp: Device 00:0a disabled.
[  384.363893] pnp: Device 00:0a activated.
[  384.363920]  00:0a: responds at SIR 0x2e8, FIR 0x100
[  384.371879] pnp: PnP ACPI: found 12 devices
[  384.371919] ACPI: ACPI bus type pnp unregistered
[  384.372891] PCI: Using ACPI for IRQ routing
[  384.372916] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[  384.399921] Time: tsc clocksource has been installed.
[  384.406886] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[  384.406908] pnp: 00:00: iomem range 0xe0000-0xeffff could not be reserved
[  384.406924] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
[  384.406941] pnp: 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[  384.439685] PCI: Bridge: 0000:00:01.0
[  384.439718]   IO window: disabled.
[  384.439740]   MEM window: f7f00000-fdffffff
[  384.439758]   PREFETCH window: 48000000-480fffff
[  384.439781] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[  384.439792]   IO window: 00001000-000010ff
[  384.439808]   IO window: 00001400-000014ff
[  384.439824]   PREFETCH window: 30000000-33ffffff
[  384.439841]   MEM window: 34000000-37ffffff
[  384.439857] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[  384.439867]   IO window: 00001800-000018ff
[  384.439883]   IO window: 00001c00-00001cff
[  384.439922]   PREFETCH window: 38000000-3bffffff
[  384.439940]   MEM window: 3c000000-3fffffff
[  384.439957] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[  384.439968]   IO window: 00002000-000020ff
[  384.439984]   IO window: 00002400-000024ff
[  384.440000]   PREFETCH window: 40000000-43ffffff
[  384.440017]   MEM window: 44000000-47ffffff
[  384.440060] PCI: Setting latency timer of device 0000:00:01.0 to 64
[  384.440127] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[  384.441530] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  384.441554] PCI: setting IRQ 11 as level-triggered
[  384.441563] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
=20
(level, low) -> IRQ 11
[  384.441627] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[  384.442679] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[  384.442694] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
=20
(level, low) -> IRQ 11
[  384.442756] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[  384.443847] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[  384.443866] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
=20
(level, low) -> IRQ 11
[  384.443967] NET: Registered protocol family 2
[  384.476807] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[  384.477340] TCP established hash table entries: 16384 (order: 7, 589824=
=20
bytes)
[  384.483802] TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
[  384.489840] TCP: Hash tables configured (established 16384 bind 16384)
[  384.490127] TCP reno registered
[  384.500920] checking if image is initramfs... it is
[  384.707452] Freeing initrd memory: 1135k freed
[  384.711248] audit: initializing netlink socket (disabled)
[  384.711414] audit(1186251740.583:1): initialized
[  384.736080] io scheduler noop registered
[  384.736134] io scheduler anticipatory registered (default)
[  384.736147] io scheduler deadline registered
[  384.736756] io scheduler cfq registered
[  384.736856] Activating ISA DMA hang workarounds.
[  384.736907] Boot video device is 0000:01:00.0
[  384.737825] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng=20
3072k, total 16384k
[  384.737860] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[  384.737872] vesafb: protected mode interface info at c000:775e
[  384.737885] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[  384.737897] vesafb: scrolling: redraw
[  384.737910] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[  384.807860] Console: switching to colour frame buffer device 128x48
[  384.870578] fb0: VESA VGA frame buffer device
[  384.939821] Switched to high resolution mode on CPU 0
[  385.094544] Real Time Clock Driver v1.12ac
[  385.101167] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
=20
blocksize
[  385.104614] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[  385.110956] serio: i8042 KBD port at 0x60,0x64 irq 1
[  385.111662] serio: i8042 AUX port at 0x60,0x64 irq 12
[  385.113930] mice: PS/2 mouse device common for all mice
[  385.115162] TCP cubic registered
[  385.116326] NET: Registered protocol family 1
[  385.117006] Using IPI Shortcut mode
[  385.118479] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[  385.121911] Freeing unused kernel memory: 184k freed
[  385.122901] Write protecting the kernel read-only data: 652k
[  385.153580] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  385.154462] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with idebus=3Dxx
[  385.181323] input: AT Translated Set 2 keyboard=20
as /devices/platform/i8042/serio0/input/input0
[  385.240017] ALI15X3: IDE controller at PCI slot 0000:00:04.0
[  385.266515] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  385.292508] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[  385.318356] ALI15X3: chipset revision 195
[  385.343844] ALI15X3: not 100% native mode: will probe irqs later
[  385.369530]     ide0: BM-DMA at 0xeff0-0xeff7, BIOS settings: hda:DMA,=20
hdb:pio
[  385.395811]     ide1: BM-DMA at 0xeff8-0xefff, BIOS settings: hdc:DMA,=20
hdd:pio
[  385.421711] Probing IDE interface ide0...
[  385.696548] hda: IC25N020ATDA04-0, ATA DISK drive
[  386.359523] hda: host side 80-wire cable detection failed, limiting max=
=20
speed to UDMA33
[  386.385892] hda: selected mode 0x42
[  386.386383] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[  386.430443] Probing IDE interface ide1...
[  387.132876] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
[  387.799178] hdc: selected mode 0x42
[  387.810532] ide1 at 0x170-0x177,0x376 on irq 15
[  387.873642] hda: max request size: 128KiB
[  387.901119] hda: 39070080 sectors (20003 MB) w/1806KiB Cache,=20
CHS=3D38760/16/63, UDMA(33)
[  387.928815] hda: cache flushes not supported
[  387.956232]  hda: hda1 hda2
[  388.409253] swsusp: Marking nosave pages: 000000000009f000 -=20
0000000000100000
[  388.409285] swsusp: Basic memory bitmaps created
[  388.444808] swsusp: Basic memory bitmaps freed
[  388.573838] ReiserFS: hda2: found reiserfs format "3.6" with standard=20
journal
[  388.599516] ReiserFS: hda2: using ordered data mode
[  388.630301] ReiserFS: hda2: journal params: device hda2, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[  388.691136] ReiserFS: hda2: checking transaction log (hda2)
[  388.746329] ReiserFS: hda2: Using r5 hash to sort names
[  399.327698] Linux agpgart interface v0.102
[  399.444748] hdc: ATAPI 24X DVD-ROM drive, 128kB Cache, UDMA(33)
[  399.444785] Uniform CD-ROM driver Revision: 3.20
[  399.487066] agpgart: Detected ALi M1644 chipset
[  399.497185] agpgart: AGP aperture is 64M @ 0xf0000000
[  399.587923] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  399.587990] Yenta: Using CSCINT to route CSC interrupts to PCI
[  399.587998] Yenta: Routing CardBus interrupts to PCI
[  399.588012] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  399.719078] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[  399.719097] e100: Copyright(c) 1999-2006 Intel Corporation
[  399.836379] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  399.836399] Socket status: 30000059
[  399.851476] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  399.851498] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
=20
(level, low) -> IRQ 11
[  399.952874] usbcore: registered new interface driver usbfs
[  400.044107] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:D7:14:A1
[  400.044290] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  400.150389] usbcore: registered new interface driver hub
[  400.150690] usbcore: registered new device driver usb
[  400.173010] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  400.173027] Socket status: 30000007
[  400.173954] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  400.303850] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  400.303869] Socket status: 30000007
[  400.376730] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ=20
sharing enabled
[  400.380536] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[  400.388532] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[  400.388553] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
=20
(level, low) -> IRQ 11
[  400.388616] ohci_hcd 0000:00:02.0: OHCI Host Controller
[  400.391332] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  400.392511] serial8250: ttyS3 at I/O 0x2e8 (irq =3D 3) is a 16550A
[  400.470159] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[  400.526313] pccard: PCMCIA card inserted into slot 0
[  400.530462] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[  400.530561] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[  400.587028] usb usb1: configuration #1 chosen from 1 choice
[  400.587365] hub 1-0:1.0: USB hub found
[  400.626597] hub 1-0:1.0: 3 ports detected
[  400.653630] NET: Registered protocol family 23
[  400.806825] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[  400.806867] Activated ALi 1533 ISA bridge port 0x02e8.
[  400.806882] Activated ALi 1533 ISA bridge port 0x02f8.
[  400.807096] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[  400.807131] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x0e
[  400.807154] smsc_ircc_present: can't get sir_base of 0x2e8
[  400.940228] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[  400.940251] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
=20
(level, low) -> IRQ 11
[  404.404605] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x2f8-0x2ff 0x330-0x337 0x378-0x37f 0x388-0x38f
[  404.407905] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  404.409403] cs: IO port probe 0x820-0x8ff: clean.
[  404.410696] cs: IO port probe 0xc00-0xcf7: clean.
[  404.413127] cs: IO port probe 0xa00-0xaff: clean.
[  404.818645] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x2f8-0x2ff 0x330-0x337 0x378-0x37f 0x388-0x38f
[  404.821862] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  404.823296] cs: IO port probe 0x820-0x8ff: clean.
[  404.824588] cs: IO port probe 0xc00-0xcf7: clean.
[  404.826864] cs: IO port probe 0xa00-0xaff: clean.
[  404.857613] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x2f8-0x2ff 0x330-0x337 0x378-0x37f 0x388-0x38f
[  404.942405] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[  404.954820] pcmcia: registering new device pcmcia0.0
[  404.966845] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  404.968295] cs: IO port probe 0x820-0x8ff: clean.
[  404.995333] cs: IO port probe 0xc00-0xcf7: clean.
[  404.997598] cs: IO port probe 0xa00-0xaff: clean.
[  405.108955] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[  405.108983] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[  405.108991] *** Station Mode (STA) Support: YES
[  405.108997] *** Access Point Mode (AP) Support: YES
[  405.709370] eth1: PRI 31 variant 2 version 9.48
[  405.709441] eth1: NIC 5 variant 2 version 1.02
[  405.713766] eth1: Wireless, io_addr 0x100, irq 11, mac_address=20
00:02:2D:26:95:6C
[  407.104070] Toshiba System Managment Mode driver v1.11 26/9/2001
[  407.167560] Non-volatile memory driver v1.2
[  407.398367] input: ImPS/2 Generic Wheel Mouse=20
as /devices/platform/i8042/serio1/input/input1
[  408.375792] ACPI: AC Adapter [ADP1] (on-line)
[  408.402893] ACPI: Battery Slot [BAT1] (battery present)
[  408.403120] ACPI: Battery Slot [BAT2] (battery absent)
[  408.439855] input: Power Button (FF) as /devices/virtual/input/input2
[  408.441228] ACPI: Power Button (FF) [PWRF]
[  408.443662] input: Lid Switch as /devices/virtual/input/input3
[  408.445132] ACPI: Lid Switch [LID]
[  408.532010] ACPI: Transitioning device [FAN] to D3
[  408.532028] ACPI: Transitioning device [FAN] to D3
[  408.532060] ACPI: Fan [FAN] (off)
[  408.651565] ACPI: CPU0 (power states: C1[C1] C2[C2])
[  408.739942] ACPI: Thermal Zone [THRM] (59 C)
[  408.851127] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[  408.851152] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[  408.968357] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[  409.275763] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:=
=20
dm-devel@redhat.com
[  409.460831] Marking TSC unstable due to: possible TSC halt in C2.
[  409.464081] Time: acpi_pm clocksource has been installed.
[  409.577165] loop: module loaded
[  409.816772] Clocksource tsc unstable (delta =3D -133463782 ns)
[  411.830450] Adding 500432k swap on /dev/hda1.  Priority:-1 extents:1=20
across:500432k
[  418.345308] IrCOMM protocol (Dag Brattli)
[  420.380972] PPP generic driver version 2.4.2
[  421.580638] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[  421.580680] Activated ALi 1533 ISA bridge port 0x02e8.
[  421.580695] Activated ALi 1533 ISA bridge port 0x02f8.
[  421.580909] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[  421.580943] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x0e
[  421.580968] smsc_ircc_present: can't get sir_base of 0x2e8
[  422.411631] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[  422.411683] Activated ALi 1533 ISA bridge port 0x02e8.
[  422.411698] Activated ALi 1533 ISA bridge port 0x02f8.
[  424.681575] Bluetooth: Core ver 2.11
[  424.688047] NET: Registered protocol family 31
[  424.688064] Bluetooth: HCI device and connection manager initialized
[  424.688376] Bluetooth: HCI socket layer initialized
[  425.645910] Bluetooth: L2CAP ver 2.8
[  425.645929] Bluetooth: L2CAP socket layer initialized
[  426.381600] Bluetooth: RFCOMM socket layer initialized
[  426.381691] Bluetooth: RFCOMM TTY layer initialized
[  426.381698] Bluetooth: RFCOMM ver 1.8
[  428.373301] NET: Registered protocol family 17
[  431.161093] eth1: PRI 31 variant 2 version 9.48
[  431.161182] eth1: NIC 5 variant 2 version 1.02
[  431.639775] eth1: PRI 31 variant 2 version 9.48
[  431.639862] eth1: NIC 5 variant 2 version 1.02
[  431.880089] eth1: PRI 31 variant 2 version 9.48
[  431.880179] eth1: NIC 5 variant 2 version 1.02
[  533.915043] swsusp: Marking nosave pages: 000000000009f000 -=20
0000000000100000
[  533.915237] swsusp: Basic memory bitmaps created
[  533.917372] Stopping tasks ... done.
[  533.942655] Shrinking memory...  =08-=08\=08done (14013 pages freed)
[  534.162066] Freed 56052 kbytes in 0.31 seconds (180.81 MB/s)
[  534.162077] Suspending console(s)
[  534.169152] pnp: Device 00:09 disabled.
[  534.172472] ACPI: PCI interrupt for device 0000:00:0a.0 disabled
[  534.172489] Trying to free already-free IRQ 11
[  534.174735] ACPI: PCI interrupt for device 0000:00:06.0 disabled
[  534.175345] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[  534.178935] swsusp: critical section:=20
[  534.247939] swsusp: Need to copy 59544 pages
[   54.140346] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   54.140657] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
=20
(level, low) -> IRQ 11
[   54.140878] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   54.140885] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[   54.141107] PM: Writing back config space on device 0000:00:06.0 at offs=
et=20
1 (was c2900007, writing c2900003)
[   54.141158] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
=20
(level, low) -> IRQ 11
[   54.147965] PM: Writing back config space on device 0000:00:0a.0 at offs=
et=20
f (was 380801ff, writing 3808010b)
[   54.148010] PM: Writing back config space on device 0000:00:0a.0 at offs=
et=20
6 (was 48100000, writing f7d00000)
[   54.148026] PM: Writing back config space on device 0000:00:0a.0 at offs=
et=20
5 (was 2801, writing eb41)
[   54.148042] PM: Writing back config space on device 0000:00:0a.0 at offs=
et=20
4 (was 48200000, writing f7efd000)
[   54.148065] PM: Writing back config space on device 0000:00:0a.0 at offs=
et=20
1 (was 2900000, writing 2900007)
[   54.148150] PM: Writing back config space on device 0000:00:10.0 at offs=
et=20
f (was 34001ff, writing 5c001ff)
[   54.148201] PM: Writing back config space on device 0000:00:10.0 at offs=
et=20
4 (was 48201000, writing 48100000)
[   54.148217] PM: Writing back config space on device 0000:00:10.0 at offs=
et=20
3 (was 24008, writing 2a808)
[   54.151639] PM: Writing back config space on device 0000:00:11.0 at offs=
et=20
f (was 10001ff, writing 58001ff)
[   54.151692] PM: Writing back config space on device 0000:00:11.0 at offs=
et=20
4 (was 48202000, writing 48101000)
[   54.151709] PM: Writing back config space on device 0000:00:11.0 at offs=
et=20
3 (was 824000, writing 82a800)
[   54.152743] PM: Writing back config space on device 0000:00:11.1 at offs=
et=20
f (was 10002ff, writing 58002ff)
[   54.152797] PM: Writing back config space on device 0000:00:11.1 at offs=
et=20
4 (was 48203000, writing 48102000)
[   54.152813] PM: Writing back config space on device 0000:00:11.1 at offs=
et=20
3 (was 824000, writing 82a800)
[   54.154078] pnp: Failed to activate device 00:05.
[   54.154120] pnp: Failed to activate device 00:06.
[   54.159608] pnp: Device 00:09 activated.
[   54.205284] WARNING: at /home/bor/src/linux-git/kernel/irq/resend.c:70=20
check_irq_resend()
[   54.205299]  [<c01047fa>] show_trace_log_lvl+0x1a/0x30
[   54.205332]  [<c0105292>] show_trace+0x12/0x20
[   54.205343]  [<c01052f5>] dump_stack+0x15/0x20
[   54.205353]  [<c014ce7e>] check_irq_resend+0x9e/0xb0
[   54.205388]  [<c014c991>] enable_irq+0xb1/0xc0
[   54.205397]  [<df82f6fa>] ide_config_drive_speed+0x18a/0x3e0 [ide_core]
[   54.205570]  [<df80f3cc>] ali15x3_tune_drive+0x1c/0x20 [alim15x3]
[   54.205592]  [<df82da33>] ide_do_request+0x8a3/0xa10 [ide_core]
[   54.205623]  [<df82dc60>] ide_do_drive_cmd+0xc0/0x110 [ide_core]
[   54.205652]  [<df82c868>] generic_ide_resume+0x98/0xe0 [ide_core]
[   54.205681]  [<c023793c>] resume_device+0x4c/0xa0
[   54.205717]  [<c02379ee>] dpm_resume+0x5e/0x90
[   54.205727]  [<c0237a46>] device_resume+0x26/0x40
[   54.205736]  [<c0141849>] hibernation_snapshot+0x69/0xd0
[   54.205747]  [<c0141a1c>] hibernate+0xac/0x170
[   54.205755]  [<c01407ae>] state_store+0xbe/0xd0
[   54.205764]  [<c01ab2d2>] subsys_attr_store+0x32/0x50
[   54.205784]  [<c01ab5ab>] sysfs_write_file+0xdb/0x120
[   54.205795]  [<c016f8b9>] vfs_write+0x99/0x130
[   54.205819]  [<c016fe2d>] sys_write+0x3d/0x70
[   54.205829]  [<c0104112>] sysenter_past_esp+0x5f/0x99
[   54.205839]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   54.206084] hda: selected mode 0x42
[   54.225580] hdc: selected mode 0x42
[   54.228619] usb usb1: root hub lost power or was reset
[   54.714012] eth1: PRI 31 variant 2 version 9.48
[   54.714075] eth1: NIC 5 variant 2 version 1.02
[   54.810451] Restarting tasks ... <5>toshiba_acpi: Re-enabled hotkeys
[   54.925054] done.
[   54.925134] swsusp: Basic memory bitmaps freed
[   59.560144] eth1: PRI 31 variant 2 version 9.48
[   59.560231] eth1: NIC 5 variant 2 version 1.02
[   59.835398] eth1: PRI 31 variant 2 version 9.48
[   59.835487] eth1: NIC 5 variant 2 version 1.02
[   60.079468] eth1: PRI 31 variant 2 version 9.48
[   60.079553] eth1: NIC 5 variant 2 version 1.02

config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23-rc2
# Sat Aug  4 11:08:42 2007
#
CONFIG_X86_32=3Dy
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_X86=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_QUICKLIST=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_DMI=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_BROKEN_ON_SMP=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
CONFIG_AUDIT=3Dy
CONFIG_AUDITSYSCALL=3Dy
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D17
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_EMBEDDED=3Dy
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=3Dy
CONFIG_BLOCK=3Dy
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
# CONFIG_SMP is not set
CONFIG_X86_PC=3Dy
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=3Dy
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D5
CONFIG_X86_XADD=3Dy
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_GOOD_APIC=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D4
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=3Dy
CONFIG_TOSHIBA=3Dm
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=3Dy
CONFIG_MICROCODE=3Dm
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dm
CONFIG_X86_CPUID=3Dm

#
# Firmware Drivers
#
CONFIG_EDD=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=3Dy
CONFIG_NOHIGHMEM=3Dy
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=3Dy
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=3D0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_FLATMEM_MANUAL=3Dy
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=3Dy
CONFIG_FLAT_NODE_MEM_MAP=3Dy
CONFIG_SPARSEMEM_STATIC=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_NR_QUICK=3D1
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=3Dy
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D300
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=3D0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dm
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_THERMAL=3Dm
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=3Dm
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dy
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dm
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=3Dm
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

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=3Dy
CONFIG_PCI_BIOS=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=3Dy
CONFIG_ISA=3Dy
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
CONFIG_PCCARD=3Dm
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=3Dm
CONFIG_PCMCIA_LOAD_CIS=3Dy
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=3Dy
CONFIG_PCCARD_NONSTATIC=3Dm
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_AOUT=3Dm
CONFIG_BINFMT_MISC=3Dm

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=3Dm
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
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
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
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

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
CONFIG_IRDA=3Dm

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dm
CONFIG_IRDA_ULTRA=3Dy

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
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

#
# Old SIR device drivers
#
# CONFIG_IRPORT_SIR is not set

#
# Old Serial dongle support
#

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=3Dm
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=3Dm
CONFIG_BT_L2CAP=3Dm
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=3Dm
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
CONFIG_FIB_RULES=3Dy

#
# Wireless
#
CONFIG_CFG80211=3Dm
CONFIG_WIRELESS_EXT=3Dy
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
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dm
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dm
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm
CONFIG_BLK_DEV_NBD=3Dm
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D32000
CONFIG_BLK_DEV_RAM_BLOCKSIZE=3D1024
CONFIG_CDROM_PKTCDVD=3Dy
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=3Dy
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=3Dm
CONFIG_IDE_MAX_HWIFS=3D4
CONFIG_BLK_DEV_IDE=3Dm

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=3Dm
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=3Dm
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=3Dy
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=3Dy

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dm
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_SHARE_IRQ=3Dy
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=3Dm
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
# CONFIG_IDE_ARM is not set
# CONFIG_IDE_CHIPSETS is not set
CONFIG_BLK_DEV_IDEDMA=3Dy
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dm
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dm
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dm
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dm
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=3Dm
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_LOWLEVEL=3Dy
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
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SEAGATE is not set
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
# CONFIG_ATA is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dm
CONFIG_MD_LINEAR=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
CONFIG_MD_RAID5_RESHAPE=3Dy
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dm
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dm
CONFIG_DM_SNAPSHOT=3Dm
CONFIG_DM_MIRROR=3Dm
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
CONFIG_DM_MULTIPATH_EMC=3Dm
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_DELAY is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=3Dm
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dm
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
CONFIG_NET_PCI=3Dy
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_DGRS is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=3Dm
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
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
CONFIG_WLAN_80211=3Dy
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dm
# CONFIG_NET_FC is not set
CONFIG_SHAPER=3Dm
CONFIG_NETCONSOLE=3Dm
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_TSDEV=3Dm
CONFIG_INPUT_TSDEV_SCREEN_X=3D240
CONFIG_INPUT_TSDEV_SCREEN_Y=3D320
CONFIG_INPUT_EVDEV=3Dm
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
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
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dm
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=3Dm

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dm
CONFIG_FIX_EARLYCON_MEM=3Dy
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=3Dm
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dm
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
# CONFIG_IPMI_HANDLER is not set
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=3Dm
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
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
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dm
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=3Dm
CONFIG_RTC=3Dy
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=3Dm
CONFIG_AGP_ALI=3Dm
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

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=3Dm
CONFIG_MAX_RAW_DEVS=3D256
CONFIG_HPET=3Dy
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=3Dy
CONFIG_HANGCHECK_TIMER=3Dm
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dm
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dm

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_I2C_ALGOPCF=3Dm
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=3Dm
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
CONFIG_I2C_STUB=3Dm
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=3Dm
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
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
CONFIG_POWER_SUPPLY=3Dm
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=3Dm
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
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
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
CONFIG_SENSORS_LM90=3Dm
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
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

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
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
CONFIG_LCD_CLASS_DEVICE=3Dm
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dm
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dm
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=3Dy
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

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
CONFIG_FB_VESA=3Dy
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

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=3Dy
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=3Dy
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=3Dy
CONFIG_LOGO_LINUX_MONO=3Dy
CONFIG_LOGO_LINUX_VGA16=3Dy
CONFIG_LOGO_LINUX_CLUT224=3Dy

#
# Sound
#
CONFIG_SOUND=3Dm

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
CONFIG_SND_RTCTIMER=3Dm
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=3Dy
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm

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
CONFIG_SND_ALI5451=3Dm
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
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
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=3Dy

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
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dm
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dm
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=3Dm
CONFIG_USB_MOUSE=3Dm
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dm
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
CONFIG_USB_PERSIST=3Dy
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=3Dm
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dy
CONFIG_USB_STORAGE_FREECOM=3Dy
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=3Dy
CONFIG_USB_STORAGE_USBAT=3Dy
CONFIG_USB_STORAGE_SDDR09=3Dy
CONFIG_USB_STORAGE_SDDR55=3Dy
CONFIG_USB_STORAGE_JUMPSHOT=3Dy
CONFIG_USB_STORAGE_ALAUDA=3Dy
CONFIG_USB_STORAGE_KARMA=3Dy
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

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
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
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dm
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

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dm
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=3Dm
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=3Dm
CONFIG_REISERFS_FS=3Dm
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=3Dy
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=3Dy
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D866
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dm
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=3Dy
CONFIG_CONFIGFS_FS=3Dm

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
CONFIG_SQUASHFS=3Dm
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
# CONFIG_SQUASHFS_VMALLOC is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
CONFIG_NFS_DIRECTIO=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_NFSD_TCP=3Dy
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=3Dm
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS=3Dy
CONFIG_CIFS_STATS2=3Dy
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=3Dm
# CONFIG_CODA_FS_OLD_API is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
CONFIG_NLS_CODEPAGE_737=3Dm
CONFIG_NLS_CODEPAGE_775=3Dm
CONFIG_NLS_CODEPAGE_850=3Dm
CONFIG_NLS_CODEPAGE_852=3Dm
CONFIG_NLS_CODEPAGE_855=3Dm
CONFIG_NLS_CODEPAGE_857=3Dm
CONFIG_NLS_CODEPAGE_860=3Dm
CONFIG_NLS_CODEPAGE_861=3Dm
CONFIG_NLS_CODEPAGE_862=3Dm
CONFIG_NLS_CODEPAGE_863=3Dm
CONFIG_NLS_CODEPAGE_864=3Dm
CONFIG_NLS_CODEPAGE_865=3Dm
CONFIG_NLS_CODEPAGE_866=3Dm
CONFIG_NLS_CODEPAGE_869=3Dm
CONFIG_NLS_CODEPAGE_936=3Dm
CONFIG_NLS_CODEPAGE_950=3Dm
CONFIG_NLS_CODEPAGE_932=3Dm
CONFIG_NLS_CODEPAGE_949=3Dm
CONFIG_NLS_CODEPAGE_874=3Dm
CONFIG_NLS_ISO8859_8=3Dm
CONFIG_NLS_CODEPAGE_1250=3Dm
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
CONFIG_NLS_ISO8859_2=3Dm
CONFIG_NLS_ISO8859_3=3Dm
CONFIG_NLS_ISO8859_4=3Dm
CONFIG_NLS_ISO8859_5=3Dm
CONFIG_NLS_ISO8859_6=3Dm
CONFIG_NLS_ISO8859_7=3Dm
CONFIG_NLS_ISO8859_9=3Dm
CONFIG_NLS_ISO8859_13=3Dm
CONFIG_NLS_ISO8859_14=3Dm
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
CONFIG_NLS_KOI8_U=3Dm
CONFIG_NLS_UTF8=3Dm

#
# Distributed Lock Manager
#
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=3Dy
CONFIG_PROFILING=3Dy
CONFIG_OPROFILE=3Dm
CONFIG_KPROBES=3Dy

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
CONFIG_DEBUG_SHIRQ=3Dy
CONFIG_DETECT_SOFTLOCKUP=3Dy
CONFIG_SCHED_DEBUG=3Dy
CONFIG_SCHEDSTATS=3Dy
CONFIG_TIMER_STATS=3Dy
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_PROVE_LOCKING=3Dy
CONFIG_LOCKDEP=3Dy
CONFIG_LOCK_STAT=3Dy
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy
CONFIG_DEBUG_LOCKING_API_SELFTESTS=3Dy
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_FRAME_POINTER=3Dy
CONFIG_FORCED_INLINING=3Dy
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Page alloc debug is incompatible with Software Suspend on i386
#
CONFIG_DEBUG_RODATA=3Dy
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY is not set
CONFIG_XOR_BLOCKS=3Dm
CONFIG_ASYNC_CORE=3Dm
CONFIG_ASYNC_MEMCPY=3Dm
CONFIG_ASYNC_XOR=3Dm
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dm
CONFIG_CRYPTO_BLKCIPHER=3Dm
CONFIG_CRYPTO_HASH=3Dm
CONFIG_CRYPTO_MANAGER=3Dm
CONFIG_CRYPTO_HMAC=3Dm
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dm
CONFIG_CRYPTO_SHA1=3Dm
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_WP512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_CBC=3Dm
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_LRW=3Dm
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=3Dm
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_586=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
CONFIG_CRYPTO_AES=3Dm
CONFIG_CRYPTO_AES_586=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_CRC32C=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_TEST=3Dm
CONFIG_CRYPTO_HW=3Dy
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=3Dy
CONFIG_CRC7=3Dm
CONFIG_LIBCRC32C=3Dm
CONFIG_AUDIT_GENERIC=3Dy
CONFIG_ZLIB_INFLATE=3Dm
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_KTIME_SCALAR=3Dy

--nextPart18833763.pu9pzsvt1L
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGtMeIR6LMutpd94wRAmSsAJ9phiA4Rt8dOtd0KGuJ1SWBq/cTfACeJW1/
Ot6QyeGXnEM1HyHna9jOOPY=
=4Nzf
-----END PGP SIGNATURE-----

--nextPart18833763.pu9pzsvt1L--
