Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbZIVJcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbZIVJcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZIVJcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:32:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZIVJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:32:12 -0400
Date: Tue, 22 Sep 2009 11:31:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090922093155.GB15508@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <20090921191729.GE5018@nowhere> <4AB81E70.4060103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB81E70.4060103@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Frederic Weisbecker wrote:
> > On Wed, Sep 16, 2009 at 04:16:22PM -0400, Steven Rostedt wrote:
> >> What are people's thoughts about creating a linux-trace-users mailing
> >> list on vger.kernel.org?
> >>
> >> This would be a place for users of tracers and even perf. For asking
> >> questions about how to use the debugfs/tracing directory or the perf
> >> tool.
> >>
> >> This will not be a place for kernel development. Patches for the tracing
> >> infrastructure should still go through LKML. This will be a place to ask
> >> how-to questions, or any other kind of help questions.
> >>
> >> LKML can be quite intimidating, and it is not a place to ask help
> >> questions anyway. I think adding a linux-trace-users mailing list would
> >> be a good idea.
> >>
> >> Thoughts?
> >>
> >> -- Steve
> > 
> > 
> > Why not. That could also gather informations from LKML threads by 
> > Cc'ing it while explaining how to use the tools in random 
> > discussions.
> > 
> 
> +1
> 
> And then the mailing list needs to be renamed to linux-trace. And we 
> need to advertise it, in Documentation, Kconfig?

The list i can support is what was suggested here: 
tracing-users@vger.kernel.org, for user questions and solutions.

Development of tracing bits should still be very much done on lkml.

We dont want to go down the failed path of some other projects that went 
off to their private lists, became self-breeding, ego-boosting 
pat-each-other-on-the-shoulders-for-being-cool-guys forums, became more 
and more detached from mainline and the complexities there, and in some 
cases also became increasingly hostile towards mainline (hey everyone on 
that list agrees that we are cool guys writing cool code, why doesnt 
upstream love us unconditionally?) and sometimes started growing clique 
or clan social structures - which are outright harmful.

The topical filtering offered by such lists is an advantage (note that 
those can be had on lkml as well by using mail filtering) - but the 
social disadvantages are unsolvable, lets not go there.

Staying on lkml and staying connected is particularly important for a 
subsystem that by their very nature deal with many other subsystems, 
such as tracing / instrumentation.

	Ingo
