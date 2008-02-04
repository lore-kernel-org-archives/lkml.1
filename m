Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYBDH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYBDH6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 02:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYBDH6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 02:58:03 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:4446 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYBDH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 02:58:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bemhJj1SL1X0q42wJP3w1DSvdrzdj5QYGN/wJFVbOSix8AS2mg/XaewP8m4jbBkoUTqHooORyCnxLhqtKREbeyTJTwARR1JgT6ZKQZEgAOy4xV3hzYLK9vcn5hcsB/x5EThKT9nZMcKOOLbNacnPizLGO5MHA5+aHKZ8Nc3MQxE=
Subject: [PATCH] x86: trivial sparse/checkpatch in quirks.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 23:58:13 -0800
Message-Id: <1202111893.1844.74.camel@brick>
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
The remaining checkpatch errors are false positives.

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



