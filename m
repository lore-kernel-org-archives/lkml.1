Return-Path: <linux-kernel-owner+w=401wt.eu-S1763562AbYBZRgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763562AbYBZRgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762290AbYBZRgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:36:41 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55952 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbYBZRgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:36:40 -0500
Date: Tue, 26 Feb 2008 19:35:36 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org
Subject: h8300 drivers/serial/sh-sci.c compile error
Message-ID: <20080226173536.GC8287@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e108b2ca2349f510ce7d7f910eda89f71d710d84 broke the compilation of 
drivers/serial/sh-sci.c on h8300:

<--  snip  -->

...
  CC      drivers/serial/sh-sci.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/sh-sci.c:57:21: error: asm/sci.h: No such file or directory
...
make[3]: *** [drivers/serial/sh-sci.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

