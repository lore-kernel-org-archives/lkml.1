Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbXFZQtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbXFZQtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbXFZQtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:49:00 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49040 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbXFZQtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:49:00 -0400
Date: Tue, 26 Jun 2007 18:50:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       akpm@linux-foundation.org, Tony Lindgren <tony@atomide.com>,
       imre.deak@solidboot.com, juha.yrjola@solidboot.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] OMAP: Add TI OMAP framebuffer driver
Message-ID: <20070626165003.GA22389@uranus.ravnborg.org>
References: <5d5443650706260533r218c05b1u5d4336015c4a4a9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650706260533r218c05b1u5d4336015c4a4a9b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
new file mode 100644
index 0000000..5aa7175
--- /dev/null
+++ b/drivers/video/omap/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the new OMAP framebuffer device driver
+#
+
+obj-$(CONFIG_FB_OMAP) += omapfb.o
+
+objs-yy := omapfb_main.o
+
+omapfb-objs := $(objs-yy)
+

This looks strangs.
Please use:
obj-$(CONFIG_FB_OMAP) += omapfb.o

omapfb-y := omapfb_main.o

Or even better rename your .c file to omapfb.c then
you only need to use:
obj-$(CONFIG_FB_OMAP) += omapfb.o

	Sam
