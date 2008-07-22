Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYGVTbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYGVTbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYGVTZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:25:01 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:17141 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755546AbYGVTY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:59 -0400
X-BigFish: VPS26(z37d4jzzz10d3izzz32i87il43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9WX-01-8RX-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/24] x86/oprofile: Minor changes in op_model_athlon.c
Date: Tue, 22 Jul 2008 21:08:49 +0200
Message-ID: <1216753748-11261-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0042 (UTC) FILETIME=[71B65820:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index dd8b1dc..d25d7f1 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -45,6 +45,8 @@
 
 static unsigned long reset_value[NUM_COUNTERS];
 
+/* functions for op_athlon_spec */
+
 static void athlon_fill_in_addresses(struct op_msrs * const msrs)
 {
 	int i;
-- 
1.5.5.4


