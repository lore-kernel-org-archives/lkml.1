Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbXEEWcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbXEEWcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXEEWcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:32:31 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2860 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXEEWc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:32:29 -0400
Date: Sat, 5 May 2007 18:25:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.21-mm1
Message-ID: <20070505222501.GD23938@tuxdriver.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463CA74C.8080008@gmail.com> <20070505114811.f824c902.akpm@linux-foundation.org> <200705052348.49994.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705052348.49994.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 11:48:49PM +0200, Michael Buesch wrote:
> On Saturday 05 May 2007 20:48:11 Andrew Morton wrote:
> > On Sat, 05 May 2007 17:48:28 +0200 Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> > 
> > > Andrew Morton pisze:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > > > 
> > > > 
> > > 
> > > CC [M]  lib/zlib_deflate/deflate_syms.o
> > >   LD [M]  lib/zlib_deflate/zlib_deflate.o
> > >   Building modules, stage 2.
> > >   MODPOST 791 modules
> > > ERROR: "ssb_pcihost_register" [drivers/net/b44.ko] undefined!
> > > ERROR: "ssb_pcihost_unregister" [drivers/net/b44.ko] undefined!
> > > make[2]: *** [__modpost] Error 1
> > > make[1]: *** [modules] Error 2
> > > make[1]: Leaving directory `/usr/src/linux-mm'
> > > make: *** [debian/stamp-build-kernel] Error 2
> 
> config B44_PCI
> 	bool "Broadcom 4400 PCI device support"
> 	depends on B44 && NET_PCI
> 
> We simply need a SELECT SSB_PCIHOST here. Not sure why it's not there.
> I thought it used to be there.

That may have only been applied to the mm-master branch, which now
no longer exists.  I'll patch it now.

John
-- 
John W. Linville
linville@tuxdriver.com
