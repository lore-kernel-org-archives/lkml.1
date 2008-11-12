Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbYKLMEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbYKLMEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYKLMEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:04:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58072 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYKLME3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:04:29 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: v4l-dvb-maintainer@linuxtv.org, linux-dvb@linuxtv.org,
       Alex Woods <linux-dvb@giblets.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ttusb-dec: make it depend on PCI
Date: Wed, 12 Nov 2008 07:04:28 -0500
Message-Id: <1226491468-9343-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
References: <1226491218-9281-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ttusb_dec.c relies on pci_alloc_consistent and
pci_free_consistent, make it depend on PCI in Kconfig.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/media/dvb/ttusb-dec/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ttusb-dec/Kconfig b/drivers/media/dvb/ttusb-dec/Kconfig
index d5f48a3..290254a 100644
--- a/drivers/media/dvb/ttusb-dec/Kconfig
+++ b/drivers/media/dvb/ttusb-dec/Kconfig
@@ -1,6 +1,6 @@
 config DVB_TTUSB_DEC
 	tristate "Technotrend/Hauppauge USB DEC devices"
-	depends on DVB_CORE && USB && INPUT
+	depends on DVB_CORE && USB && INPUT && PCI
 	select CRC32
 	help
 	  Support for external USB adapters designed by Technotrend and
-- 
1.6.0.3

