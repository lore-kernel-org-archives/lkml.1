Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXCEWlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXCEWlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932495AbXCEWlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:41:09 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:7680 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbXCEWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:40:55 -0500
Date: Mon, 5 Mar 2007 23:40:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] check_bugs() should be inline.
Message-ID: <20070305224055.GF22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] check_bugs() should be inline.

Don't have functions in header files unless they are inline.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/bugs.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/include/asm-s390/bugs.h linux-2.6-patched/include/asm-s390/bugs.h
--- linux-2.6/include/asm-s390/bugs.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/bugs.h	2007-03-05 22:51:52.000000000 +0100
@@ -16,7 +16,7 @@
  *      void check_bugs(void);
  */
 
-static void __init check_bugs(void)
+static inline void check_bugs(void)
 {
   /* s390 has no bugs ... */
 }
