Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYAEVJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYAEVJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbYAEVJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:09:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47316 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbYAEVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:09:34 -0500
Date: Sat, 5 Jan 2008 21:09:17 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Can ARM use drivers/Kconfig [Was: Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm]
Message-ID: <20080105210917.GC7797@flint.arm.linux.org.uk>
References: <200801051546.SAA08953@raad.intranet> <20080105192000.GA9553@uranus.ravnborg.org> <20080105203123.GA7797@flint.arm.linux.org.uk> <20080105205424.GA10191@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105205424.GA10191@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 09:54:24PM +0100, Sam Ravnborg wrote:
> On Sat, Jan 05, 2008 at 08:31:24PM +0000, Russell King wrote:
> > Not everything in drivers/ is suitable for every ARM configuration.  It
> > was felt at the time better for ARM to remain separate because people
> > didn't want to pollute drivers/Kconfig with the ARM specific conditionals.
> > 
> Today we would have used HAVE_ for the problematic parts and thus
> it would have been easy to not select what ARM does not support.
> But unfortunately thats not how it got designed.
> 
> 
> It would be nice to revist one day to see how much is actually needed
> to cleanly supprt ARM in drivers/Kconfig.

You could diff the two Kconfig files - I try to keep them so they list
the same Kconfigs in the same order to keep the diff size down.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
