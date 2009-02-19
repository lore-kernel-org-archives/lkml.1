Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZBSLIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZBSLIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZBSLI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:08:28 -0500
Received: from bu3sch.de ([62.75.166.246]:53136 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZBSLI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:08:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] spi_bitbang: Add more lowlevel function documentation
Date: Thu, 19 Feb 2009 12:06:17 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191206.17734.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds more documentation of the lowlevel API to avoid future bugs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: linux-2.6/include/linux/spi/spi_bitbang.h
===================================================================
--- linux-2.6.orig/include/linux/spi/spi_bitbang.h	2009-02-19 11:59:23.000000000 +0100
+++ linux-2.6/include/linux/spi/spi_bitbang.h	2009-02-19 12:04:09.000000000 +0100
@@ -83,6 +83,13 @@ extern int spi_bitbang_stop(struct spi_b
  *  int getmiso(struct spi_device *);
  *  void spidelay(unsigned);
  *
+ * setsck()'s is_on parameter is a zero/nonzero boolean.
+ *
+ * setmosi()'s is_on parameter is a zero/nonzero boolean.
+ *
+ * getmiso() is required to return 0 or 1 only. Any other value is invalid
+ * and will result in improper operation.
+ *
  * A non-inlined routine would call bitbang_txrx_*() routines.  The
  * main loop could easily compile down to a handful of instructions,
  * especially if the delay is a NOP (to run at peak speed).

-- 
Greetings, Michael.
