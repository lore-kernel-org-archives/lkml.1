Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXGaVjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXGaVjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756014AbXGaVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:39:13 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32865 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751686AbXGaVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:39:09 -0400
Subject: 2.6.23-rc1-mm1 Reiser4 / SLUB padding overwritten error
From: Zan Lynx <zlynx@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4jRsNg/LJHvMdir6t2pb"
Date: Tue, 31 Jul 2007 15:39:01 -0600
Message-Id: <1185917942.6981.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4jRsNg/LJHvMdir6t2pb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I was just going along, playing some music and typing in gnome-terminals
when the system froze up.

System is AMD-64, Reiser4 filesystem.

This was taken off netconsole and I think some bits of it are missing,
or perhaps that Padding stuff just prints like that.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
BUG kmalloc-128: Padding overwritten. 0x000000000000003a-0x00000000fffffffe
---------------------------------------------------------------------------=
--

INFO: Slab 0xffff810001481e20 used=3D18 fp=3D0xffff81000d1cc000 flags=3D0x4=
0000000000000c3

Call Trace:
 [<ffffffff802a9389>] slab_err+0x99/0xc0
 [<ffffffff8028d987>] pagevec_lookup+0x17/0x20
 [<ffffffff802a94f3>] slab_pad_check+0xe3/0x120
 [<ffffffff802a95ab>] check_slab+0x7b/0x90
 [<ffffffff802aae39>] __slab_alloc+0x109/0x700
 [<ffffffff80342ab3>] blocknr_set_add+0x113/0x180
 [<ffffffff80342ab3>] blocknr_set_add+0x113/0x180
 [<ffffffff802ab707>] kmem_cache_alloc+0xc7/0xd0
 [<ffffffff80342ab3>] blocknr_set_add+0x113/0x180
 [<ffffffff8033544e>] reiser4_dealloc_blocks+0x21e/0x260
 [<ffffffff80367579>] kill_hook_extent+0x389/0x4a0
 [<ffffffff803671f0>] kill_hook_extent+0x0/0x4a0
 [<ffffffff8035b362>] call_kill_hooks+0x82/0xa0
 [<ffffffff8036bd36>] max_item_key_by_coord+0x36/0x50
 [<ffffffff8035b210>] kill_units+0x0/0xa0
 [<ffffffff8035bf53>] prepare_for_compact+0x753/0x790
 [<ffffffff8035dd50>] kill_tail+0x0/0x50
 [<ffffffff8035b2b0>] kill_head+0x0/0x30
 [<ffffffff8032a930>] jload_gfp+0x80/0x210
 [<ffffffff8032ca02>] lock_carry_node+0x1e2/0x360
 [<ffffffff8035c0ac>] kill_node40+0x3c/0xe0
 [<ffffffff8032dbe4>] carry_cut+0x54/0x70
 [<ffffffff8032d62e>] reiser4_carry+0xfe/0x2b0
 [<ffffffff8032cc54>] reiser4_post_carry+0x54/0xe0
 [<ffffffff80331dd1>] kill_node_content+0x161/0x880
 [<ffffffff8032a930>] jload_gfp+0x80/0x210
 [<ffffffff80332d8d>] cut_tree_worker_common+0x17d/0x3e0
 [<ffffffff80332c10>] cut_tree_worker_common+0x0/0x3e0
 [<ffffffff80330cb4>] reiser4_cut_tree_object+0x124/0x230
 [<ffffffff80334a85>] reiser4_grab_space+0x45/0xa0
 [<ffffffff80334cf7>] reiser4_grab_reserved+0x47/0x150
 [<ffffffff8034f236>] cut_file_items+0xc6/0x1d0
 [<ffffffff8034fdc0>] reiser4_update_file_size+0x0/0x90
 [<ffffffff8034f741>] truncate_file_body+0xc1/0x400
 [<ffffffff802331cb>] enqueue_entity+0xbb/0x270
 [<ffffffff80232900>] enqueue_task+0x50/0x70
 [<ffffffff80232cdd>] update_curr+0x13d/0x240
 [<ffffffff802a999b>] check_bytes_and_report+0x4b/0x100
 [<ffffffff802a9e64>] check_object+0x224/0x260
 [<ffffffff802a9648>] init_object+0x88/0xa0
 [<ffffffff802aae02>] __slab_alloc+0xd2/0x700
 [<ffffffff802a999b>] check_bytes_and_report+0x4b/0x100
 [<ffffffff8053717f>] _spin_unlock_irq+0x2f/0x50
 [<ffffffff80536381>] __down_write_nested+0xa1/0xc0
 [<ffffffff80352611>] get_exclusive_access+0x11/0x20
 [<ffffffff8034fd3d>] delete_object_unix_file+0x5d/0xe0
 [<ffffffff803332f3>] reiser4_init_context+0x63/0x80
 [<ffffffff803435ae>] reiser4_delete_inode+0x7e/0xd0
 [<ffffffff80343530>] reiser4_delete_inode+0x0/0xd0
 [<ffffffff802c5d5a>] generic_delete_inode+0x7a/0x100
 [<ffffffff802c26b1>] d_kill+0x41/0x70
 [<ffffffff802c3816>] dput+0x86/0x160
 [<ffffffff802bb12a>] sys_renameat+0x23a/0x260
 [<ffffffff802aa4ed>] __slab_free+0xad/0x380
 [<ffffffff80536db6>] _spin_lock_irqsave+0x46/0x60
 [<ffffffff8053657c>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8020c1de>] system_call+0x7e/0x83

