Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYEYKYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYEYKYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbYEYKXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbYEYKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:38 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 02/28] bluetooth: treat firmware data as const
Message-Id: <E1K0DNz-0007Cu-0C@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:31 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/bluetooth/bfusb.c   |    3 ++-
 drivers/bluetooth/bt3c_cs.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index b990805..0c211ad 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -566,7 +566,8 @@ static int bfusb_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long arg
 	return -ENOIOCTLCMD;
 }
 
-static int bfusb_load_firmware(struct bfusb_data *data, unsigned char *firmware, int count)
+static int bfusb_load_firmware(struct bfusb_data *data,
+			       const unsigned char *firmware, int count)
 {
 	unsigned char *buf;
 	int err, pipe, len, size, sent = 0;
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 7703d6e..593b7c5 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -470,7 +470,8 @@ static int bt3c_hci_ioctl(struct hci_dev *hdev, unsigned int cmd, unsigned long
 /* ======================== Card services HCI interaction ======================== */
 
 
-static int bt3c_load_firmware(bt3c_info_t *info, unsigned char *firmware, int count)
+static int bt3c_load_firmware(bt3c_info_t *info, const unsigned char *firmware,
+			      int count)
 {
 	char *ptr = (char *) firmware;
 	char b[9];
-- 
1.5.4.5

