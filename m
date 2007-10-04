Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXJDLkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXJDLkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757907AbXJDL3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:29:21 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:57486 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbXJDL22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:28 -0400
Message-Id: <20071004112830.024915273@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:26 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 20/34] disassembler: Remove redundant variable assignment
Content-Disposition: inline; filename=020-dis-assign.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

There is no need to assign "0" to "hops" twice. Remove one assigment.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/dis.c |    1 -
 1 file changed, 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/dis.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/dis.c
+++ quilt-2.6/arch/s390/kernel/dis.c
@@ -1243,7 +1243,6 @@ void show_code(struct pt_regs *regs)
 	}
 	/* Find a starting point for the disassembly. */
 	while (start < 32) {
-		hops = 0;
 		for (i = 0, hops = 0; start + i < 32 && hops < 3; hops++) {
 			if (!find_insn(code + start + i))
 				break;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

