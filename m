Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZHONLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZHONLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZHONLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:11:50 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:16806 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbZHONLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:11:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEpQhkpR9dHw/2dsb2JhbADQWgmEEAWCKQ
Date: Sat, 15 Aug 2009 15:11:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian@openwrt.org>
Subject: [WATCHDOG] v2.6.31-rc ar7_wdt fix
Message-ID: <20090815131149.GK4302@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/ar7_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Florian Fainelli <florian@openwrt.org>
Date:   Wed Jun 3 13:05:48 2009 +0200

    [WATCHDOG] ar7_wdt: fix path to ar7-specific headers
    
    AR7 is currently being resubmitted for mainline inclusion
    and we changed the path to the ar7-specific headers
    from ar7 to mach-ar7 to reflect the other MIPS-based
    boards header hierarchy. This patch will avoid any future
    compilation failure due to missing headers.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 3fe9742..2f8643e 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -37,7 +37,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/addrspace.h>
-#include <asm/ar7/ar7.h>
+#include <asm/mach-ar7/ar7.h>
 
 #define DRVNAME "ar7_wdt"
 #define LONGNAME "TI AR7 Watchdog Timer"
