Return-Path: <linux-kernel-owner+w=401wt.eu-S1946556AbXBIQFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946556AbXBIQFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946566AbXBIQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53622 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946569AbXBIQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:08 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] wrong order of kzalloc arguments
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYFH-0004qI-0v@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/acpi/bay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index 667fa1d..91082ce 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -296,7 +296,7 @@ static int bay_add(acpi_handle handle, int id)
 	/*
 	 * Initialize bay device structure
 	 */
-	new_bay = kzalloc(GFP_ATOMIC, sizeof(*new_bay));
+	new_bay = kzalloc(sizeof(*new_bay), GFP_ATOMIC);
 	INIT_LIST_HEAD(&new_bay->list);
 	new_bay->handle = handle;
 	new_bay->name = (char *)nbuffer.pointer;
-- 
1.5.0-rc2.GIT


