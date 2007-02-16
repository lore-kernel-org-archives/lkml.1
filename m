Return-Path: <linux-kernel-owner+w=401wt.eu-S1946269AbXBPWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946269AbXBPWsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946287AbXBPWsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:48:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39758 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946269AbXBPWsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:48:41 -0500
Date: Fri, 16 Feb 2007 14:48:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, schwab@suse.de
Subject: Re: [PATCH] Remove stack hard limit on ia64
Message-Id: <20070216144835.711f7c54.akpm@linux-foundation.org>
In-Reply-To: <20070216220654.GA11135@aepfle.de>
References: <20070216220654.GA11135@aepfle.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 23:06:54 +0100
Olaf Hering <olaf@aepfle.de> wrote:

> From: schwab@suse.de
> 
> Un-Breaks pthreads, since Oct 2003.
> 

Oh come on, that's not a changelog.  I refuse to believe that nobody has
used pthreads on ia64 for the past three years.

> 
> Index: linux-2.6/include/asm-ia64/resource.h
> ===================================================================
> --- linux-2.6.orig/include/asm-ia64/resource.h
> +++ linux-2.6/include/asm-ia64/resource.h
> @@ -2,7 +2,6 @@
>  #define _ASM_IA64_RESOURCE_H
>  
>  #include <asm/ustack.h>
> -#define _STK_LIM_MAX	DEFAULT_USER_STACK_SIZE
>  #include <asm-generic/resource.h>
>  
>  #endif /* _ASM_IA64_RESOURCE_H */

Please provide a complete description of the problem which this patch is
fixing, and a complete description of how the patch fixes it.
