Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXIAPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXIAPTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 11:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXIAPTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 11:19:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36644 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753500AbXIAPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 11:19:09 -0400
Date: Sat, 1 Sep 2007 17:19:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc4-mm1: two ktime_sub_ns() functions
Message-ID: <20070901151910.GH9260@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +ktime_sub_ns-analog-of-ktime_add_ns.patch
>...
>  netdev things
>...

One ktime_sub_ns() should be enough for everyone - and the net tree 
already adds one (even with a correct EXPORT_SYMBOL...).

<--  snip  -->

...
  CC      kernel/hrtimer.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/kernel/hrtimer.c:313: error: redefinition of 'ktime_sub_ns'
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/kernel/hrtimer.c:289: error: previous definition of 'ktime_sub_ns' was here
make[2]: *** [kernel/hrtimer.o] Error 1

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

