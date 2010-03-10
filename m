Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab0CJV74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:59:56 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44395 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab0CJV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=PbpLYAAdhGs43TulnR3gNEzaIxkxZplAOwgTlIKZhd094GwbcyqQhsKJkqwvasMhi4
         qmgWRHtINM5qj0u+WrbRCxDgfAD30FZDn+hYQk0LGXrXF6YD9OvtiE3Bf7k69FojvgOQ
         KBKgtFyNWFGZCXvgP8fcsIrBvkKNDp6IaVERU=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] Staging: comedi: fix macro coding style issue in adl_pci9111.c
Date: Wed, 10 Mar 2010 21:59:39 +0000
Message-Id: <1268258379-4995-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to remove trailing semi-colons from do - while loops in the adl_pci9111.c file

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 5171176..5421104 100755
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -214,7 +214,7 @@ Add external multiplexer support.
 			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
 		outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
 			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-	} while (0);
+	} while (0)
 
 #define pci9111_is_fifo_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
@@ -271,7 +271,7 @@ Add external multiplexer support.
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
 		outb((data >> 8) & 0xFF, \
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
-	} while (0);
+	} while (0)
 
 #define pci9111_8254_counter_1_set(data) \
 	do { \
@@ -279,7 +279,7 @@ Add external multiplexer support.
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
 		outb((data >> 8) & 0xFF, \
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
-	} while (0);
+	} while (0)
 
 #define pci9111_8254_counter_2_set(data) \
 	do { \
@@ -287,7 +287,7 @@ Add external multiplexer support.
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
 		outb((data >> 8) & 0xFF, \
 			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
-	} while (0);
+	} while (0)
 
 /*  Function prototypes */
 
@@ -581,7 +581,7 @@ static int pci9111_ai_cancel(struct comedi_device *dev,
 	do { \
 		tmp = src; \
 		src &= flags; if (!src || tmp != src) error++; \
-	} while (0);
+	} while (0)
 
 static int
 pci9111_ai_do_cmd_test(struct comedi_device *dev,
-- 
1.6.3.3

