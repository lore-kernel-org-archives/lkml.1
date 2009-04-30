Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbZD3XEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbZD3XEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764165AbZD3XDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:03:44 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52411 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764336AbZD3XDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:03:43 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/4] alpha: make THREAD_SIZE available to assembly files.
Date: Thu, 30 Apr 2009 19:00:15 -0400
Message-Id: <1241132416-7055-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241132416-7055-3-git-send-email-tabbott@mit.edu>
References: <1241132416-7055-1-git-send-email-tabbott@mit.edu>
 <1241132416-7055-2-git-send-email-tabbott@mit.edu>
 <1241132416-7055-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows THREAD_SIZE to be used in the linker script.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/include/asm/thread_info.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index d069526..a64d74d 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -49,12 +49,12 @@ struct thread_info {
 register struct thread_info *__current_thread_info __asm__("$8");
 #define current_thread_info()  __current_thread_info
 
+#endif /* __ASSEMBLY__ */
+
 /* Thread information allocation.  */
 #define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
 
-#endif /* __ASSEMBLY__ */
-
 #define PREEMPT_ACTIVE		0x40000000
 
 /*
-- 
1.6.2.1

