Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXIXKgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXIXKgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXIXKg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:36:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40815 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbXIXKgY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:36:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc7-mm1 - 'touch' command causes Oops.
In-Reply-To: Your message of "Mon, 24 Sep 2007 02:17:16 PDT."
             <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190630150_3103P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 06:35:50 -0400
Message-ID: <3339.1190630150@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190630150_3103P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 02:17:16 PDT, Andrew Morton said:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/

It lived fast, it died young, it didn't leave a pretty corpse...

Something in the startup scripts did a 'touch', and ker-blam.

[   15.668000] Unable to handle kernel NULL pointer dereference at 0000000000000252 RIP: 
[   15.668000]  [<ffffffff802a1dd1>] __mnt_is_readonly+0x9/0x1e
[   15.668000] PGD 52be067 PUD 5645067 PMD 0 
[   15.668000] Oops: 0000 [1] PREEMPT SMP 
[   15.668000] last sysfs file: /block/dm-13/dev
[   15.668000] CPU 0 
[   15.668000] Modules linked in: rtc
[   15.668000] Pid: 528, comm: touch Not tainted 2.6.23-rc7-mm1 #1
[   15.668000] RIP: 0010:[<ffffffff802a1dd1>]  [<ffffffff802a1dd1>] __mnt_is_readonly+0x9/0x1e
[   15.668000] RSP: 0018:ffff8100045fddd8  EFLAGS: 00010202
[   15.668000] RAX: 0000000000000001 RBX: ffff810002c10680 RCX: 0000000000000001
[   15.668000] RDX: ffff810082504000 RSI: ffff810005243168 RDI: 0000000000000202
[   15.668000] RBP: ffff8100045fddd8 R08: 0000000000000001 R09: 0000000000000002
[   15.668000] R10: 0000000000000000 R11: ffff8100045fde68 R12: 0000000000000202
[   15.668000] R13: 00000000ffffffe2 R14: ffff8100052c1d80 R15: ffff8100039aa8a0
[   15.668000] FS:  00007f9527f596f0(0000) GS:ffffffff806b6000(0000) knlGS:0000000000000000
[   15.668000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   15.668000] CR2: 0000000000000252 CR3: 00000000052cb000 CR4: 00000000000006e0
[   15.668000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.668000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   15.668000] Process touch (pid: 528, threadinfo ffff8100045fc000, task ffff8100047517e0)
[   15.668000] last branch before last exception/interrupt
[   15.668000]  from  [<ffffffff802a4d1b>] mnt_want_write+0x44/0xb5
[   15.668000]  to  [<ffffffff802a1dc8>] __mnt_is_readonly+0x0/0x1e
[   15.668000] Stack:  ffff8100045fde08 ffffffff802a4d20 ffff8100045fddf8 0000000000000000
[   15.668000]  00000000fffffff7 ffff810005243140 ffff8100045fdf28 ffffffff802ad288
[   15.668000]  ffff8100045fde58 0000000000000202 ffff8100045fde58 ffffffff8035437b
[   15.668000] Call Trace:
[   15.668000]  [<ffffffff802a4d20>] mnt_want_write+0x49/0xb5
[   15.668000]  [<ffffffff802ad288>] do_utimes+0xd0/0x220
[   15.668000]  [<ffffffff8035437b>] __up_read+0x7a/0x83
[   15.668000]  [<ffffffff8024b1af>] up_read+0x9/0xb
[   15.668000]  [<ffffffff8051977c>] do_page_fault+0x421/0x7d0
[   15.668000]  [<ffffffff8028b370>] do_filp_open+0x36/0x46
[   15.668000]  [<ffffffff802ad519>] sys_utimensat+0x8b/0xa5
[   15.668000]  [<ffffffff80517a4d>] error_exit+0x0/0x84
[   15.668000]  [<ffffffff8020c10e>] system_call+0x7e/0x83
[   15.668000] 
[   15.668000] 
[   15.668000] Code: f6 47 50 40 75 0d 48 8b 47 28 8a 40 58 83 e0 01 0f b6 c0 c9 
[   15.668000] RIP  [<ffffffff802a1dd1>] __mnt_is_readonly+0x9/0x1e
[   15.668000]  RSP <ffff8100045fddd8>
[   15.668000] CR2: 0000000000000252


--==_Exmh_1190630150_3103P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG95MGcC3lWbTT17ARAuZeAJ9jU8w/8GNsBIVEfp8CkfZDh+fOMQCgjbc4
orDrUw4WST89LFVTNX6FXBM=
=JFL2
-----END PGP SIGNATURE-----

--==_Exmh_1190630150_3103P--
