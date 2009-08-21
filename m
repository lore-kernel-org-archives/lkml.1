Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZHUOSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZHUOSC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZHUOSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:18:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbZHUOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:18:00 -0400
Date: Fri, 21 Aug 2009 16:17:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Josh Triplett <josht@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, hugh.dickins@tiscali.co.uk,
       benh@kernel.crashing.org
Subject: Re: [PATCH -tip/core/rcu 1/6] Cleanups and fixes for RCU in face
	of heavy CPU-hotplug stress
Message-ID: <20090821141721.GA11098@elte.hu>
References: <20090815165153.GA8886@linux.vnet.ibm.com> <1250533487.2709.14.camel@josh-work.beaverton.ibm.com> <20090817192036.GJ6760@linux.vnet.ibm.com> <20090818152643.GA5549@elte.hu> <20090820140335.GA31773@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820140335.GA31773@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I would not trust this architecture for synchronization tests. 
> There has been reports of a hardware bug affecting the cmpxchg 
> instruction in the field. The load fence normally implied by the 
> semantic seems to be missing. AFAIK, AMD never acknowledged the 
> problem.

If cmpxchg was broken i'd be having far worse problems and very 
widely so.

FYI, this was the same box i prototyped/developed -rt on, which uses 
cmpxchg for _everything_.

That's not a proof of course (it's near impossible to prove the lack 
of a bug), but it's sure a strong indicator and you'll need to 
provide far more proof of misbehavior before i discount a bona fide 
regression on this box.

	Ingo
