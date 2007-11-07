Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbXKGNj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbXKGNj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbXKGNjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:39:49 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:54320 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbXKGNjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:39:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEpOMUdMROHU/2dsb2JhbACBWw
Date: Wed, 7 Nov 2007 08:39:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] Move Kconfig.instrumentation to arch/Kconfig and
	init/Kconfig fix
Message-ID: <20071107133945.GA28283@Krystal>
References: <20071106203724.620893371@polymtl.ca> <20071106204152.754044476@polymtl.ca> <20071107140953.6b2cb1fa@dhcp-255-175.norway.atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071107140953.6b2cb1fa@dhcp-255-175.norway.atmel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:38:22 up 3 days, 18:43,  2 users,  load average: 3.13, 1.26,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig fix

Haavard Skinnemoen <hskinnemoen@atmel.com>:
> Index: linux-2.6-lttng/init/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/init/Kconfig 2007-11-02 13:16:41.000000000 -0400
> +++ linux-2.6-lttng/init/Kconfig      2007-11-02 13:16:55.000000000 -0400
> @@ -644,6 +644,20 @@ config SLOB

> +source "ltt/Kconfig"

This one seems to be new, and I can't seem to find ltt/Kconfig
anywhere. Wouldn't it be better to move it to a separate patch?


Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>:
Yes, it has nothing to do in this patch. I missed this one. This fix should be
folded with "Move Kconfig.instrumentation to arch/Kconfig and init/Kconfig".

Thanks!

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: akpm@linux-foundation.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 init/Kconfig |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-11-07 08:33:55.000000000 -0500
+++ linux-2.6-lttng/init/Kconfig	2007-11-07 08:34:13.000000000 -0500
@@ -656,8 +656,6 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
-source "ltt/Kconfig"
-
 source "arch/Kconfig"
 
 endmenu		# General setup
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
