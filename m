Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbZCXLVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbZCXLVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbZCXLVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:21:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbZCXLVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:21:09 -0400
Date: Tue, 24 Mar 2009 12:20:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: fix memory leak in trace_stat
Message-ID: <20090324112050.GC6386@elte.hu>
References: <alpine.DEB.2.00.0903210251100.13615@gandalf.stny.rr.com> <20090321094348.GB5594@elte.hu> <49C88F0B.7070901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C88F0B.7070901@cn.fujitsu.com>
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> >> Ingo,
> >>
> >> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> >> tip/tracing/ftrace
> >>
> >>
> >> Steven Rostedt (1):
> >>       tracing: fix memory leak in trace_stat
> >>
> >> ----
> >>  kernel/trace/trace_stat.c |   23 +++++++++++++----------
> >>  1 files changed, 13 insertions(+), 10 deletions(-)
> > 
> > Pulled, thanks Steve!
> > 
> > 	Ingo
> >
> 
> Hi, Ingo
> 
> I found this patch is not in the tip tree.

It was tied to the function profiler which is still being debated. 
Steve, mind re-anchoring that commit?

	Ingo
