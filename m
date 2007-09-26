Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbXIZNEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbXIZNEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXIZNDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:03:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXIZNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:03:51 -0400
Subject: Re: [PATCH] usbvision-video: buggered method tables
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thierry MERLE <thierry.merle@free.fr>
In-Reply-To: <E1IaL9q-00084l-9L@ZenIV.linux.org.uk>
References: <E1IaL9q-00084l-9L@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Sep 2007 10:02:25 -0300
Message-Id: <1190811745.5076.4.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Qua, 2007-09-26 às 01:53 +0100, Al Viro escreveu:
> duplicated .mmap in one, .vidioc_s_audio misspelled as .vidioc_g_audio
> in other
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

> ---
>  drivers/media/video/usbvision/usbvision-video.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
> index e3371f9..0cb006f 100644
> --- a/drivers/media/video/usbvision/usbvision-video.c
> +++ b/drivers/media/video/usbvision/usbvision-video.c
> @@ -1387,7 +1387,6 @@ static const struct file_operations usbvision_fops = {
>  	.ioctl		= video_ioctl2,
>  	.llseek		= no_llseek,
>  /* 	.poll          = video_poll, */
> -	.mmap	       = usbvision_v4l2_mmap,
>  	.compat_ioctl  = v4l_compat_ioctl32,
>  };
>  static struct video_device usbvision_video_template = {
> @@ -1413,7 +1412,7 @@ static struct video_device usbvision_video_template = {
>  	.vidioc_s_input       = vidioc_s_input,
>  	.vidioc_queryctrl     = vidioc_queryctrl,
>  	.vidioc_g_audio       = vidioc_g_audio,
> -	.vidioc_g_audio       = vidioc_s_audio,
> +	.vidioc_s_audio       = vidioc_s_audio,
>  	.vidioc_g_ctrl        = vidioc_g_ctrl,
>  	.vidioc_s_ctrl        = vidioc_s_ctrl,
>  	.vidioc_streamon      = vidioc_streamon,
> @@ -1459,7 +1458,7 @@ static struct video_device usbvision_radio_template=
>  	.vidioc_s_input       = vidioc_s_input,
>  	.vidioc_queryctrl     = vidioc_queryctrl,
>  	.vidioc_g_audio       = vidioc_g_audio,
> -	.vidioc_g_audio       = vidioc_s_audio,
> +	.vidioc_s_audio       = vidioc_s_audio,
>  	.vidioc_g_ctrl        = vidioc_g_ctrl,
>  	.vidioc_s_ctrl        = vidioc_s_ctrl,
>  	.vidioc_g_tuner       = vidioc_g_tuner,
-- 
Cheers,
Mauro

