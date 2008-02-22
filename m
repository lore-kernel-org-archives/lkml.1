Return-Path: <linux-kernel-owner+w=401wt.eu-S935272AbYBVULp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272AbYBVULp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934979AbYBVUKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:10:09 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53191 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbYBVUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:10:05 -0500
Date: Fri, 22 Feb 2008 22:09:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: xtansa common_defconfig compile error
Message-ID: <20080222200916.GO1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to compile common_defconfig fails with the following error:

<--  snip  -->

...
  CC      init/main.o
In file included from include2/asm/hardirq.h:15,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hardirq.h:7,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/local.h:5,
                 from include2/asm/local.h:14,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/module.h:19,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:13:
include2/asm/irq.h:14:35: error: asm/platform/hardware.h: No such file or directory
make[2]: *** [init/main.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

