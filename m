Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbXFOVpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbXFOVpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbXFOVpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:45:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36341 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757410AbXFOVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:45:11 -0400
Date: Fri, 15 Jun 2007 23:45:25 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Vladimir Lebedev <vladimir.p.lebedev@intel.com>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/acpi/sbs.c: remove dead code
Message-ID: <20070615214525.GN3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/acpi/sbs.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- linux-2.6.22-rc4-mm2/drivers/acpi/sbs.c.old	2007-06-15 22:44:17.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/acpi/sbs.c	2007-06-15 22:46:26.000000000 +0200
@@ -1411,7 +1411,7 @@ static int acpi_sbs_update_run(struct ac
 	char dir_name[32];
 	int do_battery_init = 0, do_ac_init = 0;
 	int old_remaining_capacity = 0;
-	int update_ac = 1, update_battery = 1;
+	int update_battery = 1;
 	int up_tm = update_time;
 
 	if (sbs_zombie(sbs)) {
@@ -1431,10 +1431,6 @@ static int acpi_sbs_update_run(struct ac
 
 	sbs->run_cnt++;
 
-	if (!update_ac && !update_battery) {
-		goto end;
-	}
-
 	old_ac_present = sbs->ac.ac_present;
 
 	result = acpi_ac_get_present(sbs);

