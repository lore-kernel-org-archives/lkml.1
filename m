Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXLFMyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXLFMyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbXLFMoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:18 -0500
Received: from nic2.axis.se ([193.13.178.10]:45008 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbXLFMoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:16 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <575b5ad9df7b4c3bf6b97b49dbeb88c44f1b53aa.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 17:28:05 +0100
Subject: [PATCH 38/47] Include path fix for CRISv32 timex.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Shorten include path for machine dependent header files.
- Correct some formatting issues.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/arch-v32/timex.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-cris/arch-v32/timex.h b/include/asm-cris/arch-v32/timex.h
index 5a4aa28..2591d3c 100644
--- a/include/asm-cris/arch-v32/timex.h
+++ b/include/asm-cris/arch-v32/timex.h
@@ -1,9 +1,9 @@
 #ifndef _ASM_CRIS_ARCH_TIMEX_H
 #define _ASM_CRIS_ARCH_TIMEX_H
 
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/timer_defs.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/timer_defs.h>
 
 /*
  * The clock runs at 100MHz, we divide it by 1000000. If you change anything
@@ -18,7 +18,7 @@
 
 /* Convert the value in step of 10 ns to 1us without overflow: */
 #define GET_JIFFIES_USEC() \
-  ( (TIMER0_DIV - REG_RD(timer, regi_timer, r_tmr0_data)) /100 )
+	((TIMER0_DIV - REG_RD(timer, regi_timer0, r_tmr0_data)) / 100)
 
 extern unsigned long get_ns_in_jiffie(void);
 
-- 
1.5.3.6.970.gd25430

