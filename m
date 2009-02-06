Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZBFJLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZBFJLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZBFJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:11:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44667 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZBFJLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:11:20 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [linux-next][PATCH] revert headers_check fix: ia64, fpu.h
Cc: kosaki.motohiro@jp.fujitsu.com,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <3f9a31f40902060053x18dacf58u40c739ab89f13860@mail.gmail.com>
References: <20090206164546.6291.KOSAKI.MOTOHIRO@jp.fujitsu.com> <3f9a31f40902060053x18dacf58u40c739ab89f13860@mail.gmail.com>
Message-Id: <20090206180957.6294.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  6 Feb 2009 18:11:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: b/arch/ia64/include/asm/fpu.h
> > ===================================================================
> > --- a/arch/ia64/include/asm/fpu.h
> > +++ b/arch/ia64/include/asm/fpu.h
> > @@ -6,7 +6,7 @@
> >  *     David Mosberger-Tang <davidm@hpl.hp.com>
> >  */
> >
> > -#include <linux/types.h>
> > +#include <asm/types.h>
> >
> 
> No , we do not even need asm/types.h
> 
> Subject: [PATCH] Neither asm/types.h nor linux/types.h is not required
> for arch/ia64/include/asm/fpu.h
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

ok. I confirmed.
	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

thanks.


> ---
>  arch/ia64/include/asm/fpu.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/fpu.h b/arch/ia64/include/asm/fpu.h
> index b6395ad..0c26157 100644
> --- a/arch/ia64/include/asm/fpu.h
> +++ b/arch/ia64/include/asm/fpu.h
> @@ -6,8 +6,6 @@
>   *     David Mosberger-Tang <davidm@hpl.hp.com>
>   */
> 
> -#include <linux/types.h>
> -
>  /* floating point status register: */
>  #define FPSR_TRAP_VD   (1 << 0)        /* invalid op trap disabled */
>  #define FPSR_TRAP_DD   (1 << 1)        /* denormal trap disabled */
> -- 
> 1.6.1.1



