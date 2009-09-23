Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbZIWVqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbZIWVqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZIWVqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:46:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59323 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZIWVqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:46:52 -0400
Date: Wed, 23 Sep 2009 23:46:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling
	updates
Message-ID: <20090923214642.GA30061@elte.hu>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <20090923105252.GA32176@elte.hu> <20090923212438.GA5190@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923212438.GA5190@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Sep 23, 2009 at 12:52:52PM +0200, Ingo Molnar wrote:
> > Would be nice to merge latest -git into this tree and resolve the 
> > conflicts:
> > 
> >  kernel/trace/Makefile
> >  kernel/trace/trace.h
> >  kernel/trace/trace_event_types.h
> >  kernel/trace/trace_export.c
> > 
> > Then i could pull it into tip:tracing/kprobes for more testing.
> > 
> > 	Ingo
> 
> 
> I've just merged latest upstream tree into it and pushed
> that in a new branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/kprobes-v2

Pulled into tip:tracing/kprobes, thanks Frederic!

> There were several conflicts, not trivial. I hope I haven't missed
> something. But it boots well, I've tested a simple kprobe creation
> and fetched its events through perf without any problem.
> 
> Thanks,
> Frederic.
> 
> PS: I'd recommend you to define a name when you define a kprobe.
> For example if you want to get the first argument of sys_open,
> don't create it using:
> 
> 	p sys_open a0
> 
> but rather:
> 
> 	p:my_probe_name sys_open a0
> 
> Otherwise you will get a default kprobe name that doesn't seem
> to make perf trace happy (put in my TODO list).

ok. Right now it's in a cooking branch, tracing/kprobes. I merged it to 
tip:master - we can propagate it to tracing/core once it's ready with 
all known bugs and quirks fixed and with significant perf functionality 
for it.

	Ingo
