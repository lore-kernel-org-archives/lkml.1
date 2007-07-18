Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbXGRLeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbXGRLeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbXGRLdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:33:49 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2262 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758212AbXGRLds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:33:48 -0400
Date: Wed, 18 Jul 2007 12:33:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
In-Reply-To: <Pine.LNX.4.64.0707171049080.10600@anakin>
Message-ID: <Pine.LNX.4.64N.0707181210520.29955@blysk.ds.pg.gda.pl>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707171049080.10600@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Geert Uytterhoeven wrote:

> > > No, no revert, please.  If the architecture doesn't support readb() then we
> > > need some reliable way of working that out within Kconfig.
> > 
> > Isn't that CONFIG_HAS_IOMEM?
> 
> No, having memory mapped I/O doesn't mean you have PCI.

 Hmm, TURBOchannel is not PCI, but is still accessible with 
{read,write}{b,w,l}().

> How to access memory mapped I/O depends on the bus behind the device.

 I would have thought this is to be resolved within ioremap() so that 
drivers can be made portable without twisting your arms.  With the more 
recent ioport_map() call that may be extended to port I/O type devices as 
well.  The Alpha with its dense and sparse I/O space proves it can be done 
for arbitrarily complicated arrangements.

  Maciej
