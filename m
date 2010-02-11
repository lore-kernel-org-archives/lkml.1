Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0BKMZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:25:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:62293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab0BKMZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:25:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,451,1262592000"; 
   d="scan'208";a="595079433"
Date: Thu, 11 Feb 2010 13:27:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
       kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH] mfd: Fix WM8994 error handling
Message-ID: <20100211122703.GC3136@sortiz.org>
References: <4B6E145E.9090300@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6E145E.9090300@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 07, 2010 at 10:16:14AM +0900, Joonyoung Shim wrote:
> This patch fixes wrong goto statement for error handling on probe.
Patch applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/mfd/wm8994-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
> index 299c1af..844e1c1 100644
> --- a/drivers/mfd/wm8994-core.c
> +++ b/drivers/mfd/wm8994-core.c
> @@ -305,14 +305,14 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
>  				 wm8994->supplies);
>  	if (ret != 0) {
>  		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
> -		goto err_get;
> +		goto err_supplies;
>  	}
>  
>  	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
>  				    wm8994->supplies);
>  	if (ret != 0) {
>  		dev_err(wm8994->dev, "Failed to enable supplies: %d\n", ret);
> -		goto err_supplies;
> +		goto err_get;
>  	}
>  
>  	ret = wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET);
> -- 
> 1.6.3.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
