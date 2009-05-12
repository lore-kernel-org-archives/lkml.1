Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZELDaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZELDaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbZELD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:29:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34571 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706AbZELD37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:29:59 -0400
Date: Mon, 11 May 2009 23:29:09 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <20090512032956.5040.77055.sendpatchset@localhost.localdomain>
Subject: [PATCH] x86: remove useless headers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


<stdarg.h> is not needed by these files, remove them.

Compile tests passed.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 76f8f84..ccc9b07 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,8 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b751a41..19d2463 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -14,8 +14,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <stdarg.h>
-
 #include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
