Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZBSNuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZBSNuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZBSNre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:49874 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbZBSNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XTsO/pBVg7jE/k4g2rrdJMQ2NN/O8lrHrb4VDt3NKYXs2IgXjOIYvV2ZZ3bQpmADFe
         0i9aTTnG8GfW/lW/eNrezcJgKwrT+4gLbG7Lnmp+vD1Cx6fH30msh7dT2zHs9WO7P4Dm
         E4QCU3zs8yXVrycUOKepJiNBVnwnaKxU12fk4=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa: allow reuse of serial driver for pxa168
Date: Thu, 19 Feb 2009 21:45:57 +0800
Message-Id: <1235051161-8858-9-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-8-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-6-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-7-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-8-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 7d7f576..9be11b0 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -628,7 +628,7 @@ config SERIAL_MPSC_CONSOLE
 
 config SERIAL_PXA
 	bool "PXA serial port support"
-	depends on ARM && ARCH_PXA
+	depends on ARCH_PXA || ARCH_MMP
 	select SERIAL_CORE
 	help
 	  If you have a machine based on an Intel XScale PXA2xx CPU you
-- 
1.6.0.4

