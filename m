Return-Path: <linux-kernel-owner+w=401wt.eu-S1765449AbYDYVOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765449AbYDYVOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbYDYVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:14:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60088 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbYDYVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:14:07 -0400
Date: Fri, 25 Apr 2008 22:13:43 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul Walmsley <paul@pwsan.com>, Dmitry <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       David Brownell <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080425211343.GD28893@flint.arm.linux.org.uk>
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com> <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com> <20080425103942.GC14903@elf.ucw.cz> <20080425202010.GA28893@flint.arm.linux.org.uk> <20080425205151.GA6251@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425205151.GA6251@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 10:51:51PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > WTF? There are currently around 10 copies of clock code in the tree,
> > > every one slightly different. If this can help us get rid of all that
> > > crap, that's a GOOD THING, normative or not.
> > 
> > At the expense of people going off and inventing their own APIs because
> > they find that the "normatived" clock API doesn't do what they need to?
> 
> Just now, everyone just cuts&copies clock.c. I do not think "new"
> situation can worse than that.

That's certainly not what I've seen going on.  Each implementation is
customised to the needs of the SoC it's running on - OMAP has a complex
implementation, whereas simpler SoCs have a more simple implementation.

That's an entirely reasonable state of affairs - those who need complexity
are able to have it, whereas those who don't need complexity don't have
to be lumbered with it.

It's a long way from a "cut and copy" situation you're trying to suggest
it is.  Certainly on ARM, your viewpoint does not hold.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
