Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbYBEUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbYBEUlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbYBEUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:41:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:57990 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758925AbYBEUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lkFR2uuaS4weFqTVj77N/Pjkz/tzCI0ioCKwIimA5xvr4wQ1GfWMMCD3+bJt2bpedH06a54v4JGDqwSbBUdBK/vIpQjEsaBJE9TIVE2xTkdzIg0L5o2BGqtjw2V+O3cJXWjeaU1IMwEALLqtRUjuk7kEY53AAYMTLiaZkiRmys0=
Subject: [PATCH 4/8] x86: trivial sparse/checkpatch in quirks.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:41:23 -0800
Message-Id: <1202244083.18081.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix the style of the switch statement while here.

arch/x86/kernel/quirks.c:384:3: warning: returning void-valued expression
arch/x86/kernel/quirks.c:387:3: warning: returning void-valued expression
arch/x86/kernel/quirks.c:390:3: warning: returning void-valued expression
arch/x86/kernel/quirks.c:393:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/quirks.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 3cd7a2d..6ba33ca 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -380,19 +380,19 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x0367,
 void force_hpet_resume(void)
 {
 	switch (force_hpet_resume_type) {
-	    case ICH_FORCE_HPET_RESUME:
-		return ich_force_hpet_resume();
-
-	    case OLD_ICH_FORCE_HPET_RESUME:
-		return old_ich_force_hpet_resume();
-
-	    case VT8237_FORCE_HPET_RESUME:
-		return vt8237_force_hpet_resume();
-
-	    case NVIDIA_FORCE_HPET_RESUME:
-		return nvidia_force_hpet_resume();
-
-	    default:
+	case ICH_FORCE_HPET_RESUME:
+		ich_force_hpet_resume();
+		return;
+	case OLD_ICH_FORCE_HPET_RESUME:
+		old_ich_force_hpet_resume();
+		return;
+	case VT8237_FORCE_HPET_RESUME:
+		vt8237_force_hpet_resume();
+		return;
+	case NVIDIA_FORCE_HPET_RESUME:
+		nvidia_force_hpet_resume();
+		return;
+	default:
 		break;
 	}
 }
-- 
1.5.4.rc5.1138.g2602


