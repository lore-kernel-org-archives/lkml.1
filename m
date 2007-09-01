Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbXIAP1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbXIAP1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 11:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXIAP1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 11:27:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:40647 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753680AbXIAP1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 11:27:42 -0400
Date: Sat, 1 Sep 2007 17:27:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc: sched.c vs. xtensa: RSR redefined
Message-ID: <20070901152743.GI9260@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Although it seems to pick the right version the following namespace 
conflict should be resolved:

<--  snip  -->

...
  CC      kernel/sched.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/kernel/sched.c:676:1: warning: "RSR" redefined
In file included from include2/asm/bitops.h:18,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/bitops.h:17,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/thread_info.h:20,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/preempt.h:9,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/spinlock.h:49,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/mmzone.h:7,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/gfp.h:4,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/mm.h:8,
                 from 
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/kernel/sched.c:27:
include2/asm/processor.h:194:1: warning: this is the location of the previous definition
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

