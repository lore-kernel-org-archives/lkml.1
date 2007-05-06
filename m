Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXEFUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXEFUj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 16:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXEFUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 16:39:29 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1374 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbXEFUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 16:39:28 -0400
Date: Sun, 6 May 2007 22:39:25 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: <asm/scatterlist.h> needs <asm/types.h>
In-Reply-To: <Pine.LNX.4.64.0705062233160.4741@anakin>
Message-ID: <Pine.LNX.4.64.0705062238360.2956@scrub.home>
References: <Pine.LNX.4.64.0705062233160.4741@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 6 May 2007, Geert Uytterhoeven wrote:

> The recent <linux/pci.h> cleanup uncovered that include/asm-m68k/scatterlist.h
> needs to include <asm/types.h>
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/asm-m68k/scatterlist.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-m68k-2.6.21.orig/include/asm-m68k/scatterlist.h
> +++ linux-m68k-2.6.21/include/asm-m68k/scatterlist.h
> @@ -1,6 +1,8 @@
>  #ifndef _M68K_SCATTERLIST_H
>  #define _M68K_SCATTERLIST_H
>  
> +#include <asm/types.h>
> +

Unless required otherwise please use <linux/types.h>

bye, Roman
