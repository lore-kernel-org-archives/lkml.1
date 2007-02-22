Return-Path: <linux-kernel-owner+w=401wt.eu-S1751763AbXBVSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbXBVSf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXBVSf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:35:59 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41215 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763AbXBVSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:35:58 -0500
Date: Thu, 22 Feb 2007 19:35:57 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: add -freg-struct-return to CFLAGS
Message-ID: <20070222183557.GC8603@stusta.de>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222083822.GB15068@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222083822.GB15068@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 09:38:22AM +0100, Ingo Molnar wrote:
>...
> --- linux.orig/arch/i386/Makefile
> +++ linux/arch/i386/Makefile
> @@ -31,7 +31,7 @@ LDFLAGS_vmlinux := --emit-relocs
>  endif
>  CHECKFLAGS	+= -D__i386__
>  
> -CFLAGS += -pipe -msoft-float -mregparm=3
> +CFLAGS += -pipe -msoft-float -mregparm=3 -freg-struct-return
>  
>  # prevent gcc from keeping the stack 16 byte aligned
>  CFLAGS += $(call cc-option,-mpreferred-stack-boundary=2)

Why is this i386 specific?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

