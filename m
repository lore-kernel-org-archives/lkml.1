Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZBEWbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZBEWbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZBEWa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:30:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:34658 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZBEWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:30:56 -0500
Subject: Re: [PATCH 10/16] dma-debug: add add checking for map/unmap_sg
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org
In-Reply-To: <1232376423-11067-11-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
	 <1232376423-11067-11-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 22:30:49 +0000
Message-Id: <1233873049.8135.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 15:46 +0100, Joerg Roedel wrote:
>  
> +extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
> +                            int nents, int direction);
> +
> +extern void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
> +                              int nelems, int dir);

You want a forward declaration of 'struct scatterlist' to go with those.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

