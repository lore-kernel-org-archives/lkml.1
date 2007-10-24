Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXJXQYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXJXQYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXJXQWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:22:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33294 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756091AbXJXQWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:47 -0400
Date: Wed, 24 Oct 2007 18:23:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fujitsu-laptop.c: make 2 functions static
Message-ID: <20071024162316.GJ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_fujitsu_{add,remove}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/misc/fujitsu-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

175c8b648a54b625037916a8f6e3851574141532 
diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index d366a6c..d686ba7 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -198,7 +198,7 @@ static struct platform_driver fujitsupf_driver = {
 
 /* ACPI device */
 
-int acpi_fujitsu_add(struct acpi_device *device)
+static int acpi_fujitsu_add(struct acpi_device *device)
 {
 	int result = 0;
 	int state = 0;
@@ -229,7 +229,7 @@ int acpi_fujitsu_add(struct acpi_device *device)
 	return result;
 }
 
-int acpi_fujitsu_remove(struct acpi_device *device, int type)
+static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 {
 	ACPI_FUNCTION_TRACE("acpi_fujitsu_remove");
 
