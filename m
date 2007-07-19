Return-Path: <linux-kernel-owner+w=401wt.eu-S940799AbXGSR1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940799AbXGSR1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765363AbXGSR1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:27:33 -0400
Received: from h146-az.mvista.com ([65.200.49.156]:65099 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S940095AbXGSR1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:27:32 -0400
Date: Thu, 19 Jul 2007 10:30:12 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH 3/4] serial: MPSC: Remove duplicate SUPPORT_SYSRQ definition
Message-ID: <20070719173012.GC589@mag.az.mvista.com>
References: <20070719172617.GA589@mag.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719172617.GA589@mag.az.mvista.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the duplicate definition of SUPPORT_SYSRQ in mpsc driver.

Signed-off-by: Mark A. Greer <mgreer@mvista.com>
---
 drivers/serial/mpsc.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 0d75505..1311433 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -74,10 +74,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#if defined(CONFIG_SERIAL_MPSC_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
-#define SUPPORT_SYSRQ
-#endif
-
 #define	MPSC_NUM_CTLRS		2
 
 /*
