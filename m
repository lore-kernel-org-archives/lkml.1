Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbXGOXbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbXGOXbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbXGOXax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:30:53 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:54334 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958AbXGOXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:30:52 -0400
Date: Sun, 15 Jul 2007 19:30:50 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, hch@infradead.org
Subject: Re: [PATCH] Text Edit Lock - x86_64 kerneldoc
Message-ID: <20070715233050.GC22428@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012412.960272115@polymtl.ca> <20070714233201.GJ18674@Krystal> <20070715013014.GC23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715013014.GC23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:30:37 up 8 days, 13:35,  3 users,  load average: 0.84, 0.61, 0.31
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please drop, will be replaced by
text-edit-lock-x86_64-kerneldoc-implementation.patch

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Text Edit Lock - x86_64 kerneldoc
> 
> Add kerneldoc to text edit lock x86_64 API.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: hch@infradead.org
> ---
>  include/asm-x86_64/cacheflush.h |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/asm-x86_64/cacheflush.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-x86_64/cacheflush.h	2007-07-14 20:25:49.000000000 -0400
> +++ linux-2.6-lttng/include/asm-x86_64/cacheflush.h	2007-07-14 20:25:50.000000000 -0400
> @@ -32,8 +32,25 @@ void clflush_cache_range(void *addr, int
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
