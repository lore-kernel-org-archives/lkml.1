Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYDWJw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYDWJw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYDWJvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59373 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYDWJvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:13 -0400
Date: Wed, 23 Apr 2008 12:50:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make smp_callin() static
Message-ID: <20080423095034.GM28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_callin() needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
79b46d1c5a18df072f85ae4dbc583fb0b1e66bc1 diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7d9b441..5fe569d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -213,7 +213,7 @@ static void unmap_cpu_to_logical_apicid(int cpu)
  * Report back to the Boot Processor.
  * Running on AP.
  */
-void __cpuinit smp_callin(void)
+static void __cpuinit smp_callin(void)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;

