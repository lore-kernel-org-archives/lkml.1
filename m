Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbXJLNHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbXJLNHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXJLNHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:07:10 -0400
Received: from mx28.mail.ru ([194.67.23.67]:3428 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbXJLNHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:07:08 -0400
From: xeb@mail.ru
To: linux-kernel@vger.kernel.org
Subject: Kernel panic (network stack)
Date: Fri, 12 Oct 2007 16:28:09 +0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121628.10533.xeb@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
I develop network driver.
It works fine while less then 100 network interfaces exists.
Then i give kernel panic. What could cause it ?

general protection fault: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: ppp_deflate zlib_deflate zlib_inflate pptp pppox 
ppp_generic slhc rtc 8139too 
Pid: 0, comm: swapper Noy tainted 2.6.22-gentoo-r8 #5
RIP: 0010:[<ffffffff8025ec9b>] [<ffffffff8025ec9b>] put_page+0x1b/0x110
RSP: 0018:ffff81000171fda0 EFLAGS: 00010286
RAX: ffff81000ec31080 RBX: a2e9690005e3ffff RCX: 0000000000000000
RDX: 0000000000000000 RSI: 000000000000005a RDI: a2e9690005e3ffff
RBP: ffff81000ec31080 R08: ffff81000ec31046 R09: 0000000000000001
R10: 0000000000000000 R11: ffffffff80467910 R12: ffff81001a912800
R13: 0000000000000008 R14: ffffffff805f7440 R15: ffff81001a912800
FS:  00002ad3cba47ae0(0000) GS: ffff81001be7df40(0000) knlGS: 00000000f7e3b6b0
CS:  0010 DS: 0018 ES: 0018 CR0: 0000000008005003b
CR2: 0000000000413ae0 CR3: 00000000011ef000 CR4: 00000000000006e0
Process swapper (pid:0, threadinfo ffff810001718000, task ffff81001be6e730
Stack: 0000000000000000 0000000000000001 ffff81000f16f0c0 ffff81001a912800
 0000000000000008 fffffff80463ab7 ffff8100129d1e42 ffff81000f16f0c0
 ffff81000f16f0c0 fffffff80463859 ffffffff806081b0 ffffffff80489fb5
Call Trace:
<IRQ> [<ffffffff80463ab7>] skb_release_data+0x77/0xd0
[<ffffffff80463859>] kfree_skbmem+0x9/0x80
[<ffffffff80489fb5>] ip_rcv+0xc5/0x6a0
[<ffffffff8046aeb5>] netif_receive_skb+0x3f5/0x400
[<ffffffff8046ad58>] netif_receive_skb+0x298/0x400
[<ffffffff8046af5b>] process_backlog+0x9b/0x130
[<ffffffff8046b078>] net_rx_action+0x88/0x1d0
[<ffffffff8808e632>] :8139too:rtl8139_interrupt+0x142/0x550
[<ffffffff802335fb>] __do_softirq+0x6b/0xf0
[<ffffffff8020acbc>] call_softirq+0x1c/0x30
[<ffffffff8020cbda>] do_softirq+0x4a/0xb0
[<ffffffff8020cb10>] do_IRQ+0x80/0x100
[<ffffffff80207b40>] default_idle+0x0/0x50
[<ffffffff80209fe1>] ret_from_intr+0x0/0xa
<EOI> <ffffffff80207b69>] default_idle+0x29/0x50
[<ffffffff80207d90>] cpu_idle+0x90/0xa0


Code: 8b 07 f6 c4 40 0f 85 cc 00 00 00 f0 ff 4f 08 0f 94 c0 84 c0
RIP [<ffffffff8025ec9b>] put_page+0x1b/0x110
 RSP: 0018:ffff81000171fda0
Kernel panic - not syncing: Aiee, killing interrupt handler!



