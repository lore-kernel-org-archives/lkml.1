Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYKXJRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYKXJRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYKXJQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:16:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42214 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKXJQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:16:50 -0500
Date: Mon, 24 Nov 2008 10:18:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: penberg@cs.helsinki.fi, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: w35und: fix Kconfig
Message-ID: <20081124091829.GA30292@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4KSTACK dependency was needed when driver carried its own softmac
layer. That layer is gone, and functions have reasonably small stack
footprint -> dependency can be removed.

Add better description of hardware this driver is targetted at.

Signed-off-by: Pavel Machek <pavel@suse.cz>

--- gregkh-ofic/drivers/staging/winbond/Kconfig	2008-11-19 11:39:38.000000000 +0100
+++ gregkh/drivers/staging/winbond/Kconfig	2008-11-19 12:26:57.000000000 +0100
@@ -1,7 +1,11 @@
 config W35UND
-	tristate "Winbond driver"
-	depends on MAC80211 && WLAN_80211 && USB && EXPERIMENTAL && !4KSTACKS
+	tristate "IS89C35 WLAN USB driver"
+	depends on MAC80211 && WLAN_80211 && USB && EXPERIMENTAL
 	default n
 	---help---
-	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks
-	  Check http://code.google.com/p/winbondport/ for new version
+	  This is highly experimental driver for Winbond WIFI card.
+
+	  HW is present in some Kohjinsha subnotebooks, and in some 
+	  stand-alone USB modules. Chipset name seems to be w89c35d.
+
+	  Check http://code.google.com/p/winbondport/ for new version.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
