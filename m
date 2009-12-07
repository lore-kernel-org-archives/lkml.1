Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbZLGARU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbZLGARU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbZLGAQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:16:37 -0500
Received: from kroah.org ([198.145.64.141]:34732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934374AbZLGAOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:00 2009
Message-Id: <20091207000700.065141484@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>
Subject: [111/119] tty/of_serial: add missing ns16550a id
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=tty-of_serial-add-missing-ns16550a-id.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Simek <monstr@monstr.eu>

commit 16173c7c2d79da7eb89b41acfdebd74b130f4339 upstream.

Many boards have a bug-free ns16550 compatible serial port, which we should
register as PORT_16550A. This introduces a new value "ns16550a" for the
compatible property of of_serial to let a firmware choose that model instead
of using the crippled PORT_16550 mode.

Reported-by: Alon Ziv <alonz@nolaviz.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/of_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/serial/of_serial.c
+++ b/drivers/serial/of_serial.c
@@ -161,6 +161,7 @@ static int of_platform_serial_remove(str
 static struct of_device_id __devinitdata of_platform_serial_table[] = {
 	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
 	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
+	{ .type = "serial", .compatible = "ns16550a", .data = (void *)PORT_16550A, },
 	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
 	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .type = "serial", .compatible = "ns16850",  .data = (void *)PORT_16850, },


