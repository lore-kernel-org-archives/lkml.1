Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbXFVXcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbXFVXcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbXFVXcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:32:11 -0400
Received: from homer.mvista.com ([63.81.120.158]:56445 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXFVXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:32:09 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
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
In-Reply-To: <20070622224455.GA32742@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <1182549202.3228.78.camel@dhcp193.mvista.com>
	 <Pine.LNX.4.64.0706221506560.14942@asgard.lang.hm>
	 <1182550533.3228.87.camel@dhcp193.mvista.com>
	 <20070622224455.GA32742@elte.hu>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 16:28:06 -0700
Message-Id: <1182554887.3228.142.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 00:44 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > remember, these changes have been in use in -rt for a while. there's 
> > > reason to believe that they aren't going to cause drastic problems.
> > 
> > Since I've been working with -rt (~2 years now I think) it's clear 
> > that the number of testers of the patch isn't all that high compared 
> > to the stable kernel . [...]
> 
> You havent been watching it too closely i guess :-) The -rt kernel often 
> pops up regressions before mainline does, especially when it comes to 
> arcane hardware often used by embedded vendors [ =B-) ]. It even 
> triggers certain high-end scalability and race bugs before the mainline 
> kernel does, due to its unique scheduling behavior.

Don't assume anything Ingo ;)

> So yes, -rt obviously does not have as wide of a tester basis as the 
> mainline kernel (but it's by no means small), it nevertheless has a 
> tester base that is partly orthogonal to the mainline kernel.
> 
> Furthermore, -rt has a wide enough tester base for it to know that if 
> something has not caused problems in it for years is certainly at least 
> a good indicator that something isnt going to cause drastic problems ... 
> which was the point to begin with.

As I said, it's a plus but not a silver bullet ? Are you saying I was
wrong ?

Daniel

