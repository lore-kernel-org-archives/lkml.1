Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbXHQLJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbXHQLJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762265AbXHQLJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:09:23 -0400
Received: from main.gmane.org ([80.91.229.2]:41812 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762309AbXHQLJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:09:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: Unable to handle kernel NULL pointer dereference at 0000000000000001
 RIP
Date: Fri, 17 Aug 2007 12:59:36 +0200
Message-ID: <fa3v2o$m16$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: merlin2.provinz.bz.it
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

our SLES production system
2.6.5-7.252-smp #1 SMP Tue Feb 14 11:11:04 UTC 2006 x86_64 x86_64 x86_64
stopped with the following messages in the log
Is this a known bug in this version and is it solved in the next versions.

As I wrote it is a production server so I can't change away from reiserfs.

Thanks
Andreas Moroder

Aug 16 22:00:07 falcon1 su: pam_unix2: session started for user oracle, 
service su
Aug 16 22:00:37 falcon1 kernel: Unable to handle kernel NULL pointer 
dereference at 0000000000000001 RIP:
Aug 16 22:00:37 falcon1 kernel: 
<ffffffffa00b3d26>{:reiserfs:reiserfs_clear_inode+22}
Aug 16 22:00:37 falcon1 kernel: PML4 12c07a067 PGD 103721067 PMD 0
Aug 16 22:00:37 falcon1 kernel: Oops: 0002 [1] SMP
Aug 16 22:00:37 falcon1 kernel: CPU 2
Aug 16 22:00:37 falcon1 kernel: Pid: 224, comm: kswapd0 Tainted: P   UM 
  (2.6.5-7.252-smp SLES9_SP3_BRANCH-200602141111040000)
Aug 16 22:00:37 falcon1 kernel: RIP: 0010:[<ffffffffa00b3d26>] 
<ffffffffa00b3d26>{:reiserfs:reiserfs_clear_inode+22}
Aug 16 22:00:37 falcon1 kernel: RSP: 0000:000001013fdfdc08  EFLAGS: 00010213
Aug 16 22:00:37 falcon1 kernel: RAX: ffffffffa00b3d10 RBX: 
00000100b8fd49f8 RCX: ffffffff8053fa80
Aug 16 22:00:37 falcon1 kernel: RDX: 000001013fdfdc78 RSI: 
00000100b8fd4680 RDI: 0000000000000001
Aug 16 22:00:37 falcon1 kernel: RBP: 00000100b8fd49f8 R08: 
000001000a75c810 R09: 0000000000000001
Aug 16 22:00:37 falcon1 kernel: R10: 0000000000000000 R11: 
00000000fffffb11 R12: 000001013fdfdc78
Aug 16 22:00:37 falcon1 kernel: R13: 0000000000000031 R14: 
ffffffff803e6b20 R15: 000001013fdfdc78
Aug 16 22:00:37 falcon1 kernel: FS:  0000000000000000(0000) 
GS:ffffffff8057d000(0000) knlGS:0000000000000000
Aug 16 22:00:37 falcon1 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 
000000008005003b
Aug 16 22:00:37 falcon1 kernel: CR2: 0000000000000001 CR3: 
000000000a6b1000 CR4: 00000000000006e0
Aug 16 22:00:37 falcon1 kernel: Process kswapd0 (pid: 224, threadinfo 
000001013fdfc000, task 000001013fe2aa40)
Aug 16 22:00:37 falcon1 kernel: Stack: 00000100b8fd49f8 ffffffff801aa7eb 
00000100b8fd4a08 ffffffff801aa898
Aug 16 22:00:37 falcon1 kernel:        0000010005147530 0000010046a47d08 
0000010046a47cf8 0000000000000080
Aug 16 22:00:37 falcon1 kernel:        0000000000000080 ffffffff801aab17
Aug 16 22:00:37 falcon1 kernel: Call 
Trace:<ffffffff801aa7eb>{clear_inode+155} 
<ffffffff801aa898>{dispose_list+104}
Aug 16 22:00:37 falcon1 kernel: 
<ffffffff801aab17>{shrink_icache_memory+471} 
<ffffffff80172c55>{shrink_slab+245}
Aug 16 22:00:37 falcon1 kernel: 
<ffffffff80172ecd>{balance_pgdat+477} <ffffffff80173226>{kswapd+390}
Aug 16 22:00:37 falcon1 kernel:        <ffffffff80141461>{do_exit+3505} 
<ffffffff8013d3e0>{autoremove_wake_function+0}
Aug 16 22:00:37 falcon1 kernel: 
<ffffffff8013d3e0>{autoremove_wake_function+0} 
<ffffffff801111b7>{child_rip+8}
Aug 16 22:00:37 falcon1 kernel:        <ffffffff801730a0>{kswapd+0} 
<ffffffff801111af>{child_rip+0}
Aug 16 22:00:37 falcon1 kernel:
Aug 16 22:00:37 falcon1 kernel:
Aug 16 22:00:37 falcon1 kernel: Code: f0 ff 0f 0f 94 c0 84 c0 74 05 e8 
0b a4 0b e0 48 8b 7b e0 48
Aug 16 22:00:37 falcon1 kernel: RIP 
<ffffffffa00b3d26>{:reiserfs:reiserfs_clear_inode+22} RSP <000001013fdfdc08>
Aug 16 22:00:37 falcon1 kernel: CR2: 0000000000000001

