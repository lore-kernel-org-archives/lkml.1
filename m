Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYBFPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYBFPSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYBFPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:18:23 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59252 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYBFPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:18:22 -0500
Date: Wed, 6 Feb 2008 17:18:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Matt Mackall <mpm@selenic.com>, bryan.wu@analog.com
Cc: linux-kernel@vger.kernel.org
Subject: blackfin compile error
Message-ID: <20080206151830.GI505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773 broke blackfin:

<--  snip  -->

...
  CC      mm/vmscan.o
In file included from 
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/vmscan.c:44:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h: In function 'is_swap_pte':
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_none'
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/swapops.h:48: error: implicit declaration of function 'pte_present'
make[2]: *** [mm/vmscan.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

