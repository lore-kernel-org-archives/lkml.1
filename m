Return-Path: <linux-kernel-owner+w=401wt.eu-S1765242AbZEAA0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765242AbZEAA0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764096AbZEAAFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:05:36 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62271 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763520AbZEAAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:05:32 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 6/6] s390: convert to new generic read_mostly support.
Date: Thu, 30 Apr 2009 19:57:21 -0400
Message-Id: <1241135841-9619-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135841-9619-6-git-send-email-tabbott@mit.edu>
References: <1241135841-9619-1-git-send-email-tabbott@mit.edu>
 <1241135841-9619-2-git-send-email-tabbott@mit.edu>
 <1241135841-9619-3-git-send-email-tabbott@mit.edu>
 <1241135841-9619-4-git-send-email-tabbott@mit.edu>
 <1241135841-9619-5-git-send-email-tabbott@mit.edu>
 <1241135841-9619-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/Kconfig             |    3 +++
 arch/s390/include/asm/cache.h |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 2eca5fe..bf6f4fb 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -75,6 +75,9 @@ config VIRT_CPU_ACCOUNTING
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
+config HAVE_READ_MOSTLY_DATA
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/s390/include/asm/cache.h b/arch/s390/include/asm/cache.h
index 9b86681..ae5338e 100644
--- a/arch/s390/include/asm/cache.h
+++ b/arch/s390/include/asm/cache.h
@@ -14,6 +14,4 @@
 #define L1_CACHE_BYTES     256
 #define L1_CACHE_SHIFT     8
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
-
 #endif
-- 
1.6.2.1

