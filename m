Return-Path: <linux-kernel-owner+w=401wt.eu-S965731AbXCGXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbXCGXbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965738AbXCGXbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:31:23 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:46197 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965731AbXCGXbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:31:22 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 7 Mar 2007 18:28:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Fix erroneous "MODVERSIONS" with "CONFIG_MODVERSIONS".
Message-ID: <Pine.LNX.4.64.0703071826490.3752@CPE00045a9c397f-CM001225dbafb6>
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


  Replace the apparently misspelled "MODVERSIONS" preprocessor
variable with "CONFIG_MODVERSIONS".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 76357c8..94473fc 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -65,7 +65,7 @@

 /****** Kernel includes ******/

-#ifdef MODVERSIONS
+#ifdef CONFIG_MODVERSIONS
 #include <config/modversions.h>
 #endif


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
