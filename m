Return-Path: <linux-kernel-owner+w=401wt.eu-S1765369AbYBTXSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765369AbYBTXSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYBTXSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:18:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:47346 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbYBTXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=bnrud2s/RFoZyo9dAuhmmxtd4I5HzT+U0dtebnj3EFIZs4yZZ9FDrFh9+1kpih47uW26VFOkqryP9tQEMg2ppwcC+FYwUxYsPYFKEHO5IxoYn/0ZJBli1/DVXhaJ+z1ijLCRfpMHdV2pB60i+MHRiKEIVmICjiE9jRjZ5CQBsRM=
Date: Thu, 21 Feb 2008 00:18:34 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: Coding style fixes to arch/x86/kernel/cpu/umc.c
Message-ID: <20080221001834.02229a2a@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the patch:
total: 0 errors, 0 warnings, 25 lines checked
arch/x86/kernel/cpu/umc.c has no obvious style problems and is ready for submission.

Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/umc.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index b1acf08..b1fc909 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -3,17 +3,19 @@
 #include <asm/processor.h>
 #include "cpu.h"
 
-/* UMC chips appear to be only either 386 or 486, so no special init takes place.
+/*
+ * UMC chips appear to be only either 386 or 486,
+ * so no special init takes place.
  */
 
 static struct cpu_dev umc_cpu_dev __cpuinitdata = {
 	.c_vendor	= "UMC",
-	.c_ident 	= { "UMC UMC UMC" },
+	.c_ident	= { "UMC UMC UMC" },
 	.c_models = {
 		{ .vendor = X86_VENDOR_UMC, .family = 4, .model_names =
-		  { 
-			  [1] = "U5D", 
-			  [2] = "U5S", 
+		  {
+			  [1] = "U5D",
+			  [2] = "U5S",
 		  }
 		},
 	},
-- 
1.5.4.1.183.gf873

