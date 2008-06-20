Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYFTUeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYFTUeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762043AbYFTUV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35227 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762032AbYFTUV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 49/70] tty-usb-iuu-phoenix: Clean up to coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:33 +0100
Message-ID: <20080620200430.1479.89171.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/iuu_phoenix.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)


diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index d654148..ddff37f 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -318,11 +318,10 @@ static int bulk_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 					 port->bulk_out_endpointAddress), buf,
 			 count, &actual, HZ * 1);
 
-	if (status != IUU_OPERATION_OK) {
+	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
-	} else {
+	else
 		dbg("%s - write OK !", __func__);
-	}
 	return status;
 }
 
@@ -342,12 +341,10 @@ static int read_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 					 port->bulk_in_endpointAddress), buf,
 			 count, &actual, HZ * 1);
 
-	if (status != IUU_OPERATION_OK) {
+	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
-	} else {
+	else
 		dbg("%s - read OK !", __func__);
-	}
-
 	return status;
 }
 
@@ -770,14 +767,14 @@ static int iuu_uart_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (priv->writelen > 0) {
 		/* buffer already filled but not commited */
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return (0);
+		return 0;
 	}
 	/* fill the buffer */
 	memcpy(priv->writebuf, buf, count);
 	priv->writelen = count;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return (count);
+	return count;
 }
 
 static void read_rxcmd_callback(struct urb *urb)

