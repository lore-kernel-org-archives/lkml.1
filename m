Return-Path: <linux-kernel-owner+w=401wt.eu-S1764197AbYEATQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764197AbYEATQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760726AbYEATQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:16:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42682 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760037AbYEATQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:16:45 -0400
Date: Thu, 1 May 2008 20:08:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin =?UTF-8?B?TU9LUkVKxaA=?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
Message-ID: <20080501200851.2e14d3b8@core>
In-Reply-To: <4819FDAF.7050005@ribosome.natur.cuni.cz>
References: <4819FDAF.7050005@ribosome.natur.cuni.cz>
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

> To get rid of the errors, I can use libata.dma=0 kernel
> command-line parameter. Unfortunately, this sets all libata
> devices to PIO4 mode. How can I set just this one? I tried
> 'libata.force=7.00:pio4' but it did not help.

libata.dma=3 will stop DMA being used for CF devices (except those that
decide to pretend to be ATA classes). This one comes up a lot as many CF
adapters are simply not adequate for UDMA.

> Where are the flags documented? linux/Documentation/ directory
> contains almost nothing about pata_marvell. :(

The flags are all common across drivers.

Alan
