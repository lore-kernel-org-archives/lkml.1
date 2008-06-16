Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYFPXAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYFPXAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYFPXAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:00:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYFPXAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:00:23 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH] typo CONFIX -> CONFIG
Date: Mon, 16 Jun 2008 19:59:08 -0300
Message-Id: <1213657148-5263-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/x86/kernel/nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 07cf17f..3775463 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -69,7 +69,7 @@ static inline unsigned int get_nmi_count(int cpu)
 
 static inline int mce_in_progress(void)
 {
-#if defined(CONFIX_X86_64) && defined(CONFIG_X86_MCE)
+#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
 	return atomic_read(&mce_entry) > 0;
 #endif
 	return 0;
-- 
1.5.4.5

