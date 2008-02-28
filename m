Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbYB1Gq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbYB1Gq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbYB1Gpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:45 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52728 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756159AbYB1Gpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:44 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 10/12] security: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:59 -0500
Message-Id: <1204180441-8540-10-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-9-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
 <1204180441-8540-6-git-send-email-matthew@wil.cx>
 <1204180441-8540-7-git-send-email-matthew@wil.cx>
 <1204180441-8540-8-git-send-email-matthew@wil.cx>
 <1204180441-8540-9-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 security/selinux/selinuxfs.c      |    1 -
 security/selinux/ss/conditional.c |    1 -
 security/selinux/xfrm.c           |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 0341567..443cdac 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -28,7 +28,6 @@
 #include <linux/percpu.h>
 #include <linux/audit.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 /* selinuxfs pseudo filesystem for exporting the security policy API.
    Based on the proc code and the fs/nfsd/nfsctl.c code. */
diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index 50ad85d..a115892 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -11,7 +11,6 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
-#include <asm/semaphore.h>
 #include <linux/slab.h>
 
 #include "security.h"
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 7e15820..041d8d1 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -45,7 +45,6 @@
 #include <net/xfrm.h>
 #include <net/checksum.h>
 #include <net/udp.h>
-#include <asm/semaphore.h>
 #include <asm/atomic.h>
 
 #include "avc.h"
-- 
1.5.4.1

