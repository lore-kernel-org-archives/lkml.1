Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZERIs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZERIs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZERIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:48:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZERIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:48:15 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 18 May 2009 10:48:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <1242633428-16460-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1242633428-16460-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181048.24264.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: [PATCH] gpio: max7301: add missing __devexit marking
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 18. Mai 2009, Mike Frysinger wrote:
> The remove member of the spi_driver max7301_driver uses __devexit_p(),
> so the remove function itself should be marked with __devexit.  Even
> more so considering the probe function is marked with __devinit.
>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> CC: Juergen Beisert <j.beisert@pengutronix.de>
> CC: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/gpio/max7301.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpio/max7301.c b/drivers/gpio/max7301.c
> index 3e7f4e0..7b82eaa 100644
> --- a/drivers/gpio/max7301.c
> +++ b/drivers/gpio/max7301.c
> @@ -287,7 +287,7 @@ exit_destroy:
>  	return ret;
>  }
>
> -static int max7301_remove(struct spi_device *spi)
> +static int __devexit max7301_remove(struct spi_device *spi)
>  {
>  	struct max7301 *ts;
>  	int ret;

Acked-by: Juergen Beisert <j.beisert@pengutronix.de>

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
