Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbXIXMzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbXIXMzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 08:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbXIXMzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 08:55:45 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:44127 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXIXMzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 08:55:44 -0400
Message-ID: <46F7B3B3.7010600@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 18:25:15 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Kernel oops over x86_64 (AMD Opteron(tm) Processor 844)

Unable to handle kernel NULL pointer dereference at 0000000000000070 RIP: 
 [<ffffffff80290630>] fasync_helper+0x6b/0xe4
PGD 181949067 PUD 182228067 PMD 0 
Oops: 0000 [1] SMP 
last sysfs file: /devices/system/node/possible
CPU 3 
Modules linked in:
Pid: 18156, comm: fcntl23 Not tainted 2.6.23-rc7-mm1-autokern1 #1
RIP: 0010:[<ffffffff80290630>]  [<ffffffff80290630>] fasync_helper+0x6b/0xe4
RSP: 0000:ffff810082bdfdb8  EFLAGS: 00010046
RAX: 00000000fffffff4 RBX: ffff8101821a9000 RCX: 0000000000000000
RDX: ffff8101821a9000 RSI: ffff810180026900 RDI: ffffffff806286b8
RBP: ffff810082bdfde8 R08: 0000000000000002 R09: ffff81018072124b
R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000070
R13: 0000000000000001 R14: 0000000000000000 R15: ffff810181875cc0
FS:  0000000000000000(0000) GS:ffff810180721380(0063) knlGS:00000000556aa2a0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000000000070 CR3: 00000001818c4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fcntl23 (pid: 18156, threadinfo ffff810082bde000, task ffff810082309530)
last branch before last exception/interrupt
 from  [<ffffffff804ad9e0>] _write_lock_irq+0x14/0x15
 to  [<ffffffff80290630>] fasync_helper+0x6b/0xe4
Stack:  0000000400000004 0000000000000000 0000000000000000 ffff810181875cc0
 0000000000000004 ffff810182b3d238 ffff810082bdfee8 ffffffff802939cc
 ffff810082bdfe18 0000000000000000 0000000000000000 ffff810082bdfe10
Call Trace:
 [<ffffffff802939cc>] fcntl_setlease+0x99/0x101
 [<ffffffff80290370>] sys_fcntl+0x2a3/0x2ce
 [<ffffffff802b14cf>] compat_sys_fcntl64+0x2ee/0x2ff
 [<ffffffff80224292>] ia32_sysret+0x0/0xa
DWARF2 unwinder stuck at ia32_sysret+0x0/0xa
Leftover inexact backtrace:
Code: 49 8b 34 24 4c 89 e2 48 85 f6 74 2a 4c 39 7e 10 75 1a 45 85 
RIP  [<ffffffff80290630>] fasync_helper+0x6b/0xe4
 RSP <ffff810082bdfdb8>
CR2: 0000000000000070

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
