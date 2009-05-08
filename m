Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZEHEds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZEHEds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZEHEdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:33:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65521 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZEHEdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:33:31 -0400
Message-Id: <20090508043331.050670973@goodmis.org>
References: <20090508043250.372421144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 00:32:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] tracing: have menu default enabled when kernel debug is configured
Content-Disposition: inline; filename=0001-tracing-have-menu-default-enabled-when-kernel-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Tracing can be very helpful to debug the kernel. When DEBUG_KERNEL is
enabled it is nice to enable the trace menu as well.

This patch only make the tracing menu enabled by default, it does not
make any of the tracers enabled. And the menu is only enabled by
default if DEBUG_KERNEL is enabled.

[ Impact: show tracing options to those debugging the kernel ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 50f62a2..f61be30 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -79,6 +79,7 @@ if TRACING_SUPPORT
 
 menuconfig FTRACE
 	bool "Tracers"
+	default y if DEBUG_KERNEL
 	help
 	 Enable the kernel tracing infrastructure.
 
-- 
1.6.2.4

-- 
