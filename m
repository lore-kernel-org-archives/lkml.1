Return-Path: <linux-kernel-owner+w=401wt.eu-S1763273AbXJOJzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763273AbXJOJzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXJOJzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:55:40 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:55093 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897AbXJOJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:55:39 -0400
Date: Mon, 15 Oct 2007 10:55:36 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: -git mips defconfig compile error
Message-ID: <20071015095535.GB9896@linux-mips.org>
References: <20071014131948.GF4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071014131948.GF4211@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 03:19:48PM +0200, Adrian Bunk wrote:

> Commit 05dc8c02bf40090e9ed23932b1980ead48eb8870 causes the following 
> compile error with the mips defconfig:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/video/logo/logo.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c: In function 'fb_find_logo':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: 'mips_machgroup' undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: for each function it appears in.)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: 'MACH_GROUP_SGI' undeclared (first use in this function)
> make[4]: *** [drivers/video/logo/logo.o] Error 1
> 
> <--  snip  -->
> 
> It seems the drivers/net/jazzsonic.c and drivers/video/logo/logo.c parts 
> that are part of the corresponding commit in the mips git tree got lost
> somewhere.

The logo.c bit I've sent out a few weeks ago so I'm just waiting for that
patch to resurface at the other end of the wormhole.

The jazzsonic breakage was caused by the not very well done "[NET]:
Introduce and use print_mac() and DECLARE_MAC_BUF()" patch aka
0795af5729b18218767fab27c44b1384f72dc9ad.

(No need to mail me about build failures of default configurations; there
is an autobuilder building them regularly ...)

  Ralf
