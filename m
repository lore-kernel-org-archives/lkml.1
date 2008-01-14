Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYANXF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYANXF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYANXFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:05:48 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53581 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYANXFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:05:48 -0500
Date: Tue, 15 Jan 2008 01:04:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080114230448.GL9847@does.not.exist>
References: <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop> <20080113072415.GB18741@parisc-linux.org> <20080113090108.3224698c@laptopd505.fenrus.org> <20080114225225.GQ18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080114225225.GQ18741@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 03:52:26PM -0700, Matthew Wilcox wrote:
> On Sun, Jan 13, 2008 at 09:01:08AM -0800, Arjan van de Ven wrote:
>...
> > > -	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
> > > +	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
> > 
> > 	couldn't this (at least in some next patch) use the vector if it exists?
> 
> I thought so, but due to the way that things are initialised, mmconfig
> happens before conf1.  conf1 is known to be usable, but hasn't set
> raw_pci_ops at this point.  Confusing, and not ideal, but fixing this
> isn't in scope for 2.6.24.
>...

*ahem*

I don't think anything of what was discussed in this thread would be in 
scope for 2.6.24 (unless Linus wants to let the bunny that brings eggs 
release 2.6.24).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

