Return-Path: <linux-kernel-owner+w=401wt.eu-S934405AbZKXXWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbZKXXWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934366AbZKXXWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:22:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:32621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934364AbZKXXWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:22:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="470301361"
Date: Wed, 25 Nov 2009 00:24:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 01/38] move asic3_remove to .devexit.text
Message-ID: <20091124232421.GG8290@sortiz.org>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Tue, Nov 24, 2009 at 10:06:56PM +0100, Uwe Kleine-König wrote:
> The function asic3_remove is used only wrapped by __devexit_p so define
> it using __devexit.
This one was already applied to my for-next branch.

Cheers,
Samuel.


> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mfd/asic3.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index 63a2a66..e22128c 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -908,7 +908,7 @@ static int __init asic3_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> -static int asic3_remove(struct platform_device *pdev)
> +static int __devexit asic3_remove(struct platform_device *pdev)
>  {
>  	int ret;
>  	struct asic3 *asic = platform_get_drvdata(pdev);
> -- 
> 1.6.5.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
