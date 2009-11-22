Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZKVQZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZKVQZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbZKVQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:25:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61997 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbZKVQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:25:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nzs1iXj2fWBeCDVRTM3lD0qikxOo417kThTyWsLIOGH2lsYQ4yMADv3cb97hFUtQyy
         LQjjz6VpwZcgNdCapfvUY0KwoXvDLupAh92HLQv+umR18E+WnS8GeKtpSom07wg6KgXR
         7C4ofwG1oMd8zbZ+p5o9jFZeW+0K47SXvC3P4=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: ftdi_sio: remove obsolete comment
Date: Sun, 22 Nov 2009 17:25:08 +0100
Message-Id: <1258907108-11949-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We always push characters to ldisc immediately regardless of
ASYNC_LOW_LATENCY.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9c60d6d..73441a7 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1518,8 +1518,7 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 	kref_init(&priv->kref);
 	spin_lock_init(&priv->tx_lock);
 	init_waitqueue_head(&priv->delta_msr_wait);
-	/* This will push the characters through immediately rather
-	   than queue a task to deliver them */
+
 	priv->flags = ASYNC_LOW_LATENCY;
 
 	if (quirk && quirk->port_probe)
-- 
1.6.5.3

