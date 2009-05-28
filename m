Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbZE1Lzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbZE1Lzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbZE1Lzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:55:45 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:43854 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757051AbZE1Lzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:55:45 -0400
Date: Thu, 28 May 2009 13:44:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528114408.GA11285@game.jcrosoft.org>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528091513.GA14789@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 8916564313744583603
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:15 Thu 28 May     , Russell King - ARM Linux wrote:
> On Thu, May 28, 2009 at 05:37:16PM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2009-05-27 at 18:56 +0100, Russell King wrote:
> > > 
> > > smc91x is a prime example of the kind of information drivers need - base
> > > address and irq are very much insufficient to describe how this device is
> > > connected.  There's much more information required to specify this device
> > > fully, and throwing it into the driver doesn't work.  We've been there
> > > and proven that point.
> > 
> > The device-tree is a very nice and convenient way to convey all the
> > informations the driver need straight to the driver without any platform
> > code in the middle :-)
> 
> I'm still uncertain whether that's actually a true statement.  For some
> cases, of course it's true, but I have a nasty suspicion that we have
> corner cases where OF won't cope well with.
> 
> As I see it, if we were to convert to OF, we're boxing ourselves in to
> a corner that would be extremely difficult to get out of.  We would
> never be able to step back from OF.  Lets take an example.  If we were
> to convert PXA to OF including all the PXA SoC drivers, and a board
> configuration came along which required hacks to a driver.  Later on
> we find that most platform authors are applying similar hacks because
> their hardware is subtly different but those differences can't be
> expressed via OF.  At this point, what do we do?  We can't say "well,
> OF doesn't work well on this platform, we want to get rid of it" that
> would be extremely difficult to impossible to do.
One of the really nice ability is to allow to simplify AMP support
by defining one device tree for each core where each kernel will use nealy the same
kernel. As done by Kumar for the mpc8572ds.

You can found here the boot procedure and kernel option
http://git.denx.de/?p=u-boot/u-boot-arm.git;a=blob;f=doc/README.mpc8572ds;h=06dab596bea52ab8d8c2ba89d86f793cc4881ccb;hb=HEAD

Best Regards,
J.
