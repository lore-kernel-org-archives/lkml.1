Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbZLVFMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbZLVFMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 00:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZLVFMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 00:12:12 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54377 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZLVFML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 00:12:11 -0500
Date: Tue, 22 Dec 2009 16:12:09 +1100
From: Simon Horman <horms@verge.net.au>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Solomon Peachy <pizza@shaftnet.org>
Subject: [patch] prism2-usb: Build should select WIRELESS_EXT
Message-ID: <20091222051209.GA4054@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prevailing idiom is to select WIRELESS_EXT not depend on it.

Depending leaves this driver in a situation where it can only
be built if another driver that selects WIRELESS_EXT has been enabled.

Signed-off-by: Simon Horman <horms@verge.net.au>

--- 

Reposting as I mucked up my own name the first time around

Index: net-next-2.6/drivers/staging/wlan-ng/Kconfig
===================================================================
--- net-next-2.6.orig/drivers/staging/wlan-ng/Kconfig	2009-12-21 12:35:25.000000000 +1100
+++ net-next-2.6/drivers/staging/wlan-ng/Kconfig	2009-12-21 12:35:45.000000000 +1100
@@ -1,6 +1,7 @@
 config PRISM2_USB
 	tristate "Prism2.5/3 USB driver"
-	depends on WLAN && USB && WIRELESS_EXT
+	depends on WLAN && USB
+	select WIRELESS_EXT
 	default n
 	---help---
 	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
