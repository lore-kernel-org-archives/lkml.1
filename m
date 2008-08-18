Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYHRWHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYHRWHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYHRWGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:06:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:38699 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYHRWGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:06:51 -0400
Subject: Re: [PATCH] RADEON: duplicate PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <48AA3900.80305@gmail.com>
References: <48AA3900.80305@gmail.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 08:06:40 +1000
Message-Id: <1219097200.28339.94.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 23:07 -0400, roel kluin wrote:
> untested, is it correct?
> ---
> duplicate PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb

Hard to say... this code originates from ATI. I'll have to dig a bit
to see what is the right bit combo I suppose.

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
> index 675abda..74d2e65 100644
> --- a/drivers/video/aty/radeon_pm.c
> +++ b/drivers/video/aty/radeon_pm.c
> @@ -210,7 +210,7 @@ static void radeon_pm_disable_dynamic_mode(struct radeonfb_info *rinfo)
>  			 PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb	|
>  			 PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb	|
>  			 PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb		|
> -			 PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb		|
> +			 PIXCLKS_CNTL__R300_P2G2CLK_DAC_ALWAYS_ONb	|
>  			 PIXCLKS_CNTL__R300_DISP_DAC_PIXCLK_DAC2_BLANK_OFF);
>                  OUTPLL(pllPIXCLKS_CNTL, tmp);
>  
> @@ -392,7 +392,7 @@ static void radeon_pm_enable_dynamic_mode(struct radeonfb_info *rinfo)
>  			PIXCLKS_CNTL__R300_PIXCLK_TRANS_ALWAYS_ONb      |
>  			PIXCLKS_CNTL__R300_PIXCLK_TVO_ALWAYS_ONb        |
>  			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb           |
> -			PIXCLKS_CNTL__R300_P2G2CLK_ALWAYS_ONb);
> +			PIXCLKS_CNTL__R300_P2G2CLK_DAC_ALWAYS_ONb);
>  		OUTPLL(pllPIXCLKS_CNTL, tmp);
>  
>  		tmp = INPLL(pllMCLK_MISC);

