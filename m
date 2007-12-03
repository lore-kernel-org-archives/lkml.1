Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXLCWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXLCWER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXLCWEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:04:05 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:46579 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXLCWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:04:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACkMVEdMROHU/2dsb2JhbACBWw
Date: Mon, 3 Dec 2007 17:03:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] AVR32 - Add HAVE_OPROFILE
Message-ID: <20071203220358.GB7149@Krystal>
References: <1196689618-17503-1-git-send-email-hskinnemoen@atmel.com> <1196689618-17503-2-git-send-email-hskinnemoen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1196689618-17503-2-git-send-email-hskinnemoen@atmel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:02:57 up 30 days,  3:08,  5 users,  load average: 0.85, 0.36,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be applied after the 
"Add HAVE_KPROBES" patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 arch/avr32/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/arch/avr32/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/avr32/Kconfig	2007-12-03 16:55:43.000000000 -0500
+++ linux-2.6-lttng/arch/avr32/Kconfig	2007-12-03 16:56:01.000000000 -0500
@@ -12,6 +12,7 @@ config AVR32
 	# that we usually don't need on AVR32.
 	select EMBEDDED
 	select HAVE_KPROBES
+	select HAVE_OPROFILE
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
