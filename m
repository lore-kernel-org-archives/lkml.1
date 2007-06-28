Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbXF1Wpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbXF1Wpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763129AbXF1Wpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:45:33 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49365 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbXF1Wpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:45:32 -0400
Date: Thu, 28 Jun 2007 18:45:11 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-ID: <20070628224511.GA12447@c2.user-mode-linux.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070628133715.GA4343@osiris.boeblingen.de.ibm.com> <20070628110644.a530cfef.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282017450.30789@anakin> <20070628113819.c24e592d.akpm@linux-foundation.org> <Pine.LNX.4.64.0706282044360.30789@anakin> <20070628132947.e3378811.akpm@linux-foundation.org> <20070628232537.02ced21c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628232537.02ced21c@the-village.bc.nu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 11:25:37PM +0100, Alan Cox wrote:
> This completely bogus. readb() should be present on M68K, fix the
> platform to implement readb() for MMIO, even if your MMIO readb is a
> moveb instruction.
> 
> check_signature is relevant for anything with MMIO space (for example you
> can legitimately want to check_signature a MAC68K Nubus ROM).
> 
> S/390 is a bit of a special case as no S/390 usage of check_signature
> appears sane but equally it isn't used so you can stub it out.

This is a problem for UML too.

I have a patch in my tree, which basically stubs readb, waiting to see
how this is fixed for the other arches.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
