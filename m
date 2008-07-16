Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYGPLOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYGPLOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYGPLOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:14:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:44348 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYGPLOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:14:35 -0400
Subject: Re: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Dave Jones <davej@redhat.com>,
       akpm <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <200807161051.12545.arnd@arndb.de>
References: <1216172043.7740.136.camel@pasglop>
	 <20080716042042.GA13212@redhat.com>  <200807161051.12545.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 21:13:44 +1000
Message-Id: <1216206824.7740.172.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 10:51 +0200, Arnd Bergmann wrote:
> On Wednesday 16 July 2008, Dave Jones wrote:
> > arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
> > /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
> > /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'
> 
> FS_ENET and EP8248E both select MDIO_BITBANG, but not PHYLIB or MII, which
> looks broken to me.
> 
> Also, I think it would be useful to split out the bitbang
> driver from ep8248e.c, so that you can build it as a loadable
> module if you want to have PHYLIB loadable.

On that note... I already run it through an autobuilder with a bunch of
configs before uploading (though obviously not this one). Kumar, can you
send me 2 or 3 configs you believe cover a reasonable range of the fsl
stuff that I could stick into my list for next time ?

Cheers,
Ben.

