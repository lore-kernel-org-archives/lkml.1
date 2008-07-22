Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYGVTZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYGVTZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYGVTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:54 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:25014 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYGVTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:51 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9V8-01-8PB-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/24] x86: apic_*.c: Add description to AMD's extended LVT functions
Date: Tue, 22 Jul 2008 21:08:46 +0200
Message-ID: <1216753748-11261-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:38.0933 (UTC) FILETIME=[71A5B650:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic_32.c |    3 +++
 arch/x86/kernel/apic_64.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d6c8983..fad94b0 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -646,6 +646,9 @@ int setup_profiling_timer(unsigned int multiplier)
  *
  * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
  * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ *
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 7f1f030..42bf69f 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -205,6 +205,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  *
  * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
  * MCE interrupts are supported. Thus MCE offset must be set to 0.
+ *
+ * If mask=1, the LVT entry does not generate interrupts while mask=0
+ * enables the vector. See also the BKDGs.
  */
 
 #define APIC_EILVT_LVTOFF_MCE 0
-- 
1.5.5.4


