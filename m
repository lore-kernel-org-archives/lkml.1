Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbXIHIYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbXIHIYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXIHIYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:24:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:54987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751345AbXIHIX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:23:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/d3gkeYJTdelvYLF/+TAPOw/a/IghjMuGxO1tBbY
	7nOlkmbJXVTG64
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Mike Galbraith <efault@gmx.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <1189238208.6575.54.camel@Homer.simpson.net>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
	 <1188694367.11196.42.camel@dhcp193.mvista.com>
	 <20070902072029.GA24427@elte.hu>
	 <Pine.LNX.4.64.0709071634450.1817@scrub.home>
	 <1189238208.6575.54.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 08 Sep 2007 10:23:55 +0200
Message-Id: <1189239835.10725.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-08 at 09:56 +0200, Mike Galbraith wrote:

> <repeats dozen times or so>

They weren't all repeats after all, the last few were...

[  120.267389] 2,f73035a0(5624): 1fa7e90b58c,1fb3b460000,f73035a0(5624),5
[  120.281110] WARNING: at kernel/sched_norm.c:413 entity_tick()
[  120.294101]  [<c0105188>] show_trace_log_lvl+0x1a/0x30
[  120.306425]  [<c0105d83>] show_trace+0x12/0x14
[  120.317857]  [<c0105d9b>] dump_stack+0x16/0x18
[  120.329124]  [<c011eb68>] task_tick_fair+0x15d/0x170
[  120.340988]  [<c01221f3>] scheduler_tick+0x18d/0x2d5
[  120.352896]  [<c012f91d>] update_process_times+0x44/0x63
[  120.365177]  [<c014161e>] tick_sched_timer+0x5c/0xbd
[  120.377146]  [<c013ca61>] hrtimer_interrupt+0x12c/0x1a0
[  120.389392]  [<c01173f0>] smp_apic_timer_interrupt+0x57/0x88
[  120.402114]  [<c0104c50>] apic_timer_interrupt+0x28/0x30
[  120.414491]  [<c0123c1b>] wake_up_new_task+0x72/0xad
[  120.426477]  [<c0125ddc>] do_fork+0x13c/0x205
[  120.437795]  [<c0102258>] sys_clone+0x33/0x39
[  120.449062]  [<c0104182>] sysenter_past_esp+0x5f/0x85
[  120.461047]  =======================


