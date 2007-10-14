Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXJNNT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXJNNT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 09:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXJNNTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 09:19:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46640 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751419AbXJNNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 09:19:19 -0400
Date: Sun, 14 Oct 2007 15:19:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: -git mips defconfig compile error
Message-ID: <20071014131948.GF4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 05dc8c02bf40090e9ed23932b1980ead48eb8870 causes the following 
compile error with the mips defconfig:

<--  snip  -->

...
  CC      drivers/video/logo/logo.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c: In function 'fb_find_logo':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: 'mips_machgroup' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/video/logo/logo.c:91: error: 'MACH_GROUP_SGI' undeclared (first use in this function)
make[4]: *** [drivers/video/logo/logo.o] Error 1

<--  snip  -->

It seems the drivers/net/jazzsonic.c and drivers/video/logo/logo.c parts 
that are part of the corresponding commit in the mips git tree got lost
somewhere.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

