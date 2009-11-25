Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZKYRFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZKYRFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbZKYRF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:05:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187AbZKYRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ZwSG7yQzADGiT/sLGutNhllBXcX09IzRg5nanqxhWnduYv/qkULy9+5ub39yDyh+a1
         ELsm2842Mkap6v0mORVMzWMgfC8GMkyhkGTDbZMUXInajDTkBVC3mSAbOnVRcTSVUUsZ
         fJa2sjqeOlSOA/7GwnQn2KfRwoXRJlJ7BCpJw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:36 +0100
Message-Id: <20091125170436.5446.83994.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 19/86] pata_cmd640: document known issues
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd640: document known issues

Document known issues with the driver to aid distribution makers,
users and developers in making informed decisions instead of wasting
their time needlessly.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/Kconfig |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -287,8 +287,11 @@ config PATA_CMD640_PCI
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD640 PCI IDE
-	  interface chip. Only the primary channel is currently
-	  supported.
+	  interface chip.
+
+	  Known issues:
+	  - only the primary channel is currently supported
+	  - only the PCI chip interface is currently supported
 
 	  If unsure, say N.
 
