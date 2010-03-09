Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0CIMx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:53:27 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:34192 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0CIMxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:53:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19350.17594.427393.844950@pilspetsen.it.uu.se>
Date: Tue, 9 Mar 2010 13:53:14 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alan Cox <alan@linux.intel.com>
Subject: [PATCH TRIVIAL 2.6.34-rc1] fix TTY_BUFFER_PAGE double space typo
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new TTY_BUFFER_PAGE macro has a double space before a
subtraction operator.  Replace it with a single space.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
diff -rupN linux-2.6.34-rc1/include/linux/tty.h linux-2.6.34-rc1.tty-buffer-page-cleanups/include/linux/tty.h
--- linux-2.6.34-rc1/include/linux/tty.h	2010-03-09 11:42:23.000000000 +0100
+++ linux-2.6.34-rc1.tty-buffer-page-cleanups/include/linux/tty.h	2010-03-09 13:27:26.000000000 +0100
@@ -75,7 +75,7 @@ struct tty_buffer {
  * must match
  */
 
-#define TTY_BUFFER_PAGE		((PAGE_SIZE  - 256) / 2)
+#define TTY_BUFFER_PAGE		((PAGE_SIZE - 256) / 2)
 
 
 struct tty_bufhead {
