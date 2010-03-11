Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0CKIn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:43:28 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65230 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0CKInX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=Zc6kKXtJO0mzlRmXGCc9lYITR+XWZqjEPI49mzDBaFDza1RIq4xvu2m2XWYEPGnyHr
         BI/1ocKmnljfLqUeMMD1HBHtmpBB2o5JGAi2wsyn9L2XXtvHHOQOdxllJPq1wsT0Vj2t
         dSzq+FhYvKDuN+ozUQ59IIw7Hz7qez/X0J2pw=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 11 Mar 2010 09:42:06 +0100
Subject: [PATCH 1/4 v2] x86: remove rdc321x_defs.h
MIME-Version: 1.0
X-TUID: 388d1626d06a9b0a
X-Length: 1575
Organization: OpenWrt
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Wim Van Sebroeck <wim@iguana.be>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003110942.06367.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is going to be replaced with a cleaner version with the adding
of a MFD driver for the southbridge.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/arch/x86/include/asm/rdc321x_defs.h b/arch/x86/include/asm/rdc321x_defs.h
deleted file mode 100644
index c8e9c8b..0000000
--- a/arch/x86/include/asm/rdc321x_defs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#define PFX	"rdc321x: "
-
-/* General purpose configuration and data registers */
-#define RDC3210_CFGREG_ADDR     0x0CF8
-#define RDC3210_CFGREG_DATA     0x0CFC
-
-#define RDC321X_GPIO_CTRL_REG1	0x48
-#define RDC321X_GPIO_CTRL_REG2	0x84
-#define RDC321X_GPIO_DATA_REG1	0x4c
-#define RDC321X_GPIO_DATA_REG2	0x88
-
-#define RDC321X_MAX_GPIO	58
