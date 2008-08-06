Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbYHFPiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbYHFPiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYHFPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:33:34 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:32365 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756033AbYHFPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:33:32 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i67h)
X-Spam-TCS-SCL: 6:0
X-FB-SS: 7,
X-WSS-ID: 0K56R71-01-ZGT-01
Message-ID: <20080806152320.081968686@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 6 Aug 2008 17:21:21 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 4/5] [PATCH 4/5] x86: Minor correction to Intel microcode patch loader.
References: <20080806152117.198754464@amd.com>
Content-Disposition: inline;
	filename="0004-x86-Minor-correction-to-Intel-microcode-patch-loade.patch"
X-OriginalArrivalTime: 06 Aug 2008 15:32:10.0072 (UTC) FILETIME=[976FF580:01C8F7D9]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 arch/x86/kernel/microcode_intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 4ab6ce3..8d69470 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -315,7 +315,7 @@ static void apply_microcode(int cpu)
 	unsigned long flags;
 	unsigned int val[2];
 	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu);
+	struct ucode_cpu_info *uci = get_ucode_cpu_info(cpu_num);
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
-- 
1.5.4.5




