Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYDWJvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYDWJvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYDWJu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:50:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36830 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYDWJu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:50:57 -0400
Date: Wed, 23 Apr 2008 12:50:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make smp_checks() static
Message-ID: <20080423095017.GH28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global smp_checks() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9a408bf30cc7e5197f8d61f25139184edefd890d diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3000fff..7d9b441 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -438,7 +438,7 @@ valid_k7:
 #endif
 }
 
-void __cpuinit smp_checks(void)
+static void __cpuinit smp_checks(void)
 {
 	if (smp_b_stepping)
 		printk(KERN_WARNING "WARNING: SMP operation may be unreliable"

