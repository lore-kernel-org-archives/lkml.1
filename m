Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZGLMrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZGLMrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 08:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZGLMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 08:47:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:56891 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbZGLMrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 08:47:22 -0400
Subject: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 12 Jul 2009 16:47:10 +0200
Message-Id: <1247410030.1095.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 6190.368242] Restarting tasks ... done.
[ 6191.252241] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[ 6191.252253] IP: [<ffffffff8134beea>] strchr+0x24/0x45
[ 6191.252253] PGD 182503067 PUD 1771f4067 PMD 0 
[ 6191.252253] Oops: 0000 [#1] PREEMPT SMP 
[ 6191.252253] last sysfs file: /sys/devices/pci0000:00/0000:00:0f.0/0000:07:00.1/class
[ 6191.252253] CPU 1 
[ 6191.252253] Modules linked in: rndis_wlan floppy olympic forcedeth [last unloaded: scsi_wait_scan]
[ 6191.252253] Pid: 23330, comm: gvfs-gdu-volume Tainted: G        W  2.6.31-rc2 #79 MS-7250
[ 6191.252253] RIP: 0010:[<ffffffff8134beea>]  [<ffffffff8134beea>] strchr+0x24/0x45
[ 6191.252253] RSP: 0018:ffff8801771b9d98  EFLAGS: 00010246
[ 6191.252253] RAX: 0000000000000040 RBX: 0000000000000001 RCX: 0000000000000008
[ 6191.252253] RDX: 0000000000000000 RSI: 000000000000002c RDI: 0000000000000040
[ 6191.252253] RBP: 0000000000000000 R08: 0000000000008020 R09: ffffffffffffffff
[ 6191.252253] R10: 0000000003e36d36 R11: ffffffff812e3591 R12: ffff880151808780
[ 6191.252253] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 6191.252253] FS:  00007f77e395a790(0000) GS:ffff880028050000(0000) knlGS:0000000000000000
[ 6191.252253] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6191.252253] CR2: 0000000000000040 CR3: 0000000182416000 CR4: 00000000000006e0
[ 6191.252253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6191.252253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6191.252253] Process gvfs-gdu-volume (pid: 23330, threadinfo ffff8801771b8000, task ffff88019a22a0d0)
[ 6191.252253] Stack:
[ 6191.252253]  ffffffff81846b60 0000000003e36d36 0000000000000000 ffffffff812e37d7
[ 6191.252253] <0> ffff8801bd8f3600 ffff880151808780 ffff8801bd9eb2c0 ffff8801bd9eb2c0
[ 6191.252253] <0> ffff880100000001 0000000000000000 0000000000000000 0000000003e36d36
[ 6191.252253] Call Trace:
[ 6191.252253]  [<ffffffff812e37d7>] ? selinux_sb_show_options+0x246/0x33c
[ 6191.252253]  [<ffffffff811306a2>] ? show_vfsmnt+0xbb/0x133
[ 6191.252253]  [<ffffffff81134785>] ? seq_read+0x293/0x376
[ 6191.252253]  [<ffffffff81117f49>] ? vfs_read+0xb1/0x123
[ 6191.252253]  [<ffffffff811180a3>] ? sys_read+0x55/0x90
[ 6191.252253]  [<ffffffff8102bf2b>] ? system_call_fastpath+0x16/0x1b
[ 6191.252253] Code: d2 ff 48 83 c4 18 c3 48 83 ec 18 48 89 f8 65 48 8b 14 25 28 00 00 00 48 89 54 24 08 31 d2 eb 0b 84 d2 75 04 31 c0 eb 0a 48 ff c0 <8a> 10 40 38 f2 75 ee 48 8b 54 24 08 65 48 33 14 25 28 00 00 00 
[ 6191.252253] RIP  [<ffffffff8134beea>] strchr+0x24/0x45
[ 6191.252253]  RSP <ffff8801771b9d98>
[ 6191.252253] CR2: 0000000000000040
[ 6191.258135] ---[ end trace f7a4d612974b9b43 ]---


