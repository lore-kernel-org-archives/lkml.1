Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZBRRHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZBRRHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZBRRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:06:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZBRRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:06:53 -0500
Date: Wed, 18 Feb 2009 12:06:50 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
In-Reply-To: <20090218093026.GA12152@elte.hu>
Message-ID: <alpine.DEB.1.10.0902181203470.11411@gandalf.stny.rr.com>
References: <20090217182048.233060814@goodmis.org> <20090218000952.GD12714@elte.hu> <20090218084041.GA27540@elte.hu> <20090218085719.GA31049@elte.hu> <20090218093026.GA12152@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Note, I upgrade my email server which caused a bit of havoc, I'm 
 just getting emails back from yesterday ]


On Wed, 18 Feb 2009, Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > it's one of these recent commits:
> > 
> >  fa7c7f6: tracing/core: remove unused parameter in tracing_fill_pipe_page()
> >  6eaaa5d: tracing/core: use appropriate waiting on trace_pipe
> >  35ebf1c: ftrace: show unlimited when traceon or traceoff has no counter
> >  73d8b8b: tracing: fix typing mistake in hint message and comments
> >  d2ef7c2: tracing: fix the return value of trace selftest
> >  af51309: tracing: use the more proper parameter
> >  b6887d7: ftrace: rename _hook to _probe
> >  6a24a24: ftrace: clean up coding style
> > 
> > Have not bisected it any further, excluded them from 
> > tip:master for the time being.
> 
> actually - it's one of these:
> 
> 37bd824: Merge branches 'tracing/ftrace' and 'tracing/urgent' into tracing/core
> 5b058bc: tracing/function-graph-tracer: trace the idle tasks
> 73d3fd9: ftrace: fix !CONFIG_DYNAMIC_FTRACE ftrace_swapper_pid definition
> 97d0bb8: ftrace: fix !CONFIG_FTRACE [un_]register_ftrace_command() prototypes
> f492d3f8: Merge branch 'tip/tracing/ftrace' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace into tracing/ftrace
> c4e2b43: Merge branches 'tracing/hw-branch-tracing' and 'tracing/power-tracer' into tracing/core
> e110e3d: ftrace: add pretty print function for traceon and traceoff hooks
> 809dcf2: ftrace: add pretty print to selected fuction traces
> 8fc0c70: ftrace: show selected functions in set_ftrace_filter
> 23b4ff3: ftrace: add traceon traceoff commands to enable/disable the buffers
> 988ae9d: ring-buffer: add tracing_is_on to test if ring buffer is enabled
> 59df055: ftrace: trace different functions with a different tracer
> e6ea44e: ftrace: consolidate mutexes

The above consolidate mutexs would be a prime suspect for a hard lockup.
It may very well be that. When I finally receive your config, I'll give it 
a test. I saw you post the config by looking a web archive, but my email 
server is still in the processes of retrieving all my email from the last 
day or so.

-- Steve
