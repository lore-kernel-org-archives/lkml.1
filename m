Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYEYQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYEYQp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYEYQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:45:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48215 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbYEYQpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:45:47 -0400
Date: Sun, 25 May 2008 19:43:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Chris Dearman <chris@mips.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips/kernel/traps.c build error
Message-ID: <20080525164311.GB1791@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 39b8d5254246ac56342b72f812255c8f7a74dca9
([MIPS] Add support for MIPS CMP platform.)
causes the following build error:

<--  snip  -->

...
  CC      arch/mips/kernel/traps.o
cc1: warnings being treated as errors
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/traps.c: In function 'show_raw_backtrace':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/kernel/traps.c:92: error: cast from pointer to integer of different size
make[2]: *** [arch/mips/kernel/traps.o] Error 1

<--  snip  -->

"[MIPS] Fix check for valid stack pointer during backtrace" in the mips 
tree fixes it, and should therefore also go into 2.6.26.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

