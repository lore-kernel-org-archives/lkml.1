Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYBRDIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYBRDIj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbYBRDI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:08:27 -0500
Received: from mfo32.po.2iij.net ([210.128.50.15]:11569 "EHLO
	mfo32.po.2iij.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbYBRDI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:08:26 -0500
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 22:08:26 EST
Date: Mon, 18 Feb 2008 11:58:24 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Adrian Bunk <bunk@stusta.de>
Cc: yoichi_yuasa@tripeaks.co.jp, Dmitry Torokhov <dtor@mail.ru>,
       ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: cobalt_btns.c <-> struct platform_device compile error
Message-Id: <20080218115824.3ae7cf29.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20080217200935.GE1403@cs181133002.pp.htv.fi>
References: <20080217200935.GE1403@cs181133002.pp.htv.fi>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I already sent a patch to Dmitry.

Yoichi

On Sun, 17 Feb 2008 22:09:35 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> Commit b037b08e59633d939d79f1df9c43c6625f8db904 broke the compilation of 
> cobalt_btns.c:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/input/misc/cobalt_btns.o
> ...
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c: In function 'cobalt_buttons_probe':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:101: error: 'struct platform_device' has no member named 'keymap'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/input/misc/cobalt_btns.c:102: error: 'struct platform_device' has no member named 'keymap'
> ...
> make[4]: *** [drivers/input/misc/cobalt_btns.o] Error 1
> 
> <--  snip  -->
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 
> 
