Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbXGOXaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbXGOXaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbXGOXaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:30:12 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:54232 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXGOXaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:30:10 -0400
Date: Sun, 15 Jul 2007 19:30:07 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: Re: [PATCH] Text Edit Lock - Architecture Independent Code - kerneldoc
Message-ID: <20070715233007.GA22428@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012411.845928928@polymtl.ca> <20070715012807.GA23209@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070715012807.GA23209@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:29:43 up 8 days, 13:34,  3 users,  load average: 1.72, 0.70, 0.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please drop. Will be replaced by 
text-edit-lock-architecture-independent-code-kerneldoc-implementation.patch

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Text Edit Lock - Architecture Independent Code - kerneldoc
> 
> Add kerneldoc to text edit lock API.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: hch@infradead.org
> ---
>  include/linux/memory.h |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-lttng/include/linux/memory.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/memory.h	2007-07-14 20:08:50.000000000 -0400
> +++ linux-2.6-lttng/include/linux/memory.h	2007-07-14 20:18:13.000000000 -0400
> @@ -86,11 +86,24 @@ extern int remove_memory_block(unsigned 
>  	register_memory_notifier(&fn##_mem_nb);			\
>  }
>  
> -/*
> - * Take and release the kernel text modification lock, used for code patching.
> +/**
> + * kernel_text_lock     -   Take the kernel text modification lock
> + *
> + * Insures mutual write exclusion of kernel and modules text live text
> + * modification. Should be used for code patching.
>   * Users of this lock can sleep.
>   */
> +
>  extern void kernel_text_lock(void);
> +
> +/**
> + * kernel_text_unlock   -   Release the kernel text modification lock
> + *
> + * Insures mutual write exclusion of kernel and modules text live text
> + * modification. Should be used for code patching.
> + * Users of this lock can sleep.
> + */
> +
>  extern void kernel_text_unlock(void);
>  
>  #endif /* _LINUX_MEMORY_H_ */
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
