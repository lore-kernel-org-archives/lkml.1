Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZKHKBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZKHKBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZKHKBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:01:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbZKHKBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:01:08 -0500
Date: Sun, 8 Nov 2009 11:00:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, akpm@linux-foundation.org, yinghai@kernel.org,
       torvalds@linux-foundation.org, tj@kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
Message-ID: <20091108100029.GD2845@elte.hu>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20091028074832.GC19402@elte.hu>
 <20091106104931W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106104931W.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Wed, 28 Oct 2009 08:48:32 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > From: Chris Wright <chrisw@sous-sol.org>
> > > 
> > > Add a new function for freeing bootmem after the bootmem allocator has
> > > been released and the unreserved pages given to the page allocator.
> > > This allows us to reserve bootmem and then release it if we later
> > > discover it was not needed.
> > > 
> > > Reviewed-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> > > ---
> > >  include/linux/bootmem.h |    1 +
> > >  mm/bootmem.c            |   43 ++++++++++++++++++++++++++++++++++++++-----
> > >  2 files changed, 39 insertions(+), 5 deletions(-)
> > 
> > Hm, we are now further complicating the bootmem model.
> 
> Yeah, agreed. But reorganizing the allocator during boot is not easy. 
> I'll investigate it later on but VT-d people want to fix this IOMMU 
> issue now. Can we accept this for now?

Since the patchset weighs heavily towards the iommu and x86 side i can 
do that in tip:core/iommu tree, if there's an Acked-by for this 
bootmem.c patch from at least one of these gents:

 Johannes Weiner <hannes@cmpxchg.org>
 Pekka Enberg <penberg@cs.helsinki.fi>
 Andrew Morton <akpm@linux-foundation.org>
 Tejun Heo <tj@kernel.org>

Thanks,

	Ingo
