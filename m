Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXLJXPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXLJXPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXLJXPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:15:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41807 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbXLJXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:15:11 -0500
Date: Mon, 10 Dec 2007 23:07:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210230716.38da105a@the-village.bc.nu>
In-Reply-To: <1197319154.8692.13.camel@pasglop>
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
	<20071210150126.7cec9cbc@the-village.bc.nu>
	<1197319154.8692.13.camel@pasglop>
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

> Forcing controllers into native mode tends to be something that really
> only works on -some- controllers. I'm happy to have a hack to try to do
> that on all of them on powermacs, because the range of controllers that
> might not be in native mode in the first place there is pretty small,
> and for CHRP briq, I do it for a specific known controller only.

I'm thinking of doing this solely if the platform has
CONFIG_ATA_NO_LEGACY set. In other words we'd only try this stunt on a
system we *know* cannot address the low PCI space ports.

