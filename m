Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbZDCMPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbZDCMPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZDCMO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:14:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821AbZDCMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:14:59 -0400
Date: Fri, 3 Apr 2009 14:14:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
Message-ID: <20090403121434.GJ31399@elte.hu>
References: <20090402052721.013878388@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402052721.013878388@goodmis.org>
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
> Please pull the latest tip/tracing/filters tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/filters
> 
> 
> Steven Rostedt (2):
>       ring-buffer: add ring_buffer_discard_commit
>       tracing/filters: use ring_buffer_discard_commit for discarded events
> 
> Tom Zanussi (2):
>       tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT events
>       tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event macro

I've cherry-picked them into tip/tracing/filters, and there are some 
new build failures:

(.text+0x40795): undefined reference to `event_context_switch'
kernel/built-in.o: In function `probe_power_mark':
trace_power.c:(.text+0x44fd7): undefined reference to `event_power'
trace_power.c:(.text+0x44fe1): undefined reference to `event_power'
trace_power.c:(.text+0x44fe6): undefined reference to 
`filter_match_preds'
kernel/built-in.o: In function `probe_power_end':
trace_power.c:(.text+0x45064): undefined reference to `event_power'
trace_power.c:(.text+0x4506e): undefined reference to `event_power'
trace_power.c:(.text+0x45073): undefined reference to 
`filter_match_preds'
kernel/built-in.o: In function `kmemtrace_free':

so i've excluded it from tip/master for now.

	Ingo
