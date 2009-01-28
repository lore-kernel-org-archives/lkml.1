Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZA1X3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZA1X3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZA1X2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:11 -0500
Received: from kroah.org ([198.145.64.141]:56977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756580AbZA1X2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/10] Staging: comedi: fix Kbuild
Date: Wed, 28 Jan 2009 15:26:41 -0800
Message-Id: <1233185210-23098-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comedi doesn't like being built into the kernel right now, so force it
to be a module.

Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/comedi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index b501bfb..b47ca1e 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1,6 +1,7 @@
 config COMEDI
 	tristate "Data Acquision support (comedi)"
 	default N
+	depends on m
 	---help---
 	  Enable support a wide range of data acquision devices
 	  for Linux.
-- 
1.6.0.2

