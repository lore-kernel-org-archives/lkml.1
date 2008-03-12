Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYCLUek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYCLUek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYCLUec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:34:32 -0400
Received: from zaphod.rfc1149.net ([88.191.14.223]:43262 "EHLO
	mail.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYCLUeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:34:31 -0400
X-Greylist: delayed 4258 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2008 16:34:31 EDT
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Samuel Tardieu <sam@rfc1149.net>
To: linux-kernel@vger.kernel.org, wim@iguana.be
Cc: P@draigBrady.com, Samuel Tardieu <sam@rfc1149.net>
Subject: [PATCH 2/3] watchdog: Make w83697h_wdt timeout option string similar to others
Date: Wed, 12 Mar 2008 14:28:02 +0100
Message-Id: <e2b93eb1cff2f2dd926caf6d9d76b62054a8ae24.1205328258.git.sam@rfc1149.net>
X-Mailer: git-send-email 1.5.4.3.611.g29c00.dirty
In-Reply-To: <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
References: <1205328483-3814-1-git-send-email-sam@rfc1149.net>
 <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
In-Reply-To: <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
References: <9b2269dbdb0d6674cc8dc79e5cb61f23bff86ae0.1205328258.git.sam@rfc1149.net>
Organisation: RFC1149 (see http://www.rfc1149.net/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
---
 drivers/watchdog/w83697hf_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index b534174..2120702 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -56,7 +56,7 @@ module_param(timeout, int, 0);
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255 (default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-- 
1.5.4.3.611.g29c00.dirty

