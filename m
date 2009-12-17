Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbZLQItd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbZLQItd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbZLQIta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:49:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42016 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbZLQIt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:49:29 -0500
Date: Thu, 17 Dec 2009 09:49:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Teach might_sleep() about preemptible RCU
Message-ID: <20091217084912.GB1901@elte.hu>
References: <20091216142536.GA18091@elte.hu>
 <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
 <20091216192354.GC5211@nowhere>
 <20091217013700.GL6744@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217013700.GL6744@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Dec 16, 2009 at 08:23:57PM +0100, Frederic Weisbecker wrote:
> > On Wed, Dec 16, 2009 at 08:21:05PM +0100, Frederic Weisbecker wrote:
> > > From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Crap... I think I'm really becoming this cyborg...
> > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Although I've happily put Paul's Reviewed-by tag in this v2,
> > I'd feel more comfortable if he could confirm it :)
> 
> Given that I missed the TINY_RCU problem, I am not sure how much my 
> Reviewed-by tag is worth, but I have no problem attaching it to this updated 
> patch.  ;-)

Reviewed-by is valuable in terms of you both acking the patch and expressing 
that you thought it through and like it. It does not mean you have done a 
mental kernel build test of all 2^3000 kernel .config variants and have proven 
the patch correct under circumstances! :-)

So yes, i've added it - thanks Paul!

	Ingo
