Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZEMEf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZEMEf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZEMEfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:35:10 -0400
Received: from [76.245.85.235] ([76.245.85.235]:41152 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZEMEfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:35:09 -0400
Date: Tue, 12 May 2009 21:34:09 -0700
From: Brad Boyer <flar@allandria.com>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Message-ID: <20090513043409.GA13577@cynthia.pants.nu>
References: <20090511222702.352192505@arndb.de> <200905112238.55404.arnd@arndb.de> <20090512090602.65722342@lxorguk.ukuu.org.uk> <200905121123.21436.arnd@arndb.de> <20090513033027.GA13193@cynthia.pants.nu> <alpine.DEB.1.00.0905130610240.18305@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0905130610240.18305@zirkon.biophys.uni-duesseldorf.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 06:12:31AM +0200, Michael Schmitz wrote:
> The Atari IDE interface does not use DMA. I don't see what addition of DMA 
> mapping for IDE would achieve. 

The macide driver doesn't support anything with DMA hardware either. In
fact, no m68k Macintosh has both DMA capability and an IDE controller.
However, we do support the basic DMA routines on the main m68k platforms.
It's just not used for IDE. I think the proposed change was to require
that the DMA routines be present, not that the IDE ports actually have
to have a DMA capability.

> If it doesn't interfere with plain PIO mode, fine. 

I agree. There definitely needs to still be support for IDE ports that
don't have DMA capability.

	Brad Boyer
	flar@allandria.com

