Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYBQRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYBQRLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYBQRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:10:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:47523 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYBQRKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gS2PZrwDgU1ZOyjMEXatho84qwKxcQvOp73Y2Yik8sCbiLbhprxIiGU5SSEjCZBMYrj1zsi4u2QwmIW3dQfiqcRSWkWip2jB1+rKM4xjAARWl+pPmkjAJ/Yj0Qlad/LgGQv0NMVKkf71d25Zsjfq+JNtR2+HejQ0aU1ebdJezng=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/hdsmart.h: fix goofups
Date: Sun, 17 Feb 2008 18:07:57 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171807.57983.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix goofups of commit 76166952bbc81dda1c8a8c14e75a2aa06f6c052c
("<linux/hdsmart.h> is not used by kernel code").

Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/hdsmart.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/include/linux/hdsmart.h
===================================================================
--- a/include/linux/hdsmart.h
+++ b/include/linux/hdsmart.h
@@ -17,7 +17,7 @@
 #ifndef _LINUX_HDSMART_H
 #define _LINUX_HDSMART_H
 
-#ifndef __KERNEL
+#ifndef __KERNEL__
 #define OFFLINE_FULL_SCAN		0
 #define SHORT_SELF_TEST			1
 #define EXTEND_SELF_TEST		2
@@ -121,6 +121,6 @@ typedef struct ata_smart_selftestlog_s {
 	unsigned char			resevered[2];
 	unsigned char			chksum;
 } __attribute__ ((packed)) ata_smart_selftestlog_t;
-#endif /* __KERNEL__ *
+#endif /* __KERNEL__ */
 
 #endif	/* _LINUX_HDSMART_H */