INFO: lockdep is turned off.
 Padding 0xffff81000d1cc000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkk=
kkkkkkkkkk
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b a5 bb bb 0d 81 =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD.=EF=BF=BD....=EF=BF=BD=EF=BF=BD
 bb ff ff 00 35 o=EF=BF=BD2.=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD....r5..
 d7 01 00 d4 ff ff 00 00 35 d7 ff 1c ff 00 00 =EF=BF=BD=EF=BF=BD....=EF=BF=
=BD=EF=BF=BD........
 6b 6b 6b 6b 6b Padding 0xffff81000d1cc140:  6b 6b cc cc cc c4 00 ff 25 ff =
Padding 0xffff81000d1cc160:  00 1a 79 ff 00 19 80 ff 00 32 00 4c ff 00 5a 5=
a 5a 6b 6b 6b 6b 6b 6b Padding 0xffff81000d1cc1a0:  6b 6b 6b kkkkkkkkkkkkkk=
kk
 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
 Padding 0xffff81000d1cc1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b Padding 0xffff81000d1cc200:  04 d4 ff =EF=BF=BD.!.....=EF=BF=BD=EF=BF=
=BD2.=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
 00 72 00 01 00 5a 5a 5a 78 65 ZZZZZZZZ\x2fdevi
 65 78 63 30 3a Padding 0xffff81000d1cc270:  78 30 3a 3a 2e 32 66 62 78 33 =
2\x2fusb3\x2f3-1
 78 2d 32 78 2d Padding 0xffff81000d1cc2a0:  31 32 33 32 .2.1\x2f3-1.2.1:
 2e 78 69 75 78 1.1\x2finput\x2f
 6e 74 78 int\x2fusbdev3.5
 70 00 cc cc 1c ff 2c 80 ff ff ff ff =EF=BF=BD=EF=BF=BD....=EF=BF=BD=EF=BF=
=BDM6,.=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
 Padding 0xffff81000d1cc480:  00 00 00 00 30 1a 00 00 fd 00 Padding 0xffff8=
1000d1cc490:  00 00 00 00 00 00 00 00 5a 5a ........ZZZZZZZZ
 78 64 30 32 73 Padding 0xffff81000d1cc4e0:  32 2d 78 33 2e 32 32 31 2e 78 =
