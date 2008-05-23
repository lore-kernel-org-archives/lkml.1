Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbYEWNOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbYEWNOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYEWNNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:13:16 -0400
Received: from gw.goop.org ([64.81.55.164]:33954 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbYEWNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:13:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 5] x86: use symbolic constant in stts()
X-Mercurial-Node: aadbeed1909f40057097eb502df7ac71ca6ce14c
Message-Id: <aadbeed1909f40057097.1211548256@localhost>
In-Reply-To: <patchbomb.1211548253@localhost>
Date: Fri, 23 May 2008 14:10:56 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -293,7 +293,7 @@
 
 #endif/* CONFIG_PARAVIRT */
 
-#define stts() write_cr0(8 | read_cr0())
+#define stts() write_cr0(read_cr0() | X86_CR0_TS)
 
 #endif /* __KERNEL__ */
 


