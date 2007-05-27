Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbXE0AAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbXE0AAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbXE0AAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:00:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbXE0AAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:00:34 -0400
Date: Sat, 26 May 2007 17:00:39 -0700 (PDT)
Message-Id: <20070526.170039.119261389.davem@davemloft.net>
To: grundler@parisc-linux.org
Cc: abraham.manu@gmail.com, rdreier@cisco.com, greg@kroah.com,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: PCIE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070526235515.GA31023@colo.lackof.org>
References: <46584C30.4030206@gmail.com>
	<20070526.154910.78725926.davem@davemloft.net>
	<20070526235515.GA31023@colo.lackof.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@parisc-linux.org>
Date: Sat, 26 May 2007 17:55:15 -0600

> MSI (and MSI-X) vectors are required to be exclusive.
> I submitted that change to pci.txt last year:
> 	http://lkml.org/lkml/2006/12/25/2
> 
> and ISTR I've posted that bit of the PCI spec a few years ago.
> But it probably was to linux-pci mailing list only.

This requirement only extends to the PCI host controller,
how that interfaces to the cpu and it's limitations is
an entirely other matter.

> > I can imagine many systems where the cpu simply doesn't have enough
> > interrupt pins to uniquely identify every possible MSI interrupt
> > source.
> 
> The cpus haven't been using interrupt pins for a long time now.
> Anything with a Local-xAPIC is already using transactions to
> signal interrupts even if the OS isn't aware of it.

I'm not talking about x86, x86_64, et al.

I'm talking about embedded ARM chips and the like, and yes they
very possibly will be using PCI-E controllers at some point.
