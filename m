Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXAWMZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXAWMZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbXAWMZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:25:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60923 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbXAWMZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:25:09 -0500
To: torvalds@osdl.org
Subject: [PATCH] funsoft: ktermois fix
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1H9Ki4-0006p9-Ff@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 23 Jan 2007 12:25:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/serial/funsoft.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/funsoft.c b/drivers/usb/serial/funsoft.c
index 31501c9..2bebd63 100644
--- a/drivers/usb/serial/funsoft.c
+++ b/drivers/usb/serial/funsoft.c
@@ -27,7 +27,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static int funsoft_ioctl(struct usb_serial_port *port, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
-	struct termios t;
+	struct ktermios t;
 
 	dbg("%s - port %d, cmd 0x%04x", __FUNCTION__, port->number, cmd);
 
-- 
1.4.2.GIT

