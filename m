Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZISVmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZISVmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZISVmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:42:42 -0400
Received: from kroah.org ([198.145.64.141]:40506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbZISVml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:42:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/79] serial: kill off uif_t
Date: Sat, 19 Sep 2009 14:36:56 -0700
Message-Id: <1253396244-7885-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This typedef is now extinct

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/serial_core.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 284ef7f..f98dc78 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -337,18 +337,7 @@ struct uart_port {
 };
 
 /*
- * This is the state information which is only valid when the port
- * is open; it may be cleared the core driver once the device has
- * been closed.  Either the low level driver or the core can modify
- * stuff here.
- */
-typedef unsigned int __bitwise__ uif_t;
-
-
-/*
  * This is the state information which is persistent across opens.
- * The low level driver must not to touch any elements contained
- * within.
  */
 struct uart_state {
 	struct tty_port		port;
-- 
1.6.4.2

