Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0CJFDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:03:50 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:53790 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab0CJFDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:03:46 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 00:03:46 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uG0AuovSP22s8ceZ5cVEnWMKvTG9wOwVlAL7BBXWJQVINVQIc8ht5ApVgFtdHO+DSC
         1hEku4M3KbVEPFXONgy6HoioYG6mVOgXBF6rJ+KHMkWDg6AvP8EZHI6ua2pMZCcFLTAt
         PDJ5z+XY9FL+G6Fll2eeUG1ITuHKJRaH4Elqw=
From: Bruno Bigras <bigras.bruno@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruno Bigras <bigras.bruno@gmail.com>
Subject: [PATCH] acpi: sleep: fixed a brace coding style issue
Date: Tue,  9 Mar 2010 23:56:20 -0500
Message-Id: <1268196980-5697-1-git-send-email-bigras.bruno@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a coding style issue.

Signed-off-by: Bruno Bigras <bigras.bruno@gmail.com>
---
 drivers/acpi/sleep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 3bde594..fc8343f 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -62,9 +62,9 @@ static int acpi_sleep_prepare(u32 acpi_state)
 #ifdef CONFIG_ACPI_SLEEP
 	/* do we have a wakeup address for S2 and S3? */
 	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
+		if (!acpi_wakeup_address)
 			return -EFAULT;
-		}
+
 		acpi_set_firmware_waking_vector(
 				(acpi_physical_address)acpi_wakeup_address);
 
-- 
1.7.0.2

