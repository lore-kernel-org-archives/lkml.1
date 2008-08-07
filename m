Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYHGV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYHGV5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYHGV5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:57:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36944 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYHGV5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:57:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: "e100_probe: Error clearing wake event" when booting 2.6.27-rc1
Date: Fri, 8 Aug 2008 00:00:06 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alessandro Guido <alessandro.guido@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200808051730.27599.alessandro.guido@gmail.com> <200808052203.07815.rjw@sisk.pl> <200808070947.37534.jbarnes@virtuousgeek.org>
In-Reply-To: <200808070947.37534.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808080000.07156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of August 2008, Jesse Barnes wrote:
> On Tuesday, August 5, 2008 1:03 pm Rafael J. Wysocki wrote:
> > On Tuesday, 5 of August 2008, Alessandro Guido wrote:
> > > [please cc me on replies]
> > >
> > > I'm getting this error message when booting my laptop.
> > >
> > > The commit that causes this is:
> > >
> > > commit eb9d0fe40e313c0a74115ef456a2e43a6c8da72f
> > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > Date:   Mon Jul 7 03:34:48 2008 +0200
> > >
> > >     PCI ACPI: Rework PCI handling of wake-up
> > >
> > > [very long commit message snipped]
> > >
> > > Should I ignore that?
> >
> > The message is harmless, but it exposes the problem that e100_probe()
> > should not use pci_enable_wake() for this purpose.
> >
> > The appended patch makes it use pci_pme_active() instead.
> 
> I can take the pci_pme_active bits, but the e100 stuff should go in through 
> Jeff probably.  Care to respin?

Sure, in replies to this message.

Thanks,
Rafael
