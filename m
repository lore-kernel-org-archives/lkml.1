Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYKRR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYKRR6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYKRR6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:58:02 -0500
Received: from xvm-9-20.ghst.net ([92.243.9.20]:52554 "EHLO wazoo.schurger.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYKRR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:58:00 -0500
X-Greylist: delayed 1754 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Nov 2008 12:58:00 EST
From: Jean Schurger <jean@schurger.org>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-a/bK71c9+bL98YZ0ecJU"
Date: Tue, 18 Nov 2008 12:28:30 -0500
Message-Id: <1227029310.14464.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 206.47.39.162
X-SA-Exim-Mail-From: jean@schurger.org
Subject: r8169 needs mii
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on wazoo.schurger.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a/bK71c9+bL98YZ0ecJU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

  The r8169 module needs the MII hardware support library.

Here is a patch for the drivers/net/Kconfig

Jean.


--=-a/bK71c9+bL98YZ0ecJU
Content-Disposition: attachment; filename=r8159-config-mii.patch
Content-Type: text/x-patch; name=r8159-config-mii.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

diff -uNr linux-2.6.27.6.orig/drivers/net/Kconfig linux-2.6.27.6/drivers/net/Kconfig
--- linux-2.6.27.6.orig/drivers/net/Kconfig	2008-11-13 12:56:21.000000000 -0500
+++ linux-2.6.27.6/drivers/net/Kconfig	2008-11-18 12:24:46.000000000 -0500
@@ -2046,6 +2046,7 @@
 	tristate "Realtek 8169 gigabit ethernet support"
 	depends on PCI
 	select CRC32
+	select MII
 	---help---
 	  Say Y here if you have a Realtek 8169 PCI Gigabit Ethernet adapter.
 

--=-a/bK71c9+bL98YZ0ecJU--

