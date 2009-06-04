Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZFDHv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZFDHv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZFDHvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:51:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbZFDHvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:51:20 -0400
Date: Thu, 4 Jun 2009 00:51:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=9A=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Added timbgpio
Message-Id: <20090604005119.6b4f80e0.akpm@linux-foundation.org>
In-Reply-To: <4A262F54.3090106@mocean-labs.com>
References: <4A262F54.3090106@mocean-labs.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 10:07:48 +0200 Richard R____jfors  <richard.rojfors.ext@mocean-labs.com> wrote:

> Supplied is a GPIO driver for the Timberdale FPGA found on the
> Intel Atom board Russellville.
>
> ...
> 
> +EXPORT_SYMBOL(timbgpio_gpio_flnk_lvl_ctrl);
> +EXPORT_SYMBOL(timbgpio_gpio_int_ctrl);
> +EXPORT_SYMBOL(timbgpio_gpio_lvl_ctrl);
> +EXPORT_SYMBOL(timbgpio_gpio_int_clr);

Why all these module exports?

> ...
>
> +config GPIO_TIMBERDALE
> +	tristate "Support for timberdale GPIO"
> +	depends on MFD_TIMBERDALE && GPIOLIB
> +	---help---
> +	Add support for GPIO usage of some pins of the timberdale FPGA.
> +

I cannot find anything which sets MFD_TIMBERDALE anywhere?
