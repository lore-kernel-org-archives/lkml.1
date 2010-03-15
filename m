Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab0COFeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:34:01 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41015 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752389Ab0COFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:33:59 -0400
Date: Mon, 15 Mar 2010 06:33:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream:  generic_gpio: Use linux instead of
 asm uaccess.h
Message-ID: <20100315053352.GC11552@elf.ucw.cz>
References: <1268622355-9966-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268622355-9966-1-git-send-email-chihau@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-15 00:05:55, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This is moving toward using <linux/uaccess.h> instead of the old
> <asm/uaccess.h> file.

Changelog does not match the patch.

...plus, was the patch actually tested?
									Pavel

> --- a/drivers/staging/dream/generic_gpio.c
> +++ b/drivers/staging/dream/generic_gpio.c
> @@ -18,7 +18,7 @@
>  #include <linux/errno.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> -#include <asm/gpio.h>
> +#include <linux/gpio.h>
>  #include "gpio_chip.h"
>  
>  #define GPIO_NUM_TO_CHIP_INDEX(gpio) ((gpio)>>5)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
