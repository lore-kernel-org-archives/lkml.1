Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXCaGNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXCaGNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbXCaGNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:13:15 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2927 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXCaGNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:13:14 -0400
From: Mariusz =?iso-8859-2?q?Koz=B3owski?= <m.kozlowski@tuxland.pl>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: 2.6.21-rc5-mm1
Date: Sat, 31 Mar 2007 08:28:49 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Adrian Bunk <bunk@stusta.de>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070328130234.c0a23572.akpm@linux-foundation.org> <1175113906.5523.7.camel@localhost.localdomain>
In-Reply-To: <1175113906.5523.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703310828.50372.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > 2) This was found a couple minutes later when the system was
> > >    really busy and close to oom condition.
> > > 
> > >  INFO: lockdep is turned off.
> > >  BUG: soft lockup detected on CPU#0!
> > >   [<c0104614>] show_trace_log_lvl+0x1a/0x30
> > >   [<c01052c9>] show_trace+0x12/0x14
> > >   [<c0105355>] dump_stack+0x16/0x18
> > >   [<c01467a0>] softlockup_tick+0x81/0xa8
> > >   [<c011e4dc>] run_local_timers+0x12/0x14
> > >   [<c011e8dd>] update_process_times+0x2b/0x63
> > >   [<c012e4be>] tick_sched_timer+0x4d/0x9e
> > >   [<c012af00>] hrtimer_interrupt+0x12e/0x1a6
> > >   [<c0106f56>] timer_interrupt+0xe/0x15
> > >   [<c0146af3>] handle_IRQ_event+0x28/0x59
> > >   [<c01480a7>] handle_level_irq+0x6e/0xe7
> > >   [<c0105d3e>] do_IRQ+0x3d/0x7f
> > >   [<c01041b2>] common_interrupt+0x2e/0x34
> > >   [<c011afef>] do_softirq+0x4d/0x50
> > >   [<c011b263>] irq_exit+0x7e/0x80
> > >   [<c0105d43>] do_IRQ+0x42/0x7f
> > >   [<c01041b2>] common_interrupt+0x2e/0x34
> > >   [<c0178bf2>] core_sys_select+0x1c6/0x310
> > >   [<c0179101>] sys_select+0x39/0x18f
> > >   [<c0103f44>] sysenter_past_esp+0x5d/0x99
> > >   =======================
> > >  Clocksource tsc unstable (delta = 9372804176 ns)
> > >  Time: acpi_pm clocksource has been installed.
> 
> Hmm.. No clue right off. Does booting w/ clocksource=acpi_pm avoid the
> issue?

Sorry. Can't reproduce it either way.

	Mariusz
