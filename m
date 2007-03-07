Return-Path: <linux-kernel-owner+w=401wt.eu-S1422673AbXCGRZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422673AbXCGRZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422877AbXCGRZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:25:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422894AbXCGRSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:03 -0500
Message-Id: <20070307171618.763827313@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, kernel@nn7.de,
       benh@kernel.crashing.org, paulus@samba.org, dtor@mail.ru
Subject: [patch 085/101] enable mouse button 2+3 emulation for x86 macs
Content-Disposition: inline; filename=enable-mouse-button-2-3-emulation-for-x86-macs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Soeren Sonnenburg <kernel@nn7.de>

As macbook/macbook pro's also have to live with a single mouse button the
following patch just enables the Macintosh device drivers menu in Kconfig +
adds the macintosh dir to the obj-* to make macbook* users happy (who use
exactly that since months....

Signed-off-by: Soeren Sonnenburg <kernel@nn7.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/Makefile          |    2 +-
 drivers/macintosh/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/Makefile
+++ linux-2.6.20.1/drivers/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ net/ media/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-$(CONFIG_ATM)		+= atm/
-obj-$(CONFIG_PPC_PMAC)		+= macintosh/
+obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_FC4)		+= fc4/
 obj-$(CONFIG_SCSI)		+= scsi/
--- linux-2.6.20.1.orig/drivers/macintosh/Kconfig
+++ linux-2.6.20.1/drivers/macintosh/Kconfig
@@ -1,6 +1,6 @@
 
 menu "Macintosh device drivers"
-	depends on PPC || MAC
+	depends on PPC || MAC || X86
 
 config ADB
 	bool "Apple Desktop Bus (ADB) support"

--
