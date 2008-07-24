Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbYGXOCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbYGXOCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYGXOB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:01:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:60892 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbYGXOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:01:57 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4IKAR-02-SO3-01
From: Robert Richter <robert.richter@amd.com>
To: Jason Yeh <jason.yeh@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] x86/oprofile: Fix on_each_cpu build error
Date: Thu, 24 Jul 2008 16:00:16 +0200
Message-ID: <1216908016-8495-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 24 Jul 2008 14:01:30.0141 (UTC) FILETIME=[C59D9CD0:01C8ED95]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 186ab90..053c8c6 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -123,7 +123,7 @@ static int nmi_switch_event(void)
 	if (nmi_multiplex_on() < 0)
 		return -EINVAL;
 
-	on_each_cpu(nmi_cpu_switch, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_switch, NULL, 1);
 
 	return 0;
 }
-- 
1.5.5.4


