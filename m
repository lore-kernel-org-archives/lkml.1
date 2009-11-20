Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZKTIbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZKTIbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZKTIbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:31:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZKTIbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:31:05 -0500
Date: Fri, 20 Nov 2009 09:30:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091120083053.GB19778@elte.hu>
References: <4B064AF5.9060208@cn.fujitsu.com>
 <20091120081440.GA19778@elte.hu>
 <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, Nov 20, 2009 at 10:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > Pekka, Eduard and the other slab hackers might have ideas about what
> > other stats they generally like to see to judge the health of a workload
> > (or system).
> 
> kmalloc()/kfree() CPU ping-pong call-sites (i.e. alloc and free
> happening on different CPUs) is one interesting metric we haven't
> implemented yet. Valgrind massif tool type of output graph would be
> helpful as well:
> 
> http://valgrind.org/docs/manual/ms-manual.html
> 
> On Fri, Nov 20, 2009 at 10:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > If this iteration looks good to the slab folks then i can apply it as-is
> > and we can do the other changes relative to that. It looks good to me as
> > a first step, and it's functional already.
> 
> Yeah, looks OK to me as the first step. Patch 2 looks premature,
> though, looking at the output of "perf kmem" from patch 1.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Great - thanks for the quick ack!

Regarding patch 2 - can we set some definitive benchmark threshold for 
that? I.e. a list of must-have features in 'perf kmem' before we can do 
it? 100% information and analysis equivalency with kmemtrace-user tool? 
Eduard, what do you think?

	Ingo
