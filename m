Return-Path: <linux-kernel-owner+w=401wt.eu-S1764530AbYEBIhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764530AbYEBIhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbYEBIhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:37:11 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:35485 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152AbYEBIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:37:09 -0400
MIME-Version: 1.0
Date: Fri, 02 May 2008 10:37:06 +0200
From: <oliver@zipernowsky.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: [OP] ACPI-check-a-return-value-correctly-in-acpi_power_get_context.patch
 added to queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <98dc4844cdf494b51a8c7cc803c4f9a6@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch added to queue-2.6.22.23-op1.
If anyone has any objections, please let us know.

---

>From a815ab8b5891f3d2515316655729272f68269e3b Mon Sep 17 00:00:00 2001
From: Li Zefan <lizf@cn.fujitsu.com>
Date: Fri, 18 Apr 2008 13:27:29 -0700
Subject: [PATCH] ACPI: check a return value correctly in
acpi_power_get_context()

We should check *resource != NULL rather than resource != NULL, which will
be
always true.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 76bf6d9..f2a76ac 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -121,7 +121,7 @@ acpi_power_get_context(acpi_handle handle,
 	}
 
 	*resource = acpi_driver_data(device);
-	if (!resource)
+	if (!*resource)
 		return -ENODEV;
 
 	return 0;


