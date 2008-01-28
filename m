Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbYA1O4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbYA1O4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYA1O4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:56:38 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:43411 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbYA1O4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:56:37 -0500
Date: Mon, 28 Jan 2008 15:56:27 +0100
From: Linus Nilsson <lajnold@acc.umu.se>
To: jgarzik@pobox.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       trivial@kernel.org
Subject: [PATCH] libata: Change "write_data" to "rw" for some function
	documentations
Message-ID: <20080128145627.GA24317@montezuma.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Nilsson <lajnold@acc.umu.se>

The documentation for ata_data_xfer and ata_data_xfer_noirq had the 'rw'
parameter named 'write_data'.

Signed-off-by: Linus Nilsson <lajnold@acc.umu.se>
---
 drivers/ata/libata-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c	2008-01-28 15:47:26.000000000 +0100
+++ b/drivers/ata/libata-core.c	2008-01-28 15:47:27.000000000 +0100
@@ -4924,7 +4924,7 @@
  *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
- *	@write_data: read/write
+ *	@rw: read/write
  *
  *	Transfer data from/to the device data register by PIO.
  *
@@ -4970,7 +4970,7 @@
  *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
- *	@write_data: read/write
+ *	@rw: read/write
  *
  *	Transfer data from/to the device data register by PIO. Do the
  *	transfer with interrupts disabled.
