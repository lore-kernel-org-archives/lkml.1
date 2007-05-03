Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXECIU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXECIU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXECIU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:20:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47075 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXECIUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:20:09 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 04:19:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: netdev@vger.kernel.org
Subject: finding your own dead "CONFIG_" variables
Message-ID: <Pine.LNX.4.64.0705030400120.20539@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-15.989, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SUBJ_YOUR_OWN 0.81)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  while there's still a pile of possible dead CONFIG_ variables under
the fs/ and drivers/ directories i haven't posted yet, you don't need
to wait for me to generate them.  take a minute and run the script
yourself:

http://fsdev.net/wiki/index.php?title=Dead_CONFIG_variables

  a couple of examples:

$ ../dead_config.sh net/wanrouter
========== WANPIPE_MULTPPP ==========
net/wanrouter/wanmain.c:#ifdef CONFIG_WANPIPE_MULTPPP
net/wanrouter/wanmain.c:#ifdef CONFIG_WANPIPE_MULTPPP
net/wanrouter/wanmain.c:#ifdef CONFIG_WANPIPE_MULTPPP

$ ../dead_config.sh drivers/net/wireless
========== BCM947XX ==========
drivers/net/wireless/bcm43xx/bcm43xx_dma.c:663:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.h:36:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:64:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:145:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:789:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:799:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:1228:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:1390://FIXME: Do we _really_ want #ifndef CONFIG_BCM947XX here?
drivers/net/wireless/bcm43xx/bcm43xx_main.c:1392:#ifndef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:2143:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:2155:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:2648:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx_main.c:4147:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx.h:661:#ifdef CONFIG_BCM947XX
drivers/net/wireless/bcm43xx/bcm43xx.h:792:#ifdef CONFIG_BCM947XX
$

  go wild.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
