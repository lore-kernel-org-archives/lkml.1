Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbYAWSFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbYAWSFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYAWSFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:05:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:59403 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbYAWSFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:05:43 -0500
Message-ID: <479781E3.2000109@ct.jp.nec.com>
Date: Wed, 23 Jan 2008 10:05:23 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: remove struct cpu_model_info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86_64: remove struct cpu_model_info

No one uses struct cpu_model_info on x86_64 now.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/setup_64.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 2643a8f..eb722b0 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -881,12 +881,6 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 		c->x86_vendor = X86_VENDOR_UNKNOWN;
 }
 
-struct cpu_model_info {
-	int vendor;
-	int family;
-	char *model_names[16];
-};
-
 /* Do some early cpuid on the boot CPU to get some parameter that are
    needed before check_bugs. Everything advanced is in identify_cpu
    below. */
-- 
1.5.3.7

