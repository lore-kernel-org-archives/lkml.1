Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbXLBTn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbXLBTn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbXLBTnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:43:49 -0500
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1300 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbXLBTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:43:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH 2/2] ivtv: Remove a invalid shadow-variable
Date: Sun, 2 Dec 2007 20:43:26 +0100
User-Agent: KMail/1.9.5
Cc: Richard Knutsson <ricknu-0@student.ltu.se>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
References: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se> <20071202173335.15374.10234.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071202173335.15374.10234.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712022043.26799.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 December 2007 18:47, Richard Knutsson wrote:
> Remove the shadowing 'struct v4l2_chip_ident *chip', since it already
> exists and makes the if-statement useless.
>
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks,

	Hans

> ---
> Compile-tested on i386 with "allyesconfig" and "allmodconfig".
>
>
> diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c
> b/drivers/media/video/ivtv/ivtv-ioctl.c index fd6826f..874aa22 100644
> --- a/drivers/media/video/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/video/ivtv/ivtv-ioctl.c
> @@ -660,11 +660,8 @@ static int ivtv_debug_ioctls(struct file *filp,
> unsigned int cmd, void *arg) chip->ident = V4L2_IDENT_NONE;
>  		chip->revision = 0;
>  		if (reg->match_type == V4L2_CHIP_MATCH_HOST) {
> -			if (v4l2_chip_match_host(reg->match_type, reg->match_chip)) {
> -				struct v4l2_chip_ident *chip = arg;
> -
> +			if (v4l2_chip_match_host(reg->match_type, reg->match_chip))
>  				chip->ident = itv->has_cx23415 ? V4L2_IDENT_CX23415 :
> V4L2_IDENT_CX23416; -			}
>  			return 0;
>  		}
>  		if (reg->match_type == V4L2_CHIP_MATCH_I2C_DRIVER)
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
