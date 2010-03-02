Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0CBWkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:40:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab0CBWkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:40:40 -0500
Date: Tue, 2 Mar 2010 14:40:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RESEND] gpio: introduce it8761e_gpio driver for IT8761E Super
 I/O chip
Message-Id: <20100302144027.bf6ea1c9.akpm@linux-foundation.org>
In-Reply-To: <4B8A2F34.3020505@compulab.co.il>
References: <4B8A2F34.3020505@compulab.co.il>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Feb 2010 10:54:12 +0200
Denis Turischev <denis@compulab.co.il> wrote:

> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -101,6 +101,12 @@ config GPIO_SCH
>   	  This driver can also be built as a module. If so, the module
>   	  will be called sch-gpio.
> 
> +config GPIO_IT8761E
> +	tristate "IT8761E GPIO support"
> +	depends on GPIOLIB
> +	help
> +	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
> +

The comment said "put expanders in the right section, in alphabetical
order".  It wasn't in alphabetical order ;)

Is this a "Memory mapped GPIO expander"?  Looks like it's IO-mapped,
but there isn't a section in Kconfig for that.  PCI mapped?


