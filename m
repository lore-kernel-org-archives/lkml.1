Return-Path: <linux-kernel-owner+w=401wt.eu-S1764713AbXHDNVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764713AbXHDNVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXHDNVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:21:48 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:54674 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbXHDNVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:21:47 -0400
X-Greylist: delayed 1460 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Aug 2007 09:21:47 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200708041257.l74CvQcH001808@clem.clem-digital.net>
Subject: 2.6.23-rc2 3com vortex boot g
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Sat, 4 Aug 2007 08:57:26 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi. Seeing the below on boot (first is UP, second SMP system).

from my logs,
23-rc1-git10 was ok
sorry, did not run git11 
23-rc1-git12 first shows up


eth0:  setting half-duplex.
WARNING: at kernel/irq/resend.c:70 check_irq_resend()
 [<c012e51b>] check_irq_resend+0xab/0xc0
 [<c012df59>] enable_irq+0x99/0xa0
 [<c01f72cb>] vortex_timer+0x26b/0x3d0
 [<c0122d3b>] hrtimer_run_queues+0x1b/0x140
 [<c01f7060>] vortex_timer+0x0/0x3d0
 [<c0117611>] run_timer_softirq+0x101/0x150
 [<c012648f>] tick_handle_periodic+0xf/0x70
 [<c014d33e>] sys_fstat64+0x1e/0x30
 [<c01144b2>] __do_softirq+0x42/0x90
 [<c0114526>] do_softirq+0x26/0x30
 [<c01045e7>] do_IRQ+0x47/0x80
 [<c011a0c2>] sys_rt_sigprocmask+0x62/0xd0
 [<c0102a2f>] common_interrupt+0x23/0x28
 =======================
NET: Registered protocol family 10


eth2:  setting half-duplex.
WARNING: at kernel/irq/resend.c:70 check_irq_resend()
 [<c014218b>] check_irq_resend+0xab/0xc0
 [<c0141d18>] enable_irq+0xc8/0xd0
 [<f8839a1b>] vortex_timer+0x27b/0x3f0 [3c59x]
 [<c0134baa>] hrtimer_run_queues+0xca/0x150
 [<f88397a0>] vortex_timer+0x0/0x3f0 [3c59x]
 [<c0127b46>] run_timer_softirq+0x116/0x180
 [<c0124262>] __do_softirq+0x82/0x100
 [<c0124317>] do_softirq+0x37/0x40
 [<c01125c7>] smp_apic_timer_interrupt+0x57/0x90
 [<c0101a70>] default_idle+0x0/0x40
 [<c010385c>] apic_timer_interrupt+0x28/0x30
 [<c0101a70>] default_idle+0x0/0x40
 [<c0101a9f>] default_idle+0x2f/0x40
 [<c0101044>] cpu_idle+0x74/0xc0
 [<c03d99da>] start_kernel+0x2aa/0x2f0
 [<c03d9140>] unknown_bootoption+0x0/0x1f0
 =======================
eth2: no IPv6 routers present

-- 
Pete Clements 
