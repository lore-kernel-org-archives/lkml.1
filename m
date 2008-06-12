Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYFLAWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYFLAWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYFLAW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:22:28 -0400
Received: from mx1.suse.de ([195.135.220.2]:50084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYFLAW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:22:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] dev_set_name: fix missing kernel-doc
Date: Wed, 11 Jun 2008 17:21:21 -0700
Message-Id: <1213230082-13365-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.3
In-Reply-To: <20080612001035.GA7615@suse.de>
References: <20080612001035.GA7615@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc for new dev_set_name() function:

Warning(lin2626-rc5//drivers/base/core.c:767): No description found for parameter 'fmt'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 422cfca..ee0a51a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -762,6 +762,7 @@ static void device_remove_class_symlinks(struct device *dev)
 /**
  * dev_set_name - set a device name
  * @dev: device
+ * @fmt: format string for the device's name
  */
 int dev_set_name(struct device *dev, const char *fmt, ...)
 {
-- 
1.5.5.3

