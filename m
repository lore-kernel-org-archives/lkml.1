Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXA1JQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXA1JQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 04:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbXA1JQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 04:16:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbXA1JQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 04:16:48 -0500
Date: Sun, 28 Jan 2007 10:15:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc6-rt2 - SMP/x86 -- questions about .config selection
Message-ID: <20070128091514.GA30685@elte.hu>
References: <8355959a0701272135p150bb95dkf62dbfc07c0cdccc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8355959a0701272135p150bb95dkf62dbfc07c0cdccc@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sunil Naidu <akula2.shark@gmail.com> wrote:

> There is some confusion for me while configuring a rt kernel & 
> proceeding for experiments. I did choose the following:-
> 
> NO_HZ=y
> HIGH_RES_TIMERS=y
> SMP=y
> PREEMPT_VOLUNTARY=y
> PREEMPT_SOFTIRQS=y
> PREEMPT_HARDIRQS=y
> SPINLOCK_BKL=y
> CLASSIC_RCU=y
> SCHED_SMT=y
> IRQBALANCE=y
> HZ_1000=y
> 
> 
> #1 Is this correct to say PREEMPT_VOLUNTARY=y for rt on this desktop 
> #PC?

well, PREEMPT_RT is the best preemption method.

> #2 I am not clear about IRQ config selection (which one should be
> enable/disable for a PC, I did select all as shown in the above 
> config). Any suggestion?

it's OK. If you select PREEMPT_RT then all the necessary preemption 
options get auto-selected for you.

> #3 Any other parameter(s) I need to enable/disable to get better
> results? (did disable APM)

check out the configs of the -rt yum repository, those are pretty 
optimal:

  http://people.redhat.com/mingo/realtime-preempt/yum/

	Ingo
