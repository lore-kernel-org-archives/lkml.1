Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbYJRNr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbYJRNr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 09:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYJRNrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 09:47:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54210 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYJRNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 09:47:21 -0400
Subject: Re: [PATCH] intel-iommu: use coherent_dma_mask in alloc_coherent
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mgross@linux.intel.com, mingo@elte.hu, grundler@parisc-linux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081015160732K.fujita.tomonori@lab.ntt.co.jp>
References: <20081015160732K.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 14:46:56 +0100
Message-Id: <1224337616.6770.1366.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-15 at 16:08 +0900, FUJITA Tomonori wrote:
> This patch fixes intel-iommu to use dev->coherent_dma_mask in
> alloc_coherent. Currently, intel-iommu uses dev->dma_mask in
> alloc_coherent but alloc_coherent is supposed to use
> coherent_dma_mask. It could break drivers that uses smaller
> coherent_dma_mask than dma_mask (though the current code works for the
> majority that use the same mask for coherent_dma_mask and dma_mask).

I've fixed this up to cope with the fact that dma_mask can be bigger
than an 'unsigned long', and committed it to the iommu-2-6.git tree.

Thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

