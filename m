Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZD2QwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZD2QwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZD2QwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:52:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZD2QwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:52:03 -0400
Date: Wed, 29 Apr 2009 18:51:27 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: autobuild-bsp@pengutronix.de, sha@pengutronix.de,
       Juergen Beisert <jbe@pengutronix.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [FAILED] phyCORE-i.MX35 + Linus's git kernel (origin/master)
Message-ID: <20090429165127.GZ5367@pengutronix.de>
Mail-Followup-To: Robert Schwebel <r.schwebel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	autobuild-bsp@pengutronix.de, sha@pengutronix.de,
	Juergen Beisert <jbe@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org
References: <E1Lyeeh-0001TA-QH@himalia.hi.pengutronix.de> <200904280918.16248.jbe@pengutronix.de> <20090429162952.GY5367@pengutronix.de> <Pine.LNX.4.64.0904291838070.4676@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904291838070.4676@axis700.grange>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 18:42:04 up 70 days,  8:35, 24 users,  load average: 0.07, 1.36,
	1.33
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

[switching to list]

On Wed, Apr 29, 2009 at 06:38:59PM +0200, Guennadi Liakhovetski wrote:
> see attachment

What's the state of the patch below? The mainline Linus kernel doesn't
compile any more for the whole mx3 family since days, so the patch
should be applied with high priority in order to make it possible again
to be able to test the latest-and-greatest.

rsc

> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> From hg-commit@linuxtv.org Wed Apr 29 00:15:48 2009
> Date: Wed, 29 Apr 2009 00:15:03 +0200
> From: Patch from Sascha Hauer <hg-commit@linuxtv.org>
> Reply-To: Sascha Hauer  via Mercurial <s.hauer@pengutronix.de>
> To: linuxtv-commits@linuxtv.org
> Cc:Sascha Hauer  <s.hauer@pengutronix.de>, Guennadi Liakhovetski  <g.liakhovetski@gmx.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, 
> Subject: [hg:v4l-dvb] mx3_camera: Fix compilation with CONFIG_PM
> 
> The patch number 11612 was added via Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Sascha Hauer  <s.hauer@pengutronix.de>
> mx3_camera: Fix compilation with CONFIG_PM
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> priority: high
> ---
>  drivers/media/video/mx3_camera.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> 
> ---
> 
>  linux/drivers/media/video/mx3_camera.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff -r 54265472e7cb -r 4a2b85d095d4 linux/drivers/media/video/mx3_camera.c
> --- a/linux/drivers/media/video/mx3_camera.c	Fri Apr 24 17:57:42 2009 +0200
> +++ b/linux/drivers/media/video/mx3_camera.c	Fri Apr 24 17:58:24 2009 +0200
> @@ -1063,10 +1063,6 @@ static struct soc_camera_host_ops mx3_so
>  	.owner		= THIS_MODULE,
>  	.add		= mx3_camera_add_device,
>  	.remove		= mx3_camera_remove_device,
> -#ifdef CONFIG_PM
> -	.suspend	= mx3_camera_suspend,
> -	.resume		= mx3_camera_resume,
> -#endif
>  	.set_crop	= mx3_camera_set_crop,
>  	.set_fmt	= mx3_camera_set_fmt,
>  	.try_fmt	= mx3_camera_try_fmt,
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/4a2b85d095d493fa9f6a3160ff418475921e5576

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
