Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYDBPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYDBPvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbYDBPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:51:08 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:49565 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbYDBPvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:51:08 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/5] [MIPS] op_model_mipsxx.c: make the save_perf_irq variable static
Date: Wed,  2 Apr 2008 19:51:05 +0400
Message-Id: <1207151465-29257-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pointer save_perf_irq introduced by the previous
patch in this series can become static.

Thanks for Atsushi Nemoto for pointing out the possibility.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
Hi Ralf,

If you find that the series is worth it, please pick up this
patch too. Thank you.

Dmitri

 arch/mips/oprofile/op_model_mipsxx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index 12e840f..0a11727 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -31,7 +31,7 @@
 
 #define M_COUNTER_OVERFLOW		(1UL      << 31)
 
-int (*save_perf_irq)(void);
+static int (*save_perf_irq)(void);
 
 #ifdef CONFIG_MIPS_MT_SMP
 #define WHAT		(M_TC_EN_VPE | M_PERFCTL_VPEID(smp_processor_id()))
-- 
1.5.3

