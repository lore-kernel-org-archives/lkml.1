Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbXJCReq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbXJCReq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbXJCRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:34:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49587 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbXJCRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:34:38 -0400
Date: Wed, 3 Oct 2007 10:32:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] DOC:  Correct explanations of "find_next" bit routines.
Message-Id: <20071003103213.a1a94e70.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0710030916410.27061@localhost.localdomain>
References: <Pine.LNX.4.64.0710030916410.27061@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 09:18:39 -0400 (EDT) Robert P. J. Day wrote:

> 
> Correct the obvious "copy and paste" errors explaining some of the
> "find_next" routines.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> 
>  arch/i386/lib/bitops.c    |    2 +-
>  arch/x86_64/lib/bitops.c  |    2 +-
>  include/asm-i386/bitops.h |    5 ++---
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/i386/lib/bitops.c b/arch/i386/lib/bitops.c
> index afd0045..b654404 100644
> --- a/arch/i386/lib/bitops.c
> +++ b/arch/i386/lib/bitops.c
> @@ -2,7 +2,7 @@
>  #include <linux/module.h>
> 
>  /**
> - * find_next_bit - find the first set bit in a memory region
> + * find_next_bit - find the next set bit in a memory region
>   * @addr: The address to base the search on
>   * @offset: The bitnumber to start searching at
>   * @size: The maximum size to search
> diff --git a/arch/x86_64/lib/bitops.c b/arch/x86_64/lib/bitops.c
> index 95b6d96..0e8f491 100644
> --- a/arch/x86_64/lib/bitops.c
> +++ b/arch/x86_64/lib/bitops.c
> @@ -58,7 +58,7 @@ long find_first_zero_bit(const unsigned long * addr, unsigned long size)
>  }
> 
>  /**
> - * find_next_zero_bit - find the first zero bit in a memory region
> + * find_next_zero_bit - find the next zero bit in a memory region
>   * @addr: The address to base the search on
>   * @offset: The bitnumber to start searching at
>   * @size: The maximum size to search
> diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
> index a20fe98..700b1a2 100644
> --- a/include/asm-i386/bitops.h
> +++ b/include/asm-i386/bitops.h
> @@ -1,4 +1,3 @@
> -#ifndef _I386_BITOPS_H
>  #define _I386_BITOPS_H
> 
>  /*
> @@ -297,7 +296,7 @@ static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
>  }
> 
>  /**
> - * find_next_zero_bit - find the first zero bit in a memory region
> + * find_next_zero_bit - find the next zero bit in a memory region
>   * @addr: The address to base the search on
>   * @offset: The bitnumber to start searching at
>   * @size: The maximum size to search
> @@ -340,7 +339,7 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
>  }
> 
>  /**
> - * find_next_bit - find the first set bit in a memory region
> + * find_next_bit - find the next set bit in a memory region
>   * @addr: The address to base the search on
>   * @offset: The bitnumber to start searching at
>   * @size: The maximum size to search
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://crashcourse.ca
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
