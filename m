Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZBTVyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZBTVyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZBTVxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:53:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbZBTVxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:53:50 -0500
Date: Fri, 20 Feb 2009 22:53:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arun@linux.vnet.ibm.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090220215318.GA30665@elte.hu>
References: <20090220125516.GB10232@linux.vnet.ibm.com> <20090220132145.GF26418@elte.hu> <20090220141415.GA27381@dirshya.in.ibm.com> <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220115745.43d202d6@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 20 Feb 2009 17:07:37 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > > I'd also suggest to not do that rather ugly 
> > > > enable_timer_migration per-cpu variable, but simply reuse 
> > > > the existing nohz.load_balancer as a target CPU.
> > > 
> > > This is a good idea to automatically bias the timers.  But 
> > > this nohz.load_balancer is a very fast moving target and we 
> > > will need some heuristics to estimate overall system idleness 
> > > before moving the timers.
> > > 
> > > I would agree that the power saving load balancer has a good 
> > > view of the system and can potentially guide the timer biasing 
> > > framework.
> > 
> > Yeah, it's a fast moving target, but it already concentrates 
> > the load somewhat.
> > 
> 
> I wonder if the real answer for this isn't to have timers be 
> considered schedulable-entities and have the regular scheduler 
> decide where they actually run.

hm, not sure - it's a bit heavy for that.

	Ingo
