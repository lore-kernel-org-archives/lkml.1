Return-Path: <linux-kernel-owner+w=401wt.eu-S965708AbXAZQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708AbXAZQBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXAZQBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:01:32 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:42543 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965708AbXAZQBb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:01:31 -0500
Date: Fri, 26 Jan 2007 11:01:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 00/09] atomic.h : standardizing atomic primitives
Message-ID: <20070126160124.GA26138@Krystal>
References: <11697417541743-git-send-email-mathieu.desnoyers@polymtl.ca> <1169806002.6189.94.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1169806002.6189.94.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 10:59:56 up 156 days, 13:07,  4 users,  load average: 1.85, 2.80, 2.82
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Thu, 2007-01-25 at 11:15 -0500, Mathieu Desnoyers wrote:
> > atomic.h : standardizing atomic primitives
> > 
> > It mainly adds support for missing 64 bits cmpxchg and 64 bits atomic add
> > unless. Therefore, principally 64 bits architectures are targeted by these
> > patches. It also adds the complete list of atomic operations on the atomic_long
> > type.
> > 
> > These patches apply on 2.6.20-rc5-git4.
> 
> ARCH=um SUBARCH=i386
> 
> In file included from include2/asm/arch/atomic.h:257,
>                  from include2/asm/atomic.h:10,
>                  from /usr/src/linux-2.6-git/include/linux/file.h:9,
>                  from /usr/src/linux-2.6-git/mm/fadvise.c:12:
> /usr/src/linux-2.6-git/include/asm-generic/atomic.h: In function ‘atomic_long_add_unless’:
> /usr/src/linux-2.6-git/include/asm-generic/atomic.h:260: warning: implicit declaration of function ‘cmpxchg’
> /usr/src/linux-2.6-git/include/asm-generic/atomic.h: In function ‘atomic_long_xchg’:
> /usr/src/linux-2.6-git/include/asm-generic/atomic.h:281: warning: implicit declaration of function ‘xchg’
> 
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/include/asm-um/atomic.h b/include/asm-um/atomic.h
> index b683f10..b2766b0 100644
> --- a/include/asm-um/atomic.h
> +++ b/include/asm-um/atomic.h
> @@ -6,6 +6,7 @@ #define __UM_ATOMIC_H
>   */
>  #include "linux/kernel.h"
>  
> +#include "asm/arch/system.h"
>  #include "asm/arch/atomic.h"
>  
>  #endif
> 
> 

Thanks for the fix,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
