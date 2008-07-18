Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYGRJit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYGRJit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYGRJim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:38:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36480 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYGRJil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:38:41 -0400
Date: Fri, 18 Jul 2008 10:06:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Frantisek Hanzlik <franta@hanzlici.cz>, linux-kernel@vger.kernel.org
Subject: Re: serverworks CSB5 IDE: DMA disabled on secondary channel
Message-ID: <20080718100607.1589ed2f@the-village.bc.nu>
In-Reply-To: <487FED33.2030207@shaw.ca>
References: <fa.Fmf0CiaCc/J+JAWaZ5FS+ihhhzA@ifi.uio.no>
	<487FED33.2030207@shaw.ca>
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

> > ata2.01: ATAPI: CD-W540E, 1.0D, max UDMA/33
> > ata2.00: simplex DMA is claimed by other device, disabling DMA
> > ata2.01: simplex DMA is claimed by other device, disabling DMA
> > ata2.00: configured for PIO4
> > ata2.01: configured for PIO4


Disable the pata_acpi driver and let me know if it then behaves. We had a
similar problem with the ATI hardware which lost and messed up its
internal state if pata_acpi was loaded first.

