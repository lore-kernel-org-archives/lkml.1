Return-Path: <linux-kernel-owner+w=401wt.eu-S1765989AbXHXTHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765989AbXHXTHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761720AbXHXTHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:07:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49022 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757610AbXHXTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:07:38 -0400
Date: Fri, 24 Aug 2007 20:15:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: postfail@hushmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] /drivers/char sx.c ioremap -> pci_ioremap api
Message-ID: <20070824201530.5d741b37@the-village.bc.nu>
In-Reply-To: <4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com>
References: <46CF2849.2090008@gmail.com>
	<4af2d03a0708241159v56b46299h46df9777a98590e5@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ase, 0x80);
> 
> remove also the hwbase var.
> 
> > +	rebase = pci_iomap(pdev, 0, 0x80);
> >   	t = readl(rebase + CNTRL_REG_OFFSET);

Switch to ioread* if you are using the iomap interface. Its not a trivial
conversion and its slower and bulkier - the original ioremap was much
better

NAK this change therefore
