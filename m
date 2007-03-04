Return-Path: <linux-kernel-owner+w=401wt.eu-S1751566AbXCDLaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbXCDLaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbXCDLaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:30:18 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:45125 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXCDLaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:30:17 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Mar 2007 06:08:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>
Subject: [PATCH] KCONFIG:  Set the default for the deprecated sysfs entries
 to N.
Message-ID: <Pine.LNX.4.64.0703040604330.16320@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Set the default for creating deprecated sysfs files to "no".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  Given that the help info for this entry states that "None of these
features or values should be used today," it makes more sense for the
config entry to default to no, wouldn't you think?

diff --git a/init/Kconfig b/init/Kconfig
index f977086..7fa74ca 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -275,7 +275,7 @@ config CPUSETS

 config SYSFS_DEPRECATED
 	bool "Create deprecated sysfs files"
-	default y
+	default n
 	help
 	  This option creates deprecated symlinks such as the
 	  "device"-link, the <subsystem>:<name>-link, and the

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
