Return-Path: <linux-kernel-owner+w=401wt.eu-S1946570AbXBIPiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946570AbXBIPiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946575AbXBIPfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946579AbXBIPfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SMVkHuRyhkt4l9AA+yDF0BgfWV3zNA8FKTbM08eBXNJCbMGskS8slzISkTneeJQw94RERoAYlhyWhCPgCh50ddsRqOC+yrgLHn1A8D5PKeMvXg7weUbf3/VHbDEcOGPGgy3H1X6c2ZbiNVt+HlAm9+4nLuwnM68zTfH6UhfZDLI=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, linux-serial@vger.kernel.org
Subject: [PATCH 33/34] __initdata cleanup - serial
Date: Fri, 9 Feb 2007 17:35:10 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091735.10675.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/serial/8250_early.c linux-2.6.20-rc6-mm3/drivers/serial/8250_early.c
--- linux-2.6.20-rc6-mm3.org/drivers/serial/8250_early.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/drivers/serial/8250_early.c	2007-01-31 22:19:30.000000000 +0200
@@ -41,8 +41,8 @@ struct early_uart_device {
 	unsigned int baud;
 };
 
-static struct early_uart_device early_device __initdata;
-static int early_uart_registered __initdata;
+static struct early_uart_device early_device __initdata = {{{{0}}}};
+static int early_uart_registered __initdata = 0;
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
