Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbYKLG5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbYKLG5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYKLG5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:57:14 -0500
Received: from smtp.nokia.com ([192.100.105.134]:21073 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYKLG5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:57:13 -0500
From: Jarkko Nikula <jarkko.nikula@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       Jarkko Nikula <jarkko.nikula@nokia.com>
Subject: [patch 2.6.28-rc4] gpiolib: extend gpio label column width in debugfs file
Date: Wed, 12 Nov 2008 08:56:13 +0200
Message-Id: <1226472973-16271-1-git-send-email-jarkko.nikula@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 12 Nov 2008 06:56:35.0061 (UTC) FILETIME=[CD376250:01C94493]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are already various drivers having bigger label than 12 bytes. Most
of them fit well under 20 bytes but make column width exact so that
oversized labels don't mess up output alignment.

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
---
 drivers/gpio/gpiolib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index faa1cc6..82020ab 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1134,7 +1134,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			continue;
 
 		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
-		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
+		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
 			gpio, gdesc->label,
 			is_out ? "out" : "in ",
 			chip->get
-- 
1.5.6.5

