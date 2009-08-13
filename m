Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZHMLGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZHMLGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZHMLGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:06:01 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3394 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbZHMLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:05:59 -0400
Subject: [PATCH] MAINTAINERS: Change ARM "subscriber-only" lists to
 "moderated for non-subscribers"
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>, Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <20090813103513.GC6132@n2100.arm.linux.org.uk>
References: <1249568614.10297.20.camel@Joe-Laptop.home>
	 <20090806150322.GX2080@trinity.fluff.org>
	 <1249948147.8895.96.camel@Joe-Laptop.home>
	 <20090812115520.GI24339@elf.ucw.cz>
	 <20090812194838.GB12117@n2100.arm.linux.org.uk>
	 <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com>
	 <20090812212502.GA24667@n2100.arm.linux.org.uk>
	 <20090813103511.2928a085@lxorguk.ukuu.org.uk>
	 <20090813094736.GZ6132@n2100.arm.linux.org.uk>
	 <1250158593.28285.23.camel@Joe-Laptop.home>
	 <20090813103513.GC6132@n2100.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 04:01:55 -0700
Message-Id: <1250161315.28285.57.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 11:35 +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 13, 2009 at 03:16:33AM -0700, Joe Perches wrote:
> > On Thu, 2009-08-13 at 10:47 +0100, Russell King - ARM Linux wrote:
> > > These lists have _TWO_ admins.  Fact: Everyone only talks to me
> > > about problems with these lists.  Fact: they do not copy Erik.
> > 
> > Erik isn't listed in MAINTAINERS.  You are.
> > Erik doesn't post much to lkml.  You do.
> 
> Is Matti, who also looks after vger, in MAINTAINERS ?

Note the original title and cc list to this thread.

> Given your position above, don't you think he should be, so that when
> people have a problem with LKML they can email him?

You should ask Dave how often he gets individual mail about
some vger problem.  I don't know nor care.

> > Humans tend to reuse and improve the tools that work best.
> > Your ARM based mail tool has caused some to do more work
> > than they would like, so they would like to use a better
> > tool.
> 
> So instead you'd like me to do more work by having to service peoples
> requests about how to subscribe and unsubscribe from a mailing list
> which I don't run?

Frankly, yes.  _I_ want to do less work.  You can do all the work
you like or you can be lazy.

> I invented a tool for that.  It's called "running my own mailing list."

There's pleasure in making your own tools.

Just don't expect others to not complain about the
burrs they get when they have to use the tools you
give them.

> > I believe very few care very much if vger.kernel.org or
> > arm.linux.org.uk is the list server.  I don't.  I just
> > want my email to get through.
> > 
> > And I still don't want to subscribe.
> 
> And... have your emails been held for moderation recently?

I don't care.  I don't read arm.linux.org.uk.

How about you apply this?

scripts/get_maintainer.pl by default will not output
"subscriber-only" list addresses.

cheers, Joe

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..dd8c14a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -497,7 +497,7 @@ F:	arch/arm/include/asm/floppy.h
 
 ARM PORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/
@@ -508,51 +508,51 @@ F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-ixp23xx/
 F:	arch/arm/mach-ixp23xx/include/mach/
 
 ARM/ADS SPHERE MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/AFEB9260 MACHINE SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/AJECO 1ARM MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
 M:	Andrew Victor <linux@maxim.org.za>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://maxim.org.za/at91_26.html
 S:	Maintained
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/CORGI MACHINE SUPPORT
@@ -561,14 +561,14 @@ S:	Maintained
 
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 T:	git git://gitorious.org/linux-gemini/mainline.git
 S:	Maintained
 F:	arch/arm/mach-gemini/
 
 ARM/EBSA110 MACHINE SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/mach-ebsa110/
@@ -586,13 +586,13 @@ F:	arch/arm/mach-pxa/ezx.c
 
 ARM/FARADAY FA526 PORT
 M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/include/asm/hardware/dec21285.h
@@ -600,17 +600,17 @@ F:	arch/arm/mach-footbridge/
 
 ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/GUMSTIX MACHINE SUPPORT
 M:	Steve Sakoman <sakoman@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/H4700 (HP IPAQ HX4700) MACHINE SUPPORT
@@ -630,55 +630,55 @@ F:	arch/arm/mach-sa1100/include/mach/jornada720.h
 ARM/INTEL IOP32X ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Supported
 
 ARM/INTEL IXP2000 ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL IXP23XX ARM ARCHITECTURE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 M:	Dan Williams <dan.j.williams@intel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Supported
 
 ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/LOGICPD PXA270 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/MAGICIAN MACHINE SUPPORT
@@ -687,7 +687,7 @@ S:	Maintained
 
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 F:	arch/arm/mach-pxa/mioa701.c
 S:	Maintained
 
@@ -728,18 +728,18 @@ S:	Maintained
 
 ARM/PT DIGITAL BOARD PORT
 M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/RISCPC ARCHITECTURE
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/common/time-acorn.c
@@ -758,7 +758,7 @@ S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-s3c/
@@ -766,65 +766,65 @@ F:	arch/arm/plat-s3c24xx/
 
 ARM/S3C2410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
 ARM/S3C2440 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
 
 ARM/S3C2442 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2442/
 
 ARM/S3C2443 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
 ARM/S3C6400 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6400/
 
 ARM/S3C6410 ARM ARCHITECTURE
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/THECUS N2100 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 
 ARM/NUVOTON W90X900 ARM ARCHITECTURE
 M:	Wan ZongShun <mcuos.com@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.mcuos.com
 S:	Maintained
 
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
@@ -923,7 +923,7 @@ F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
@@ -1501,7 +1501,7 @@ F:	drivers/infiniband/hw/cxgb3/
 
 CYBERPRO FB DRIVER
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
@@ -2046,7 +2046,7 @@ F:	drivers/i2c/busses/i2c-cpm.c
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-mxc/include/mach/imxfb.h
 F:	drivers/video/imxfb.c
@@ -3390,7 +3390,7 @@ F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 M:	Pavel Pisa <ppisa@pikron.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
@@ -4092,7 +4092,7 @@ F:	drivers/media/video/pvrusb2/
 PXA2xx/PXA3xx SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Russell King <linux@arm.linux.org.uk>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-pxa/
 F:	drivers/pcmcia/pxa2xx*
@@ -4105,13 +4105,13 @@ F:	sound/soc/pxa
 PXA168 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
 M:	Jason Chagas <jason.chagas@marvell.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
 PXA910 SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
@@ -4352,7 +4352,7 @@ F:	net/iucv/
 
 S3C24XX SD/MMC Driver
 M:	Ben Dooks <ben-linux@fluff.org>
-L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
@@ -4547,7 +4547,7 @@ F:	drivers/misc/sgi-xp/
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm-kernel@lists.arm.linux.org.uk (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
 F:	arch/arm/mach-lh7a40x/


