Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYIRAVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYIRAVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbYIRATU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:19:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:60127 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYIRATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kDP8Yd+P0aunPAjv8/4YMf6eaZI0S33Tq89A/yqjcYLjawFiiPgyU6jE55/72yYcq6
         tgP4OqRM340eEqGDeXwIxkrHQCKDyoBVUF2BfyZoqQ52X4HyLm5mAzZsg3JA8fHh3NvM
         qlmUGOCBYDNMDfrF5/VOD/lf/IqSyCzqAMHs8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] pci: using %pF in quirks.c
Date: Wed, 17 Sep 2008 17:18:32 -0700
Message-Id: <1221697112-21814-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/quirks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -1689,8 +1689,7 @@ static void pci_do_fixups(struct pci_dev
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 #ifdef DEBUG
-			dev_dbg(&dev->dev, "calling ");
-			print_fn_descriptor_symbol("%s\n", f->hook);
+			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 #endif
 			f->hook(dev);
 		}
