Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbYGZBxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbYGZBxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 21:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYGZBxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 21:53:14 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:50563 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYGZBxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 21:53:12 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 21:53:12 EDT
Message-ID: <488A816A.1070209@tlinx.org>
Date: Fri, 25 Jul 2008 18:44:10 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.26 hanging...
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just got a message that one of the two cpu's had exceeded a hang-checkk
timer and then it spit out this in the log.

Jul 25 18:21:28 Ishtar kernel: Clocksource tsc unstable (delta = 
571817442154 ns
)
Jul 25 18:21:28 Ishtar kernel: Modules linked in: uhci_hcd
Jul 25 18:21:28 Ishtar kernel:
Jul 25 18:21:28 Ishtar kernel: Pid: 183, comm: cifsoplockd Not tainted 
(2.6.26-ish #2)
Jul 25 18:21:28 Ishtar kernel: EIP: 0060:[<b0412437>] EFLAGS: 00000286 
CPU: 1
Jul 25 18:21:28 Ishtar kernel: EIP is at _spin_unlock_irqrestore+0x7/0x10
Jul 25 18:21:28 Ishtar kernel: EAX: b05a8d00 EBX: efb13f54 ECX: b05a8d00 
EDX: 00000286
Jul 25 18:21:28 Ishtar kernel: ESI: 00000000 EDI: b01eaa90 EBP: efb13f24 
ESP: efb13f24
Jul 25 18:21:28 Ishtar kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jul 25 18:21:28 Ishtar kernel: CR0: 8005003b CR2: a7a2c000 CR3: 37c10000 
CR4: 000006d0
Jul 25 18:21:28 Ishtar kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 
DR3: 00000000
Jul 25 18:21:28 Ishtar kernel: DR6: ffff0ff0 DR7: 00000400
Jul 25 18:21:28 Ishtar kernel:  [<b012df2a>] try_to_del_timer_sync+0x4a/0x60
Jul 25 18:21:28 Ishtar kernel:  [<b012df51>] del_timer_sync+0x11/0x20
Jul 25 18:21:28 Ishtar kernel:  [<b0410dbf>] schedule_timeout+0x4f/0xc0
Jul 25 18:21:28 Ishtar kernel:  [<b012db20>] ? process_timeout+0x0/0x10
Jul 25 18:21:28 Ishtar kernel:  [<b0410db3>] ? schedule_timeout+0x43/0xc0
Jul 25 18:21:28 Ishtar kernel:  [<b01eabee>] cifs_oplock_thread+0x15e/0x230
Jul 25 18:21:28 Ishtar kernel:  [<b011a836>] ? complete+0x46/0x60
Jul 25 18:21:28 Ishtar kernel:  [<b01eaa90>] ? cifs_oplock_thread+0x0/0x230
Jul 25 18:21:28 Ishtar kernel:  [<b01375b2>] kthread+0x42/0x70
Jul 25 18:21:28 Ishtar kernel:  [<b0137570>] ? kthread+0x0/0x70
Jul 25 18:21:28 Ishtar kernel:  [<b0103c4f>] kernel_thread_helper+0x7/0x18
Jul 25 18:21:28 Ishtar kernel:  =======================
---
   
New feature with 2.6.26?  (just upgraded from 2.6.24-24)....

