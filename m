Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYF1RI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYF1RI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYF1RIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:08:46 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41671 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYF1RIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:08:46 -0400
Date: Sat, 28 Jun 2008 22:38:28 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/30] SMP-group balancer - take 3
Message-ID: <20080628170828.GA2002@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080627114109.724249622@chello.nl> <20080627173355.GA11381@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627173355.GA11381@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this at bootup

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2738 check_flags+0x8a/0x12d()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc8-tip #5
 [<c0226971>] warn_on_slowpath+0x41/0x7b
 [<c024207e>] ? trace_hardirqs_off+0xb/0xd
 [<c0207fef>] ? native_sched_clock+0x8b/0x9d
 [<c022d490>] ? __sysctl_head_next+0x98/0x9f
 [<c057b286>] ? _spin_unlock+0x1d/0x20
 [<c022d490>] ? __sysctl_head_next+0x98/0x9f
 [<c0244a54>] ? __lock_acquire+0xd96/0xda5
 [<c024189b>] check_flags+0x8a/0x12d
 [<c0244a9e>] lock_acquire+0x3b/0x89
 [<c021cb50>] ? tg_shares_up+0x0/0x170
 [<c021b074>] walk_tg_tree+0x2c/0x9f
 [<c021b048>] ? walk_tg_tree+0x0/0x9f
 [<c02190f7>] ? tg_nop+0x0/0x5
 [<c0220d24>] update_shares+0x54/0x5d
 [<c0220d86>] try_to_wake_up+0x59/0x22b
 [<c0220f80>] wake_up_process+0xf/0x11
 [<c0237c94>] kthread_create+0x68/0x98
 [<c0234d75>] ? worker_thread+0x0/0xc2
 [<c0235207>] __create_workqueue_key+0x19e/0x1ee
 [<c0234d75>] ? worker_thread+0x0/0xc2
 [<c076dd9b>] init_workqueues+0x4c/0x5d
 [<c075b36e>] kernel_init+0xcf/0x255
 [<c0329858>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c024379e>] ? trace_hardirqs_on_caller+0x10b/0x136
 [<c0329858>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0203a92>] ? restore_nocheck_notrace+0x0/0xe
 [<c075b29f>] ? kernel_init+0x0/0x255
 [<c075b29f>] ? kernel_init+0x0/0x255
 [<c0204623>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
possible reason: unannotated irqs-on.
irq event stamp: 1892
hardirqs last  enabled at (1891): [<c02437d4>] trace_hardirqs_on+0xb/0xd
hardirqs last disabled at (1892): [<c024207e>]
trace_hardirqs_off+0xb/0xd
softirqs last  enabled at (1548): [<c022b6eb>] __do_softirq+0x13e/0x146
softirqs last disabled at (1541): [<c022b72d>] do_softirq+0x3a/0x52

-- 
regards,
Dhaval
