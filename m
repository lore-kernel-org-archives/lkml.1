Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXFVMkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXFVMkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbXFVMkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:40:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59139 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbXFVMkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:40:09 -0400
Date: Fri, 22 Jun 2007 14:38:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622123805.GA9770@elte.hu>
References: <20070622040014.234651401@goodmis.org> <20070622070948.GA21291@infradead.org> <1182515542.5493.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182515542.5493.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > And this is something that might be fine for benchmarking, but not something
> > we should put in.  Keeping two wildly different implementation of core
> > functionality with very different behaviour around is quite bad.  Better
> > kill tasklets once for all.
> 
> Honestly, I highly doubted that this would make it up to Linus's tree.

that's where it belongs - but it first needs the cleanups suggested by 
Christoph.

> My aim was to get this into -mm, [...]

that would be the first step towards getting it upstream.

> and perhaps even turn on the tasklets-as-workqueues as default.

that is a hack that shouldnt be in the patch. People can unapply/apply a 
patch just as well as they can flip a .config switch.

	Ingo
