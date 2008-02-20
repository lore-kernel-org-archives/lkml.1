Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbYBTWG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbYBTWG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYBTWGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:06:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46693 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759906AbYBTWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:06:02 -0500
Date: Wed, 20 Feb 2008 23:06:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: gorcunov@gmail.com
Cc: takata@linux-m32r.org, dhowells@redhat.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] s390: cleanup - drop .data.idt section in vmlinux.lds script
Message-ID: <20080220220613.GC22382@uranus.ravnborg.org>
References: <20080220194123.114692303@gmail.com> <20080220194444.348896940@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220194444.348896940@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:41:26PM +0300, gorcunov@gmail.com wrote:
> The section .data.idt is not used at all - so drop it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
> 
>  vmlinux.lds.S |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: linux-2.6.git/arch/s390/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6.git.orig/arch/s390/kernel/vmlinux.lds.S	2008-02-06 23:15:14.000000000 +0300
> +++ linux-2.6.git/arch/s390/kernel/vmlinux.lds.S	2008-02-20 22:30:30.000000000 +0300
> @@ -71,11 +71,6 @@ SECTIONS
>  	. = ALIGN(PAGE_SIZE);
>  	__nosave_end = .;
>  
> -	. = ALIGN(PAGE_SIZE);
> -	.data.page_aligned : {
> -		*(.data.idt)
> -	}
> -
>  	. = ALIGN(0x100);
>  	.data.cacheline_aligned : {
>  		*(.data.cacheline_aligned)
> 
> -- 
