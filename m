Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbXFREvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbXFREvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXFREvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:51:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47934 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbXFREvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:51:40 -0400
Date: Mon, 18 Jun 2007 06:52:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] arch/i386/video/fbdev.c should #include <asm/fb.h>
Message-ID: <20070618045244.GA20224@uranus.ravnborg.org>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070617234257.GE3588@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617234257.GE3588@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 01:42:57AM +0200, Adrian Bunk wrote:
> Every file should include the headers containing the prototypes for
> it's global functions.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.22-rc4-mm2/arch/i386/video/fbdev.c.old	2007-06-17 15:48:25.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/arch/i386/video/fbdev.c	2007-06-17 15:48:53.000000000 +0200
> @@ -11,6 +11,8 @@
>  #include <linux/fb.h>
>  #include <linux/pci.h>
>  
> +#include <asm/fb.h>
> +

1) Why not include asm/fb.h from linux/fb.h?
2) Is asm/fb.h an -mm thing? I do not have it in my linus tree.

Note: Ketchup is broken on my ubuntu box so no -mm right now.

	Sam
