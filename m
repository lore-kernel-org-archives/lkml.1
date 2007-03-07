Return-Path: <linux-kernel-owner+w=401wt.eu-S1422942AbXCGRX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942AbXCGRX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422917AbXCGRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:43816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422891AbXCGRSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:21 -0500
Message-Id: <20070307171644.216202267@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, randy.dunlap@oracle.com
Subject: [patch 093/101] ueagle-atm.c needs sched.h
Content-Disposition: inline; filename=ueagle-atm.c-needs-sched.h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Randy Dunlap <randy.dunlap@oracle.com>

Driver needs sched.h for try_to_freeze().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/atm/ueagle-atm.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20.1.orig/drivers/usb/atm/ueagle-atm.c
+++ linux-2.6.20.1/drivers/usb/atm/ueagle-atm.c
@@ -61,6 +61,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/ctype.h>
+#include <linux/sched.h>
 #include <linux/kthread.h>
 #include <linux/version.h>
 #include <linux/mutex.h>

--
