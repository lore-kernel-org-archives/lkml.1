Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYL3Gnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYL3Gnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:43:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYL3Gn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:43:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYL3Gn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:43:28 -0500
Date: Tue, 30 Dec 2008 07:43:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] sched: sched.c declare variables before they get used
Message-ID: <20081230064316.GB30975@elte.hu>
References: <1230574157.26564.37.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230574157.26564.37.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

> Impact: cleanup, avoid sparse warnings
> 
> In linux/sched.h moved out sysctl_sched_latency, 
> sysctl_sched_min_granularity, sysctl_sched_wakeup_granularity, 
> sysctl_sched_shares_ratelimit and sysctl_sched_shares_thresh from #ifdef 
> CONFIG_SCHED_DEBUG as these variables are common for both.
> 
> Fixes these sparse warnings:
> kernel/sched.c:825:14: warning: symbol 'sysctl_sched_shares_ratelimit' was not declared. Should it be static?
> kernel/sched.c:832:14: warning: symbol 'sysctl_sched_shares_thresh' was not declared. Should it be static?
> kernel/sched_fair.c:37:14: warning: symbol 'sysctl_sched_latency' was not declared. Should it be static?
> kernel/sched_fair.c:43:14: warning: symbol 'sysctl_sched_min_granularity' was not declared. Should it be static?
> kernel/sched_fair.c:72:14: warning: symbol 'sysctl_sched_wakeup_granularity' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/sched.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

applied to tip/sched/cleanups, thanks!

	Ingo
