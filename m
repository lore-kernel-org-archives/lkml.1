Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbXLJNja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbXLJNja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXLJNjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:39:23 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41941 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXLJNjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:39:22 -0500
Date: Mon, 10 Dec 2007 13:38:54 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071210133854.GB12913@linux-mips.org>
References: <1196917447.7033.17.camel@pasglop> <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net> <1196922262.7033.33.camel@pasglop> <20071209021231.GA13729@linux-mips.org> <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop> <20071209133812.2d305a02@the-village.bc.nu> <1197230609.6563.6.camel@pasglop> <20071209222335.70e52be3@the-village.bc.nu> <1197260962.6563.46.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197260962.6563.46.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 03:29:22PM +1100, Benjamin Herrenschmidt wrote:

> To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
> 	Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>,
> 	Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
> 	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
> 	Greg KH <gregkh@suse.de>,
> 	Linus Torvalds <torvalds@linux-foundation.org>,
> 	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: Re: Please revert: PCI: fix IDE legacy mode resources
> Content-Type: text/plain
> 
> powerpc: Fix IDE legacy vs. native fixups
> 
> PowerMac and CHRP/BriQ platforms have quirks to switch some IDE
> controllers from legacy mode to fully native mode. Those quirks
> however will not work properly anymore due to a change to the
> generic code to better handle legacy IDE resources.
> 
> This fixes it by moving those quirk to "early" quirks (so they
> run before resources are probed for the devices) and clearing
> all BARs after the conversion to force a reallocation of sane
> values.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> To be totally correct, we still need to also revert
> commit fd6e732186ab522c812ab19c2c5e5befb8ec8115 which
> is bogus.
> 
> Linus, can you still apply this to 2.6.24 ? I would also like the
> above (fd6e...) reverted as so far, nobody have come up with a demonstration
> that it's not bogus.

For the revert:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

I'll work with Yoichi to find another solution.

  Ralf
