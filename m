Return-Path: <linux-kernel-owner+w=401wt.eu-S1760743AbXKBPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743AbXKBPpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbXKBPoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:44:37 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53865 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760160AbXKBPog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:44:36 -0400
Date: Fri, 2 Nov 2007 16:44:14 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/ptrace.c should #include <linux/syscalls.h>
Message-ID: <20071102154414.GN30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case sys_ptrace()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
516dd6c4f50faf46120024fa80ca8e831033e0a6 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 7c76f2f..a0f7963 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -20,6 +20,7 @@
 #include <linux/signal.h>
 #include <linux/audit.h>
 #include <linux/pid_namespace.h>
+#include <linux/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>

