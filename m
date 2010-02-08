Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0BHJKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:10:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40601 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0BHJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:10:03 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Nate Case <ncase@xes-inc.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 3/3] gpiolib: document that names can contain printk format specifiers
Date: Mon,  8 Feb 2010 10:09:40 +0100
Message-Id: <1265620180-14150-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100203155558.GH11354@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de>
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
---
 include/asm-generic/gpio.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 37af893..abdb5d3 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -60,7 +60,8 @@ struct module;
  * @names: if set, must be an array of strings to use as alternative
  *      names for the GPIOs in this chip. Any entry in the array
  *      may be NULL if there is no alias for the GPIO, however the
- *      array must be @ngpio entries long.
+ *      array must be @ngpio entries long.  A name can include a single printk
+ *      format specifier for an unsigned int.
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
-- 
1.6.6

