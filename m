Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZEOOw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZEOOw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZEOOwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:52:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32951 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbZEOOwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:52:17 -0400
Date: Fri, 15 May 2009 11:51:44 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: Re: perf counter issue -
	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
Message-ID: <20090515145144.GD13664@ghostprotocols.net>
References: <20090513165433.GD16373@in.ibm.com> <20090513165724.GA32707@in.ibm.com> <20090515135604.GC16389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515135604.GC16389@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 15, 2009 at 03:56:04PM +0200, Ingo Molnar escreveu:
> 
> * Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> 
> > On Wed, May 13, 2009 at 10:24:33PM +0530, Srivatsa Vaddagiri wrote:
> > > I am hitting this warning in kernel/exit.c (latest -tip code):
> > > 
> > > WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
> > > 
> > > I was using perf counters against a java benchmark.
> > 
> > Basically using perf counters as:
> > 
> > 	$ perf stat java ....
> 
> hm, is there a reproducer perhaps? Is there some class file i could 
> run with specific parameters to reproduce it?

I'll try this with some java benchmarks we have, AMQP related, lets see
if I can reproduce it.

- Arnaldo
