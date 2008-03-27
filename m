Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbYC0Vzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbYC0Vzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbYC0VzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:55:22 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41814 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbYC0VzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:55:22 -0400
Message-ID: <47EC17C7.8020401@tiscali.nl>
Date: Thu, 27 Mar 2008 22:55:19 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: hare@suse.de
CC: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 resend] aic7xxx_old: aicasm_gram.y: Test opcode in type_check()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/scsi/aic7xxx_old/sequencer.h:130:#define AIC_OP_JZ 0xf
--
Test opcode, not definition

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 6066998..702e2db 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -1837,7 +1837,7 @@ type_check(symbol_t *symbol, expression_t *expression, int opcode)
 	int and_op;
 
 	and_op = FALSE;
-	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ || AIC_OP_JZ)
+	if (opcode == AIC_OP_AND || opcode == AIC_OP_JNZ || opcode == AIC_OP_JZ)
 		and_op = TRUE;
 
 	/*

