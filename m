Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbXJ2VZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbXJ2VZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXJ2VZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:25:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:54366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbXJ2VZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:25:33 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] cpuidle: remove unused exports
Date: Mon, 29 Oct 2007 17:25:19 -0400
User-Agent: KMail/1.9.5
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
References: <20071029124913.GJ7227@stusta.de>
In-Reply-To: <20071029124913.GJ7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291725.19844.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Monday 29 October 2007 08:49, Adrian Bunk wrote:
> This patch removes the following unused exports:
> - cpuidle_devices
> - cpuidle_register_governor
> - cpuidle_unregister_governor
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/cpuidle/cpuidle.c  |    1 -
>  drivers/cpuidle/governor.c |    3 ---
>  2 files changed, 4 deletions(-)
> 
> d2197cfe905506ff95f6acd1ee6a6cd933419fdf 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index fdf4106..d2fabe7 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -19,7 +19,6 @@
>  #include "cpuidle.h"
>  
>  DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
> -EXPORT_PER_CPU_SYMBOL_GPL(cpuidle_devices);
>  
>  DEFINE_MUTEX(cpuidle_lock);
>  LIST_HEAD(cpuidle_detected_devices);
> diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
> index bb699cb..70b5964 100644
> --- a/drivers/cpuidle/governor.c
> +++ b/drivers/cpuidle/governor.c
> @@ -94,8 +94,6 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
>  	return ret;
>  }
>  
> -EXPORT_SYMBOL_GPL(cpuidle_register_governor);
> -
>  /**
>   * cpuidle_replace_governor - find a replacement governor
>   * @exclude_rating: the rating that will be skipped while looking for
> @@ -138,4 +136,3 @@ void cpuidle_unregister_governor(struct cpuidle_governor *gov)
>  	mutex_unlock(&cpuidle_lock);
>  }
>  
> -EXPORT_SYMBOL_GPL(cpuidle_unregister_governor);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
