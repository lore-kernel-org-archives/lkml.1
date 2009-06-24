Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZFXPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZFXPbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZFXPbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:31:06 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55600 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZFXPbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:31:05 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, hjk@linutronix.de, Daniel Mack <daniel@caiaq.de>
Subject: [PATCH 2/2] UIO: remove 'default n' from Kconfig
Date: Wed, 24 Jun 2009 17:30:25 +0200
Message-Id: <1245857425-25389-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245857425-25389-2-git-send-email-daniel@caiaq.de>
References: <1245857425-25389-1-git-send-email-daniel@caiaq.de>
 <1245857425-25389-2-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'default n' is the default, there is no need for these lines.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Hans J. Koch <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.3.1

