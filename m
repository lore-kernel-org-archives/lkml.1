Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbYGBEcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbYGBEcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYGBEcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:32:03 -0400
Received: from colo.lackof.org ([198.49.126.79]:44628 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYGBEcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:32:01 -0400
Date: Tue, 1 Jul 2008 22:31:50 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Michael Buesch <mb@bu3sch.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       jejb <James.Bottomley@hansenpartnership.com>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] PCI: add stub for pci_set_consistent_dma_mask()
Message-ID: <20080702043150.GC19593@colo.lackof.org>
References: <20080630113553.c133307f.randy.dunlap@oracle.com> <200806301142.31124.jbarnes@virtuousgeek.org> <200806302240.50416.mb@bu3sch.de> <200806301400.02455.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806301400.02455.jbarnes@virtuousgeek.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 02:00:02PM -0700, Jesse Barnes wrote:
> > > Applied to linux-next, thanks Randy.
> >
> > I guess this is probably also needed for 2.6.26.
> 
> Hm, current upstream seems to have pci_set_consistent_dma_mask under 
> CONFIG_SSB_PCIHOST, which in turn depends on PCI = y (or PCI = SSB, what does 
> that mean?).
> 
> But yeah, it wouldn't hurt to push this for 2.6.26 too.

While I don't expect problems, it's not a critical fix. And there
are very few drivers that support both PCI and !PCI bus flavors.
I personally would not apply this patch to any "stable" kernel.

grant
