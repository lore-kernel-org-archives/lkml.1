Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYF0Mqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYF0Mqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754849AbYF0Mql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:46:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53199 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbYF0Mql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:46:41 -0400
Date: Fri, 27 Jun 2008 14:46:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/30] SMP-group balancer - take 3
Message-ID: <20080627124630.GB14576@elte.hu>
References: <20080627114109.724249622@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627114109.724249622@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Hi,
> 
> Another go at SMP fairness for group scheduling.
> 
> This code needs some serious testing,..
> 
> However on my system performance doesn't tank as much as it used to. 
> I've ran sysbench and volanomark benchmarks.
> 
> The machine is a Quad core (Intel Q9450) with 4GB of RAM.
> Fedora9 - x86_64
> 
> sysbench-0.4.8 + postgresql-8.3.3
> volanomark-2.5.0.9 + openjdk-1.6.0
> 
> I've used cgroup group scheduling.

cool. I have applied your patches to a new temporary topic, 
tip/sched/devel.smp-group-balance. If that works out fine in testing 
then we can merge it back into sched/devel.

Thanks Peter,

	Ingo
