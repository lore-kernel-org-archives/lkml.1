Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995Ab0AEUEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0AEUEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671Ab0AEUEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:04:05 -0500
Received: from lixom.net ([66.141.50.11]:53036 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0AEUEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:04:00 -0500
Date: Tue, 5 Jan 2010 14:10:42 -0600
From: Olof Johansson <olof@lixom.net>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH] pca953x: Minor include cleanup
Message-ID: <20100105201042.GA28367@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/i2c/pca953x.h is a very bare include file. Fix check for multiple
includes of linux/i2c/pca953x.h, and add dependent includes into the
header file.

Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
index 81736d6..29699f8 100644
--- a/include/linux/i2c/pca953x.h
+++ b/include/linux/i2c/pca953x.h
@@ -1,3 +1,9 @@
+#ifndef _LINUX_PCA953X_H
+#define _LINUX_PCA953X_H
+
+#include <linux/types.h>
+#include <linux/i2c.h>
+
 /* platform data for the PCA9539 16-bit I/O expander driver */
 
 struct pca953x_platform_data {
@@ -17,3 +23,5 @@ struct pca953x_platform_data {
 				void *context);
 	char		**names;
 };
+
+#endif /* _LINUX_PCA953X_H */
