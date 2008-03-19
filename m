Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbYCSTjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbYCSTjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYCSTag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbYCSTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:35 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 08/79] [PATCH] use identify_boot_cpu
Date: Wed, 19 Mar 2008 14:25:03 -0300
Message-Id: <12059476123203-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947607406-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Call this function instead of identify_cpu in bugs_64.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/bugs_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/bugs_64.c b/arch/x86/kernel/bugs_64.c
index 8f520f9..60207e9 100644
--- a/arch/x86/kernel/bugs_64.c
+++ b/arch/x86/kernel/bugs_64.c
@@ -12,7 +12,7 @@
 
 void __init check_bugs(void)
 {
-	identify_cpu(&boot_cpu_data);
+	identify_boot_cpu();
 #if !defined(CONFIG_SMP)
 	printk("CPU: ");
 	print_cpu_info(&boot_cpu_data);
-- 
1.5.0.6

