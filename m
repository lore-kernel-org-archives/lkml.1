Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXHJGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXHJGsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXHJGsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:48:45 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:46905 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbXHJGso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:48:44 -0400
Message-ID: <46BC0A34.9050806@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2007 12:18:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: kernel BUG at mm/swap_state.c:78 with the 2.6.23-rc2-mm1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following kernel Bug  on the 2.6.23-rc2-mm1 kernel on
a Dual Core AMD Opteron (processor 270),  while testing the  LTP
runall

================================================
kernel BUG at mm/swap_state.c:78!

invalid opcode: 0000 [1] SMP

CPU 0

Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc battery ac lp 
parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core button

Pid: 262, comm: kprefetchd Not tainted 2.6.23-rc2-mm1-autokern1 #1

RIP: 0010:[<ffffffff8027c443>]  [<ffffffff8027c443>] 
__add_to_swap_cache+0x12/0xa6

RSP: 0018:ffff81000299bea0  EFLAGS: 00010246

RAX: 0000000000000000 RBX: ffff81003f3baec0 RCX: ffff8100048c33b0

RDX: 00000000000000d0 RSI: 0000000000000001 RDI: 00000000000000d0

RBP: ffff81003f3baec0 R08: ffff810001423f14 R09: 000000000000bb27

R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001

R13: 0000000000000002 R14: 0000000000000001 R15: ffff8100048c33b0

FS:  00002b941f4a40f0(0000) GS:ffffffff80670000(0000) knlGS:0000000000000000

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

CR2: 00000000005b9db0 CR3: 0000000004ed7000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Process kprefetchd (pid: 262, threadinfo ffff81000299a000, task 
ffff810001c98040)

Stack:  0000000000000001 ffff81003f3baec0 0000000000000000 ffffffff8027c50d

 0000000000000002 ffff81003f3baec0 0000000000000000 ffffffff8027f318

 0000000000000000 0000000000000000 ffff81000299bf20 0000000000000000

Call Trace:

 [<ffffffff8027c50d>] add_to_swap_cache+0x36/0x5f

 [<ffffffff8027f318>] kprefetchd+0x248/0x40c

 [<ffffffff8027f0d0>] kprefetchd+0x0/0x40c

 [<ffffffff80248360>] kthread+0x47/0x73

 [<ffffffff8020ca78>] child_rip+0xa/0x12

 [<ffffffff80248319>] kthread+0x0/0x73

 [<ffffffff8020ca6e>] child_rip+0x0/0x12





Code: 0f 0b eb fe 8b 03 66 85 c0 79 04 0f 0b eb fe 8b 03 f6 c4 08

Thanks,
Kamalesh Babulal.
