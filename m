Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXBPOs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXBPOs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXBPOs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:48:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45266 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935AbXBPOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:48:56 -0500
Date: Fri, 16 Feb 2007 14:48:53 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Antonino Daplas <adaplas@pol.net>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i810fb: Fix i810_check_params section mismatch
In-Reply-To: <20070216143813.e7de85ef.khali@linux-fr.org>
Message-ID: <Pine.LNX.4.64.0702161448240.14957@pentafluge.infradead.org>
References: <20070216143813.e7de85ef.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew please apply.

Acked-By: James Simmons <jsimmons@infradead.org>

On Fri, 16 Feb 2007, Jean Delvare wrote:

> WARNING: drivers/video/i810/i810fb.o - Section mismatch: reference
> to .init.data: from .text between 'i810_check_params' (at offset
> 0x1123) and 'encode_fix'
> 
> yres cannot be declared __devinitdata as it is used in
> i810_check_params(), which isn't __devinit.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> This patch was already sent on December 17th, 2006.
> 
>  drivers/video/i810/i810_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.20-rc1.orig/drivers/video/i810/i810_main.c	2006-12-17 16:02:06.000000000 +0100
> +++ linux-2.6.20-rc1/drivers/video/i810/i810_main.c	2006-12-17 16:04:01.000000000 +0100
> @@ -142,7 +142,7 @@
>  static int vsync1     __devinitdata;
>  static int vsync2     __devinitdata;
>  static int xres       __devinitdata;
> -static int yres       __devinitdata;
> +static int yres;
>  static int vyres      __devinitdata;
>  static int sync       __devinitdata;
>  static int extvga     __devinitdata;
> 
> 
> 
