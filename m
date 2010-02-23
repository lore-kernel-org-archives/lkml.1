Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0BWQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:28:54 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:55294 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752373Ab0BWQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:28:53 -0500
Date: Tue, 23 Feb 2010 17:28:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream: camera: msm_camera: fix coding style
 issues
Message-ID: <20100223162845.GE6220@elf.ucw.cz>
References: <1265914067-11150-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265914067-11150-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-02-11 15:47:47, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some coding style issues like to use __func__ instead
> __FUNCTION__, "foo *bar" instead "foo* bar" and a initial comment with
> "/* */" instead "//"
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  drivers/staging/dream/camera/msm_camera.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/dream/camera/msm_camera.c b/drivers/staging/dream/camera/msm_camera.c
> index 7d93877..4f808dc 100644
> --- a/drivers/staging/dream/camera/msm_camera.c
> +++ b/drivers/staging/dream/camera/msm_camera.c
> @@ -2,7 +2,7 @@
>   * Copyright (C) 2008-2009 QUALCOMM Incorporated.
>   */
>  
> -//FIXME: most allocations need not be GFP_ATOMIC
> +/* FIXME: most allocations need not be GFP_ATOMIC */
>  /* FIXME: management of mutexes */
>  /* FIXME: msm_pmem_region_lookup return values */
>  /* FIXME: way too many copy to/from user */
> @@ -361,7 +361,7 @@ static int __msm_get_frame(struct msm_sync *sync,
>  	if (!frame->buffer) {
>  		pr_err("%s: cannot get frame, invalid lookup address "
>  			"y=%x cbcr=%x offset=%d\n",
> -			__FUNCTION__,
> +			__func__,
>  			pphy->y_phy,
>  			pphy->cbcr_phy,
>  			frame->y_off);
> @@ -455,7 +455,7 @@ static int msm_disable_vfe(struct msm_sync *sync, void __user *arg)
>  	return rc;
>  }
>  
> -static struct msm_queue_cmd* __msm_control(struct msm_sync *sync,
> +static struct msm_queue_cmd *__msm_control(struct msm_sync *sync,
>  		struct msm_control_device_queue *queue,
>  		struct msm_queue_cmd *qcmd,
>  		int timeout)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
