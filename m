Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0APCet (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108Ab0APCes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:34:48 -0500
Received: from trinity.fluff.org ([89.16.178.74]:42355 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab0APCes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:34:48 -0500
Date: Sat, 16 Jan 2010 02:34:42 +0000
From: Ben Dooks <ben@trinity.fluff.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c-fb: Fix mixed code and variable declaration
Message-ID: <20100116023442.GF3738@trinity.fluff.org>
References: <1263574286-6382-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263574286-6382-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 04:51:26PM +0000, Mark Brown wrote:
> Hoist osdc_data up into the variable declaration section.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
>  drivers/video/s3c-fb.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index e2e7afd..58e2fed 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -269,6 +269,7 @@ static int s3c_fb_set_par(struct fb_info *info)
>  	int win_no = win->index;
>  	u32 data;
>  	u32 pagewidth;
> +	u32 osdc_data;
>  	int clkdiv;
>  
>  	dev_dbg(sfb->dev, "setting framebuffer parameters\n");
> @@ -359,8 +360,6 @@ static int s3c_fb_set_par(struct fb_info *info)
>  
>  	data = var->xres * var->yres;
>  
> -	u32 osdc_data = 0;
> -
>  	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
>  		VIDISD14C_ALPHA1_G(0xf) |
>  		VIDISD14C_ALPHA1_B(0xf);
> -- 
> 1.6.6
> 

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

