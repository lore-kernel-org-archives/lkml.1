Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZL3VqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZL3VqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZL3VqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:46:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbZL3VqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:46:06 -0500
Date: Wed, 30 Dec 2009 13:44:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Jean Delvare <khali@linux-fr.org>, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpio: adp5588-gpio: new driver for ADP5588 GPIO
 expanders
Message-Id: <20091230134455.fb07fefe.akpm@linux-foundation.org>
In-Reply-To: <1261447302-16624-1-git-send-email-vapier@gentoo.org>
References: <1261447302-16624-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 21:01:42 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> +config GPIO_ADP5588
> +	tristate "ADP5588 I2C GPIO expander"
> +	depends on I2C
> +	help
> +	  This option enables support for 18 GPIOs found
> +	  on Analog Devices ADP5588 GPIO Expanders.
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called adp5588-gpio.

A neat little driver.  I don't see much to be gained by holding it off
for 2.6.34, so I'll queue it for .33.

