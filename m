Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYCaWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYCaWHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYCaWHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:07:19 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:55461 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYCaWHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:07:18 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] [MIPS] make plat_perf_setup() static
Date: Tue,  1 Apr 2008 02:03:23 +0400
Message-Id: <1207001005-2633-5-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for the plat_perf_setup() function to be global,
so make it static.

Successfully build-tested using default configs for Malta, Atlas
and SEAD boards.

Runtime test successfully performed by booting the Malta 4Kc board
up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/generic/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/generic/time.c b/arch/mips/mips-boards/generic/time.c
index b50e0fc..a6eece7 100644
--- a/arch/mips/mips-boards/generic/time.c
+++ b/arch/mips/mips-boards/generic/time.c
@@ -127,7 +127,7 @@ unsigned long read_persistent_clock(void)
 	return mc146818_get_cmos_time();
 }
 
-void __init plat_perf_setup(void)
+static void __init plat_perf_setup(void)
 {
 	cp0_perfcount_irq = -1;
 
-- 
1.5.3

