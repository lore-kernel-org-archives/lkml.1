Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYIYMJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYIYMJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYIYL5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:57:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbYIYL5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:57:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 39/39] KVM: s390: change help text of guest Kconfig
Date: Thu, 25 Sep 2008 14:55:11 +0300
Message-Id: <1222343711-12508-40-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The current help text for CONFIG_S390_GUEST is not very helpful.
Lets add more text.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/s390/Kconfig |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 8d41908..c9bfed9 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -564,13 +564,16 @@ config ZFCPDUMP
 	  Refer to <file:Documentation/s390/zfcpdump.txt> for more details on this.
 
 config S390_GUEST
-bool "s390 guest support (EXPERIMENTAL)"
+bool "s390 guest support for KVM (EXPERIMENTAL)"
 	depends on 64BIT && EXPERIMENTAL
 	select VIRTIO
 	select VIRTIO_RING
 	select VIRTIO_CONSOLE
 	help
-	  Select this option if you want to run the kernel under s390 linux
+	  Select this option if you want to run the kernel as a guest under
+	  the KVM hypervisor. This will add detection for KVM as well  as a
+	  virtio transport. If KVM is detected, the virtio console will be
+	  the default console.
 endmenu
 
 source "net/Kconfig"
-- 
1.6.0.1

