Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYCAFyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYCAFyV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYCAFyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:54:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49062 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYCAFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:54:10 -0500
Date: Fri, 29 Feb 2008 21:54:55 -0800
From: Greg KH <greg@kroah.com>
To: mark gross <mgross@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]iommu-iotlb-flushing
Message-ID: <20080301055455.GB20032@kroah.com>
References: <20080221000623.GA5510@linux.intel.com> <20080223000517.232704f3.akpm@linux-foundation.org> <20080229231841.GA6639@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229231841.GA6639@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 03:18:41PM -0800, mark gross wrote:
> > > --- linux-2.6.24-mm1.orig/Documentation/kernel-parameters.txt	2008-02-12 07:12:06.000000000 -0800
> > > +++ linux-2.6.24-mm1/Documentation/kernel-parameters.txt	2008-02-13 11:17:22.000000000 -0800
> > > @@ -822,6 +822,10 @@
> > >  			than 32 bit addressing. The default is to look
> > >  			for translation below 32 bit and if not available
> > >  			then look in the higher range.
> > > +		strict [Default Off]
> > > +			With this option on every unmap_single operation will
> > > +			result in a hardware IOTLB flush operation as opposed
> > > +			to batching them for performance.
> > 
> > boot-time options suck.  Is it not possible to tweak this at runtime?
> 
> Yes, I could easily create a sysfs or debugfs mechanism for turning it
> on / off at run time.  I would like input on the preferred way to do this.
> sysfs or debugfs?

Which is it, a debugging option, or something that anyone would want to
change?  If debugging, make it a debugfs file.  Otherwise sysfs if fine,
but be sure to add a Documentation/ABI/ file for it.

thanks,

greg k-h
