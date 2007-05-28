Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXE1IpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXE1IpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761820AbXE1Ih5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:37:57 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:50807 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759314AbXE1Ih4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:37:56 -0400
Date: Mon, 28 May 2007 10:37:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Linux-fbdev-devel] [PATCH 8/9] fbdev: Detect primary display
 device
In-Reply-To: <465952CD.2040409@gmail.com>
Message-ID: <Pine.LNX.4.64.0705281037080.4790@anakin>
References: <465952CD.2040409@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007, Antonino A. Daplas wrote:
> Add function helper, fb_is_display_device().  Given struct fb_info, it will
                             ^^^^^^^
			     primary

> return a nonzero value if the device is the primary display.

> +static inline int fb_is_primary_device(struct fb_screeninfo *info)
                                                 ^^^^^^^^^^^^^
						 fb_info

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
