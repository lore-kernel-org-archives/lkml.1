Return-Path: <linux-kernel-owner+w=401wt.eu-S1762988AbXJNAIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762988AbXJNAIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 20:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbXJNAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 20:08:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:59494 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbXJNAIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 20:08:21 -0400
Subject: Re: [git patches] IDE updates (part 2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200710140041.25152.bzolnier@gmail.com>
References: <200710131825.24768.bzolnier@gmail.com>
	 <200710140009.06260.bzolnier@gmail.com>
	 <20071013232922.3ff6a464@the-village.bc.nu>
	 <200710140041.25152.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 10:08:09 +1000
Message-Id: <1192320489.22054.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 00:41 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 14 October 2007, Alan Cox wrote:
> > > > > 		/* Probably a PCI interface... */
> > > > > 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
> > > > > 			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
> > > > > 		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
> > 
> > Ok so in actual fact
> > 
> > - The piece of code above can't be executed anyway
> > - The ctrl_port argument is not needed ?
> 
> pmac_ide_init_hwif_ports() is also called by ide_init_hwif_ports()
> through ppc_ide_md.init_hwif.

In which case it should be called with a ctrl_port right ?

Ben.


