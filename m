Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbYHVHA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbYHVHA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYHVHAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:00:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:41087 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYHVHAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:00:18 -0400
Date: Fri, 22 Aug 2008 15:57:20 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       jbarnes@virtuousgeek.org, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080822064414.GT14110@elte.hu>
References: <20080821231230V.fujita.tomonori@lab.ntt.co.jp>
	<20080822001238F.fujita.tomonori@lab.ntt.co.jp>
	<20080822064414.GT14110@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080822155754C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 08:44:14 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > > As I wrote in another mail, GART should return zeroed memory 
> > > (keeping the current behavior is better). Except for it, the 
> > > patchset looks fine.
> > 
> > I think that you can apply the following patch after Joerg's patchset.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] x86: remove map_simple hook in struct dma_mapping_ops
> > 
> > pci-dma.c doesn't use map_simple hook any more so we can remove it 
> > from struct dma_mapping_ops now.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> applied to tip/x86/iommu - thanks!

Can you drop the following patch in tip/x86/gart?

commit 0bc65ffd52a78a65f582b42503f727b3f3773cc4
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Mon Aug 18 00:36:18 2008 +0900

    x86 gart: allocate size-aligned address for alloc_coherent, v2


Joerg's patchset and this patch slightly conflict with the above
patch. I'll send a new patch against tip/x86/iommu shortly.
