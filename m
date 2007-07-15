Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbXGOXar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbXGOXar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbXGOXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:30:37 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:54294 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbXGOXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:30:36 -0400
Date: Sun, 15 Jul 2007 19:30:35 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: Re: [PATCH] Text Edit Lock - i386 kerneldoc
Message-ID: <20070715233035.GB22428@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.380213021@polymtl.ca> <20070714233108.GI18674@Krystal> <20070715012905.GB23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715012905.GB23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:30:22 up 8 days, 13:35,  3 users,  load average: 0.88, 0.61, 0.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please drop, will be replaced by
text-edit-lock-i386-kerneldoc-implementation.patch

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Text Edit Lock - i386 kerneldoc
> 
> Add kerneldoc to text edit lock i386 API.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: hch@infradead.org
> ---
>  include/asm-i386/cacheflush.h |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/asm-i386/cacheflush.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-i386/cacheflush.h	2007-07-14 20:23:01.000000000 -0400
> +++ linux-2.6-lttng/include/asm-i386/cacheflush.h	2007-07-14 20:24:17.000000000 -0400
> @@ -35,8 +35,25 @@ void kernel_map_pages(struct page *page,
>  #ifdef CONFIG_DEBUG_RODATA
>  void mark_rodata_ro(void);
>  
> -/* mark kernel text pages writable */
> +/**
> + * kernel_text_mark_rw  -   Mark kernel text RW
> + * @address:                location of the code
> + * @len:                    size of code to mark
> + *
> + * Mark the kernel text pages writable so they can safely written to. This is
> + * useful for code patching.
> +*/
> +
>  extern void kernel_text_mark_rw(unsigned long address, size_t len);
> +
> +/**
> + * kernel_text_unmark  -    Mark kernel text back to its original flags
> + * @address:                location of the code
> + * @len:                    size of code to mark
> + *
> + * Mark the kernel text back to its original flags.
> + */
> +
>  extern void kernel_text_unmark(unsigned long address, size_t len);
>  #else
>  static inline void kernel_text_mark_rw(unsigned long address, size_t len) { }
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
