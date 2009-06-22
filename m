Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZFVRch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZFVRch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbZFVRb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:31:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49075 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757664AbZFVRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:31:55 -0400
Date: Mon, 22 Jun 2009 18:32:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Freemyer <greg.freemyer@gmail.com>,
       David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       elendil@planet.nl, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared -
 system  	is dreadfully slow)
Message-ID: <20090622183218.15d340d5@lxorguk.ukuu.org.uk>
In-Reply-To: <200906221921.21709.arnd@arndb.de>
References: <20090621.141950.160759111.davem@davemloft.net>
	<4A3FB956.6060401@garzik.org>
	<20090622181100.43a56309@lxorguk.ukuu.org.uk>
	<200906221921.21709.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, m68k, m32r and h8300 currently can't use libata at all
> for one reason or another, mostly missing support for dma-mapping.h

That wants fixing and your ifdef patches looked a route to beat it into
some kind of shape

> side, it should be possible to convert almost any non-PCI ATA
> chip to use drivers/ata/pata_platform.c or pata_of_platform.c.

The ioc4 and the ppc ones are a bit harder as they have custom DMA
descriptor tables and stuff. The rest I agree.
