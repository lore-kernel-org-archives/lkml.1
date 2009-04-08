Return-Path: <linux-kernel-owner+w=401wt.eu-S1757765AbZDHA5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbZDHA5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZDHA5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:57:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50116 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZDHA5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:57:39 -0400
Message-Id: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
Subject: [2.6.30-rc1] RCU detected CPU 1 stall
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Apr 2009 09:57:35 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 07042009 #1827235, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got this.

[  161.653269] INFO: RCU detected CPU 1 stall (t=4294932711/32565 jiffies)
[  161.655376] Pid: 3487, comm: khelper Tainted: G        W  2.6.30-rc1 #1
[  161.655376] Call Trace:
[  161.659680]  [<c015949d>] ? printk+0x1d/0x30
[  161.659680]  [<c01b38b5>] print_cpu_stall+0x45/0xa0
[  161.663377]  [<c01b39f8>] check_cpu_stall+0xe8/0x190
[  161.667409]  [<c01ad59d>] ? get_timestamp+0xd/0x20
[  161.667409]  [<c01b43ab>] __rcu_pending+0x1b/0x160
[  161.671679]  [<c01b451e>] rcu_pending+0x2e/0x70
[  161.675680]  [<c01692ab>] update_process_times+0x3b/0x80
[  161.675680]  [<c018bcf0>] tick_periodic+0x40/0x90
[  161.679710]  [<c018bd5e>] tick_handle_periodic+0x1e/0xa0
[  161.679710]  [<c01045e0>] ? apic_timer_interrupt+0x28/0x34
[  161.683721]  [<c012215f>] local_apic_timer_interrupt+0x6f/0x80
[  161.687390]  [<c0161184>] ? irq_enter+0x14/0x60
[  161.691702]  [<c05e7d83>] smp_apic_timer_interrupt+0x33/0x42
[  161.691702]  [<c01045e7>] apic_timer_interrupt+0x2f/0x34
[  161.695378]  [<c0225da4>] ? __bprm_mm_init+0xe4/0x120
[  161.699377]  [<c0379c3d>] ? __get_user_4+0x11/0x17
[  161.699377]  [<c0225f4e>] ? count+0x3e/0xb0
[  161.703696]  [<c0228554>] do_execve+0x5f4/0x890
[  161.707390]  [<c022bd8b>] ? getname+0x6b/0xa0
[  161.707390]  [<c010237e>] sys_execve+0x5e/0xb0
[  161.711705]  [<c0103d19>] syscall_call+0x7/0xb
[  161.711705]  [<c010aee4>] ? kernel_execve+0x24/0x30
[  161.715395]  [<c0172b6f>] ? ____call_usermodehelper+0xff/0x170
[  161.719736]  [<c0172a70>] ? ____call_usermodehelper+0x0/0x170
[  161.723726]  [<c0104707>] ? kernel_thread_helper+0x7/0x10

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc1
Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc1.txt

Regards.
