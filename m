Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752980AbYLRUSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYLRUSU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYLRUSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:18:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYLRUSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:18:03 -0500
Date: Thu, 18 Dec 2008 21:17:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dipankar Sarma <dipankar@in.ibm.com>, Vatsa <vatsa@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
        David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 8/8] sched: idle_balance() does not call
	load_balance_newidle()
Message-ID: <20081218201722.GA12376@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175658.29812.62512.stgit@drishya.in.ibm.com> <20081218181252.GH26572@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218181252.GH26572@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >  static void idle_balance(int this_cpu, struct rq *this_rq)
> >  {
> >  	struct sched_domain *sd;
> > -	int pulled_task = -1;
> > +	int pulled_task = 0;
> >  	unsigned long next_balance = jiffies + HZ;
> >  	cpumask_t tmpmask;
> >
> 
> Isn't this already in Ingo's patch queue? 

yep - i left it out.

	Ingo
