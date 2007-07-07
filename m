Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXGGCBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXGGCBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXGGCBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:01:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53183 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbXGGCBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:01:12 -0400
Date: Sat, 7 Jul 2007 04:01:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       jsipek@cs.sunysb.edu
Cc: linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: 2.6.22-rc6-mm1: UNION_FS=y + BLOCK=n = compile error
Message-ID: <20070707020142.GA3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
>  git-unionfs.patch
>...
>  git trees
>...

CONFIG_UNION_FS=y, CONFIG_BLOCK=n results in the following compile error:

<--  snip  -->

...
  CC      fs/unionfs/file.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/unionfs/file.c:147: error: ‘file_fsync’ undeclared here (not in a function)
make[3]: *** [fs/unionfs/file.o] Error 1
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

