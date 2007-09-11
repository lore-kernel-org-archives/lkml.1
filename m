Return-Path: <linux-kernel-owner+w=401wt.eu-S966452AbXIKGl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966452AbXIKGl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762180AbXIKGjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:39:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55170 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762016AbXIKGjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:39:22 -0400
Date: Mon, 10 Sep 2007 23:24:29 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gaston <jason.d.gaston@intel.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       khali@linux-fr.org, i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.23-rc4][RESEND] irq: irq and pci_ids patch for
	Intel Tolapai
Message-ID: <20070911062429.GG27404@kroah.com>
References: <200708301750.57189.jason.d.gaston@intel.com> <20070910024525.4e90b29d.akpm@linux-foundation.org> <20070910140913.GC6171@kroah.com> <20070910124841.4a6c66d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910124841.4a6c66d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 12:48:41PM -0700, Andrew Morton wrote:
> On Mon, 10 Sep 2007 07:09:13 -0700 Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Sep 10, 2007 at 02:45:25AM -0700, Andrew Morton wrote:
> > > On Thu, 30 Aug 2007 17:50:56 -0700 Jason Gaston <jason.d.gaston@intel.com> wrote:
> > > 
> > > > Resend without wordwrap.
> > > > 
> > > > This updated patch adds the Intel Tolapai LPC and SMBus Controller DID's.
> > > > 
> > > > Signed-off-by: ?Jason Gaston <jason.d.gaston@intel.com>
> > > > 
> > > > --- linux-2.6.23-rc4/arch/i386/pci/irq.c.orig	2007-08-27 18:32:35.000000000 -0700
> > > > +++ linux-2.6.23-rc4/arch/i386/pci/irq.c	2007-08-28 16:58:31.000000000 -0700
> > > > @@ -550,6 +550,7 @@
> > > >  		case PCI_DEVICE_ID_INTEL_ICH9_3:
> > > >  		case PCI_DEVICE_ID_INTEL_ICH9_4:
> > > >  		case PCI_DEVICE_ID_INTEL_ICH9_5:
> > > > +		case PCI_DEVICE_ID_INTEL_Tolapai_0:
> > > >  			r->name = "PIIX/ICH";
> > > >  			r->get = pirq_piix_get;
> > > >  			r->set = pirq_piix_set;
> > > > --- linux-2.6.23-rc4/include/linux/pci_ids.h.orig	2007-08-27 18:32:35.000000000 -0700
> > > > +++ linux-2.6.23-rc4/include/linux/pci_ids.h	2007-08-28 16:58:31.000000000 -0700
> > > > @@ -2293,6 +2293,8 @@
> > > >  #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
> > > >  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
> > > >  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
> > > > +#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
> > > > +#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032
> > > >  #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
> > > >  #define PCI_DEVICE_ID_INTEL_82371SB_1	0x7010
> > > >  #define PCI_DEVICE_ID_INTEL_82371SB_2	0x7020
> > > 
> > > I agree with Matthew that the lower-case shouldn't be in there, so I queued
> > > a patch to fix that up.
> > > 
> > > Given that your I2C patch (and potentially others?) depend upon this one, I
> > > shall plan on getting this patch into mainline this week to make everyone's
> > > life simpler.
> > 
> > I agree, that's why it's in my queue to go to Linus in a day or so :)
> > 
> 
> I can't find it.  Did you queue the all-caps version or the above version?

The all-caps version.  But I realized that I hadn't pushed out my tree
to kernel.org due to doing this work on the train without network
support, so it should be there now.  Sorry about that.

greg k-h
