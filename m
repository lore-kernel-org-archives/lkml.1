Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZBWLZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZBWLZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZBWLZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:25:30 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:36223 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbZBWLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:25:29 -0500
Date: Mon, 23 Feb 2009 16:55:17 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       ego@in.ibm.com, tglx@linutronix.de, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arun@linux.vnet.ibm.com, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 0/4] timers: framework for migration between CPU
Message-ID: <20090223112517.GD10226@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090220132145.GF26418@elte.hu> <20090220141415.GA27381@dirshya.in.ibm.com> <20090220160737.GC11294@elte.hu> <20090220115745.43d202d6@infradead.org> <20090220215318.GA30665@elte.hu> <20090223075521.GA3725@balbir.in.ibm.com> <20090223091158.GJ9582@elte.hu> <20090223094850.GA10226@balbir.in.ibm.com> <20090223103814.GB8817@dirshya.in.ibm.com> <20090223110725.GB17312@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090223110725.GB17312@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2009-02-23 12:07:25]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > My understanding is that we will certainly have a sysfs 
> > tunable to 'enable' timer migration or consolidation, similar 
> > to the sched_mc=2 policy, but the actual set of CPUs to 
> > evacuate and the correct set of target CPUs to consolidate 
> > should come from the scheduler and not necessarily from the 
> > user space.
> 
> Yes.
> 
> > The scheduler should be able to figure out the following 
> > parameters:
> > 
> > * Identify set of idle CPUs (CPU package) from which timers 
> >   can be removed
> > * Identify a semi-idle or idle CPU package to which the timers
> >   can be moved
> > * Decide when to start moving timers as the system has large
> >   number of idle CPUs
> > * Decide when to stop migrating as system becomes less idle
> >   and utilisation increases
> > 
> > Guiding all of the above decisions from user space may not be 
> > fast enough.
> 
> Exactly.
>

OK, lets head that way for now. I've highlighted my concerns in a
different email. Experimentation will definitely show us if they are
justified or not. 

-- 
	Balbir
