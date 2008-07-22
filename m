Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbYGVT2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbYGVT2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYGVTYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:13 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40748 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbYGVTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:03 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9V8-01-8PE-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Barry Kasindorf <barry.kasindorf@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/24] oprofile: Add support for AMD Family 11h
Date: Tue, 22 Jul 2008 21:08:47 +0200
Message-ID: <1216753748-11261-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:38.0933 (UTC) FILETIME=[71A5B650:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Kasindorf <barry.kasindorf@amd.com>

This patch add support for AMD Family 11h CPUs.

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 7f3329b..cf28a02 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -422,6 +422,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 			model = &op_athlon_spec;
 			cpu_type = "x86-64/family10";
 			break;
+		case 0x11:
+			model = &op_athlon_spec;
+			cpu_type = "x86-64/family11h";
+			break;
 		}
 		break;
 
-- 
1.5.5.4


