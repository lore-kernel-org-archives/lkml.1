Return-Path: <linux-kernel-owner+w=401wt.eu-S1756844AbZCMLjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbZCMLjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCMLjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:39:10 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:41794 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752235AbZCMLjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:39:09 -0400
X-Greylist: delayed 1577 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 07:39:09 EDT
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/1] loop.h use __kernel_old_dev_t which is not possible use on arch which don't have it..
Date: Fri, 13 Mar 2009 12:12:43 +0100
Message-Id: <e778390af6d0f71c03cf32226f22ab243c9cf54c.1236942607.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This patch is for incomming Microblaze arch.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/linux/loop.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/loop.h b/include/linux/loop.h
index 6ffd6db..fdbabd2 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -82,6 +82,7 @@ enum {
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
 #include <linux/types.h>	/* for __u64 */
 
+#ifdef __kernel_old_dev_t
 /* Backwards compatibility version */
 struct loop_info {
 	int		   lo_number;		/* ioctl r/o */
@@ -97,6 +98,7 @@ struct loop_info {
 	unsigned long	   lo_init[2];
 	char		   reserved[4];
 };
+#endif
 
 struct loop_info64 {
 	__u64		   lo_device;			/* ioctl r/o */
-- 
1.5.5.1

