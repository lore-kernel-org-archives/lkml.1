Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZIOTPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZIOTPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbZIOTPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:02 -0400
Received: from kroah.org ([198.145.64.141]:33039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbZIOTO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/20] UIO: remove 'default n' from Kconfig
Date: Tue, 15 Sep 2009 12:12:40 -0700
Message-Id: <1253041976-1111-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@caiaq.de>

'default n' is the default, there is no need for these lines.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 7f86534..45200fd 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -1,7 +1,6 @@
 menuconfig UIO
 	tristate "Userspace I/O drivers"
 	depends on !S390
-	default n
 	help
 	  Enable this to allow the userspace driver core code to be
 	  built.  This code allows userspace programs easy access to
@@ -16,7 +15,6 @@ if UIO
 config UIO_CIF
 	tristate "generic Hilscher CIF Card driver"
 	depends on PCI
-	default n
 	help
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
 	  driver requires a userspace component that handles all of the
@@ -48,7 +46,6 @@ config UIO_PDRV_GENIRQ
 
 config UIO_SMX
 	tristate "SMX cryptengine UIO interface"
-	default n
 	help
 	  Userspace IO interface to the Cryptography engine found on the
 	  Nias Digital SMX boards.  These will be available from Q4 2008
@@ -61,7 +58,6 @@ config UIO_SMX
 config UIO_AEC
 	tristate "AEC video timestamp device"
 	depends on PCI
-	default n
 	help
 
 	  UIO driver for the Adrienne Electronics Corporation PCI time
@@ -78,7 +74,6 @@ config UIO_AEC
 
 config UIO_SERCOS3
 	tristate "Automata Sercos III PCI card driver"
-	default n
 	help
 	  Userspace I/O interface for the Sercos III PCI card from
 	  Automata GmbH. The userspace part of this driver will be
-- 
1.6.4.2

