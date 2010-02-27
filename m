Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506Ab0B0Q5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:57:11 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030489Ab0B0Q4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kf3S26Wh+sKyZeJJs9wC4qLWM42XGCBGifjyT/mVV8d/Er+MC2qy7a2M1BxJm9sWBp
         9J0lbRsolbSU2vG24lTpJaFTiw5UrcfCCaajWvve3VRigtVihq083Lkj2xCCM76yz4XX
         JEToNldaS0yCh47MzxSgbZNrYKb24vY2Rcoio=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 49/66] arch/cris/include/arch-v32/arch/intmem.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:30 +0100
Message-Id: <1267289508-31031-50-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/include/arch-v32/arch/intmem.h:4: ERROR: "foo* bar" should be "foo *bar"
arch/cris/include/arch-v32/arch/intmem.h:5: ERROR: "foo* bar" should be "foo *bar"
arch/cris/include/arch-v32/arch/intmem.h:6: ERROR: "foo* bar" should be "foo *bar"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/cris/include/arch-v32/arch/intmem.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/cris/include/arch-v32/arch/intmem.h b/arch/cris/include/arch-v32/arch/intmem.h
index c0ada33..46b05ee 100644
--- a/arch/cris/include/arch-v32/arch/intmem.h
+++ b/arch/cris/include/arch-v32/arch/intmem.h
@@ -1,9 +1,9 @@
 #ifndef _ASM_CRIS_INTMEM_H
 #define _ASM_CRIS_INTMEM_H
 
-void* crisv32_intmem_alloc(unsigned size, unsigned align);
-void crisv32_intmem_free(void* addr);
-void* crisv32_intmem_phys_to_virt(unsigned long addr);
+void *crisv32_intmem_alloc(unsigned size, unsigned align);
+void crisv32_intmem_free(void *addr);
+void *crisv32_intmem_phys_to_virt(unsigned long addr);
 unsigned long crisv32_intmem_virt_to_phys(void *addr);
 
 #endif /* _ASM_CRIS_ARCH_INTMEM_H */
-- 
1.7.0.90.g251a4

