Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbXIKFdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbXIKFdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXIKFdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:33:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:6466 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXIKFdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T7XxyFxgHsLGyZdLVfeRhL2c8MsWFHGfWiwo0C34d+B9w8Rj5zcCeRmO9nGWypLSh7SbE/nXPuqlZUNllZIcald8kdvqUMX6zFJBCwK314wAYDPUTB6SBLW3ygHnB2+SvFqGYQ3K01/CiHFJSk/p57OQEmsP5uFcHHlAEnof4EQ=
Message-ID: <406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
Date: Tue, 11 Sep 2007 07:33:13 +0200
From: "=?ISO-8859-1?Q?K=F6vedi_Kriszti=E1n?=" <kovedi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
Cc: linux-kernel@vger.kernel.org, stable-bounces@kernel.org,
       davem@sunset.davemloft.net
In-Reply-To: <20070910.053642.71114977.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <406fe6c90709100442j1ae0ef79v3188eb10b8be451b@mail.gmail.com>
	 <20070910.053642.71114977.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/10, David Miller <davem@davemloft.net>:
> From: "Kövedi_Krisztián" <kovedi@gmail.com>
> Date: Mon, 10 Sep 2007 13:42:43 +0200
>
> > Executing last command: boot
> > Boot device: /pci@1f,0/ide@d/disk@0,0:a  File and args:
> > SILO Version 1.4.13
> > boot: teszt
> > Allocated 8 Megs of memory at 0x40000000 for kernel
> > Loaded kernel version 2.6.22
> >
> > Remapping the kernel... done.
> > Booting Linux...
>
> Please add "-p" to the boot command line so we can see
> if any other useful messages are printed by the kernel.
>
> There is a period between this last message and the
> console initialization, which can be quite long and the
> "-p" option forces all messages to be printed via the
> firmware.
>

thanks, we find one kernel panic under initailizin the pci deveces

hier is the dmesg with -p:

###################
Sun Fire V100 (UltraSPARC-IIe 648MHz), No Keyboard
OpenBoot 4.0, 1024 MB memory installed, Serial #53829668.
Ethernet address 0:3:ba:35:60:24, Host ID: 83356024.



