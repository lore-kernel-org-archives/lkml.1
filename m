Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbXJZL6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbXJZL6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXJZL6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:58:00 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29743 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbXJZL57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:57:59 -0400
Date: Fri, 26 Oct 2007 13:56:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: [PATCH] x86: fix pci-gart failure handling
Message-ID: <20071026115604.GI5155@kernel.dk>
References: <20071026080814Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071026080814Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26 2007, FUJITA Tomonori wrote:
> blk_rq_map_sg doesn't initialize sg->dma_address/length to zero
> anymore. Some low level drivers reuse sg lists without initializing so
> IOMMUs might get non-zero dma_address/length. If map_sg fails, we need
> pass the number of the mapped entries to gart_unmap_sg.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks Tomo, applied!

-- 
Jens Axboe

