Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZE1DpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZE1DpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZE1Do6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:44:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53740 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbZE1Do6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:44:58 -0400
Date: Thu, 28 May 2009 13:25:57 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528032557.GF1464@yookeroo.seuss>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Russell King <rmk+lkml@arm.linux.org.uk>,
	devicetree-discuss <devicetree-discuss@ozlabs.org>,
	linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Janboe Ye <yuan-bo.ye@motorola.com>,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527205218.GA5591@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527205218.GA5591@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:52:23PM +0100, Mark Brown wrote:
> On Wed, May 27, 2009 at 08:29:10PM +0100, Russell King wrote:
> > On Wed, May 27, 2009 at 02:08:42PM -0500, Scott Wood wrote:
> 
> > > I'm not talking about platform specific code, I'm talking about code to  
> > > retrieve information about a device from the device tree.  There would  
> > > not be separate instances of this for "platforms X, Y and Z", just one  
> > > of_platform binding in each driver.  It's no different than having a  
> > > platform bus binding, except in the data structures used.
> 
> > I really don't see what OF buys us then, apart from additional dependencies
> > that have to be correct for the kernel to work.  I can only see disadvantages
> > if all OF is, is a way to pass some file to the kernel to (effectively) tell
> > it which drivers to use.
> 
> The main selling points of the device tree AFAICT are that some
> platforms have to use it it anyway due to the native OS and firmware for
> the platform use it, the possibility of using the same device tree with
> more than one OS (modulo unrepresentable holes) and the fact that some
> people find it more convenient to use than straight data tables
> (personally I find the two approaches to be much of a muchness there).
> Perhaps I'm missing something, though?

The tree structure as opposed to plain data tables is not a trivial
difference.  It makes it much, much more convenient to describe
complex device layouts unambiguously than flat tables.  It's not
perfect but it's about three shit loads better than flat data tables
(powerpc embedded went through that stage too, on the way to device
trees and it sucked mightily).

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
