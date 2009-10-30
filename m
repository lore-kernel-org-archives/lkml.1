Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZJ3UDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZJ3UDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZJ3UDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 16:03:38 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:58519
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135AbZJ3UDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 16:03:38 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: add missing comments in sysctl kernel names
Date: Fri, 30 Oct 2009 18:03:39 -0200
Message-Id: <1256933019-6687-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 include/linux/sysctl.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 1e4743e..9a3c8f7 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -98,8 +98,8 @@ enum
 	KERN_VERSION=4,		/* string: compile time info */
 	KERN_SECUREMASK=5,	/* struct: maximum rights mask */
 	KERN_PROF=6,		/* table: profiling information */
-	KERN_NODENAME=7,
-	KERN_DOMAINNAME=8,
+	KERN_NODENAME=7,	/* string: hostname */
+	KERN_DOMAINNAME=8,	/* string: domainname */
 
 	KERN_PANIC=15,		/* int: panic timeout */
 	KERN_REALROOTDEV=16,	/* real root device to mount after initrd */
@@ -111,8 +111,8 @@ enum
 	KERN_PPC_HTABRECLAIM=25, /* turn htab reclaimation on/off on PPC */
 	KERN_PPC_ZEROPAGED=26,	/* turn idle page zeroing on/off on PPC */
 	KERN_PPC_POWERSAVE_NAP=27, /* use nap mode for power saving */
-	KERN_MODPROBE=28,
-	KERN_SG_BIG_BUFF=29,
+	KERN_MODPROBE=28,	/* string: modprobe path */
+	KERN_SG_BIG_BUFF=29,	/* int: sg driver reserved buffer size */
 	KERN_ACCT=30,		/* BSD process accounting parameters */
 	KERN_PPC_L2CR=31,	/* l2cr register on PPC */
 
@@ -159,7 +159,7 @@ enum
 	KERN_ACPI_VIDEO_FLAGS=71, /* int: flags for setting up video after ACPI sleep */
 	KERN_IA64_UNALIGNED=72, /* int: ia64 unaligned userland trap enable */
 	KERN_COMPAT_LOG=73,	/* int: print compat layer  messages */
-	KERN_MAX_LOCK_DEPTH=74,
+	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
 };
-- 
1.6.3.3

