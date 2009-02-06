Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZBFADw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZBFADw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZBFADn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:03:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49411 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZBFADm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:03:42 -0500
Date: Fri, 6 Feb 2009 01:03:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] trace: Call tracing_reset_online_cpus before
	tracer->init()
Message-ID: <20090206000333.GD16040@elte.hu>
References: <20090205200200.GB9846@ghostprotocols.net> <20090205231236.GC23999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090205231236.GC23999@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Feb 05, 2009 at 06:02:00PM -0200, Arnaldo Carvalho de Melo wrote:
> > Impact: cleanup
> > 
> > To make it easy for ftrace plugin writers, as this was open coded in
> > the existing plugins
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  block/blktrace.c                     |    2 --
> >  kernel/trace/trace.c                 |    8 +++++++-
> >  kernel/trace/trace.h                 |    1 +
> >  kernel/trace/trace_branch.c          |    1 -
> >  kernel/trace/trace_functions.c       |   17 +++--------------
> >  kernel/trace/trace_functions_graph.c |    1 -
> >  kernel/trace/trace_hw_branches.c     |    1 -
> >  kernel/trace/trace_nop.c             |    1 -
> >  kernel/trace/trace_sched_switch.c    |    8 +-------
> >  kernel/trace/trace_selftest.c        |   18 +++++++++---------
> >  kernel/trace/trace_sysprof.c         |   14 ++++----------
> >  11 files changed, 25 insertions(+), 47 deletions(-)
> > 
> 
> Heh, I will have to manage an "arnaldo" topic in my local git tree
> if I want to stay synced :-)
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Applied to tip:tracing/ftrace, thanks guys!

	Ingo
