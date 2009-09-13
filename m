Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZIMVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZIMVGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZIMVGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:06:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:12064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbZIMVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D/9MG7bT2h4FHQGUWGT55Hw4v+naueebzQU+A/Yo1mXO0Etzt5fIDeQ9Cw+U/lZOc+
         Q9Ol+PSeYXXn3W5Rl8kArRhbgnjG5pEMDp4K8NYLub5CYdubxu/798BDR3L7H1fkUoSW
         0fwJxFVbCDY6nZwxauEdX7pnbHcUisFxn9zVM=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: remove unused code in delay.S
Date: Mon, 14 Sep 2009 00:05:59 +0300
Message-Id: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/lib/delay.S |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/arm/lib/delay.S b/arch/arm/lib/delay.S
index 8d6a876..b741eb4 100644
--- a/arch/arm/lib/delay.S
+++ b/arch/arm/lib/delay.S
@@ -42,22 +42,6 @@ ENTRY(__const_udelay)				@ 0 <= r0 <= 0x7fffff06
 @ Delay routine
 ENTRY(__delay)
 		subs	r0, r0, #1
-#if 0
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-		movls	pc, lr
-		subs	r0, r0, #1
-#endif
 		bhi	__delay
 		mov	pc, lr
 ENDPROC(__udelay)
-- 
1.6.5.rc1

