Return-Path: <linux-kernel-owner+w=401wt.eu-S1764359AbXGZJ5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764359AbXGZJ5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXGZJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:56:57 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46468 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbXGZJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:56:56 -0400
Date: Thu, 26 Jul 2007 12:56:55 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, astarikovskiy@suse.de
Subject: [PATCH] ACPI: cure run-together printk lines
Message-ID: <Pine.SOC.4.64.0707261254410.20645@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a newline to printk so next line does not run together with this 
line.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 469f3f5..9ecfdbc 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -685,7 +685,7 @@ static int ec_parse_device(struct acpi_ec *ec, acpi_handle handle)
 
 	ec->handle = handle;
 
-	printk(KERN_INFO PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx",
+	printk(KERN_INFO PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
 
 	return 0;

-- 
Meelis Roos (mroos@linux.ee)
