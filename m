Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbYBGXNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbYBGXNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbYBGXMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:12:22 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51663 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274AbYBGXMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:12:20 -0500
Date: Fri, 8 Feb 2008 01:12:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: parisc compile error
Message-ID: <20080207231232.GF7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e2779fa281cfda13ac060753d674bbcaa23367e broke parisc:

<--  snip  -->

...
  CC      arch/parisc/kernel/asm-offsets.s
In file included from include/asm/pgtable.h:13,
                 from arch/parisc/kernel/asm-offsets.c:36:
include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:243: error: 'VMALLOC_START' undeclared (first use in this function)
include/linux/mm.h:243: error: (Each undeclared identifier is reported only once
include/linux/mm.h:243: error: for each function it appears in.)
include/linux/mm.h:243: error: 'VMALLOC_END' undeclared (first use in this function)
make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

