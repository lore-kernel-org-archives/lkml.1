Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXGBPrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXGBPrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXGBPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:47:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52947 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbXGBPrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:47:24 -0400
Date: Mon, 2 Jul 2007 16:53:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [info] What's in libata-dev.git?
Message-ID: <20070702165327.2646a761@the-village.bc.nu>
In-Reply-To: <20070702151639.GA10948@havoc.gtf.org>
References: <20070702151639.GA10948@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 11:16:39 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> 
> 
> What follows are the changes contained in libata-dev.git, listed on a
> branch-by-branch basis.  The double "====" lines separate each branch's
> contents.  Each branch is accompanied by a 'STATUS' line, indicating the
> upstream status of each branch.
> 
> I have patches from Alan (pata_sis FIFO whack, pata_dma option), Tejun,
> Albert and Kristen still to be reviewed.  Will get to those on Friday,
> after the July 4th US holiday.tions(-)

I have a pile more for you here including finally nailing a nasty
corruptor on some chipsets. Guess what certain chips do given a PRD entry
of

            someaddress
            0x00000000

Not generating those seems to sort out the CS5530 and probably the SC1200.

I've also got the patches to print all the iomap addresses properly, get
the HPT343 working fully solidly in PIO (some DMA problems - anyone got
ancient HPT docs for the 343/345/363 anywhere). The ide/pci driver isn't
any use as a reference as that one doesn't work either.

Alan
