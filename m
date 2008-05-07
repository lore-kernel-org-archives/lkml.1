Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbYEGHe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbYEGHe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbYEGHeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:34:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761343AbYEGHeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:34:12 -0400
Date: Wed, 7 May 2008 08:25:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin =?UTF-8?B?TU9LUkVKxaA=?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: Robert Hancock <hancockr@shaw.ca>, Jan Engelhardt <jengelh@medozas.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
Message-ID: <20080507082502.0713bc14@core>
In-Reply-To: <4820ECD4.2020500@ribosome.natur.cuni.cz>
References: <fa.+9Q+WQnyiYTlpbXVIzn6aT2/gS0@ifi.uio.no>
	<fa.fKUfeQYS9BFD60fOMormQ25ard4@ifi.uio.no>
	<fa.QYXSW2xjSxf6xnmd0rQGJhHLnrc@ifi.uio.no>
	<fa.qfeYSQtlsXzGvFvBQEdF9TFFpNg@ifi.uio.no>
	<481BD12D.1030406@shaw.ca>
	<4820529D.2040609@ribosome.natur.cuni.cz>
	<20080506140825.759db8f2@core>
	<4820711C.1010902@ribosome.natur.cuni.cz>
	<20080506160452.61725e6c@core>
	<48208647.3090500@ribosome.natur.cuni.cz>
	<20080506200421.64491c30@core>
	<4820ECD4.2020500@ribosome.natur.cuni.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good, but as I have said, I am using 2.6.24.5 or below. According
> to Google the patch was included in 2.6.25-rc3 so I am out of luck.

For the moment yes.

> Subject: 2.6.25: pata_marvell/ahci/libata regression: ata7: SATA link down (SStatus 0 SControl 300)

I have absolutely no idea about the AHCI link down case although some
patches did go into the tree for a similar looking report.

> Basically, I cannot boot with 2.6.25. So I am stuck. Please
> push the libata.force patch into 2.6.24 tree
> (http://www.mail-archive.com/linux-ide@vger.kernel.org/msg15454.html).
> Currently I can only use libata.dma=0.

Correct.

Alan
