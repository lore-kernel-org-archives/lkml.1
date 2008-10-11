Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbYJKHkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbYJKHkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbYJKHh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:27 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:48127 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356AbYJKHhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:25 -0400
Date: Sat, 11 Oct 2008 02:36:29 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 69/85] ACPI: don't load acpi_cpufreq if acpi=off
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Len Brown <len.brown@intel.com>
Message-id: <ee297533279a802eac8b1cbea8e65b24b36a1aac.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index dd097b8..9943b4c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -779,6 +779,9 @@ static int __init acpi_cpufreq_init(void)
 {
 	int ret;
 
+	if (acpi_disabled)
+		return 0;
+
 	dprintk("acpi_cpufreq_init\n");
 
 	ret = acpi_cpufreq_early_init();
-- 
1.5.5.1

