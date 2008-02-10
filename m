Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYBJVzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYBJVzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYBJVzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:55:33 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36556 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYBJVzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:55:32 -0500
Date: Sun, 10 Feb 2008 22:55:28 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 oops
Message-ID: <20080210215527.GA4330@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 10 Feb 2008 22:55:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I encountered an oops while playing a movie with mplayer.
(couple of hours before, I tried this exploit:
http://www.securityfocus.com/data/vulnerabilities/exploits/27704.c
so the oops may be induced by the exploit.)

[12695.120141] Unable to handle kernel paging request at 0000100000000000 RIP: 
[12695.120152]  [<ffffffff802705bb>] find_get_page+0x3b/0x80
[12695.120166] PGD 0 
[12695.120172] Oops: 0000 [1] PREEMPT SMP 
[12695.120180] CPU 0 
[12695.120184] Modules linked in: cdc_ether usbnet mii cdc_acm usb_storage des_generic cbc nfs lockd rpcsec_gss_krb5 auth_rpcgss sunrpc i915 drm rfcomm l2cap bluetooth fuse arc4 ecb blkcipher e1000 ehci_hcd uhci_hcd snd_hda_intel thinkpad_acpi intel_agp
[12695.120228] Pid: 10382, comm: mplayer Not tainted 2.6.24 #2
[12695.120232] RIP: 0010:[<ffffffff802705bb>]  [<ffffffff802705bb>] find_get_page+0x3b/0x80
[12695.120242] RSP: 0018:ffff8100794d7ca8  EFLAGS: 00210006
[12695.120247] RAX: 0000100000000000 RBX: 0000100000000000 RCX: 0000000000000000
[12695.120252] RDX: ffff81000efe0000 RSI: 000000000001b3c0 RDI: 0000000000000000
[12695.120257] RBP: ffff81007ceffeb8 R08: 0000000000000000 R09: ffffffff80270330
[12695.120262] R10: 0000000000000000 R11: 0000000000000001 R12: 000000000001b3c0
[12695.120267] R13: 0000000000000001 R14: ffff81000cf8a728 R15: ffff81000cf8a6c0
[12695.120273] FS:  00002af6ae621610(0000) GS:ffffffff8062b000(0000) knlGS:0000000000000000
[12695.120278] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12695.120283] CR2: 0000100000000000 CR3: 00000000512b7000 CR4: 00000000000006e0
[12695.120288] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12695.120292] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12695.120298] Process mplayer (pid: 10382, threadinfo ffff8100794d6000, task ffff81007c230000)
[12695.120303] Stack:  ffff8100794d7ed8 ffff81007ceffea0 000000000001b3c0 ffffffff80270efb
[12695.120313]  0000000000037000 ffffffff80270330 ffff8100794d7d68 ffff8100794d7e58
[12695.120322]  ffff81000cf8a728 ffff81007ceffd78 000000000001b3c1 000000000001b3bf
[12695.120329] Call Trace:
[12695.120338]  [<ffffffff80270efb>] do_generic_mapping_read+0x10b/0x400
[12695.120345]  [<ffffffff80270330>] file_read_actor+0x0/0x1a0
[12695.120355]  [<ffffffff80272a8f>] generic_file_aio_read+0xff/0x1b0
[12695.120366]  [<ffffffff80298a99>] do_sync_read+0xd9/0x120
[12695.120373]  [<ffffffff802528ae>] enqueue_hrtimer+0x6e/0x110
[12695.120383]  [<ffffffff8024fed0>] autoremove_wake_function+0x0/0x30
[12695.120391]  [<ffffffff804c46f9>] do_nanosleep+0x69/0x90
[12695.120397]  [<ffffffff802533c8>] hrtimer_nanosleep+0x78/0x140
[12695.120404]  [<ffffffff80252bb0>] hrtimer_wakeup+0x0/0x30
[12695.120411]  [<ffffffff804c46e5>] do_nanosleep+0x55/0x90
[12695.120417]  [<ffffffff802993b5>] vfs_read+0xc5/0x160
[12695.120422]  [<ffffffff8029984b>] sys_read+0x3b/0x90
[12695.120429]  [<ffffffff80299863>] sys_read+0x53/0x90
[12695.120437]  [<ffffffff8020c47e>] system_call+0x7e/0x83
[12695.120444] 
[12695.120446] 
[12695.120447] Code: 48 8b 00 48 89 da 25 00 40 02 00 48 3d 00 40 02 00 74 22 f0 
[12695.120472] RIP  [<ffffffff802705bb>] find_get_page+0x3b/0x80
[12695.120480]  RSP <ffff8100794d7ca8>
[12695.120484] CR2: 0000100000000000
[12695.120490] ---[ end trace a272000ffa9585c7 ]---
[12695.120496] note: mplayer[10382] exited with preempt_count 1

-- 
Luká¹ Hejtmánek
