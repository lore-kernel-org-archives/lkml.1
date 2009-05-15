Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZEOOmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZEOOmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZEOOmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:42:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40923 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZEOOmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:42:45 -0400
Date: Fri, 15 May 2009 16:42:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [PATCH][GIT PULL] x86/function-graph: fix constraint for
	recording old return value
Message-ID: <20090515144226.GA10559@elte.hu>
References: <alpine.DEB.2.00.0905131400200.30591@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905131400200.30591@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Ingo,
> 
> After upgrading my distcc boxes from gcc 4.2.2 to 4.4.0, function 
> graph tracer broke. Seems that the variable "old" needs to be 
> denoted as an "early clobber". I've put this against the urgent 
> tree and I'm Cc'ing stable because by the time 30 (and other) 
> kernels get to users, they may be using gcc 4.4.0. I would expect 
> that we will get more complaints about this as more people start 
> using the newer gcc.
> 
> -- Steve
> 
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       x86/function-graph: fix constraint for recording old return value
> 
> ----
>  arch/x86/kernel/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
