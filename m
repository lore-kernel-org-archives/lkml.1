Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092Ab0AQVr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0AQVr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957Ab0AQVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:47:27 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:60375 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab0AQVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:47:27 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: marcelo@kvack.org, dilinger@collabora.co.uk,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix grammo in tsc comment about Geode TSC reliability
Date: Sun, 17 Jan 2010 19:44:44 -0200
Message-Id: <1263764685-9871-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 arch/x86/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..23066ec 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -806,7 +806,7 @@ static void __init check_system_tsc_reliable(void)
 	unsigned long res_low, res_high;
 
 	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
-	/* Geode_LX - the OLPC CPU has a possibly a very reliable TSC */
+	/* Geode_LX - the OLPC CPU has a very reliable TSC */
 	if (res_low & RTSC_SUSP)
 		tsc_clocksource_reliable = 1;
 #endif
-- 
1.6.6

