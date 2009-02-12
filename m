Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbZBLPUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbZBLPUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbZBLPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:20:29 -0500
Received: from 8bytes.org ([88.198.83.132]:59700 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZBLPU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:20:28 -0500
Date: Thu, 12 Feb 2009 16:20:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/16] DMA-API debugging facility v2
Message-ID: <20090212152027.GE2125@8bytes.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1233874352.8135.12.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233874352.8135.12.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Feb 05, 2009 at 10:52:32PM +0000, David Woodhouse wrote:
> This adds a function to dump the DMA mappings that the debugging code is
> aware of -- either for a single device, or for _all_ devices.
> 
> This can be useful for debugging -- sticking a call to it in the DMA
> page fault handler, for example, to see if the faulting address _should_
> be mapped or not, and hence work out whether it's IOMMU bugs we're
> seeing, or driver bugs.
> 
> I'd also like to make it answer the question 'should address X be mapped
> for device Y', but I'll get to that next.
> 
> Do we have a %pX format for printing dma_addr_t yet? 
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 

Great. Thanks. Applied to my dma-api/debug branch.

Joerg
