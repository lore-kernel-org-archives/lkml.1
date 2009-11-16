Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbZKPAr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbZKPAr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZKPAr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:47:27 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:41066 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888AbZKPAr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:47:26 -0500
Message-ID: <4B00A15A.9080102@snapgear.com>
Date: Mon, 16 Nov 2009 10:48:26 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>
CC: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: export clk_* symbols in clk.c
References: <200911131218.37434.sfking@fdwdc.com>
In-Reply-To: <200911131218.37434.sfking@fdwdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven King wrote:
> export the clk_*  stubs defined in arch/m68knommu/platform/coldfire/clk.c so
> they can be used by modules.
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>

Looks good, thanks.
Applied to for-linus branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git

Regards
Greg



>  arch/m68knommu/platform/coldfire/clk.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/arch/m68knommu/platform/coldfire/clk.c b/arch/m68knommu/platform/coldfire/clk.c
> index 7cdbf44..9f1260c 100644
> --- a/arch/m68knommu/platform/coldfire/clk.c
> +++ b/arch/m68knommu/platform/coldfire/clk.c
> @@ -9,6 +9,7 @@
>  /***************************************************************************/
>  
>  #include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/clk.h>
>  #include <asm/coldfire.h>
>  
> @@ -18,23 +19,27 @@ struct clk *clk_get(struct device *dev, const char *id)
>  {
>  	return NULL;
>  }
> +EXPORT_SYMBOL(clk_get);
>  
>  int clk_enable(struct clk *clk)
>  {
>  	return 0;
>  }
> +EXPORT_SYMBOL(clk_enable);
>  
>  void clk_disable(struct clk *clk)
>  {
>  }
> +EXPORT_SYMBOL(clk_disable);
>  
>  void clk_put(struct clk *clk)
>  {
>  }
> +EXPORT_SYMBOL(clk_put);
>  
>  unsigned long clk_get_rate(struct clk *clk)
>  {
>  	return MCF_CLK;
>  }
> -
> +EXPORT_SYMBOL(clk_get_rate);
>  /***************************************************************************/
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
