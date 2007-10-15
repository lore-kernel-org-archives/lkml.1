Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbXJOV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbXJOV6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756968AbXJOV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:58:35 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:38786 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXJOV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:58:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j0PaUbJJ8Y7GtmoH4G9JEfgfKENf64upwIPc8EvQaXgxcyncgtQxMiVCL9FIHMKUVzaY8Mpdyd4aeZfwf6eFOe4z6qp1SI7XM0Yl6cDuRPrMFPYGBoZavmoAz8yz+qItNsask8dLwKRXh6ZfUwcQNtOj0FevRA8fWsdHeVbOFP0=
Message-ID: <9a8748490710151458o73267df1tcfb35fb5ae71d598@mail.gmail.com>
Date: Mon, 15 Oct 2007 23:58:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH 04/12] Clean up duplicate includes in arch/i386/xen/
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Keir Fraser" <keir@xensource.com>, "Stable Kernel" <stable@kernel.org>
In-Reply-To: <20071015210114.891237072@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015204840.074767068@goop.org>
	 <20071015210114.891237072@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2007, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> This patch cleans up duplicate includes in
>         arch/i386/xen/
>

Just for the record; this patch is
From: Jesper Juhl <jesper.juhl@gmail.com>

> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  arch/x86/xen/enlighten.c |    1 -
>  arch/x86/xen/mmu.c       |    2 --
>  2 files changed, 3 deletions(-)
>
> ===================================================================
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -25,7 +25,6 @@
>  #include <linux/mm.h>
>  #include <linux/page-flags.h>
>  #include <linux/highmem.h>
> -#include <linux/smp.h>
>
>  #include <xen/interface/xen.h>
>  #include <xen/interface/physdev.h>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 4ae038a..35691a2 100644
> ===================================================================
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -41,7 +41,6 @@
>  #include <linux/sched.h>
>  #include <linux/highmem.h>
>  #include <linux/bug.h>
> -#include <linux/sched.h>
>
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
