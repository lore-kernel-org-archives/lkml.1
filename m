Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYDAUj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYDAUj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbYDAUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:39:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:37073 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759108AbYDAUjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:39:40 -0400
Subject: Re: +
	revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch added to
	-mm tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, davem@davemloft.net, greg@kroah.com,
       m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <20080401100050.009cec7b.akpm@linux-foundation.org>
References: <200803282348.m2SNmleP016847@imap1.linux-foundation.org>
	 <200804010957.16459.bjorn.helgaas@hp.com>
	 <20080401100050.009cec7b.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 07:38:10 +1100
Message-Id: <1207082290.10388.226.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-01 at 10:00 -0700, Andrew Morton wrote:
> On Tue, 1 Apr 2008 09:57:15 -0600 Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Friday 28 March 2008 05:48:47 pm akpm@linux-foundation.org wrote:
> > > 
> > > The patch titled
> > >      revert gregkh-pci-pci-x86-use-generic-pci_enable_resources
> > > has been added to the -mm tree.  Its filename is
> > >      revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
> > 
> > OK, I'm not sure where we are with this.  Ben listed arches where
> > the generic pci_enable_resources() should be safe: x86, alpha, and
> > powerpc.  I think we should also include ia64, since I work on that.
> > 
> > If there's no objection to those arches, how should we move forward?
> > Since Andrew put in "revert gregkh-pci" patches rather than just
> > dropping things, I assume the original patches are in Greg KH's tree.
> > 
> > Can we just drop the "revert gregkh" patches for x86, alpha, powerpc,
> > and ia64?
> 
> So powerpc is OK but ppc might not be?

No, ppc should be fine too.

Cheers,
Ben.

