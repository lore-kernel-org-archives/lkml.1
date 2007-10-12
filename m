Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbXJLG7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbXJLG7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbXJLG7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:59:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbXJLG7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:59:39 -0400
Date: Fri, 12 Oct 2007 08:59:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Message-ID: <20071012065917.GC3057@elte.hu>
References: <470D7055.4090000@bigpond.net.au> <20071011065946.GB32125@elte.hu> <b647ffbd0710110044r5424d7ffi58fc64221a440c7d@mail.gmail.com> <470EA277.7090107@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470EA277.7090107@bigpond.net.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> > I had also considered introducing smth like 
> > sched_class::task_timeslice() but decided it was not worth it.
> 
> The reason I was going that route was for modularity (which helps when 
> adding plugsched patches).  I'll submit a revised patch for 
> consideration.

no strong feelings - since this isnt a performance-sensitive codepath we 
could certainly abstract it a bit more if it's convenient for 
hackability. Depends on how the patch looks like and how much code 
increase there is - but i'd not expect it to be anything controversial.

	Ingo
