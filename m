Return-Path: <linux-kernel-owner+w=401wt.eu-S1762395AbYBPAYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395AbYBPAYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYBPAYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:24:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45413 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbYBPAYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:24:07 -0500
Date: Sat, 16 Feb 2008 00:17:12 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080216001712.GE31474@flint.arm.linux.org.uk>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
	torvalds@linux-foundation.org, jeff@garzik.org, davem@davemloft.net,
	arjan@infradead.org, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org
References: <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org> <20080212191552.GA20883@kroah.com> <alpine.LFD.1.00.0802121133210.2920@woody.linux-foundation.org> <20080212204813.GA21650@kroah.com> <20080215232308.GC31474@flint.arm.linux.org.uk> <20080215153732.a93caec7.akpm@linux-foundation.org> <20080215154724.132ad4f3.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215154724.132ad4f3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 03:47:24PM -0800, Randy Dunlap wrote:
> On Fri, 15 Feb 2008 15:37:32 -0800 Andrew Morton wrote:
> > I wonder why I didn't see any of this - I build arm allmodconfig at least
> > once a week, usually more frequently.

Basically, you don't build any of the PXA platforms, which is what was
affected.

> > So either the offending patches weren't in my pile or arm allmodconfig is
> > worse than I thought :(
> > 
> > It really is in arch maintainers' best interest to keep their allmodconfig
> > in good shape, for this reason.  arm's _isn't_ in good shape: the compile
> > fails for several long-standing reasons (eg: no hope of building DRM) and I
> > don't think the coverage is very broad either.
> 
> I think that Russell has said that allmodconfig isn't very realistic
> for ARM, with its 70+ config files.  Nevertheless, having a usable
> allmodconfig would be very helpful.

Which is quite impossible.  I've said all along that all*config is bad
news for ARM and folk haven't listened.

allmodconfig can (and does) work on some platform configurations such as
the one Andrew builds - which will be based on the Versatile platform.
However, that doesn't get _any_ of the PXA SoC drivers scattered throughout
the tree, the PXA SoC support in arch/arm/mach-pxa, none of the PXA platform
support files.

If you built an allmodconfig PXA configuration, you'd get those, but you
wouldn't get the OMAP SoC drivers, nor the ARM Primecell drivers found on
ARMs Integrator, Versatile and Realview platforms and the Cirrus EP93xx
SoCs.  Nor the Atmel AT91 drivers... and so the list goes on.

Each family of platforms are, unfortunately, quite distinct from each
other.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
