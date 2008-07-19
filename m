Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYGSMtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYGSMtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYGSMtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:49:15 -0400
Received: from 8bytes.org ([88.198.83.132]:38789 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYGSMtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:49:15 -0400
Date: Sat, 19 Jul 2008 14:49:13 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
Message-ID: <20080719124913.GG31439@8bytes.org>
References: <20080709162913H.tomof@acm.org> <20080718113105.GA13662@8bytes.org> <20080719211303J.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719211303J.tomof@acm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 09:12:56PM +0900, FUJITA Tomonori wrote:
> 
> I think that we need a common header file (iommu.h or whatever) for
> what everyone needs, pci_iommu_shutdown(), no_iommu_init(), etc.
> 
> Anyway, I did more cleanups:
> 
> http://lkml.org/lkml/2008/7/10/510
> 
> or
> 
> tip/x86/gart
> 
> Let me know if you think we still need cleanups.

Now that you ask, I think the x86 DMA layer in general needs some rework
and cleanup. The implementation specific free_coherent function is never
called at the moment for example. For paravirtualized DMA we also need
some kind of stackable dma_ops according to Amit.

Joerg

