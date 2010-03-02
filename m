Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0CBXgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:36:06 -0500
Received: from kroah.org ([198.145.64.141]:38655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab0CBX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Ogness <john.ogness@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/62] UIO: minor Kconfig fixes
Date: Tue,  2 Mar 2010 15:28:38 -0800
Message-Id: <1267572541-410-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

Two trivial fixes for the Userspace IO Kconfig file:
1) uio_sercos3 is a PCI driver, so let it depend on PCI.
2) "default n" under UIO_PCI_GENERIC is luxury since it is already the default.

Acked-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 069b144..6dd2a29 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -74,6 +74,7 @@ config UIO_AEC
 
 config UIO_SERCOS3
 	tristate "Automata Sercos III PCI card driver"
+	depends on PCI
 	help
 	  Userspace I/O interface for the Sercos III PCI card from
 	  Automata GmbH. The userspace part of this driver will be
@@ -87,7 +88,6 @@ config UIO_SERCOS3
 config UIO_PCI_GENERIC
 	tristate "Generic driver for PCI 2.3 and PCI Express cards"
 	depends on PCI
-	default n
 	help
 	  Generic driver that you can bind, dynamically, to any
 	  PCI 2.3 compliant and PCI Express card. It is useful,
-- 
1.7.0.1

