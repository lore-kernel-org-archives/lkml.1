Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZHJXx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZHJXx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZHJXxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:53:55 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3139 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZHJXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:53:55 -0400
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
 sections
From: Joe Perches <joe@perches.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Pavel Machek <pavel@ucw.cz>,
       Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <20090806150322.GX2080@trinity.fluff.org>
References: <20090804100051.GA17106@elf.ucw.cz>
	 <20090804223922.GD18365@flint.arm.linux.org.uk>
	 <20090806125751.7d0253ce@nij0285> <20090806113104.GK31370@elf.ucw.cz>
	 <20090806120826.GC27773@flint.arm.linux.org.uk>
	 <4A7ACC8D.7030706@xenontk.org>
	 <20090806124048.GD27773@flint.arm.linux.org.uk>
	 <1249563730.10297.13.camel@Joe-Laptop.home>
	 <20090806133349.GF27773@flint.arm.linux.org.uk>
	 <1249568614.10297.20.camel@Joe-Laptop.home>
	 <20090806150322.GX2080@trinity.fluff.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 16:49:07 -0700
Message-Id: <1249948147.8895.96.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend for Andrew Morton

On Thu, 2009-08-06 at 16:03 +0100, Ben Dooks wrote:
> On Thu, Aug 06, 2009 at 07:23:34AM -0700, Joe Perches wrote:
> > On Thu, 2009-08-06 at 14:33 +0100, Russell King wrote:
> > > On Thu, Aug 06, 2009 at 06:02:10AM -0700, Joe Perches wrote:
> > > > I suspect a vger based ARM list would not require you to "run" it.
> > > There is already a vger based ARM list.  I see no signs of people
> > > moving over to it.  I summise that is because most people don't
> > > have a problem, and most people are happy with the existing lists
> > > as they stand.  Could it be that it's only a minority who are
> > > having issues.  I don't know.
> > 
> > Perhaps there is too little exposure of the
> > linux-arm@vger.kernel.org mailing list.
> 
> I'm not subscribed, please do not add any of the samsung entries
> with linux-arm@vger.kernel.org list.

Perhaps this patch is more palatable.  It's certainly shorter.

It does add both linux-arm-kernel and linux-arm to section
SIMTEC EB2410ITX (BAST).  By the way, another section you
maintain, SIMTEC EB110ATX (Chalice CATS), has neither a
pattern entry nor a mailing list entry.  Should it?

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..04c13c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -498,9 +498,11 @@ F:	arch/arm/include/asm/floppy.h
 ARM PORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
+F:	drivers/*/arm/
 
 ARM PRIMECELL MMCI PL180/1 DRIVER
 S:	Orphan
@@ -2047,6 +2049,7 @@ FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
 F:	drivers/video/imxfb.c
@@ -2616,6 +2619,8 @@ F:	drivers/dma/iop-adma.c
 
 INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT
 M:	Krzysztof Halasa <khc@pm.waw.pl>
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-ixp4xx/include/mach/qmgr.h
 F:	arch/arm/mach-ixp4xx/include/mach/npe.h
@@ -4093,6 +4098,7 @@ PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
@@ -4548,6 +4554,7 @@ SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/
@@ -4570,6 +4577,8 @@ S:	Supported
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
 M:	Vincent Sanders <support@simtec.co.uk>
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/


