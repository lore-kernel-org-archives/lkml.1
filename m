Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYGCI1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYGCI1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYGCIQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:16:54 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59563 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934493AbYGCHKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:10:54 -0400
Date: Thu, 3 Jul 2008 16:10:53 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org, xen-devel@lists.xensource.com,
       xen-ia64-devel@lists.xensource.com
Subject: [PATCH] xen: remove load_cr3() from manage.c for ia64 support.
Message-ID: <20080703071053.GC15683%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove load_cr3() from manage.c. It is unncessary and x86 dependent.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/xen/manage.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 2bb268e..e8db90c 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -39,8 +39,6 @@ static int xen_suspend(void *data)
 
 	BUG_ON(!irqs_disabled());
 
-	load_cr3(swapper_pg_dir);
-
 	err = device_power_down(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "xen_suspend: device_power_down failed: %d\n",
-- 
1.5.3

