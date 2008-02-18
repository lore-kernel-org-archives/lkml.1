Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYBRAnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYBRAnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 19:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYBRAnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 19:43:16 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53962 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390AbYBRAnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 19:43:16 -0500
Date: Mon, 18 Feb 2008 02:42:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips yosemite_defconfig compile error
Message-ID: <20080218004246.GN1403@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e2779fa281cfda13ac060753d674bbcaa23367e also broke the
mips yosemite_defconfig:

<--  snip  -->

...
  CC      arch/mips/kernel/asm-offsets.s
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/asm-offsets.c:14:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h: In function 'is_vmalloc_addr':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:243: error: 'PKMAP_BASE' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:243: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:243: error: for each function it appears in.)
make[2]: *** [arch/mips/kernel/asm-offsets.s] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

