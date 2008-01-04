Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYADUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYADUl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYADUlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:41:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:61756 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYADUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z46Q4pDlSa7VHibtuxg+5in2GGhq986PhPYk3v911Zp75SlQEiIh/+55tZr0YpAkbvsrXBhIRpIyTZTeIvJk5huW506ZJe8ew0iE1Wccyk8H04fr4ikjBOnef5kco7LB+Raa7oH387N6USU8JBKe3zfTKtMoc25/wA/y8nylQMc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] <linux/hdsmart.h> is not used by kernel code
Date: Fri, 4 Jan 2008 21:53:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042153.02889.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/hdsmart.h |    2 ++
 1 file changed, 2 insertions(+)

Index: b/include/linux/hdsmart.h
===================================================================
--- a/include/linux/hdsmart.h
+++ b/include/linux/hdsmart.h
@@ -17,6 +17,7 @@
 #ifndef _LINUX_HDSMART_H
 #define _LINUX_HDSMART_H
 
+#ifndef __KERNEL
 #define OFFLINE_FULL_SCAN		0
 #define SHORT_SELF_TEST			1
 #define EXTEND_SELF_TEST		2
@@ -120,5 +121,6 @@ typedef struct ata_smart_selftestlog_s {
 	unsigned char			resevered[2];
 	unsigned char			chksum;
 } __attribute__ ((packed)) ata_smart_selftestlog_t;
+#endif /* __KERNEL__ *
 
 #endif	/* _LINUX_HDSMART_H */
