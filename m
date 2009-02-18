Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZBRSUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZBRSUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZBRSUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:20:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbZBRSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:20:04 -0500
Date: Wed, 18 Feb 2009 19:19:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
Message-ID: <20090218181926.GA26802@elte.hu>
References: <20090217182048.233060814@goodmis.org> <20090218000952.GD12714@elte.hu> <20090218084041.GA27540@elte.hu> <20090218085719.GA31049@elte.hu> <20090218093026.GA12152@elte.hu> <alpine.DEB.1.10.0902181203470.11411@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902181203470.11411@gandalf.stny.rr.com>
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
> [ Note, I upgrade my email server which caused a bit of havoc, I'm 
>  just getting emails back from yesterday ]
> 
> 
> On Wed, 18 Feb 2009, Ingo Molnar wrote:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > it's one of these recent commits:
> > > 
> > >  fa7c7f6: tracing/core: remove unused parameter in tracing_fill_pipe_page()
> > >  6eaaa5d: tracing/core: use appropriate waiting on trace_pipe
> > >  35ebf1c: ftrace: show unlimited when traceon or traceoff has no counter
> > >  73d8b8b: tracing: fix typing mistake in hint message and comments
> > >  d2ef7c2: tracing: fix the return value of trace selftest
> > >  af51309: tracing: use the more proper parameter
> > >  b6887d7: ftrace: rename _hook to _probe
> > >  6a24a24: ftrace: clean up coding style
> > > 
> > > Have not bisected it any further, excluded them from 
> > > tip:master for the time being.
> > 
> > actually - it's one of these:
> > 
> > 37bd824: Merge branches 'tracing/ftrace' and 'tracing/urgent' into tracing/core
> > 5b058bc: tracing/function-graph-tracer: trace the idle tasks
> > 73d3fd9: ftrace: fix !CONFIG_DYNAMIC_FTRACE ftrace_swapper_pid definition
> > 97d0bb8: ftrace: fix !CONFIG_FTRACE [un_]register_ftrace_command() prototypes
> > f492d3f8: Merge branch 'tip/tracing/ftrace' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace into tracing/ftrace
> > c4e2b43: Merge branches 'tracing/hw-branch-tracing' and 'tracing/power-tracer' into tracing/core
> > e110e3d: ftrace: add pretty print function for traceon and traceoff hooks
> > 809dcf2: ftrace: add pretty print to selected fuction traces
> > 8fc0c70: ftrace: show selected functions in set_ftrace_filter
> > 23b4ff3: ftrace: add traceon traceoff commands to enable/disable the buffers
> > 988ae9d: ring-buffer: add tracing_is_on to test if ring buffer is enabled
> > 59df055: ftrace: trace different functions with a different tracer
> > e6ea44e: ftrace: consolidate mutexes
> 
> The above consolidate mutexs would be a prime suspect for a hard lockup.
> It may very well be that. When I finally receive your config, I'll give it 
> a test. I saw you post the config by looking a web archive, but my email 
> server is still in the processes of retrieving all my email from the last 
> day or so.

here's a clickable link:

http://redhat.com/~mingo/misc/config-ftrace-breakage-2009-02-18

	ngo
