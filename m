Return-Path: <linux-kernel-owner+w=401wt.eu-S932365AbXF2AGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbXF2AGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbXF2AG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:06:26 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4898 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbXF2AGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:06:25 -0400
Date: Fri, 29 Jun 2007 02:06:36 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
In-Reply-To: <20070629001244.3ce09917@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706290202480.1817@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
 <20070628110644.a530cfef.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282017450.30789@anakin>
 <20070628113819.c24e592d.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282044360.30789@anakin>
 <20070628132947.e3378811.akpm@linux-foundation.org> <20070628232537.02ced21c@the-village.bc.nu>
 <Pine.LNX.4.64.0706290048290.1817@scrub.home> <20070629001244.3ce09917@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 29 Jun 2007, Alan Cox wrote:

> > > check_signature is relevant for anything with MMIO space (for example you
> > > can legitimately want to check_signature a MAC68K Nubus ROM).
> > 
> > A generic check_signature() is a little difficult if we have separate io 
> > functions for every bus.
> 
> Does M68K implement iomap() and pci_iomap and friends yet ?

How is that related?

> check_signature has fairly few users so moving to be iomap based wouldn't
> be hard if that was a problem. The other option would seem to be
> bus->check_signature() ?

IMO the first question would be whether that function is really this 
important. We can also just leave it as a PCI/ISA template and other bus 
specific header can implement when necessary.

bye, Roman
