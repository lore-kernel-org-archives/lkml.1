Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbZGDWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbZGDWe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZGDWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 18:34:19 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:43828 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZGDWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 18:34:19 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: rjw@sisk.pl
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/3] Trivial: fix typo in label name s/Platofrm_finish/Platform_finish/
Date: Sat,  4 Jul 2009 19:33:35 -0300
Message-Id: <1246746815-12146-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the same label name is used somewhere else in the file, this
particular label was consistently typoed in all of its uses.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 kernel/power/hibernate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 81d2e74..ec82025 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -460,11 +460,11 @@ int hibernation_platform_enter(void)
 
 	error = hibernation_ops->prepare();
 	if (error)
-		goto Platofrm_finish;
+		goto Platform_finish;
 
 	error = disable_nonboot_cpus();
 	if (error)
-		goto Platofrm_finish;
+		goto Platform_finish;
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
@@ -476,7 +476,7 @@ int hibernation_platform_enter(void)
 	 * We don't need to reenable the nonboot CPUs or resume consoles, since
 	 * the system is going to be halted anyway.
 	 */
- Platofrm_finish:
+ Platform_finish:
 	hibernation_ops->finish();
 
 	dpm_suspend_noirq(PMSG_RESTORE);
-- 
1.6.3

