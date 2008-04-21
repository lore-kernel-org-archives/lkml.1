Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYDUWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYDUWv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbYDUWu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:50:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52373 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbYDUWu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:50:57 -0400
Date: Tue, 22 Apr 2008 01:50:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make start_secondary() static
Message-ID: <20080421225026.GI2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

start_secondary() needlessly became global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
c2c97ec1631c669a4da2f3d927a47183a8de6784 diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 679c0ca..3000fff 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -301,7 +301,7 @@ void __cpuinit smp_callin(void)
 /*
  * Activate a secondary processor.
  */
-void __cpuinit start_secondary(void *unused)
+static void __cpuinit start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too

