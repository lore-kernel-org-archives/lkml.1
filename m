Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZEON4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZEON4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZEON4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:56:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36531 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbZEON4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:56:16 -0400
Date: Fri, 15 May 2009 15:56:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: perf counter issue -
	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
Message-ID: <20090515135604.GC16389@elte.hu>
References: <20090513165433.GD16373@in.ibm.com> <20090513165724.GA32707@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513165724.GA32707@in.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:

> On Wed, May 13, 2009 at 10:24:33PM +0530, Srivatsa Vaddagiri wrote:
> > I am hitting this warning in kernel/exit.c (latest -tip code):
> > 
> > WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
> > 
> > I was using perf counters against a java benchmark.
> 
> Basically using perf counters as:
> 
> 	$ perf stat java ....

hm, is there a reproducer perhaps? Is there some class file i could 
run with specific parameters to reproduce it?

	Ingo
