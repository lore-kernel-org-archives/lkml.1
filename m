Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0CKOm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:42:56 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:45517 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab0CKOmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:42:54 -0500
Date: Thu, 11 Mar 2010 15:42:43 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [PATCH] MEMORY MANAGEMENT: Remove deprecated memclear_highpage_flush().
Message-ID: <20100311144243.GA28203@cmpxchg.org>
References: <alpine.LFD.2.00.1003110847220.6408@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003110847220.6408@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 08:49:21AM -0500, Robert P. J. Day wrote:
> 
> Since this routine is all of static, deprecated and unreferenced, it
> seems safe to delete it.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 74152c0..c77f913 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -173,12 +173,6 @@ static inline void zero_user(struct page *page,
>  	zero_user_segments(page, start, start + size, 0, 0);
>  }
> 
> -static inline void __deprecated memclear_highpage_flush(struct page *page,
> -			unsigned int offset, unsigned int size)
> -{
> -	zero_user(page, offset, size);
> -}
> -
>  #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
> 
>  static inline void copy_user_highpage(struct page *to, struct page *from,
> 
> ========================================================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
> 
>             Linux Consulting, Training and Kernel Pedantry.
> 
> Web page:                                          http://crashcourse.ca
> Twitter:                                       http://twitter.com/rpjday
> ========================================================================
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
