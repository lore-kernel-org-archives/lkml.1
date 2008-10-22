Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYJVRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYJVRf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbYJVRcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:32:53 -0400
Received: from kroah.org ([198.145.64.141]:53021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755407AbYJVRcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:32:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/42] staging: balance parenthesis in wlan-ng headers
Date: Wed, 22 Oct 2008 10:28:48 -0700
Message-Id: <1224696563-5170-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Balance parenthesis in HFA384x_CMD_QOS_GET macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/hfa384x.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index a205463..0dfb8ce 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -824,7 +824,7 @@ PD Record codes
 #define		HFA384x_CMD_MACPORT_SET(value)		((UINT16)HFA384x_CMD_AINFO_SET(value))
 #define		HFA384x_CMD_ISRECL(value)		((UINT16)(HFA384x_CMD_AINFO_GET((UINT16)(value) & HFA384x_CMD_RECL)))
 #define		HFA384x_CMD_RECL_SET(value)		((UINT16)HFA384x_CMD_AINFO_SET(value))
-#define		HFA384x_CMD_QOS_GET(value)		((UINT16((((UINT16)(value))&((UINT16)0x3000)) >> 12))
+#define		HFA384x_CMD_QOS_GET(value)		((UINT16)((((UINT16)(value))&((UINT16)0x3000)) >> 12))
 #define		HFA384x_CMD_QOS_SET(value)		((UINT16)((((UINT16)(value)) << 12) & 0x3000))
 #define		HFA384x_CMD_ISWRITE(value)		((UINT16)(HFA384x_CMD_AINFO_GET((UINT16)(value) & HFA384x_CMD_WRITE)))
 #define		HFA384x_CMD_WRITE_SET(value)		((UINT16)HFA384x_CMD_AINFO_SET((UINT16)value))
-- 
1.6.0.2

