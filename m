Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbXFZQw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbXFZQw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbXFZQws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:52:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60835 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbXFZQwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:52:47 -0400
Date: Tue, 26 Jun 2007 18:53:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       akpm@linux-foundation.org, Tony Lindgren <tony@atomide.com>,
       imre.deak@solidboot.com, juha.yrjola@solidboot.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] OMAP: Add TI OMAP1 internal LCD controller
Message-ID: <20070626165352.GC22389@uranus.ravnborg.org>
References: <5d5443650706260535haf0f9feq5e320059ee36c6cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650706260535haf0f9feq5e320059ee36c6cd@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index 5aa7175..2f35389 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -6,5 +6,7 @@ obj-$(CONFIG_FB_OMAP) += omapfb.o

 objs-yy := omapfb_main.o

+objs-y$(CONFIG_ARCH_OMAP1) += lcdc.o
+
 omapfb-objs := $(objs-yy)

So this explained your usage of -yy.
If you use the proposal from before then you could do
it like this:
omapfb-$(CONFIG_ARCH_OMAPI) += lcdc.o

	 Sam
