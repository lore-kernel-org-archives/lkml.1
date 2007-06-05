Return-Path: <linux-kernel-owner+w=401wt.eu-S1764094AbXFELIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764094AbXFELIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXFELIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:08:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34945 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764568AbXFELIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:08:04 -0400
Date: Tue, 5 Jun 2007 12:12:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605121244.277203c1@the-village.bc.nu>
In-Reply-To: <20070605005634.GG15426@holomorphy.com>
References: <Pine.SOC.4.64.0706032314590.20033@math>
	<20070603.174010.41894721.davem@davemloft.net>
	<20070604143005.1b0e3c66@the-village.bc.nu>
	<20070604.142243.98381397.davem@davemloft.net>
	<20070605005634.GG15426@holomorphy.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The 32-bit sparc port has some but those PCMCIA controllers aren't
> > going to be supported in the foreseeable future, you have to abstract
> > out all the inb/outb etc. operations to go through the pcmcia
> > controller driver for one thing.

Thats one place iomap might actually save the day as you can hack in an
ugly "if its this page then go via pcmcia" hack into the io_read8 etc
methods and save the universe.

> I don't foresee my ever dealing with those PCMCIA controllers. If by
> some miracle I manage to get any work done on basic functionality I'll
> consider that having won.

8)
