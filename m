Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZLMWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZLMWtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbZLMWtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:49:09 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:49353 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZLMWtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F/1sTbIyp72u5YzgNHZUCKrZQzVEEi+vBNjODnJ1qiqevPiN7PZl3AkWqkGvfDMdo/
         ig22ztH7oZG/n56sBrIXgFTkv+alnyiGkbZQgacxCJ4npgRJxgKELyPWyjE6SmWdP+g/
         N6zF2cQkAoKuwKTWiZKfu1Xlxy3WUoxo78e2U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Fix a typo in drivers/acpi/battery.c
Date: Sun, 13 Dec 2009 14:48:56 -0800
Message-Id: <1260744536-20762-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.5
In-Reply-To: <1260744536-20762-1-git-send-email-justinmattock@gmail.com>
References: <1260744536-20762-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 drivers/acpi/battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 3f4602b..cada73f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -831,7 +831,7 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
 					dev_name(&device->dev), event,
 					acpi_battery_present(battery));
 #ifdef CONFIG_ACPI_SYSFS_POWER
-	/* acpi_batter_update could remove power_supply object */
+	/* acpi_battery_update could remove power_supply object */
 	if (battery->bat.dev)
 		kobject_uevent(&battery->bat.dev->kobj, KOBJ_CHANGE);
 #endif
-- 
1.6.5.5

