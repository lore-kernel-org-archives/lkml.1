Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYFBXqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYFBXqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYFBXqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:46:11 -0400
Received: from ozlabs.org ([203.10.76.45]:43565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYFBXqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:46:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] mm: fix comment formatting in asm-generic/pgtable.h:__ptep_modify_prot_
Date: Tue, 3 Jun 2008 09:45:59 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <patchbomb.1212192268@localhost> <20080602111339.GB18586@elte.hu> <4843EF6A.20305@goop.org>
In-Reply-To: <4843EF6A.20305@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806030946.00434.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 23:02:34 Jeremy Fitzhardinge wrote:
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  include/asm-generic/pgtable.h |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> ===================================================================
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -201,9 +201,11 @@
>  					     unsigned long addr,
>  					     pte_t *ptep)
>  {
> -	/* Get the current pte state, but zero it out to make it
> -	   non-present, preventing the hardware from asynchronously
> -	   updating it. */
> +	/*
> +	 * Get the current pte state, but zero it out to make it
> +	 * non-present, preventing the hardware from asynchronously
> +	 * updating it.
> +	 */

Since there is debate over whether winged comments are a feature, I'm not sure 
this can be termed a "fix".

>  {
> -	/* The pte is non-present, so there's no hardware state to
> -	   preserve. */
> +	/*
> +	 * The pte is non-present, so there's no hardware state to
> +	 * preserve.
> +	 */
>  	set_pte_at(mm, addr, ptep, pte);
>  }

This will fit in one line, no? 

Rusty.
