Return-Path: <linux-kernel-owner+w=401wt.eu-S1751067AbZEMEBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbZEMEBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbZEMEBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:01:37 -0400
Received: from [76.245.85.235] ([76.245.85.235]:58698 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZEMEBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:01:37 -0400
X-Greylist: delayed 1824 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 May 2009 00:01:36 EDT
Date: Tue, 12 May 2009 20:30:27 -0700
From: Brad Boyer <flar@allandria.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Message-ID: <20090513033027.GA13193@cynthia.pants.nu>
References: <20090511222702.352192505@arndb.de> <200905112238.55404.arnd@arndb.de> <20090512090602.65722342@lxorguk.ukuu.org.uk> <200905121123.21436.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905121123.21436.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 11:23:20AM +0200, Arnd Bergmann wrote:
> Currently, the only architectures that don't set HAS_DMA are h8300, m32r
> m68k (except SUN3 and Coldfire), microblaze and s390.
> s390 will never get it, microblaze is currently implementing dma-mapping.h.
> 
> The other three are still using drivers/ide instead of drivers/ata.
> 
> One way to fix this would be to implement dma-mapping.h in h8300, m32r and
> m68k and leave !HAS_DMA as the obscure s390 case (this one already can't
> use ATA because of !HAS_MMIO).

If I'm reading the m68k code correctly, SUN3 is the one that doesn't have
DMA. It is implemented on any m68k with a standard Motorola MMU. It might
be possible to get the DMA code working on a sun3, but I doubt they ever
have IDE hardware.

	Brad Boyer
	flar@allandria.com

