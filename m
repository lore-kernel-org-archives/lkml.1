Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0CGED6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 23:03:58 -0500
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52294 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0CGED4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 23:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qcptB8bqaDrIIC20GEKTfLtucFw15eQtMBqv43jqtjhxew6Z4BHnUfz1PHP9y6y7hd
         Ss17W9ASrMDlu7FyTx/wX+JZdhJ2nTy/UGefHwr1lvycyz1UtcHMoZOCXb4i0JZz7j0R
         z+UPjwLuyX0+h5St0zw77MIDU5cHxu8R6F3d8=
From: t.a.c.henriques@googlemail.com
To: gregkh@suse.de, t.a.c.henriques@gmail.com
Cc: marcel@holtmann.org, adobriyan@gmail.com, tglx@linutronix.de,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: fix coding style issue in hci_vhci.c This patch affects hci_vhci.c it fixes some warnings detected by the checkpath.pl tool Signed-off-by: Tiago Henriques <t.a.c.henriques@gmail.com>
Date: Sun,  7 Mar 2010 04:03:51 +0000
Message-Id: <1267934631-3531-1-git-send-email-t.a.c.henriques@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <Fix Bluetooth Code Style warnings>
References: <Fix Bluetooth Code Style warnings>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@balganUbuntuVM.(none)>

---
 drivers/bluetooth/hci_vhci.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
index bb0aefd..4a5386e 100644
--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -264,12 +264,9 @@ static int vhci_release(struct inode *inode, struct file *file)
 	struct vhci_data *data = file->private_data;
 	struct hci_dev *hdev = data->hdev;
 
-	if (hci_unregister_dev(hdev) < 0) {
+	if (hci_unregister_dev(hdev) < 0)
 		BT_ERR("Can't unregister HCI device %s", hdev->name);
-	}
-
 	hci_free_dev(hdev);
-
 	file->private_data = NULL;
 
 	return 0;
@@ -284,7 +281,7 @@ static const struct file_operations vhci_fops = {
 	.release	= vhci_release,
 };
 
-static struct miscdevice vhci_miscdev= {
+static struct miscdevice vhci_miscdev = {
 	.name	= "vhci",
 	.fops	= &vhci_fops,
 	.minor	= MISC_DYNAMIC_MINOR,
-- 
1.6.3.3

