Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXLOCTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXLOCTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXLOCTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:19:17 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:51770 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXLOCTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:19:17 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Jon Masters <jonathan@jonmasters.org>
To: benh@kernel.crashing.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1197670314.6696.20.camel@pasglop>
References: <1197514804.15741.60.camel@pasglop>
	 <1197633131.29507.97.camel@perihelion>  <1197670314.6696.20.camel@pasglop>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 14 Dec 2007 21:18:32 -0500
Message-Id: <1197685112.29507.151.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-15 at 09:11 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2007-12-14 at 06:52 -0500, Jon Masters wrote:
> > On Thu, 2007-12-13 at 14:00 +1100, Benjamin Herrenschmidt wrote:
> > > While reworking the powerpc PCI resource management, to make it more
> > > x86-like and use more of the generic code in setup-bus.c and
> > > setup-res.c, I noticed something a bit fishy in the way we deal with
> > > resources that we failed to assign.
> > 
> > On a tangent here, is there a way (other than pci=rom) to ensure greater
> > address space/resource space for PCI resource mappings?
> 
> limit lowmem ? 4g/4g ? 64 bits ? :-)

Oh, I've seen resource allocation fail on x86_64, which is what bothers
me, since this really shouldn't be happening.

Jon.


