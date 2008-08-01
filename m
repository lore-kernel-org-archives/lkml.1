Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbYHAWcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbYHAWcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYHAWcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:32:00 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43168 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYHAWb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:31:59 -0400
Date: Sat, 2 Aug 2008 01:30:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: nAl Viro <viro@zeniv.linux.org.uk>, dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: mtdsuper.c BLOCK=n compile error
Message-ID: <20080801223056.GK19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d5686b444ff3f72808d2b3fbd58672a86cdf38e7
(switch mtd and dm-table to lookup_bdev()) causes
the following compile error with CONFIG_BLOCK=n:

<--  snip  -->

...
  CC      drivers/mtd/mtdsuper.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c: In function `get_sb_mtd':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c:184: error: implicit declaration of function 'lookup_bdev'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c:184: warning: assignment makes pointer from integer without a cast
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/mtd/mtdsuper.c:197: error: implicit declaration of function 'bdput'
make[3]: *** [drivers/mtd/mtdsuper.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

