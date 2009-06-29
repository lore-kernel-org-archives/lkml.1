Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZF2Tw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZF2Tw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZF2Twt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:52:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37684 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZF2Tws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:52:48 -0400
Date: Mon, 29 Jun 2009 21:52:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [tip:perfcounters/urgent] perf stat: Improve output
Message-ID: <20090629195203.GD31577@elte.hu>
References: <1246051927.2988.10.camel@hpdv5.satnam> <tip-6e750a8fc009fd0ae98704525d1d8e80d60e8cc9@git.kernel.org> <1246295491.17061.43.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246295491.17061.43.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-06-27 at 17:31 +0000, tip-bot for Jaswinder Singh Rajput
> wrote:
> > Before:
> >          150708  L1-d$-stores          (scaled from 23.57%)
> >          428804  L1-d$-prefetches      (scaled from 23.47%)
> >          314446  L1-d$-prefetch-misses  (scaled from 23.42%)
> >       252626137  L1-i$-loads           (scaled from 23.24%)
> >         5297550  dTLB-load-misses      (scaled from 23.96%)
> >       106992392  branch-loads          (scaled from 23.67%)
> >         5239561  branch-load-misses    (scaled from 23.43%)
> > 
> > After:
> >         1731713  L1-d$-loads               (  14.25x scaled)
> >           44241  L1-d$-prefetches          (   3.88x scaled)
> >           21076  L1-d$-prefetch-misses     (   3.40x scaled)
> >         5789421  L1-i$-loads               (   3.78x scaled)
> >           29645  dTLB-load-misses          (   2.95x scaled)
> >          461474  branch-loads              (   6.52x scaled)
> >            7493  branch-load-misses        (  26.57x scaled)
> 
> I really rather like the before better. Its far easier to get a 
> feel for the overload factor from a fraction that from this 
> multiplier.

ok - i reverted this portion. I liked the multiplicator a bit more - 
but you seem to have a strong preference for the percentage unit.

	Ingo
