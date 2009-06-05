Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZFEIJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZFEIJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZFEIFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37482 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZFEIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 09/62] Blackfin: fix parentheses balance and convert some tab/space mixing
Date: Fri,  5 Jun 2009 04:04:18 -0400
Message-Id: <1244189111-19639-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
index 241725b..7a5f74c 100644
--- a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
+++ b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
@@ -67,14 +67,14 @@
 #define bfin_write_SIC_ISR0(val)       bfin_write32(SIC_ISR0, val)
 #define bfin_read_SIC_ISR1()           bfin_read32(SIC_ISR1)
 #define bfin_write_SIC_ISR1(val)       bfin_write32(SIC_ISR1, val)
-#define bfin_read_SIC_ISR(x)	       bfin_read32(SIC_ISR0 + x * (SIC_ISR1 - SIC_ISR0))
+#define bfin_read_SIC_ISR(x)           bfin_read32(SIC_ISR0 + x * (SIC_ISR1 - SIC_ISR0))
 #define bfin_write_SIC_ISR(x, val)     bfin_write32(SIC_ISR0 + x * (SIC_ISR1 - SIC_ISR0), val)
 #define bfin_read_SIC_IWR0()           bfin_read32(SIC_IWR0)
 #define bfin_write_SIC_IWR0(val)       bfin_write32(SIC_IWR0, val)
 #define bfin_read_SIC_IWR1()           bfin_read32(SIC_IWR1)
 #define bfin_write_SIC_IWR1(val)       bfin_write32(SIC_IWR1, val)
-#define bfin_read_SIC_IWR(x)	       bfin_read32(SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0))
-#define bfin_write_SIC_IWR(x, val)     bfin_write32((SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0), val)
+#define bfin_read_SIC_IWR(x)           bfin_read32(SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0))
+#define bfin_write_SIC_IWR(x, val)     bfin_write32(SIC_IWR0 + x * (SIC_IWR1 - SIC_IWR0), val)
 #define bfin_read_SIC_IAR0()           bfin_read32(SIC_IAR0)
 #define bfin_write_SIC_IAR0(val)       bfin_write32(SIC_IAR0, val)
 #define bfin_read_SIC_IAR1()           bfin_read32(SIC_IAR1)
-- 
1.6.3.1

