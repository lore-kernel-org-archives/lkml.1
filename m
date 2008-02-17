Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYBQUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYBQUMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbYBQUK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:10:28 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53482 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbYBQUKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:10:22 -0500
Date: Sun, 17 Feb 2008 22:09:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>,
       Jean Delvare <khali@linux-fr.org>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips SMBUS_PSC_BASE compile errors
Message-ID: <20080217200953.GJ1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8b798c4d16b762d15f4055597ff8d87f73b35552 causes compile errors 
like the following for several system types:

<--  snip  -->

...
  CC      arch/mips/au1000/common/platform.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/au1000/common/platform.c:277: error: 'PSC0_BASE_ADDR' undeclared here (not in a function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/au1000/common/platform.c:314: warning: no previous prototype for 'au1xxx_platform_init'
make[2]: *** [arch/mips/au1000/common/platform.o] Error 1

<--  snip  -->

One or more #include <asm/mach-au1x00/au1xxx_psc.h>'s at the right 
places seem to be the correct solution, but I don't understand the mips 
subarch setup good enough for knowing where to place them.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

