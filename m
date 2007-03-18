Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXCRNBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXCRNBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 09:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXCRNBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 09:01:14 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57397 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbXCRNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 09:01:13 -0400
Date: Sun, 18 Mar 2007 12:58:08 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build error due to not including <linux/errno.h>
Message-ID: <20070318125808.GA25840@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since d9a9cdfb078d755e648d53ec25b7370f84ee5729 <linux/sysfs.h> is using
ENOSYS without including <linux/errno.h> if CONFIG_SYSFS is disabled.

Fixed by including <linux/errno.h>.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 0544edd..fea9a6b 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -11,6 +11,7 @@
 #define _SYSFS_H_
 
 #include <linux/compiler.h>
+#include <linux/errno.h>
 #include <linux/list.h>
 #include <asm/atomic.h>
 
