Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZEWQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZEWQvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbZEWQv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:51:29 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4916 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbZEWQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:51:27 -0400
Subject: [PATCH] acpi-cpufreq.c - Fix typo and indentation
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 23 May 2009 09:50:45 -0700
Message-Id: <1243097445.3506.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 208ecf6..54b6de2 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -693,8 +693,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
 	    policy->cpuinfo.transition_latency > 20 * 1000) {
 		policy->cpuinfo.transition_latency = 20 * 1000;
-			printk_once(KERN_INFO "Capping off P-state tranision"
-				    " latency at 20 uS\n");
+		printk_once(KERN_INFO
+			    "P-state transition latency capped at 20 uS\n");
 	}
 
 	/* table init */


