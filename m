Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbZIOTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbZIOTRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758603AbZIOTQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:16:48 -0400
Received: from kroah.org ([198.145.64.141]:33079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758490AbZIOTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: GeunSik Lim <leemgs1@gmail.com>, GeunSik Lim <geunsik.lim@samsung.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/20] debugfs: Modified default dir of debugfs for debugging UHCI.
Date: Tue, 15 Sep 2009 12:12:54 -0700
Message-Id: <1253041976-1111-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GeunSik Lim <leemgs1@gmail.com>

Change default debugfs directory as mounting point for debugging
UHCI(Universal Host Controller Interface driver) for USB.

As we all know, We need change default directory for consistency of
debugfs by Greg K-H

Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/uhci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 274751b..5cd0e48 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(ignore_oc, "ignore hardware overcurrent indications");
  * debug = 0, no debugging messages
  * debug = 1, dump failed URBs except for stalls
  * debug = 2, dump all failed URBs (including stalls)
- *            show all queues in /debug/uhci/[pci_addr]
+ *            show all queues in /sys/kernel/debug/uhci/[pci_addr]
  * debug = 3, show all TDs in URBs when dumping
  */
 #ifdef DEBUG
-- 
1.6.4.2

