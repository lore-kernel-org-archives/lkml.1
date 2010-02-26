Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935394Ab0BZHE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:04:27 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40096 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935384Ab0BZHEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:04:24 -0500
Date: Fri, 26 Feb 2010 08:04:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: dream: camera: sk5k3e2fx: fix code style
	issues
Message-ID: <20100226070423.GB14036@atrey.karlin.mff.cuni.cz>
References: <1267140009-18775-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267140009-18775-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues about assignments in if conditions.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

ACK.

> ---
>  drivers/staging/dream/camera/s5k3e2fx.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
> index edba198..2426f5e 100644
> --- a/drivers/staging/dream/camera/s5k3e2fx.c
> +++ b/drivers/staging/dream/camera/s5k3e2fx.c
> @@ -743,12 +743,12 @@ static int s5k3e2fx_sensor_open_init(const struct msm_camera_sensor_info *data)
>  	}
>  
>  	/* initialize AF */
> -	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
> -			0x3146, 0x3A)) < 0)
> +	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr, 0x3146, 0x3A);
> +	if (rc < 0)
>  		goto init_fail1;
>  
> -	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
> -			0x3130, 0x03)) < 0)
> +	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr, 0x3130, 0x03);
> +	if (rc < 0)
>  		goto init_fail1;
>  
>  	goto init_done;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
