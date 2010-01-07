Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652Ab0AGCfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0AGCfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613Ab0AGCfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:35:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:47452 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756583Ab0AGCfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:35:54 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+s4pscB1CsKtV9QTQIbdhovfj6ehCwHg7G6UCEx4
	UD8l7Zg7djHrAM
From: Peter Huewe <PeterHuewe@gmx.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH] watchdog/ixp2000: Fix build failure caused by missing include
Date: Thu, 7 Jan 2010 03:35:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001070335.49710.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 03:24:28 +0100

This patch fixes a build failure[1] caused by the missing include of
timer.h and thus fixes the build failure.

Notably the build failure existed since October 2009! [2]

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/1983339/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/1351737/

Patch against Linus' tree

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/watchdog/ixp2000_wdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 4f4b35a..3c79dc5 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
+#include <linux/timer.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
-- 
1.6.4.4

