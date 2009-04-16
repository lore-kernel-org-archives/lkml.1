Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZDPKDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZDPKDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbZDPKCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:02:40 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54400 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756997AbZDPKCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:02:39 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 01/11] microblaze: Remove unneded per cpu SYSCALL_SAVE variable
Date: Thu, 16 Apr 2009 11:56:28 +0200
Message-Id: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/entry.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
index 7f57e42..1019d88 100644
--- a/arch/microblaze/include/asm/entry.h
+++ b/arch/microblaze/include/asm/entry.h
@@ -29,7 +29,6 @@ DECLARE_PER_CPU(unsigned int, KM); /* Kernel/user mode */
 DECLARE_PER_CPU(unsigned int, ENTRY_SP); /* Saved SP on kernel entry */
 DECLARE_PER_CPU(unsigned int, R11_SAVE); /* Temp variable for entry */
 DECLARE_PER_CPU(unsigned int, CURRENT_SAVE); /* Saved current pointer */
-DECLARE_PER_CPU(unsigned int, SYSCALL_SAVE); /* Saved syscall number */
 # endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_MICROBLAZE_ENTRY_H */
-- 
1.5.5.1

