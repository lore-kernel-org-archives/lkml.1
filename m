Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYLSWPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYLSWPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYLSWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:15:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37586 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYLSWPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:15:37 -0500
Date: Fri, 19 Dec 2008 23:15:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       perfctr-devel@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: perf_counter.c intel_perfmon_event_map and
	max_intel_perfmon_events should be static
Message-ID: <20081219221525.GL2351@elte.hu>
References: <1229706478.7625.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229706478.7625.5.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup, avoid sparse warnings, reduce kernel size a bit
> 
> Fixes these sparse warnings:
> arch/x86/kernel/cpu/perf_counter.c:44:11: warning: symbol 'intel_perfmon_event_map' was not declared. Should it be static?
> arch/x86/kernel/cpu/perf_counter.c:54:11: warning: symbol 'max_intel_perfmon_events' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/perfcounters/core, thanks!

	Ingo
