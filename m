Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbZIVTis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbZIVTis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZIVTip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:45 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZIVTil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V9exF9ouTZXAepBhQRwJQTlix40tzcI26cUzt+JZ1BtqEN9LP4yOJSsCUcrpiLLu2K
         xCoQRk9WF4RHPlPdYTGsNqiB0gEo6Ti+cFrOtvkCmkvgcvBdsgHQMfyD+8JZJ/vikHk4
         xN6DvmAt7fD+RFNI/DnaSJDIMwhocf2GcQHd0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/24] x86: Remove unused config macros from instruction decoder selftest
Date: Tue, 22 Sep 2009 21:38:06 +0200
Message-Id: <1253648302-5771-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Remove dummy definitions of CONFIG_X86_64 and CONFIG_X86_32 because
those macros are not used in the instruction decoder anymore.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090828221326.8778.70723.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/tools/test_get_len.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index a3273f4..376d338 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -21,11 +21,6 @@
 #include <string.h>
 #include <assert.h>
 
-#ifdef __x86_64__
-#define CONFIG_X86_64
-#else
-#define CONFIG_X86_32
-#endif
 #define unlikely(cond) (cond)
 
 #include <asm/insn.h>
-- 
1.6.2.3

