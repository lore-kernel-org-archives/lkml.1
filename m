Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbXF0ODT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbXF0ODT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXF0ODJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:03:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59385 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbXF0ODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:03:08 -0400
Date: Wed, 27 Jun 2007 08:03:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs (was: EDD build error)
Message-ID: <20070627140305.GV22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com> <20070627024505.GA30197@humbolt.us.dell.com> <20070627113048.GU22063@parisc-linux.org> <20070627145500.2e66fd49@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627145500.2e66fd49@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 02:55:00PM +0100, Alan Cox wrote:
> On Wed, 27 Jun 2007 05:30:48 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> > pci_get_bus_and_slot() shouldn't be used because it fails to work on
> > systems with multiple domains.  pci_get_slot() avoids this problem (and
> > is much faster too).
> 
> But requires you have a bus pointer to hand which is often not the
> case. Do we need pci_get_domain_bus_and_slot() ?

We have pci_find_bus(domain, busnr) which will get you the bus pointer.
