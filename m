Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXLMLUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXLMLUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 06:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXLMLUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 06:20:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:48832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXLMLUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:20:40 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1197544621.15741.132.camel@pasglop>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	 <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
	 <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no> <4760B37E.3010002@shaw.ca>
	 <20071213120403.B21124@jurassic.park.msu.ru>
	 <20071213102424.18b621a7@the-village.bc.nu>
	 <1197544621.15741.132.camel@pasglop>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 22:20:20 +1100
Message-Id: <1197544820.15741.137.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Supporting pci_enable_device_io / pci_enable_device_mmio / pci_iomap_io /
> > pci_iomap_mmio seems to cover pretty much all the use cases we have. 
> > 
> > The users we have right now that are:
> > 
> >         - pata_cs5520   (can be dealt with easily)
> >         - old IDE       (with the new resource handling for legacy IDE
> > can use pci_enable_device_io I think, ditto pci/cs5520)
> >         - scx200_acb    (looks like a simple substitution works)
> >         - lpfc          pci_enable_device_mmio
> >         - qla2xxx       pci_enable_device ? (enables IO and MMIO)

I may have not fully undestood you in my previous reply. You are proposing
replacing pci_enable_device_bars() with a pair of pci_enable_device_io/mem ?

I think that would be a good idea indeed.

Cheers,
Ben.


