Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYBGPYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYBGPYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbYBGPYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:24:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:45821 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755746AbYBGPYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:24:35 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/qtFdlBKvqcK+NYDFilGM9dafzCc+lHedd6TL0AA
	8QeqBa0zyPkkkF
Date: Thu, 7 Feb 2008 16:24:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH] Define a NO_GPIO macro to compare against and to use as
 an invalid GPIO
In-Reply-To: <Pine.LNX.4.64.0801311624370.8478@axis700.grange>
Message-ID: <Pine.LNX.4.64.0802071622020.5383@axis700.grange>
References: <Pine.LNX.4.64.0801311624370.8478@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Guennadi Liakhovetski wrote:

> As discussed on i2c mailing list with David Brownell, and number
> outside of the 0...MAX_INT range is invalid as a GPIO number.
> Define a macro, similar to NO_IRQ, to be used as a deliberate
> invalid GPIO, rather than defining a is_valid_gpio() macro.

David, I think, your ack is required on this one. Can we get it in, 
please? My soc-camera patches are accepted by the v4l maintainer, and 
without this one the series would be incomplete.

Thanks
Guennadi

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> ---
> 
> As gpiolib doesn't seem to have an own mailing list, sending it directly 
> to LKML.
> 
>  include/asm-generic/gpio.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index f29a502..806b86c 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -16,6 +16,10 @@
>  #define ARCH_NR_GPIOS		256
>  #endif
>  
> +#ifndef NO_GPIO
> +#define NO_GPIO			((unsigned int)-1)
> +#endif
> +
>  struct seq_file;
>  
>  /**
> -- 
> 1.5.3.4
> 

---
Guennadi Liakhovetski
