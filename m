Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZLCS6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZLCS6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZLCS6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:58:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32820 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbZLCS6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:58:02 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] sysfs: deprecated features are to help old tools not to confuse them
Date: Thu,  3 Dec 2009 19:58:00 +0100
Message-Id: <1259866680-27905-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091203083143.3a4619a4.randy.dunlap@oracle.com>
References: <20091203083143.3a4619a4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index eb4b337..d7ac66b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -606,7 +606,7 @@ config SYSFS_DEPRECATED
 	bool
 
 config SYSFS_DEPRECATED_V2
-	bool "enable deprecated sysfs features which may confuse old userspace tools"
+	bool "enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
 	default n
 	select SYSFS_DEPRECATED
-- 
1.6.5.2

