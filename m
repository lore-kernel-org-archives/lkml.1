Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbXJXPiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbXJXPiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbXJXPiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:38:14 -0400
Received: from xenotime.net ([66.160.160.81]:54749 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752889AbXJXPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:38:13 -0400
Date: Wed, 24 Oct 2007 08:38:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] bitops kernel-doc: expand macro
Message-Id: <20071024083811.661051f0.rdunlap@xenotime.net>
In-Reply-To: <200710241800.19764.nickpiggin@yahoo.com.au>
References: <20071023220959.a359d57d.rdunlap@xenotime.net>
	<200710241800.19764.nickpiggin@yahoo.com.au>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:00:19 +1000 Nick Piggin wrote:

> On Wednesday 24 October 2007 15:09, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > Can we expand this macro definition, or should I look for a way to
> > fool^W teach kernel-doc about this?
> >
> > scripts/kernel-doc says:
> > Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand
> > prototype: 'test_and_set_bit_lock test_and_set_bit '
> 
> Actually, it probably looks a bit nicer like this anyway. If you grep
> for it, then you can actually see the parameters...
> 
> On third thoughts, an inline function might be the best thing to do,
> and also avoid setting a bad example. What do you think?

That's probably best, yes.
Would you do the honors?


> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  include/asm-x86/bitops_32.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- linux-2.6.24-rc1.orig/include/asm-x86/bitops_32.h
> > +++ linux-2.6.24-rc1/include/asm-x86/bitops_32.h
> > @@ -185,7 +185,7 @@ static inline int test_and_set_bit(int n
> >   *
> >   * This is the same as test_and_set_bit on x86
> >   */
> > -#define test_and_set_bit_lock test_and_set_bit
> > +#define test_and_set_bit_lock(nr, addr) test_and_set_bit(nr, addr)
> >
> >  /**
> >   * __test_and_set_bit - Set a bit and return its old value
> > ---


---
~Randy
