Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZG0VEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZG0VEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZG0VEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:04:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:36546 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbZG0VEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:04:34 -0400
Cc: linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-Id: <40312002-766E-428B-8AC4-5CB50D854647@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1248405855-15546-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 3/5] add set_dma_mask hook to struct dma_map_ops
Date: Mon, 27 Jul 2009 16:02:57 -0500
References: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1248405855-15546-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23, 2009, at 10:24 PM, FUJITA Tomonori wrote:

> POWERPC needs this hook. SPARC could use it too.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Becky Bruce <beckyb@kernel.crashing.org>

>
> ---
> include/linux/dma-mapping.h |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index c0f6c3c..91b7618 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -58,6 +58,7 @@ struct dma_map_ops {
> 				   enum dma_data_direction dir);
> 	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
> 	int (*dma_supported)(struct device *dev, u64 mask);
> +	int (*set_dma_mask)(struct device *dev, u64 mask);
> 	int is_phys;
> };
>
> --  
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

