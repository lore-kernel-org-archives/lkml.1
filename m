Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0CHIKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 03:10:19 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59717 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0CHIKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 03:10:16 -0500
Date: Mon, 8 Mar 2010 09:10:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation: fix block/biodoc.txt dma mapping
	description
Message-ID: <20100308081014.GN5768@kernel.dk>
References: <20100308155252Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308155252Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08 2010, FUJITA Tomonori wrote:
> - It looks incorrect to use blk_rq_map_sg with pci_map_page here about
>   DMA mappings. dma_map_sg?
> 
> - better to use dma_map_page instead of pci_map_page.
>   http://marc.info/?l=linux-kernel&m=126596737604808&w=2

Thanks, when this was written, dma_map_page() didn't exist yet.

-- 
Jens Axboe

