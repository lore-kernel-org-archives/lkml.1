Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYAHWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYAHWx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYAHWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:53:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYAHWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:53:18 -0500
Date: Tue, 8 Jan 2008 23:52:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Message-ID: <20080108225249.GC5578@elte.hu>
References: <20080108063113.GA21287@fattire.cabal.ca> <200801082250.06828.rusty@rustcorp.com.au> <20080108155119.GA26114@elte.hu> <200801090948.43594.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801090948.43594.rusty@rustcorp.com.au>
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

> On Wednesday 09 January 2008 02:51:19 Ingo Molnar wrote:
> > cool :-)
> >
> > finally we have a _really_ sane symbols subsystem. Kudos :)
> 
> Actually, the interface is horribly scattered.  It'd be nice for 
> someone to go through and look at what the minimum we actually need is 
> and come up with a system to organize them.
> 
> BTW, do you want this fix in 2.6.24?

hm, i'm not sure it should go into v2.6.24 without first being exposed 
in v2.6.25 for some time - symbol lookup has been historically a bit 
fragile (hopefully this will change now) , and the worst thing that can 
happen during a crash printout is for the debug code to regress. No 
strong feelings though.

	Ingo
