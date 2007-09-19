Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXISNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXISNns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXISNnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:43:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbXISNnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:43:40 -0400
Date: Wed, 19 Sep 2007 15:38:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 0/6] using lockdep to validate rcu usage
Message-ID: <20070919133814.GA3731@elte.hu>
References: <20070919104125.286538000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919104125.286538000@chello.nl>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> This patch set uses lockdep to validate rcu usage.
> 
> It annotates rcu_read_{,un}lock{,_bh}() to catch imbalances. And 
> further uses that information to establish a proper context for 
> rcu_dereference().
> 
> It also separates implicit from explicit preempt_disable() usage, in 
> order to separate rcu_dereference() from the locking model.
> 
> A kernel (2.6.23-rc4-mm1) with these patches boots but does have some 
> funnies - I suspect it calls printf from places it doesn't like.
> 
> The first patch should be safe to apply, the rest is RFC.

great work! The patches look good to me.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

	Ingo
