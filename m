Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZAFWbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZAFWbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbZAFWON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:13 -0500
Received: from kroah.org ([198.145.64.141]:51327 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755465AbZAFWOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/60] dmi: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:09 -0800
Message-Id: <1231279939-32728-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dmi-id.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.0.4

