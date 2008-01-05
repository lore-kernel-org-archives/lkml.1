Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYAEUbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYAEUbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYAEUbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:31:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36098 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbYAEUbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:31:40 -0500
Date: Sat, 5 Jan 2008 20:31:24 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Can ARM use drivers/Kconfig [Was: Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm]
Message-ID: <20080105203123.GA7797@flint.arm.linux.org.uk>
References: <200801051546.SAA08953@raad.intranet> <20080105192000.GA9553@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105192000.GA9553@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 08:20:00PM +0100, Sam Ravnborg wrote:
> On Sat, Jan 05, 2008 at 06:42:52PM +0300, Al Boldi wrote:
> > 
> > From: David Brownell <david-b@pacbell.net>
> > 
> > Source "drivers/usb/gadget/Kconfig" for ARCH=arm.
> > 
> > 
> > Cc: David Brownell <david-b@pacbell.net>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Al Boldi <a1426z@gawab.com>
> > 
> > ---
> > 
> > --- 23.a/arch/arm/Kconfig
> > +++ 23.b/arch/arm/Kconfig
> > @@ -1049,6 +1049,8 @@ source "drivers/hid/Kconfig"
> >  
> >  source "drivers/usb/Kconfig"
> >  
> > +source "drivers/usb/gadget/Kconfig"
> > +
> >  source "drivers/mmc/Kconfig"
> >  
> >  source "drivers/rtc/Kconfig"
> 
> What is preventing ARM from using drivers/Kconfig?
> That a better fix IMO.

Not everything in drivers/ is suitable for every ARM configuration.  It
was felt at the time better for ARM to remain separate because people
didn't want to pollute drivers/Kconfig with the ARM specific conditionals.

(mtd is conditional because it's not supported on ARM CPUs without
alignment trap support.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
