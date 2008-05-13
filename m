Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYEMEO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYEMEO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbYEMEOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:14:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:30785 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYEMEOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:14:32 -0400
X-IronPort-AV: E=Sophos;i="4.27,477,1204520400"; 
   d="scan'208";a="53440092"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Cc: Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/2] [Blackfin] serial driver: add extra IRQ flag for 8250 serial driver
Date: Tue, 13 May 2008 12:14:29 +0800
Message-Id: <1210652069-16788-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210652069-16788-1-git-send-email-cooloney@kernel.org>
References: <1210652069-16788-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Javier Herrero <jherrero@hvsistemas.es>

Signed-off-by: Javier Herrero <jherrero@hvsistemas.es>
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
