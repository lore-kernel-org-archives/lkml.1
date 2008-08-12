Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbYHLETA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbYHLETA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 00:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYHLESx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 00:18:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12965 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYHLESw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 00:18:52 -0400
Date: Mon, 11 Aug 2008 21:18:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.27-rc2-git5 BUG: unable to handle kernel paging request
Message-Id: <20080811211802.8fed7a4b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on x86_64, SMP, 8 GB RAM:

BUG: unable to handle kernel paging request at ffffe20001d5ae00
IP: [<ffffffff8027c08f>] unmap_vmas+0x42d/0x7a0
PGD 28102067 PUD 28103067 PMD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in: lpfc(+) cciss ehci_hcd ohci_hcd uhci_hcd
Pid: 1382, comm: udevd Not tainted 2.6.27-rc2-git5 #1
RIP: 0010:[<ffffffff8027c08f>]  [<ffffffff8027c08f>] unmap_vmas+0x42d/0x7a0
RSP: 0018:ffff88027dcffd68  EFLAGS: 00010246
RAX: 000000008631b98b RBX: ffffe20001d5ade8 RCX: ffff880183a27500
RDX: 0000000001d5ad00 RSI: 000000008631b98b RDI: ffff88027e549840
RBP: ffff88027dcffe38 R08: 000000017efc3402 R09: 000000ffffffffff
R10: ffff88017e84c9d8 R11: 0000000000000006 R12: 0000000000000020
R13: 00007fbedb007000 R14: ffff88027dd81038 R15: 00007fbedb10a000
FS:  00007fbedb777710(0000) GS:ffff88027f623c80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffe20001d5ae00 CR3: 000000027e12c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 1382, threadinfo ffff88027dcfe000, task ffff88027d959bc0)
Stack:  0000000000000000 0000000000000000 ffff88027dcffe50 ffffffffffffffff
 0000000000000000 ffff88027e549840 ffff88027dcffe58 00000000003bc9f2
 0000000000000000 0000000108b985a8 00007fbedb10a000 ffff88027e12c7f8
Call Trace:
 [<ffffffff8027ff11>] exit_mmap+0x75/0xed
 [<ffffffff80232f3a>] mmput+0x42/0x98
 [<ffffffff802369ff>] exit_mm+0xfd/0x108
 [<ffffffff80237fce>] do_exit+0x272/0x84d
 [<ffffffff8023861b>] do_group_exit+0x72/0xa2
 [<ffffffff8023865d>] sys_exit_group+0x12/0x14
 [<ffffffff8020beeb>] system_call_fastpath+0x16/0x1b


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
