Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZFEOnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZFEOnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZFEOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:43:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56403 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:43:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 5 Jun 2009 16:43:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch 2/2] firewire: rename source files
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.b8d0b3fd0adbd091@s5r6.in-berlin.de>
Message-ID: <tkrat.9c353e14a798ecf3@s5r6.in-berlin.de>
References: <tkrat.b8d0b3fd0adbd091@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source files of firewire-core, firewire-ohci, firewire-sbp2, i.e.
 "drivers/firewire/fw-*.c"
are renamed to
 "drivers/firewire/core-*.c",
 "drivers/firewire/ohci.c",
 "drivers/firewire/sbp2.c".

The old fw- prefix was redundant to the directory name.  The new core-
prefix distinguishes the files according to which driver they belong to.

This change comes a little late, but still before further firewire
drivers are added as anticipated RSN.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This is a git diff with rename detection; ditto patch 1/2.
A normal unified diff is available at
http://user.in-berlin.de/~s5r6/linux1394/pending/.

 drivers/firewire/Makefile                          |    8 ++++----
 drivers/firewire/{fw-card.c => core-card.c}        |    0
 drivers/firewire/{fw-cdev.c => core-cdev.c}        |    0
 drivers/firewire/{fw-device.c => core-device.c}    |    0
 drivers/firewire/{fw-iso.c => core-iso.c}          |    0
 .../firewire/{fw-topology.c => core-topology.c}    |    0
 .../{fw-transaction.c => core-transaction.c}       |    0
 drivers/firewire/{fw-ohci.c => ohci.c}             |    0
 drivers/firewire/{fw-sbp2.c => sbp2.c}             |    0
 9 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/firewire/{fw-card.c => core-card.c} (100%)
 rename drivers/firewire/{fw-cdev.c => core-cdev.c} (100%)
 rename drivers/firewire/{fw-device.c => core-device.c} (100%)
 rename drivers/firewire/{fw-iso.c => core-iso.c} (100%)
 rename drivers/firewire/{fw-topology.c => core-topology.c} (100%)
 rename drivers/firewire/{fw-transaction.c => core-transaction.c} (100%)
 rename drivers/firewire/{fw-ohci.c => ohci.c} (100%)
 rename drivers/firewire/{fw-sbp2.c => sbp2.c} (100%)

diff --git a/drivers/firewire/Makefile b/drivers/firewire/Makefile
index a7c31e9..bc3b9bf 100644
--- a/drivers/firewire/Makefile
+++ b/drivers/firewire/Makefile
@@ -2,10 +2,10 @@
 # Makefile for the Linux IEEE 1394 implementation
 #
 
-firewire-core-y += fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
-                   fw-device.o fw-cdev.o
-firewire-ohci-y += fw-ohci.o
-firewire-sbp2-y += fw-sbp2.o
+firewire-core-y += core-card.o core-cdev.o core-device.o \
+                   core-iso.o core-topology.o core-transaction.o
+firewire-ohci-y += ohci.o
+firewire-sbp2-y += sbp2.o
 
 obj-$(CONFIG_FIREWIRE) += firewire-core.o
 obj-$(CONFIG_FIREWIRE_OHCI) += firewire-ohci.o
diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/core-card.c
similarity index 100%
rename from drivers/firewire/fw-card.c
rename to drivers/firewire/core-card.c
diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/core-cdev.c
similarity index 100%
rename from drivers/firewire/fw-cdev.c
rename to drivers/firewire/core-cdev.c
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/core-device.c
similarity index 100%
rename from drivers/firewire/fw-device.c
rename to drivers/firewire/core-device.c
diff --git a/drivers/firewire/fw-iso.c b/drivers/firewire/core-iso.c
similarity index 100%
rename from drivers/firewire/fw-iso.c
rename to drivers/firewire/core-iso.c
diff --git a/drivers/firewire/fw-topology.c b/drivers/firewire/core-topology.c
similarity index 100%
rename from drivers/firewire/fw-topology.c
rename to drivers/firewire/core-topology.c
diff --git a/drivers/firewire/fw-transaction.c b/drivers/firewire/core-transaction.c
similarity index 100%
rename from drivers/firewire/fw-transaction.c
rename to drivers/firewire/core-transaction.c
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/ohci.c
similarity index 100%
rename from drivers/firewire/fw-ohci.c
rename to drivers/firewire/ohci.c
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/sbp2.c
similarity index 100%
rename from drivers/firewire/fw-sbp2.c
rename to drivers/firewire/sbp2.c
-- 
1.6.0.6


-- 
Stefan Richter
-=====-==--= -==- --=-=
http://arcgraph.de/sr/

