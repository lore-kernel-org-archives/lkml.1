Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXFDVWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXFDVWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXFDVWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:22:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59301
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752508AbXFDVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:22:29 -0400
Date: Mon, 04 Jun 2007 14:22:43 -0700 (PDT)
Message-Id: <20070604.142243.98381397.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070604143005.1b0e3c66@the-village.bc.nu>
References: <Pine.SOC.4.64.0706032314590.20033@math>
	<20070603.174010.41894721.davem@davemloft.net>
	<20070604143005.1b0e3c66@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 4 Jun 2007 14:30:05 +0100

> > It really makes no sense to allow this on Sparc, there are no
> > non-PCI Sparc ATA controllers.
> 
> There are PCMCIA controllers and PCI/PCMCIA/Cardbus adapters for the
> Sparc platform I thought ?

The 32-bit sparc port has some but those PCMCIA controllers aren't
going to be supported in the foreseeable future, you have to abstract
out all the inb/outb etc. operations to go through the pcmcia
controller driver for one thing.

Secondarily, sparc32 lacks an active maintainer and it's
been like this for several years, the only things getting
worked on therefore are basica functionality and the most
important bug fixes.
