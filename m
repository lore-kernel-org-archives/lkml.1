Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbXGXEip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbXGXEip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXGXEid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:38:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17916 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbXGXEiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:38:17 -0400
Date: Mon, 23 Jul 2007 21:42:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc fix for kmod.c
Message-Id: <20070723214215.6a0270df.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kmod.c:
Warning(linux-2.6.23-rc1//kernel/kmod.c:364): No description found for parameter 'envp'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/kmod.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1.orig/kernel/kmod.c
+++ linux-2.6.23-rc1/kernel/kmod.c
@@ -351,11 +351,11 @@ static inline void register_pm_notifier_
 
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
- * @path - path to usermode executable
- * @argv - arg vector for process
- * @envp - environment for process
+ * @path: path to usermode executable
+ * @argv: arg vector for process
+ * @envp: environment for process
  *
- * Returns either NULL on allocation failure, or a subprocess_info
+ * Returns either %NULL on allocation failure, or a subprocess_info
  * structure.  This should be passed to call_usermodehelper_exec to
  * exec the process and free the structure.
  */
