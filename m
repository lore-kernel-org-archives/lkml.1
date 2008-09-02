Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYIBJQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYIBJQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYIBJP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:15:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25674 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYIBJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:15:58 -0400
X-BigFish: VPS-7(zz936eQzz10d3izzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K6K9Q7-02-FT2-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86/oprofile: fix duplicate function declarations
Date: Tue, 2 Sep 2008 11:04:04 +0200
Message-ID: <1220346244-15674-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0
X-OriginalArrivalTime: 02 Sep 2008 09:15:44.0927 (UTC) FILETIME=[7ACB92F0:01C90CDC]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes duplicate function declarations intrduced with commit
19263c35e6de34095ec208015bf472df1a725c63.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index d4c2f2d..c9374e1 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -36,8 +36,6 @@ static void nmi_cpu_start(void *dummy);
 static void nmi_cpu_stop(void *dummy);
 static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs);
 static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs);
-static void nmi_cpu_stop(void *dummy);
-static void nmi_cpu_start(void *dummy);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
-- 
1.6.0


