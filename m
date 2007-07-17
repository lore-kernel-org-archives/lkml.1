Return-Path: <linux-kernel-owner+w=401wt.eu-S934875AbXGQSD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbXGQSD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXGQSDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:03:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933715AbXGQSDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:03:35 -0400
Date: Tue, 17 Jul 2007 11:03:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Jeff Dike <jdike@addtoit.com>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
In-Reply-To: <Pine.LNX.4.64.0707171842590.10600@anakin>
Message-ID: <alpine.LFD.0.999.0707171102040.19166@woody.linux-foundation.org>
References: <200707161802.l6GI2tNp007390@hera.kernel.org>
 <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org>
 <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org>
 <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
 <20070717163328.GG7965@c2.user-mode-linux.org>
 <Pine.LNX.4.64.0707171842590.10600@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Geert Uytterhoeven wrote:
> 
> M68k uses I/O memory for all I/O (hence it sets CONFIG_HAS_IOMEM), but
> many m68k machines don't have PCI or ISA (hence it doesn't set
> CONFIG_PCI resp. CONFIG_ISA).

It doesn't matter whether the machine has PCI or ISA. The only thing that 
matters is whether the thing compiles (which in turn depends on whether it 
has "readb()", which in turn is what HAS_IOMEM is all about).

So I do think that HAS_IOMEM is the right thing here.

		Linus
