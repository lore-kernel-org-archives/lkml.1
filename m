Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYJ3AqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYJ3AqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYJ3AqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:46:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64544 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJ3AqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:46:08 -0400
Subject: dmi: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Lennart Poettering <mzxreary@0pointer.de>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:46:07 +0100
Message-Id: <1225327567.5970.39.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, care to pick that up?


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: dmi: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Lennart Poettering <mzxreary@0pointer.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index e880d6c..5a76d05 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -223,7 +223,7 @@ static int __init dmi_id_init(void)
 	}
 
 	dmi_dev->class = &dmi_class;
-	strcpy(dmi_dev->bus_id, "id");
+	dev_set_name(dmi_dev, "id");
 	dmi_dev->groups = sys_dmi_attribute_groups;
 
 	ret = device_register(dmi_dev);

