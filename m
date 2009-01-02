Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZABHxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZABHxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 02:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZABHxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 02:53:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38643 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZABHxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 02:53:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH] asm-s390/posix_types.h: drop __USE_ALL usage
Date: Fri,  2 Jan 2009 02:53:02 -0500
Message-Id: <1230882782-9977-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring s390 in line with all the other ports.  Not sure how s390 missed
this change as all the other arches were being updated ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux390@de.ibm.com
CC: linux-s390@vger.kernel.org
---
 arch/s390/include/asm/posix_types.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/posix_types.h b/arch/s390/include/asm/posix_types.h
index 397d93f..8cc113f 100644
--- a/arch/s390/include/asm/posix_types.h
+++ b/arch/s390/include/asm/posix_types.h
@@ -68,11 +68,7 @@ typedef unsigned short __kernel_old_dev_t;
 #endif /* __s390x__ */
 
 typedef struct {
-#if defined(__KERNEL__) || defined(__USE_ALL)
         int     val[2];
-#else                        /* !defined(__KERNEL__) && !defined(__USE_ALL)*/
-        int     __val[2];
-#endif                       /* !defined(__KERNEL__) && !defined(__USE_ALL)*/
 } __kernel_fsid_t;
 
 
-- 
1.6.0.6

