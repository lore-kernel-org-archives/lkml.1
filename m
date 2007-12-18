Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbXLRJpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbXLRJpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 04:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXLRJpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 04:45:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:39542 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbXLRJpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 04:45:24 -0500
Subject: Re: [RFC/PATCH 1/4] pci: Add pci_enable_device_{io,mem} intefaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       jgarzik@pobox.com, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071218123715.A7874@jurassic.park.msu.ru>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <x7prx4vq3e.fsf@saeurebad.de> <1197936157.13400.9.camel@pasglop>
	 <20071218123715.A7874@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 20:43:50 +1100
Message-Id: <1197971030.13400.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 12:37 +0300, Ivan Kokshaysky wrote:
> On Tue, Dec 18, 2007 at 11:02:37AM +1100, Benjamin Herrenschmidt wrote:
> > +EXPORT_SYMBOL(pci_enable_device_io);
> > +EXPORT_SYMBOL(pci_enable_device_mem);
> >  EXPORT_SYMBOL(pci_enable_device);
> 
> Wouldn't it be better to export only the pci_enable_device_flags()
> and make these three just "static inline" wrappers in pci.h?

Been thinking about it yeah. I don't want drivers to start using
the _flags version directly tho, which is why I preferred going that
way but if people prefer the inline version, I'll do that.

> >  EXPORT_SYMBOL(pcim_enable_device);
> 
> Looks like many SATA drivers would benefit from pcim_* equivalents
> of pci_enable_device_{io,mem}, as they could happily work with just
> a single MMIO BAR... Alan?

I have no experience with the pcim stuff, I would appreciate if somebody
took care of that part.

Cheers,
Ben.


