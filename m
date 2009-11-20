Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZKTJW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZKTJW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZKTJW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:22:57 -0500
Received: from mga12.intel.com ([143.182.124.36]:51607 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803AbZKTJW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="213787179"
Date: Fri, 20 Nov 2009 10:24:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl4030: Fix warning
Message-ID: <20091120092445.GC3733@sortiz.org>
References: <20091117154841.3941.35813.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117154841.3941.35813.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:48:47PM +0000, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@linux.intel.com>
Applied, thanks Alan.

Cheers,
Samuel.


> ---
> 
>  drivers/mfd/twl4030-irq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index fb194fe..c78b5ad 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -728,7 +728,8 @@ int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
>  		goto fail_rqirq;
>  	}
>  
> -	task = kthread_run(twl4030_irq_thread, (void *)irq_num, "twl4030-irq");
> +	task = kthread_run(twl4030_irq_thread, (void *)(long)irq_num,
> +								"twl4030-irq");
>  	if (IS_ERR(task)) {
>  		pr_err("twl4030: could not create irq %d thread!\n", irq_num);
>  		status = PTR_ERR(task);
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
