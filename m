Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290Ab0AaUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0AaUER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042Ab0AaUCW
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:02:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1640 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0AaUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:19 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 01/10] arch/powerpc: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:03 -0800
Message-Id: <d8e2cb6523906c5e77bb13ea9ffc077a9310dc9e.1264967498.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kernel/nvram_64.c               |    6 +++---
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    8 ++++----
 arch/powerpc/platforms/pseries/smp.c         |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index ad461e7..9cf197f 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -338,8 +338,8 @@ static int __init nvram_create_os_partition(void)
 
 	rc = nvram_write_header(new_part);
 	if (rc <= 0) {
-		printk(KERN_ERR "nvram_create_os_partition: nvram_write_header \
-				failed (%d)\n", rc);
+		printk(KERN_ERR "nvram_create_os_partition: nvram_write_header "
+				"failed (%d)\n", rc);
 		return rc;
 	}
 
@@ -349,7 +349,7 @@ static int __init nvram_create_os_partition(void)
 	rc = ppc_md.nvram_write((char *)&seq_init, sizeof(seq_init), &tmp_index);
 	if (rc <= 0) {
 		printk(KERN_ERR "nvram_create_os_partition: nvram_write "
-				"failed (%d)\n", rc);
+		       "failed (%d)\n", rc);
 		return rc;
 	}
 	
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 6ea4698..a70de10 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -397,12 +397,12 @@ static int parse_cede_parameters(void)
 				CEDE_LATENCY_PARAM_MAX_LENGTH);
 
 	if (call_status != 0)
-		printk(KERN_INFO "CEDE_LATENCY: \
-			%s %s Error calling get-system-parameter(0x%x)\n",
+		printk(KERN_INFO "CEDE_LATENCY: "
+			"%s %s Error calling get-system-parameter(0x%x)\n",
 			__FILE__, __func__, call_status);
 	else
-		printk(KERN_INFO "CEDE_LATENCY: \
-			get-system-parameter successful.\n");
+		printk(KERN_INFO "CEDE_LATENCY: "
+			"get-system-parameter successful.\n");
 
 	return call_status;
 }
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index b488663..4e7f89a 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -144,8 +144,8 @@ static void __devinit smp_pSeries_kick_cpu(int nr)
 		hcpuid = get_hard_smp_processor_id(nr);
 		rc = plpar_hcall_norets(H_PROD, hcpuid);
 		if (rc != H_SUCCESS)
-			printk(KERN_ERR "Error: Prod to wake up processor %d\
-						Ret= %ld\n", nr, rc);
+			printk(KERN_ERR "Error: Prod to wake up processor %d "
+						"Ret= %ld\n", nr, rc);
 	}
 }
 
-- 
1.6.6.rc0.57.gad7a

