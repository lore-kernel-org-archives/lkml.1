Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZHIJhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZHIJhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZHIJhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:37:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52551 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZHIJg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:36:59 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Wim Van Sebroeck <wim@iguana.be>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH RT 8/6] [ARM, WATCHDOG] davinci: include mach/timex.h in davinci_wdt.c
Date: Sun,  9 Aug 2009 11:36:39 +0200
Message-Id: <1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de>
 <1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a a build failure for 2.6.31-rc4-rt1 (ARCH=arm,
davinci_all_defconfig):

	drivers/watchdog/davinci_wdt.c: In function 'wdt_enable':
	drivers/watchdog/davinci_wdt.c:102: error: 'CLOCK_TICK_RATE' undeclared (first use in this function)
	drivers/watchdog/davinci_wdt.c:102: error: (Each undeclared identifier is reported only once
	drivers/watchdog/davinci_wdt.c:102: error: for each function it appears in.)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
---
 drivers/watchdog/davinci_wdt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 83e22e7..4a136d7 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -26,6 +26,8 @@
 #include <linux/io.h>
 #include <linux/device.h>
 
+#include <mach/timex.h>
+
 #define MODULE_NAME "DAVINCI-WDT: "
 
 #define DEFAULT_HEARTBEAT 60
-- 
1.6.3.3

