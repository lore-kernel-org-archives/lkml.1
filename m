Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXJWHcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXJWHcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbXJWHcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:32:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12622 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbXJWHcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:32:00 -0400
Date: Tue, 23 Oct 2007 09:30:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: torvalds@linux-foundation.org, kyle@parisc-linux.org,
       linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: [PATCH] parisc: fix sg_page() fallout
Message-ID: <20071023073035.GL25962@kernel.dk>
References: <20071023150017P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023150017P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_map_sg':
> arch/parisc/kernel/pci-dma.c:487: error: 'struct scatterlist' has no member named 'page'
> arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_unmap_sg':
> arch/parisc/kernel/pci-dma.c:508: error: 'struct scatterlist' has no member named 'page'
> arch/parisc/kernel/pci-dma.c:508: error: 'struct scatterlist' has no member named 'page'
> arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_sync_sg_for_cpu':
> arch/parisc/kernel/pci-dma.c:535: error: 'struct scatterlist' has no member named 'page'
> arch/parisc/kernel/pci-dma.c:535: error: 'struct scatterlist' has no member named 'page'
> arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_sync_sg_for_device':
> arch/parisc/kernel/pci-dma.c:545: error: 'struct scatterlist' has no member named 'page'
> arch/parisc/kernel/pci-dma.c:545: error: 'struct scatterlist' has no member named 'page'

Applied.

-- 
Jens Axboe

