Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0BIXXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 18:23:50 -0500
Received: from www.tglx.de ([62.245.132.106]:36742 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0BIXXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 18:23:48 -0500
Date: Wed, 10 Feb 2010 00:23:47 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, John Ogness <jogness@linutronix.de>,
       "Michael S. Tsirkin <mst@redhat.com>"@local
Subject: [PATCH] UIO: Review of drivers/uio/Kconfig
Message-ID: <20100209232347.GG3229@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two trivial fixes for the Userspace IO Kconfig file:
1) uio_sercos3 is a PCI driver, so let it depend on PCI.
2) "default n" under UIO_PCI_GENERIC is luxury since it is already the default.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.33-rc/drivers/uio/Kconfig
===================================================================
--- linux-2.6.33-rc.orig/drivers/uio/Kconfig	2010-02-10 00:07:18.000000000 +0100
+++ linux-2.6.33-rc/drivers/uio/Kconfig	2010-02-10 00:08:10.000000000 +0100
@@ -74,6 +74,7 @@
 
 config UIO_SERCOS3
 	tristate "Automata Sercos III PCI card driver"
+	depends on PCI
 	help
 	  Userspace I/O interface for the Sercos III PCI card from
 	  Automata GmbH. The userspace part of this driver will be
@@ -87,7 +88,6 @@
 config UIO_PCI_GENERIC
 	tristate "Generic driver for PCI 2.3 and PCI Express cards"
 	depends on PCI
-	default n
 	help
 	  Generic driver that you can bind, dynamically, to any
 	  PCI 2.3 compliant and PCI Express card. It is useful,
