Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYFEEmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYFEEmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 00:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYFEEml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 00:42:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55385 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYFEEml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 00:42:41 -0400
Date: Wed, 4 Jun 2008 21:40:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] dev_set_name: fix missing kernel-doc
Message-Id: <20080604214043.a29464a0.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc for new dev_set_name() function:

Warning(lin2626-rc5//drivers/base/core.c:767): No description found for parameter 'fmt'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/base/core.c |    1 +
 1 file changed, 1 insertion(+)

--- lin2626-rc5.orig/drivers/base/core.c
+++ lin2626-rc5/drivers/base/core.c
@@ -762,6 +762,7 @@ static void device_remove_class_symlinks
 /**
  * dev_set_name - set a device name
  * @dev: device
+ * @fmt: format string for the device's name
  */
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
