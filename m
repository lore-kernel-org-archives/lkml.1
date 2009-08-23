Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbZHWXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbZHWXIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 19:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZHWXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 19:08:19 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:39387 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZHWXIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 19:08:18 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2009 19:08:18 EDT
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-usb@vger.kernel.org
Cc: gustavo@padovan.org, smurf@smurf.noris.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] usb: remove unused variable
Date: Sun, 23 Aug 2009 19:55:50 -0300
Message-Id: <1251068150-15001-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct usb_serial *serial is not used.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 drivers/usb/serial/option.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 98262dd..77b9563 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -831,7 +831,6 @@ static void option_instat_callback(struct urb *urb)
 	int status = urb->status;
 	struct usb_serial_port *port =  urb->context;
 	struct option_port_private *portdata = usb_get_serial_port_data(port);
-	struct usb_serial *serial = port->serial;
 
 	dbg("%s", __func__);
 	dbg("%s: urb %p port %p has data %p", __func__, urb, port, portdata);
@@ -927,7 +926,6 @@ static int option_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	struct option_port_private *portdata;
-	struct usb_serial *serial = port->serial;
 	int i, err;
 	struct urb *urb;
 
-- 
1.6.3.3

