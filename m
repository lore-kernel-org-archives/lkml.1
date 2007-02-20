Return-Path: <linux-kernel-owner+w=401wt.eu-S965624AbXBTANy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965624AbXBTANy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbXBTAIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:08:10 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36147 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965598AbXBTAIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:08:04 -0500
Date: Tue, 20 Feb 2007 01:08:03 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.20-mm2: BLOCK=n compile error
Message-ID: <20070220000803.GI13958@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm1:
>...
>  git-block.patch
>...
>  git trees
>...


This causes the following compile error with CONFIG_BLOCK=n:

<--  snip  -->

...
  CC      kernel/sched.o
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/kernel/sched.c:1835: warning: no previous prototype for 'schedule_tail'
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/kernel/sched.c: In function 'schedule':
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/kernel/sched.c:3466: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/kernel/sched.c:3467: error: implicit declaration of function 'blk_replug_current_nested'
make[2]: *** [kernel/sched.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

