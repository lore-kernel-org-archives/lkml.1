Return-Path: <linux-kernel-owner+w=401wt.eu-S1946668AbXBIQq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946668AbXBIQq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946648AbXBIQjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51687 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946642AbXBIQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:51 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] hwmon: ansify
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlu-0006n6-MC@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/hwmon/ams/ams-input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ams/ams-input.c b/drivers/hwmon/ams/ams-input.c
index f126aa4..1821016 100644
--- a/drivers/hwmon/ams/ams-input.c
+++ b/drivers/hwmon/ams/ams-input.c
@@ -153,7 +153,7 @@ int ams_input_init(void)
 }
 
 /* Call with ams_info.lock held! */
-void ams_input_exit()
+void ams_input_exit(void)
 {
 	ams_input_disable();
 	device_remove_file(&ams_info.of_dev->dev, &dev_attr_joystick);
-- 
1.5.0-rc2.GIT


