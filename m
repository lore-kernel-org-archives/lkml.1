Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYCaJZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYCaJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYCaJZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:25:16 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53003 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYCaJZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:25:15 -0400
Date: Mon, 31 Mar 2008 12:25:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: rth@twiddle.net, ink@jurassic.park.msu.ru
Cc: linux-kernel@vger.kernel.org
Subject: alpha build errors with gcc 4.3
Message-ID: <20080331092501.GU28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only architecture that has serious problems when trying to build a 
kernel with gcc 4.3, and considering the usage of "extern inline" on 
this architecture problems with gcc 4.3 are somehow expected.

The build fails with:

<--  snip  -->

...
  CC      arch/alpha/kernel/traps.o
cc1: warnings being treated as errors
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:64,
                 from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/alpha/kernel/traps.c:12:
include2/asm/semaphore.h: In function 'down':
include2/asm/semaphore.h:133: error: '__down' is static but used in inline function 'down' which is not static
...
make[2]: *** [arch/alpha/kernel/traps.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

