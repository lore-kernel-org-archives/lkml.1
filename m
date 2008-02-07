Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYBGHit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYBGHit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYBGHii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:38:38 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:49763 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbYBGHih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:38:37 -0500
Message-ID: <47AAB57B.2010709@web.de>
Date: Thu, 07 Feb 2008 08:38:35 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] KGDB: kconfig polishing 
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/XJn4j+L14iq7CUSCsYcOso6WazI4Kyo0iYKH0
	welBIirX2q4DA9QEqsUS4HICcEIHax4wm7D2enVPuQo7leFjRA
	PCUr7A01M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for the sake of cleanness.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 lib/Kconfig.kgdb |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/lib/Kconfig.kgdb
===================================================================
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -16,7 +16,7 @@ config KGDB_ARCH_HAS_SHADOW_INFO
 	depends on KGDB
 
 config KGDB_CONSOLE
-	bool "KGDB: Console messages through gdb"
+	bool "Console messages through gdb"
 	depends on KGDB
 	help
 	  If you say Y here, console messages will appear through gdb.
@@ -53,7 +53,7 @@ config KGDB_8250
 	  used by the standard 8250 driver or serial earlyprintk/earlycon.
 
 config KGDBOC
-	tristate "KGDB: Share serial console and kgdb port"
+	tristate "Shared serial console and kgdb port"
 	depends on KGDB
 	select SERIAL_POLL
 	select MAGIC_SYSRQ
