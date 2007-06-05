Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbXFEPqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbXFEPqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764769AbXFEPq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:46:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59063 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762850AbXFEPq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:46:27 -0400
Date: Tue, 5 Jun 2007 16:50:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605165056.1d9d3815@the-village.bc.nu>
In-Reply-To: <20070605141714.GA2572@flint.arm.linux.org.uk>
References: <Pine.SOC.4.64.0706032314590.20033@math>
	<20070603.174010.41894721.davem@davemloft.net>
	<20070604074719.GB15390@infradead.org>
	<20070604171952.GA3437@dhcp83-182.boston.redhat.com>
	<20070605122218.410d611b@the-village.bc.nu>
	<20070605135608.GA31565@havoc.gtf.org>
	<20070605141714.GA2572@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you don't have DMA capabilities, does libata still need ->pad and
> ->pad_dma set?

It shouldn't - nor the prd. You don't need to use the default
ata_port_start in this case. I've just added ata_sff_port_start to my
tree which figures out which to allocate for SFF devices.

