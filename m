Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbXKCJxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbXKCJxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 05:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXKCJwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 05:52:55 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:10373 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbXKCJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 05:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FjnlGbMjui1byd+0nIi/ULeJMGXDvzdcfQooDvWC/5pichrXjVYmFtSASSye9sQ/SjrSYtIYfQ2cUt/uL4ahHW0uiLQFms6GBZ8O5WYDarIP/8kDiDPDDG54CDF0MB+8IaQCpVgsBhDzOeFjmTkDY8HD7YXBK3gpF+Qmo2ZhHjU=
Message-ID: <386072610711030252k2f974504sd1af4e376b21ca2f@mail.gmail.com>
Date: Sat, 3 Nov 2007 17:52:53 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] BLACKFIN: Typo: "CONFIG_RTC_BFIN_MODULE" -> "CONFIG_RTC_DRV_BFIN_MODULE"
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       bryan.wu@analog.com, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0711030506370.8543@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711030506370.8543@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>
> ---
>
>   i'm *reasonably* confident that this is a typo that should be fixed.
>
>
Quite true. Thanks.

Acked-by: Bryan Wu <bryan.wu@analog.com>

> diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
> index b941550..7d33096 100644
> --- a/arch/blackfin/mach-bf533/boards/H8606.c
> +++ b/arch/blackfin/mach-bf533/boards/H8606.c
> @@ -49,7 +49,7 @@
>   */
>  const char bfin_board_name[] = "HV Sistemas H8606";
>
> -#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_BFIN_MODULE)
> +#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
>  static struct platform_device rtc_device = {
>         .name = "rtc-bfin",
>         .id   = -1,
> --
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
>
> http://crashcourse.ca
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
