Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYJJKzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYJJKzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759549AbYJJKvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:51:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47613 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758298AbYJJKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:51:17 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 24/27] serial-make-uart_ports-ioport-unsigned-long-fix
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:51:13 +0100
Message-ID: <20081010105110.31597.61280.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/serial_core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index f977c98..308588e 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2154,12 +2154,11 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 
 	switch (port->iotype) {
 	case UPIO_PORT:
-		snprintf(address, sizeof(address),
-			 "I/O 0x%x", port->iobase);
+		snprintf(address, sizeof(address), "I/O 0x%lx", port->iobase);
 		break;
 	case UPIO_HUB6:
 		snprintf(address, sizeof(address),
-			 "I/O 0x%x offset 0x%x", port->iobase, port->hub6);
+			 "I/O 0x%lx offset 0x%x", port->iobase, port->hub6);
 		break;
 	case UPIO_MEM:
 	case UPIO_MEM32:

