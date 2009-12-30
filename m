Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZL3Qsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZL3Qsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZL3Qsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:48:42 -0500
Received: from mailout.uni-giessen.de ([134.176.2.3]:37182 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZL3Qsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:48:41 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Dec 2009 11:48:41 EST
From: Marvin <marvin24@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: vfs related crash in 2.6.33-rc2
Date: Wed, 30 Dec 2009 17:33:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc2; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912301733.19077.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm getting a lot of these:

kernel: general protection fault: 0000 [#1] SMP
kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/modalias
kernel: CPU 0
kernel: Pid: 12177, comm: packagekitd Not tainted 2.6.33-rc2 #1 GA-MA69VM-S2/GA-
MA69VM-S2
kernel: RIP: 0010:[<ffffffff81111984>]  [<ffffffff81111984>] __d_lookup+0x84/0x140
kernel: RSP: 0018:ffff880032281bf8  EFLAGS: 00010286
kernel: RAX: bc004303ff008e00 RBX: bc004303ff008e00 RCX: 0000000000000011
kernel: RDX: 018721e0aefe22a8 RSI: ffff880032281ce8 RDI: ffff88003b4c8540
kernel: RBP: ffff880032281c48 R08: 0016c3c8f8b84e99 R09: 0000000000001000
kernel: R10: 61746f742f363331 R11: 0000000000000246 R12: bc004303ff008de8
kernel: R13: ffff88003b4c8540 R14: 00000000afeb6093 R15: ffff880032281ce8
kernel: FS:  00007fcee6297910(0000) GS:ffff880001a00000(0000) knlGS:00000000f76ba6c0
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007fcee6288b3c CR3: 000000000be7c000 CR4: 00000000000006f0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process packagekitd (pid: 12177, threadinfo ffff880032280000, task 
ffff88003a874320)
kernel: Stack:
kernel: ffff880032281c18 ffff88002150201c 0000000d264cf090 000000000000000d
kernel: <0> ffff880032281c48 ffff880032281dd8 ffff880032281cf8 ffff880032281ce8
kernel: <0> ffff880038aa9a00 ffff880032281cf8 ffff880032281c98 ffffffff811069c5
kernel: Call Trace:
kernel: [<ffffffff811069c5>] do_lookup+0x55/0x270
kernel: [<ffffffff8110905d>] link_path_walk+0x69d/0xe70
kernel: [<ffffffff811099b8>] path_walk+0x58/0xc0
kernel: [<ffffffff81109a73>] do_path_lookup+0x53/0xa0
kernel: [<ffffffff8110a6a3>] user_path_at+0x53/0xa0
kernel: [<ffffffff811edcab>] ? _atomic_dec_and_lock+0x6b/0x90
kernel: [<ffffffff811013f3>] ? cp_new_stat+0xf3/0x110
kernel: [<ffffffff81101617>] vfs_fstatat+0x37/0x70
kernel: [<ffffffff811016b9>] vfs_lstat+0x19/0x20
kernel: [<ffffffff811016df>] sys_newlstat+0x1f/0x50
kernel: [<ffffffff81002d2b>] system_call_fastpath+0x16/0x1b
kernel: Code: e0 03 48 03 05 ee df 75 00 48 8b 18 8b 45 c4 48 85 db 48 89 45 c8 75 0f 
eb 71 0f 1f 44 00 00 48 8b 1b 48 85 db 74 64 4c 8d 63 e8 <48> 8b 03 45 39 74 24 30 0f 
18 08 75 e7 4d 39 6c 24 28 75 e0 49
kernel: RIP  [<ffffffff81111984>] __d_lookup+0x84/0x140
kernel: RSP <ffff880032281bf8>
kernel: ---[ end trace 20357edf03a4cafd ]---

filesystem is ext4 (in case it matters). 

Cheers

Marvin

