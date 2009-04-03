Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbZDCOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbZDCOg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762335AbZDCOgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:36:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765063AbZDCOgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:36:42 -0400
Date: Fri, 3 Apr 2009 10:36:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
In-Reply-To: <20090403121434.GJ31399@elte.hu>
Message-ID: <alpine.DEB.2.00.0904031035060.965@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org> <20090403121434.GJ31399@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > Please pull the latest tip/tracing/filters tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/filters
> > 
> > 
> > Steven Rostedt (2):
> >       ring-buffer: add ring_buffer_discard_commit
> >       tracing/filters: use ring_buffer_discard_commit for discarded events
> > 
> > Tom Zanussi (2):
> >       tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT events
> >       tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event macro
> 
> I've cherry-picked them into tip/tracing/filters, and there are some 
> new build failures:
> 
> (.text+0x40795): undefined reference to `event_context_switch'
> kernel/built-in.o: In function `probe_power_mark':
> trace_power.c:(.text+0x44fd7): undefined reference to `event_power'
> trace_power.c:(.text+0x44fe1): undefined reference to `event_power'
> trace_power.c:(.text+0x44fe6): undefined reference to 
> `filter_match_preds'
> kernel/built-in.o: In function `probe_power_end':
> trace_power.c:(.text+0x45064): undefined reference to `event_power'
> trace_power.c:(.text+0x4506e): undefined reference to `event_power'
> trace_power.c:(.text+0x45073): undefined reference to 
> `filter_match_preds'
> kernel/built-in.o: In function `kmemtrace_free':
> 
> so i've excluded it from tip/master for now.

I figured that is due to the missing pieces from the ftrace merge I did. 
But I guess we want to tone down on the inter merging of branches.

Tom, could you check out the tracing/filters branch from tip and get that 
branch working.

Thanks,

-- Steve

