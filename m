Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYGSNR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYGSNR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYGSNRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:17:52 -0400
Received: from sh.osrg.net ([192.16.179.4]:50819 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbYGSNRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:17:52 -0400
Date: Sat, 19 Jul 2008 22:17:28 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080719124913.GG31439@8bytes.org>
References: <20080718113105.GA13662@8bytes.org>
	<20080719211303J.tomof@acm.org>
	<20080719124913.GG31439@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080719221750G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 14:49:13 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Sat, Jul 19, 2008 at 09:12:56PM +0900, FUJITA Tomonori wrote:
> > 
> > I think that we need a common header file (iommu.h or whatever) for
> > what everyone needs, pci_iommu_shutdown(), no_iommu_init(), etc.
> > 
> > Anyway, I did more cleanups:
> > 
> > http://lkml.org/lkml/2008/7/10/510
> > 
> > or
> > 
> > tip/x86/gart
> > 
> > Let me know if you think we still need cleanups.
> 
> Now that you ask, I think the x86 DMA layer in general needs some rework
> and cleanup.

Agreed, I think that every IOMMU developer agrees :)


> The implementation specific free_coherent function is never
> called at the moment for example.

Right, x86 coherent functions need to be fixed. There are some other
areas to improve, I think.


> For paravirtualized DMA we also need
> some kind of stackable dma_ops according to Amit.

Yeah, we need that:

http://marc.info/?t=121117888500001&r=1&w=2

I think that we will need lots of IOMMU (and DMA stuff) work in the
near future.
