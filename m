Return-Path: <linux-kernel-owner+w=401wt.eu-S934580AbXGYSW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbXGYSW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763395AbXGYSWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:22:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44205 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758316AbXGYSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:22:47 -0400
Date: Wed, 25 Jul 2007 20:22:21 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: 2.6.23-rc1-mm1: reiser4 <-> lzo compile error
Message-ID: <20070725182221.GG3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<--  snip  -->

...
  LD      .tmp_vmlinux1
lib/built-in.o: In function `lzo1x_1_compress':
(.text+0x13eae): multiple definition of `lzo1x_1_compress'
fs/built-in.o:(.text+0x117075): first defined here
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

AFAIR, we once had a patch in -mm changing reiser4 to use the
LZO code that is now in the kernel?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

