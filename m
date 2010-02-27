Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967973Ab0B0IYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:24:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:45867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967957Ab0B0IYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:24:53 -0500
Subject: [PATCH -tip] mm: includecheck fix for arch/x86/mm/init_64.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Shaohui Zheng <shaohui.zheng@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 13:52:57 +0530
Message-Id: <1267258977.26906.3.camel@i7.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following 'make includecheck' warning:
  arch/x86/mm/init_64.c: linux/bootmem.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/mm/init_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e9b040e..a544bec 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -49,7 +49,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
-#include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
 
-- 
1.6.6


