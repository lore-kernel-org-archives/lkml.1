Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYEWNnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYEWNnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYEWNnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:43:35 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:34778 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYEWNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:43:34 -0400
Date: Fri, 23 May 2008 15:43:13 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Fernando Luis Vazquez Cao <fernando@intellilink.co.jp>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       dev-etrax <dev-etrax@axis.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cris: remove unused global_flush_tlb
Message-ID: <20080523134313.GG8890@axis.com>
References: <1211524591.2719.11.camel@nausicaa.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211524591.2719.11.camel@nausicaa.intellilink.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 08:36:31AM +0200, Fernando Luis Vazquez Cao wrote:
> global_flush_tlb is declared but never used.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
> 
> diff -urNp linux-2.6.26-rc3-git4-orig/include/asm-cris/cacheflush.h linux-2.6.26-rc3-git4/include/asm-cris/cacheflush.h
> --- linux-2.6.26-rc3-git4-orig/include/asm-cris/cacheflush.h    2008-04-17 11:49:44.000000000 +0900
> +++ linux-2.6.26-rc3-git4/include/asm-cris/cacheflush.h 2008-05-23 15:19:26.000000000 +0900
> @@ -26,7 +26,6 @@
>  #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
>         memcpy(dst, src, len)
> 
> -void global_flush_tlb(void);
>  int change_page_attr(struct page *page, int numpages, pgprot_t prot);
> 
>  #endif /* _CRIS_CACHEFLUSH_H */


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
