Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab0BKHUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 02:20:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50221 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0BKHUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 02:20:49 -0500
Date: Thu, 11 Feb 2010 08:20:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jochen Maes <jochen.maes@sejo.be>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers: dream: Code style fix
Message-ID: <20100211072040.GB3436@ucw.cz>
References: <1265795977-20293-1-git-send-email-jochen.maes@sejo.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265795977-20293-1-git-send-email-jochen.maes@sejo.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-02-10 10:59:37, Jochen Maes wrote:
> Removed parenthesis from return statements,
> split up assignment and if condition
> 
> Signed-off-by: Jochen Maes <jochen.maes@sejo.be>
> ---
>  drivers/staging/dream/camera/s5k3e2fx.c |   22 ++++++++++++----------
>  1 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
> index edba198..5cb22c8 100644
> --- a/drivers/staging/dream/camera/s5k3e2fx.c
> +++ b/drivers/staging/dream/camera/s5k3e2fx.c
> @@ -743,12 +743,14 @@ static int s5k3e2fx_sensor_open_init(const struct msm_camera_sensor_info *data)
>  	}
>  
>  	/* initialize AF */
> -	if ((rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
> -			0x3146, 0x3A)) < 0)
> +	rc = s5k3e2fx_i2c_write_b(s5k3e2fx_client->addr,
> +			0x3146, 0x3A)
> +	if rc < 0
>  		goto init_fail1;
>  

I do not think this is valid C.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
