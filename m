Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbYEACVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbYEACVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbYEACSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:18:40 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45774 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759982AbYEACSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:18:38 -0400
Date: Thu, 1 May 2008 12:17:41 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010217.m412Hfh5004146@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: rework definition of HZ
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the HZ definition to be more consistent with other architectures.
Non-kernel includers will see a constant HZ setting of 100.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/include/asm-m68knommu/param.h linux-2.6.25-uc0/include/asm-m68knommu/param.h
--- linux-2.6.25/include/asm-m68knommu/param.h	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/include/asm-m68knommu/param.h	2008-04-28 17:00:21.000000000 +1000
@@ -1,13 +1,16 @@
 #ifndef _M68KNOMMU_PARAM_H
 #define _M68KNOMMU_PARAM_H
 
-#define HZ CONFIG_HZ
-
 #ifdef __KERNEL__
+#define HZ CONFIG_HZ
 #define	USER_HZ		HZ
 #define	CLOCKS_PER_SEC	(USER_HZ)
 #endif
 
+#ifndef HZ
+#define HZ	100
+#endif
+
 #define EXEC_PAGESIZE	4096
 
 #ifndef NOGROUP
