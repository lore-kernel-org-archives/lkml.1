Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZFLNBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZFLNBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762392AbZFLM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:19 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:41838
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760023AbZFLM7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:17 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KL4MQJ-03-HW1-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/23] x86/oprofile: minor style changes in struct op_x86_model_spec
Date: Fri, 12 Jun 2009 14:35:20 +0200
Message-ID: <1244810140-20595-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0686 (UTC) FILETIME=[912C5F60:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some vertical alignments. Variables are now located in the beginning
of the struct.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_x86_model.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index ed27783..bd8157d 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -32,17 +32,17 @@ struct pt_regs;
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
-	int (*init)(struct oprofile_operations *ops);
-	void (*exit)(void);
-	unsigned int num_counters;
-	unsigned int num_controls;
-	void (*fill_in_addresses)(struct op_msrs * const msrs);
-	void (*setup_ctrs)(struct op_msrs const * const msrs);
-	int (*check_ctrs)(struct pt_regs * const regs,
-		struct op_msrs const * const msrs);
-	void (*start)(struct op_msrs const * const msrs);
-	void (*stop)(struct op_msrs const * const msrs);
-	void (*shutdown)(struct op_msrs const * const msrs);
+	unsigned int	num_counters;
+	unsigned int	num_controls;
+	int		(*init)(struct oprofile_operations *ops);
+	void		(*exit)(void);
+	void		(*fill_in_addresses)(struct op_msrs * const msrs);
+	void		(*setup_ctrs)(struct op_msrs const * const msrs);
+	int		(*check_ctrs)(struct pt_regs * const regs,
+				      struct op_msrs const * const msrs);
+	void		(*start)(struct op_msrs const * const msrs);
+	void		(*stop)(struct op_msrs const * const msrs);
+	void		(*shutdown)(struct op_msrs const * const msrs);
 };
 
 extern struct op_x86_model_spec const op_ppro_spec;
-- 
1.6.3.1


