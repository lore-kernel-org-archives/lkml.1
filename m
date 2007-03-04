Return-Path: <linux-kernel-owner+w=401wt.eu-S932997AbXCDQJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbXCDQJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933003AbXCDQJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:09:05 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50366 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbXCDQJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:09:04 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Mar 2007 10:09:13 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Kconfig:  Remove reference to external mqueue library.
Message-ID: <Pine.LNX.4.64.0703041006560.28227@CPE00045a9c397f-CM001225dbafb6>
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


  Remove the reference to an external mqueue library since that was
merged into glibc in 2004.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/init/Kconfig b/init/Kconfig
index f977086..ed2e0d3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -139,9 +139,7 @@ config POSIX_MQUEUE
 	  queues every message has a priority which decides about succession
 	  of receiving it by a process. If you want to compile and run
 	  programs written e.g. for Solaris with use of its POSIX message
-	  queues (functions mq_*) say Y here. To use this feature you will
-	  also need mqueue library, available from
-	  <http://www.mat.uni.torun.pl/~wrona/posix_ipc/>
+	  queues (functions mq_*) say Y here.

 	  POSIX message queues are visible as a filesystem called 'mqueue'
 	  and can be mounted somewhere if you want to do filesystem

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
