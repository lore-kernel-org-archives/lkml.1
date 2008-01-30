Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbYA3Jec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbYA3Jec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYA3Jaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:35 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:40738 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbYA3JaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:20 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624089"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 07/12] [Blackfin] serial driver: add extra IRQ flag for 8250 serial driver
Date: Wed, 30 Jan 2008 17:30:07 +0800
Message-Id: <1201685412-29095-8-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/serial.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-blackfin/serial.h

diff --git a/include/asm-blackfin/serial.h b/include/asm-blackfin/serial.h
new file mode 100644
index 0000000..994dd86
--- /dev/null
+++ b/include/asm-blackfin/serial.h
@@ -0,0 +1,5 @@
+/*
+ * include/asm-blackfin/serial.h
+ */
+
+#define SERIAL_EXTRA_IRQ_FLAGS IRQF_TRIGGER_HIGH
-- 
1.5.3.4
