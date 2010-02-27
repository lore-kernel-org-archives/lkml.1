Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030526Ab0B0RB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:01:26 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030449Ab0B0Q4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:56:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=fAvH2iLMt44EoJOonDx3fWBYMkMK6tEcd1GRdRhiNI6W2bvHFUgkC2+VdGek+EPH1n
         ndB2SG0Zwo6+Ka87AK8dbvUrurZ8Gixs5oezOugt/mFqqIEKTSTiwA+PrteNzRHcGLfl
         dkA3E2MngrcTUSQ3Q0+2ApH8d2xUCmzW2HTA8=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 44/66] arch/powerpc/sysdev/cpm2_pic.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:25 +0100
Message-Id: <1267289508-31031-45-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/powerpc/sysdev/cpm2_pic.h:6: ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/powerpc/sysdev/cpm2_pic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/cpm2_pic.h b/arch/powerpc/sysdev/cpm2_pic.h
index 30e5828..2c5f70c 100644
--- a/arch/powerpc/sysdev/cpm2_pic.h
+++ b/arch/powerpc/sysdev/cpm2_pic.h
@@ -3,6 +3,6 @@
 
 extern unsigned int cpm2_get_irq(void);
 
-extern void cpm2_pic_init(struct device_node*);
+extern void cpm2_pic_init(struct device_node *);
 
 #endif /* _PPC_KERNEL_CPM2_H */
-- 
1.7.0.90.g251a4

