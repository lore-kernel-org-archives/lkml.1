Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab0BXW7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:59:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758042Ab0BXW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:58:58 -0500
Date: Wed, 24 Feb 2010 14:58:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5535_gpio: gpio_chip.get should return the input
 value
Message-Id: <20100224145822.803e86ed.akpm@linux-foundation.org>
In-Reply-To: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
References: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 16:55:17 -0600 Ben Gardner <gardner.ben@gmail.com> wrote:

> The gpio_chip.get() function for the CS5535 GPIO driver currently returns the
> output value instead of the input value.
> This patch changes it to return the input value.
> 
> Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
> ---
> --- linux-2.6.33-rc8.orig/drivers/gpio/cs5535-gpio.c
> +++ linux-2.6.33-rc8/drivers/gpio/cs5535-gpio.c
> @@ -154,7 +154,7 @@
> 
>  static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
> -	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
> +	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
>  }
> 
>  static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)

<presses F10>

What were the user-visible effects of this bug?
