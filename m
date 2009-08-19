Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbZHSHnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbZHSHnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZHSHnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:43:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34170 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZHSHnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:43:19 -0400
Date: Wed, 19 Aug 2009 09:43:18 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Make MC13783 driver depend on SPI
Message-ID: <20090819074318.GD23444@pengutronix.de>
References: <1250636045-23014-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250636045-23014-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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
X-Uptime: 09:42:39 up 13 days, 19:01, 29 users,  load average: 1.48, 1.75,
	1.46
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 11:54:05PM +0100, Mark Brown wrote:
> The Atlas chips need SPI to be enabled for chip access, if it is not
> available build failures result due to the use of the SPI APIs for
> register I/O.

Missed that one.

> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> ---
>  drivers/mfd/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 960c9d4..a4f3dff 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -240,6 +240,7 @@ config MFD_PCF50633
>  
>  config MFD_MC13783
>  	tristate "Support Freescale MC13783"
> +	depends on SPI_MASTER
>  	select MFD_CORE
>  	help
>  	  Support for the Freescale (Atlas) MC13783 PMIC and audio CODEC.
> -- 
> 1.6.3.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
