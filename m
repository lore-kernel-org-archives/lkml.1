Return-Path: <linux-kernel-owner+w=401wt.eu-S1751266AbYL3Gos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbYL3Gos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYL3Gog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:44:36 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36304 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYL3Gog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:44:36 -0500
Date: Tue, 30 Dec 2008 12:14:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081230064432.GA30101@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <28c262360812291543ia322a13g6af854a685ce7632@mail.gmail.com> <20081230024819.GA23301@balbir.in.ibm.com> <20081230062139.GA30038@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081230062139.GA30038@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-30 07:21:39]:

> 
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > > > KERNBENCH Runs: make -j4 on a x86 8 core, dual socket quad core cpu
> > > > package system
> > > >
> > > > SchedMC Run Time     Package Idle    Energy  Power
> > > > 0       81.68        52.83% 54.71%  1.00x J 1.00y W
> > > > 1       80.70        36.62% 70.11%  0.95x J 0.96y W
> > > > 2       74.95        19.53% 85.92%  0.90x J 0.98y W
> 
> > > Your result is very interesting.
> > > level 2 is more fast and efficient of power.
> > > 
> > > What's major contributor to use less time in level 2?
> > > I think it's cache bounce is less time than old.
> > > Is right ?
> > 
> > Yes, correct
> 
> yes, i too noticed that runtime improved so dramatically: +7.5% on 
> kernbench is a _very_ big deal.
> 

Yes, it is, I think one way to identify it on the x86 box would be to
use the performance counter patches, I'll see it I can get it working.

> So i wanted to ask you to re-test whether this speedup is reproducible, 
> and if yes, please check a few other workloads (for example sysbench on 
> postgresql / mysqld) and send a patch that changes the 
> sched_mc_power_savings default to POWERSAVINGS_BALANCE_WAKEUP (2).
> 

We'll do that, Vaidyanathan is on vacation and will be back in the
first week of January. We'll revert back with more tests and results.
>From code review, it would seem that the benefits are going to be
workload specific, but results would show for certain.

> Sidenote, _please_ fix your mail client to not mess up the Cc: list via:
>

Thanks, mutt has this turned on by default, I am turning it off and
hope that followup-to goes away.
 

-- 
	Balbir
