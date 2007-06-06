Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbXFFHse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbXFFHse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXFFHs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:48:26 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:50013 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXFFHs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:48:26 -0400
Date: Wed, 6 Jun 2007 10:48:23 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: alpha compile failure (srm_printk)
In-Reply-To: <20070605231712.ff1df46f.akpm@linux-foundation.org>
Message-ID: <Pine.SOC.4.64.0706061045280.449@math>
References: <Pine.SOC.4.64.0706041419470.7370@math>
 <20070605231712.ff1df46f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > While trying make boot bootimage with 2.6.22-rc3 + todays git, the 
> > compilation fails with
> > 
> >   CC      arch/alpha/boot/main.o
> > arch/alpha/boot/main.c: In function 'load':arch/alpha/boot/main.c:135: warning: passing argument 3 of 'callback_read' makes pointer from integer without a cast
> >   LD      arch/alpha/boot/bootloader
> > arch/alpha/boot/bootloader.lds:25: undefined symbol `srm_printk' referenced in expression
> > 
> > This my first selfcompiled kernel for alpha so my config might be 
> > faulty:
> 
> I was unable to repeoduce these errors on 2.6.22-rc4 with your config.

Hmm. Using
gcc version 4.1.3 20070601 (prerelease) (Debian 4.1.2-11)
GNU ld (GNU Binutils for Debian) 2.17.50.20070426
bintuils package 2.17cvs20070426-8

-- 
Meelis Roos (mroos@linux.ee)
