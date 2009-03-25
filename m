Return-Path: <linux-kernel-owner+w=401wt.eu-S1759577AbZCYKsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577AbZCYKsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZCYKsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:48:17 -0400
Received: from mx1.emlix.com ([193.175.82.87]:51138 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbZCYKsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:48:16 -0400
From: Oskar Schirmer <os@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/4] xtensa: define s6000 XLMI addresses
Date: Wed, 25 Mar 2009 11:49:15 +0100
Message-Id: <1237978158-23603-1-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Glöckner <dg@emlix.com>

Provide register addresses for XLMI devices (like the ISEF).

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 .../variants/s6000/include/variant/hardware.h      |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/variants/s6000/include/variant/hardware.h b/arch/xtensa/variants/s6000/include/variant/hardware.h
index 5d9ba09..9faa7dd 100644
--- a/arch/xtensa/variants/s6000/include/variant/hardware.h
+++ b/arch/xtensa/variants/s6000/include/variant/hardware.h
@@ -21,10 +21,15 @@
 /* Device addresses */
 
 #define S6_REG_SCB              S6_MEM_REG
+#define S6_REG_XAD		(S6_MEM_XLMI + 0x00000)
 #define S6_REG_NB               (S6_REG_SCB + 0x10000)
+#define S6_REG_NB_XLMI		(S6_MEM_XLMI + 0x10000)
 #define S6_REG_LMSDMA           (S6_REG_SCB + 0x20000)
+#define S6_REG_LMSDMA_XLMI	(S6_MEM_XLMI + 0x04000)
 #define S6_REG_NI               (S6_REG_SCB + 0x30000)
+#define S6_REG_NI_XLMI		(S6_MEM_XLMI + 0x0C000)
 #define S6_REG_NIDMA            (S6_REG_SCB + 0x40000)
+#define S6_REG_NIDMA_XLMI	(S6_MEM_XLMI + 0x08000)
 #define S6_REG_NS               (S6_REG_SCB + 0x50000)
 #define S6_REG_DDR              (S6_REG_SCB + 0x60000)
 #define S6_REG_GREG1            (S6_REG_SCB + 0x70000)
-- 
1.6.2.107.ge47ee

