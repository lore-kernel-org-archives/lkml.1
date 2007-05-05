Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbXEEVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbXEEVtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbXEEVtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:49:10 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41222
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962AbXEEVtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:49:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1
Date: Sat, 5 May 2007 23:48:49 +0200
User-Agent: KMail/1.9.6
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <463CA74C.8080008@gmail.com> <20070505114811.f824c902.akpm@linux-foundation.org>
In-Reply-To: <20070505114811.f824c902.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705052348.49994.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2007 20:48:11 Andrew Morton wrote:
> On Sat, 05 May 2007 17:48:28 +0200 Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> 
> > Andrew Morton pisze:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > > 
> > > 
> > 
> > CC [M]  lib/zlib_deflate/deflate_syms.o
> >   LD [M]  lib/zlib_deflate/zlib_deflate.o
> >   Building modules, stage 2.
> >   MODPOST 791 modules
> > ERROR: "ssb_pcihost_register" [drivers/net/b44.ko] undefined!
> > ERROR: "ssb_pcihost_unregister" [drivers/net/b44.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> > make[1]: *** [modules] Error 2
> > make[1]: Leaving directory `/usr/src/linux-mm'
> > make: *** [debian/stamp-build-kernel] Error 2

config B44_PCI
	bool "Broadcom 4400 PCI device support"
	depends on B44 && NET_PCI

We simply need a SELECT SSB_PCIHOST here. Not sure why it's not there.
I thought it used to be there.

-- 
Greetings Michael.
