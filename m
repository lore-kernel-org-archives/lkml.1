Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYDTKlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYDTKlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbYDTKkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56255 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbYDTKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Hans-J=C3=BCrgen=20Koch?= <hjk@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/36] UIO: Remove needless PCI_DEVICE_ID definition from uio_cif.c
Date: Sun, 20 Apr 2008 03:45:35 -0700
Message-Id: <1208688366-9252-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Jürgen Koch <hjk@linutronix.de>

Meanwhile, PCI_DEVICE_ID_PLX_9030 is defined in pci_ids.h, no need to
define it again in the driver.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
CC: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_cif.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 4a5a97e..5737606 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -15,10 +15,6 @@
 
 #include <asm/io.h>
 
-#ifndef PCI_DEVICE_ID_PLX_9030
-#define PCI_DEVICE_ID_PLX_9030	0x9030
-#endif
-
 #define PLX9030_INTCSR		0x4C
 #define INTSCR_INT1_ENABLE	0x01
 #define INTSCR_INT1_STATUS	0x04
-- 
1.5.4.5

