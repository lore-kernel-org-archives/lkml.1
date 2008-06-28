Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYF1X5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYF1X5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 19:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYF1X5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 19:57:03 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35870 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYF1X5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 19:57:01 -0400
Date: Sun, 29 Jun 2008 00:57:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH trivial] exec: remove some includes
Message-ID: <Pine.LNX.4.64.0806290055560.18327@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/exec.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-next/fs/exec.c	2008-06-27 13:39:17.000000000 +0100
+++ linux/fs/exec.c	2008-06-27 14:08:00.000000000 +0100
@@ -25,19 +25,17 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
-#include <linux/mman.h>
+#include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
-#include <linux/swap.h>
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
@@ -47,7 +45,6 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
-#include <linux/rmap.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
