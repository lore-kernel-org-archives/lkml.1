Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbXFDV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbXFDV6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXFDV6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:58:43 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37879 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbXFDV6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:58:42 -0400
Date: Mon, 4 Jun 2007 17:58:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ATA]: Don't allow to enable this for SPARC64 without PCI.
Message-ID: <20070604215841.GK20299@havoc.gtf.org>
References: <200706042059.l54Kx6jR031700@hera.kernel.org> <20070604210952.GI20299@havoc.gtf.org> <20070604.142736.27799798.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604.142736.27799798.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 02:27:36PM -0700, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Mon, 4 Jun 2007 17:09:52 -0400
> 
> > Um, this was NAK'd:
> > 
> > libata uses generic DMA and generic struct device.  Neither of which
> > are specific to SPARC64 or PCI.
> > 
> > Did you read the code?
> > Did you read the thread on which you were CC'd?
> > Did you see the NAKs from me and Alan (and others)?
> 
> It went in before any of you replied, to be fair.

Sounds like we should taunt Linus for being slow then ;) ;)


> I'm willing to fix this in other ways, but there is simply
> no hardware that's going to work in that kind of configuration
> (non-PCI) on sparc64 so building it in that state is going to
> be purely for the purposes of intellectual curiosity :-)

Should be easy enough to add dma_xxx wrappers that do nothing but
return an error.

As long as this change is _temporary_, I'm happy.

As you saw from my reply, apply a driver fix for a platform problem
makes me twitch in a big way... :)

	Jeff



