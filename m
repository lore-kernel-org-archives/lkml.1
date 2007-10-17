Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXJQVnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXJQVnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbXJQVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:42:57 -0400
Received: from www.tglx.de ([62.245.132.106]:50579 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbXJQVm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:42:57 -0400
Date: Wed, 17 Oct 2007 23:42:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Introduce "used_vectors" bitmap which can be used
 to reserve vectors.
In-Reply-To: <20071017143536.f4e7cba1.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0710172341110.24155@localhost.localdomain>
References: <200710172046.55454.rusty@rustcorp.com.au> <200710172052.47230.rusty@rustcorp.com.au> <200710172054.45652.rusty@rustcorp.com.au> <200710172056.05123.rusty@rustcorp.com.au> <20071017143536.f4e7cba1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Andrew Morton wrote:

> On Wed, 17 Oct 2007 20:56:04 +1000
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > This simplifies the io_apic.c __assign_irq_vector() logic and removes
> > the explicit SYSCALL_VECTOR check, and also allows for vectors to be
> > reserved by other mechanisms (ie. lguest).
> 
> I already have this one as
> x86_64-mm-introduce-used_vectors-bitmap-which-can-be-used-to-reserve-vectors.patch
> - part of the firstfloor tree.
> 
> Thomas is going through those patches and is getting them merged up - a large
> batch went through today.
> 
> So I assume he'll me merging this patch via that route, unless he has
> decided to skip it for some reason.
> 
> Either way, I guess I'll hang onto the firstfloor.org leftovers until each
> one has some sort of definite disposition.

It's in the "needs review" batch and I push out a git branch with the
ones in our backlog when I'm done with picking up stuff here and there.

     tglx

