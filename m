Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbXJKMSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbXJKMSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXJKMSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:18:17 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:65228 "EHLO
	outbound6-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746AbXJKMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:18:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "Christoph Egger" <Christoph.Egger@amd.com>
Subject: [PATCH 2/2] x86: mce minor indent cleanup
Date: Thu, 11 Oct 2007 14:17:54 +0200
Message-ID: <11921050752495-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11921050742274-git-send-email-joerg.roedel@amd.com>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Oct 2007 12:17:55.0507 (UTC)
 FILETIME=[C0D97830:01C80C00]
MIME-Version: 1.0
X-WSS-ID: 6B10CBF70601502551-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove one indent level

Signed-off-by: Christoph Egger <Christoph.Egger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   40 +++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e1ac4f7..bc61f1e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -45,26 +45,26 @@ void mcheck_init(struct cpuinfo_x86 *c)
 	}
 
 	switch (c->x86_vendor) {
-		case X86_VENDOR_AMD:
-			amd_mcheck_init(c);
-			break;
-
-		case X86_VENDOR_INTEL:
-			if (c->x86==5)
-				intel_p5_mcheck_init(c);
-			if (c->x86==6)
-				intel_p6_mcheck_init(c);
-			if (c->x86==15)
-				intel_p4_mcheck_init(c);
-			break;
-
-		case X86_VENDOR_CENTAUR:
-			if (c->x86==5)
-				winchip_mcheck_init(c);
-			break;
-
-		default:
-			break;
+	case X86_VENDOR_AMD:
+		amd_mcheck_init(c);
+		break;
+
+	case X86_VENDOR_INTEL:
+		if (c->x86==5)
+			intel_p5_mcheck_init(c);
+		if (c->x86==6)
+			intel_p6_mcheck_init(c);
+		if (c->x86==15)
+			intel_p4_mcheck_init(c);
+		break;
+
+	case X86_VENDOR_CENTAUR:
+		if (c->x86==5)
+			winchip_mcheck_init(c);
+		break;
+
+	default:
+		break;
 	}
 }
 
-- 
1.5.2.5



