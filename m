Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbYDNWMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbYDNWMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760457AbYDNWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:12:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39694 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760411AbYDNWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:12:05 -0400
Date: Mon, 14 Apr 2008 15:10:44 -0700
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       davem@davemloft.net, m.kozlowski@tuxland.pl,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: +
	revert-gregkh-pci-pci-x86-use-generic-pci_enable_resources.patch
	added to -mm tree
Message-ID: <20080414221044.GA3684@kroah.com>
References: <200803282348.m2SNmleP016847@imap1.linux-foundation.org> <1207082276.10388.224.camel@pasglop> <20080402051554.GA21714@kroah.com> <200804020843.02402.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804020843.02402.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 08:43:01AM -0600, Bjorn Helgaas wrote:
> On Tuesday 01 April 2008 11:15:54 pm Greg KH wrote:
> > On Wed, Apr 02, 2008 at 07:37:56AM +1100, Benjamin Herrenschmidt wrote:
> > > 
> > > On Tue, 2008-04-01 at 09:57 -0600, Bjorn Helgaas wrote:
> > > > 
> > > > Can we just drop the "revert gregkh" patches for x86, alpha, powerpc,
> > > > and ia64?
> > > 
> > > Considering that the generic is equivalent to what I have today on
> > > powerpc, I'm fine with it.
> > 
> > Ok, so what ones should I keep in my tree?
> > 
> > Bjorn, any help?
> 
> I think we should keep x86, alpha, powerpc, ppc, and ia64.
> 
> Kyle previously acked it for parisc, so maybe he can speak
> up about whether to keep it there.

Ok, I've kept:
	x86
	alpha
	powerpc
	ppc
	parisc
	ia64

and dropped:
	arm
	cris
	frv
	mips
	mn10300
	sh
	sparc64
	v850
	xtensa

from my tree.

If anything further needs to be changed, please let me know.

thanks,

greg k-h
