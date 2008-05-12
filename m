Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589AbYELEaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbYELEaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYELEaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:30:00 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:34542 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYELE3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:29:24 -0400
X-IronPort-AV: E=Sophos;i="4.27,471,1204520400"; 
   d="scan'208";a="53384627"
From: Bryan Wu <cooloney@kernel.org>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Javier Herrero <jherrero@hvsistemas.es>,
       Bryan Wu <bryan.wu@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] [Blackfin] serial driver: add extra IRQ flag for 8250 serial driver
Date: Mon, 12 May 2008 12:29:25 +0800
Message-Id: <1210566565-6205-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210566565-6205-1-git-send-email-cooloney@kernel.org>
References: <1210566565-6205-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
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
1.5.5
