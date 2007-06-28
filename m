Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbXF1XGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbXF1XGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763604AbXF1XGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:06:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48528 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759911AbXF1XGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:06:42 -0400
Date: Fri, 29 Jun 2007 00:12:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-ID: <20070629001244.3ce09917@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0706290048290.1817@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
	<20070628110644.a530cfef.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282017450.30789@anakin>
	<20070628113819.c24e592d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282044360.30789@anakin>
	<20070628132947.e3378811.akpm@linux-foundation.org>
	<20070628232537.02ced21c@the-village.bc.nu>
	<Pine.LNX.4.64.0706290048290.1817@scrub.home>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > check_signature is relevant for anything with MMIO space (for example you
> > can legitimately want to check_signature a MAC68K Nubus ROM).
> 
> A generic check_signature() is a little difficult if we have separate io 
> functions for every bus.

Does M68K implement iomap() and pci_iomap and friends yet ?
check_signature has fairly few users so moving to be iomap based wouldn't
be hard if that was a problem. The other option would seem to be
bus->check_signature() ?

Alan
