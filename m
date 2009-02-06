Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZBFOzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZBFOzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZBFOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:54:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZBFOyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:54:53 -0500
Date: Fri, 6 Feb 2009 15:54:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
Message-ID: <20090206145431.GG18368@elte.hu>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <1233912891.4731.1.camel@laptop> <20090206144609.GB18368@elte.hu> <alpine.DEB.1.10.0902060950250.10059@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902060950250.10059@gandalf.stny.rr.com>
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

> On Fri, 6 Feb 2009, Ingo Molnar wrote:
> 
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, 2009-02-06 at 01:53 -0500, Steven Rostedt wrote:
> > > 
> > > > This code adds an in_nmi() macro that uses the current tasks preempt count
> > > > to track when it is in NMI context. Other parts of the kernel can
> > > > use this to determine if the context is in NMI context or not.
> > > > 
> > > > This code was inspired by the -rt patch in_nmi version that was
> > > > written by Peter Zijlstra.
> > > 
> > > Which in turn I borrowed from Mathieu.
> > 
> > Steve, could you please fix the attribution?
> 
> Is it OK to rebase the branch to do so?

Sure, that's necessary.

And note that unless you base your tree against tip:tracing/ftrace i cannot 
do a straight pull anyway. (your trees are usually based against tip:master 
- which brings in all other branches)

	Ingo
