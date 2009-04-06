Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbZDFPf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbZDFPf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZDFPdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:33:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56960 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755886AbZDFPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:33:43 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/27] cyclades: Auto-load cyclades module when device opened.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:33:04 +0100
Message-ID: <20090406163303.12934.76601.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>

The cyclades module is missing the char-major-19-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/cyclades.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 272db0e..1fdb9f6 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -646,6 +646,7 @@
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
 #include <linux/firmware.h>
+#include <linux/device.h>
 
 #include <asm/system.h>
 #include <linux/io.h>
@@ -5408,3 +5409,4 @@ module_exit(cy_cleanup_module);
 
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CY_VERSION);
+MODULE_ALIAS_CHARDEV_MAJOR(CYCLADES_MAJOR);

