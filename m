Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXCUXNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXCUXNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbXCUXNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:13:41 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38706 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXCUXNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:13:40 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 21 Mar 2007 19:10:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] De-list the raw driver from scheduled removal.
Message-ID: <Pine.LNX.4.64.0703211908140.5679@CPE00045a9c397f-CM001225dbafb6>
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


Stop trying to remove the raw driver.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  happy now?  :-P

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0bc8b0b..6b845f3 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -21,14 +21,6 @@ Who:	Pavel Machek <pavel@suse.cz>

 ---------------------------

-What:	RAW driver (CONFIG_RAW_DRIVER)
-When:	December 2005
-Why:	declared obsolete since kernel 2.6.3
-	O_DIRECT can be used instead
-Who:	Adrian Bunk <bunk@stusta.de>
-
----------------------------
-
 What:	raw1394: requests of type RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN
 When:	June 2007
 Why:	Deprecated in favour of the more efficient and robust rawiso interface.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
