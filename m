Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYIYJU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYIYJU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYIYJUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:20:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYIYJUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:20:16 -0400
Date: Thu, 25 Sep 2008 11:19:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: sched:
Message-ID: <20080925091959.GF16734@elte.hu>
References: <20080925042108.GA3663@in.ibm.com> <1222334067.16700.190.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222334067.16700.190.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0050]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2008-09-25 at 09:51 +0530, Bharata B Rao wrote:
> > Hi,
> > 
> > sched: Maintain only task entities in cfs_rq->tasks list.
> > 
> > cfs_rq->tasks list is used by the load balancer to iterate
> > over all the tasks. Currently it holds all the entities
> > (both task and group entities) because of which there is
> > a need to check for group entities explicitly during load
> > balancing. This patch changes the cfs_rq->tasks list to
> > hold only task entities.
> 
> Looks fine. Thanks Bharata!

applied to tip/sched/devel, thanks!

	Ingo
