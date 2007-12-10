Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXLJNlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXLJNlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXLJNlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:41:16 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41971 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbXLJNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:41:15 -0500
Date: Mon, 10 Dec 2007 13:40:56 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: benh@kernel.crashing.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210134056.GC12913@linux-mips.org>
References: <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net> <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org> <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop> <20071209133812.2d305a02@the-village.bc.nu> <1197230609.6563.6.camel@pasglop> <20071209222335.70e52be3@the-village.bc.nu> <1197260962.6563.46.camel@pasglop> <20071210112050.0bd6ac28@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210112050.0bd6ac28@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 11:20:50AM +0000, Alan Cox wrote:

> > To be totally correct, we still need to also revert
> > commit fd6e732186ab522c812ab19c2c5e5befb8ec8115 which
> > is bogus.
> 
> Agreed but that would cause an revert on an obscure MIPS platform which
> is apparently now a thoughtcrime ;)
> 
> > Linus, can you still apply this to 2.6.24 ? I would also like the
> > above (fd6e...) reverted as so far, nobody have come up with a demonstration
> > that it's not bogus.
> 
> Ack the revert too.
> 
> The MIPS needs sorting out differently.

Yep.

It seems the whole MIPS resource managment is complicated enough (out of
necessity) that only a few people actually grok it.  Ioports being
actually memory mapped on MIPS only makes the confusion worse, sigh.

  Ralf
