Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYCCROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYCCROm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbYCCROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349AbYCCROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:01 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 01/52] commonize smp.h
Date: Mon,  3 Mar 2008 14:12:29 -0300
Message-Id: <1204564400-17636-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is the first step of integrating smp.h between x86_64
and i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/smp.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index f2e8319..f250d1c 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -1,5 +1,12 @@
+#ifndef _ASM_X86_SMP_H_
+#define _ASM_X86_SMP_H_
+#ifndef __ASSEMBLY__
+
 #ifdef CONFIG_X86_32
 # include "smp_32.h"
 #else
 # include "smp_64.h"
 #endif
+
+#endif /* __ASSEMBLY__ */
+#endif
-- 
1.5.0.6

