Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZHFOiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZHFOiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZHFOiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:38:03 -0400
Received: from india.einfochips.com ([203.88.139.151]:2168 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753478AbZHFOiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:38:01 -0400
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dhaval.vasa@einfochips.com
Subject: [PATCH] USB: ftdi_sio: add product_id for Marvell OpenRD Base, Client
Date: Thu,  6 Aug 2009 20:09:26 +0530
Message-Id: <1249569566-824-1-git-send-email-dhaval.vasa@einfochips.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reference:
http://www.open-rd.org

Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
---
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 24dbd99..4285b14 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -954,6 +954,13 @@
 #define AURICAL_USB_PID		0x0010	/* Aurical USB Audiometer */
 
 /*
+ * Marvell OpenRD Base, Client
+ * http://www.open-rd.org
+ * OpenRD Base, Client use VID 0x0403
+ */
+#define MARVELL_OPENRD_PID	0x9e90
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
-- 
1.6.0.6

-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
