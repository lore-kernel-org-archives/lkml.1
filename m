Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYDEK3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYDEK3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 06:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYDEK3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 06:29:31 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:35292 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYDEK3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 06:29:30 -0400
Date: Sat, 5 Apr 2008 13:24:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, sct@redhat.com,
       akpm@linux-foundation.org, adilger@clusterfs.com, geert@linux-m68k.org,
       zippel@linux-m68k.org
Cc: linux-ext4@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: ext4 compile error on m68k
Message-ID: <20080405102408.GB30987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aa02ad67d9b308290fde390682cd039b29f7ab85
"ext4: Add ext4_find_next_bit()" causes the following regression:

<--  snip  -->

...
  CC [M]  fs/ext4/mballoc.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c:696: error: implicit declaration of function 'generic_find_next_le_bit'
make[3]: *** [fs/ext4/mballoc.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

