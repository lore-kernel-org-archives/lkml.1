Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYGXNoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYGXNoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYGXNoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:44:22 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:36693 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYGXNoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tXRpUmbTYPGGtWOsYTrdOD4b8BNQ6ExSveI9xgzaUl0su/v0hghtDOlce+je9aKLNK
         qVPkds9NhA/JWdTy1+p16Eh+F5qwt7HR+o6oVQE2x0OFMT63vX7DEusgrVDP6VtbWyNR
         G1CHRShZd+NjVbtFkK39i3AxhBZ2Fr/tSF7ww=
Message-ID: <74d0deb30807240644q67779232m1a266243e02656ac@mail.gmail.com>
Date: Thu, 24 Jul 2008 15:44:19 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Input: Enable WM97xx touchscreen sub-drivers by default
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1216905308-4723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216905308-4723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 3:15 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Currently the support for each WM97xx touchscreen model is compiled out
> by default, meaning that the default configuration when the driver is
> built is for it to support no hardware.  This is suboptimal and leads to
> problems like distribution kernels shipping a non-functional driver.
>
> Change the default to support all controllers and update the help text
> to reflect this.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/input/touchscreen/Kconfig |   21 +++++++++------------
>  1 files changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index e573665..f3933f0 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -237,29 +237,26 @@ config TOUCHSCREEN_WM97XX
>  config TOUCHSCREEN_WM9705
>        bool "WM9705 Touchscreen interface support"
>        depends on TOUCHSCREEN_WM97XX
> +       default y
>        help
> -         Say Y here if you have a Wolfson Microelectronics WM9705
> -         touchscreen controller connected to your system.
> -
> -         If unsure, say N.
> +         Say Y here if to enable support for the Wolfson Microelectronics

Say Y here to enable?

> +         WM9705 touchscreen controller.
>
>  config TOUCHSCREEN_WM9712
>        bool "WM9712 Touchscreen interface support"
>        depends on TOUCHSCREEN_WM97XX
> +       default y
>        help
> -         Say Y here if you have a Wolfson Microelectronics WM9712
> -         touchscreen controller connected to your system.
> -
> -         If unsure, say N.
> +         Say Y here if to enable support for the Wolfson Microelectronics

dito

> +         WM9712 touchscreen controller.
>
>  config TOUCHSCREEN_WM9713
>        bool "WM9713 Touchscreen interface support"
>        depends on TOUCHSCREEN_WM97XX
> +       default y
>        help
> -         Say Y here if you have a Wolfson Microelectronics WM9713 touchscreen
> -         controller connected to your system.
> -
> -         If unsure, say N.
> +         Say Y here if to enable support for the Wolfson Microelectronics

dito

> +         WM9713 touchscreen controller.
>
>  config TOUCHSCREEN_WM97XX_MAINSTONE
>        tristate "WM97xx Mainstone accelerated touch"
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

regards
Philipp
