Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbZGGPBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbZGGPBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbZGGPBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:01:42 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4536 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbZGGPBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:01:41 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2009 11:01:41 EDT
X-SpamScore: 7
X-BigFish: VPS7(zzzz1202hzzz32i87h41i42k43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KMF2CK-02-55G-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86/oprofile: rename kernel parameter for architectural perfmon to arch_perfmon
Date: Tue, 7 Jul 2009 16:43:29 +0200
Message-ID: <1246977809-8253-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 07 Jul 2009 14:45:59.0189 (UTC) FILETIME=[A43F0450:01C9FF11]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The short name of the achitecture is 'arch_perfmon'. This patch
changes the kernel parameter to use this name.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 Documentation/kernel-parameters.txt |    4 ++--
 arch/x86/oprofile/nmi_int.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d08759a..fd64b54 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1720,8 +1720,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	oprofile.cpu_type=	Force an oprofile cpu type
 			This might be useful if you have an older oprofile
 			userland or if you want common events.
-			Format: { archperfmon }
-			archperfmon: [X86] Force use of architectural
+			Format: { arch_perfmon }
+			arch_perfmon: [X86] Force use of architectural
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b07dd8d..89b9a5c 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -390,7 +390,7 @@ static int __init p4_init(char **cpu_type)
 static int force_arch_perfmon;
 static int force_cpu_type(const char *str, struct kernel_param *kp)
 {
-	if (!strcmp(str, "archperfmon")) {
+	if (!strcmp(str, "arch_perfmon")) {
 		force_arch_perfmon = 1;
 		printk(KERN_INFO "oprofile: forcing architectural perfmon\n");
 	}
-- 
1.6.3.1


