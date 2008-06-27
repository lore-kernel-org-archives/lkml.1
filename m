Return-Path: <linux-kernel-owner+w=401wt.eu-S1763985AbYF0Vgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763985AbYF0Vgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbYF0Vgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:36:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbYF0Vgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:36:42 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 01/39] Don't use size specifiers
Date: Fri, 27 Jun 2008 18:34:08 -0300
Message-Id: <1214602486-17080-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "l" from inline asm at arch/x86/lib/delay_32.c.
It is not needed.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/delay_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index ef69131..54013f8 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -38,9 +38,9 @@ static void delay_loop(unsigned long loops)
 		"1:	jmp 2f		\n"
 
 		".align 16		\n"
-		"2:	decl %0		\n"
+		"2:	dec %0		\n"
 		"	jnz 2b		\n"
-		"3:	decl %0		\n"
+		"3:	dec %0		\n"
 
 		: /* we don't need output */
 		:"a" (loops)
-- 
1.5.5.1

