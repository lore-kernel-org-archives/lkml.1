Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZGVC4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZGVC4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZGVC4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:56:52 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47314 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbZGVC4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:56:51 -0400
X-AuditID: b753bd60-ad649ba000006009-84-4a667ff0dc9a
Message-ID: <4A667FD4.3010509@hitachi.com>
Date: Wed, 22 Jul 2009 11:56:20 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, ak@linux.intel.com,
       seto.hidetoshi@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: [PATCH] x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_X86_THRESHOLD used in arch/x86/kernel/irqinit.c is always
undefined.  Rename it to the correct name "CONFIG_X86_MCE_THRESHOLD".

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 arch/x86/kernel/irqinit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 8a194ad..ccf8ab5 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -187,7 +187,7 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
-#ifdef CONFIG_X86_THRESHOLD
+#ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
 #if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
-- 
1.6.2.5

-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

