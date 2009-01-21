Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZAUAaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZAUAaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763232AbZAUA3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:29:46 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:38957 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596AbZAUA3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:29:46 -0500
Date: Tue, 20 Jan 2009 16:29:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH -next] driver-core: fix kernel-doc parameter name
Message-Id: <20090120162913.fffe3305.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49766C64.0283:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function parameter name in kernel-doc:

Warning(linux-next-20090120//drivers/base/core.c:1289): No description found for parameter 'dev'
Warning(linux-next-20090120//drivers/base/core.c:1289): Excess function parameter 'root' description in 'root_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Mark McLoughlin <markmc@redhat.com>
---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090120.orig/drivers/base/core.c
+++ linux-next-20090120/drivers/base/core.c
@@ -1280,7 +1280,7 @@ EXPORT_SYMBOL_GPL(__root_device_register
 
 /**
  * root_device_unregister - unregister and free a root device
- * @root: device going away.
+ * @dev: device going away
  *
  * This function unregisters and cleans up a device that was created by
  * root_device_register().
