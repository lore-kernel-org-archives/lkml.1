Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbXFSWub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbXFSWub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXFSWuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:50:12 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5757 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430AbXFSWuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:50:09 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:50:35 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 7/12] acpi: fix another compile warning
Message-ID: <20070619225035.GI5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:49:39.0121 (UTC)
 FILETIME=[1E127A10:01C7B2C4]
X-WSS-ID: 6A66821C1S4852344-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid compile warning if !ACPI_BLACKLIST_YEAR

  CC      drivers/acpi/blacklist.o
  drivers/acpi/blacklist.c:76:5: warning: "CONFIG_ACPI_BLACKLIST_YEAR" is not defined

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/acpi/blacklist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 3ec110c..ac96c47 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -73,7 +73,7 @@ static struct acpi_blacklist_item acpi_blacklist[] __initdata = {
 	{""}
 };
 
-#if	CONFIG_ACPI_BLACKLIST_YEAR
+#if	defined(CONFIG_ACPI_BLACKLIST_YEAR) && CONFIG_ACPI_BLACKLIST_YEAR
 
 static int __init blacklist_by_year(void)
 {
-- 
1.5.0.7




