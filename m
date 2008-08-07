Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYHGRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYHGRW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYHGRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:22:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYHGRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:22:41 -0400
Date: Thu, 7 Aug 2008 10:20:01 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Message-ID: <20080807172001.GA9773@kroah.com>
References: <1217786532.4179.24.camel@localhost.localdomain> <200808051415.59993.jbarnes@virtuousgeek.org> <1217973297.9923.80.camel@localhost.localdomain> <200808070903.23787.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808070903.23787.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 09:03:22AM -0700, Jesse Barnes wrote:
> On Tuesday, August 5, 2008 2:54 pm James Bottomley wrote:
> > > or somesuch.  That seems just as simple for driver writers as your
> > > initial patch, and the function is named in accordance with what it
> > > actually does, rather than what it's used for...
> >
> > It could, but if the bridge is the culprit (as it usually is for MSI
> > problems), this print won't help identify it.
> >
> > Therefore, rather than give driver writers a recipe for "print this and
> > this and go to the bridge and print this", I'd rather have a single PCI
> > callback that prints all the (hopefully) relevant information that will
> > allow either fixing or blacklisting.
> 
> So in addition to the IRQ type check we need to dump some device topology 
> information... yeah that makes sense.  I wonder if the driver core should 
> provide something like this.  Greg?

What kind of topology do you need that is not already provided?

thanks,

greg k-h
