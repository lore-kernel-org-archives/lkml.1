Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbYDNSmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbYDNSmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764071AbYDNSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:41:54 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51066 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764014AbYDNSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:41:53 -0400
Date: Mon, 14 Apr 2008 21:40:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 acpi/bay.c:eject_removable_drive()
Message-ID: <20080414184047.GF6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused eject_removable_drive().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 1 Mar 2008

 drivers/acpi/bay.c |    2 ++
 1 file changed, 2 insertions(+)

de6f6fda54c9a51719c8e5a5b8d303fb958cfe36 foobar
diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index 1fa8681..d2fc941 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -201,6 +201,7 @@ static int is_ejectable_bay(acpi_handle handle)
 	return 0;
 }
 
+#if 0
 /**
  * eject_removable_drive - try to eject this drive
  * @dev : the device structure of the drive
@@ -225,6 +226,7 @@ int eject_removable_drive(struct device *dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(eject_removable_drive);
+#endif  /*  0  */
 
 static int acpi_bay_add_fs(struct bay *bay)
 {



