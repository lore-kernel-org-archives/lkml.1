Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbXKEHkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbXKEHkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXKEHkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:40:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37688 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXKEHkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:40:00 -0500
Date: Mon, 5 Nov 2007 08:41:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [git Patch] Makefile: Remove ncscope.out when make mrproper
Message-ID: <20071105074137.GA26540@uranus.ravnborg.org>
References: <20071105073233.GC2461@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105073233.GC2461@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 03:32:33PM +0800, WANG Cong wrote:
> 
> Hi, Sam!
> 
> This patch adds the ncscope.out file into cleaning targets of 'make mrproper'.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> 
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/Makefile
> ===================================================================
> --- linux-2.6.orig/Makefile
> +++ linux-2.6/Makefile
> @@ -1073,7 +1073,7 @@ MRPROPER_DIRS  += include/config include
>  MRPROPER_FILES += .config .config.old include/asm .version .old_version \
>                    include/linux/autoconf.h include/linux/version.h      \
>                    include/linux/utsrelease.h                            \
> -		  Module.symvers tags TAGS cscope*
> +		  Module.symvers tags TAGS cscope* ncscope.out

Hi WANG.

ncscope.out is just a temporary file but I see why you like to have it covered.
How about modifying the rule to look like this:
> -		  Module.symvers tags TAGS cscope*
> +		  Module.symvers tags TAGS *cscope*

Or is this to broad a pattern?

	Sam
