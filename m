Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXDAOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXDAOfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXDAOfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:47524 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbXDAOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/41] KVM: Use own minor number
Date: Sun,  1 Apr 2007 17:35:00 +0300
Message-Id: <1175438138805-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381384009-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the minor number (232) allocated to kvm by lanana.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c     |    2 +-
 include/linux/miscdevice.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 drivers/kvm/kvm_main.c

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
old mode 100644
new mode 100755
index ff7c836..946ed86
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2299,7 +2299,7 @@ static struct file_operations kvm_chardev_ops = {
 };
 
 static struct miscdevice kvm_dev = {
-	MISC_DYNAMIC_MINOR,
+	KVM_MINOR,
 	"kvm",
 	&kvm_chardev_ops,
 };
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 326da7d..dff9ea3 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -29,6 +29,7 @@
 
 #define TUN_MINOR	     200
 #define	HPET_MINOR	     228
+#define KVM_MINOR            232
 
 struct device;
 
-- 
1.5.0.5

