Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZFIGhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZFIGhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZFIGhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:37:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54734 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZFIGhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:37:23 -0400
Date: Tue, 9 Jun 2009 16:37:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Nicolas Pitre <nico@cam.org>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the watchdog tree with the arm tree
Message-Id: <20090609163718.ccefad1d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/watchdog/Makefile between commit
3b937a7dbddbedd9457b33fcc8fa369c0c229c6e ("[ARM] Orion/Kirkwood: rename
orion5x_wdt to orion_wdt") from the arm tree and commit
e35f878d8313518a20d3c53393d14761dca74624 ("[WATCHDOG] U300 COH 901 327
watchdog driver") from the watchdog tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/Makefile
index c3afa14,9eb74b7..0000000
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@@ -40,7 -41,8 +41,8 @@@ obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx
  obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
  obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
  obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 -obj-$(CONFIG_ORION5X_WATCHDOG) += orion5x_wdt.o
 +obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
+ obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
  
  # AVR32 Architecture
  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
