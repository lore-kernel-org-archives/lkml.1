Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXEJATp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXEJATp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbXEJATi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:19:38 -0400
Received: from ozlabs.org ([203.10.76.45]:33164 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbXEJATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:19:37 -0400
Subject: Re: [patch 5/9] lguest: the Makefile and Kconfig
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, ak@suse.de
In-Reply-To: <20070509204725.GB10336@uranus.ravnborg.org>
References: <200705090951.l499pb6H020400@shell0.pdx.osdl.net>
	 <20070509204725.GB10336@uranus.ravnborg.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 10:19:35 +1000
Message-Id: <1178756375.7286.178.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 22:47 +0200, Sam Ravnborg wrote:
> > diff -puN /dev/null drivers/lguest/Makefile
> > --- /dev/null
> > +++ a/drivers/lguest/Makefile
> > @@ -0,0 +1,7 @@
> > +# Guest requires the paravirt_ops replacement and the bus driver.
> > +obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
> > +
> > +# Host requires the other files, which can be a module.
> > +obj-$(CONFIG_LGUEST)	+= lg.o
> > +lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
> > +	segments.o io.o lguest_user.o switcher.o
> Please use: lg-y :=
> Using -objs is no longer preferred.

Hi Sam!

	Thanks, will patch.

Cheers,
Rusty.

