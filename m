Return-Path: <linux-kernel-owner+w=401wt.eu-S933714AbZE0T5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714AbZE0T5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZE0T5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:57:42 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:56491 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758708AbZE0T5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:57:41 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 15:57:41 EDT
Date: Wed, 27 May 2009 21:39:27 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527193927.GD30039@game.jcrosoft.org>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090527192116.GA31110@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 11067596085741792179
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:21 Wed 27 May     , Russell King - ARM Linux wrote:
> On Wed, May 27, 2009 at 03:13:55PM -0400, Jon Smirl wrote:
> > On Wed, May 27, 2009 at 3:08 PM, Scott Wood <scottwood@freescale.com> wrote:
> > > I'm not talking about platform specific code, I'm talking about code to
> > > retrieve information about a device from the device tree.  There would not
> > > be separate instances of this for "platforms X, Y and Z", just one
> > > of_platform binding in each driver.  It's no different than having a
> > > platform bus binding, except in the data structures used.
> > >
> > > But to restate, having external glue to create platform devices from the
> > > device tree is fine if that's what you want to do.  We used to do that, but
> > > it was a pain compared to keeping everything in one place.  Your experience
> > > may differ.
> > 
> > Could 'struct platform_device' and 'struct of_platform_device" be
> > unified into a single structure? It's personal preference whether the
> > internal representation of the hardware is done via a device tree or
> > snippets of platform code, but do we need to have to different device
> > types?
> 
> That's a damned good question - platform devices have been around since
> the dawn of the device model, so the real question which needs to be
> asked is: what was the reason that of_platform_device created rather
> than unifying it with the already provided platform_device ?
I agree at 100%

when you have to support the same driver for non OF and OF platform it's
really a pain in the ass

Best Regards,
J.
