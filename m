Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYHKPq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYHKPq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYHKPqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:46:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44299 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbYHKPqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:46:48 -0400
Date: Mon, 11 Aug 2008 10:46:46 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Max Krasnyansky <maxk@qualcomm.com>
Subject: [PATCH] x86: Remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU
Message-ID: <20080811154646.GB8181@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU on the x86 architecture.

One question, should we default to 'Y'?

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2008-07-30 14:45:16.000000000 -0500
+++ linux/arch/x86/Kconfig	2008-07-30 14:47:54.000000000 -0500
@@ -1365,11 +1365,11 @@ config PHYSICAL_ALIGN
 	  Don't change this unless you know what you are doing.
 
 config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	bool "Support for suspend on SMP and hot-pluggable CPUs"
+	depends on SMP && HOTPLUG && !X86_VOYAGER
 	---help---
-	  Say Y here to experiment with turning CPUs off and on, and to
-	  enable suspend on SMP systems. CPUs can be controlled through
+	  Say Y here to allow turning CPUs off and on, and to enable
+	  suspend on SMP systems. CPUs can be controlled through
 	  /sys/devices/system/cpu.
 	  Say N if you want to disable CPU hotplug and don't need to
 	  suspend.
