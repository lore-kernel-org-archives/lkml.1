Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbYEHWF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbYEHWF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762397AbYEHWFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:05:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46219 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764402AbYEHWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:05:04 -0400
Date: Fri, 9 May 2008 01:03:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh cayman_defconfig build error
Message-ID: <20080508220334.GF22887@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent gcc versions (I'm using 4.3) the compilation of 
cayman_defconfig fails with the following error:

<--  snip  -->

...
  CC      arch/sh/kernel/signal_64.o
cc1: warnings being treated as errors
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/signal_64.c: In function 'setup_frame':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/signal_64.c:477: error: cast from pointer to integer of different size
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/signal_64.c: In function 'setup_rt_frame':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/signal_64.c:595: error: cast from pointer to integer of different size
make[2]: *** [arch/sh/kernel/signal_64.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

