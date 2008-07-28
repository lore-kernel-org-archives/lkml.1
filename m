Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYG1VMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYG1VMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYG1VJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:39 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbYG1VJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:38 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 09/24] x86: kernel/irq_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:16 -0300
Message-Id: <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/irq_64.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 1f78b23..63c7b8a 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -277,18 +277,18 @@ extern void call_softirq(void);
 
 asmlinkage void do_softirq(void)
 {
- 	__u32 pending;
- 	unsigned long flags;
+	__u32 pending;
+	unsigned long flags;
 
- 	if (in_interrupt())
- 		return;
+	if (in_interrupt())
+		return;
 
- 	local_irq_save(flags);
- 	pending = local_softirq_pending();
- 	/* Switch to interrupt stack */
- 	if (pending) {
+	local_irq_save(flags);
+	pending = local_softirq_pending();
+	/* Switch to interrupt stack */
+	if (pending) {
 		call_softirq();
 		WARN_ON_ONCE(softirq_count());
 	}
- 	local_irq_restore(flags);
+	local_irq_restore(flags);
 }
-- 
1.5.4.5

