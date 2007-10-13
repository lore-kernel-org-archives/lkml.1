Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXJMPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXJMPXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXJMPXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 11:23:07 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53700 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbXJMPXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 11:23:06 -0400
Message-ID: <4710E2C6.5090302@lwfinger.net>
Date: Sat, 13 Oct 2007 10:22:46 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [patch 7/8] b43 wireless needs <linux/io.h>
References: <20071013123123.085686856@mail.of.borg> <20071013123414.160200918@mail.of.borg>
In-Reply-To: <20071013123414.160200918@mail.of.borg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> linux/drivers/net/wireless/b43/pio.h: In function 'b43_pio_write':
> linux/drivers/net/wireless/b43/pio.h:89: error: implicit declaration of function 'mmiowb'
>
> linux/drivers/net/wireless/b43/phy.c: In function 'b43_phy_write':
> linux/drivers/net/wireless/b43/phy.c:301: error: implicit declaration of function 'mmiowb'
>
> linuxdrivers/net/wireless/b43/sysfs.c: In function 'b43_attr_interfmode_store':
> linuxdrivers/net/wireless/b43/sysfs.c:147: error: implicit declaration of function 'mmiowb'

>From the distribution list for this E-mail, I presume this error occurred for m68k. Is this correct?
If so, I will probably need to prepare a similar patch for b43legacy.

Thanks,

Larry


