Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbXJARJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbXJARJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXJARJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:09:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbXJARJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:09:24 -0400
Date: Mon, 1 Oct 2007 19:09:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071001170903.GA2492@elte.hu>
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local> <20071001162507.GA22791@elte.hu> <47012696.2010606@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47012696.2010606@nortel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> Ingo Molnar wrote:
> 
> >But, because you assert it that it's risky to "criticise sched_yield() 
> >too much", you sure must know at least one real example where it's right 
> >to use it (and cite the line and code where it's used, with 
> >specificity)?
> 
> It's fine to criticise sched_yield().  I agree that new apps should 
> generally be written to use proper completion mechanisms or to wait 
> for specific events.

yes.

> However, there are closed-source and/or frozen-source apps where it's 
> not practical to rewrite or rebuild the app.  Does it make sense to 
> break the behaviour of all of these?

See the background and answers to that in:

   http://lkml.org/lkml/2007/9/19/357
   http://lkml.org/lkml/2007/9/19/328

there's plenty of recourse possible to all possible kinds of apps. Tune 
the sysctl flag in one direction or another, depending on which behavior 
the app is expecting.

	Ingo
