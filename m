Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXBEOeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXBEOeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXBEOeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:34:13 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:51403 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932926AbXBEOeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:34:11 -0500
Date: Mon, 5 Feb 2007 09:29:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] Missing include in include/asm-powerpc/prom.h
Message-ID: <20070205142905.GA31392@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 09:27:06 up 3 days,  4:35,  4 users,  load average: 1.16, 1.24, 1.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Missing include in include/asm-powerpc/prom.h

include/asm-powerpc/prom.h needs to include asm/irq.h because it uses
irq_of_parse_and_map and NO_IRQ. It applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/prom.h
+++ b/include/asm-powerpc/prom.h
@@ -19,6 +19,7 @@
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <asm/atomic.h>
+#include <asm/irq.h>
 
 /* Definitions used by the flattened device tree */
 #define OF_DT_HEADER		0xd00dfeed	/* marker */
-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
