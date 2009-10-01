Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZJAR2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZJAR2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZJAR2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:28:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:41550 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755814AbZJAR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,488,1249282800"; 
   d="scan'208";a="555788490"
Date: Thu, 1 Oct 2009 19:30:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 01/34] move asic3_remove to .devexit.text
Message-ID: <20091001173029.GI10199@sortiz.org>
References: <20091001082607.GA2181@pengutronix.de>
 <1254385718-14254-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1254385718-14254-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Oct 01, 2009 at 10:28:05AM +0200, Uwe Kleine-König wrote:
> The function asic3_remove is used only wrapped by __devexit_p so define
> it using __devexit.
Applied to the mfd tree, thanks.

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
> 1.6.4.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
