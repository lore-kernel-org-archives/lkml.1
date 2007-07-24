Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbXGXXM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbXGXXM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbXGXXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:12:15 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:53077 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760961AbXGXXMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:12:13 -0400
Date: Wed, 25 Jul 2007 00:11:57 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2.6.23-rc1] dma_free_coherent() needs irqs enabled (sigh)
Message-ID: <20070724231157.GA30861@flint.arm.linux.org.uk>
References: <200707241429.05615.david-b@pacbell.net> <20070724220738.GD22165@flint.arm.linux.org.uk> <200707241608.12198.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707241608.12198.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 04:08:11PM -0700, David Brownell wrote:
> On Tuesday 24 July 2007, Russell King wrote:
> > On Tue, Jul 24, 2007 at 02:29:05PM -0700, David Brownell wrote:
> > > On at least ARM (and I'm told MIPS too) dma_free_coherent() has a newish
> > > call context requirement:  unlike its dma_alloc_coherent() sibling, it
> > > may not be called with IRQs disabled.  (This was new behavior on ARM as
> > > of late 2006, caused by ARM SMP updates.)
> > 
> > I think you got the year wrong:
> > 
> > 5edf71ae (Russell King      2005-11-25 15:52:51 +0000 364)      WARN_ON(irqs_disabled());
> > 
> > which is due to this commit:
> > 
> > [ARM] Do not call flush_tlb_kernel_range() with IRQs disabled.
> 
> This little "to do" list item has been sitting in my mailbox way
> too long then.  Certainly since it was fair to say "last year"!  ;)

Are you intentionally not reading what I said?

> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Thanks...

That was part of the commit I quoted, not an endorsement of your patch,
though I think it does deserve an:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
