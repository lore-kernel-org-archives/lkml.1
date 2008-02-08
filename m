Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbYBHWZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbYBHWZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYBHWZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:25:01 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33448 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYBHWZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:25:00 -0500
Date: Sat, 9 Feb 2008 00:25:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, gerg@uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: m68knommu compile error
Message-ID: <20080208222516.GC6505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 breaks m68knommu:

<--  snip  -->

...
  CC      init/main.o
In file included from include2/asm/uaccess.h:8,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/poll.h:13,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/rtc.h:113,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/efi.h:19,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:43:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:1151: 
error: expected declaration specifiers or '...' before 'pgtable_t'
make[2]: *** [init/main.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

