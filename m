Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbYBGXMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbYBGXMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYBGXMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:12:20 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59474 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbYBGXMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:12:18 -0500
Date: Fri, 8 Feb 2008 01:12:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Rientjes <rientjes@google.com>, wli@holomorphy.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: sparc compile error
Message-ID: <20080207231230.GE7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3062fc67dad01b1d2a15d58c709eff946389eca4 broke sparc:

<--  snip  -->

...
  CC      init/do_mounts.o
In file included from include/linux/mm.h:39,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:7,
                 from init/do_mounts.c:6:
include/asm/pgtable.h:344: warning: parameter names (without types) in function declaration
include/asm/pgtable.h:345: warning: parameter names (without types) in function declaration
include/asm/pgtable.h:346: error: expected '=', ',', ';', 'asm' or '__attribute__' before '___f___swp_entry'
make[1]: *** [init/do_mounts.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

