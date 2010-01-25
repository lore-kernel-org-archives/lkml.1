Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877Ab0AYJUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0AYJUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 04:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794Ab0AYJUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 04:20:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60361 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab0AYJUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 04:20:44 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH] MAINTAINERS: add i2c tree for embedded platforms
Date: Mon, 25 Jan 2010 10:20:34 +0100
Message-Id: <1264411234-5400-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
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
Cc: Ben Dooks <ben-linux@fluff.org>
---
Hello,

I wonder if it makes sence to split the "I2C SUBSYSTEM" entry into
something like:

	I2C SUBSYSTEM (PC drivers, core)
	M:	Jean Delvare <khali@linux-fr.org>
	L:	...
	W:	...
	T:	quilt ...
	S:	...
	F:	Documentation/i2c/
	F:	drivers/i2c/
	F:	include/linux/i2c.h
	F:	include/linux/i2c-*.h

	I2C SUBSYSTEM (embedded platforms)
	M:	Ben Dooks <ben-linux@fluff.org>
	L:	...
	W:	...
	T:	git ...
	S:	...
	F:	drivers/i2c/
	F:	include/linux/i2c-*.h

(I'm not entirely sure about the file patterns for the 2nd entry.)

Best regards
Uwe

 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1858646..a1813fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2629,6 +2629,7 @@ M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
+T:	git git://git.fluff.org/bjdooks/linux.git
 S:	Maintained
 F:	Documentation/i2c/
 F:	drivers/i2c/
-- 
1.6.6

