Return-Path: <linux-kernel-owner+w=401wt.eu-S1765732AbYBTWFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765732AbYBTWFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbYBTWFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:05:03 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45844 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbYBTWFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:05:02 -0500
Date: Wed, 20 Feb 2008 23:05:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: gorcunov@gmail.com
Cc: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] m32r: cleanup - drop .data.idt section in vmlinux.lds script
Message-ID: <20080220220512.GA22382@uranus.ravnborg.org>
References: <20080220194123.114692303@gmail.com> <20080220194443.628830230@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220194443.628830230@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:41:24PM +0300, gorcunov@gmail.com wrote:
> The section .data.idt is not used at all - so drop it.
Only used by 32 bit x86 to be precise.

> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> 
>  vmlinux.lds.S |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: linux-2.6.git/arch/m32r/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6.git.orig/arch/m32r/kernel/vmlinux.lds.S	2008-02-10 10:46:37.000000000 +0300
> +++ linux-2.6.git/arch/m32r/kernel/vmlinux.lds.S	2008-02-20 22:23:46.000000000 +0300
> @@ -60,9 +60,6 @@ SECTIONS
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
