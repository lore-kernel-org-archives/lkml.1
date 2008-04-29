Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbYD2ORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbYD2ORP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYD2OP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:15:58 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:14875 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYD2OPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:15:54 -0400
Message-Id: <20080429140249.106441988@de.ibm.com>
References: <20080429140117.631962807@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Apr 2008 16:01:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/15] Add missing ifndef/define to include/asm-s390/sysinfo.h.
Content-Disposition: inline; filename=003-sysinfo.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

In order to protect against compile breakage in case the header file
gets included twice.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/sysinfo.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: quilt-2.6/include/asm-s390/sysinfo.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/sysinfo.h
+++ quilt-2.6/include/asm-s390/sysinfo.h
@@ -11,6 +11,9 @@
  *		 Christian Borntraeger <borntraeger@de.ibm.com>
  */
 
+#ifndef __ASM_S390_SYSINFO_H
+#define __ASM_S390_SYSINFO_H
+
 struct sysinfo_1_1_1 {
 	char reserved_0[32];
 	char manufacturer[16];
@@ -114,3 +117,5 @@ static inline int stsi(void *sysinfo, in
 		: "cc", "memory");
 	return r0;
 }
+
+#endif /* __ASM_S390_SYSINFO_H */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

