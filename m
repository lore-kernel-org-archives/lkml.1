Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZIMQHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZIMQHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 12:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZIMQHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:07:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbZIMQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:07:43 -0400
Date: Sun, 13 Sep 2009 09:07:37 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: dca: module load should not be an error message
Message-ID: <20090913090737.3141c842@nehalam>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message (if it must exist) should not be an error message.
IMHO such messages are useless.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
I sent patch for this previously, but it seems to have been ignored.

--- a/drivers/dca/dca-core.c	2009-09-13 09:02:25.896005620 -0700
+++ b/drivers/dca/dca-core.c	2009-09-13 09:02:50.786144428 -0700
@@ -276,7 +276,7 @@ EXPORT_SYMBOL_GPL(dca_unregister_notify)
 
 static int __init dca_init(void)
 {
-	printk(KERN_ERR "dca service started, version %s\n", DCA_VERSION);
+	pr_info("dca service started, version %s\n", DCA_VERSION);
 	return dca_sysfs_init();
 }
 
