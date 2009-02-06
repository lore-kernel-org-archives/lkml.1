Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZBFPRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZBFPRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZBFPRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:17:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59410 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZBFPRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:17:34 -0500
Date: Fri, 6 Feb 2009 16:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
Message-ID: <20090206151659.GK18368@elte.hu>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <1233912891.4731.1.camel@laptop> <20090206144609.GB18368@elte.hu> <alpine.DEB.1.10.0902060950250.10059@gandalf.stny.rr.com> <20090206145431.GG18368@elte.hu> <alpine.DEB.1.10.0902060956480.10059@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902060956480.10059@gandalf.stny.rr.com>
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
> On Fri, 6 Feb 2009, Ingo Molnar wrote:
> > > Is it OK to rebase the branch to do so?
> > 
> > Sure, that's necessary.
> 
> OK, will do.
> 
> > 
> > And note that unless you base your tree against tip:tracing/ftrace i cannot 
> > do a straight pull anyway. (your trees are usually based against tip:master 
> > - which brings in all other branches)
> 
> Which is better for you? Should I base it off of tracing/ftrace instead? I 
> just been using master to make sure I did not break anything else in your 
> repo ;-)

I'll resolve conflicts, no need to worry about that - so it would be nice if 
you could base it on tracing/ftrace (or tracing/core). You can test-merge 
your branch against tip/master and see whether there's any conflict.

> I can set up a branch called tip/ftrace/devel that will be based off of 
> tracing/ftrace, and keep tip/devel off of tip/master. This will let you 
> know which repo my post is based off of. I'll also add it to the subject.

ok, that will work - thanks!

	Ingo
