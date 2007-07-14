Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbXGNOCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbXGNOCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 10:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbXGNOCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 10:02:30 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39880
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919AbXGNOC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 10:02:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] pure_initcall ID inconsistency
Date: Sat, 14 Jul 2007 16:00:43 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141600.43551.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pure_initcall uses the same ID as core_initcall.
I guess that's a typo and it should use its own ID.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h	2007-05-26 19:56:35.000000000 +0200
+++ linux-2.6/include/linux/init.h	2007-07-14 15:59:07.000000000 +0200
@@ -114,7 +114,7 @@ void prepare_namespace(void);
  *
  * This only exists for built-in code, not for modules.
  */
-#define pure_initcall(fn)		__define_initcall("0",fn,1)
+#define pure_initcall(fn)		__define_initcall("0",fn,0)
 
 #define core_initcall(fn)		__define_initcall("1",fn,1)
 #define core_initcall_sync(fn)		__define_initcall("1s",fn,1s)

-- 
Greetings Michael.
