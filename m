Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZBEVGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZBEVGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZBEVGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:06:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:49189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZBEVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:06:29 -0500
Subject: Re: [PATCH 09/16] dma-debug: add checking for map/unmap_page/single
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, iommu@lists.linux-foundation.org
In-Reply-To: <1232376423-11067-10-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
	 <1232376423-11067-10-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 21:06:22 +0000
Message-Id: <1233867982.3548.697.camel@macbook.infradead.org>
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
> +static inline void debug_dma_map_page(struct device *dev, struct page *page,
> +                                     size_t offset size_t size,

A missing comma between those two arguments...       ^

> +                                     int direction, dma_addr_t dma_addr,
> +                                     bool map_single)


-- 
dwmw2

