Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZCEHNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZCEHNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZCEHMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:12:48 -0500
Received: from smtp100.biz.mail.mud.yahoo.com ([68.142.201.176]:25584 "HELO
	smtp100.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751933AbZCEHMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:12:47 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 02:12:47 EST
X-YMail-OSG: t6b3oN4VM1k5FC2xT0X_tp5Nt7ZfZKA67hKNXQnOe9bGua0Bdd4sSlG1jWLrD4XbsOTfNKCBnjvdJD_yJ_n6mOVNxu0rH.bHdww67sp_ZP4CUCtcUd.8LKxtw59OBEDoeCkDllVuUHnhqeDMqM_9f2UaDm1tdNvwWAAm.Jv8I0zvdDNsQre0p_3HXCrct5ZeuRE49GonHaRP4802T23eTSkozCi18C2jiac.otIQRWPCs5o-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: uclinux-dev@uclinux.org
Subject: [PATCH] m68knommu: m5206e build fix.
Date: Wed, 4 Mar 2009 23:04:38 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903042304.39637.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68knommu/platform/5206e/config.c 
b/arch/m68knommu/platform/5206e/config.c
index d01a5d2..db90254 100644
--- a/arch/m68knommu/platform/5206e/config.c
+++ b/arch/m68knommu/platform/5206e/config.c
@@ -17,6 +17,7 @@
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
