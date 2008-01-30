Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYA3SZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYA3SZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYA3SZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:25:17 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:51189 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674AbYA3SZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:25:15 -0500
X-Belgacom-Dynamic: yes
Date: Wed, 30 Jan 2008 19:25:09 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHOG] v2.6.24 watchdog patches - part 2
Message-ID: <20080130182509.GA2652@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date:   Sun Dec 2 12:54:42 2007 +0100

    [WATCHDOG] use SGI_HAS_INDYDOG for INDYDOG depends
    
    Use SGI_HAS_INDYDOG for INDYDOG depends.
    
    Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 899fc13..afcdc69 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -609,7 +609,7 @@ config SBC_EPX_C3_WATCHDOG
 
 config INDYDOG
 	tristate "Indy/I2 Hardware Watchdog"
-	depends on SGI_IP22
+	depends on SGI_HAS_INDYDOG
 	help
 	  Hardware driver for the Indy's/I2's watchdog. This is a
 	  watchdog timer that will reboot the machine after a 60 second
