Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbYAHPvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbYAHPvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYAHPvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:51:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbYAHPvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:51:46 -0500
Date: Tue, 8 Jan 2008 16:51:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-ID: <20080108155119.GA26114@elte.hu>
References: <20080108063113.GA21287@fattire.cabal.ca> <200801082228.05218.rusty@rustcorp.com.au> <20080108113323.GB11083@elte.hu> <200801082250.06828.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801082250.06828.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 08 January 2008 22:33:23 Ingo Molnar wrote:
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > +/* FIXME: Risky: returns a pointer into a module w/o lock */
> >
> > stupid question: since module unloads are so rare, why isnt this via 
> > the same mechanism that CPU hotplug uses to securely unregister 
> > CPUs? I.e. quiet all CPUs, disable irqs on all of them, then unlink 
> > the module.
> 
> That's what we do.  This old locking stuff is legacy.

oh, wonderful :-)

> And here's the patch for the FIXME (which I put in to remind myself):
> 
> Make module_address_lookup safe

cool :-)

finally we have a _really_ sane symbols subsystem. Kudos :)

	Ingo
