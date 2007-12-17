Return-Path: <linux-kernel-owner+w=401wt.eu-S933174AbXLQTim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbXLQTim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761194AbXLQTbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:46 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2975 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760874AbXLQTbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:40 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH] arch/um: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:23 -0800
Message-Id: <1197919875-5288-24-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/sys-x86_64/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index 1778d33..3a63862 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -112,7 +112,7 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 	err |= PUTREG(regs, RSI, to, rsi);
 	err |= PUTREG(regs, RBP, to, rbp);
 	/*
-	 * Must use orignal RSP, which is passed in, rather than what's in
+	 * Must use original RSP, which is passed in, rather than what's in
 	 * the pt_regs, because that's already been updated to point at the
 	 * signal frame.
 	 */
-- 
1.5.3.7.949.g2221a6

