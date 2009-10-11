Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZJKIye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZJKIye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 04:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZJKIyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 04:54:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZJKIyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 04:54:32 -0400
Date: Sun, 11 Oct 2009 10:53:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH 2/3] perf trace: Update eval_flag() flags array to
	match interrupt.h
Message-ID: <20091011085345.GE14995@elte.hu>
References: <1254808849-7829-1-git-send-email-tzanussi@gmail.com> <1254808849-7829-3-git-send-email-tzanussi@gmail.com> <20091006132732.GA14978@infradead.org> <20091006151858.GB5152@nowhere> <20091006152106.GA6490@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006152106.GA6490@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Oct 06, 2009 at 05:19:00PM +0200, Frederic Weisbecker wrote:
> > Yeah. We may want to do that by including trace/events/irq.h
> > and then use the show_softirq_name() macro defined there.
> > 
> > The rest of the header can be wrapped through no-op macros and
> > stub includes.
> 
> No, not at all.  Performance tracing tools really should not be 
> dependent on the kernel source.  This kind of creep is exactly what I 
> feared from putting the perf source in the kernel tree.

And you were full of it back then and you are full of it now as well.

Of course tools/perf/ can be dependent on the kernel source, as long as 
it's all exposed cleanly. Runtime exposure of information is better of 
course in many cases, but there's a balance to be stricken.

We already have deep and good dependencies between kernel code and 
tools/perf: for example we use the kernel's list.h and lib/rbtree.c in 
perf and those facilities are God-sent over user-space crap that for 
example Glist is.

I tend to agree that softirq names might make sense to expose runtime as 
well, but that is totally independent of your _idiotic_ argument that 
this issue somehow talks against perf being part of the kernel source.

Really, give up that argument already - or if not, please engage in an 
open, honest exchange about it. These drip-drip attacks you are doing, 
without actually having the balls to argue your technical position are 
somewhat annoying.

	Ingo
