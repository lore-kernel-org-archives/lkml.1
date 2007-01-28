Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXA1SVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXA1SVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 13:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXA1SVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 13:21:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbXA1SVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 13:21:30 -0500
Date: Sun, 28 Jan 2007 19:19:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070128181909.GA12645@elte.hu>
References: <1169993494.10987.23.camel@lappy> <20070128144933.GD16552@infradead.org> <20070128151700.GA7644@elte.hu> <20070128152858.GA23410@infradead.org> <20070128154806.GA10615@elte.hu> <20070128155429.GA26855@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128155429.GA26855@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 04:48:06PM +0100, Ingo Molnar wrote:
> > i'm sorry, but do you realize that files_lock is a global lock, 
> > triggered by /every single/ file close?
> 
> Please check which thread you're in before you start such lengthy 
> rants.

my reply applies to the other thread too, you made a similar comment 
there too:

* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
> > This patch-set breaks up the global file_list_lock which was found 
> > to be a severe contention point under basically any filesystem 
> > intensive workload.
>
> Benchmarks, please.  Where exactly do you see contention for this?

	Ingo
