Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZAEU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZAEU1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZAEU1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:27:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:51868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752504AbZAEU1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:27:38 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18oevFXd4AoJlXOHF9b8dCh0FpOgkfVeifVU3h29a
	+WbDl/FmwFAUd0
Date: Mon, 5 Jan 2009 21:27:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Luotao Fu <l.fu@pengutronix.de>
cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicated defines in pxa_camera.c
In-Reply-To: <1231175487-3293-1-git-send-email-l.fu@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0901052125480.8605@axis700.grange>
References: <1231175487-3293-1-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Luotao Fu wrote:

> Defines for CIR Registers have been moved to pxa_camera.h. So remove them from
> pxa_camera.c to avoid compiler warnings.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> ---
>  drivers/media/video/pxa_camera.c |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index cb8c5e1..4eda750 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -44,19 +44,6 @@
>  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
>  #define PXA_CAM_DRV_NAME "pxa27x-camera"
>  
> -/* Camera Interface */
> -#define CICR0		0x0000
> -#define CICR1		0x0004
> -#define CICR2		0x0008
> -#define CICR3		0x000C
> -#define CICR4		0x0010
> -#define CISR		0x0014
> -#define CIFR		0x0018
> -#define CITOR		0x001C
> -#define CIBR0		0x0028
> -#define CIBR1		0x0030
> -#define CIBR2		0x0038
> -
>  #define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
>  #define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
>  #define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
> -- 
> 1.5.6.5

NAK. Please, see an earlier patch from Eric Miao, a correct fix for this 
is in the queue.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
