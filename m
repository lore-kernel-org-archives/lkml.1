Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbZIVQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbZIVQ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZIVQ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:57:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48838 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756161AbZIVQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:57:20 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>, Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH v2 1/2] m68knommu: Make THREAD_SIZE available to assembly files.
Date: Tue, 22 Sep 2009 12:56:54 -0400
Message-Id: <1253638615-27009-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253638615-27009-1-git-send-email-tabbott@ksplice.com>
References: <1253638615-27009-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/thread_info_no.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/thread_info_no.h b/arch/m68k/include/asm/thread_info_no.h
index c2bde5e..a6512bf 100644
--- a/arch/m68k/include/asm/thread_info_no.h
+++ b/arch/m68k/include/asm/thread_info_no.h
@@ -12,8 +12,6 @@
 
 #ifdef __KERNEL__
 
-#ifndef __ASSEMBLY__
-
 /*
  * Size of kernel stack for each process. This must be a power of 2...
  */
@@ -28,6 +26,8 @@
  */
 #define THREAD_SIZE (PAGE_SIZE<<THREAD_SIZE_ORDER)
 
+#ifndef __ASSEMBLY__
+
 /*
  * low level task data.
  */
-- 
1.6.3.3

