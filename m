Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZLNAQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZLNAQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbZLMX5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZLMX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:46 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>
Subject: [PATCH 0/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:29 +0100
Message-Id: <1260748779-13567-1-git-send-email-re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/acpi/battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 3f4602b..2e41d36 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -763,7 +763,7 @@ DECLARE_FILE_FUNCTIONS(alarm);
 	}
 
 static struct battery_file {
-	struct file_operations ops;
+	const struct file_operations ops;
 	mode_t mode;
 	const char *name;
 } acpi_battery_file[] = {
-- 
1.6.5.3

