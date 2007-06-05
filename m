Return-Path: <linux-kernel-owner+w=401wt.eu-S1764586AbXFELRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764586AbXFELRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbXFELRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:17:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56680 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754639AbXFELRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:17:37 -0400
Date: Tue, 5 Jun 2007 12:22:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605122218.410d611b@the-village.bc.nu>
In-Reply-To: <20070604171952.GA3437@dhcp83-182.boston.redhat.com>
References: <Pine.SOC.4.64.0706032314590.20033@math>
	<20070603.174010.41894721.davem@davemloft.net>
	<20070604074719.GB15390@infradead.org>
	<20070604171952.GA3437@dhcp83-182.boston.redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK
> 
> We have generic devices and generic DMA mapping.  libata already uses
> the generic stuff.  Now fix the platform...

Nice theory but your generic helpers rely on the map functions working
even for generic hardware that doesn't need them, so at the very least
there is some clean up required.
