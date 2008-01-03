Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbYACAuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbYACAuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYACAt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:49:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:51765 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbYACAt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:49:57 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [1/20] x86: Make ptrace.h safe to include from assembler code
Date: Thu,  3 Jan 2008 01:49:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/ptrace-abi.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/include/asm-x86/ptrace-abi.h
===================================================================
--- linux.orig/include/asm-x86/ptrace-abi.h
+++ linux/include/asm-x86/ptrace-abi.h
@@ -80,6 +80,7 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
+#ifndef __ASSEMBLY__
 /* configuration/status structure used in PTRACE_BTS_CONFIG and
    PTRACE_BTS_STATUS commands.
 */
@@ -91,6 +92,7 @@ struct ptrace_bts_config {
 	/* buffer overflow signal */
 	unsigned int signal;
 };
+#endif
 
 #define PTRACE_BTS_O_TRACE	0x1 /* branch trace */
 #define PTRACE_BTS_O_SCHED	0x2 /* scheduling events w/ jiffies */
