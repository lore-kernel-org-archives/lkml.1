Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZLCWHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZLCWHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZLCWHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:07:18 -0500
Received: from trinity.fluff.org ([89.16.178.74]:58612 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZLCWHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:07:16 -0500
Date: Thu, 3 Dec 2009 22:07:18 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Russell King <linux@arm.linux.org.uk>,
       Ryan Mallon <ryan@bluewatersys.com>,
       linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
       akpm@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Ramax Lo <ramaxlo@gmail.com>
Subject: Re: [PATCH 15/38] move s3c_adc_remove to .devexit.text
Message-ID: <20091203220718.GS4808@trinity.fluff.org>
References: <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-9-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-10-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-11-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-12-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-13-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-14-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259096853-18909-15-git-send-email-u.kleine-koenig@pengutronix.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:07:10PM +0100, Uwe Kleine-König wrote:
> The function s3c_adc_remove is used only wrapped by __devexit_p so define
> it using __devexit.

Shall I put these into my tree?
 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Acked-By: Ben Dooks <ben@simtec.co.uk>
> Cc: Ramax Lo <ramaxlo@gmail.com>
> Cc: Nelson Castillo <arhuaco@freaks-unidos.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Ryan Mallon <ryan@bluewatersys.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/plat-s3c24xx/adc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-s3c24xx/adc.c b/arch/arm/plat-s3c24xx/adc.c
> index df47322..ce47627 100644
> --- a/arch/arm/plat-s3c24xx/adc.c
> +++ b/arch/arm/plat-s3c24xx/adc.c
> @@ -365,7 +365,7 @@ static int s3c_adc_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> -static int s3c_adc_remove(struct platform_device *pdev)
> +static int __devexit s3c_adc_remove(struct platform_device *pdev)
>  {
>  	struct adc_device *adc = platform_get_drvdata(pdev);
>  
> -- 
> 1.6.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

