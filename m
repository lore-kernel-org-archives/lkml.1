Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXEaKMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXEaKMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXEaKMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:12:07 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3746 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbXEaKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:12:05 -0400
Date: Thu, 31 May 2007 11:12:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial_core.h: Include <linux/sysrq.h>
Message-ID: <Pine.LNX.4.64N.0705311106160.7856@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 The <linux/serial_core.h> header refers to handle_sysrq(), but does not 
include <linux/sysrq.h> which provides a declaration of the function.  
This may result in an implicit declaration and a warning if the actual one 
is seen later on.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---

 Please apply.

  Maciej

patch-2.6.22-rc2-serial-sysrq-2
diff -up --recursive --new-file linux-2.6.22-rc2.macro/include/linux/serial_core.h linux-2.6.22-rc2/include/linux/serial_core.h
--- linux-2.6.22-rc2.macro/include/linux/serial_core.h	2007-05-27 15:12:02.000000000 +0000
+++ linux-2.6.22-rc2/include/linux/serial_core.h	2007-05-30 20:33:10.000000000 +0000
@@ -152,6 +152,7 @@
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/sysrq.h>
 
 struct uart_port;
 struct uart_info;
