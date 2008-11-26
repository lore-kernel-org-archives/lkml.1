Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYKZQNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYKZQNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYKZQN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:13:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49914 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKZQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:13:28 -0500
Date: Wed, 26 Nov 2008 17:15:16 +0100
From: Pavel Machek <pavel@suse.cz>
To: penberg@cs.helsinki.fi, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, rdunlap@xenotime.net
Subject: Re: w35und: fix Kconfig
Message-ID: <20081126161516.GB1983@elf.ucw.cz>
References: <20081124091829.GA30292@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124091829.GA30292@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


4KSTACK dependency was needed when driver carried its own softmac
layer. That layer is gone, and functions have reasonably small stack
footprint -> dependency can be removed.

Add better description of hardware this driver is targetted at (now
with fixed whitespace)

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

diff -ur gregkh-ofic/drivers/staging/winbond/Kconfig gregkh/drivers/staging/winbond/Kconfig
--- gregkh-ofic/drivers/staging/winbond/Kconfig	2008-11-19 11:39:38.000000000 +0100
+++ gregkh/drivers/staging/winbond/Kconfig	2008-11-26 10:33:36.000000000 +0100
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
+	  Hardware is present in some Kohjinsha subnotebooks, and in some
+	  stand-alone USB modules. Chipset name seems to be w89c35d.
+
+	  Check http://code.google.com/p/winbondport/ for new version.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
