Return-Path: <linux-kernel-owner+w=401wt.eu-S1751580AbXBVLXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbXBVLXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXBVLXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:23:30 -0500
Received: from colin.muc.de ([193.149.48.1]:4752 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXBVLX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:23:29 -0500
Date: 22 Feb 2007 12:23:28 +0100
Date: Thu, 22 Feb 2007 12:23:28 +0100
From: Andi Kleen <ak@muc.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: add -freg-struct-return to CFLAGS
Message-ID: <20070222112328.GB10190@muc.de>
References: <45DCF1C5.4030006@goop.org> <1172131463.3531.226.camel@laptopd505.fenrus.org> <45DD4FA0.5030205@goop.org> <20070222083822.GB15068@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222083822.GB15068@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 09:38:22AM +0100, Ingo Molnar wrote:
> Subject: [patch] x86: add -freg-struct-return to CFLAGS
> From: Ingo Molnar <mingo@elte.hu>
> 
> Jeremy Fitzhardinge suggested the use of -freg-struct-return, which does 
> structure-returns (such as when using pte_t) in registers instead of on 
> the stack.
> 
> that is indeed so, and this option reduced the kernel size a bit:
> 
>     text    data     bss     dec     hex filename
>  4799506  543456 3760128 9103090  8ae6f2 vmlinux.before
>  4798117  543456 3760128 9101701  8ae185 vmlinux.after
> 
> the resulting kernel booted fine on my testbox. Lets go for it.

Ok I added it for now. Let's see what happens.

I guess people maintaining external Makefiles without Kbuild 
are in for a nasty surprise again though. Cannot be avoided unfortunately.

-Andi
