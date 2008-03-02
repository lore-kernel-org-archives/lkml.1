Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbYCBVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbYCBVgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbYCBVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:36:39 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45017 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbYCBVgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:36:38 -0500
Date: Sun, 2 Mar 2008 23:35:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stuart Menefy <stuart.menefy@st.com>, Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh r7780mp_defconfig compile error
Message-ID: <20080302213506.GD25484@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d02b08f6e8b184ffef349e395210a5e82ff4f4bc causes the following 
compile error with r7780mp_defconfig:

<--  snip  -->

...
  CC      init/main.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/clocksource.h:18,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/clockchips.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/tick.h:9,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:44:
include2/asm/io.h: In function '__ioremap_mode':
include2/asm/io.h:331: error: implicit declaration of function 'P1SEGADDR'
include2/asm/io.h:333: error: implicit declaration of function 'P2SEGADDR'
make[2]: *** [init/main.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

