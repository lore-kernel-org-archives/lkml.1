Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXCNJSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXCNJSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXCNJSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:18:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60480 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030761AbXCNJSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:18:30 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 4/17] constant should be long
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HRPcs-0003QH-0N@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:18:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/kernel/udbg_16550.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
index e738f93..a963f65 100644
--- a/arch/powerpc/kernel/udbg_16550.c
+++ b/arch/powerpc/kernel/udbg_16550.c
@@ -184,7 +184,7 @@ void udbg_pas_real_putc(char c)
 
 void udbg_init_pas_realmode(void)
 {
-	udbg_comport = (volatile struct NS16550 __iomem *)0xfcff03f8;
+	udbg_comport = (volatile struct NS16550 __iomem *)0xfcff03f8UL;
 
 	udbg_putc = udbg_pas_real_putc;
 	udbg_getc = NULL;
-- 
1.5.0-rc2.GIT


