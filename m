Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYE3QU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYE3QU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYE3QUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:20:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:4773 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYE3QUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GcIsPVD1UZMnN/eXxALlLBl59vLcvGbUgWtMUZ++Bjxz88l9UqhC8wAzi1gocnRnCHYm0VC0vk3gffGufexFpXY4LaWgSuwUjnulXrNDl3hTao8PW9Ng3pt/i4LkTydE7+Jt887xQqCx/muip1l6bri4cfjB8AKEGTQcp8hqVnw=
From: Alessandro Guido <alessandro.guido@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] sony-laptop: Add missing newline character
Date: Fri, 30 May 2008 18:20:26 +0200
User-Agent: KMail/1.9.9
Cc: malattia@linux.it
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301820.26626.alessandro.guido@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing newline character at the end of the warning string

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
---
 drivers/misc/sony-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 00e48e2..daf3c9c 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -969,7 +969,7 @@ static int sony_nc_resume(struct acpi_device *device)
 	/* set the last requested brightness level */
 	if (sony_backlight_device &&
 			!sony_backlight_update_status(sony_backlight_device))
-		printk(KERN_WARNING DRV_PFX "unable to restore brightness level");
+		printk(KERN_WARNING DRV_PFX "unable to restore brightness level\n");
 
 	/* re-initialize models with specific requirements */
 	dmi_check_system(sony_nc_ids);
