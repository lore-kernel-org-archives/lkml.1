Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZADTxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZADTxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbZADTwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:52:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:53227 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755901AbZADTwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:52:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/N5e0PzvLN4QQ6A2IoddTUlHUQTG3oUjohBBUy2u
	nBnVZ2GPcHVecC
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
From: Mike Galbraith <efault@gmx.de>
To: svaidy@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090104181946.GC4301@dirshya.in.ibm.com>
References: <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com>
	 <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu>
	 <20081230180722.GA29060@dirshya.in.ibm.com>
	 <20090102072600.GA13412@dirshya.in.ibm.com>
	 <20090102221630.GF17240@elte.hu> <1230967765.5257.6.camel@marge.simson.net>
	 <20090103101626.GA4301@dirshya.in.ibm.com>
	 <1230981761.27180.10.camel@marge.simson.net>
	 <1231081200.17224.44.camel@marge.simson.net>
	 <20090104181946.GC4301@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 20:52:49 +0100
Message-Id: <1231098769.5757.43.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 23:49 +0530, Vaidyanathan Srinivasan wrote:

> I am new to sysbench.  I just started few OLTP runs with pgsql. In
> your graph you are plotting and comparing read/write-per-sec and not
> transactions-per-sec.  Both the parameter vary in a similar manner.
> Can you please let me know some background on using the
> read/write-per-sec result for comparison.

It means nothing.  One result is the same as any other.  I prefer low
level read/write but someone else may prefer higher level transactions.

> I assume you have run the above tests on Q6600 box that has single
> quad core package that consist of two dual core CPUs.

Yes.  I can go down from there, but not up.  Oh darn.

>   Can you please
> let me know the sched_domain tree that was build by hacking
> mc_capable().  The effect of sched_mc={1,2} depends on the
> sched groups that was build and their flags.

Hm.  I don't know what you're asking.  I hacked mc_capable only so I
could have the tweakable handy in case there was something I didn't know
about yet (having _just_ jumped in with both feet;)

> As you have mentioned in your data, sched_mc=2 helps recover some
> performance mainly because of NEWIDLE balance.

Yes, odd.

> You have mentioned clients in the x-axis of the graph, what is their
> relation to the number of threads?

I have 4 cores, and 2 caches.  Any relationship is all about cache.

Please feel free to point me to any previous discussion on sysbench
> where the above questions have been discussed.

I haven't seen such.

> Thanks,
> Vaidy

	Cheers,

	-Mike

