Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXLNWNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXLNWNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbXLNWMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:12:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:40205 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbXLNWMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:12:55 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1197633131.29507.97.camel@perihelion>
References: <1197514804.15741.60.camel@pasglop>
	 <1197633131.29507.97.camel@perihelion>
Content-Type: text/plain
Date: Sat, 15 Dec 2007 09:11:54 +1100
Message-Id: <1197670314.6696.20.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 06:52 -0500, Jon Masters wrote:
> On Thu, 2007-12-13 at 14:00 +1100, Benjamin Herrenschmidt wrote:
> > While reworking the powerpc PCI resource management, to make it more
> > x86-like and use more of the generic code in setup-bus.c and
> > setup-res.c, I noticed something a bit fishy in the way we deal with
> > resources that we failed to assign.
> 
> On a tangent here, is there a way (other than pci=rom) to ensure greater
> address space/resource space for PCI resource mappings?

limit lowmem ? 4g/4g ? 64 bits ? :-)

Ben


