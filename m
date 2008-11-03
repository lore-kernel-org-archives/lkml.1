Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYKCUvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYKCUvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYKCUvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:51:07 -0500
Received: from kroah.org ([198.145.64.141]:40115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754165AbYKCUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:51:04 -0500
Date: Mon, 3 Nov 2008 12:47:26 -0800
From: Greg KH <greg@kroah.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Chubb <peterc@gelato.unsw.edu.au>, jbarnes@virtuousgeek.org,
       matthew@wil.cx
Subject: Re: [stable] [patch] fix 64-vbit prefetchable memory resource BARs
Message-ID: <20081103204726.GB19936@kroah.com>
References: <8763nx1fr3.wl%peter@chubb.wattle.id.au> <200811031342.11018.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811031342.11018.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 02:42:10PM -0600, Bjorn Helgaas wrote:
> On Sunday 12 October 2008 06:49:04 pm Peter Chubb wrote:
> > Since patch 6ac665c63dcac8fcec534a1d224ecbb8b867ad59
> > my infiniband controller hasn't worked.  This is because it has
> > 64-bit prefetchable memory, which was mistakenly being  taken to be
> > 32-bit memory.  The resource flags in this case are
> > PCI_BASE_ADDRESS_MEM_TYPE_64|PCI_BASE_ADDRESS_MEM_PREFETCH.
> > 
> > This patch checks only for the PCI_BASE_ADDRESS_MEM_TYPE_64 bit; thus
> > whether the region is prefetchable or not is ignored.  This fixes my
> > Infiniband.
> 
> I think this patch needs to be put in a 2.6.27-stable release.
> 
> Without it, we ignore the upper bits of 64-bit prefetchable BARs.
> 
> This is commit e354597cce8d219d135d65e585dc4f30323486b9 in Linus's
> tree.

Thanks for the info, we will queue it up.

greg k-h
