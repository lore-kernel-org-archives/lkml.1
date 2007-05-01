Return-Path: <linux-kernel-owner+w=401wt.eu-S1946046AbXEAW4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946046AbXEAW4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946048AbXEAW4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:56:10 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59904 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946046AbXEAW4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:56:09 -0400
Date: Wed, 2 May 2007 01:56:05 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/33] m68k: CROSS_COMPILE = m68k-linux-gnu-
Message-ID: <20070501225605.GA5533@sci.fi>
References: <20070501203234.252205858@mail.of.borg> <20070501203330.778353898@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070501203330.778353898@mail.of.borg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:32:40PM +0200, Geert Uytterhoeven wrote:
> Recent cross-compilers are called m68k-linux-gnu-gcc instead of m68k-linux-gcc
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-m68k-2.6.21.orig/arch/m68k/Makefile
> +++ linux-m68k-2.6.21/arch/m68k/Makefile
> @@ -21,7 +21,7 @@ AS += -m68020
>  LDFLAGS := -m m68kelf
>  ifneq ($(COMPILE_ARCH),$(ARCH))
>  	# prefix for cross-compiling binaries
> -	CROSS_COMPILE = m68k-linux-
> +	CROSS_COMPILE = m68k-linux-gnu-
>  endif
>  
>  ifdef CONFIG_SUN3

What about using ?= so the user can override it. I sent a patch doing
just that but never got any response.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
