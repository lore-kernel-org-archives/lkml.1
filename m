Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYISIlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYISIlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYISIk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:40:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbYISIk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:40:56 -0400
Date: Fri, 19 Sep 2008 10:40:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mpm@selenic.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Message-ID: <20080919084030.GB17592@elte.hu>
References: <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D2ABFD.3040103@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > in 7 days that's about 7000 random bootups, 20% of which had TINY_SHMEM 
> > enabled, half 32-bit, half 64-bit x86. It did not blow up in any way 
> > that would have prevented the kernel from building its next random 
> > version from within itself and it did not produce any kernel messages 
> > with various random kernel debug, compile and boot options.
> 
> Does anything in that workload actually use shared memory?

yes, X and a couple of other things i assume. It's the same test setup 
that found the lockdep assert - and lockdep needs actual use of the 
affected facilities.

	Ingo
