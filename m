Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYJUPIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYJUPIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYJUPIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:08:17 -0400
Received: from bioshock.netsplit.com ([89.16.172.233]:33570 "EHLO
	bioshock.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYJUPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:08:16 -0400
X-Greylist: delayed 2839 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2008 11:08:16 EDT
From: Scott James Remnant <scott@canonical.com>
To: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       286977@bugs.launchpad.net
Date: Tue, 21 Oct 2008 15:18:36 +0100
Subject: [PATCH] add MODULE_ALIAS to load ipmi_devintf with ipmi_si
Message-Id: <E1KsI6R-0006gT-PJ@bioshock.netsplit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipmi_devintf module contains the userspace interface for IPMI
devices, yet will not be loaded automatically with a system
interface handler driver.

Add a MODULE_ALIAS for the "platform:ipmi_si" MODALIAS exported by
the ipmi_si driver, so that userspace knows of the recommendation.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
---
 drivers/char/ipmi/ipmi_devintf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 64e1c16..ecaf369 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -957,3 +957,4 @@ module_exit(cleanup_ipmi);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
 MODULE_DESCRIPTION("Linux device interface for the IPMI message handler.");
+MODULE_ALIAS("platform:ipmi_si");
-- 
1.5.6.3

