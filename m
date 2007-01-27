Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXA0UTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXA0UTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXA0UTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:19:45 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:56130 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXA0UTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:19:44 -0500
Date: Sat, 27 Jan 2007 21:19:29 +0100
Message-Id: <200701272019.l0RKJTKh026426@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: hans-peter.nilsson@axis.com, linux-kernel@vger.kernel.org,
       mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net
In-reply-to: <200701262021.55317.david-b@pacbell.net> (message from David
	Brownell on Fri, 26 Jan 2007 20:21:54 -0800)
Subject: Re: [PATCH 1/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Fri, 26 Jan 2007 20:21:54 -0800

> In fact, how about this one instead?  It uses a bit in spi->mode
> since that's pretty easy to test.  And while it doesn't get rid
> of the multiple conditionals when the tx buffer is null, it does
> let the other values be constants (0, ~0) that compilers like.

I'm fine, except the typo.

> (I can update your patch #4, etc, to match.)

Or I could, and test it to boot. :)

> +#define MODEBITS	(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH | SPI_TX_1)

Add SPI_LSB_FIRST (still supported by spi_bitbang, I presume :)

brgds, H-P
