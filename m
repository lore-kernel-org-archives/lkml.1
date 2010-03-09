Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0CIVFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 16:05:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0CIVFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 16:05:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Simmons <jsimmons@infradead.org>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) outside the graphics driver
Date: Tue, 9 Mar 2010 22:08:28 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Luca Tettamanti <kronos.it@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
References: <201003062236.09801.rjw@sisk.pl> <201003091234.59598.rjw@sisk.pl> <alpine.LFD.2.00.1003091613390.30952@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.1003091613390.30952@casper.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003092208.28175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 March 2010, James Simmons wrote:
> 
> > > > Second, in the KMS case, we'd be able to skip the kernel VT switch, because
> > > > the KMS driver uses its own framebuffer anyway.
> > > >
> > > > So, is there any reasonable way to check that from the outside of the graphics
> > > > driver?  It should be general enough to cover the cases when there are two
> > > > graphics adapters with different drivers in the system and so forth.
> > > 
> > > Inside the kernel? If you have a struct pci_dev you can get the
> > > associated struct drm_device with pci_get_drvdata and then check the
> > > KMS feature: drm_core_check_feature(dev, DRIVER_MODESET).
> > 
> > Yeah, I know that.
> > 
> > > I'm note sure how to check that a device is graphic card though :|
> > 
> > Well, that's the "outside of the graphics driver" part of my question. :-)
> 
> if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
> 	....

I'm not sure if searching through all PCI devices really is an option.

Thanks anyway.

Rafael
