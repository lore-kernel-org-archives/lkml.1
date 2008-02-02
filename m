Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbYBBHso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbYBBHso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYBBHsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:48:33 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:59559 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYBBHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vfx8tOzuC03zJDOLXDRLgB0ZPCfaUnOm4nBilRoDVO4P1jfCMObAnPZWnR5Z2vtp9g7KwLsUzugiklSnt4a4xIcy8I8+hoM9XTrAx4nliIwtjw3MTXWaxXrmyooQAMOUMpHgmIm3tseAYf7CSJdyPKzB1kOQuHHgtxA2A0a1eH4=
Subject: [PATCH 1/3] x86: add include to cpu/intel.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 23:48:04 -0800
Message-Id: <1201938484.1844.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning:

arch/x86/kernel/cpu/intel.c:48:15: warning: symbol 'ppro_with_ram_bug' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |    1 +
 include/asm-x86/bugs.h      |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d1c372b..fae31ce 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -13,6 +13,7 @@
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/ds.h>
+#include <asm/bugs.h>
 
 #include "cpu.h"
 
diff --git a/include/asm-x86/bugs.h b/include/asm-x86/bugs.h
index 3fcc30d..021cbdd 100644
--- a/include/asm-x86/bugs.h
+++ b/include/asm-x86/bugs.h
@@ -2,6 +2,6 @@
 #define _ASM_X86_BUGS_H
 
 extern void check_bugs(void);
-extern int ppro_with_ram_bug(void);
+int ppro_with_ram_bug(void);
 
 #endif /* _ASM_X86_BUGS_H */
-- 
1.5.4.rc4.1142.gf5a97


