Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbYDTCzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbYDTCzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYDTCyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:54:39 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:53355 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbYDTCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:54:37 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86: remove unused function amd_init_cpu()
Date: Sun, 20 Apr 2008 06:54:31 +0400
Message-Id: <1208660074-7324-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp01.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users for the function amd_init_cpu() defined in
arch/x86/kernel/cpu/amd.c. This patch removes this routine.

This patch was build-tested using defconfigs for i386 and x86_64,
and a few randconfig instances. Runtime tests were performed by
booting 32- and 64-bit x86 boxen up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/kernel/cpu/amd.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0173065..2458668 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -343,10 +343,4 @@ static struct cpu_dev amd_cpu_dev __cpuinitdata = {
 	.c_size_cache	= amd_size_cache,
 };
 
-int __init amd_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_AMD] = &amd_cpu_dev;
-	return 0;
-}
-
 cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
-- 
1.5.3

