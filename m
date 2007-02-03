Return-Path: <linux-kernel-owner+w=401wt.eu-S1946242AbXBCCif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946242AbXBCCif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946255AbXBCCiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:12 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52934 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946258AbXBCCiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:00 -0500
Message-Id: <20070203024236.800727000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:35 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>,
       Alessandro Zummo <a.zummo@towertech.it>, Andrew Morton <akpm@osdl.org>
Subject: [patch 31/59] remove __devinit markings from rtc_sysfs_add_device()
Content-Disposition: inline; filename=remove-__devinit-markings-from-rtc_sysfs_add_device.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Mike Frysinger <vapier@gentoo.org>

rtc_sysfs_add_device is needed even after dev initialization, so drop __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/rtc/rtc-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/drivers/rtc/rtc-sysfs.c
+++ linux-2.6.19.2/drivers/rtc/rtc-sysfs.c
@@ -78,7 +78,7 @@ static struct attribute_group rtc_attr_g
 	.attrs = rtc_attrs,
 };
 
-static int __devinit rtc_sysfs_add_device(struct class_device *class_dev,
+static int rtc_sysfs_add_device(struct class_device *class_dev,
 					struct class_interface *class_intf)
 {
 	int err;

--
