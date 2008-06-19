Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYFSQb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYFSQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYFSQbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:31:50 -0400
Received: from gate.critical-links.com ([62.28.57.164]:43699 "EHLO
	gate.critical-links.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYFSQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:31:48 -0400
Date: Thu, 19 Jun 2008 17:29:32 +0100
From: WANG Cong <wcong@critical-links.com>
To: mtk.manpages@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [Patch] Add the ENOSYS description for syslog(2)
Message-ID: <20080619172932.0509e359@hack>
Organization: critical-links.com
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-edgeBOX-MailScanner-Information: Please contact the ISP for more information
X-edgeBOX-MailScanner: Found to be clean
X-edgeBOX-MailScanner-From: wcong@critical-links.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Michael!

syslog(2) just returns ENOSYS when CONFIG_PRINTK is not enabled.
This should be described in man pages, I think.

Patch is below.

Thanks.

Sigend-off-by: WANG Cong <wcong@critical-links.com>

---
diff -Nrup man-pages-3.00/man2/syslog.2 man-pages-3.00.modified/man2/syslog.2
--- man-pages-3.00/man2/syslog.2	2008-06-11 05:20:46.000000000 +0100
+++ man-pages-3.00.modified/man2/syslog.2	2008-06-19 17:13:00.000000000 +0100
@@ -235,6 +235,12 @@ capability).
 .B ERESTARTSYS
 System call was interrupted by a signal; nothing was read.
 (This can be seen only during a trace.)
+.TP
+.B ENOSYS
+This system call is not enabled when the operating system
+kernel was compiled.
+The kernel configuration parameter controlling this is
+.BR CONFIG_PRINTK .
 .SH "CONFORMING TO"
 This system call is Linux-specific and should not be used in programs
 intended to be portable.

