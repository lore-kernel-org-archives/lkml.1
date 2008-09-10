Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYIJJfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYIJJfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYIJJex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:34:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYIJJew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:34:52 -0400
Date: Wed, 10 Sep 2008 11:34:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: Re: [PATCH 0/4] add a helper function, is_buffer_dma_capable()
Message-ID: <20080910093430.GB5259@elte.hu>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080909162705.GC13536@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909162705.GC13536@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 10, 2008 at 01:06:45AM +0900, FUJITA Tomonori wrote:
> > This patchset adds a trivial helper function, is_buffer_dma_capable()
> > and cleans up some IOMMU implementations. This function is to to see
> > if a memory region is DMA-capable or not with the arguments, the
> > dma_mask (or coherent_dma_mask) of a device and the address and size
> > of a memory region. It's useful for IOMMUs that don't do virtual
> > mappings at all times.
> > 
> > The patch for swiotlb is a bug fix (the rest are just
> > cleanups). Currently, swiotlb doesn't take account of the size of a
> > memory region to see if if the memory region is DMA-capable.
> 
> Good idea. This patchset increases the readability of the software
> dma-api implementations.
> 
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>

applied to tip/x86/iommu:

 2797982: swiotlb: convert swiotlb to use is_buffer_dma_capable helper function
 49fbf4e: x86: convert pci-nommu to use is_buffer_dma_capable helper function
 ac4ff65: x86: convert gart to use is_buffer_dma_capable helper function
 636dc67: add is_buffer_dma_capable helper function

thanks!

	Ingo
