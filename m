Return-Path: <linux-kernel-owner+w=401wt.eu-S934697AbXLRA1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697AbXLRA1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760432AbXLRA1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:27:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:53616 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761382AbXLRA13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:27:29 -0500
Subject: Re: [RFC/PATCH 2/4] pci: Remove users of pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071218000740.446a6adf@the-village.bc.nu>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <20071217230126.26291DDE34@ozlabs.org>
	 <20071218000740.446a6adf@the-village.bc.nu>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 11:26:26 +1100
Message-Id: <1197937586.13400.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 00:07 +0000, Alan Cox wrote:
> On Tue, 18 Dec 2007 10:01:14 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > This patch converts users of pci_enable_device_bars() to the new
> > pci_enable_device_{io,mem} interface.
> > 
> > The new API fits nicely, except maybe for the QLA case where a bit of
> > code re-organization might be a good idea but I prefer sticking to the
> > simple patch as I don't have hardware to test on.
> > 
> > I'll also need some feedback on the cs5520 change
> 
> 5520 in fact is always enabled as it is the host bridge.
> pci_enable_device_io will do just fine. The 5520 fun is if you disable it
> the system hangs.

Ok, thanks, that's not my idea of fun though :-)

Cheers,
Ben.


