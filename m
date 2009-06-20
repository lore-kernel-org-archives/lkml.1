Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZFTSuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZFTSuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbZFTSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48186 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758157AbZFTSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 20/25] Blackfin: fix typo in TRAS define in mem_init.h header
Date: Sat, 20 Jun 2009 14:44:43 -0400
Message-Id: <1245523488-26536-21-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

We defined SDRAM_tRAS to TRAS_4, but then wrongly defined SDRAM_tRAS_num
to 3.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/mem_init.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/mem_init.h b/arch/blackfin/include/asm/mem_init.h
index 61f7487..fc164b3 100644
--- a/arch/blackfin/include/asm/mem_init.h
+++ b/arch/blackfin/include/asm/mem_init.h
@@ -59,7 +59,7 @@
 #define SDRAM_tRP       TRP_1
 #define SDRAM_tRP_num   1
 #define SDRAM_tRAS      TRAS_4
-#define SDRAM_tRAS_num  3
+#define SDRAM_tRAS_num  4
 #define SDRAM_tRCD      TRCD_1
 #define SDRAM_tWR       TWR_2
 #endif
-- 
1.6.3.1

