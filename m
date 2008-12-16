Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbYLPUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbYLPUkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYLPUkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:40:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYLPUkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:40:07 -0500
Date: Tue, 16 Dec 2008 21:39:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: Use RCU variant of list traversal in
	for_each_leaf_rt_rq()
Message-ID: <20081216203957.GB14787@elte.hu>
References: <20081215062648.GB4337@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215062648.GB4337@in.ibm.com>
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


* Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> sched: Use RCU variant of list traversal in for_each_leaf_rt_rq()
> 
> for_each_leaf_rt_rq() walks an RCU protected list (rq->leaf_rt_rq_list),
> but doesn't use list_for_each_entry_rcu(). Fix this.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/sched/urgent, thanks Bharata!

i'm wondering, have you observed a real crash, or did you find this via 
code review?

	Ingo
