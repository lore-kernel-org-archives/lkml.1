Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbYHAV3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbYHAV3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761343AbYHAV2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:28:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41285 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763251AbYHAV2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:28:31 -0400
Date: Sat, 2 Aug 2008 00:27:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: sam@ravnborg.org, lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh O= builds broken
Message-ID: <20080801212728.GF19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most likely caused by the headers move:

<--  snip  -->

...
  CC      init/main.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/irq.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/irq.h:23,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/hardirq.h:5,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hardirq.h:7,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/local.h:5,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/local.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/module.h:19,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:13:
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/machvec.h:15:27: 
error: asm/machtypes.h: No such file or directory
make[2]: *** [init/main.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

