Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXGTDev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXGTDev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764746AbXGTDdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:33:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35661 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764585AbXGTDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:38 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 6/8] m68k: remove empty ->setup is several consoles
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjFK-0004mM-5v@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:33:38 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/serial167.c |    6 ------
 drivers/char/vme_scc.c   |    8 --------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index c585b47..f1497ce 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -2573,16 +2573,10 @@ static struct tty_driver *serial167_console_device(struct console *c,
 	return cy_serial_driver;
 }
 
-static int __init serial167_console_setup(struct console *co, char *options)
-{
-	return 0;
-}
-
 static struct console sercons = {
 	.name = "ttyS",
 	.write = serial167_console_write,
 	.device = serial167_console_device,
-	.setup = serial167_console_setup,
 	.flags = CON_PRINTBUFFER,
 	.index = -1,
 };
diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
index bef6d88..e122a0e 100644
--- a/drivers/char/vme_scc.c
+++ b/drivers/char/vme_scc.c
@@ -1013,18 +1013,10 @@ static struct tty_driver *scc_console_device(struct console *c, int *index)
 	return scc_driver;
 }
 
-
-static int __init scc_console_setup(struct console *co, char *options)
-{
-	return 0;
-}
-
-
 static struct console sercons = {
 	.name		= "ttyS",
 	.write		= scc_console_write,
 	.device		= scc_console_device,
-	.setup		= scc_console_setup,
 	.flags		= CON_PRINTBUFFER,
 	.index		= -1,
 };
-- 
1.5.3.GIT


