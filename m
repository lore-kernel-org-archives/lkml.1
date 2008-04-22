Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbYDVSwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbYDVSwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbYDVSuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:50:04 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45176 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbYDVStz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:49:55 -0400
Date: Tue, 22 Apr 2008 21:49:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andy Fleming <afleming@freescale.com>, Jeff Garzik <jgarzik@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: drivers/net/ucc_geth.c compile error
Message-ID: <20080422184919.GE28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9d9326d3bc0ea9a8bbe40bf3e5e66c7b9858caa0
(phy: Change mii_bus id field to a string)
causes the following compile error:

<--  snip  -->

...
  CC      drivers/net/ucc_geth.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ucc_geth.c: In function 'ucc_geth_startup':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ucc_geth.c:2605: warning: assignment makes integer from pointer without a cast
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ucc_geth.c:2642: warning: assignment makes integer from pointer without a cast
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ucc_geth.c: In function 'ucc_geth_probe':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/ucc_geth.c:3935: error: incompatible types in assignment
make[3]: *** [drivers/net/ucc_geth.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

