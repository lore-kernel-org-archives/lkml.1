Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXGFPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXGFPN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbXGFPNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:13:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53960 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756007AbXGFPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:13:51 -0400
Date: Fri, 6 Jul 2007 16:19:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
Message-ID: <20070706161950.32fc3139@the-village.bc.nu>
In-Reply-To: <20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
	<20070706111848.43551f33@the-village.bc.nu>
	<20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So, the name of the drive can depend on something which happens in the
> ramdisk environment. Does anybody know what that is? And is there a
> kernel command line parameter which restores the old behaviour?

Old IDE -> /dev/hd*
LibATA -> /dev/sd*

so if you build both sets of modules it depends who gets loaded first.

> And what about hdparm (setting 32bit I/O and multi-sector mode)? Suren
> wrote that 32bit I/O makes no sense when using DMA. Maybe that's right,
> but it does not correspond with my experiences. At least, I have the
> "feeling" that my IDE disks work much faster since I enabled 32bit
> support (DMA already was on before).

32bit I/O and multi-sector I/O are PIO specific features - they have no
effect on DMA performance. 32bit is on my todo list but very low priority
as for most systems it makes almost no difference.

Alan
