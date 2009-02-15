Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZBOToz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZBOToz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZBOToq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:44:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZBOTop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:44:45 -0500
Date: Sun, 15 Feb 2009 20:44:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull][tip] updates for tip/tracing/ftrace
Message-ID: <20090215194420.GB18517@elte.hu>
References: <alpine.DEB.1.10.0902131025120.27973@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902131025120.27973@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Jason Baron (1):
>       tracing: convert c/p state power tracer to use tracepoints
> 
> ----
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +
>  arch/x86/kernel/process.c                  |    3 +
>  include/trace/power.h                      |   25 ++--
>  kernel/trace/trace_power.c                 |  173 ++++++++++++++++-----------
>  4 files changed, 119 insertions(+), 84 deletions(-)

Pulled into tip:tracing/power-tracer, thanks Steve!

	Ingo
