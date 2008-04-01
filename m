Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYDARJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYDARJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 13:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbYDARJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 13:09:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6694 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbYDARJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 13:09:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch added to -mm tree
Date: Tue, 1 Apr 2008 11:09:42 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: davem@davemloft.net, greg@kroah.com, m.kozlowski@tuxland.pl,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <200803282348.m2SNmleP016847@imap1.linux-foundation.org> <200804010957.16459.bjorn.helgaas@hp.com> <20080401100050.009cec7b.akpm@linux-foundation.org>
In-Reply-To: <20080401100050.009cec7b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011109.43046.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 11:00:50 am Andrew Morton wrote:
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

I suppose Ben is the expert on that, and he did say he thought both
powerpc and ppc would be OK.  I think we just care less about ppc
because powerpc is the new converged one.

Bjorn
