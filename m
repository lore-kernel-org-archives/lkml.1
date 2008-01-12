Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbYALA0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbYALA0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 19:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbYALA0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 19:26:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46450 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYALA0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 19:26:30 -0500
Date: Fri, 11 Jan 2008 16:26:38 -0800
From: Greg KH <greg@kroah.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080112002638.GA18710@kroah.com>
References: <20080111194931.GN18741@parisc-linux.org> <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org> <20080111201716.GO18741@parisc-linux.org> <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111235856.GA16079@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 02:58:56AM +0300, Ivan Kokshaysky wrote:
> On Fri, Jan 11, 2008 at 02:38:03PM -0700, Matthew Wilcox wrote:
> > On Fri, Jan 11, 2008 at 01:28:30PM -0800, Linus Torvalds wrote:
> > > Hmm. Were all those reports root-caused to just that BAR probing? If so, 
> > > we may be in better shape than I worried.
> > 
> > I believe so.
> 
> Ditto.
> 
> One typical problem is that on "Intel(r) 3 Series Experss Chipset Family"
> MMCONFIG probing of the BAR #2 (frame buffer address) of integrated graphics
> device locks up the machine (depending on BIOS settings, of course).
> This happens because the frame buffer of IGD has higher decode priority
> than MMCONFIG range, as stated in Intel docs...

Ok, so what would the proposed patch look like to help resolve this?

Ivan, you posted one a while ago, but never seemed to get any
confirmation if it helped or not.  Should I use that and drop Arjan's?
Or use both?  Or something else like the patches proposed by Tony
Camuso?

thanks,

greg k-h
