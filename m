Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXE0Bt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXE0Bt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 21:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXE0Btx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 21:49:53 -0400
Received: from colo.lackof.org ([198.49.126.79]:51152 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXE0Btw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 21:49:52 -0400
Date: Sat, 26 May 2007 19:49:45 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
Message-ID: <20070527014945.GE31023@colo.lackof.org>
References: <20070526235515.GA31023@colo.lackof.org> <20070526.170039.119261389.davem@davemloft.net> <20070527001631.GC31023@colo.lackof.org> <20070526.173037.45196275.davem@davemloft.net> <4658D84E.6050807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4658D84E.6050807@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 05:01:02AM +0400, Manu Abraham wrote:
> David Miller wrote:
> > True, on sparc64 PCI-E controllers, for example, the MSI vector is
> > received by the PCI-E host controller, and the host controller turns
> > this into a cpu format interrupt packet for the system bus.
> 
> Err .. why would a PCIe controller be CPU specific ? Looking at Figure
> 1-6 of the spec, i think it should be CPU independent ?

To be pedantic, the PCIe controller isn't really CPU specific.
It's host bus specific. ie the PCI-e controller is a bridge between
whatever chipset defines the "cache coherency domain" and the PCI-e devices.

> Excuse me for my ignorance, just that my head has begun to reel after
> reading through PCIe 1.0 and the device specs, still being inconclusive
> how to proceed.

no problem...I suspect you need to figure out why DTL-MMIO isn't working.
I have never touched DTL and can't be of much help with that.

hth,
grant

