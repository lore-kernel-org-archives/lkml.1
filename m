Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZFMVi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZFMVi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZFMVir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:38:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44740 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZFMVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:38:47 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-rt@pengutronix.de, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <greg@kroah.com>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: [PATCH -rt] disable building all staging drivers
Date: Sat, 13 Jun 2009 23:38:38 +0200
Message-Id: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
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

I know that at least COMEDI and RT2870 are broken with -rt, but Thomas
requested disabling all of staging.  He's the maintainer.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
---
 drivers/staging/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 211af86..3d1a966 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -1,6 +1,7 @@
 menuconfig STAGING
 	bool "Staging drivers"
 	default n
+	depends on BROKEN
 	---help---
 	  This option allows you to select a number of drivers that are
 	  not of the "normal" Linux kernel quality level.  These drivers
-- 
1.6.3.1

