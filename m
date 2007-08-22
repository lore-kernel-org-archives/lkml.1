Return-Path: <linux-kernel-owner+w=401wt.eu-S1762505AbXHVJG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762505AbXHVJG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbXHVIxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:43 -0400
Received: from 1wt.eu ([62.212.114.60]:2145 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbXHVIxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:39 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084037.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:32 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Graham Murray <gmurray@webwayone.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 48/58] sx: switch subven and subid values
Content-Disposition: inline; filename=0048-sx-switch-subven-and-subid-values.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sx.c is failing to locate Graham's card.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Graham Murray <gmurray@webwayone.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/sx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 1da92a6..85a2328 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -2721,9 +2721,9 @@ static void __devexit sx_pci_remove(struct pci_dev *pdev)
    its because the standard requires it. So check for SUBVENDOR_ID. */
 static struct pci_device_id sx_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0200,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0200 },
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0300,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0300 },
 	{ 0 }
 };
 
-- 
1.5.2.5

-- 
