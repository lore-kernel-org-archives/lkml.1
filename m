Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZCBG0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZCBG0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZCBG0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:26:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:53433 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCBG0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:26:30 -0500
From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Organization: Nokia
To: sameo@openedhand.com
Subject: [PATCH] Add TWL4030 registers
Date: Mon, 2 Mar 2009 08:24:56 +0200
User-Agent: KMail/1.9.6
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "sailus@maxwell.research.nokia.com" 
	<sailus@maxwell.research.nokia.com>,
       linux-kernel@vger.kernel.org
References: <200902271555.00330.tuukka.o.toivonen@nokia.com> <20090227170743.GD11594@atomide.com>
In-Reply-To: <20090227170743.GD11594@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903020824.56642.tuukka.o.toivonen@nokia.com>
X-OriginalArrivalTime: 02 Mar 2009 06:24:59.0264 (UTC) FILETIME=[9CAC3800:01C99AFF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 include/linux/i2c/twl4030.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index c89d33b..c4fe1b6 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -379,11 +379,21 @@ int twl4030_sih_setup(int module);
 #define TWL4030_VDAC_DEV_GRP		0x3B
 #define TWL4030_VDAC_DEDICATED		0x3E
 #define TWL4030_VAUX1_DEV_GRP		0x17
+#define TWL4030_VAUX1_TYPE		0x18
+#define TWL4030_VAUX1_REMAP		0x19
 #define TWL4030_VAUX1_DEDICATED		0x1A
 #define TWL4030_VAUX2_DEV_GRP		0x1B
+#define TWL4030_VAUX2_TYPE		0x1C
+#define TWL4030_VAUX2_REMAP		0x1D
 #define TWL4030_VAUX2_DEDICATED		0x1E
 #define TWL4030_VAUX3_DEV_GRP		0x1F
+#define TWL4030_VAUX3_TYPE		0x20
+#define TWL4030_VAUX3_REMAP		0x21
 #define TWL4030_VAUX3_DEDICATED		0x22
+#define TWL4030_VAUX4_DEV_GRP		0x23
+#define TWL4030_VAUX4_TYPE		0x24
+#define TWL4030_VAUX4_REMAP		0x25
+#define TWL4030_VAUX4_DEDICATED		0x26
 
 #if defined(CONFIG_TWL4030_BCI_BATTERY) || \
 	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
-- 
1.5.2.5

