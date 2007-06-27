Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbXF0UWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbXF0UWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXF0UWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:22:06 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2565 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbXF0UWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:22:05 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] balance parenthesis in serial core
Date: Wed, 27 Jun 2007 22:22:00 +0200
User-Agent: KMail/1.9.5
Cc: David Woodhouse <dwmw2@infradead.org>, mm-commits@vger.kernel.org
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
In-Reply-To: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272222.01300.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch balances the parenthesis imbalance in serial core.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc6-bo-a/drivers/serial/serial_core.c	2007-06-27 22:05:41.000000000 +0200
+++ linux-2.6.22-rc6-bo-b/drivers/serial/serial_core.c	2007-06-27 22:08:56.000000000 +0200
@@ -1158,9 +1158,9 @@ static void uart_set_termios(struct tty_
 	 * appropriately by set_termios() in tty_ioctl.c
 	 */
 #ifdef CIBAUD
-#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD))
 #else
-#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
+#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD))
 #endif
 #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
