Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbZJIJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbZJIJa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbZJIJa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:30:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:34886 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbZJIJa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b6P9BgmU4ZGbnV/h8wkoNNvOmN4O8FK0jtnOAZVOc3362cAz2r/rwbAcLenm3KrADG
         TXkgq6CZdJe2EwUl/oKmhRiaW5gEX9wZVUcR9LL4CubERFzRaXYp+KoDSJpnDOz/Rtpe
         juhItATe630FLjCgiD0Nh41wDMaDPBPhBWowU=
MIME-Version: 1.0
In-Reply-To: <20091009085847.GA24918@july>
References: <20091009085847.GA24918@july>
Date: Fri, 9 Oct 2009 14:59:19 +0530
Message-ID: <5d5443650910090229mb3baf06we208c07200003f77@mail.gmail.com>
Subject: Re: [PATCH 4/6] Haptic: add haptic configuration (v2)
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Fri, Oct 9, 2009 at 2:28 PM, Kyungmin Park <kyungmin.park@samsung.com> wrote:
> haptic class support
>
> Changelog v1:
>        Fix typo
>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/Kconfig  |    2 ++
>  drivers/Makefile |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 48bbdbe..a44348e 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -90,6 +90,8 @@ source "drivers/memstick/Kconfig"
>
>  source "drivers/leds/Kconfig"
>
> +source "drivers/haptic/Kconfig"
> +
>  source "drivers/accessibility/Kconfig"
>
>  source "drivers/infiniband/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 6ee53c7..ee6f438 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -94,6 +94,7 @@ obj-y                         += idle/
>  obj-$(CONFIG_MMC)              += mmc/
>  obj-$(CONFIG_MEMSTICK)         += memstick/
>  obj-$(CONFIG_NEW_LEDS)         += leds/
> +obj-$(CONFIG_HAPTIC)           += haptic/
>  obj-$(CONFIG_INFINIBAND)       += infiniband/
>  obj-$(CONFIG_SGI_SN)           += sn/
>  obj-y                          += firmware/

Reviewed-by: Trilok Soni <soni.trilok@gmail.com>


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
