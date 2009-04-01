Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbZDAR5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbZDAR5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZDAR51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:57:27 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:16956 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbZDAR50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:57:26 -0400
Date: Wed, 1 Apr 2009 18:58:56 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] vga16fb: fix color component length
 for pseudocolor modes
Message-Id: <20090401185856.44d89699.krzysztof.h1@poczta.fm>
In-Reply-To: <20090330220523.GA6993@spock.one.pl>
References: <20090330220523.GA6993@spock.one.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: a2e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 00:05:24 +0200
Michal Januszewski <spock@gentoo.org> wrote:

> vga16fb incorrectly sets the length of the color fields to 6 or 2 bits
> for PSEUDOCOLOR modes, for which either 8 or 4 bits are used per pixel.
> Fix this by setting the length to 8 or 4, respectively.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 5b29389..50033b9 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -506,7 +506,7 @@ static int vga16fb_check_var(struct fb_var_screeninfo *var,
>  	var->red.offset = var->green.offset = var->blue.offset = 
>  	var->transp.offset = 0;
>  	var->red.length = var->green.length = var->blue.length =
> -		(par->isVGA) ? 6 : 2;
> +		(par->isVGA) ? 8 : 4;
>  	var->transp.length = 0;
>  	var->activate = FB_ACTIVATE_NOW;
>  	var->height = -1;
> 

There is the second place to change in the vga16fb_probe().

Regards,
Krzysztof

 	
----------------------------------------------------------------------
Internetowe dowcipy na 1 kwietnia! Sprawdz! ;) 
http://link.interia.pl/f20f4

