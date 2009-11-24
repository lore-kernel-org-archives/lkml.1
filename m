Return-Path: <linux-kernel-owner+w=401wt.eu-S934226AbZKXVmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226AbZKXVmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbZKXVmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:42:38 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:34081 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995AbZKXVmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:42:37 -0500
MIME-Version: 1.0
In-Reply-To: <1259096853-18909-32-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-24-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-25-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-26-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-27-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-28-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-29-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-30-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-31-git-send-email-u.kleine-koenig@pengutronix.de> 
	<1259096853-18909-32-git-send-email-u.kleine-koenig@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 24 Nov 2009 14:42:22 -0700
X-Google-Sender-Auth: 1c44dede3dd1d9d6
Message-ID: <fa686aa40911241342we68d831n4bd6e637ff21f939@mail.gmail.com>
Subject: Re: [PATCH 32/38] don't use __exit_p to wrap plat_mpc8xxx_spi_remove
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kumar Gala <galak@kernel.crashing.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       devicetree-discuss@lists.ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/24 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> The function plat_mpc8xxx_spi_remove is defined using __devexit, so don't
> use __exit_p but __devexit_p to wrap it.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Obviously correct.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: spi-devel-general@lists.sourceforge.net
> ---
>  drivers/spi/spi_mpc8xxx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
> index 0fd0ec4..1d98be9 100644
> --- a/drivers/spi/spi_mpc8xxx.c
> +++ b/drivers/spi/spi_mpc8xxx.c
> @@ -900,7 +900,7 @@ static int __devexit plat_mpc8xxx_spi_remove(struct platform_device *pdev)
>  MODULE_ALIAS("platform:mpc8xxx_spi");
>  static struct platform_driver mpc8xxx_spi_driver = {
>        .probe = plat_mpc8xxx_spi_probe,
> -       .remove = __exit_p(plat_mpc8xxx_spi_remove),
> +       .remove = __devexit_p(plat_mpc8xxx_spi_remove),
>        .driver = {
>                .name = "mpc8xxx_spi",
>                .owner = THIS_MODULE,
> --
> 1.6.5.2
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
