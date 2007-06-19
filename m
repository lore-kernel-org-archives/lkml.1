Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbXFSBSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbXFSBSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbXFSBSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:18:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:33056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbXFSBSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:18:13 -0400
Subject: Re: PCI userland access non-mmap APIs, kernel access to legacy
	space
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Ian Romanick <idr@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>,
       Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <200706181414.25647.jesse.barnes@intel.com>
References: <1182133004.26853.229.camel@localhost.localdomain>
	 <200706181414.25647.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 11:17:51 +1000
Message-Id: <1182215871.26853.302.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But adding read/write is fine with me.  In fact, having read/write hooks 
> for the memory backed resource files is also nice, since it makes 
> dealing with them on the command line a bit easier.

Plan is to use iomap so I get both IO and MMIO for (almost) free :-)

> > Also, while at it, I would like to introduce a pair of in-kernel
> > interfaces:
> 
> What's the other half of the pair?

Heh, indeed, there is none, I initially had a separate function for mem
and for io and at the last minute though "ugh, let's just use a struct
resource !" :-)

> Yeah, sounds like a good additional abstraction for that interface.  
> Should make porting it to other arches easier (I talked with kyle about 
> this last week, so maybe this'll give him motivation to do it for 
> parisc).

Ok, good. I'll do some code asap.

Ben.


