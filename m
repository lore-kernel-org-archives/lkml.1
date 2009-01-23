Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZAWKMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZAWKMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZAWKMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:12:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZAWKMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:12:03 -0500
Date: Fri, 23 Jan 2009 11:11:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trace, lockdep: manual preempt count adding for
	local_bh_disable
Message-ID: <20090123101143.GC15188@elte.hu>
References: <alpine.DEB.1.10.0901221523400.5838@gandalf.stny.rr.com> <1232658518.4739.3.camel@laptop> <alpine.DEB.1.10.0901221714030.5838@gandalf.stny.rr.com> <alpine.DEB.1.10.0901221926540.5838@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901221926540.5838@gandalf.stny.rr.com>
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
> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Steven Rostedt (1):
>       trace, lockdep: manual preempt count adding for local_bh_disable
> 
> ----
>  include/linux/sched.h |    2 ++
>  kernel/sched.c        |    8 ++++----
>  kernel/softirq.c      |   13 ++++++++++++-
>  3 files changed, 18 insertions(+), 5 deletions(-)

pulled, thanks Steve!

	Ingo
