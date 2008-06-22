Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYFVIzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYFVIzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 04:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYFVIzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 04:55:38 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59678 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYFVIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 04:55:03 -0400
Date: Sun, 22 Jun 2008 11:53:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org
Subject: alpha build failure
Message-ID: <20080622085313.GC27069@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9267b4b3880d00dc2dab90f1d817c856939114f7
(alpha: fix module load failures on smp (bug #10926))
causes the following build failure with the alpha defconfig:

<--  snip  -->

...
  CC      arch/alpha/mm/init.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/alpha/mm/init.c:34: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'typeof'
make[2]: *** [arch/alpha/mm/init.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

