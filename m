Return-Path: <linux-kernel-owner+w=401wt.eu-S1762831AbXFJRk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831AbXFJRk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbXFJRkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:40:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47290 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758187AbXFJRkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:40:16 -0400
Date: Sun, 10 Jun 2007 18:45:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: libata limiting to UDMA/33 instead of UDMA/100
Message-ID: <20070610184536.7e29fe65@the-village.bc.nu>
In-Reply-To: <20070610183919.6f676401@laptop.hypervisor.org>
References: <20070609132124.247a6646@laptop.hypervisor.org>
	<20070610171259.278f841d@the-village.bc.nu>
	<20070610183919.6f676401@laptop.hypervisor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch fixes my cable detection problem. Now everything is back to
> UDMA/100 again. I noticed that ata1/ata2 claim to be using irq0, although
> they do in fact use irq10. This seems to be a purely cosmetical problem.

I think Tejun posted a patch for that one already - its purely cosmetic
and caused by soem of the core cleanup. The cmd/ctl/bmdma values are also
currently mis-reported from similar updates.

> ata1.01: ata_hpa_resize 1: sectors = 241254720, hpa_sectors = 241254720
> ata1.01: configured for UDMA/100

Will double check the and then push upstream
