Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZE0UxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZE0UxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZE0Uww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:52:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44106 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbZE0Uww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:52:52 -0400
Date: Wed, 27 May 2009 21:52:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Scott Wood <scottwood@freescale.com>, Peter Korsgaard <jacmet@sunsite.dk>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>
Message-ID: <20090527205218.GA5591@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527192909.GA32398@flint.arm.linux.org.uk>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:29:10PM +0100, Russell King wrote:
> On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:

> > I'm not talking about platform specific code, I'm talking about code to  
> > retrieve information about a device from the device tree.  There would  
> > not be separate instances of this for "platforms X, Y and Z", just one  
> > of_platform binding in each driver.  It's no different than having a  
> > platform bus binding, except in the data structures used.

> I really don't see what OF buys us then, apart from additional dependencies
> that have to be correct for the kernel to work.  I can only see disadvantages
> if all OF is, is a way to pass some file to the kernel to (effectively) tell
> it which drivers to use.

The main selling points of the device tree AFAICT are that some
platforms have to use it it anyway due to the native OS and firmware for
the platform use it, the possibility of using the same device tree with
more than one OS (modulo unrepresentable holes) and the fact that some
people find it more convenient to use than straight data tables
(personally I find the two approaches to be much of a muchness there).
Perhaps I'm missing something, though?
