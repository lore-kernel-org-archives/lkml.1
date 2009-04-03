Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbZDCFnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbZDCFnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 01:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZDCFnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 01:43:05 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:59412 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZDCFnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 01:43:04 -0400
Message-ID: <49D5A1D7.7070401@freemail.hu>
Date: Fri, 03 Apr 2009 07:42:47 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove experimental flag from leds-clevo-mail
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32721; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The leds-clevo-mail driver is in the mainline kernel since 2.6.25 and works
without severe problems. Make this driver available for a larger audience.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.29/drivers/leds/Kconfig.orig	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29/drivers/leds/Kconfig	2009-04-02 23:19:52.000000000 +0200
@@ -120,8 +120,8 @@ config LEDS_GPIO
 	  and they must be connected to the GPIO lines.

 config LEDS_CLEVO_MAIL
-	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
-	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
+	tristate "Mail LED on Clevo notebook"
+	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI
 	help
 	  This driver makes the mail LED accessible from userspace
 	  programs through the leds subsystem. This LED have three
