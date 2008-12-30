Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYL3SMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYL3SMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 13:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYL3SL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 13:11:58 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:43109 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYL3SL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 13:11:57 -0500
Date: Tue, 30 Dec 2008 23:37:22 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20081230180722.GA29060@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
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
> So i wanted to ask you to re-test whether this speedup is reproducible, 
> and if yes, please check a few other workloads (for example sysbench on 
> postgresql / mysqld) and send a patch that changes the 
> sched_mc_power_savings default to POWERSAVINGS_BALANCE_WAKEUP (2).

The speedup for kernbench is reproducible.  I will post a more
detailed test report on kernbench soon.  The power-performance benefit
is for an under-utilised system (nr_cpus/2) run of kernbench which is
very ideal to demonstrate the power savings feature.  I will also try
sysbench and update results little later.  As Balbir mentioned, I am
on vacation and traveling.  I will post more benchmark results as soon
as possible.

--Vaidy
