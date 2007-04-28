Return-Path: <linux-kernel-owner+w=401wt.eu-S1030872AbXD1VhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872AbXD1VhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030905AbXD1VhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:37:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40823 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030872AbXD1VhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:37:13 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 17:37:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: maturity levels:  a first pass
Message-ID: <Pine.LNX.4.64.0704281735470.29040@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


off the top of my head, this is what the interface might look like.

diff --git a/init/Kconfig b/init/Kconfig
index b170aa1..5c8529c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -40,6 +40,26 @@ config EXPERIMENTAL
 	  you say Y here, you will be offered the choice of using features or
 	  drivers that are currently considered to be in the alpha-test phase.

+config ACTIVATE_MATURITY
+	bool "Activate maturity attribute selection"
+	---help---
+	  This feature gives you the ability to de-select entire sets of
+	  kernel features based on how they've been tagged with the
+	  "maturity" directive.
+
+	  If you choose not to activate this feature, then the Kconfig
+	  "maturity" directives have no effect on the configuration.
+
+config MATURITY_DEPRECATED
+	bool "Display DEPRECATED features."
+	depends on ACTIVATE_MATURITY
+	default y
+
+config MATURITY_OBSOLETE
+	bool "Display OBSOLETE features."
+	depends on ACTIVATE_MATURITY
+	default y
+
 config BROKEN
 	bool


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
