Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZELNn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZELNn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZELNnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:43:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZELNnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:43:17 -0400
Date: Tue, 12 May 2009 15:42:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, tglx@linutronix.de,
       kamezawa.hiroyu@jp.fujitsu.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter
	batch values for stats counters
Message-ID: <20090512134254.GA13423@elte.hu>
References: <20090512102412.GG6351@balbir.in.ibm.com> <20090512102939.GB11714@elte.hu> <20090512193656.D647.A69D9226@jp.fujitsu.com> <20090512132805.GA9808@elte.hu> <2f11576a0905120640qcecc90ase686095b0d9ef014@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0905120640qcecc90ase686095b0d9ef014@mail.gmail.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 2009/5/12 Ingo Molnar <mingo@elte.hu>:
> >
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> >> > or rather, to make cpuacct_batch have a sane value on UP too.
> >> > (1? 0?)
> >>
> >> umm..
> >>
> >> I've reviewed my patch again.
> >> but sched_init() already has multiple #ifdef SMP. [...]
> >
> > Patches are welcome to remove more of them.
> >
> >> [...] Thus I don't think cosmetic changing improve readability
> >> largely.
> >
> > an avoidable #ifdef should aways be avoided.
> 
> ok. I'll fix it tommorow.

With the caveat that you should do it only if i'm right and if it 
results in better code in general.

	Ingo
