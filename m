Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXKOLC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXKOLC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXKOLCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:02:51 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:63322 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750801AbXKOLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:02:50 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-164.messagelabs.com!1195124568!10275110!5
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Thu, 18 Oct 2007 08:26:34 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] trivial: SERIAL_NETX_CONSOLE provides console for NetX, not IMX
Message-ID: <20071018062634.GA850@bre-cln-ukleine.digi.com>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Nov 2007 11:02:48.0069 (UTC) FILETIME=[0EAA4350:01C82777]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 drivers/serial/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d6ae38e..6d0c97a 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1271,8 +1271,8 @@ config SERIAL_NETX_CONSOLE
 	depends on SERIAL_NETX
 	select SERIAL_CORE_CONSOLE
 	help
-	  If you have enabled the serial port on the Motorola IMX
-	  CPU you can make it the console by answering Y to this option.
+	  If you have enabled the serial port on the Hilscher NetX SoC
+	  you can make it the console by answering Y to this option.
 
 config SERIAL_OF_PLATFORM
 	tristate "Serial port on Open Firmware platform bus"
-- 
1.5.3.4

