Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYDWJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYDWJva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYDWJvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:00 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36836 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYDWJu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:50:59 -0400
Date: Wed, 23 Apr 2008 12:50:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make smp_b_stepping static
Message-ID: <20080423095020.GI28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_b_stepping needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9a408bf30cc7e5197f8d61f25139184edefd890d diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3000fff..7d9b441 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -147,7 +147,7 @@ unsigned char *trampoline_base = __va(TRAMPOLINE_BASE);
 static cpumask_t cpu_sibling_setup_map;
 
 /* Set if we find a B stepping CPU */
-int __cpuinitdata smp_b_stepping;
+static int __cpuinitdata smp_b_stepping;
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_32)
 

