Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYLJOr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYLJOr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYLJOrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:47:14 -0500
Received: from brick.kernel.dk ([93.163.65.50]:26529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbYLJOrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:47:13 -0500
Date: Wed, 10 Dec 2008 15:46:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/33] block: Make static
Message-ID: <20081210144657.GV23742@kernel.dk>
References: <493EA286.7080500@gmail.com> <493EA41C.5060607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493EA41C.5060607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09 2008, Roel Kluin wrote:
> Sparse asked whether these could be static.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  block/blk-softirq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-softirq.c b/block/blk-softirq.c
> index e660d26..ce0efc6 100644
> --- a/block/blk-softirq.c
> +++ b/block/blk-softirq.c
> @@ -161,7 +161,7 @@ void blk_complete_request(struct request *req)
>  }
>  EXPORT_SYMBOL(blk_complete_request);
>  
> -__init int blk_softirq_init(void)
> +static __init int blk_softirq_init(void)
>  {
>  	int i;
>  

Applied to for-2.6.29, thanks.

-- 
Jens Axboe

