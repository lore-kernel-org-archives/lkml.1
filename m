Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYDUVcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYDUVcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYDUVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:07 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49720 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYDUVcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:06 -0400
Date: Tue, 22 Apr 2008 00:31:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make impress_friends() static
Message-ID: <20080421213133.GE2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global impress_friends() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -579,7 +579,7 @@ void __init smp_alloc_memory(void)
 }
 #endif
 
-void impress_friends(void)
+static void impress_friends(void)
 {
 	int cpu;
 	unsigned long bogosum = 0;
