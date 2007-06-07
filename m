Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbXFGHNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbXFGHNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759849AbXFGHNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:13:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45237 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957AbXFGHNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:13:08 -0400
Date: Thu, 7 Jun 2007 00:12:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070607001218.742c0ba5.akpm@linux-foundation.org>
In-Reply-To: <20070607070108.GA8013@gondor.apana.org.au>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<200706062132.37430.m.kozlowski@tuxland.pl>
	<20070606132439.3f59f0cf.akpm@linux-foundation.org>
	<20070606212831.GA1534@gondor.apana.org.au>
	<20070606164202.a3dcd176.akpm@linux-foundation.org>
	<Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
	<20070607070108.GA8013@gondor.apana.org.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 17:01:08 +1000 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Thu, Jun 07, 2007 at 08:54:50AM +0200, Jan Engelhardt wrote:
> > 
> > /me points at Herbert
> > Andrew would not add options between the "menuconfig CRYPTO" and
> > the "if CRYPTO" line... :)
> 
> Actually this patch is not even in my tree :)

uh, OK, sorry.

> > Index: linux-2.6.22-rc4/crypto/Kconfig
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/crypto/Kconfig
> > +++ linux-2.6.22-rc4/crypto/Kconfig
> > @@ -7,6 +7,8 @@ menuconfig CRYPTO
> >  	help
> >  	  This option provides the core Cryptographic API.
> >  
> > +if CRYPTO
> > +
> >  #
> >  # Generic algorithms support
> >  #
> > @@ -18,8 +20,6 @@ config XOR_BLOCKS
> >  #
> >  source "crypto/async_tx/Kconfig"
> 
> Andrew, do you want me to pick the async_tx stuff up instead?
> 

I wouldn't recommend it.  It's an ongoing source of bustage frankly, has a
habit of getting unpleasantly tangled with git-ioat.patch and afaik is
still awaiting a go-ahead from Neil.

