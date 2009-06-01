Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZFAKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZFAKoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZFAKoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:44:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38077 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbZFAKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:44:05 -0400
Date: Mon, 1 Jun 2009 11:43:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
Message-ID: <20090601104353.GA25391@flint.arm.linux.org.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <200905282104.55818.arnd@arndb.de> <20090601170847V.fujita.tomonori@lab.ntt.co.jp> <20090601082943.GA5550@flint.arm.linux.org.uk> <200906011128.10670.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011128.10670.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 11:28:09AM +0100, Arnd Bergmann wrote:
> On Monday 01 June 2009, Russell King wrote:
> > On Mon, Jun 01, 2009 at 05:08:09PM +0900, FUJITA Tomonori wrote:
> > > This adds a version of the dma-mapping API to asm-generic that can be
> > > used by most architectures that only need a linear mapping.
> > 
> > It depends what is meant by "linear mapping".
> > 
> > If that's just a way of saying "all that needs to be done for the
> > DMA streaming APIs is to flush the cache" then the vast majority of
> > ARMs fall into that category.
> 
> Right. You can probably split out the arm dma-mapping.h implementation
> into the dmabounce version and a version that falls back to my
> asm-generic code.
> 
> One feature that the arm code currently has that I'm still missing is
> highmem support, which seems to be relatively complex in arm
> (three different implementations). Not sure how to best fit that in there.

Err - there's only one highmem implementation on ARM.

Anyway, as I hinted, things in this area will most likely become more
complex in the near future, so any unification of the ARM dma-mapping
will have to be undone.

Let's wait for the ARMv7 support to mature before trying to unify too
much.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
