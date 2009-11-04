Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbZKDRjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbZKDRjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbZKDRgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:40568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbZKDRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QhoXSDN5jfDaeKHZgJXGKylFOd3q63TDQ5BC1g7vVyuS1SAt8Jex8/Pr6H6RjGEnZ8
         N6YeB6NQiQhvgHsVByyAFignKyPHJKiGFuY3/sBWYJDeWF04iPzDMV61A+ZOKtQ9eW5L
         fkGjcGrY009dQiLTSbBqd3oOoLNzqGeQB05wI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:02 +0100
Message-Id: <20091104173602.28463.31521.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 33/41] rt2800: fix comments in rt2800.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: fix comments in rt2800.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |   42 +++++++++++++++-----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -181,8 +181,8 @@
  * WMM_AIFSN_CFG: Aifsn for each EDCA AC
  * AIFSN0: AC_BE
  * AIFSN1: AC_BK
- * AIFSN1: AC_VI
- * AIFSN1: AC_VO
+ * AIFSN2: AC_VI
+ * AIFSN3: AC_VO
  */
 #define WMM_AIFSN_CFG			0x0214
 #define WMM_AIFSN_CFG_AIFSN0		FIELD32(0x0000000f)
@@ -194,8 +194,8 @@
  * WMM_CWMIN_CSR: CWmin for each EDCA AC
  * CWMIN0: AC_BE
  * CWMIN1: AC_BK
- * CWMIN1: AC_VI
- * CWMIN1: AC_VO
+ * CWMIN2: AC_VI
+ * CWMIN3: AC_VO
  */
 #define WMM_CWMIN_CFG			0x0218
 #define WMM_CWMIN_CFG_CWMIN0		FIELD32(0x0000000f)
@@ -207,8 +207,8 @@
  * WMM_CWMAX_CSR: CWmax for each EDCA AC
  * CWMAX0: AC_BE
  * CWMAX1: AC_BK
- * CWMAX1: AC_VI
- * CWMAX1: AC_VO
+ * CWMAX2: AC_VI
+ * CWMAX3: AC_VO
  */
 #define WMM_CWMAX_CFG			0x021c
 #define WMM_CWMAX_CFG_CWMAX0		FIELD32(0x0000000f)
@@ -528,9 +529,6 @@
 /*
  * RF_CSR_CFG2: RF control register
  * VALUE: Register value to program into RF
- * RFGAP: Gap between BB_CONTROL_RF and RF_LE
- *        0: 3 system clock cycle (37.5usec)
- *        1: 5 system clock cycle (62.5usec)
  */
 #define RF_CSR_CFG2			0x1028
 #define RF_CSR_CFG2_VALUE		FIELD32(0x00ffffff)
@@ -1306,8 +1304,8 @@
  * PAIRWISE_KEY_TABLE_BASE: 32-byte * 256 entry
  * MAC_IVEIV_TABLE_BASE: 8-byte * 256-entry
  * MAC_WCID_ATTRIBUTE_BASE: 4-byte * 256-entry
- * SHARED_KEY_TABLE_BASE: 32 bytes * 32-entry
- * SHARED_KEY_MODE_BASE: 4 bits * 32-entry
+ * SHARED_KEY_TABLE_BASE: 32-byte * 16-entry
+ * SHARED_KEY_MODE_BASE: 4-byte * 16-entry
  */
 #define MAC_WCID_BASE			0x1800
 #define PAIRWISE_KEY_TABLE_BASE		0x4000
@@ -1416,7 +1414,7 @@ struct mac_iveiv_entry {
 
 /*
  * HW_DFS_CTS_BASE:
- * FS CTS frame base address. It's where mac stores CTS frame for DFS.
+ * DFS CTS frame base address. It's where mac stores CTS frame for DFS.
  */
 #define HW_DFS_CTS_BASE			0x7780
 
