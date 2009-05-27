Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbZE0TZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbZE0TZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZE0TY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:24:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44589 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZE0TYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:24:55 -0400
Date: Wed, 27 May 2009 20:21:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Scott Wood <scottwood@freescale.com>, Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527192116.GA31110@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:13:55PM -0400, Jon Smirl wrote:
> On Wed, May 27, 2009 at 3:08 PM, Scott Wood <scottwood@freescale.com> wrote:
> > I'm not talking about platform specific code, I'm talking about code to
> > retrieve information about a device from the device tree.  There would not
> > be separate instances of this for "platforms X, Y and Z", just one
> > of_platform binding in each driver.  It's no different than having a
> > platform bus binding, except in the data structures used.
> >
> > But to restate, having external glue to create platform devices from the
> > device tree is fine if that's what you want to do.  We used to do that, but
> > it was a pain compared to keeping everything in one place.  Your experience
> > may differ.
> 
> Could 'struct platform_device' and 'struct of_platform_device" be
> unified into a single structure? It's personal preference whether the
> internal representation of the hardware is done via a device tree or
> snippets of platform code, but do we need to have to different device
> types?

That's a damned good question - platform devices have been around since
the dawn of the device model, so the real question which needs to be
asked is: what was the reason that of_platform_device created rather
than unifying it with the already provided platform_device ?

BTW, I can find no such struct "of_platform_device" in include/linux.
Is it specific to each and every OF implementation?
