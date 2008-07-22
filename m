Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYGVFkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYGVFkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbYGVFZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:43362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYGVFZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/79] UIO: fix UIO Kconfig dependencies
Date: Mon, 21 Jul 2008 22:19:20 -0700
Message-Id: <1216703983-21448-56-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

ae210f188614bb3d1ee3f19c64e28e3cdd44877c introduced a big "if UIO"/"endif"
where all uio drivers are defined.  So know there is no need for them to
depend explicitly on UIO.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index a4aaab9..78e139c 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -15,7 +15,7 @@ if UIO
 
 config UIO_CIF
 	tristate "generic Hilscher CIF Card driver"
-	depends on UIO && PCI
+	depends on PCI
 	default n
 	help
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
@@ -28,7 +28,6 @@ config UIO_CIF
 
 config UIO_SMX
 	tristate "SMX cryptengine UIO interface"
-	depends on UIO
 	default n
 	help
 	  Userspace IO interface to the Cryptography engine found on the
-- 
1.5.6.3

