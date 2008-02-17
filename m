Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYBQULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYBQULu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbYBQUKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:10:23 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:44204 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbYBQUKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:10:16 -0500
Date: Sun, 17 Feb 2008 22:09:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips/bcm47xx/setup.c compile error
Message-ID: <20080217200947.GH1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d3c319f9c8d9ee2c042c60b8a1bbd909dcc42782 causes the following 
compile error:

<--  snip  -->

...
  CC      arch/mips/bcm47xx/setup.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c: In function 'bcm47xx_get_invariants':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:95: error: 'struct ssb_sprom' has no member named 'r1'
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:97: error: 'struct ssb_sprom' has no member named 'r1'
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:99: error: 'struct ssb_sprom' has no member named 'r1'
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:101: error: 'struct ssb_sprom' has no member named 'r1'
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:103: error: 'struct ssb_sprom' has no member named 'r1'
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/bcm47xx/setup.c:105: error: 'struct ssb_sprom' has no member named 'r1'
make[2]: *** [arch/mips/bcm47xx/setup.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

