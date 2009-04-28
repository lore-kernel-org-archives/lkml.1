Return-Path: <linux-kernel-owner+w=401wt.eu-S933342AbZD1RJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbZD1RJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933123AbZD1RGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:06:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56017 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933155AbZD1RGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:06:45 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH v2 10/15] powerpc: Remove unused __page_aligned macro.
Date: Tue, 28 Apr 2009 13:00:57 -0400
Message-Id: <1240938062-3264-11-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-10-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
 <1240938062-3264-2-git-send-email-tabbott@mit.edu>
 <1240938062-3264-3-git-send-email-tabbott@mit.edu>
 <1240938062-3264-4-git-send-email-tabbott@mit.edu>
 <1240938062-3264-5-git-send-email-tabbott@mit.edu>
 <1240938062-3264-6-git-send-email-tabbott@mit.edu>
 <1240938062-3264-7-git-send-email-tabbott@mit.edu>
 <1240938062-3264-8-git-send-email-tabbott@mit.edu>
 <1240938062-3264-9-git-send-email-tabbott@mit.edu>
 <1240938062-3264-10-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/include/asm/page_64.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index 043bfdf..20f9c74 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -152,14 +152,6 @@ do {						\
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
-#ifdef MODULE
-#define __page_aligned __attribute__((__aligned__(PAGE_SIZE)))
-#else
-#define __page_aligned \
-	__attribute__((__aligned__(PAGE_SIZE), \
-		__section__(".data.page_aligned")))
-#endif
-
 #define VM_DATA_DEFAULT_FLAGS \
 	(test_thread_flag(TIF_32BIT) ? \
 	 VM_DATA_DEFAULT_FLAGS32 : VM_DATA_DEFAULT_FLAGS64)
-- 
1.6.2.1

