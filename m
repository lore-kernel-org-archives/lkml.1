Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYCLUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYCLUey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYCLUec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:34:32 -0400
Received: from zaphod.rfc1149.net ([88.191.14.223]:43264 "EHLO
	mail.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYCLUeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:34:31 -0400
From: Samuel Tardieu <sam@rfc1149.net>
To: linux-kernel@vger.kernel.org, wim@iguana.be
Cc: P@draigBrady.com, Samuel Tardieu <sam@rfc1149.net>
Subject: [PATCH 1/3] watchdog: Make w83697h_wdt void-like functions void
Date: Wed, 12 Mar 2008 14:28:01 +0100
Message-Id: <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
X-Mailer: git-send-email 1.5.4.3.611.g29c00.dirty
In-Reply-To: <1205328483-3814-1-git-send-email-sam@rfc1149.net>
References: <1205328483-3814-1-git-send-email-sam@rfc1149.net>
Organisation: RFC1149 (see http://www.rfc1149.net/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some non-exported functions always returned 0. Mark them void instead.

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
---
 drivers/watchdog/w83697hf_wdt.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index c622a0e..b534174 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -140,7 +140,7 @@ w83697hf_init(void)
 	w83697hf_deselect_wdt();
 }
 
-static int
+static void
 wdt_ping(void)
 {
 	spin_lock(&io_lock);
@@ -150,10 +150,9 @@ wdt_ping(void)
 
 	w83697hf_deselect_wdt();
 	spin_unlock(&io_lock);
-	return 0;
 }
 
-static int
+static void
 wdt_enable(void)
 {
 	spin_lock(&io_lock);
@@ -164,10 +163,9 @@ wdt_enable(void)
 
 	w83697hf_deselect_wdt();
 	spin_unlock(&io_lock);
-	return 0;
 }
 
-static int
+static void
 wdt_disable(void)
 {
 	spin_lock(&io_lock);
@@ -178,7 +176,6 @@ wdt_disable(void)
 
 	w83697hf_deselect_wdt();
 	spin_unlock(&io_lock);
-	return 0;
 }
 
 static int
-- 
1.5.4.3.611.g29c00.dirty

