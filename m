Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbYDKIZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbYDKIZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYDKIZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:25:37 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:24298 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756932AbYDKIZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:25:35 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-164.messagelabs.com!1207902333!10886207!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] GPIO: #include <linux/kernel.h> for might_sleep
Date: Fri, 11 Apr 2008 10:24:50 +0200
Message-Id: <1207902290-25381-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Apr 2008 08:24:51.0155 (UTC) FILETIME=[831EF230:01C89BAD]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--10.484000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello David,

I like having headers being independend of the order of inclusion.
Usually I order all includes alphabetically (and grouped by linux/,
asm/, etc.).  This doesn't work with gpio.h because then kernel.h is
included to late.

Best regards
Uwe

 include/asm-generic/gpio.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index f29a502..4fe6207 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -97,6 +97,8 @@ extern int __gpio_cansleep(unsigned gpio);
 
 #else
 
+#include <linux/kernel.h>
+
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
  */
-- 
1.5.4.5

