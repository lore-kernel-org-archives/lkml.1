Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab0CJWKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:10:08 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47759 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab0CJWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=W9JfHGatsUHL24Yb2Y0dPqzJS8k07eCyzk7xGUH2moRWo5wIraKhxKHQxwr1cwdCZ4
         uSsk8K76sYsBaQ+lA5j+i+1Hyl0SrpPPOg51h4C98SQbUMKbF4r8S2tjhLDPaDHXj2Xe
         aVm+j6B9N9okn4QEclf06tVebuyfsCq8BzAxo=
From: =?UTF-8?q?=C3=93lafur=20Jens=20Sigur=C3=B0sson?= <ojsbug@gmail.com>
To: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, sdietrich@novell.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       =?UTF-8?q?=C3=93lafur=20Jens=20=C5=9Aigur=C3=B0sson?= 
	<ojsbug@gmail.com>
Subject: [PATCH] =?UTF-8?q?Staging:=20batman-adv:=20Fix=20coding=20style=20in=20device.c
Date: Wed, 10 Mar 2010 22:09:35 +0000
Message-Id: <1268258975-4161-1-git-send-email-ojsbug@gmail.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ólafur Jens Śigurðsson <ojsbug@gmail.com>

---
 drivers/staging/batman-adv/device.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/batman-adv/device.c b/drivers/staging/batman-adv/device.c
index e7f4421..6edc2f2 100644
--- a/drivers/staging/batman-adv/device.c
+++ b/drivers/staging/batman-adv/device.c
@@ -67,7 +67,7 @@ int bat_device_setup(void)
 	batman_class = class_create(THIS_MODULE, "batman-adv");
 
 	if (IS_ERR(batman_class)) {
-		printk(KERN_ERR "batman-adv:Could not register class 'batman-adv' \n");
+		printk(KERN_ERR "batman-adv:Could not register class 'batman-adv'\n");
 		return 0;
 	}
 
@@ -110,7 +110,7 @@ int bat_device_open(struct inode *inode, struct file *file)
 	}
 
 	if (device_client_hash[i] != device_client) {
-		printk(KERN_ERR "batman-adv:Error - can't add another packet client: maximum number of clients reached \n");
+		printk(KERN_ERR "batman-adv:Error - can't add another packet client: maximum number of clients reached\n");
 		kfree(device_client);
 		return -EXFULL;
 	}
@@ -211,7 +211,8 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
 	unsigned long flags;
 
 	if (len < sizeof(struct icmp_packet)) {
-		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: invalid packet size\n");
+		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from "
+					"char device: invalid packet size\n");
 		return -EINVAL;
 	}
 
@@ -222,12 +223,16 @@ ssize_t bat_device_write(struct file *file, const char __user *buff,
 		return -EFAULT;
 
 	if (icmp_packet.packet_type != BAT_ICMP) {
-		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: got bogus packet type (expected: BAT_ICMP)\n");
+		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from "
+					"char device: got bogus packet type "
+					"(expected: BAT_ICMP)\n");
 		return -EINVAL;
 	}
 
 	if (icmp_packet.msg_type != ECHO_REQUEST) {
-		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from char device: got bogus message type (expected: ECHO_REQUEST)\n");
+		bat_dbg(DBG_BATMAN, "batman-adv:Error - can't send packet from "
+					"char device: got bogus message type "
+					"(expected: ECHO_REQUEST)\n");
 		return -EINVAL;
 	}
 
-- 
1.6.6.2

