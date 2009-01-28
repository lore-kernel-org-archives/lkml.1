Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZA1X2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZA1X2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA1X17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:27:59 -0500
Received: from kroah.org ([198.145.64.141]:56975 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753053AbZA1X16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:27:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] driver-core: fix kernel-doc parameter name
Date: Wed, 28 Jan 2009 15:26:36 -0800
Message-Id: <1233185196-23064-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232543.GA23030@kroah.com>
References: <20090128232543.GA23030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter name in kernel-doc:

Warning(linux-next-20090120//drivers/base/core.c:1289): No description found for parameter 'dev'
Warning(linux-next-20090120//drivers/base/core.c:1289): Excess function parameter 'root' description in 'root_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 55e5309..f3eae63 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1280,7 +1280,7 @@ EXPORT_SYMBOL_GPL(__root_device_register);
 
 /**
  * root_device_unregister - unregister and free a root device
- * @root: device going away.
+ * @dev: device going away
  *
  * This function unregisters and cleans up a device that was created by
  * root_device_register().
-- 
1.6.0.2

