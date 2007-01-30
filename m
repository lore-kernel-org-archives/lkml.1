Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXA3G1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXA3G1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 01:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXA3G1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 01:27:24 -0500
Received: from relay02.mail-hub.dodo.com.au ([202.136.32.45]:51986 "EHLO
	relay02.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933085AbXA3G1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 01:27:23 -0500
From: Grant Coady <grant_lkml@dodo.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] -mm2: typo in ipc/ipc_sysctl.c -> compile failure
Date: Tue, 30 Jan 2007 17:27:10 +1100
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <kuotr2dffd1uftp4h946mst3s7k4ddaj9l@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Dunno who does IPC so hoping you do ;)  (ref.config: 20-rc6-mm2b/048)

Cheers,
Grant.
From: Grant Coady <gcoady.lk@gmail.com>

Fix typos causing compile failure when CONFIG_PROC_FS not set in 
ipc/ipc_sysctl.c, compile tested.

ipc/ipc_sysctl.c:107: error: `proc_ipc_doulongvec_minmax' undeclared here (not in a function)
ipc/ipc_sysctl.c:107: error: initializer element is not constant
[...]
ipc/ipc_sysctl.c:164: error: (near initialization for `ipc_kern_table[7]')
make[1]: *** [ipc/ipc_sysctl.o] Error 1
make: *** [ipc] Error 2

Also applies cleanly to 2.6.20-rc6-mm3.

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>

---
 ipc_sysctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20-rc6-mm2a/ipc/ipc_sysctl.c	2007-01-30 07:41:08.000000000 +1100
+++ linux-2.6.20-rc6-mm2b/ipc/ipc_sysctl.c	2007-01-30 16:45:03.000000000 +1100
@@ -50,8 +50,8 @@
 }
 
 #else
-#define proc_ipc_do_ulongvec_minmax NULL
-#define proc_ipc_do_intvec	    NULL
+#define proc_ipc_doulongvec_minmax NULL
+#define proc_ipc_dointvec	   NULL
 #endif
 
 #ifdef CONFIG_SYSCTL_SYSCALL
