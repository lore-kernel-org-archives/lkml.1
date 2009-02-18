Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZBRK3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZBRK3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZBRK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:29:37 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41846 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZBRK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:29:36 -0500
Message-ID: <499BE300.5090405@in.ibm.com>
Date: Wed, 18 Feb 2009 15:59:20 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: [s390] next Feb 18: defconfig build break
References: <20090218191640.0b023029.sfr@canb.auug.org.au>
In-Reply-To: <20090218191640.0b023029.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next Feb 18 defconfig build on s390 fails with following error.

  CC      arch/s390/lib/string.o
In file included from include/linux/bitmap.h:8,
                 from include/linux/cpumask.h:142,
                 from include/linux/smp.h:12,
                 from /usr/local/autobench/var/tmp/build/linux/arch/s390/include/asm/spinlock.h:14,
                 from include/linux/spinlock.h:88,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from arch/s390/lib/string.c:13:
include/linux/string.h: In function 'strstarts':
include/linux/string.h:124: error: implicit declaration of function 'strlen'
include/linux/string.h:124: warning: incompatible implicit declaration of built-in function 'strlen'
make[1]: *** [arch/s390/lib/string.o] Error 1
make: *** [arch/s390/lib] Error 2

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

