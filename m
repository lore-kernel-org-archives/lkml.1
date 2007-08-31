Return-Path: <linux-kernel-owner+w=401wt.eu-S1761105AbXHaJIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761105AbXHaJIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759543AbXHaJIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:08:16 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60097 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbXHaJIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:08:15 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 04:57:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: ysato@users.sourceforge.jp, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] H8/300:  Fix misnamed "CONFIG_BLKDEV_RESERVE_ADDRESS" Kconfig
 variable.
Message-ID: <Pine.LNX.4.64.0708310452530.1209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  if i read correctly an email i just got from Yoshinori Sato, he
wanted me to post this to the main list.  it seems an obvious enough
error that it can probably be pushed to the main tree fairly soon,
unless i've messed something up here.


diff --git a/arch/h8300/Kconfig.debug b/arch/h8300/Kconfig.debug
index 554efe6..996d97e 100644
--- a/arch/h8300/Kconfig.debug
+++ b/arch/h8300/Kconfig.debug
@@ -59,7 +59,7 @@ config BLKDEV_RESERVE
 	help
 	  Reserved BLKDEV area.

-config CONFIG_BLKDEV_RESERVE_ADDRESS
+config BLKDEV_RESERVE_ADDRESS
 	hex 'start address'
 	depends on BLKDEV_RESERVE
 	help
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
