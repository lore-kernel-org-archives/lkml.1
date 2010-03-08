Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0CHMNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:13:44 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:38863 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab0CHMNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=fbmNwJzx0TNdJgv0ozDKsJvQxSYWuVyWtU/LTd85CZqN6B3cChfUuL9wjc0OoVJa5V
         fTkE0YDkVOXN6uo8/x2Ka1BtNB+2uHgWIdui5cSxbEytcVeo82bTu+uOboiVz/G9BMXT
         eGOg38tDPAGysvFPfTl5Z4To8czCSCT5pQdKo=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 8 Mar 2010 13:12:40 +0100
Subject: [PATCH 1/4] x86: remove rdc321x_defs.h
MIME-Version: 1.0
X-TUID: 530fc51f202b79b1
X-Length: 1575
Organization: OpenWrt
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Samuel Ortiz <sameo@linux.intel.com>,
       Wim Van Sebroeck <wim@iguana.be>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003081312.40524.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is going to be replaced with a cleaner version with the adding
of a MFD driver for the southbridge.

Signed-off-by: Regards, Florian Fainelli <florian@openwrt.org>
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
