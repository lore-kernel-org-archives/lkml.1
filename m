Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbXFVWp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbXFVWp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXFVWpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:45:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48595 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXFVWpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:45:51 -0400
Date: Sat, 23 Jun 2007 00:44:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622224455.GA32742@elte.hu>
References: <20070622040014.234651401@goodmis.org> <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <1182549202.3228.78.camel@dhcp193.mvista.com> <Pine.LNX.4.64.0706221506560.14942@asgard.lang.hm> <1182550533.3228.87.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182550533.3228.87.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > remember, these changes have been in use in -rt for a while. there's 
> > reason to believe that they aren't going to cause drastic problems.
> 
> Since I've been working with -rt (~2 years now I think) it's clear 
> that the number of testers of the patch isn't all that high compared 
> to the stable kernel . [...]

You havent been watching it too closely i guess :-) The -rt kernel often 
pops up regressions before mainline does, especially when it comes to 
arcane hardware often used by embedded vendors [ =B-) ]. It even 
triggers certain high-end scalability and race bugs before the mainline 
kernel does, due to its unique scheduling behavior.

So yes, -rt obviously does not have as wide of a tester basis as the 
mainline kernel (but it's by no means small), it nevertheless has a 
tester base that is partly orthogonal to the mainline kernel.

Furthermore, -rt has a wide enough tester base for it to know that if 
something has not caused problems in it for years is certainly at least 
a good indicator that something isnt going to cause drastic problems ... 
which was the point to begin with.

	Ingo
