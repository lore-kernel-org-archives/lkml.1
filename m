Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXDMV7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXDMV7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXDMV7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:59:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19706 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbXDMV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XB0BaXbPxktEfFvhm+n7t+7u/20gBNmHkODxG/seeHZx5s7t+gMRSidCcgV4kg0Kz+3TngsRkM5gFuFmQvqgFLXW2DWeCHcwwJqdMunQu+SXObLPFxK4AOI4T7jSJlMpjKJle0Ep7N10YlLMH59JPVcdnvv4iW1n+2Hm6L1YxXE=
Message-ID: <461FFCE0.2090306@googlemail.com>
Date: Fri, 13 Apr 2007 23:57:52 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napisał(a):
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
> 
> i'm pleased to announce the first release of the "Modular Scheduler Core
> and Completely Fair Scheduler [CFS]" patchset:
> 
>    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> 

Friday the 13th, my lucky day :).

/mnt/md0/devel/linux-msc-cfs/usr/include/linux/sched.h requires linux/rbtree.h, which does not exist in exported headers


make[3]: *** No rule to make target `/mnt/md0/devel/linux-msc-cfs/usr/include/linux/.check.sched.h', needed by `__headerscheck'.  Stop.
make[2]: *** [linux] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-msc-cfs-clean/include/linux/Kbuild	2007-04-13 23:52:47.000000000 +0200
+++ linux-msc-cfs/include/linux/Kbuild	2007-04-13 23:49:41.000000000 +0200
@@ -133,6 +133,7 @@ header-y += quotaio_v1.h
 header-y += quotaio_v2.h
 header-y += radeonfb.h
 header-y += raw.h
+header-y += rbtree.h
 header-y += resource.h
 header-y += rose.h
 header-y += smbno.h
