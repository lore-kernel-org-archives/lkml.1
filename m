Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZIXTMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZIXTMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZIXTMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:12:16 -0400
Received: from mail.perches.com ([173.55.12.10]:1171 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZIXTMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:12:15 -0400
Subject: Re: [PATCH 00/11] MAINTAINERS cleanups
From: Joe Perches <joe@perches.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090924205902.48b217fc@infradead.org>
References: <cover.1253817463.git.joe@perches.com>
	 <20090924205902.48b217fc@infradead.org>
Content-Type: multipart/mixed; boundary="=-LEbCSFKJ+saUd32LOW66"
Date: Thu, 24 Sep 2009 12:12:18 -0700
Message-Id: <1253819538.1806.16.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LEbCSFKJ+saUd32LOW66
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On Thu, 2009-09-24 at 20:59 +0200, Arjan van de Ven wrote:
> On Thu, 24 Sep 2009 11:41:48 -0700
> Joe Perches <joe@perches.com> wrote:
> > Yet another collection of MAINTAINERS cleanups
> since all of this is to one file.. could you just make one big rollup
> patch?

Sure, but individual patches to MAINTAINERS are better.

MAINTAINERS changes pretty quickly and the larger the patch,
the more likely it won't apply correctly at any point in the
future.

Here's a rollup against MAINTAINERS right now.

---

A collection of cleanups to MAINTAINERS

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e797c4d..50cd5bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -963,7 +963,7 @@ F:	drivers/net/atlx/
 
 ATM
 M:	Chas Williams <chas@cmf.nrl.navy.mil>
-L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
+L:	linux-atm-general@lists.sourceforge.net (moderated for non-subscribers)
 L:	netdev@vger.kernel.org
 W:	http://linux-atm.sourceforge.net
 S:	Maintained
@@ -2115,7 +2115,7 @@ S:	Supported
 F:	arch/powerpc/sysdev/qe_lib/
 F:	arch/powerpc/include/asm/*qe.h
 
-FREESCALE USB PERIPHERIAL DRIVERS
+FREESCALE USB PERIPHERAL DRIVERS
 M:	Li Yang <leoli@freescale.com>
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
@@ -2166,18 +2166,6 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
-TRACING
-M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
-M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
-S:	Maintained
-F:	Documentation/trace/ftrace.txt
-F:	arch/*/*/*/ftrace.h
-F:	arch/*/kernel/ftrace.c
-F:	include/*/ftrace.h include/trace/ include/linux/trace*.h
-F:	kernel/trace/
-
 FUJITSU FR-V (FRV) PORT
 M:	David Howells <dhowells@redhat.com>
 S:	Maintained
@@ -2236,9 +2224,8 @@ S:	Maintained
 F:	include/asm-generic
 
 GENERIC UIO DRIVER FOR PCI DEVICES
-M:	Michael S. Tsirkin <mst@redhat.com>
+M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
@@ -2968,7 +2955,7 @@ F:	scripts/Makefile.*
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
-S:	Maintained
+S:	Odd Fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	"J. Bruce Fields" <bfields@fieldses.org>
@@ -3740,7 +3727,7 @@ F:	drivers/video/riva/
 F:	drivers/video/nvidia/
 
 OMAP SUPPORT
-M:	"Tony Lindgren <tony@atomide.com>" <tony@atomide.com>
+M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
@@ -4481,12 +4468,11 @@ F:	kernel/sched*
 F:	include/linux/sched.h
 
 SCORE ARCHITECTURE
-P:	Chen Liqin
-M:	liqin.chen@sunplusct.com
-P:	Lennox Wu
-M:	lennox.wu@gmail.com
+M:	Chen Liqin <liqin.chen@sunplusct.com>
+M:	Lennox Wu <lennox.wu@gmail.com>
 W:	http://www.sunplusct.com
 S:	Supported
+F:	arch/score/
 
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
@@ -4559,20 +4545,20 @@ S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-S:     Orphan
-L:     linux-mmc@vger.kernel.org
-F:     drivers/mmc/host/sdhci.*
+S:	Orphan
+L:	linux-mmc@vger.kernel.org
+F:	drivers/mmc/host/sdhci.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
 M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@ozlabs.org
-L:     linux-mmc@vger.kernel.org
+L:	linux-mmc@vger.kernel.org
 S:	Maintained
-F:     drivers/mmc/host/sdhci-of.*
+F:	drivers/mmc/host/sdhci-of.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
-L:     linux-mmc@vger.kernel.org
+L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
@@ -4667,8 +4653,7 @@ F:	drivers/usb/gadget/lh7a40*
 F:	drivers/usb/host/ohci-lh7a40*
 
 SIMPLE FIRMWARE INTERFACE (SFI)
-P:	Len Brown
-M:	lenb@kernel.org
+M:	Len Brown <lenb@kernel.org>
 L:	sfi-devel@simplefirmware.org
 W:	http://simplefirmware.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
@@ -5116,6 +5101,20 @@ L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
 
+TRACING
+M:	Steven Rostedt <rostedt@goodmis.org>
+M:	Frederic Weisbecker <fweisbec@gmail.com>
+M:	Ingo Molnar <mingo@redhat.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
+S:	Maintained
+F:	Documentation/trace/ftrace.txt
+F:	arch/*/*/*/ftrace.h
+F:	arch/*/kernel/ftrace.c
+F:	include/*/ftrace.h
+F:	include/linux/trace*.h
+F:	include/trace/
+F:	kernel/trace/
+
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
@@ -5675,8 +5674,7 @@ S:	Maintained
 F:	drivers/scsi/wd7000.c
 
 WINBOND CIR DRIVER
-P:	David Hrdeman
-M:	david@hardeman.nu
+M:	David Härdeman <david@hardeman.nu>
 S:	Maintained
 F:	drivers/input/misc/winbond-cir.c
 
@@ -5733,9 +5731,7 @@ F:	drivers/input/touchscreen/*wm97*
 F:	include/linux/wm97xx.h
 
 WOLFSON MICROELECTRONICS PMIC DRIVERS
-P:	Mark Brown
-M:	broonie@opensource.wolfsonmicro.com
-L:	linux-kernel@vger.kernel.org
+M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/node/8
 S:	Supported


--=-LEbCSFKJ+saUd32LOW66
Content-Disposition: attachment; filename="m.d"
Content-Type: text/x-dsrc; name="m.d"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

diff --git a/MAINTAINERS b/MAINTAINERS
index e797c4d..50cd5bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -963,7 +963,7 @@ F:	drivers/net/atlx/
 
 ATM
 M:	Chas Williams <chas@cmf.nrl.navy.mil>
-L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
+L:	linux-atm-general@lists.sourceforge.net (moderated for non-subscribers)
 L:	netdev@vger.kernel.org
 W:	http://linux-atm.sourceforge.net
 S:	Maintained
@@ -2115,7 +2115,7 @@ S:	Supported
 F:	arch/powerpc/sysdev/qe_lib/
 F:	arch/powerpc/include/asm/*qe.h
 
-FREESCALE USB PERIPHERIAL DRIVERS
+FREESCALE USB PERIPHERAL DRIVERS
 M:	Li Yang <leoli@freescale.com>
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
@@ -2166,18 +2166,6 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
-TRACING
-M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
-M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
-S:	Maintained
-F:	Documentation/trace/ftrace.txt
-F:	arch/*/*/*/ftrace.h
-F:	arch/*/kernel/ftrace.c
-F:	include/*/ftrace.h include/trace/ include/linux/trace*.h
-F:	kernel/trace/
-
 FUJITSU FR-V (FRV) PORT
 M:	David Howells <dhowells@redhat.com>
 S:	Maintained
@@ -2236,9 +2224,8 @@ S:	Maintained
 F:	include/asm-generic
 
 GENERIC UIO DRIVER FOR PCI DEVICES
-M:	Michael S. Tsirkin <mst@redhat.com>
+M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
-L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/uio/uio_pci_generic.c
 
@@ -2968,7 +2955,7 @@ F:	scripts/Makefile.*
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
-S:	Maintained
+S:	Odd Fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	"J. Bruce Fields" <bfields@fieldses.org>
@@ -3740,7 +3727,7 @@ F:	drivers/video/riva/
 F:	drivers/video/nvidia/
 
 OMAP SUPPORT
-M:	"Tony Lindgren <tony@atomide.com>" <tony@atomide.com>
+M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
@@ -4481,12 +4468,11 @@ F:	kernel/sched*
 F:	include/linux/sched.h
 
 SCORE ARCHITECTURE
-P:	Chen Liqin
-M:	liqin.chen@sunplusct.com
-P:	Lennox Wu
-M:	lennox.wu@gmail.com
+M:	Chen Liqin <liqin.chen@sunplusct.com>
+M:	Lennox Wu <lennox.wu@gmail.com>
 W:	http://www.sunplusct.com
 S:	Supported
+F:	arch/score/
 
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
@@ -4559,20 +4545,20 @@ S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-S:     Orphan
-L:     linux-mmc@vger.kernel.org
-F:     drivers/mmc/host/sdhci.*
+S:	Orphan
+L:	linux-mmc@vger.kernel.org
+F:	drivers/mmc/host/sdhci.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
 M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@ozlabs.org
-L:     linux-mmc@vger.kernel.org
+L:	linux-mmc@vger.kernel.org
 S:	Maintained
-F:     drivers/mmc/host/sdhci-of.*
+F:	drivers/mmc/host/sdhci-of.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
-L:     linux-mmc@vger.kernel.org
+L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
@@ -4667,8 +4653,7 @@ F:	drivers/usb/gadget/lh7a40*
 F:	drivers/usb/host/ohci-lh7a40*
 
 SIMPLE FIRMWARE INTERFACE (SFI)
-P:	Len Brown
-M:	lenb@kernel.org
+M:	Len Brown <lenb@kernel.org>
 L:	sfi-devel@simplefirmware.org
 W:	http://simplefirmware.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
@@ -5116,6 +5101,20 @@ L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
 
+TRACING
+M:	Steven Rostedt <rostedt@goodmis.org>
+M:	Frederic Weisbecker <fweisbec@gmail.com>
+M:	Ingo Molnar <mingo@redhat.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
+S:	Maintained
+F:	Documentation/trace/ftrace.txt
+F:	arch/*/*/*/ftrace.h
+F:	arch/*/kernel/ftrace.c
+F:	include/*/ftrace.h
+F:	include/linux/trace*.h
+F:	include/trace/
+F:	kernel/trace/
+
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
@@ -5675,8 +5674,7 @@ S:	Maintained
 F:	drivers/scsi/wd7000.c
 
 WINBOND CIR DRIVER
-P:	David H�rdeman
-M:	david@hardeman.nu
+M:	David Härdeman <david@hardeman.nu>
 S:	Maintained
 F:	drivers/input/misc/winbond-cir.c
 
@@ -5733,9 +5731,7 @@ F:	drivers/input/touchscreen/*wm97*
 F:	include/linux/wm97xx.h
 
 WOLFSON MICROELECTRONICS PMIC DRIVERS
-P:	Mark Brown
-M:	broonie@opensource.wolfsonmicro.com
-L:	linux-kernel@vger.kernel.org
+M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
 W:	http://opensource.wolfsonmicro.com/node/8
 S:	Supported

--=-LEbCSFKJ+saUd32LOW66--

