Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0CHLki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:40:38 -0500
Received: from mail-ew0-f225.google.com ([209.85.219.225]:42585 "EHLO
	mail-ew0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab0CHLkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:40:36 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 06:40:35 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=G4vQOsDAZ5Iml3StglGlAG7GuB3nixBXX+r43j9uLthakgKne2I8oZaBkpiUlFBfiC
         UuiZe3btSDQPnt8yzIC4K4Shub1/drF4RZmOCDy+zHiYAFJx5wu/hMAMZehcsIYhHtuZ
         3fTangdIgukPLpxld7l6JqmDqL2CScBRY60AY=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] Staging: comedi: Fix spaces coding style issue in adl_pci9111.c
Date: Mon,  8 Mar 2010 11:33:48 +0000
Message-Id: <1268048028-3088-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to the adl_pci9111.c file that fixes a spaces warning found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 969044a..bf47f79 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -216,15 +216,15 @@ Add external multiplexer support.
 
 #define pci9111_is_fifo_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_FULL_MASK)==0)
+    PCI9111_FIFO_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_half_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_HALF_FULL_MASK)==0)
+    PCI9111_FIFO_HALF_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_empty() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_EMPTY_MASK)==0)
+    PCI9111_FIFO_EMPTY_MASK) == 0)
 
 #define pci9111_ai_channel_set(channel) \
   outb((channel)&PCI9111_CHANNEL_MASK, \
-- 
1.6.3.3

