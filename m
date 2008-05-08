Return-Path: <linux-kernel-owner+w=401wt.eu-S1764597AbYEHUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764597AbYEHUl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbYEHUlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:41:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60137 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbYEHUlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:41:14 -0400
Date: Thu, 8 May 2008 23:39:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh migor_defconfig build breakage
Message-ID: <20080508203949.GC22887@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aa6b54461cc5c0019b9d792adf3176b444c10763
(asm-generic: add node_to_cpumask_ptr macro)
causes the following build error with migor_defconfig:

<--  snip  -->

...
  CC      arch/sh/kernel/asm-offsets.s
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:8,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/asm-offsets.c:13:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h: In function 'alloc_pages_node':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:190: 
error: implicit declaration of function 'cpu_to_node'
make[2]: *** [arch/sh/kernel/asm-offsets.s] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