2\x2f3-1.2.1\x2f
 31 2e 2e 5c 66 6e 5c 66 70 5c Padding 0xffff81000d1cc520:  6d 73 6b 6b 2fm=
ouse2.kkkkkk=EF=BF=BD
 cc cc cc 0d ff Padding 0xffff81000d1cc540:  2c ff 00 00 00 Padding 0xffff8=
1000d1cc550:  ff 00 26 ff ff 00 00 00 fd 00 ........b.=EF=BF=BD=EF=BF=BD...=
.
 5a 5a 5a 32 65 ZZZZZZZZ\x2fdevi
 65 78 32 66 70 63 69 30 30 30 30 3a 30 ces\x2fpci0000:0
 Padding 0xffff81000d1cc590:  30 3a 3a 0\x2f0000:00:02.
 32 32 62 78 33 Padding 0xffff81000d1cc5b0:  78 2d 32 32 31 2e Padding 0xff=
ff81000d1cc5e0:  74 36 6b 6b cc cc cc 40 0d ff 2c ff @=EF=BF=BD....=EF=BF=
=BD=EF=BF=BDM6,.=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
 00 1a 91 ff 00 Padding 0xffff81000d1cc620:  00 00 00 00 00 00 00 00 5a 5a =
........ZZZZZZZZ
 78 64 63 5c 32 \x2fdevices\x2fp
 69 30 30 32 30 ci0000:00\x2f000
 30 30 32 32 73 33 32 2d 78 33 2e 32 32 31 32 78 2\x2f3-1.2.1\x2f
 Padding 0xffff81000d1cc690:  33 2d 31 2e 32 2e 31 3a 31 2e 30 5c 78 66 Pad=
ding 0xffff81000d1cc6a0:  75 78 69 74 Padding 0xffff81000d1cc6b0:  65 6e 00=
 6b 6b Padding 0xffff81000d1cc6c0:  00 Padding 0xffff81000d1cc6f0:  00 00 0=
0 00 00 5a 5a 5a 32 76 Padding 0xffff81000d1cc710:  73 32 63 30 30 30 66 30=
 30 30 0\x2f0000:00:02.
 5c 75 33 32 2d Padding 0xffff81000d1cc740:  66 2d 32 66 31 2e 5c 32 2d 2e =
.2.1\x2f3-1.2.1:
 30 32 69 75 32 69 75 76 65 6e 74 36 input6\x2fevent6
 Padding 0xffff81000d1cc910:  00 6b 6b 6b 6b 6b 6b cc cc cc Padding 0xffff8=
