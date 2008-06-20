Return-Path: <linux-kernel-owner+w=401wt.eu-S1764724AbYFTUck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764724AbYFTUck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbYFTUV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35219 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761752AbYFTUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 45/70] io_ti: Minor coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:04:03 +0100
Message-ID: <20080620200401.1479.14796.stgit@localhost.localdomain>
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

 drivers/usb/serial/io_ti.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 808e285..c6a6444 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2402,7 +2402,7 @@ static void change_port_settings(struct tty_struct *tty,
 	return;
 }
 
-static void edge_set_termios(struct tty_struct *tty, 
+static void edge_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
@@ -2771,7 +2771,7 @@ static unsigned int edge_buf_data_avail(struct edge_buf *eb)
 {
 	if (eb == NULL)
 		return 0;
-	return ((eb->buf_size + eb->buf_put - eb->buf_get) % eb->buf_size);
+	return (eb->buf_size + eb->buf_put - eb->buf_get) % eb->buf_size;
 }
 
 
@@ -2786,7 +2786,7 @@ static unsigned int edge_buf_space_avail(struct edge_buf *eb)
 {
 	if (eb == NULL)
 		return 0;
-	return ((eb->buf_size + eb->buf_get - eb->buf_put - 1) % eb->buf_size);
+	return (eb->buf_size + eb->buf_get - eb->buf_put - 1) % eb->buf_size;
 }
 
 

