Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXEBPrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXEBPrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXEBPrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:47:14 -0400
Received: from h155.mvista.com ([63.81.120.155]:4347 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755223AbXEBPrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:47:12 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: tglx@linuxtronux.de
Subject: [PATCH] clockchips.h: kernel-doc fix
Date: Wed, 2 May 2007 19:48:47 +0400
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021948.47563.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misnamed fields of 'struct clock_event_device' in the kernel-doc comment.
Convert the acronyms to uppercase, while at it...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---

 include/linux/clockchips.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/clockchips.h
===================================================================
--- linux-2.6.orig/include/linux/clockchips.h
+++ linux-2.6/include/linux/clockchips.h
@@ -54,17 +54,17 @@ enum clock_event_nofitiers {
 /**
  * struct clock_event_device - clock event device descriptor
  * @name:		ptr to clock event name
- * @hints:		usage hints
+ * @features:		features
  * @max_delta_ns:	maximum delta value in ns
  * @min_delta_ns:	minimum delta value in ns
  * @mult:		nanosecond to cycles multiplier
  * @shift:		nanoseconds to cycles divisor (power of two)
  * @rating:		variable to rate clock event devices
- * @irq:		irq number (only for non cpu local devices)
- * @cpumask:		cpumask to indicate for which cpus this device works
- * @set_next_event:	set next event
+ * @irq:		IRQ number (only for non CPU local devices)
+ * @cpumask:		cpumask to indicate for which CPUs this device works
+ * @set_next_event:	set next event function
  * @set_mode:		set mode function
- * @evthandler:		Assigned by the framework to be called by the low
+ * @event_handler:	Assigned by the framework to be called by the low
  *			level handler of the event source
  * @broadcast:		function to broadcast events
  * @list:		list head for the management code

