Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0BKOjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:39:18 -0500
Received: from www.tglx.de ([62.245.132.106]:44561 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab0BKOjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:39:16 -0500
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [PATCH] UIO: Review of drivers/uio/Kconfig
From: John Ogness <john.ogness@linutronix.de>
References: <20100209232347.GG3229@local>
Date: Thu, 11 Feb 2010 15:38:53 +0100
In-Reply-To: <20100209232347.GG3229@local> (Hans J. Koch's message of "Wed\, 10 Feb 2010 00\:23\:47 +0100")
Message-ID: <80vde3rg5e.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two trivial fixes for the Userspace IO Kconfig file:
1) uio_sercos3 is a PCI driver, so let it depend on PCI.
2) "default n" under UIO_PCI_GENERIC is luxury since it is already the default.

Acked-by: John Ogness <john.ogness@linutronix.de>
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
