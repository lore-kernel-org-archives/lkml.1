Return-Path: <linux-kernel-owner+w=401wt.eu-S1161070AbXBTXWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070AbXBTXWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161068AbXBTXWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:22:07 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:40155 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161070AbXBTXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:22:06 -0500
X-Originating-Ip: 74.102.209.62
Date: Tue, 20 Feb 2007 18:20:10 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] deprecated/obsolete patch
Message-ID: <Pine.LNX.4.64.0702201818580.11849@localhost.localdomain>
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


  here's a slightly revised wording, if that makes it clearer:

diff --git a/init/Kconfig b/init/Kconfig
index f977086..d5ab6ec 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -29,9 +29,10 @@ config EXPERIMENTAL
 	  <file:Documentation/BUG-HUNTING>, and
 	  <file:Documentation/oops-tracing.txt> in the kernel source).

-	  This option will also make obsoleted drivers available. These are
-	  drivers that have been replaced by something else, and/or are
-	  scheduled to be removed in a future kernel release.
+	  At the moment, this option also makes obsolete drivers available,
+	  but such drivers really should be removed from the EXPERIMENTAL
+	  category and added to either DEPRECATED or OBSOLETE, depending
+	  on their status.

 	  Unless you intend to help test and develop a feature or driver that
 	  falls into this category, or you have a situation that requires
@@ -40,6 +41,29 @@ config EXPERIMENTAL
 	  you say Y here, you will be offered the choice of using features or
 	  drivers that are currently considered to be in the alpha-test phase.

+config DEPRECATED
+	bool "Prompt for deprecated code/drivers"
+	default y
+	---help---
+	  Code that has been tagged as "deprecated" generally still works and
+	  is probably still supported, but there is already a newer and better
+	  alternative available and you should seriously consider switching to
+	  that newer alternative.
+
+	  Code that is marked as deprecated for quite some time also has a
+	  tendency to eventually become "obsolete," at which point it will
+	  probably be removed entirely from the kernel.
+
+config OBSOLETE
+	bool "Prompt for obsolete code/drivers"
+	default n
+	---help---
+	  Code that has been tagged as "obsolete" is no longer officially
+	  supported and shouldn't play a part in any normal build.  Obsolete
+	  code might already be scheduled for removal as well, so you might
+	  want to check the file Documentation/feature-removal-schedule.txt for
+	  any proposed removal dates.
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
