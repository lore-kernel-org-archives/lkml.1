Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYAEUyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYAEUyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYAEUy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:54:26 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50262 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbYAEUy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:54:26 -0500
Date: Sat, 5 Jan 2008 21:54:24 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Al Boldi <a1426z@gawab.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Can ARM use drivers/Kconfig [Was: Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm]
Message-ID: <20080105205424.GA10191@uranus.ravnborg.org>
References: <200801051546.SAA08953@raad.intranet> <20080105192000.GA9553@uranus.ravnborg.org> <20080105203123.GA7797@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105203123.GA7797@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 08:31:24PM +0000, Russell King wrote:
> On Sat, Jan 05, 2008 at 08:20:00PM +0100, Sam Ravnborg wrote:
> > On Sat, Jan 05, 2008 at 06:42:52PM +0300, Al Boldi wrote:
> > > 
> > > From: David Brownell <david-b@pacbell.net>
> > > 
> > > Source "drivers/usb/gadget/Kconfig" for ARCH=arm.
> > > 
> > > 
> > > Cc: David Brownell <david-b@pacbell.net>
> > > Cc: Greg KH <greg@kroah.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Al Boldi <a1426z@gawab.com>
> > > 
> > > ---
> > > 
> > > --- 23.a/arch/arm/Kconfig
> > > +++ 23.b/arch/arm/Kconfig
> > > @@ -1049,6 +1049,8 @@ source "drivers/hid/Kconfig"
> > >  
> > >  source "drivers/usb/Kconfig"
> > >  
> > > +source "drivers/usb/gadget/Kconfig"
> > > +
> > >  source "drivers/mmc/Kconfig"
> > >  
> > >  source "drivers/rtc/Kconfig"
> > 
> > What is preventing ARM from using drivers/Kconfig?
> > That a better fix IMO.
> 
> Not everything in drivers/ is suitable for every ARM configuration.  It
> was felt at the time better for ARM to remain separate because people
> didn't want to pollute drivers/Kconfig with the ARM specific conditionals.
> 
Today we would have used HAVE_ for the problematic parts and thus
it would have been easy to not select what ARM does not support.
But unfortunately thats not how it got designed.


It would be nice to revist one day to see how much is actually needed
to cleanly supprt ARM in drivers/Kconfig.

	Sam
