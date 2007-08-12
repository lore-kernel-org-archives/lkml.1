Return-Path: <linux-kernel-owner+w=401wt.eu-S934946AbXHLNgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934946AbXHLNgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763843AbXHLNf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:35:57 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:58775 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762689AbXHLNf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:35:56 -0400
Date: Sun, 12 Aug 2007 09:35:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2 build error on MIPS and ARM
Message-ID: <20070812133552.GA21643@Krystal>
References: <20070811025802.GA15885@Krystal> <1186825800.32314.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1186825800.32314.2.camel@localhost>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:35:02 up 13 days, 13:53,  2 users,  load average: 1.93, 1.52, 1.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Martin Schwidefsky (schwidefsky@de.ibm.com) wrote:
> On Fri, 2007-08-10 at 22:58 -0400, Mathieu Desnoyers wrote:
> > I got the following errors when building 2.6.23-rc2-mm2 on both mips and
> > arm. Both errors are very much alike.
> 
> That attached patch should fix it for arm and mips. I'll try a few more
> architectures until I'm fed up with compiling cross-compilers..
> 

It fixes the problem for me, thanks!

Tested-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Mathieu


> -- 
> blue skies,
>   Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> ---
> Subject: [PATCH] move mm_struct and vm_area_struct, compile fix.
> 
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Include <asm/page.h> in <linux/mm_types.h> to make mips and arm
> compile again after mm_struct and vm_area_struct have been moved.
> 
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  include/linux/mm_types.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -urpN linux-2.6/include/linux/mm_types.h
> linux-2.6-patched/include/linux/mm_types.h
> --- linux-2.6/include/linux/mm_types.h	2007-08-11 11:30:10.000000000
> +0200
> +++ linux-2.6-patched/include/linux/mm_types.h	2007-08-11
> 11:32:42.000000000 +0200
> @@ -11,6 +11,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/completion.h>
>  #include <asm/mmu.h>
> +#include <asm/page.h>
>  
>  struct address_space;
>  
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
