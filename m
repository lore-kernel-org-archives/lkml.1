Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbYEYTBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbYEYTBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbYEYTA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:00:59 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56320 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756761AbYEYTA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:00:58 -0400
Date: Sun, 25 May 2008 21:58:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: CONFIG_SPARC64_PAGE_SIZE_4MB build error
Message-ID: <20080525185821.GJ1791@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a compile test I ran into the following build error caused with 
CONFIG_SPARC64_PAGE_SIZE_4MB:

<--  snip  -->

...
  CC      init/main.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/slab.h:12,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/percpu.h:5,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/rcupdate.h:39,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pid.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:74,
                 from include2/asm/uaccess.h:10,
                 from include2/asm/elf.h:10,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/elf.h:7,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/module.h:14,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:13:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mmzone.h:853:2: 
error: #error Allocator MAX_ORDER exceeds SECTION_SIZE
make[2]: *** [init/main.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

