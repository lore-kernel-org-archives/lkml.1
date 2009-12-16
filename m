Return-Path: <linux-kernel-owner+w=401wt.eu-S935607AbZLPT1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935607AbZLPT1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935447AbZLPT1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:27:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935446AbZLPT12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:27:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH 3/12] PCI / PM: Propagate wake-up enable for PCIe devices too
Date: Wed, 16 Dec 2009 20:28:21 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Len Brown <lenb@kernel.org>
References: <200911160047.46299.rjw@sisk.pl> <200911291635.54352.rjw@sisk.pl> <20091216111939.1a756377@jbarnes-piketon>
In-Reply-To: <20091216111939.1a756377@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912162028.21775.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009, Jesse Barnes wrote:
> On Sun, 29 Nov 2009 16:35:54 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Having read the PM part of the PCIe 2.0 specification more carefully
> > I think that it was a mistake to restrict the wake-up enable
> > propagation to non-PCIe devices, because if we do not request
> > control of the root ports' PME registers via OSC, PCIe PME is
> > supposed to be handled by the platform, just like the non-PCIe PME.
> > Even if we do that, the wake-up propagation is done to allow the
> > devices to wake up the system from sleep states which involves the
> > platform anyway, so it won't hurt.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-acpi.c |   10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> Applied after fixing up conflicts related to dev->is_pcie.

Thanks!
