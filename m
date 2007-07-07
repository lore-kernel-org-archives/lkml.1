Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbXGGVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbXGGVLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbXGGVLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:11:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53834 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755865AbXGGVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:11:10 -0400
Date: Sat, 7 Jul 2007 23:11:41 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>, Miles Bader <miles@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: arch/v850/kernel/time.c compile error
Message-ID: <20070707211141.GO3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation on v850 fails with the following error (since 2.6.19):

<--  snip  -->

...
  CC      arch/v850/kernel/time.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/time.c: In function 'timer_interrupt':
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/time.c:49: error: too many arguments to function 'profile_tick'
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/time.c: At top level:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/v850/kernel/time.c:95: warning: initialization from incompatible pointer type
make[2]: *** [arch/v850/kernel/time.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

