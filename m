Return-Path: <linux-kernel-owner+w=401wt.eu-S1763762AbYEBKGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763762AbYEBKGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbYEBKGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:06:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46724 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757670AbYEBKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:06:00 -0400
Date: Fri, 2 May 2008 10:57:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Martin =?UTF-8?B?TU9LUkVKxaA=?= <mmokrejs@ribosome.natur.cuni.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.17 & 2.6.24.5 and maybe earlier: pata_marvell: need to
 disable DMA to get rid of '(ATA bus error)', 'ata7.00: status: { DRDY ERR
 }', 'ata7.00: error: { ICRC ABRT }'
Message-ID: <20080502105749.24b9229f@core>
In-Reply-To: <alpine.LNX.1.10.0805020150460.6463@fbirervta.pbzchgretzou.qr>
References: <4819FDAF.7050005@ribosome.natur.cuni.cz>
	<20080501200851.2e14d3b8@core>
	<alpine.LNX.1.10.0805020150460.6463@fbirervta.pbzchgretzou.qr>
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

> >libata.dma=3 will stop DMA being used for CF devices (except those that
> >decide to pretend to be ATA classes). This one comes up a lot as many CF
> >adapters are simply not adequate for UDMA.
> 
> Perhaps the kernel could do this automatically once it sees the
> status code?

We then hurt all the people with perfectly good working UDMA CF devices.
The kernel will eventually fall back from UDMA to PIO but it favours
working hardware by default.
