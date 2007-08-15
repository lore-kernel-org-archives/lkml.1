Return-Path: <linux-kernel-owner+w=401wt.eu-S965248AbXHOXo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbXHOXo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbXHOXor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:44:47 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4950 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964917AbXHOXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:44:46 -0400
Date: Thu, 16 Aug 2007 07:44:34 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: Andi Kleen <ak@suse.de>, sebastian@breakpoint.cc,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations already do.
Message-ID: <20070815234434.GC28775@gondor.apana.org.au>
References: <E1ILEQ8-0005H5-00@gondolin.me.apana.org.au> <46C3319F.4050809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C3319F.4050809@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 01:02:23PM -0400, Chris Snook wrote:
> Herbert Xu wrote:
> >Andi Kleen <ak@suse.de> wrote:
> >>>My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
> >>>  text    data     bss     dec     hex filename
> >>>3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
> >>>3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux
> >>What is the difference between atomic_normal and atomic_inlineasm? 
> >
> >The inline asm stops certain optimisations from occuring.
> >
> >I'm still unconvinced why we need this because nobody has
> >brought up any examples of kernel code that legitimately
> >need this.
> 
> There's plenty of kernel code that *wants* this though.  If we can 

You keep saying this yet everytime I ask for an example I
get nothing.

> reduce the need for register-clobbering barriers, shrink our binaries, 
> shrink our code, improve performance, and avoid heisenbugs, I think it's 
> a win, whether or not we *need* it.

Hmm, you're increasing our binary size and probably killing
performance.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
