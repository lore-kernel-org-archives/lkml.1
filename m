Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYHaJxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYHaJxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbYHaJxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:53:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35463 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756533AbYHaJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:53:21 -0400
Date: Sun, 31 Aug 2008 10:36:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Ambroz <comp@gjh.sk>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Marvell 6145 PATA controller
Message-ID: <20080831103608.69499247@lxorguk.ukuu.org.uk>
In-Reply-To: <48B9DCBE.3000306@gjh.sk>
References: <48B9DCBE.3000306@gjh.sk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The second solution is to remove few lines from ahci.c which lists the 
> marvell 6145 device (and probably also marvell 6121).
> Short patch included below.

Yes. I know or to teach the AHCI driver how to drive the PATA part of the
device. Unfortunately I've been trying - privately and now publically to
get Jeff Garzik to fix that one for *months*.

I also don't have the docs for it and requests to Jeff for the relevant
documentation have never received replies even to confirm if he has it

> ----------CUT-----------
> --- drivers/ata/ahci.c	2008-08-28 23:11:37.000000000 +0200
> +++ drivers/ata/ahci.c	2008-08-30 20:08:59.000000000 +0200
> @@ -590,10 +590,6 @@
>   	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
>   	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
> 
> -	/* Marvell */
> -	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
> -	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
> -
>   	/* Generic, PCI class code for AHCI */
>   	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>   	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
> ----------CUT-----------

And you can have my ack for it, but don't expect anything to happen

(and yes I *am* cross about this)

Alan
