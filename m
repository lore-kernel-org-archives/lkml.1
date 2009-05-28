Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbZE1Ugv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbZE1Ugv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764450AbZE1Ugb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:36:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37499 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764302AbZE1Uga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:36:30 -0400
Date: Thu, 28 May 2009 22:36:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] Saving power by cpu evacuation
	sched_max_capacity_pct=n
Message-ID: <20090528203625.GC11477@elf.ucw.cz>
References: <20090513130541.21440.33364.stgit@drishya.in.ibm.com> <20090513143550.GU19296@one.firstfloor.org> <1242225402.26820.23.camel@twins> <20090513144659.GV19296@one.firstfloor.org> <1242226219.26820.26.camel@twins> <20090513150100.GW19296@one.firstfloor.org> <20090519204015.GE1362@ucw.cz> <20090522091457.GY7336@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522091457.GY7336@dirshya.in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > But I don't see why it is neccessary to evacuate cores for this. Why
> > not just schedule special task that enters C3 instead of computing?
> 
> This is what essentially happens in the load balancer approach.  Not
> scheduling on a particular core will run the scheduler's idle task
> that will transition the core to lowest power state.  Pinning a user
> space task and using special driver to hold the core in C3 state will
> break scheduling fairness. At this point the application decides when
> to give the core back to scheduler.

Why would it break scheduling fairness? You just schedule "realtime"
task that does C3 instead of computation. The behaviour is very
similar to "normal" realtime task. Why would it break scheduler?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
