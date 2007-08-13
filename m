Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbXHMNzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbXHMNzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938385AbXHMKka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:40:30 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58364 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S938906AbXHMKkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:40:23 -0400
Date: Mon, 13 Aug 2007 12:39:24 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] [206/2many] MAINTAINERS - GENERIC GPIO I2C DRIVER
Message-ID: <20070813123924.25d422ac@dhcp-255-175.norway.atmel.com>
In-Reply-To: <46bff9fc.i+o8WMM7bF8WiNL9%joe@perches.com>
References: <46bff9fc.i+o8WMM7bF8WiNL9%joe@perches.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:28:12 -0700
joe@perches.com wrote:

> @@ -1967,6 +1967,8 @@ GENERIC GPIO I2C DRIVER
>  P:	Haavard Skinnemoen
>  M:	hskinnemoen@atmel.com
>  S:	Supported
> +F:	Documentation/gpio.txt

This document describes the generic GPIO interface which is used by the
i2c-gpio driver as well as many others. I don't think it should be
associated with this particular driver.

Patches for Documentation/gpio.txt should probably be sent to
linux-arch and David Brownell, who is the one who wrote it.

> +F:	drivers/i2c/busses/i2c-gpio.c

F: include/linux/i2c-gpio.h

The other patches I was Cc'ed on (77, 78, 81 and 82) all look good to
me.

Håvard
