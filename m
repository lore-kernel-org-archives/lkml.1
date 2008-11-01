Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYKASVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYKASVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYKASUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:20:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58328 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYKASUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:20:30 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] [sparc32] kernel/trace/trace.c wants DIE_OOPS
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1KwL5J-0000V7-FB@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 01 Nov 2008 18:20:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/include/asm/kdebug_32.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/include/asm/kdebug_32.h b/arch/sparc/include/asm/kdebug_32.h
index f69fe7d..1d0b240 100644
--- a/arch/sparc/include/asm/kdebug_32.h
+++ b/arch/sparc/include/asm/kdebug_32.h
@@ -60,6 +60,7 @@ static inline void sp_enter_debugger(void)
 
 enum die_val {
 	DIE_UNUSED,
+	DIE_OOPS,
 };
 
 #endif /* !(__ASSEMBLY__) */
-- 
1.5.6.5


