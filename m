Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZGTT77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZGTT77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZGTT76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:59:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZGTT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:59:57 -0400
Date: Mon, 20 Jul 2009 12:55:36 -0700
From: Greg KH <gregkh@suse.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, anthony@codemonkey.ws, avi@redhat.com,
       kvm@vger.kernel.org, chrisw@redhat.com, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCHv5] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090720195536.GA30483@suse.de>
References: <20090720072934.GA12509@redhat.com>
 <20090720190942.GB7604@local>
 <20090720195227.GB19009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720195227.GB19009@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 10:52:27PM +0300, Michael S. Tsirkin wrote:
> On Mon, Jul 20, 2009 at 09:09:43PM +0200, Hans J. Koch wrote:
> > On Mon, Jul 20, 2009 at 10:29:34AM +0300, Michael S. Tsirkin wrote:
> > > This adds a generic uio driver that can bind to any PCI device.  First
> > > user will be virtualization where a qemu userspace process needs to give
> > > guest OS access to the device.
> > > 
> > > Interrupts are handled using the Interrupt Disable bit in the PCI command
> > > register and Interrupt Status bit in the PCI status register.  All devices
> > > compliant to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
> > > support these bits.  Driver detects this support, and won't bind to devices
> > > which do not support the Interrupt Disable Bit in the command register.
> > > 
> > > It's expected that more features of interest to virtualization will be
> > > added to this driver in the future. Possibilities are: mmap for device
> > > resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> > 
> > Thanks for adding the docs! Looks alright to me.
> > 
> > Thanks,
> > Hans
> > 
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Acked-by: Chris Wright <chrisw@redhat.com>
> > 
> > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 
> Jesse just acked this patch in a private mail, as well.
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Odd, but ok...

I'll queue it up now.

thanks,

greg k-h
