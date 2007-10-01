Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbXJAKks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbXJAKks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXJAKkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:40:41 -0400
Received: from ns.suse.de ([195.135.220.2]:34985 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXJAKkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:40:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] [50/50] x86_64: Remove fpu io port resource
Date: Mon, 1 Oct 2007 12:40:35 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709221231.836138000@suse.de> <20070921223251.1312913DCD@wotan.suse.de> <46F44D27.4050704@garzik.org>
In-Reply-To: <46F44D27.4050704@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011240.35802.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > ===================================================================
> > --- linux.orig/arch/x86_64/kernel/setup.c
> > +++ linux/arch/x86_64/kernel/setup.c
> > @@ -121,8 +121,6 @@ struct resource standard_io_resources[] 
> >  		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
> >  	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
> >  		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
> > -	{ .name = "fpu", .start = 0xf0, .end = 0xff,
> > -		.flags = IORESOURCE_BUSY | IORESOURCE_IO }

The patch has been dropped meanwhile BTW --  Maciej pointed
out correctly that the south bridges likely decode it anyways.

> Since we are merging x86 and x86-64, I think it would be nice at least 
> to CC Thomas on patches that increase 32/64-bit differences...  because 
> won't this patch have to be partial un-done when we merge i386 and x86-64?

So far I still maintain i386 and x86-64. If Thomas wants to take both
over completely he can do that; but I won't bother handling any patches i didn't 
write then anymore.

-Andi
