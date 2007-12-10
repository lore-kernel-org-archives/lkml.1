Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbXLJPJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbXLJPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXLJPJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:09:16 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47259 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753380AbXLJPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:09:15 -0500
Date: Mon, 10 Dec 2007 15:01:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: benh@kernel.crashing.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210150126.7cec9cbc@the-village.bc.nu>
In-Reply-To: <20071210134056.GC12913@linux-mips.org>
References: <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	<1196922262.7033.33.camel@pasglop>
	<20071209021231.GA13729@linux-mips.org>
	<1197185091.6572.38.camel@pasglop>
	<1197193794.6572.52.camel@pasglop>
	<20071209133812.2d305a02@the-village.bc.nu>
	<1197230609.6563.6.camel@pasglop>
	<20071209222335.70e52be3@the-village.bc.nu>
	<1197260962.6563.46.camel@pasglop>
	<20071210112050.0bd6ac28@the-village.bc.nu>
	<20071210134056.GC12913@linux-mips.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems the whole MIPS resource managment is complicated enough (out of
> necessity) that only a few people actually grok it.  Ioports being
> actually memory mapped on MIPS only makes the confusion worse, sigh.

If the hardware cannot map the low PCI space then set
CONFIG_NO_ATA_LEGACY and the ATA layer will leave legacy ports alone.
Unfortunately its not clear we can make that mode try and force
controllers into native. We could try that if the MIPS and PPC people
want ?

