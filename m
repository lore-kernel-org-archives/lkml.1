Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbXKCIeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbXKCIeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 04:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXKCIeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 04:34:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbXKCIeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 04:34:18 -0400
Date: Sat, 3 Nov 2007 09:33:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix delay accounting regression
Message-ID: <20071103083358.GE10760@elte.hu>
References: <20071102142220.24166.49046.sendpatchset@balbir-laptop> <20071102155358.GA32116@elte.hu> <20071102165559.GA5424@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102165559.GA5424@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> On Fri, Nov 02, 2007 at 04:53:58PM +0100, Ingo Molnar wrote:
> > 
> > * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Fix the delay accounting regression introduced by commit 
> > > 75d4ef16a6aa84f708188bada182315f80aab6fa. rq no longer has sched_info 
> > > data associated with it. task_struct sched_info structure is used by 
> > > delay accounting to provide back statistics to user space.
> > 
> > no, this really is broken code. sched_clock() is not a generally 
> > reliable time source so at a minimum the rq->clock fix i mentioned is 
> > needed. What user-space tools are utilizing delay-accounting by the way? 
> > We have most of this data available under SCHEDSTATS - how about 
> > consolidating CONFIG_TASK_DELAY_ACCT into CONFIG_SCHEDSTATS?
> > 
> > 	Ingo
> 
> Hi, Ingo,
> 
> How about this?

thanks, applied.

	Ingo
