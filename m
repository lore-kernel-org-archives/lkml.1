Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbXJRRGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbXJRRGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763773AbXJRRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:06:12 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:39124 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbXJRRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:06:11 -0400
Date: Thu, 18 Oct 2007 19:06:09 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Nick Piggin <npiggin@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
In-Reply-To: <20071017122435.GA14401@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0710181904540.29362@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz>
 <20071015143732.01d99af8@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz>
 <20071016002229.GA5851@wotan.suse.de> <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz>
 <20071016222921.GA29378@wotan.suse.de> <Pine.LNX.4.64.0710170049450.19210@artax.karlin.mff.cuni.cz>
 <20071016232153.GC29378@wotan.suse.de> <Pine.LNX.4.64.0710170212090.15954@artax.karlin.mff.cuni.cz>
 <20071017122435.GA14401@wotan.suse.de>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > You already must not place any data structures into WC memory --- for 
> > > > example, spinlocks wouldn't work there.
> > > 
> > > What do you mean "already"?
> > 
> > I mean "in current kernel" (I checked it in 2.6.22)
> 
> Ahh, that's not "current kernel", though ;)
> 
> 4071c718555d955a35e9651f77086096ad87d498
>
> > So drivers can't assume that wmb() works on write-combining memory.
> 
> Drivers should be able to assume that wmb() orders _everything_ (except
> some whacky Altix thing, which I really want to fold under wmb at some
> point anyway).
> 
> So I decided that old x86 semantics isn't right, and now it really is a
> lock op / sfence everywhere.

I see. I'm just curious --- is there any real usage for WC memory, except 
graphics card memory?

Mikulas
