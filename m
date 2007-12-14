Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbXLNR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbXLNR7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbXLNR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:59:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41274 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbXLNR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:59:10 -0500
Date: Fri, 14 Dec 2007 09:58:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] UML - Add asm/fixmap.h include
Message-Id: <20071214095840.28736204.akpm@linux-foundation.org>
In-Reply-To: <20071214161647.GA5802@c2.user-mode-linux.org>
References: <20071214161647.GA5802@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 11:16:47 -0500 Jeff Dike <jdike@addtoit.com> wrote:

> [ This needs to go into 2.6.24, as it fixes a build breakage seen on x86_64 ]
> 
> um_uaccess.h refers to FIXADDR_USER_*, so it should include fixmap.h.
> 
> I also changed the non-UML includes to use <> instead of "".
> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> ---
>  arch/um/include/um_uaccess.h |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.22/arch/um/include/um_uaccess.h
> ===================================================================
> --- linux-2.6.22.orig/arch/um/include/um_uaccess.h	2007-12-13 10:09:22.000000000 -0500
> +++ linux-2.6.22/arch/um/include/um_uaccess.h	2007-12-13 15:11:42.000000000 -0500
> @@ -6,7 +6,8 @@
>  #ifndef __ARCH_UM_UACCESS_H
>  #define __ARCH_UM_UACCESS_H
>  
> -#include "asm/elf.h"
> +#include <asm/elf.h>
> +#include <asm/fixmap.h>
>  #include "sysdep/archsetjmp.h"
>  
>  #define __under_task_size(addr, size) \

arch/um/include/um_uaccess.h already includes fixmap.h.  Is this a -mm-only
fix?

