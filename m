Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYGSJTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYGSJTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 05:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYGSJTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 05:19:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46506 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYGSJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 05:19:07 -0400
Date: Sat, 19 Jul 2008 09:46:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frantisek Hanzlik <franta@hanzlici.cz>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: serverworks CSB5 IDE: DMA disabled on secondary channel
Message-ID: <20080719094631.4f4e6a5e@the-village.bc.nu>
In-Reply-To: <48815567.2080001@hanzlici.cz>
References: <fa.Fmf0CiaCc/J+JAWaZ5FS+ihhhzA@ifi.uio.no>
	<487FED33.2030207@shaw.ca>
	<20080718100607.1589ed2f@the-village.bc.nu>
	<48815567.2080001@hanzlici.cz>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 04:45:59 +0200
Frantisek Hanzlik <franta@hanzlici.cz> wrote:

> Alan Cox wrote:
> >>> ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
> >>> ata2.00: simplex DMA is claimed by other device, disabling DMA
> >>> ata2.01: simplex DMA is claimed by other device, disabling DMA
> >>> ata2.00: configured for PIO4
> >>> ata2.01: configured for PIO4
> >
> >
> > Disable the pata_acpi driver and let me know if it then behaves. We had a
> > similar problem with the ATI hardware which lost and messed up its
> > internal state if pata_acpi was loaded first.
> >
> Before I post to lkml I tried disable ata_generic driver, (which was loaded
> before pata_serverworks too


Thanks - please complain to your distribution vendor if they are not
following the docs and loading pata_acpi then ata_generic then ata_legacy
*AFTER* other drivers.
