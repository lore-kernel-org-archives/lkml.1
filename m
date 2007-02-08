Return-Path: <linux-kernel-owner+w=401wt.eu-S1161497AbXBHAdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161497AbXBHAdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161503AbXBHAdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:56432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965539AbXBHAcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:46 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Frank Haverkamp <haver@vnet.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/28] SYSFS: Fix missing include of list.h in sysfs.h
Date: Wed,  7 Feb 2007 16:30:11 -0800
Message-Id: <11708946963110-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946932742-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com> <1170894
 6903974-git-send-email-greg@kroah.com> <11708946932742-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Haverkamp <haver@vnet.ibm.com>

Sysfs.h uses definitions (e.g. struct list_head s_sibling) from list.h
but does not include it.

Signed-off-by: Frank Haverkamp <haver@vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysfs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2129d1b..eee4859 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -11,6 +11,7 @@
 #define _SYSFS_H_
 
 #include <linux/compiler.h>
+#include <linux/list.h>
 #include <asm/atomic.h>
 
 struct kobject;
-- 
1.4.4.4

