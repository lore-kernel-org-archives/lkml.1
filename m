Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbXF2I5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbXF2I5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXF2I4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:56:55 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:55014 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbXF2I4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:56:54 -0400
Date: Fri, 29 Jun 2007 10:58:01 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>
Message-ID: <20070629085801.GH13886@enneenne.com>
References: <20070628103619.GW13886@enneenne.com> <989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net> <20070628141205.GA13886@enneenne.com> <200706281453.23414.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706281453.23414.david-b@pacbell.net>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] PXA27x UDC driver.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 02:53:22PM -0700, David Brownell wrote:
> 
> Let's start with *JUST* a driver, not trying to update everything
> else in the USB Gadget stack so that it looks like it's designed
> specifically to handle all of Intel's design botches related to
> endpoint config ... and work worse for essentially everything else.
> 
> (Unlike pretty much every other vendor, Intel wanted hardware config
> management.  It was unusably buggy in pxa21x/25x/26x, and not much
> better in pxa27x.)
> 
> 
> So in technical terms, and to repeat what I've said before:  just
> configure it to act more like a PXA 25x chip (no altsettings) and
> get it so it passes all the tests [1], modulo errata which have no
> workarounds ... then submit that.  No epautoconfig updates, no
> patches to every gadget driver to cope with updated autoconfig.

This looks interesting... as you alredy told this driver derives from
an older one, I just maintained it till now.

If I well understand I should remove usb_ep_autoconfig() and program
into the controller only one (the default) configuration. Is that
right?

Currently I tested the driver only with ether gadget, but if I do as
above, should I get the driver working with all gadgets automagically?
:)

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
