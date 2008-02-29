Return-Path: <linux-kernel-owner+w=401wt.eu-S933942AbYB2VVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbYB2VVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbYB2VUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:20:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992AbYB2VUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:20:44 -0500
Date: Fri, 29 Feb 2008 22:20:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, roland@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
Message-ID: <20080229212014.GJ27212@elte.hu>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org> <20080229164510.GA6850@elte.hu> <alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org> <20080229171737.GA10604@elte.hu> <20080229173705.GA19423@elte.hu> <20080229130237.da291a1e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229130237.da291a1e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I believe the -stable guys have a bot which trolls the mainline 
> commits mailing list for "cc:.*stable@kernel.org".  So anybody 
> anywhere in the patch delivery chain can append "Cc: 
> <stable@kernel.org>" and things should get appropriate consideration.

ok, didnt know about that.

> The place where I suspect there is a lot of lossage is people simply 
> not thinking about whether a fix should be backported.  I'm forever 
> fussing about that for the patches I handle (and I still miss some) 
> but I have a suspicion that not all tree-owners do this fully.

we watch out for this, but still, about 50% of the cases, the 
realization "this should be backported" comes later on. Often because 
fixes get applied with low latency, and testers lag in realizing that 
some particular -stable problem is fixed by a -git fix. Sometimes people 
do bisection in search of backportable fixes - that too has a lag.

so the more formal:

    Backport-suggested-by: commit-id, person

entry would solve both cases. Also, a commit entry in -stable:

    Backported-from: commit-id

would finish the transaction. [ But this is clearly something that the 
-stable folks have to request - it wont help much if we start doing it 
but the -stable folks ignore the entries :-) ]

	Ingo
