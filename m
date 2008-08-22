Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYHVIZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYHVIZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYHVIYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:24:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52116 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYHVIYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:24:45 -0400
Date: Fri, 22 Aug 2008 10:23:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, jbarnes@virtuousgeek.org, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Message-ID: <20080822082328.GA27608@elte.hu>
References: <20080822064414.GT14110@elte.hu> <20080822155754C.fujita.tomonori@lab.ntt.co.jp> <20080822070450.GX14110@elte.hu> <20080822162957F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822162957F.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 22 Aug 2008 09:04:50 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > Can you drop the following patch in tip/x86/gart?
> > > 
> > > commit 0bc65ffd52a78a65f582b42503f727b3f3773cc4
> > > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Date:   Mon Aug 18 00:36:18 2008 +0900
> > > 
> > >     x86 gart: allocate size-aligned address for alloc_coherent, v2
> > > 
> > > Joerg's patchset and this patch slightly conflict with the above
> > > patch. I'll send a new patch against tip/x86/iommu shortly.
> > 
> > such conflicts are no problem usually, check out the resolution in 
> > tip/master - so there's no need to resend. Also, i just merged 
> > tip/x86/gart into tip/x86/iommu, to make the integration even more 
> > apparent.
> 
> Ok, here's a patch against tip/x86/iommu:
> 
> commit 0d8136ea509132c66155ca8a1e7cf60699f95c37
> Merge: 766af9f... 7b22ff5...
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Aug 22 09:03:43 2008 +0200
> 
>     Merge branch 'x86/gart' into x86/iommu
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] gart: allocate size-aligned address for alloc_coherent
> 
> alloc_coherent dma_ops callback was added to GART, however, it doesn't
> return a size aligned address wrt dma_alloc_coherent, as
> DMA-mapping.txt defines. This patch fixes it.
> 
> This patch also removes unused gart_map_simple
> (dma_mapping_ops->map_simple has gone).

applied, thanks!

	Ingo
