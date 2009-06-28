Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZF1Qjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZF1Qjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZF1Q2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:24 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1164 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbZF1Q2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:08 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 47/62] drivers/usb: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:52 -0700
Message-Id: <1cb3eb8ffebcc9b2e18acd3be34cc3b7973e9769.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/class/cdc-wdm.c  |    2 --
 drivers/usb/serial/spcp8x5.c |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 0fe4345..76929ea 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -507,8 +507,6 @@ static int wdm_open(struct inode *inode, struct file *file)
 	desc = usb_get_intfdata(intf);
 	if (test_bit(WDM_DISCONNECTING, &desc->flags))
 		goto out;
-
-	;
 	file->private_data = desc;
 
 	rv = usb_autopm_get_interface(desc->intf);
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 3c249d8..26d2914 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -546,7 +546,7 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	}
 
 	/* Set Baud Rate */
-	baud = tty_get_baud_rate(tty);;
+	baud = tty_get_baud_rate(tty);
 	switch (baud) {
 	case 300:	buf[0] = 0x00;	break;
 	case 600:	buf[0] = 0x01;	break;
-- 
1.6.3.1.10.g659a0.dirty

