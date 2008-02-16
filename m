Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYBPSUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYBPSUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYBPSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:20:21 -0500
Received: from as4.cineca.com ([130.186.84.251]:33950 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbYBPSUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:20:19 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Feb 2008 13:20:18 EST
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH 2/3] drivers/media/video/sn9c102/sn9c102_core.c Fix Unlikely(x) == y
Date: Sat, 16 Feb 2008 19:09:44 +0100
User-Agent: KMail/1.9.6
Cc: linux-usb@vger.kernel.org, video4linux-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
References: <47B70B6A.1070404@tiscali.nl>
In-Reply-To: <47B70B6A.1070404@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802161909.44284.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's okay, thanks.

Reviewed-by: Luca Risolia <luca.risolia@studio.unibo.it>
---

On Saturday 16 February 2008 17:12:26 Roel Kluin wrote:
> The patch below was not yet tested. If it's incorrect, please comment.
> ---
> Fix Unlikely(x) == y
>
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/media/video/sn9c102/sn9c102_core.c
> b/drivers/media/video/sn9c102/sn9c102_core.c index c40ba3a..66313b1 100644
> --- a/drivers/media/video/sn9c102/sn9c102_core.c
> +++ b/drivers/media/video/sn9c102/sn9c102_core.c
> @@ -528,7 +528,7 @@ sn9c102_find_sof_header(struct sn9c102_device* cam,
> void* mem, size_t len)
>
>  		/* Search for the SOF marker (fixed part) in the header */
>  		for (j = 0, b=cam->sof.bytesread; j+b < sizeof(marker); j++) {
> -			if (unlikely(i+j) == len)
> +			if (unlikely(i+j == len))
>  				return NULL;
>  			if (*(m+i+j) == marker[cam->sof.bytesread]) {
>  				cam->sof.header[cam->sof.bytesread] = *(m+i+j);


