Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0BDEJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:09:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab0BDEJ2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:09:28 -0500
Date: Wed, 3 Feb 2010 20:08:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Turner <mattst88@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH -mm 3/4] alpha: remove dma_sync_single_range
Message-Id: <20100203200851.9c42c917.akpm@linux-foundation.org>
In-Reply-To: <b4198de61002032006t3703baceh9fc9d9f8bd8cc16d@mail.gmail.com>
References: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265253206-17744-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<b4198de61002032006t3703baceh9fc9d9f8bd8cc16d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 23:06:37 -0500 Matt Turner <mattst88@gmail.com> wrote:

> On Wed, Feb 3, 2010 at 10:13 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > dma_sync_single_for_cpu/for_device supports a partial sync so there is
> > no point to have dma_sync_single_range (also dma_sync_single was
> > obsoleted long ago, replaced with dma_sync_single_for_cpu/for_device).
> >
> > There is no user of dma_sync_single_range() in mainline and only Alpha
> > architecture supports dma_sync_single_range(). So it's unlikely that
> > someone out of the tree uses it.
> >
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Richard Henderson <rth@twiddle.net>
> > Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > Cc: Matt Turner <mattst88@gmail.com>
> > ---
> >  arch/alpha/include/asm/dma-mapping.h |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> > index 04eb568..f514ede 100644
> > --- a/arch/alpha/include/asm/dma-mapping.h
> > +++ b/arch/alpha/include/asm/dma-mapping.h
> > @@ -59,7 +59,6 @@ int dma_set_mask(struct device *dev, u64 mask);
> >
> >  #define dma_sync_single_for_cpu(dev, addr, size, dir)    ((void)0)
> >  #define dma_sync_single_for_device(dev, addr, size, dir)  ((void)0)
> > -#define dma_sync_single_range(dev, addr, off, size, dir)  ((void)0)
> >  #define dma_sync_sg_for_cpu(dev, sg, nents, dir)         ((void)0)
> >  #define dma_sync_sg_for_device(dev, sg, nents, dir)      ((void)0)
> >  #define dma_cache_sync(dev, va, size, dir)               ((void)0)
> > --
> > 1.5.6.5
> 
> Acked-by: Matt Turner <mattst88@gmail.com>
> 
> Should I vacuum this one up, or should it go in the -mm tree? I don't
> guess there's much point in sending Linus pull requests for single
> patches.
> 

I'll grab it.
