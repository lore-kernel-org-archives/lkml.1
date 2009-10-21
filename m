Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZJUUpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZJUUpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZJUUpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:45:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZJUUpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dOAoPc3TalnluWYGpJdNFPf6X6q9BTzakmauGq4ZKCSPs5iYUvb3wJtkL7gXzD+KOs
         3WEzN4Pzh5u6y4p60Ma6WtKP5vbgu6CgqX85ICSuBR3MCy71sZtPG3IfOJCLt4d/sfKD
         7dO0KgcIElih1IqWJCEekTCnrsBy7+eKxulZQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:44:55 +0200
Message-Id: <20091021204455.4593.11548.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/12] Staging: rt28x0: remove dead code from rtmp_phy.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove dead code from rtmp_phy.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/chip/rtmp_phy.h |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

Index: b/drivers/staging/rt2860/chip/rtmp_phy.h
===================================================================
--- a/drivers/staging/rt2860/chip/rtmp_phy.h
+++ b/drivers/staging/rt2860/chip/rtmp_phy.h
@@ -278,18 +278,6 @@
 	But for some chipset which didn't have mcu (e.g., RBUS based chipset), we
 	will use this function too and didn't access the bbp register via the MCU.
 */
-#if 0
-#define RTMP_BBP_IO_READ8_BY_REG_ID(_A, _I, _pV)			\
-	do{														\
-		if ((_A)->bPCIclkOff == FALSE)							\
-		{													\
-			if ((_A)->infType == RTMP_DEV_INF_RBUS)			\
-				RTMP_BBP_IO_READ8((_A), (_I), (_pV), FALSE);	\
-			else												\
-				RTMP_BBP_IO_READ8((_A), (_I), (_pV), TRUE);	\
-		}													\
-	}while(0)
-#else
 // Read BBP register by register's ID. Generate PER to test BA
 #define RTMP_BBP_IO_READ8_BY_REG_ID(_A, _I, _pV)						\
 {																		\
@@ -381,7 +369,6 @@
 		*(_pV) = (_A)->BbpWriteLatch[_I];								\
 	}																	\
 }
-#endif // 0 //
 
 /*
 	basic marco for BBP write operation.
@@ -441,18 +428,6 @@
 	But for some chipset which didn't have mcu (e.g., RBUS based chipset), we
 	will use this function too and didn't access the bbp register via the MCU.
 */
-#if 0
-#define RTMP_BBP_IO_WRITE8_BY_REG_ID(_A, _I, _pV)			\
-	do{														\
-		if ((_A)->bPCIclkOff == FALSE)							\
-		{													\
-			if ((_A)->infType == RTMP_DEV_INF_RBUS)			\
-				RTMP_BBP_IO_WRITE8((_A), (_I), (_pV), FALSE);	\
-			else												\
-				RTMP_BBP_IO_WRITE8((_A), (_I), (_pV), TRUE);	\
-		}													\
-	}while(0)
-#else
 // Write BBP register by register's ID & value
 #define RTMP_BBP_IO_WRITE8_BY_REG_ID(_A, _I, _V)						\
 {																		\
@@ -538,9 +513,8 @@
 		DBGPRINT_ERR(("****** BBP_Write_Latch Buffer exceeds max boundry ****** \n"));	\
 	}																		\
 }
-#endif // 0 //
-
 #endif // RTMP_MAC_PCI //
+
 #ifdef RTMP_MAC_USB
 #define RTMP_BBP_IO_READ8_BY_REG_ID(_A, _I, _pV)   RTUSBReadBBPRegister(_A, _I, _pV)
 #define RTMP_BBP_IO_WRITE8_BY_REG_ID(_A, _I, _V)   RTUSBWriteBBPRegister(_A, _I, _V)
