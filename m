Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXL1Uwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXL1Uwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXL1Uoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:44:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:58004 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXL1Unn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:43 -0500
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Loic Prylli <loic@myri.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>
In-Reply-To: <47754B26.6050700@myri.com>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>
	 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>
	 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
	 <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
	 <477414C9.3040906@myri.com>
	 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>
	 <1198819790.7209.27.camel@pasglop>
	 <alpine.LFD.0.9999.0712272135270.21557@woody.linux-foundation.org>
	 <1198822010.7209.32.camel@pasglop>  <47754B26.6050700@myri.com>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 07:42:36 +1100
Message-Id: <1198874556.7209.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-28 at 14:14 -0500, Loic Prylli wrote:
> 
> Not knowing whether there is any chipset with the visibility feature,
> but without the retry capability, and given that CRS is irrelevant for
> most Linux platforms (it only matters just after power-on, long before
> Linux is started in the common case),

"common case" I suppose in your mouth means desktop machines ? :-)

In the embedded world, I would expect CRS to be something that linux has
to deal with regulary. Maybe enable_crs should be moved to quirks on
those platforms who want it...

> This is mostly independant, allowing a PCIE->PCI-X bridge to generate
> CRS is a different bit (bit 15 of pcie->devctl on the bridge). FWIW,
> Linux does not seem to touch it, and it defaults to zero, so it does
> not
> seem like most current PCIE->PCI-X bridge will never generates a CRS
> (some BIOSes might do it, but not the couple of platforms I looked
> at).
> Again the choice of setting here seems something better left to the
> specific BIOS/embedded-code for a given platform.

Ok, I wasn't sure about that one.

Ben.


