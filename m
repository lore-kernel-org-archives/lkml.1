Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbXCUObL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbXCUObL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXCUObL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:31:11 -0400
Received: from av7.karneval.cz ([81.27.192.15]:59911 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752878AbXCUObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:31:10 -0400
X-Quarantine-ID: <YdrVNPsCo9gB>
X-Amavis-Alert: BAD HEADER, Duplicate header field: "Cc"
Message-id: <9101217248700@karneval.cz>
Subject: [PATCH 1/2] Char: rocket, add MODULE_DEVICE_TABLE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <tytso@mit.edu>
Date: Wed, 21 Mar 2007 15:31:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rocket, add MODULE_DEVICE_TABLE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit c0854f5f8b3912aa8f31d329be14306349fb9a27
tree 8826447bb912fdb9b84f5b092276e72bf505253e
parent bb9798e15d86ada19f4d15e31124dc240df78899
author Jiri Slaby <jirislaby@gmail.com> Wed, 21 Mar 2007 15:09:58 +0100
committer Jiri Slaby <jirislaby@gmail.com> Wed, 21 Mar 2007 15:09:58 +0100

 drivers/char/rocket.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 76357c8..cb4044a 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1852,6 +1852,12 @@ static void rp_flush_buffer(struct tty_struct *tty)
 
 #ifdef CONFIG_PCI
 
+static struct pci_device_id __devinitdata rocket_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_ANY_ID) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, rocket_pci_ids);
+
 /*
  *  Called when a PCI card is found.  Retrieves and stores model information,
  *  init's aiopic and serial port hardware.
