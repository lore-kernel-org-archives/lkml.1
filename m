Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYABMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYABMoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 07:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYABMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 07:44:10 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:18789 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYABMoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 07:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iJYvCQ0445japhfxRg6jNClF6b4GVTQU5llLzOxDvTAypRQ2AN0rUXkGRIKgN8tPgyGjcbzXApal2fPGAJ9Ss+vtDyGqVZZ52D0uefALPISX+Dp2En6uo0AXU3Yec3of6L7QlPuKzTIUqzXa/JmeU0hJy+UDiRSh/kSu4v8dDe8=
Subject: [PATCH] x86: fault_32.c cleanup
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 04:44:06 -0800
Message-Id: <1199277846.6323.64.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get die() from kdebug.h, no need for forward declaration.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/fault_32.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index bfb0917..870b561 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -42,8 +42,6 @@
 #define PF_RSVD	(1<<3)
 #define PF_INSTR	(1<<4)
 
-extern void die(const char *, struct pt_regs *, long);
-
 static inline int notify_page_fault(struct pt_regs *regs)
 {
 #ifdef CONFIG_KPROBES
-- 
1.5.4.rc2.1097.gb6e0d


