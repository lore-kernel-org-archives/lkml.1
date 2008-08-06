Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbYHFVXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbYHFVXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422863AbYHFVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:13:39 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47697 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762022AbYHFVNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:13:37 -0400
Date: Thu, 7 Aug 2008 00:12:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] m32r: remove the unused NOHIGHMEM option
Message-ID: <20080806211209.GZ1702@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused NOHIGHMEM option.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 25 Jun 2008

adea6f9163987adf9c5a63b5a257ed3554add9d7 diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index de153de..e2e3661 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -216,10 +216,6 @@ config MEMORY_SIZE
 	default "01000000" if PLAT_M32104UT
 	default "00800000" if PLAT_OAKS32R
 
-config NOHIGHMEM
-	bool
-	default y
-
 config ARCH_DISCONTIGMEM_ENABLE
 	bool "Internal RAM Support"
 	depends on CHIP_M32700 || CHIP_M32102 || CHIP_VDEC2 || CHIP_OPSP || CHIP_M32104

