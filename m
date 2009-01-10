Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZAJSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZAJSH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZAJSHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:07:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:50806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZAJSHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:07:08 -0500
Subject: [PATCH -tip] x86: microcode_intel.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, tigran@aivazian.fsnet.co.uk,
       shaohua.li@intel.com, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 23:34:48 +0530
Message-Id: <1231610688.3994.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Fix:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ERROR: trailing whitespace
ERROR: "(foo*)" should be "(foo *)"

 total: 3 errors, 1 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/microcode_intel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index b7f4c92..5e9f4fc 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -87,9 +87,9 @@
 #include <linux/cpu.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/microcode.h>
 
@@ -196,7 +196,7 @@ static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
 }
 
-static inline int 
+static inline int
 update_match_revision(struct microcode_header_intel *mc_header,	int rev)
 {
 	return (mc_header->rev <= rev) ? 0 : 1;
@@ -442,8 +442,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 		return ret;
 	}
 
-	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
-			&get_ucode_fw);
+	ret = generic_load_microcode(cpu, (void *)firmware->data,
+				     firmware->size, &get_ucode_fw);
 
 	release_firmware(firmware);
 
@@ -460,7 +460,7 @@ static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu != raw_smp_processor_id());
 
-	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
+	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }
 
 static void microcode_fini_cpu(int cpu)
-- 
1.5.6.6



