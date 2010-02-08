Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0BHJQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:16:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56880 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0BHJQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:16:38 -0500
Date: Mon, 8 Feb 2010 10:16:34 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Nate Case <ncase@xes-inc.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 3/3] gpiolib: document that names can contain printk
	format specifiers
Message-ID: <20100208091634.GD15255@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de> <1265620180-14150-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265620180-14150-3-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 08, 2010 at 10:09:40AM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  include/asm-generic/gpio.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 37af893..abdb5d3 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -60,7 +60,8 @@ struct module;
>   * @names: if set, must be an array of strings to use as alternative
>   *      names for the GPIOs in this chip. Any entry in the array
>   *      may be NULL if there is no alias for the GPIO, however the
> - *      array must be @ngpio entries long.
> + *      array must be @ngpio entries long.  A name can include a single printk
> + *      format specifier for an unsigned int.
probably add: "It is substituted by the actual number of the gpio."

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
