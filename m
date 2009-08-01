Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZHAJuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZHAJuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 05:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZHAJuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 05:50:13 -0400
Received: from www17.your-server.de ([213.133.104.17]:57356 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZHAJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 05:50:12 -0400
Subject: kernel BUG at fs/btrfs/disk-io.c:2221!
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 11:50:08 +0200
Message-Id: <1249120208.14496.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel BUG at fs/btrfs/disk-io.c:2221! 
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/block/sdc/sdc1/start
CPU 1 
Modules linked in: btrfs olympic forcedeth rndis_wlan floppy [last unloaded: scsi_wait_scan]
Pid: 23806, comm: umount Tainted: G        W  2.6.31-rc4-rt1 #3 MS-7250
RIP: 0010:[<ffffffffa00589ad>]  [<ffffffffa00589ad>] write_all_supers+0x22f/0x259 [btrfs]
RSP: 0018:ffff88009e575ce8  EFLAGS: 00010292
RAX: 000000000000003a RBX: ffff8801980889f8 RCX: ffff88009e575ba8
RDX: 0000000000000000 RSI: 0000000000000202 RDI: 000000005661d985
RBP: 0000000000000001 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: ffff88009e575c88 R12: ffff88011e0b2000
R13: 0000000000000000 R14: ffff880198088980 R15: ffff88011e094ed6
FS:  00007fa0ba6ef740(0000) GS:ffff8800280ac000(0000) knlGS:00000000f49ffb70
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000be1858 CR3: 000000009204a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process umount (pid: 23806, threadinfo ffff88009e574000, task ffff8801bbd3a760)
Stack:
 ffff88009e575d10 ffff88011e094ee6 0000000100000000 ffff88011e094dcb
<0> ffff8801980889f8 000000008439bfff 000000008439c000 000000005661d985
<0> 00000000852b4000 ffff88011e0b2000 ffff88018024f8a0 ffff880091c92d70
Call Trace:
 [<ffffffffa005c510>] ? btrfs_commit_transaction+0x5ff/0x6d7 [btrfs]
 [<ffffffff810884bd>] ? autoremove_wake_function+0x0/0x55
 [<ffffffff81166dfc>] ? sync_quota_sb+0x58/0x133
 [<ffffffff8113a1a4>] ? __sync_filesystem+0x3b/0x82
 [<ffffffff81118cd3>] ? generic_shutdown_super+0x31/0x10c
 [<ffffffff81118e28>] ? kill_anon_super+0x1d/0x71
 [<ffffffff81119691>] ? deactivate_super+0x63/0xa6
 [<ffffffff81130949>] ? sys_umount+0x2e4/0x32a
 [<ffffffff8102bf2b>] ? system_call_fastpath+0x16/0x1b
Code: 24 90 01 00 00 48 8b b8 b0 21 00 00 48 83 c7 48 e8 dd 30 7b e1 3b 6c 24 10 7e 14 89 ee 48 c7 c7 1a 39 09 a0 31 c0 e8 eb 09 7b e1 <0f> 0b eb fe 31 c0 48 8b 54 24 38 65 48 33 14 25 28 00 00 00 74 
RIP  [<ffffffffa00589ad>] write_all_supers+0x22f/0x259 [btrfs]
 RSP <ffff88009e575ce8>
---[ end trace 1e2f23bdcf389667 ]---


