Return-Path: <linux-kernel-owner+w=401wt.eu-S1422760AbXCGSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422760AbXCGSBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422963AbXCGSAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:00:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:43389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbXCGRNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:32 -0500
Message-Id: <20070307171146.761038818@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [patch 009/101] bcm43xx: Fix for oops on resume
Content-Disposition: inline; filename=bcm43xx-fix-for-oops-on-resume.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There is a kernel oops on bcm43xx when resuming due to an overly tight timeout loop.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/bcm43xx/bcm43xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ linux-2.6.20.1/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -21,7 +21,7 @@
 #define PFX				KBUILD_MODNAME ": "
 
 #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
-#define BCM43xx_IRQWAIT_MAX_RETRIES	50
+#define BCM43xx_IRQWAIT_MAX_RETRIES	100
 
 #define BCM43xx_IO_SIZE			8192
 

--
