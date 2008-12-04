Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYLDH4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYLDH4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYLDH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:56:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:3591 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYLDH4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:56:12 -0500
Date: Thu, 4 Dec 2008 08:56:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: use min_not_zero in blk_queue_stack_limits
Message-ID: <20081204075607.GG18255@kernel.dk>
References: <20081204153243G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204153243G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04 2008, FUJITA Tomonori wrote:
> This is against for-2.6.29 in the block tree.
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: use min_not_zero in blk_queue_stack_limits
> 
> zero is invalid for max_phys_segments, max_hw_segments, and
> max_segment_size. It's better to use use min_not_zero instead of
> min. min() works though (because the commit 0e435ac makes sure that
> these values are set to the default values, non zero, if a queue is
> initialized properly).
> 
> With this patch, blk_queue_stack_limits does the almost same thing
> that dm's combine_restrictions_low() does. I think that it's easy to
> remove dm's combine_restrictions_low.

Queued up for 2.6.29. It would be nice to get rid of the dm mirror of
this function...

-- 
Jens Axboe

