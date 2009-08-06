Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZHFB7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZHFB7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZHFB7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:59:43 -0400
Received: from mail.atheros.com ([12.36.123.2]:33346 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZHFB7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:59:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
       <mcgrof@gmail.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       <zhifeng.cai@atheros.com>, <stephen.chen@atheros.com>
Subject: [PATCH] pci_ids.h: add new Atheros USB vendor ID
Date: Wed, 5 Aug 2009 18:59:41 -0700
Message-ID: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Atheros USB devices will use 0x0cf3. The first device
will be ar9271, for which we are adding support for.

Cc: zhifeng.cai@atheros.com
Cc: stephen.chen@atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, sending this through you as this is only
specific to wireless, at least at the moment.

 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 73b46b6..27f4e6b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2170,6 +2170,7 @@
 #define PCI_DEVICE_ID_BCM1250_HT	0x0002
 
 #define PCI_VENDOR_ID_ATHEROS		0x168c
+#define PCI_VENDOR_ID_ATHEROS_USB	0x0cf3
 
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
-- 
1.6.3.3

