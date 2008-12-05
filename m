Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbYLEKYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbYLEKYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYLEKVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:21:03 -0500
Received: from vps1.tull.net ([66.180.172.116]:47123 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754297AbYLEKVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:21:00 -0500
Mail-From: nobody Fri Dec  5 14:08:05 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in ftdi_sio.c
To: Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Roel Kluin <12o3l@tiscali.nl>, Sven Andersen <s.andersen@cryonet.de>,
       Vladimir Vukicevic <vladimir@pobox.com>, linux-usb@vger.kernel.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:05 +1100
Message-ID: <20081205030805.32183.11286.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in ftdi_sio.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/usb/serial/ftdi_sio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 51d7bde..aad1359 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1498,7 +1498,7 @@ static int ftdi_open(struct tty_struct *tty,
 			priv->interface, buf, 0, WDR_TIMEOUT);
 
 	/* Termios defaults are set by usb_serial_init. We don't change
-	   port->tty->termios - this would loose speed settings, etc.
+	   port->tty->termios - this would lose speed settings, etc.
 	   This is same behaviour as serial.c/rs_open() - Kuba */
 
 	/* ftdi_set_termios  will send usb control messages */


