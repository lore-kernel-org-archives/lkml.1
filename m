Return-Path: <linux-kernel-owner+w=401wt.eu-S934369AbXGZTmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934369AbXGZTmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764506AbXGZTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:41:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:47091 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763521AbXGZTlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:41:51 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/eMtwnwP7exn/FT3xIA86Ot50zN08Tbr5K36cVtf
	qWkLPubLXGanEn
Date: Thu, 26 Jul 2007 21:41:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
In-Reply-To: <20070725213925.2f25906c@the-village.bc.nu>
Message-ID: <Pine.LNX.4.60.0707262136530.6614@poirot.grange>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
 <Pine.LNX.4.60.0707252130090.6234@poirot.grange> <20070725213925.2f25906c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Alan Cox wrote:

> > driver to using platform-device. I got a reply, that it's not worth it now 
> > that IDE is slowly becoming obsolete, and the pata_platform serves the 
> > perpose perfectly well. I found this argument reasonable, I had the same 
> > doubt, just wanted to double-check. So, why do we now need a new legacy 
> > (a/drivers/ide/legacy/ide_platform.c) driver when a "modern" driver 
> > exists?
> 
> We don't *need* it but some people still want to use old IDE and the
> author was willing to make it neatly compatible so that anything that
> works with the pata_platform should be able to use the ide_platform
> driver and vice versa. For the shorter term that can only be a good thing
> - arch code doesn't need to care about which driver is used, end users
> can pick and it doesn't end up adding new ties between code and old IDE.

Ok, thanks for the explanation Alan. So, there's no technical argument, 
just "being nice to the users", and add a new driver, which we know we'll 
have to remove soon, thus having to persuade its users, who by that time 
will get used to it and will not want to invest money into switching to 
another one...

Thanks
Guennadi
---
Guennadi Liakhovetski
