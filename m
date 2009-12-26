Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZLZAqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZLZAqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZLZAqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:46:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53639 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbZLZAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:46:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:45:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v4l/dvb] firedtv: add forgotten __exit annotation
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.c98a9e80d83e315a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fdtv_fw_exit() is part of the firedtv driver's .exit.text section.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/media/dvb/firewire/firedtv-fw.c
+++ linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-fw.c
@@ -332,7 +332,7 @@ int __init fdtv_fw_init(void)
 	return driver_register(&fdtv_driver.driver);
 }
 
-void fdtv_fw_exit(void)
+void __exit fdtv_fw_exit(void)
 {
 	driver_unregister(&fdtv_driver.driver);
 	fw_core_remove_address_handler(&fcp_handler);

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

