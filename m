Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXBEREZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXBEREZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXBEREZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:04:25 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3521 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXBEREX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:04:23 -0500
Date: Mon, 5 Feb 2007 17:04:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Message-ID: <20070205170408.GE4563@flint.arm.linux.org.uk>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	David Woodhouse <dwmw2@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205084523.GA21858@elte.hu> <1170682488.29759.795.camel@pmac.infradead.org> <20070205155627.GA8354@elte.hu> <1170692539.29759.856.camel@pmac.infradead.org> <20070205162635.GA755@elte.hu> <20070205164603.GC4563@flint.arm.linux.org.uk> <20070205165233.GA4781@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165233.GA4781@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:52:33PM +0100, Ingo Molnar wrote:
> 
> * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > and the rest (ie, except integrator, versatile and ixp4xx) has:
> > 
> > config ARCH_SHARK
> >         bool "Shark"
> >         select PCI
> > 
> > IOW, the "PCI support" question isn't offered for platforms which 
> > require PCI to be present, but is offered on platforms where it's 
> > optional.
> 
> yeah. I think this also fits into the special-case i mentioned: it isnt 
> connected to something user-selectable, it's a side-effect of the first 
> 'feature selection' the user does: 'what platform do you compile your 
> kernel on'. As such it is a convenience group-selection.
> 
> i.e. what we have behind this is still a clean tree of dependencies.

I agree 100% with that - since when that happens it's possible to
traverse the tree to tell the user what's going on.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
