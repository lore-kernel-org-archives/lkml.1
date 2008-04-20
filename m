Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbYDTKkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbYDTKkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYDTKj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:39:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYDTKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:39:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Denis Cheng <crquan@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/36] uio: mark pci_device_id hilscher_pci_ids[] __devinitdata
Date: Sun, 20 Apr 2008 03:45:33 -0700
Message-Id: <1208688366-9252-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio_cif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 838bae4..4a5a97e 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -116,7 +116,7 @@ static void hilscher_pci_remove(struct pci_dev *dev)
 	kfree (info);
 }
 
-static struct pci_device_id hilscher_pci_ids[] = {
+static struct pci_device_id hilscher_pci_ids[] __devinitdata = {
 	{
 		.vendor =	PCI_VENDOR_ID_PLX,
 		.device =	PCI_DEVICE_ID_PLX_9030,
-- 
1.5.4.5

