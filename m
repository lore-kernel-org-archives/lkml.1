Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYGVT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYGVT2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYGVTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:09 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40748 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYGVTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:01 -0400
X-BigFish: VPS26(z37d4jzzz10d3izzz32i87il43j67h)
X-Spam-TCS-SCL: 6:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VD-02-3LW-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 14/24] OProfile: Fix build error in op_model_athlon.c
Date: Tue, 22 Jul 2008 21:08:58 +0200
Message-ID: <1216753748-11261-15-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0011 (UTC) FILETIME=[724A33B0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 90193b1..284c456 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -73,6 +73,11 @@
 /* MSR to set the IBS control register APIC LVT offset */
 #define IBS_LVT_OFFSET_PCI		0x1CC
 
+/* The function interface needs to be fixed, something like add
+   data. Should then be added to linux/oprofile.h. */
+extern void oprofile_add_ibs_sample(struct pt_regs *const regs,
+				    unsigned int * const ibs_sample, u8 code);
+
 struct ibs_fetch_sample {
 	/* MSRC001_1031 IBS Fetch Linear Address Register */
 	unsigned int ibs_fetch_lin_addr_low;
-- 
1.5.5.4


