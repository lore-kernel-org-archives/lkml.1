Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYCZKNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYCZKNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbYCZKMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:12:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756842AbYCZKMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:12:53 -0400
Date: Wed, 26 Mar 2008 09:56:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: DMA not working on SATA?
Message-ID: <20080326095620.7956822b@core>
In-Reply-To: <1206525562.7022.16.camel@pitcairn.cambridgebroadband.com>
References: <1206525562.7022.16.camel@pitcairn.cambridgebroadband.com>
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

> of read performance with hdparm but heavy IO still makes the machine
> sluggish, with top showing ~80% of the time in the wait state (and
> loadavg shooting up). This seems like a DMA problem because I was under

Load average includes wait states for disk.

> [   30.999213] ata1.00: ATA-7: ST3160815AS, 3.AAD, max UDMA/133
> [   30.999216] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth
> 31/32)
> [   31.054773] usb 7-1.2: configuration #1 chosen from 1 choice
> [   31.055515] usbcore: registered new interface driver libusual
> [   31.057399] ata1.00: configured for UDMA/133

So it is running at UDMA133



> [   32.934174] ata7.00: ATAPI: TSSTcorpDVD-ROM SH-D162D, SB00, max
> UDMA/33
> [   33.105820] ata7.00: configured for UDMA/33

CD-ROM at UDMA 33


> [   39.285949] nvidia: module license 'NVIDIA' taints kernel

And any problems beyond that point are ones you need to take up with
Nvidia as they have all the source code but we don't have theirs.
