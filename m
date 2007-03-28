Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXC1Ubw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXC1Ubw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXC1Ubw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:31:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49572 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbXC1Ubv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:31:51 -0400
Subject: Re: 2.6.21-rc5-mm1
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mariusz Koz__owski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070328130234.c0a23572.akpm@linux-foundation.org>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
	 <200703281844.58698.m.kozlowski@tuxland.pl>
	 <20070328130234.c0a23572.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 13:31:46 -0700
Message-Id: <1175113906.5523.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-28 at 13:02 -0700, Andrew Morton wrote:
> On Wed, 28 Mar 2007 18:44:57 +0200
> Mariusz Koz__owski <m.kozlowski@tuxland.pl> wrote:
> > 2) This was found a couple minutes later when the system was
> >    really busy and close to oom condition.
> > 
> >  INFO: lockdep is turned off.
> >  BUG: soft lockup detected on CPU#0!
> >   [<c0104614>] show_trace_log_lvl+0x1a/0x30
> >   [<c01052c9>] show_trace+0x12/0x14
> >   [<c0105355>] dump_stack+0x16/0x18
> >   [<c01467a0>] softlockup_tick+0x81/0xa8
> >   [<c011e4dc>] run_local_timers+0x12/0x14
> >   [<c011e8dd>] update_process_times+0x2b/0x63
> >   [<c012e4be>] tick_sched_timer+0x4d/0x9e
> >   [<c012af00>] hrtimer_interrupt+0x12e/0x1a6
> >   [<c0106f56>] timer_interrupt+0xe/0x15
> >   [<c0146af3>] handle_IRQ_event+0x28/0x59
> >   [<c01480a7>] handle_level_irq+0x6e/0xe7
> >   [<c0105d3e>] do_IRQ+0x3d/0x7f
> >   [<c01041b2>] common_interrupt+0x2e/0x34
> >   [<c011afef>] do_softirq+0x4d/0x50
> >   [<c011b263>] irq_exit+0x7e/0x80
> >   [<c0105d43>] do_IRQ+0x42/0x7f
> >   [<c01041b2>] common_interrupt+0x2e/0x34
> >   [<c0178bf2>] core_sys_select+0x1c6/0x310
> >   [<c0179101>] sys_select+0x39/0x18f
> >   [<c0103f44>] sysenter_past_esp+0x5d/0x99
> >   =======================
> >  Clocksource tsc unstable (delta = 9372804176 ns)
> >  Time: acpi_pm clocksource has been installed.

Hmm.. No clue right off. Does booting w/ clocksource=acpi_pm avoid the
issue?

-john