Executing last command: boot
Boot device: /pci@1f,0/ide@d/disk@0,0:a  File and args:
SILO Version 1.4.13
boot: teszt -p
Allocated 8 Megs of memory
Loaded kernel version 2.6.22

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.0.18 2002/05/23
18:22'
[    0.000000] PROMLIB: Root node compatible: sun4u
[    0.000000] Linux version 2.6.22.6 (root@www) (gcc version 4.1.1
(Gentoo 4.1.
1)) #2 Mon Sep 10 09:14:17 CEST 2007
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 00:03:ba:35:60:24
Remapping the kernel... done.
[    0.000000] PROM: Built device tree with 45240 bytes of memory.
Booting Linux...
[    0.000000] Built 1 zonelists.  Total pages: 12723
[    0.000000] Kernel command line: root=/dev/md1 ro
md=1,/dev/hda2,/dev/hdc2 id
e=nodma -p
[    0.000000] md: Will configure md1 (super-block) from
/dev/hda2,/dev/hdc2, be
low.
[    0.000000] ide_setup: ide=nodma : Prevented DMA
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   47.328995] clocksource: mult[b40001] shift[16]
[   47.382760] clockevent: mult[16c16bf] shift[32]
[   47.437635] Console: colour dummy device 80x25
[   47.495580] Dentry cache hash table entries: 131072 (order: 7,

[   47.588109] Inode-cache hash table entries: 65536 (order: 6, 524288
bytes)
[   47.730785] Memory: 1026136k available (2496k kernel code, 848k
data, 128k in
it) [fffff80000000000,00000000dfec8000]
[   48.005810] Calibrating delay using timer specific routine.. 11.12
BogoMIPS (
lpj=55615)
[   48.100809] Mount-cache hash table entries: 512
[   48.156265] NET: Registered protocol family 16
[   48.217211] PCI: Probing for controllers.
[   48.267219] /pci@1f,0: SABRE PCI Bus Module
[   48.316321] /pci@1f,0: PCI IO
[   48.382804] PCI: Scanning PBM /pci@1f,0
[   48.429059] PCI quirk: region 2000-203f claimed by ali7101 ACPI
[   48.499146] PCI quirk: region 4000-401f claimed by ali7101 SMB
[   48.569859] kobject_add failed for 0000:00:03.0 with -EEXIST, don't
try to re
gister things with the same name in the same directory.
[   48.711319] Call Trace:
[   48.740395]  [0000000000578374] device_add+0x88/0x518
[   48.800670]  [0000000000550830] pci_bus_add_device+0x10/0x6c
[   48.868208]  [00000000005508ac] pci_bus_add_devices+
[   48.937827]  [0000000000434a64] pci_scan_one_pbm+0xa4/0xb4
[   49.003288]  [000000000043d1e4] sabre_scan_bus+0x54/0x270
[   49.067712]  [0000000000755d28] pcibios_init+0x64/0x90
[   49.129014]  [00000000007501f0] kernel_init+0xc0/0x260
[   49.190319]  [00000000004277f8] kernel_thread+0x38/0x48
[   49.252663]  [000000000066f4d8] rest_init+0x18/0x50
[   49.310852] pci 0000:00:03.0: Error adding device, continuing
[   49.380101] kernel BUG at drivers/pci/bus.c:127!
[   49.434512]               \|/ ____ \|/
[   49.434518]               "@'/ .. \`@"
[   49.434524]               /_| \__/ |_\
[   49.434529]                  \__U_/
[   49.610113] swapper(1): Kernel bad sw trap 5 [#1]
[   49.666218] TSTATE: 0000000080001600 TPC: 0000000000550924 TNPC:
000000000055
0928 Y: 00000000    Not tainted
[   49.783631] TPC: <pci_bus_add_devices+0x98/0x14c>
[   49.839738] g0: 00000000007289f0 g1: 0000000000000001 g2:
0000000000715000 g3
: 00000000007152b0
[   49.943647] g4: fffff800dfe9f9e0 g5: 0000000000000000 g6:
fffff800defc00
: 0000000000000000
[   50.047551] o0: 0000000000000037 o1: 00000000006d3310 o2: 000000000000007f o3
: fffff800defcb380
[   50.151458] o4: 0000000000000101 o5: 0000000000000000 sp: fffff800defc32a1 re
t_pc: 000000000055091c
[   50.259521] RPC: <pci_bus_add_devices+0x90/0x14c>
[   50.315635] l0: fffff800dfec2498 l1: fffff800dfec24a8 l2: fffff800dfea8a60 l3
: 000000000071e000
[   50.419536] l4: fffff800def3f000 l5: 0000000000000000 l6: 0000000000000000 l7
: 0000000000000008
[   50.523447] i0: fffff800def3d000 i1: fffff80080e0de80 i2: fffff800dfec2480 i3
: 0000000000000000
[   50.627350] i4: 0000000000000001 i5: 0000000000728518 i6: fffff800defc3361 i7
: 0000000000434a64
[   50.731257] I7: <pci_scan_one_pbm+0xa4/0xb4>
[   50.782168] Caller[0000000000434a64]: pci_scan_one_pbm+0xa4/0xb4
[   50.853852] Caller[000000000043d1e4]: sabre_scan_bus+0x54/0x270
[   50.924508] Caller[0000000000755d28]: pcibios_init+0x64/0x90
[   50.992048] Caller[00000000007501f0]: kernel_init+0xc0/0x260
[   51.059586] Caller[00000000004277f8]: kernel_thread+0x38/0x48
[   51.128166] Caller[000000000066f4d8]: rest_init+0x18/0x50
[   51.192586] Instruction DUMP: 9210207f  7ffb66c3  90122310 <91d02005> 22c0802
5  c25e2010  c2588000  80a04002  1268000e
[   51.321433] Kernel panic - not syncing: Attempted to kill init!
[   51.392101] Press Stop-A (L1-A) to return to the boot prom



Thanks,
Krisz
