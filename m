Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYJ3Ff5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYJ3Ff5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYJ3Ffs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:35:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47074 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYJ3Ffr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:35:47 -0400
Date: Wed, 29 Oct 2008 22:34:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/7] kmod: fix varargs kernel-doc
Message-Id: <20081029223442.adacc33e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix varargs kernel-doc format in kmod.c:
Use @... instead of @varargs.

Warning(kernel/kmod.c:67): Excess function parameter or struct member 'varargs' description in 'request_module'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lin2628-rc2.orig/kernel/kmod.c
+++ lin2628-rc2/kernel/kmod.c
@@ -51,8 +51,8 @@ char modprobe_path[KMOD_PATH_LEN] = "/sb
 
 /**
  * request_module - try to load a kernel module
- * @fmt:     printf style format string for the name of the module
- * @varargs: arguements as specified in the format string
+ * @fmt: printf style format string for the name of the module
+ * @...: arguments as specified in the format string
  *
  * Load a module using the user mode module loader. The function returns
  * zero on success or a negative errno code on failure. Note that a
