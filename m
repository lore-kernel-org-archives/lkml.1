Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbXBRUUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbXBRUUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXBRUUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:20:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3847 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752022AbXBRUUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:20:43 -0500
Date: Sun, 18 Feb 2007 16:36:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Adrian Bunk <bunk@stusta.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>,
       gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] correct CONFIG_GIGASET_M101 Makefile entry
Message-ID: <20070218163621.GA3945@ucw.cz>
References: <20070215215609.GH13958@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215215609.GH13958@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Advanced Mathematics, lesson 1:
> 101 != 105
> 
> ;-)
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile.old	2007-02-15 17:38:23.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile	2007-02-15 17:38:41.000000000 +0100
> @@ -5,4 +5,4 @@
>  
>  obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
>  obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
> -obj-$(CONFIG_GIGASET_M105) += ser_gigaset.o gigaset.o
> +obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o

Are you sure? M105 is both usb and serial?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
