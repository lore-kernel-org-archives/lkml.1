Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbXGBNuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbXGBNuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXGBNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:50:35 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55823 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXGBNue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:50:34 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 09:48:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eng.linux@digi.com
Subject: Re: [PATCH][RFC] Remove support for the orphaned, obsolete Digi EPCA
 driver.
In-Reply-To: <20070702144605.5cf99b3a@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0707020945290.18113@localhost.localdomain>
References: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain>
 <20070702144605.5cf99b3a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Alan Cox wrote:

> On Mon, 2 Jul 2007 09:14:24 -0400 (EDT)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >   everything indicates that this driver is thoroughly dead.  the
> > MAINTAINERS file describes it as "Orphaned", while the file
> > Documentation/digiepca.txt reads:
>
> NAK
>
> > "NOTE:  This driver is obsolete.  Digi provides a 2.6 driver (dgdm) at
> > http://www.digi.com for PCI cards.  They no longer maintain this driver,
> > and have no 2.6 driver for ISA cards.
>
> This driver is obsolete from the kernel at the point the new digi drivers
> are merged.
>
> > This driver requires a number of user-space tools.  They can be acquired from
> > http://www.digi.com, but only works with 2.4 kernels."
>
> So fix them or merge the newer digi drivers first.

ok, but what then does it mean to read that this driver:

1) *requires* a number of user-space tools, and
2) these tools don't work with the 2.6 kernel?

how then does this driver have any value under 2.6 if it requires
user-space support that doesn't exist for 2.6?

obviously, i'll withdraw the patch, but it's still a mystery to me how
that driver can have any value under a 2.6 kernel, just based on
what's written above.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
