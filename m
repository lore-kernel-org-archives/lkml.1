Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab0CLNvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:51:14 -0500
Received: from smtp.nokia.com ([192.100.122.230]:43650 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab0CLNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:51:13 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Cc: akpm@linux-foundation.org, ext-jani.1.nikula@nokia.com
Subject: [PATCH] enclosure: fix error path - actually return ERR_PTR() on error
Date: Fri, 12 Mar 2010 15:50:58 +0200
Message-Id: <1268401858-9213-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 12 Mar 2010 13:51:01.0602 (UTC) FILETIME=[0D2D2C20:01CAC1EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>

---

NOTE: I'm afraid I'm unable to test this; please consider this more a
bug report than a complete patch.
---
 drivers/misc/enclosure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 1eac626..2979927 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -285,7 +285,7 @@ enclosure_component_register(struct enclosure_device *edev,
 
 	err = device_register(cdev);
 	if (err)
-		ERR_PTR(err);
+		return ERR_PTR(err);
 
 	return ecomp;
 }
-- 
1.6.5.2

