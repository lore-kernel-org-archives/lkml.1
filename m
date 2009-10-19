Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZJSMKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZJSMKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZJSMKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:10:51 -0400
Received: from smtp.nokia.com ([192.100.122.230]:20552 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZJSMKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:10:49 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: sameo@linux.intel.com, linux-omap@vger.kernel.org
Subject: [PATCH 2/5] mfd: twl4030-power: Add comments for the register and bit layout
Date: Mon, 19 Oct 2009 15:10:48 +0300
Message-Id: <1255954248-28945-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 19 Oct 2009 12:10:49.0343 (UTC) FILETIME=[321B40F0:01CA50B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe how the resource registers are laid out and the various bit-fields in
them.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org
---
 drivers/mfd/twl4030-power.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 82e3bcb..2c38ac1 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -67,14 +67,22 @@ static u8 twl4030_start_script_address = 0x2b;
 #define R_KEY_1			0xC0
 #define R_KEY_2			0x0C
 
-/* resource configuration registers */
-
+/* resource configuration registers
+   <RESOURCE>_DEV_GRP   at address 'n+0'
+   <RESOURCE>_TYPE      at address 'n+1'
+   <RESOURCE>_REMAP     at address 'n+2'
+   <RESOURCE>_DEDICATED at address 'n+3'
+*/
 #define DEV_GRP_OFFSET		0
 #define TYPE_OFFSET		1
 
 /* Bit positions in the registers */
+
+/* <RESOURCE>_DEV_GRP */
 #define DEV_GRP_SHIFT		5
 #define DEV_GRP_MASK		(7 << DEV_GRP_SHIFT)
+
+/* <RESOURCE>_TYPE */
 #define TYPE_SHIFT		0
 #define TYPE_MASK		(7 << TYPE_SHIFT)
 #define TYPE2_SHIFT		3
-- 
1.6.3.3

