Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYFCRSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYFCRSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYFCRSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:18:23 -0400
Received: from baikonur.stro.at ([213.239.196.228]:53038 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYFCRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:18:22 -0400
From: maximilian attems <max@stro.at>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Tim Gardner <tim.gardner@canonical.com>,
       maximilian attems <max@stro.at>
Subject: [PATCH] hdaps module load on Thinkpad T61P
Date: Tue,  3 Jun 2008 19:18:17 +0200
Message-Id: <1212513497-13681-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

Adds DMI system identifier for ThinkPad T61.
OriginalAuthor: Klaus S. Madsen <ubuntu@hjernemadsen.org>
OriginalLocation: http://launchpadlibrarian.net/10864950/hdaps-t61.patch
Bug: 133636


Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
---
 drivers/hwmon/hdaps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hdaps.c b/drivers/hwmon/hdaps.c
index 88e8965..26df06f 100644
--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -522,6 +522,7 @@ static struct dmi_system_id __initdata hdaps_whitelist[] = {
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
-- 
1.5.5.1

