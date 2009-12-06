Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZLFCbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZLFCbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 21:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZLFCbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 21:31:33 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36492 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbZLFCbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 21:31:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jN+qn87jM11nGm26Napa+VU9bAhsSc9TJHocFI2SMzIc7lI4WyiPBODq84rZs9f5X+
         3qaLHML9Op/LZMr63FJqbl8YQczuGCM3q++De5RSTM3p4hKr3yWJJam/aHwcSh4BFuVf
         Aa+GeKJljEJN1ppzDo6ceQEqLzUztt2BTTHDk=
From: Shaun Patterson <shaunpatterson@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Shaun Patterson <shaunpatterson@gmail.com>
Subject: [PATCH 1/1] Staging: Fixed spelling mistake
Date: Sat,  5 Dec 2009 22:30:52 -0500
Message-Id: <1260070252-19445-1-git-send-email-shaunpatterson@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Shaun Patterson <shaunpatterson@gmail.com>
---
 arch/x86/kernel/vmiclock_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 611b9e2..a58ccae 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -171,7 +171,7 @@ static int vmi_timer_next_event(unsigned long delta,
 {
 	/* Unfortunately, set_next_event interface only passes relative
 	 * expiry, but we want absolute expiry.  It'd be better if were
-	 * were passed an aboslute expiry, since a bunch of time may
+	 * were passed an absolute expiry, since a bunch of time may
 	 * have been stolen between the time the delta is computed and
 	 * when we set the alarm below. */
 	cycle_t now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_ONESHOT));
-- 
1.6.0.2

