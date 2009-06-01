Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZFAHVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZFAHVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZFAHV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:21:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:42053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZFAHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:21:27 -0400
Subject: [GIT PULL] headers_check fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Jun 2009 12:50:41 +0530
Message-Id: <1243840841.3170.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull headers_check fixes:

The following changes since commit 3218911f839b6c85acbf872ad264ea69aa4d89ad:
  Linus Torvalds (1):
        Merge git://git.infradead.org/~dwmw2/mtd-2.6.30

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master

Jaswinder Singh Rajput (2):
      headers_check fix: linux/auto_fs.h
      headers_check fix: linux/net_dropmon.h

 include/linux/auto_fs.h     |    3 +--
 include/linux/net_dropmon.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

Complete diff:

diff --git a/include/linux/auto_fs.h b/include/linux/auto_fs.h
index 6326585..7b09c83 100644
--- a/include/linux/auto_fs.h
+++ b/include/linux/auto_fs.h
@@ -14,13 +14,12 @@
 #ifndef _LINUX_AUTO_FS_H
 #define _LINUX_AUTO_FS_H
 
+#include <linux/types.h>
 #ifdef __KERNEL__
 #include <linux/fs.h>
 #include <linux/limits.h>
-#include <linux/types.h>
 #include <linux/ioctl.h>
 #else
-#include <asm/types.h>
 #include <sys/ioctl.h>
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/net_dropmon.h b/include/linux/net_dropmon.h
index 0217fb8..0e2e100 100644
--- a/include/linux/net_dropmon.h
+++ b/include/linux/net_dropmon.h
@@ -1,6 +1,7 @@
 #ifndef __NET_DROPMON_H
 #define __NET_DROPMON_H
 
+#include <linux/types.h>
 #include <linux/netlink.h>
 
 struct net_dm_drop_point {


