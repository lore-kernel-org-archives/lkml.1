Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXFEAxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXFEAxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXFEAxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:53:31 -0400
Received: from relay2.nomadix.net ([63.150.145.199]:56355 "EHLO
	relay2.nomadix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXFEAxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:53:30 -0400
X-Greylist: delayed 1654 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 20:53:30 EDT
Date: Mon, 4 Jun 2007 13:19:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070604171952.GA3437@dhcp83-182.boston.redhat.com>
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604074719.GB15390@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604074719.GB15390@infradead.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 08:47:19AM +0100, Christoph Hellwig wrote:
> The right fix is the depend on the new HAS_DMA (or whatever it's called)

ACK...  if the platform truly does not do DMA.


> symbol.  The proper long-term fix is to move calln to the dam mapping
> functions from the core libata files into the drivers responsibility with
> a default implementation for the typical cases.

NAK

We have generic devices and generic DMA mapping.  libata already uses
the generic stuff.  Now fix the platform...

	Jeff



