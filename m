Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZD0Jco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZD0Jco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZD0Jcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:32:35 -0400
Received: from smtp4.welho.com ([213.243.153.38]:37820 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbZD0Jce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:32:34 -0400
Date: Mon, 27 Apr 2009 12:33:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] usb/storage/usual-tables.c: add MODULE_LICENSE
Message-ID: <20090427093301.GC9259@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the missing MODULE_LICENSE("GPL").

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index 468bde7..d62ea8f 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -114,3 +114,5 @@ int usb_usual_ignore_device(struct usb_interface *intf)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_usual_ignore_device);
+
+MODULE_LICENSE("GPL");

