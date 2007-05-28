Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXE1ESS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXE1ESS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXE1ESL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:18:11 -0400
Received: from colo.lackof.org ([198.49.126.79]:56122 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXE1ESK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:18:10 -0400
Date: Sun, 27 May 2007 22:18:02 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: David Miller <davem@davemloft.net>, abraham.manu@gmail.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
Message-ID: <20070528041802.GB711@colo.lackof.org>
References: <46561287.8020103@gmail.com> <ada1wh560u1.fsf@cisco.com> <46584C30.4030206@gmail.com> <20070526.154910.78725926.davem@davemloft.net> <ada3b1h3gke.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3b1h3gke.fsf@cisco.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2007 at 06:03:29PM -0700, Roland Dreier wrote:
...
>  > I can imagine many systems where the cpu simply doesn't have enough
>  > interrupt pins to uniquely identify every possible MSI interrupt
>  > source.
> 
> I have a hard time imagining a PCI host bus controller that converts
> MSI interrupts back to wire interrupts that go to pins on the CPU.
> For one thing it would be hard to maintain the guarantee that
> MSI interrupts can't pass DMAs.

Whatever converts the MSI back to CPU IRQ pins would have to participate
in the "cache coherency domain". This would avoid issues around DMA ordering.
It _could_ be on the same silicon as the PCI Host bus controller as long
as the above is true.

> And it would be an absolutely silly architecture too.

While I agree it's silly, it might be cheaper if any patents are
involved, it reduces  complexity, power consumption or anything
else that costs time/money.

thanks,
grant
