Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZFRW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZFRW24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZFRW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:28:48 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:45834 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752118AbZFRW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:28:48 -0400
Date: Fri, 19 Jun 2009 00:24:13 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>
Subject: Re: [PATCH 5/5] at91/atmel_lcdfb: add at91sam9g10 support to atmel
	LCD driver
Message-ID: <20090618222413.GC19515@game.jcrosoft.org>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com> <1245341772-1689-6-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245341772-1689-6-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Ovh-Tracer-Id: 13806910559365868396
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:16 Thu 18 Jun     , Nicolas Ferre wrote:
> From: Hong Xu <hong.xu@atmel.com>
> 
> Modify atmel LCD driver: atmel_lcdfb for at91sam9g10.  This add a clock
> management equivalent to at91sam9261.
> 
> Signed-off-by: Hong Xu <hong.xu@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/video/Kconfig           |    4 ++--
>  drivers/video/atmel_lcdfb.c     |    6 ++++--
>  drivers/video/backlight/Kconfig |    2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 5152168..2dbede4 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -933,7 +933,7 @@ config FB_S1D13XXX
>  
>  config FB_ATMEL
>  	tristate "AT91/AT32 LCD Controller support"
> -	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
> +	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
create a ARCH_ATMEL_HAS_FB then select it at the soc will allow to reduce this || xx... by
	depends on FB && ARCH_ATMEL_HAS_FB

Best Regards,
J.
