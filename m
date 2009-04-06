Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZDFPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZDFPhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZDFPev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:34:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56977 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754751AbZDFPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:34:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/27] usb: Auto-load cdc_acm module when device opened.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:33:18 +0100
Message-ID: <20090406163317.12934.99480.stgit@t61.ukuu.org.uk>
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

The cdc_acm module is missing the char-major-166-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b3d5a23..85f22c6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1493,4 +1493,4 @@ module_exit(acm_exit);
 MODULE_AUTHOR( DRIVER_AUTHOR );
 MODULE_DESCRIPTION( DRIVER_DESC );
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS_CHARDEV_MAJOR(ACM_TTY_MAJOR);

