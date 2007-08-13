Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXHMNOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXHMNOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970249AbXHMIl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:41:59 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:57091 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S970247AbXHMIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:41:57 -0400
Date: Mon, 13 Aug 2007 10:41:54 +0200
From: Martin Mares <mj@ucw.cz>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-video@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
Message-ID: <mj+md-20070813.084046.10732.nikam@ucw.cz>
References: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e0020d6..cde4be1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4440,6 +4440,9 @@ P:	Martin Mares
>  M:	mj@ucw.cz
>  L:	linux-video@atrey.karlin.mff.cuni.cz
>  S:	Maintained
> +F:	Documentation/svga.txt

OK.

> +F:	drivers/video/svgalib.c
> +F:	include/linux/svga.h

These two are not a part of the video mode selection code, but
arch/i386/boot/video.S is.

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Got mole problems? Call Avogadro, 602-1023!