1000d1cc920:  0d ff 36 ff `=EF=BF=BD....=EF=BF=BD=EF=BF=BDM6,.=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD
 00 46 00 fd 00 ....F.....=EF=BF=BD=EF=BF=BD....
 00 00 00 00 00 00 00 00 5a 5a 5a 5c 64 69 73 32 Padding 0xffff81000d1cc990=
:  33 5c 33 2e 32 32 31 31 32 Padding 0xffff81000d1cc9b0:  31 31 2e 78 75 7=
3 6e 6f 74 78 sb_endpoint\x2fu
 64 33 5f 38 6b Padding 0xffff81000d1cc9e0:  cc cc ca 0d =EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD(=EF=BF=BD....=EF=BF=
=BD=EF=BF=BD
 36 ff 00 00 00 Padding 0xffff81000d1cca00:  fd 00 00 00 Padding 0xffff8100=
0d1cca10:  00 00 00 00 00 00 00 00 00 00 00 00 00 ................
 Padding 0xffff81000d1cca20:  5a 5a 5c 66 69 63 5c 66 69 30 ces\x2fpci0000:=
0
 30 32 30 3a 30 0\x2f0000:00:02.
 5c 66 62 32 2d Padding 0xffff81000d1cca60:  32 2e 78 33 \x2f3-1.2\x2f3-1
 32 78 33 2e 64 35 65 32 a5 cc cc _ep82.k=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
 1c 81 36 80 ff 1a 05 00 00 00 00 00 00 00 ................
 00 00 00 5a 5a Padding 0xffff81000d1ccaf0:  32 65 69 73 32 Padding 0xffff8=
1000d1ccb00:  30 30 30 32 30 30 30 30 32 32 62 Padding 0xffff81000d1ccb20: =
 33 5c 78 32 66 33 2d 31 5c 78 32 66 33 2d 31 2e Padding 0xffff81000d1ccb30=
:  78 33 2e 31 32 Padding 0xffff81000d1ccb40:  31 2e 2e 78 69 6e 74 66 70 3=
7 nput\x2finput7\x
 66 6e 00 6b 6b Padding 0xffff81000d1ccb70:  cc cc ce 00 ff =EF=BF=BD.=EF=
=BF=BD=EF=BF=BD.....&,.=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
 00 00 fd 00 Padding 0xffff81000d1ccbb0:  5a 5a 5c 66 76 Padding 0xffff8100=
0d1ccbc0:  73 66 69 30 ces\x2fpci0000:0
 5c 66 30 30 30 0\x2f0000:00:02.
 78 75 5c 32 32 31 5c 66 31 2e 31 66 31 2e .2.1\x2f3-1.2.1:
 2e 32 6e 74 32 Padding 0xffff81000d1ccc20:  70 5c 66 00 6b 6b 6b 6b 6b 6b =
a5 cc cc cc cc cc cc cc cc 10 1c ff 36 ff .=EF=BF=BD....=EF=BF=BD=EF=BF=BDM=
6,.=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
 00 b0 d2 ff 00 Padding 0xffff81000d1ccdf0:  00 00 00 00 Padding 0xffff8100=
0d1cce00:  00 00 5a 5a 5a 09 00 83 00 ........(.....=EF=BF=BD=EF=BF=BD
 00 14 00 ce 01 00 ca 01 00 b7 00 =EF=BF=BD=EF=BF=BD......L=EF=BF=BDX.....
 b8 00 00 00 00 Padding 0xffff81000d1cce70:  57 00 02 00 00 c3 00 00 00 00 =
=C3=B8W.............
 cc cc cc 1c 81 Padding 0xffff81000d1ccea0:  34 ff 00 00 00 Padding 0xffff8=
1000d1cceb0:  21 32 ff Padding 0xffff81000d1ccec0:  00 00 00 21 01 00 00 00=
 ....r5..=EF=BF=BD.!.....
 Padding 0xffff81000d1cced0:  5a 5a 5a 5a 5a 5a 5a 5a 78 64 ZZZZZZZZ\x2fdev=
i
 73 78 63 30 30 Padding 0xffff81000d1ccef0:  32 30 30 30 Padding 0xffff8100=
0d1ccf00:  78 73 5c 32 2d 5c 66 31 78 33 31 32 78 33 78 76 37 00 6b a5 cc c=
c .kkkkkk=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD
 00 00 4d 80 ff Padding 0xffff81000d1ccf70:  00 00 fd 00 Padding 0xffff8100=
0d1ccf80:  00 00 00 00 ................
 00 00 5a 5a 5aFIX kmalloc-128: Restoring 0xffff81000d1cc000-0xffff81000d1c=
cfff=3D0x5a
---------------------------------------------------------------------------=
--
 age=3D11936128522596731725 cpu=3D1515870810 pid=3D1515870810
INFO: Slab 0xffff810001481e20 used=3D18 fp=3D0xffff81000d1cc000 flags=3D0x4=
0000000000000c3
  Object 0xffff81000d1cc000:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a ZZZZZZZZZZZZZZZZ
 5a 5a 5a 5a 5a 5a  Object 0xffff81000d1cc050:  5a 5a 5a  Object 0xffff8100=
0d1cc060:  5a 5a 5a 5a 5a 5a 5a 5a 5a       5a 5a    ZZZZZZZZ       =20
 [<ffffffff802a9a15>] check_bytes_and_report+0xc5/0x100
 [<ffffffff80342ab3>] blocknr_set_add+0x113/0x180
 [<ffffffff80367579>] kill_hook_extent+0x389/0x4a0
 [<ffffffff8036bd36>] max_item_key_by_coord+0x36/0x50
 [<ffffffff8035b2b0>] kill_head+0x0/0x30
 [<ffffffff8020c1de>] system_call+0x7e/0x83
Unable to handle kernel paging request at ffff80fffffffff8 RIP:=20
 [<ffffffff803356e5>] count_deleted_blocks_actor+0x5/0x20
PGD 0=20
Oops: 0000 [1] PREEMPT SMP=20
CPU 0=20
Modules linked in: nls_iso8859_1 isofs nls_base netconsole usb_storage usbh=
id hid libusual snd_pcm_oss snd_mixer_oss sg ipv6 evdev snd_intel8x0 snd_ac=
97_codec ac97_bus psmouse snd_pcm ehci_hcd snd_timer serio_raw ohci_hcd snd=
 snd_page_alloc usbcore
Pid: 7793, comm: gnome-volume-ma Not tainted 2.6.23-rc1-mm1 #1
RIP: 0010:[<ffffffff803356e5>]  [<ffffffff803356e5>] count_deleted_blocks_a=
ctor+0x5/0x20
RSP: 0018:ffff8100150b9ca0  EFLAGS: 00010282
RAX: 000000000d1ccea0 RBX: 0000000000d1ccea RCX: ffff8100150b9d10
RDX: ffff80fffffffff8 RSI: ffff80fffffffff0 RDI: ffff810020c27400
RBP: ffff81000d1cce10 R08: 000000005a5a5a5a R09: 0000000000000000
R10: ffffffff80335902 R11: 000000000000009a R12: ffff81000d1cce90
R13: ffff810003dcbc01 R14: ffff8100150b9d10 R15: ffffffff803356e0
FS:  00002b66943fe730(0000) GS:ffffffff806bf000(0000) knlGS:00000000f63c69d=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff80fffffffff8 CR3: 0000000008a8e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gnome-volume-ma (pid: 7793, threadinfo ffff8100150b8000, task ffff8=
10009280fd0)
Stack:  ffffffff80342939 ffff810003dcbc38 0000000003dcb9f8 ffff810020c27458
 ffff810020c27400 5a5a5a5a5a5a5a5a ffff810020c27400 ffff810003dcbc38
 ffff810003dcb9f8 ffff810003dcbc08 ffff8100150b9d10 ffff810008c82480
Call Trace:
 [<ffffffff80342939>] blocknr_set_iterator+0xc9/0x130
 [<ffffffff80335927>] txnmgr_count_deleted_blocks+0xc7/0x100
 [<ffffffff803438b6>] reiser4_statfs+0x76/0x120
 [<ffffffff802ae8f7>] vfs_statfs+0x67/0x80
 [<ffffffff802aeb2a>] vfs_statfs_native+0x2a/0x70
 [<ffffffff802aec95>] sys_statfs+0x85/0xc0
 [<ffffffff802afceb>] do_readv_writev+0x16b/0x220
 [<ffffffff802b0133>] vfs_read+0x173/0x180
 [<ffffffff8020c1de>] system_call+0x7e/0x83

48 02 01 c0 66 48 31 c3 BUG: sleeping function called from invalid context =
at kernel/rwsem.c:20
 [<ffffffff80257615>] down_read+0x15/0x40
 [<ffffffff802a999b>] check_bytes_and_report+0x4b/0x100
 [<ffffffff803356e0>] count_deleted_blocks_actor+0x0/0x20
 [<ffffffff80342939>] blocknr_set_iterator+0xc9/0x130
 [<ffffffff802aeb2a>] vfs_statfs_native+0x2a/0x70
 [<ffffffff8053657c>] trace_hardirqs_on_thunk+0x35/0x37
BUG: scheduling while atomic: gnome-volume-ma/0x10000003/7793
 [<ffffffff8023d72f>] release_console_sem+0x4f/0x220
 [<ffffffff80533fb2>] cond_resched+0x32/0x40
 [<ffffffff80539bb3>] do_page_fault+0x613/0x8b0
 [<ffffffff803356e0>] count_deleted_blocks_actor+0x0/0x20
 [<ffffffff803356e5>] count_deleted_blocks_actor+0x5/0x20
 [<ffffffff802ae8f7>] vfs_statfs+0x67/0x80
 [<ffffffff802b0133>] vfs_read+0x173/0x180
INFO: lockdep is turned off.
SysRq : Emergency Sync
BUG: spinlock lockup on CPU#0, ktxnmgrd:sda2:r/539, ffff810003dcbc08

Call Trace:
 [<ffffffff803db034>] _raw_spin_lock+0x134/0x140
 [<ffffffff80337e64>] commit_some_atoms+0x34/0x150
 [<ffffffff80337e64>] commit_some_atoms+0x34/0x150
 [<ffffffff80342510>] ktxnmgrd+0x0/0x1a0
 [<ffffffff80342651>] ktxnmgrd+0x141/0x1a0
 [<ffffffff80342510>] ktxnmgrd+0x0/0x1a0
 [<ffffffff80253cab>] kthread+0x4b/0x80
 [<ffffffff8020d098>] child_rip+0xa/0x12
 [<ffffffff8020c780>] restore_args+0x0/0x30
 [<ffffffff80253c60>] kthread+0x0/0x80
 [<ffffffff8020d08e>] child_rip+0x0/0x12

INFO: lockdep is turned off.
NMI backtrace for cpu 0

Call Trace:
 <NMI>  [<ffffffff805388e9>] nmi_watchdog_tick+0x159/0x1e0
 [<ffffffff80537d86>] default_do_nmi+0x76/0x1e0
 [<ffffffff805389ad>] do_nmi+0x3d/0x60
 [<ffffffff80537a9f>] nmi+0x7f/0x80
 [<ffffffff8023d72f>] release_console_sem+0x4f/0x220
 [<ffffffff803cc378>] __delay+0x8/0x20
 <<EOE>>  [<ffffffff8021edff>] __trigger_all_cpu_backtrace+0x1f/0x40
 [<ffffffff803db039>] _raw_spin_lock+0x139/0x140
 [<ffffffff80337e64>] commit_some_atoms+0x34/0x150
 [<ffffffff80337e64>] commit_some_atoms+0x34/0x150
 [<ffffffff80342510>] ktxnmgrd+0x0/0x1a0
 [<ffffffff80342651>] ktxnmgrd+0x141/0x1a0
 [<ffffffff80342510>] ktxnmgrd+0x0/0x1a0
 [<ffffffff80253cab>] kthread+0x4b/0x80
 [<ffffffff8020d098>] child_rip+0xa/0x12
 [<ffffffff8020c780>] restore_args+0x0/0x30
 [<ffffffff80253c60>] kthread+0x0/0x80
 [<ffffffff8020d08e>] child_rip+0x0/0x12

INFO: lockdep is turned off.
Hangcheck: hangcheck value past margin!
SysRq : Resetting

--=20
Zan Lynx <zlynx@acm.org>

--=-4jRsNg/LJHvMdir6t2pb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGr6v1G8fHaOLTWwgRAi7yAJ9EhzN2snf7EispzELGfX5eNHthlwCgqge6
ksZgMZdT646K987TSNxdXgI=
=oktk
-----END PGP SIGNATURE-----

--=-4jRsNg/LJHvMdir6t2pb--

