Return-Path: <linux-kernel-owner+w=401wt.eu-S934737AbYBTWFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934737AbYBTWFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760966AbYBTWFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:05:32 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48349 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253AbYBTWFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:05:31 -0500
Date: Wed, 20 Feb 2008 23:05:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: gorcunov@gmail.com
Cc: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mn10300: cleanup - drop .data.idt section in vmlinux.lds script
Message-ID: <20080220220542.GB22382@uranus.ravnborg.org>
References: <20080220194123.114692303@gmail.com> <20080220194444.018019215@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220194444.018019215@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:41:25PM +0300, gorcunov@gmail.com wrote:
> The section .data.idt is not used at all - so drop it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
>  vmlinux.lds.S |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: linux-2.6.git/arch/mn10300/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6.git.orig/arch/mn10300/kernel/vmlinux.lds.S	2008-02-10 10:46:37.000000000 +0300
> +++ linux-2.6.git/arch/mn10300/kernel/vmlinux.lds.S	2008-02-20 22:26:01.000000000 +0300
> @@ -61,9 +61,6 @@ SECTIONS
>    . = ALIGN(4096);
>    __nosave_end = .;
>  
> -  . = ALIGN(4096);
> -  .data.page_aligned : { *(.data.idt) }
> -
>    . = ALIGN(32);
>    .data.cacheline_aligned : { *(.data.cacheline_aligned) }
>  
> 
> -- 
