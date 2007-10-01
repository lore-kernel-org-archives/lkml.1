Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXJAQZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXJAQZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXJAQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:25:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXJAQZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:25:28 -0400
Date: Mon, 1 Oct 2007 18:25:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071001162507.GA22791@elte.hu>
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001084356.GA1866@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1540]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> BTW, it looks like risky to criticise sched_yield too much: some 
> people can misinterpret such discussions and stop using this at all, 
> even where it's right.

Really, i have never seen a _single_ mainstream app where the use of 
sched_yield() was the right choice.

Fortunately, the sched_yield() API is already one of the most rarely 
used scheduler functionalities, so it does not really matter. [ In my 
experience a Linux scheduler is stabilizing pretty well when the 
discussion shifts to yield behavior, because that shows that everything 
else is pretty much fine ;-) ]

But, because you assert it that it's risky to "criticise sched_yield() 
too much", you sure must know at least one real example where it's right 
to use it (and cite the line and code where it's used, with 
specificity)?

	Ingo
