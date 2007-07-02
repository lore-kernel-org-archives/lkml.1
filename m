Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXGBOXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXGBOXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXGBOWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:22:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58070 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXGBOWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:22:48 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 10:20:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eng.linux@digi.com
Subject: Re: [PATCH][RFC] Remove support for the orphaned, obsolete Digi EPCA
 driver.
In-Reply-To: <20070702151534.2728ae63@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0707021015340.20805@localhost.localdomain>
References: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain>
 <20070702144605.5cf99b3a@the-village.bc.nu> <Pine.LNX.4.64.0707020945290.18113@localhost.localdomain>
 <20070702151534.2728ae63@the-village.bc.nu>
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

> > > > This driver requires a number of user-space tools.  They can be acquired from
> > > > http://www.digi.com, but only works with 2.4 kernels."
> > >
> > > So fix them or merge the newer digi drivers first.
> >
> > ok, but what then does it mean to read that this driver:
> >
> > 1) *requires* a number of user-space tools, and
> > 2) these tools don't work with the 2.6 kernel?
>
> Last time I poked at the tools they were working under 2.6 with some
> trivial compile fixes. Ideally this driver would be trimmed to ISA
> only and the newer dgrs drivers merged but latter half appears to be
> something digi have no interest in

  ah, that wasn't obvious from the text.  in any event, there's still
some cosmetic cleanup that can be done if that driver's going to stick
around.

  first, from Documentation/ioctl-number.txt:

...
Documentation/ioctl-number.txt:'d'      F0-FF   linux/digi1.h
Documentation/ioctl-number.txt:'e'      all     linux/digi1.h           conflict!
...

there *is* no header file linux/digi1.h -- there is, however, a
drivers/char/digi1.h.

  also, there are references to a README.epca file in various places:

Documentation/kernel-parameters.txt:                    See drivers/char/README.epca and
Documentation/digiepca.txt:drivers/char/README.epca for more details.  Note,
drivers/char/epca.c:/* See README.epca for change history --DAT*/

but there is no README.epca file.  just a couple observations.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
