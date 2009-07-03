Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZGCOCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZGCOCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbZGCOAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:00:42 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:39052 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbZGCOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uzX0PZ8L6z0YRXy1m4P9B83WyUfPiObdtw/eGwk7/+gcpAAgQCUf8F/MtVZHCIQWXq
         DFWAQut0AKfrUHRCReU0PDtwzyXT13SgXdtR/LTOf2Jn4ekOV6tsjbvH8+nBw+sFc05R
         e52epKd+wKwZrdFaR2MriVUKXneVxpK0Y17sY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:07:14 +0200
Message-Id: <20090703140714.7303.44569.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/22] Staging: rtl8192su: remove RTL8192SU_USE_PARAM_TXPWR ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove RTL8192SU_USE_PARAM_TXPWR ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |    5 -----
 2 files changed, 6 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -12,7 +12,6 @@ EXTRA_CFLAGS += -DRTL8190_Download_Firmw
 EXTRA_CFLAGS += -DRTL8192S_PREPARE_FOR_NORMAL_RELEASE
 EXTRA_CFLAGS += -DRTL8192SU_DISABLE_IQK=1
 
-EXTRA_CFLAGS += -DRTL8192SU_USE_PARAM_TXPWR=0
 EXTRA_CFLAGS += -DRTL8192SU_FPGA_UNSPECIFIED_NETWORK=0
 #EXTRA_CFLAGS += -DRTL8192SU_FPGA_2MAC_VERIFICATION #=0
 EXTRA_CFLAGS += -DRTL8192SU_ASIC_VERIFICATION
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -5513,12 +5513,7 @@ rtl8192SU_ReadAdapterInfo8192SUsb(struct
 	else
 	{
 		priv->AutoloadFailFlag=FALSE;
-#if RTL8192SU_USE_PARAM_TXPWR
-		priv->bTXPowerDataReadFromEEPORM = FALSE;
-#else
 		priv->bTXPowerDataReadFromEEPORM = TRUE;
-#endif
-
 	}
        // Read IC Version && Channel Plan
 	if(!priv->AutoloadFailFlag)
