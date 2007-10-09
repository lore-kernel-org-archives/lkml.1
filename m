Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXJIMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXJIMuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 08:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXJIMuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 08:50:15 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:65303 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbXJIMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 08:50:13 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
cc: "Joerg Roedel" <joerg.roedel@amd.com>,
       "Christoph Egger" <Christoph.Egger@amd.com>
Subject: [PATCH 2/2] i386: mce cleanup part2: conding style cleanups
Date: Tue,  9 Oct 2007 14:49:56 +0200
Message-ID: <11919341961670-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11919341961890-git-send-email-joerg.roedel@amd.com>
References: <11919341961890-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Oct 2007 12:49:57.0227 (UTC)
 FILETIME=[E5752BB0:01C80A72]
MIME-Version: 1.0
X-WSS-ID: 6B15A7701DW1286361-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove one indent level

Signed-off-by: Christoph Egger <Christoph.Egger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/i386/kernel/cpu/mcheck/mce.c |   40 ++++++++++++++++++------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/i386/kernel/cpu/mcheck/mce.c b/arch/i386/kernel/cpu/mcheck/mce.c
index bad2c64..fd743c3 100644
--- a/arch/i386/kernel/cpu/mcheck/mce.c
+++ b/arch/i386/kernel/cpu/mcheck/mce.c
@@ -48,26 +48,26 @@ void mcheck_init(struct cpuinfo_x86 *c)
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



