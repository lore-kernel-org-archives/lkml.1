Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXEAB7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXEAB7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXEAB7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:59:14 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:19088 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423385AbXEAB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D1J907Hrx8JF0j9RH5UOcv5AqjUrWX765oQJjhn3J6KwBP0dDozwZt4qaxkvZqqq+v8orLVQ2aEvoqdLHpbxyuTM8FV+AKLEWu5mTzaBX/91pv5GrY6nQhqDsnnVBhVnNnBbK4YL1AfVnxRPJ7/He8bqc+ex/2u+JQK+6x9xiUQ=
Message-ID: <625fc13d0704301859u2f2bed75v9347823d60ce0079@mail.gmail.com>
Date: Mon, 30 Apr 2007 20:59:07 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: akpm@linux-foundation.org
Subject: [PATCH] 8250: Remove commented out irq cruft
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some obviously old interrupt disable/enable code that has been
commented out.

Signed-off-by: Josh Boyer <jwboyer@gmail.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 90621c3..b37856a 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -913,7 +913,6 @@ static void autoconfig(struct uart_8250_port *up, unsigned i
         * be frobbing the chips IRQ enable register to see if it exists.
         */
        spin_lock_irqsave(&up->port.lock, flags);
-//     save_flags(flags); cli();

        up->capabilities = 0;
        up->bugs = 0;
@@ -1070,7 +1069,6 @@ static void autoconfig(struct uart_8250_port *up, unsigned

  out:
        spin_unlock_irqrestore(&up->port.lock, flags);
-//     restore_flags(flags);
        DEBUG_AUTOCONF("type=%s\n", uart_config[up->port.type].name);
 }
