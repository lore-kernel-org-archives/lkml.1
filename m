Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYFPVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYFPVqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbYFPVps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:45:48 -0400
Received: from gw.goop.org ([64.81.55.164]:45424 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbYFPVpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:45:47 -0400
Message-ID: <4856DEE1.5030507@goop.org>
Date: Mon, 16 Jun 2008 14:45:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 4/5] xen/blkfront: add __exit to module_exit() handlers
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1045,7 +1045,7 @@
 module_init(xlblk_init);
 
 
-static void xlblk_exit(void)
+static void __exit xlblk_exit(void)
 {
 	return xenbus_unregister_driver(&blkfront);
 }


