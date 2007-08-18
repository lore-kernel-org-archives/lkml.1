Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXHRHJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXHRHJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 03:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXHRHJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 03:09:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4615 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXHRHJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 03:09:07 -0400
Subject: [PATCH 2/2] MAINTAINERS
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Date: Sat, 18 Aug 2007 00:08:54 -0700
Message-Id: <1187420935.4200.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added patterns to describe files maintained.

Signed-off-by: Joe Perches <joe@perches.com>

Bits and pieces Signed-off-by: and Acked-by: (probably missed a few)

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Nathan Laredo <laredo@gnu.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mike Isely <isely@pobox.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: GOTO Masanori <gotom@sanori.org>
Acked-by: Linas Vepstas <linas@austin.ibm.com>
Acked-by: Ron Mercer <ron.mercer@qlogic.com>
Acked-by: Mattia Dongili <malattia@linux.it>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Len Brown <len.brown@intel.com>
Acked-by: Josh Triplett <josh@freedesktop.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Chris Snook <csnook@redhat.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Acked-by: Dave Dillow <dave@thedillows.org>
Acked-by: Kent Yoder <shpedoikal@gmail.com>
Acked-by: Auke Kok <auke-jan.h.kok@intel.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Salyzyn, Mark <mark_salyzyn@adaptec.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Acked-by: Dave Kleikamp <shaggy@vnet.linux.ibm.com
Acked-by: Petko Manolov <petkan@nucleusys.com>
Acked-By: Thomas Sailer <t.sailer@alumni.ethz.ch>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
Acked-by: Mitchell Blank Jr <mitch@sfgoth.com>


diff --git a/MAINTAINERS b/MAINTAINERS
index d3a0684..d7fe1c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19,40 +19,44 @@ trivial patch so apply some common sense.
 3.	Make sure your changes compile correctly in multiple
 	configurations. In particular check that changes work both as a
 	module and built into the kernel.
 
 4.	When you are happy with a change make it generally available for
 	testing and await feedback.
 
 5.	Make a patch available to the relevant maintainer in the list. Use
 	'diff -u' to make the patch easy to merge. Be prepared to get your
 	changes sent back with seemingly silly requests about formatting
 	and variable names.  These aren't as silly as they seem. One
 	job the maintainers (and especially Linus) do is to keep things
 	looking the same. Sometimes this means that the clever hack in
 	your driver to get around a problem actually needs to become a
 	generalized kernel feature ready for next time.
 
 	PLEASE check your patch with the automated style checker
 	(scripts/checkpatch.pl) to catch trival style violations.
 	See Documentation/CodingStyle for guidance here.
 
+	PLEASE include the appropriate maintainers and developers
+	that have modified files touched by your patch by using the
+	automated CC generator (scripts/get_maintainer.pl)
+
 	PLEASE try to include any credit lines you want added with the
 	patch. It avoids people being missed off by mistake and makes
 	it easier to know who wants adding and who doesn't.
 
 	PLEASE document known bugs. If it doesn't work for everything
 	or does something very odd once a month document it.
 
 	PLEASE remember that submissions must be made under the terms
 	of the OSDL certificate of contribution
 	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
 	and should include a Signed-off-by: line.
 
 6.	Make sure you have the right to send any changes you make. If you
 	do changes at work you may find your employer owns the patch
 	not you.
 
 7.	When sending security related changes or reports to a maintainer
 	please Cc: security@kernel.org, especially if the maintainer
 	does not respond.
 
@@ -66,513 +70,644 @@ Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
 P: Person
 M: Mail patches to
 L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt.
 S: Status, one of the following:
 
 	Supported:	Someone is actually paid to look after this.
 	Maintained:	Someone actually looks after it.
 	Odd Fixes:	It has a maintainer but they don't have time to do
 			much other than throw the odd patch in. See below..
 	Orphan:		No current maintainer [but maybe you could take the
 			role as you write your new code].
 	Obsolete:	Old code. Something tagged obsolete generally means
 			it has been replaced by a better system and you
 			should be using that.
 
+F: Files and directories with wildcard patterns.
+   A trailing slash includes all files and subdirectory files.
+	F:	drivers/net/	all files in and below drivers/net
+	F:	drivers/net/*	all files in drivers/net, but not below
+	F:	*/net/*		all files in "any top level directory"/net
+   One pattern per line.  Multiple F: lines acceptable.
+
+X: Files and directories that are NOT maintained, same rules as F:
+   Files exclusions are tested before file matches.
+   Can be useful for excluding a specific subdirectory, for instance:
+        F:     /net/
+	X:     /net/ipv6/
+   matches all files in net excluding /net/ipv6/
+
 3C359 NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
+F:	drivers/net/tokenring/3c359*
 
 3C505 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/3c505*
+
+3C59X NETWORK DRIVER
+P:	Steffen Klassert
+M:	klassert@mathematik.tu-chemnitz.de
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/vortex.txt
+F:	drivers/net/3c59x.c
 
 3CR990 NETWORK DRIVER
 P:	David Dillow
 M:	dave@thedillows.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/typhoon*
 
 3W-XXXX ATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
 M:	linuxraid@amcc.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
+F:	drivers/scsi/3w-xxxx*
 
 3W-9XXX SATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
 M:	linuxraid@amcc.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
+F:	drivers/scsi/3w-9xxx*
 
 53C700 AND 53C700-66 SCSI DRIVER
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/53c700*
 
 6PACK NETWORK DRIVER FOR AX.25
 P:	Andreas Koensgen
 M:	ajk@iehk.rwth-aachen.de
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	drivers/net/hamradio/6pack.c
 
 8139CP 10/100 FAST ETHERNET DRIVER
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 S:	Maintained
+F:	drivers/net/8139cp.c
 
 8139TOO 10/100 FAST ETHERNET DRIVER
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 W:	http://sourceforge.net/projects/gkernel/
 S:	Maintained
+F:	drivers/net/8139too.c
 
 8169 10/100/1000 GIGABIT ETHERNET DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Orphan
 
 8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULTRA, NE2000, 3C503, etc.]
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/*8390*
+F:	drivers/net/ax88796.c
 
 9P FILE SYSTEM
 P:	Eric Van Hensbergen
 M:	ericvh@gmail.com
 P:	Ron Minnich
 M:	rminnich@lanl.gov
 P:	Latchesar Ionkov
 M:	lucho@ionkov.net
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://v9fs.sf.net
 T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
 S:	Maintained
+F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
 P:	Enver Haase
-M:	ehaase@inf.fu-berlin.de
 M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
+F:	drivers/char/ser_a2232*
 
 AIO
 P:	Benjamin LaHaise
 M:	bcrl@kvack.org
 L:	linux-aio@kvack.org
 S:	Supported
+F:	fs/aio.c
+F:	include/linux/*aio*.h
 
 ABIT UGURU HARDWARE MONITOR DRIVER
 P:	Hans de Goede
 M:	j.w.r.degoede@hhs.nl
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/abitguru*
 
 ACENIC DRIVER
 P:	Jes Sorensen
 M:	jes@trained-monkey.org
 L:	linux-acenic@sunsite.dk
 S:	Maintained
+F:	drivers/net/acenic*
 
 IPS SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
 M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
+F:	drivers/scsi/ips*
 
 DPT_I2O SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
 M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
+F:	drivers/scsi/dpt*
+F:	drivers/scsi/dpt/
 
 AACRAID SCSI RAID DRIVER
 P:	Adaptec OEM Raid Solutions
 M:	aacraid@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Supported
+F:	Documentation/scsi/aacraid.txt
+F:	drivers/scsi/aacraid/
 
 ACPI
 P:	Len Brown
 M:	len.brown@intel.com
 M:	lenb@kernel.org
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
+F:	drivers/acpi/
+F:	drivers/pnp/pnpacpi/
 
 ACPI BATTERY DRIVERS
 P:	Alexey Starikovskiy
 M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 S:	Supported
+F:	drivers/acpi/battery.c
+F:	drivers/acpi/*sbs*
 
 ACPI EC DRIVER
 P:	Alexey Starikovskiy
 M:	astarikovskiy@suse.de
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 S:	Supported
+F:	drivers/acpi/ec.c
 
 ACPI FAN DRIVER
-P:	Konstantin A. Karasyov
-M:	konstantin.a.karasyov@intel.com
+P:	Len Brown
+M:	len.brown@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 S:	Supported
+F:	drivers/acpi/fan.c
 
 ACPI PCI HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/acip*
 
 ACPI THERMAL DRIVER
-P:	Konstantin A. Karasyov
-M:	konstantin.a.karasyov@intel.com
+P:	Len Brown
+M:	len.brown@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 S:	Supported
+F:	drivers/acpi/*thermal*
 
 ACPI VIDEO DRIVER
-P:	Luming Yu
-M:	luming.yu@intel.com
+P:	Rui Zhang
+M:	rui.zhang@intel.com
 L:	linux-acpi@vger.kernel.org
 W:	http://acpi.sourceforge.net/
 S:	Supported
+F:	drivers/acpi/video.c
 
 ADM1025 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/adm1025
+F:	drivers/hwmon/adm1025.c
 
 ADM1029 HARDWARE MONITOR DRIVER
 P:	Corentin Labbe
 M:	corentin.labbe@geomatys.fr
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/adm1029.c
 
 ADT746X FAN DRIVER
 P:	Colin Leroy
 M:	colin@colino.net
 S:	Maintained
+F:	drivers/macintosh/therm_adt746x.c
 
 AEDSP16 DRIVER
 P:	Riccardo Facchetti
 M:	fizban@tin.it
 S:	Maintained
+F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 S:	Maintained
+F:	fs/affs/
 
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
+F:	drivers/char/agp/
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
-M:	Juergen Fischer <fischer@norbit.de>
+M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/aha152x*
+F:	drivers/scsi/pcmcia/aha152x*
 
 ALCATEL SPEEDTOUCH USB DRIVER
 P:	Duncan Sands
 M:	duncan.sands@free.fr
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.linux-usb.org/SpeedTouch/
 S:	Maintained
+F:	drivers/usb/atm/speedtch.c
+F:	drivers/usb/atm/usbatm.c
 
 ALCHEMY AU1XX0 MMC DRIVER
 S:	Orphan
 
 ALI1563 I2C DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-ali1563
+F:	drivers/i2c/busses/i2c-ali1563.c
 
 ALPHA PORT
 P:	Richard Henderson
 M:	rth@twiddle.net
 S:	Odd Fixes for 2.4; Maintained for 2.6.
 P:	Ivan Kokshaysky
 M:	ink@jurassic.park.msu.ru
 S:	Maintained for 2.4; PCI support for 2.6.
+F:	arch/alpha/
 
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
 L:	info-linux@geode.amd.com
 S:	Supported
+F:	drivers/usb/gadget/amd5536udc.*
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
 M:	info-linux@geode.amd.com
 L:	info-linux@geode.amd.com
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
+F:	arch/i386/kernel/geode.c
+F:	drivers/char/hw-random/geode*
+F:	drivers/crypto/geode*
+F:	drivers/video/geode/
+F:	include/asm-i386/geode.h
 
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
 P:	Michael Hanselmann
 M:	linux-kernel@hansmi.ch
 S:	Supported
+F:	drivers/hwmon/ams/
 
 AMSO1100 RNIC DRIVER
 P:	Tom Tucker
 M:	tom@opengridcomputing.com
 P:	Steve Wise
 M:	swise@opengridcomputing.com
 L:	general@lists.openfabrics.org
 S:	Maintained
+F:	drivers/infiniband/hw/amso1100/
 
 AOA (Apple Onboard Audio) ALSA DRIVER
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linuxppc-dev@ozlabs.org
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Maintained
+F:	sound/aoa/
 
 APM DRIVER
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
 L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
+F:	arch/i386/kernel/apm.c
+F:	include/linux/apm_bios.h
 
 APPLE SMC DRIVER
 P:	Nicolas Boichat
 M:	nicolas@boichat.ch
 L:	mactel-linux-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/hwmon/applesmc.c
 
 APPLETALK NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
+F:	drivers/net/appletalk/
+F:	net/appletalk/
 
 ARC FRAMEBUFFER DRIVER
 P:	Jaya Kumar
 M:	jayalk@intworks.biz
 S:	Maintained
+F:	drivers/video/arcfb.c
+F:	drivers/video/fb_defio.c
 
 ARM MFM AND FLOPPY DRIVERS
 P:	Ian Molton
 M:	spyro@f2s.com
 S:	Maintained
+F:	arch/arm/lib/floppydma.S
+F:	drivers/asm-arm/floppy.h
 
 ARM PRIMECELL MMCI PL180/1 DRIVER
 P:	Russell King
 M:	rmk@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp23xx/
+F:	include/asm-arm/arch-ixp23xx/
 
 ARM/ADS SPHERE MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/adssphere.c
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/AJECO 1ARM MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-at91/board-1arm.c
+F:	include/asm-arm/arch-at91/
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
-P:      Andrew Victor
-M:      andrew@sanpeople.com
-L:      linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
-W:      http://maxim.org.za/at91_26.html
-S:      Maintained
+P:	Andrew Victor
+M:	andrew@sanpeople.com
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+W:	http://maxim.org.za/at91_26.html
+S:	Maintained
+F:	arch/arm/mach-at91/
+F:	include/asm-arm/arch-at91/
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/edb9315a.c
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/CORGI MACHINE SUPPORT
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
+F:	arch/arm/mach-pxa/
+F:	include/asm-arm/arch-pxa/
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ep93xx/gesbc9312.c
+F:	include/asm-arm/arch-ep93xx/
 
 ARM/HP JORNADA 7XX MACHINE SUPPORT
-P:      Kristoffer Ericson
-M:      kristoffer.ericson@gmail.com
-W:      www.jlime.com
-S:      Maintained
+P:	Kristoffer Ericson
+M:	kristoffer.ericson@gmail.com
+W:	www.jlime.com
+S:	Maintained
+F:	arch/arm/mach-sa1100/jornada*
+F:	include/asm-arm/arch-sa1100/
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
+F:	arch/arm/plat-iop/
+F:	arch/arm/mach-iop32x/
+F:	include/asm-arm/hardware/iop*
+F:	include/asm-arm/plat-iop/
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
+F:	arch/arm/plat-iop/
+F:	arch/arm/mach-iop33x/
+F:	include/asm-arm/hardware/iop*
+F:	include/asm-arm/plat-iop/
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
+F:	include/asm-arm/hardware/iop*
+F:	arch/arm/plat-iop/
+F:	arch/arm/mach-iop13xx/
+F:	include/asm-arm/plat-iop/
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/INTEL IXP2000 ARM ARCHITECTURE
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp2000/
+F:	include/asm-arm/arch-ixp2000/
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/INTEL IXP23XX ARM ARCHITECTURE
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp23xx/
+F:	include/asm-arm/arch-ixp23xx/
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/LOGICPD PXA270 MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-pxa/
+F:	include/asm-arm/arch-pxa/
 
 ARM/TOSA MACHINE SUPPORT
 P:	Dirk Opfer
 M:	dirk@opfer-online.de
 S:	Maintained
+F:	arch/arm/mach-pxa/tosa.c
+F:	include/asm-arm/arch-pxa/
 
 ARM/PLEB SUPPORT
 P:	Peter Chubb
 M:	pleb@gelato.unsw.edu.au
 W:	http://www.disy.cse.unsw.edu.au/Hardware/PLEB
 S:	Maintained
+F:	arch/arm/mach-sa1100/pleb.c
+F:	include/asm-arm/arch-sa1100/
 
 ARM/PT DIGITAL BOARD PORT
 P:	Stefan Eletzhofer
 M:	stefan.eletzhofer@eletztrick.de
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
+F:	arch/arm/mach-ixp2000/enp2611.c
+F:	include/asm-arm/arch-ixp2000/
 
 ARM/SHARK MACHINE SUPPORT
 P:	Alexander Schulz
 M:	alex@shark-linux.de
 W:	http://www.shark-linux.de/shark.html
 S:	Maintained
+F:	arch/arm/mach-shark/
+F:	include/asm-arm/arch-shark/
 
 ARM/STRONGARM110 PORT
 P:	Russell King
 M:	rmk@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
+F:	arch/arm/mach-ebsa110/
+F:	include/asm-arm/arch-ebsa110/
 
 ARM/S3C2410 ARM ARCHITECTURE
 P:	Ben Dooks
 M:	ben-linux@fluff.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 
 ARM/S3C2440 ARM ARCHITECTURE
 P:	Ben Dooks
 M:	ben-linux@fluff.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
@@ -580,3657 +715,4605 @@ S:	Maintained
 ARM/THECUS N2100 MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARPD SUPPORT
 P:	Jonathan Layes
 L:	netdev@vger.kernel.org
 S:	Maintained
 
 ASUS ACPI EXTRAS DRIVER
 P:	Corentin Chary
 M:	corentincj@iksaif.net
 P:	Karol Kozimor
 M:	sziwan@users.sourceforge.net
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://sourceforge.net/projects/acpi4asus
 W:	http://xf.iksaif.net/acpi4asus
 S:	Maintained
+F:	arch/i386/kernel/acpi/boot.c
+F:	drivers/acpi/asus_acpi.c
 
 ASUS ASB100 HARDWARE MONITOR DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/asb100.c
 
 ASUS LAPTOP EXTRAS DRIVER
 P:	Corentin Chary
 M:	corentincj@iksaif.net
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://sourceforge.net/projects/acpi4asus
 W:	http://xf.iksaif.net/acpi4asus
 S:	Maintained
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS API
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 P:	Shannon Nelson
 M:	shannon.nelson@intel.com
 L:	linux-kernel@vger.kernel.org
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
 
 ATA OVER ETHERNET DRIVER
 P:	Ed L. Cashin
 M:	ecashin@coraid.com
 W:	http://www.coraid.com/support/linux
 S:	Supported
+F:	Documentation/aoe/
+F:	drivers/block/aoe/
 
 ATL1 ETHERNET DRIVER
 P:	Jay Cliburn
 M:	jcliburn@gmail.com
 P:	Chris Snook
 M:	csnook@redhat.com
 L:	atl1-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
 S:	Maintained
+F:	drivers/net/atl1/
 
 ATM
 P:	Chas Williams
 M:	chas@cmf.nrl.navy.mil
 L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
 W:	http://linux-atm.sourceforge.net
 S:	Maintained
+F:	drivers/atm/
+F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 P:	Nicolas Ferre
 M:	nicolas.ferre@rfo.atmel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
+F:	drivers/mmc/host/at91_mci.c
 
 ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/net/macb.*
 
 ATMEL SPI DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/api/atmel_spi.*
 
 ATMEL WIRELESS DRIVER
 P:	Simon Kelley
 M:	simon@thekelleys.org.uk
 L:	linux-wireless@vger.kernel.org
 W:	http://www.thekelleys.org.uk/atmel
 W:	http://atmelwlandriver.sourceforge.net/
 S:	Maintained
 
 AUDIT SUBSYSTEM
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained
+F:	include/linux/audit*
+F:	kernel/audit*
 
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	drivers/auxdisplay/
+F:	include/linux/cfag12864b.h
 
 AVR32 ARCHITECTURE
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 W:	http://www.atmel.com/products/AVR32/
 W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
 S:	Supported
+F:	arch/avr32/
+F:	include/asm-avr32/
 
 AVR32/AT32AP MACHINE SUPPORT
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	arch/avr32/mach-at32ap/
+F:	include/asm-avr32/arch-at32ap/
 
 AX.25 NETWORK LAYER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/ax25.h
+F:	include/net/ax25.h
+F:	net/ax25/
 
 BACKLIGHT CLASS/SUBSYSTEM
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
+F:	drivers/video/backlight/
+F:	include/linux/backlight.h
 
 BLACKFIN ARCHITECTURE
 P:	Aubrey Li
 M:	aubrey.li@analog.com
 P:	Bernd Schmidt
 M:	bernd.schmidt@analog.com
 P:	Bryan Wu
 M:	bryan.wu@analog.com
 P:	Grace Pan
 M:	grace.pan@analog.com
 P:	Marc Hoffman
 M:	marc.hoffman@analog.com
 P:	Michael Hennerich
 M:	michael.hennerich@analog.com
 P:	Mike Frysinger
 M:	michael.frysinger@analog.com
 P:	Jerry Zeng
 M:	jerry.zeng@analog.com
 P:	Jie Zhang
 M:	jie.zhang@analog.com
 P:	Robin Getz
 M:	robin.getz@analog.com
 P:	Roy Huang
 M:	roy.huang@analog.com
 P:	Sonic Zhang
 M:	sonic.zhang@analog.com
 P:	Vivi Li
 M:	vivi.li@analog.com
 P:	Yi Li
 M:	yi.li@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	arch/blackfin/
+F:	include/asm-blackfin/
 
 BLACKFIN EMAC DRIVER
 P:	Bryan Wu
 M:	bryan.wu@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/net/bfin_mac.*
 
 BLACKFIN RTC DRIVER
 P:	Mike Frysinger
 M:	michael.frysinger@analog.com
 M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SERIAL DRIVER
 P:	Aubrey Li
 M:	aubrey.li@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/serial/bfin_5xx.c
 
 BLACKFIN WATCHDOG DRIVER
 P:	Mike Frysinger
 M:	michael.frysinger@analog.com
 M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/char/watchdog/bfin_wdt.c
 
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
 M:	t.sailer@alumni.ethz.ch
 L:	linux-hams@vger.kernel.org
 W:	http://www.baycom.org/~tom/ham/ham.html
 S:	Maintained
+F:	drivers/net/hamradio/baycom*
 
 BCM43XX WIRELESS DRIVER (SOFTMAC BASED VERSION)
 P:	Larry Finger
 M:	Larry.Finger@lwfinger.net
 P:	Stefano Brivio
 M:	st3@riseup.net
 L:	linux-wireless@vger.kernel.org
 W:	http://bcm43xx.berlios.de/
 S:	Maintained
+F:	drivers/net/wireless/bcm43xx/
 
 BEFS FILE SYSTEM
 P:	Sergey S. Kostyliov
 M:	rathamahata@php4.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/befs/
 
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/bfs/
 
 BLACKFIN I2C TWI DRIVER
 P:	Sonic Zhang
 M:	sonic.zhang@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org/
 S:	Supported
+F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
+F:	block/
 
 BLUETOOTH SUBSYSTEM
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 L:	bluez-devel@lists.sf.net
 W:	http://bluez.sf.net
 W:	http://www.bluez.org
 W:	http://www.holtmann.org/linux/bluetooth/
 T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
+F:	drivers/bluetooth/
+F:	net/bluetooth/
+F:	include/net/bluetooth/
 
 BLUETOOTH RFCOMM LAYER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	net/bluetooth/rfcomm/
+F:	include/net/bluetooth/rfcomm.h
 
 BLUETOOTH BNEP LAYER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	net/bluetooth/bnep/
 
 BLUETOOTH CMTP LAYER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	net/bluetooth/cmtp/
 
 BLUETOOTH HIDP LAYER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	net/bluetooth/hidp
 
 BLUETOOTH HCI UART DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	drivers/bluetooth/btuart_cs.c
+F:	drivers/bluetooth/hci_bcsp.c
+F:	drivers/bluetooth/hci_h4.c
+F:	drivers/bluetooth/hci_ldisc.c
+F:	drivers/bluetooth/hci_uart.h
 
 BLUETOOTH HCI USB DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	drivers/bluetooth/hci_usb.*
 
 BLUETOOTH HCI BCM203X DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bcm203x.c
 
 BLUETOOTH HCI BPA10X DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bpa10x.c
 
 BLUETOOTH HCI BFUSB DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bfusb.c
 
 BLUETOOTH HCI DTL1 DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/dtl1_cs.c
 
 BLUETOOTH HCI BLUECARD DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bluecard_cs.c
 
 BLUETOOTH HCI BT3C DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/bt3c_cs.c
 
 BLUETOOTH HCI BTUART DRIVER
 P:	Marcel Holtmann
 M:	marcel@holtmann.org
 S:	Maintained
+F:	drivers/bluetooth/btuart_cs.c
 
 BLUETOOTH HCI VHCI DRIVER
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 S:	Maintained
+F:	drivers/bluetooth/hci_vhci.c
 
 BONDING DRIVER
 P:	Chad Tindel
 M:	ctindel@users.sourceforge.net
 P:	Jay Vosburgh
 M:	fubar@us.ibm.com
 L:	bonding-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
+F:	drivers/net/bonding/
+F:	include/linux/if_bonding.h
 
 BROADBAND PROCESSOR ARCHITECTURE
 P:	Arnd Bergmann
 M:	arnd@arndb.de
 L:	linuxppc-dev@ozlabs.org
 W:	http://www.penguinppc.org/ppc64/
 S:	Supported
 
 BROADCOM B44 10/100 ETHERNET DRIVER
 P:	Gary Zambrano
 M:	zambrano@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/b44.*
 
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
 P:	Michael Chan
 M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/bnx2*
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 P:	Michael Chan
 M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	drivers/net/tg3.*
 
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	block/bsg.c
+F:	include/linux/bsg.h
 
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
+P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/video4linux/bttv/
+F:	drivers/media/video/bt8xx/bttv*
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
-P:   	Jonathan Corbet
+P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	Documentation/video4linux/cafe_ccic
+F:	drivers/media/video/cafe_ccic*
 
 CALGARY x86-64 IOMMU
 P:	Muli Ben-Yehuda
 M:	muli@il.ibm.com
 P:	Jon D. Mason
 M:	jdmason@kudzu.us
 L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
+F:	arch/x86_64/kernel/pci-calgary.c
+F:	arch/x86_64/kernel/tce.c
+F:	include/asm-x86_64/calgary.h
+F:	include/asm-x86_64/tce.h
+F:	include/asm-x86_64/rio.h
 
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	Documentation/auxdisplay/cfag12864b
+F:	drivers/auxdisplay/cfag12864b.c
+F:	include/linux/cfag12864b.h
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	Documentation/auxdisplay/cfag12864b
+F:	drivers/auxdisplay/cfag12864bfb.c
+F:	include/linux/cfag12864b.h
 
 CFG80211 and NL80211
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	include/linux/nl80211.h
+F:	include/net/cfg80211.h
+F:	net/wireless/core.*
+F:	net/wireless/sysfs.*
+F:	net/wireless/radiotap.c
 
 CHECKPATCH
 P:	Andy Whitcroft
 M:	apw@shadowen.org
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 P:	Joel Schopp
 M:	jschopp@austin.ibm.com
 S:	Supported
+F:	scripts/checkpatch.pl
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://us1.samba.org/samba/Linux_CIFS_client.html
 T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
+F:	fs/cifs/
 
 CONFIGFS
 P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/configfs/
+F:	include/linux/configfs.h
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/arm/ep93xx_eth.c
 
 CIRRUS LOGIC GENERIC FBDEV DRIVER
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Odd Fixes
 
 CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
+P:	Nils Faerber
+M:	nils@kernelconcepts.de
 S:	Maintained
+F:	Documentation/input/cs461x.txt
+F:	sound/pci/cs46xx/
 
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
 M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
+F:	fs/coda/
+F:	include/linux/coda*.h
 
 COMPACTPCI HOTPLUG CORE
 P:	Scott Murray
 M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/cpci_hotplug*
 
 COMPACTPCI HOTPLUG ZIATECH ZT5550 DRIVER
 P:	Scott Murray
 M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/cpci_zt5550.*
 
 COMPACTPCI HOTPLUG GENERIC DRIVER
 P:	Scott Murray
 M:	scottm@somanetworks.com
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/cpcihp_generic.c
 
 COMPUTONE INTELLIPORT MULTIPORT CARD
 P:	Michael H. Warfield
 M:	mhw@wittsend.com
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
+F:	Documentation/computone.txt
+F:	drivers/char/ip2/
 
 CONEXANT ACCESSRUNNER USB DRIVER
 P:	Simon Arlott
 M:	cxacru@fire.lp0.eu
 L:	accessrunner-general@lists.sourceforge.net
 W:	http://accessrunner.sourceforge.net/
 S:	Maintained
+F:	drivers/usb/atm/cxacru.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/coretemp
+F:	drivers/hwmon/coretemp.c
 
 COSA/SRP SYNC SERIAL DRIVER
 P:	Jan "Yenya" Kasprzak
 M:	kas@fi.muni.cz
 W:	http://www.fi.muni.cz/~kas/cosa/
 S:	Maintained
 
 CPU FREQUENCY DRIVERS
 P:	Dave Jones
 M:	davej@codemonkey.org.uk
 L:	cpufreq@lists.linux.org.uk
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
 T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
+F:	arch/i386/kernel/cpu/cpufreq/
+F:	drivers/cpufreq/
+F:	include/linux/cpufreq.h
 
 CPUID/MSR DRIVER
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 S:	Maintained
+F:	arch/i386/kernel/cpuid.c
+F:	arch/i386/kernel/msr.c
 
 CPUSETS
 P:	Paul Jackson
 P:	Simon Derr
 M:	pj@sgi.com
 M:	simon.derr@bull.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 S:	Supported
+F:	Documentation/cpusets.txt
+F:	include/linux/cpuset.h
+F:	kernel/cpuset.c
 
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
 S:	Orphan
 
 CRIS PORT
 P:	Mikael Starvik
 M:	starvik@axis.com
 L:	dev-etrax@axis.com
 W:	http://developer.axis.com
 S:	Maintained
+F:	arch/cris/
+F:	include/asm-cris/
 
 CRYPTO API
 P:	Herbert Xu
 M:	herbert@gondor.apana.org.au
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
+F:	crypto/
 
 CS5535 Audio ALSA driver
 P:	Jaya Kumar
 M:	jayakumar.alsa@gmail.com
 S:	Maintained
+F:	sound/pci/cs5535audio/
 
 CYBERPRO FB DRIVER
 P:	Russell King
 M:	rmk@arm.linux.org.uk
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
+F:	drivers/video/cyber2000fb.*
 
 CYBLAFB FRAMEBUFFER DRIVER
 P:	Knut Petersen
 M:	Knut_Petersen@t-online.de
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/cyblafb.c
 
 CYCLADES 2X SYNC CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
+F:	drivers/net/wan/cycx*
 
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
 
 CYCLADES PC300 DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
+F:	drivers/net/wan/pc300*
 
 DAMA SLAVE for AX.25
 P:	Joerg Reuter
 M:	jreuter@yaina.de
 W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	net/ax25/af_ax25.c
+F:	net/ax25/ax25_dev.c
+F:	net/ax25/ax25_ds_*
+F:	net/ax25/ax25_in.c
+F:	net/ax25/ax25_out.c
+F:	net/ax25/ax25_timer.c
+F:	net/ax25/sysctl_net_ax25.c
 
 DC395x SCSI driver
 P:	Oliver Neukum
 M:	oliver@neukum.name
 P:	Ali Akcaagac
 M:	aliakc@web.de
 P:	Jamie Lenehan
 M:	lenehan@twibble.org
 W:	http://twibble.org/dist/dc395x/
 L:	dc395x@twibble.org
 L:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
+F:	Documentation/scsi/dc395x.txt
+F:	drivres/scsi/dc395x.*
 
 DC390/AM53C974 SCSI driver
 P:	Kurt Garloff
 M:	garloff@suse.de
 W:	http://www.garloff.de/kurt/linux/dc390/
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
 S:	Maintained
+F:	drivers/scsi/tmscsim.*
 
 DCCP PROTOCOL
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	dccp@vger.kernel.org
 W:	http://linux-net.osdl.org/index.php/DCCP
 S:	Maintained
+F:	include/linux/dccp.h
+F:	include/linux/tfrc.h
+F:	net/dccp/
 
 DECnet NETWORK LAYER
 P:	Patrick Caulfield
 M:	patrick@tykepenguin.com
 W:	http://linux-decnet.sourceforge.net
 L:	linux-decnet-user@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/networking/decnet.txt
+F:	net/decnet/
 
 DEFXX FDDI NETWORK DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/net/defxx.*
 
 DELL LAPTOP SMM DRIVER
 P:	Massimo Dal Zotto
 M:	dz@debian.org
 W:	http://www.debian.org/~dz/i8k/
 S:	Maintained
+F:	drivers/char/i8k.c
+F:	include/linux/i8k.h
 
 DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 P:	Doug Warzecha
 M:	Douglas_Warzecha@dell.com
 S:	Maintained
+F:	Documentation/dcdbas.txt
+F:	drivers/firmware/dcdbas.*
 
 DEVICE-MAPPER  (LVM)
 P:	Alasdair Kergon
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 S:	Maintained
+F:	Documentation/device-mapper/
+F:	drivers/md/dm*
+F:	drivers/md/kcopyd*
+F:	include/linux/device-mapper.h
+F:	include/linux/dm-ioctl.h
 
 DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
 M:	device@lanana.org
 W:	http://lanana.org/docs/device-list/index.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 DIGI INTL. EPCA DRIVER
 P:	Digi International, Inc
 M:	Eng.Linux@digi.com
 L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphaned
 
 DIGI RIGHTSWITCH NETWORK DRIVER
 P:	Rick Richardson
 L:	netdev@vger.kernel.org
 W:	http://www.digi.com
 S:	Orphaned
 
 DIRECTORY NOTIFICATION
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/dnotify.c
+F:	include/linux/dnotify.h
 
 DISK GEOMETRY AND PARTITION HANDLING
 P:	Andries Brouwer
 M:	aeb@cwi.nl
 W:	http://www.win.tue.nl/~aeb/linux/Large-Disk.html
 W:	http://www.win.tue.nl/~aeb/linux/zip/zip-1.html
 W:	http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
 S:	Maintained
 
 DISKQUOTA:
 P:	Jan Kara
 M:	jack@suse.cz
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 DISTRIBUTED LOCK MANAGER
 P:	Patrick Caulfield
 M:	pcaulfie@redhat.com
 P:	David Teigland
 M:	teigland@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
+F:	fs/dlm/
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 P:	Tobias Ringstrom
 M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/dmfe.txt
+F:	drivers/net/tulip/dmfe.c
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 P:	Shannon Nelson
 M:	shannon.nelson@intel.com
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/
+F:	include/linux/dma*
 
 DME1737 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/dme1737
+F:	drivers/hwmon/dme1737.c
 
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 S:	Maintained
 
 DOCKING STATION DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	linux-acpi@vger.kernel.org
 S:	Supported
+F:	drivers/acpi/dock.c
 
 DOUBLETALK DRIVER
 P:	James R. Van Zandt
 M:	jrv@vanzandt.mv.com
 L:	blinux-list@redhat.com
 S:	Maintained
+F:	drivers/char/dtlk.c
+F:	include/linux/dtlk.h
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/kobject.txt
+F:	drivers/base/core.c
+F:	fs/sysfs/
+F:	include/linux/kobj*
+F:	lib/kobj*
 
 DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
 T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
+F:	drivers/char/drm/
 
 DSCC4 DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wan/dscc4.c
 
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
-L: 	linux-dvb@linuxtv.org (subscription required)
+L:	linux-dvb@linuxtv.org (subscribers-only)
 W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/dvb/
+F:	drivers/media/dvb/
+F:	drivers/media/common/saa7146*.c
+F:	include/linux/dvb/
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EATA ISA/EISA/PCI SCSI DRIVER
 P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EATA-PIO SCSI DRIVER
 P:	Michael Neuffer
 M:	mike@i-Connect.Net
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EBTABLES
 P:	Bart De Schuymer
 M:	bart.de.schuymer@pandora.be
 L:	ebtables-user@lists.sourceforge.net
 L:	ebtables-devel@lists.sourceforge.net
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
+F:	include/linux/netfilter_bridge/ebt_*.h
+F:	net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
-P:	Mike Halcrow, Phillip Hellewell
-M:	mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
+P:	Mike Halcrow
+M:	mhalcrow@us.ibm.com
+P:	Phillip Hellewell
+M:	phillip@hellewell.homeip.net
 L:	ecryptfs-devel@lists.sourceforge.net
 W:	http://ecryptfs.sourceforge.net/
 S:	Supported
+F:	fs/ecryptfs/
 
 EDAC-CORE
 P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Supported
+F:	Documentation/drivers/edac/edac.txt
+F:	drivers/edac/edac_*
+F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
 P:	Doug Thompson
 M:	mark.gross@intel.com
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/e752x_edac.c
 
 EDAC-E7XXX
 P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 
 EDAC-I82443BXGX
 P:	Tim Small
 M:	tim@buttersideup.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i82443bxgx_edac.c
 
 EDAC-I3000
 P:	Jason Uhlenkott
 M:	juhlenko@akamai.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i3000_edac.c
 
 EDAC-I5000
 P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i5000_edac.c
 
 EDAC-I82975X
 P:	Ranganathan Desikan
 P:	Arvind R.
 M:	rdesikan@jetzbroadband.com
 M:	arvind@acarlab.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/i82975x_edac.c
 
 EDAC-PASEMI
 P:	Egor Martovetsky
 M:	egor@pasemi.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/pasemi_edac.c
 
 EDAC-R82600
 P:	Tim Small
 M:	tim@buttersideup.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
 S:	Maintained
+F:	drivers/edac/r82600_edac.c
 
 EEPRO100 NETWORK DRIVER
 P:	Andrey V. Savochkin
 M:	saw@saw.sw.com.sg
 S:	Maintained
+F:	drivers/net/eepro100.c
 
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
+F:	fs/efs/
 
 EHCA (IBM GX bus InfiniBand adapter) DRIVER:
 P:	Hoang-Nam Nguyen
 M:	hnguyen@de.ibm.com
 P:	Christoph Raisch
 M:	raisch@de.ibm.com
 L:	general@lists.openfabrics.org
 S:	Supported
+F:	drivers/infiniband/hw/ehca/
 
 EMULEX LPFC FC SCSI DRIVER
 P:	James Smart
 M:	james.smart@emulex.com
 L:	linux-scsi@vger.kernel.org
 W:	http://sourceforge.net/projects/lpfcxxxx
 S:	Supported
+F:	drivers/scsi/lpfc/
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover
-M:	ch@murgatroid.com, ch@hpl.hp.com
+M:	ch@murgatroid.com
+P:	Christopher Hoover
+M:	ch@hpl.hp.com
 S:	Maintained
+F:	drivers/video/epson1355fb.c
 
 ETHEREXPRESS-16 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/eexpress.*
 
 ETHERNET BRIDGE
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	bridge@lists.linux-foundation.org
 W:	http://bridge.sourceforge.net/
 S:	Maintained
 
 ETHERTEAM 16I DRIVER
 P:	Mika Kuoppala
 M:	miku@iki.fi
 S:	Maintained
+F:	drivers/net/eth16i.c
 
 EXT2 FILE SYSTEM
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext2/
+F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
+P:	Andreas Dilger
+M:	adilger@clusterfs.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext3/
+F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
+P:	Ted Ts'o
+M:	tytso@mit.edu
+P:	Mingming Cao
+M:	cmm@us.ibm.com
+P:	Andreas Dilger
+M:	adilger@clusterfs.com
+P:	Dave Kleikamp
+M:	shaggy@austin.ibm.com
+P:	Eric Sandeen
+M:	sandeen@redhat.com
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/ext4/
+F:	include/linux/ext4*
 
 F71805F HARDWARE MONITORING DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/f71805f
+F:	drivers/hwmon/f71805f.c
 
 FARSYNC SYNCHRONOUS DRIVER
 P:	Kevin Curtis
 M:	kevin.curtis@farsite.co.uk
 W:	http://www.farsite.co.uk/
 S:	Supported
+F:	drivers/net/wan/farsync.*
 
 FAULT INJECTION SUPPORT
 P:	Akinobu Mita
 M:	akinobu.mita@gmail.com
 S:	Supported
+F:	Documentation/fault-injection/
+F:	lib/fault-inject.c
 
 FRAMEBUFFER LAYER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 W:	http://linux-fbdev.sourceforge.net/
 S:	Maintained
+F:	Documentation/fb/
+F:	drivers/video/fb*
+F:	include/linux/fb.h
 
 FREESCALE SOC FS_ENET DRIVER
 P:	Pantelis Antoniou
 M:	pantelis.antoniou@gmail.com
 P:	Vitaly Bordug
 M:	vbordug@ru.mvista.com
 L:	linuxppc-embedded@ozlabs.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/fs_enet/
+F:	include/linus/fs_enet_pd.h
 
 FREESCALE HIGHSPEED USB DEVICE DRIVER
 P:	Li Yang
 M:	leoli@freescale.com
 L:	linux-usb-devel@lists.sourceforge.net
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	drivers/usb/gadget/fsl_usb2_udc.c
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
 P:	Li Yang
 M:	leoli@freescale.com
 L:	netdev@vger.kernel.org
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	drivers/net/ucc_geth*
 
 FILE LOCKING (flock() and fcntl()/lockf())
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+F:	include/linux/fcntl.h
+F:	include/linux/fs.h
+F:	fs/fcntl.c
+F:	fs/locks.c
 
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 S:	Maintained
+F:	fs/*
 
 FIREWIRE SUBSYSTEM
-P:	Kristian Hoegsberg, Stefan Richter
-M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
+P:	Kristian Hoegsberg
+M:	krh@redhat.com
+P:	Stefan Richter
+M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	drivers/firewire/
+F:	include/linux/firewire-*.h
 
 FIRMWARE LOADER (request_firmware)
 L:	linux-kernel@vger.kernel.org
 S:	Orphan
 
 FPU EMULATOR
 P:	Bill Metzenthen
 M:	billm@suburbia.net
 W:	http://suburbia.net/~billm/floating-point/emulator/
 S:	Maintained
+F:	arch/i386/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
 P:	Mike McLagan
 M:	mike.mclagan@linux.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wan/dlci.c
+F:	drivers/net/wan/sdla.c
 
 FREEVXFS FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
+F:	fs/freevxfs/
 
 FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com
 S:	Maintained
+F:	arch/frv/
+F:	include/asm-frv/
 
 FUSE: FILESYSTEM IN USERSPACE
 P:	Miklos Szeredi
 M:	miklos@szeredi.hu
 L:	fuse-devel@lists.sourceforge.net
 W:	http://fuse.sourceforge.net/
 S:	Maintained
+F:	fs/fuse/
+F:	include/linux/fuse.h
 
 FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-bit)
 P:	Rik Faith
 M:	faith@cs.unc.edu
 L:	linux-scsi@vger.kernel.org
 S:	Odd fixes (e.g., new signatures)
+F:	drivers/scsi/fdomain.*
+F:	drivers/scsi/pcmcia/fdomain_stub.c
 
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 P:	Achim Leubner
 M:	achim_leubner@adaptec.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.icp-vortex.com/
 S:	Supported
+F:	drivers/scsi/gdt*
 
 GENERIC GPIO I2C DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
+F:	drivers/i2c/busses/i2c-gpio.c
+F:	include/linux/i2c-gpio.h
 
 GENERIC HDLC DRIVER, N2, C101, PCI200SYN and WANXL DRIVERS
 P:	Krzysztof Halasa
 M:	khc@pm.waw.pl
 W:	http://www.kernel.org/pub/linux/utils/net/hdlc/
 S:	Maintained
+F:	Documentation/networking/generic-hdlc.txt
+F:	drivers/net/wan/c101.c
+F:	drivers/net/wan/hd6457x.c
+F:	drivers/net/wan/hdlc*
+F:	drivers/net/wan/n2.c
+F:	drivers/net/wan/pc300too.c
+F:	drivers/net/wan/pci200syn.c
+F:	drivers/net/wan/wanxl*
 
 GFS2 FILE SYSTEM
 P:	Steven Whitehouse
 M:	swhiteho@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
+F:	Documentation/filesystems/gfs2.txt
+F:	fs/gfs2/
+F:	include/linux/gfs2_ondisk.h
+F:	include/linux/lm_interface.h
 
 GIGASET ISDN DRIVERS
 P:	Hansjoerg Lipp
 M:	hjlipp@web.de
 P:	Tilman Schmidt
 M:	tilman@imap.cc
 L:	gigaset307x-common@lists.sourceforge.net
 W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
+F:	Documentation/isdn/README.gigaset
+F:	drivers/isdn/gigaset/
+F:	include/linux/gigaset_dev.h
 
 HARDWARE MONITORING
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
 T:	git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git
 S:	Maintained
+F:	drivers/hwmon/
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
 P:	Michael Buesch
 M:	mb@bu3sch.de
 S:	Maintained
+F:	Documentation/hw_random.txt
+F:	drivers/char/hw_random/
+F:	include/linux/hw_random.h
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
 M:	rlove@rlove.org
 M:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
 S:	Maintained
+F:	drivers/hwmon/hdaps.c
 
 HARMONY SOUND DRIVER
 P:	Kyle McMartin
 M:	kyle@parisc-linux.org
 W:	http://www.parisc-linux.org/~kyle/harmony/
 L:	parisc-linux@lists.parisc-linux.org
 S:	Maintained
+F:	sound/parisc/harmony.*
 
 HAYES ESP SERIAL DRIVER
 P:	Andrew J. Robinson
 M:	arobinso@nyx.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
+F:	drivers/char/esp.c
 
 HFS FILESYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/hfs.txt
+F:	fs/hfs/
 
 HGA FRAMEBUFFER DRIVER
 P:	Ferenc Bakonyi
 M:	fero@drama.obuda.kando.hu
 L:	linux-nvidia@lists.surfsouth.com
 W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
 S:	Maintained
+F:	drivers/video/hgafb.c
+
+HIBERNATION (aka Software Suspend, aka swsusp)
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+F:	Documentation/power/
+F:	arch/i386/power/
+F:	arch/x86_64/kernel/suspend_asm.S
+F:	arch/x86_64/kernel/suspend.c
+F:	drivers/base/power/
+F:	kernel/power/
+F:	include/linux/suspend.h
+F:	include/linux/freezer.h
+F:	include/linux/pm.h
+F:	include/asm-*/suspend.h
 
 HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-input@atrey.karlin.mff.cuni.cz
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
+F:	drivers/hid/
+F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/hrtimer/
+F:	Documentation/hrtimers/
+F:	kernel/hrtimer.c
+F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
 P:	Klaus Kudielka
 M:	klaus.kudielka@ieee.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.nt.tuwien.ac.at/~kkudielk/Linux/
 S:	Maintained
+F:	drivers/net/hamradio/dmascc.c
+F:	drivers/net/hamradio/scc.c
 
 HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 P:	HighPoint Linux Team
 M:	linux@highpoint-tech.com
 W:	http://www.highpoint-tech.com
 S:	Supported
+F:	Documentation/scsi/hptiop.txt
+F:	drivers/scsi/hptiop.c
 
 HIPPI
 P:	Jes Sorensen
 M:	jes@trained-monkey.org
 L:	linux-hippi@sunsite.dk
 S:	Maintained
+F:	include/linux/hippidevice.h
+F:	include/linux/if_hippi.h
+F:	net/802/hippi.c
 
 HEWLETT-PACKARD FIBRE CHANNEL 64-bit/66MHz PCI non-intelligent HBA
 P:	Chirag Kantharia
 M:	chirag.kantharia@hp.com
 L:	iss_storagedev@hp.com
 S:	Maintained
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
 P:	Chirag Kantharia
 M:	chirag.kantharia@hp.com
 L:	iss_storagedev@hp.com
 S:	Maintained
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 P:	Mike Miller
 M:	mike.miller@hp.com
 L:	iss_storagedev@hp.com
 S:	Supported
+F:	Documentation/cciss.txt
+F:	drivers/block/cciss*
+F:	include/linux/cciss_ioctl.h
 
 HOST AP DRIVER
 P:	Jouni Malinen
 M:	j@w1.fi
 L:	hostap@shmoo.com (subscribers-only)
 L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
+F:	drivers/net/wireless/hostap/
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
 P:	Jaroslav Kysela
 M:	perex@suse.cz
 S:	Maintained
+F:	drivers/net/hp100.*
 
 HPET:	High Precision Event Timers driver (hpet.c)
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
 S:	Maintained
+F:	Documentation/hpet.txt
+F:	drivers/char/hpet.c
+F:	include/linux/hpet.h
 
 HPET:	i386
 P:	Venkatesh Pallipadi (Venki)
 M:	venkatesh.pallipadi@intel.com
 S:	Maintained
+F:	arch/i386/kernel/hpet.c
+F:	include/asm-i386/hpet.h
 
 HPET:	x86_64
 P:	Andi Kleen and Vojtech Pavlik
 M:	andi@firstfloor.org and vojtech@suse.cz
 S:	Maintained
+F:	arch/x86_64/kernel/hpet.c
+F:	include/asm-x86_64/hpet.h
 
 HPET:	ACPI hpet.c
 P:	Bob Picco
 M:	bob.picco@hp.com
 S:	Maintained
+F:	drivers/char/hpet.c
 
 HPFS FILESYSTEM
 P:	Mikulas Patocka
 M:	mikulas@artax.karlin.mff.cuni.cz
 W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
+F:	fs/hpfs/
 
 HUGETLB FILESYSTEM
 P:	William Irwin
 M:	wli@holomorphy.com
 S:	Maintained
+F:	fs/hugetlbfs/
 
 I2C/SMBUS STUB DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
 I2C SUBSYSTEM
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
 T:	quilt http://khali.linux-fr.org/devel/linux-2.6/jdelvare-i2c/
 S:	Maintained
+F:	Documentation/i2c/
+F:	drivers/i2c/
+F:	include/linux/i2c.h
+F:	include/linux/i2c-dev.h
+F:	include/linux/i2c-id.h
 
 I2C-TINY-USB DRIVER
 P:	Till Harbaum
 M:	till@harbaum.org
 L:	i2c@lm-sensors.org
 T:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
+F:	drivers/i2c/busses/i2c-tiny-usb.c
 
 i386 BOOT CODE
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	Linux-Kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/i386/boot.txt
+F:	arch/i386/boot/
+F:	arch/i386/kernel/*boot*
+F:	arch/i386/mm/boot*
+F:	include/asm-i386/*boot*
 
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
+F:	arch/i386/kernel/setup.c
+F:	include/asm-i386/setup.h
 
 IA64 (Itanium) PLATFORM
 P:	Tony Luck
 M:	tony.luck@intel.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
+F:	arch/ia64/
+F:	include/asm-ia64/*
 
 SN-IA64 (Itanium) SUB-PLATFORM
 P:	Jes Sorensen
 M:	jes@sgi.com
 L:	linux-altix@sgi.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.sgi.com/altix
 S:	Maintained
+F:	arch/ia64/sn/
 
 IBM MCA SCSI SUBSYSTEM DRIVER
 P:	Michael Lang
 M:	langa2@kph.uni-mainz.de
 W:	http://www.uni-mainz.de/~langm000/linux.html
 S:	Maintained
+F:	drivers/scsi/ibmmca.c
 
 IBM Power Linux RAID adapter
 P:	Brian King
 M:	brking@us.ibm.com
 S:	Supported
+F:	drivers/scsi/ipr.*
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
 P:	Dave Jeffery
 M:	ipslinux@adaptec.com
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported
+F:	drivers/scsi/ips.*
 
 IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz
 M:	bzolnier@gmail.com
 L:	linux-ide@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
 S:	Maintained
+F:	Documentation/ide.txt
+F:	drivers/ide/
+F:	include/linux/ide.h
 
 IDE/ATAPI CDROM DRIVER
 P:	Alan Cox
 M:	alan@lxorguk.ukuu.org.uk
 L:	linux-ide@vger.kernel.org
 S:	Maintained
+F:	Documentation/cdrom/ide-cd
+F:	drivers/ide/ide-cd.*
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
+M:	aul@paulbristow.net
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/ide/ide-floppy.c
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
+M:	gadio@netvision.net.il
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/ide/ide-tape.c
 
 IEEE 1394 SUBSYSTEM
 P:	Ben Collins
 M:	ben.collins@ubuntu.com
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	drivers/ieee1394/
 
 IEEE 1394 RAW I/O DRIVER (raw1394)
 P:	Dan Dennedy
 M:	dan@dennedy.org
 P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/ieee1394/raw1394*
 
 IMS TWINTURBO FRAMEBUFFER DRIVER
-P:	Paul Mundt
-M:	lethal@chaoticdreams.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
-S:	Maintained
+S:	Orphan
+F:	drivers/video/imsttfb.c
 
 INFINIBAND SUBSYSTEM
 P:	Roland Dreier
 M:	rolandd@cisco.com
 P:	Sean Hefty
 M:	mshefty@ichips.intel.com
 P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com 
 L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
+F:	Documentation/infiniband/
+F:	drivers/infiniband/
+F:	include/linux/if_infiniband.h
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
 M:	dtor@mail.ru
 L:	linux-input@atrey.karlin.mff.cuni.cz
 L:	linux-joystick@atrey.karlin.mff.cuni.cz
 T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 
 INOTIFY
 P:	John McCutchan
 M:	ttb@tentacle.dhs.org
 P:	Robert Love
 M:	rml@novell.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/inotify.txt
+F:	fs/inotify*
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	Documentation/fb/intelfb.txt
+F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/i810/
 
 INTEL APIC/IOAPIC, LOWLEVEL X86 SMP SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
 S:	Maintained
+F:	Documentation/i386/IO-APIC.txt
+F:	arch/i386/kernel/*apic*
+F:	include/asm-i386/*apic*
 
 INTEL I8XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 W:	http://sourceforge.net/projects/gkernel/
 S:	Maintained
+F:	drivers/char/hw_random/intel-rng.c
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
 P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 
 INTEL I/OAT DMA DRIVER
 P:	Shannon Nelson
 M:	shannon.nelson@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
 INTEL IOP-ADMA DMA DRIVER
 P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/ioatdma*
 
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
+F:	drivers/char/hw_random/ixp4xx-rng.c
 
 INTEL IXP2000 ETHERNET DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ixp2000/
 
 INTEL PRO/100 ETHERNET SUPPORT
 P:	John Ronciak
 M:	john.ronciak@intel.com
 P:	Jesse Brandeburg
 M:	jesse.brandeburg@intel.com
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
 P:	Auke Kok
 M:	auke-jan.h.kok@intel.com
 L:	e1000-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/e1000/
 S:	Supported
+F:	drivers/net/e100.c
 
 INTEL PRO/1000 GIGABIT ETHERNET SUPPORT
 P:	Jeb Cramer
 M:	cramerj@intel.com
 P:	John Ronciak
 M:	john.ronciak@intel.com
 P:	Jesse Brandeburg
 M:	jesse.brandeburg@intel.com
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
 P:	Auke Kok
 M:	auke-jan.h.kok@intel.com
 L:	e1000-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/e1000/
 S:	Supported
+F:	drivers/net/e1000/
 
 INTEL PRO/10GbE SUPPORT
 P:	Jeff Kirsher
 M:	jeffrey.t.kirsher@intel.com
 P:	Ayyappan Veeraiyan
 M:	ayyappan.veeraiyan@intel.com
 P:	John Ronciak
 M:	john.ronciak@intel.com
 P:	Jesse Brandeburg
 M:	jesse.brandeburg@intel.com
 P:	Auke Kok
 M:	auke-jan.h.kok@intel.com
 L:	e1000-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/e1000/
 S:	Supported
+F:	drivers/net/ixgb/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
 P:	Yi Zhu
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
 S:	Supported
+F:	Documentation/networking/README.ipw2100
+F:	drivers/net/wireless/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
 P:	Yi Zhu
 M:	yi.zhu@intel.com
 P:	James Ketrenos
 M:	jketreno@linux.intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
+F:	drivers/net/wireless/ipw2200.*
 
 IOC3 DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
+F:	drivers/net/ioc3-eth.c
+
+IOC3 SERIAL DRIVER
+P:	Pat Gefre
+M:	pfg@sgi.com
+L:	linux-mips@linux-mips.org
+S:	Maintained
+F:	drivers/serial/ioc3_serial.c
 
 IP MASQUERADING:
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
 S:	Maintained
+F:	net/ipv4/netfilter/ipt_MASQUERADE.c
 
 IPATH DRIVER:
 P:	Arthur Jones
 M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
 T:	git git://git.qlogic.com/ipath-linux-2.6
 S:	Supported
+F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
 P:	Corey Minyard
 M:	minyard@acm.org
 L:	openipmi-developer@lists.sourceforge.net
 W:	http://openipmi.sourceforge.net/
 S:	Supported
+F:	Documentation/IPMI.txt
+F:	drivers/char/ipmi/
+F:	include/linux/ipmi*
 
 IPX NETWORK LAYER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/ipx.h
+F:	include/net/ipx.h
+F:	net/ipx/
 
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
 M:	samuel@sortiz.org
 L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
+F:	Documentation/networking/irda.txt
+F:	drivers/net/irda/
+F:	include/net/irda/
+F:	net/irda/
 
 ISAPNP
 P:	Jaroslav Kysela
 M:	perex@suse.cz
 S:	Maintained
+F:	Documentation/isapnp.txt
+F:	drivers/pnp/isapnp/
+F:	include/linux/isapnp.h
 
 ISDN SUBSYSTEM
 P:	Karsten Keil
 M:	kkeil@suse.de
 P:	Kai Germaschewski
 M:	kai.germaschewski@gmx.de
 L:	isdn4linux@listserv.isdn4linux.de
 W:	http://www.isdn4linux.de
 T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
 S:	Maintained
+F:	Documentation/isdn/
+F:	drivers/isdn/
+F:	include/linux/isdn.h
+F:	include/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
 P:	Armin Schindler
 M:	mac@melware.de
 L:	isdn4linux@listserv.isdn4linux.de
 W:	http://www.melware.de
 S:	Maintained
+F:	drivers/isdn/hardware/eicon/
+
+IVTV VIDEO4LINUX DRIVER
+P:	Hans Verkuil
+M:	hverkuil@xs4all.nl
+L:	ivtv-devel@ivtvdriver.org
+L:	ivtv-users@ivtvdriver.org
+L:	video4linux-list@redhat.com
+W:	http://www.ivtvdriver.org
+S:	Maintained
+F:	Documentation/video4linux/README.ivtv
+F:	drivers/media/video/ivtv/
 
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	jffs-dev@axis.com
 W:	http://sources.redhat.com/jffs2/
 S:	Maintained
+F:	fs/jffs2/
+F:	include/linux/jffs2.h
+F:	include/mtd/jffs2-user.h
 
 JFS FILESYSTEM
 P:	Dave Kleikamp
 M:	shaggy@austin.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
+F:	Documentation/filesystems/jfs.txt
+F:	fs/jfs/
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
+F:	fs/jbd*/
+F:	include/linux/ext*jbd*.h
+F:	include/linux/jbd*.h
 
 K8TEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/k8temp
+F:	drivers/hwmon/k8temp.c
 
 KCONFIG
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	kbuild-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/kbuild/kconfig-language.txt
+F:	scripts/kconfig/
 
 KDUMP
 P:	Vivek Goyal
 M:	vgoyal@in.ibm.com
 P:	Haren Myneni
 M:	hbabu@us.ibm.com
 L:	kexec@lists.infradead.org
 L:	linux-kernel@vger.kernel.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
+F:	Documentation/kdump
 
 KERNEL AUTOMOUNTER (AUTOFS)
 P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	autofs@linux.kernel.org
 S:	Odd Fixes
+F:	fs/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 P:	Ian Kent
 M:	raven@themaw.net
 L:	autofs@linux.kernel.org
 S:	Maintained
+F:	fs/autofs4/
 
 KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Kai Germaschewski
 M:	kai@germaschewski.name
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
 S:	Maintained
+F:	Documentation/kbuild/
+F:	Makefile
+F:	scripts/Makefile.*
 
 KERNEL JANITORS
 P:	Several
 L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
 KERNEL NFSD
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
 M:	neilb@suse.de
 L:	nfs@lists.sourceforge.net
 W:	http://nfs.sourceforge.net/
 S:	Supported
+F:	fs/nfsd/
+F:	include/linux/nfsd/
 
 KERNEL VIRTUAL MACHINE (KVM)
 P:	Avi Kivity
 M:	avi@qumranet.com
 L:	kvm-devel@lists.sourceforge.net
 W:	kvm.sourceforge.net
 S:	Supported
+F:	drivers/kvm/
+F:	include/linux/kvm*
 
 KEXEC
 P:	Eric Biederman
 M:	ebiederm@xmission.com
 W:	http://www.xmission.com/~ebiederm/files/kexec/
 L:	linux-kernel@vger.kernel.org
 L:	kexec@lists.infradead.org
 S:	Maintained
+F:	include/linux/kexec.h
+F:	kernel/kexec.c
 
 KPROBES
 P:	Prasanna S Panchamukhi
 M:	prasanna@in.ibm.com
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
 P:	Anil S Keshavamurthy
 M:	anil.s.keshavamurthy@intel.com
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/kprobes.txt
+F:	include/linux/kprobes.h
+F:	kernel/kprobes.c
 
 KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
+F:	Documentation/auxdisplay/ks0108
+F:	drivers/auxdisplay/ks0108.c
+F:	include/linux/ks0108.h
 
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
 
 LASI 53c700 driver for PARISC
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/scsi/53c700.txt
+F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
+F:	drivers/leds/
+F:	include/linux/leds.h
 
 LEGO USB Tower driver
 P:	Juergen Stuber
 M:	starblue@users.sourceforge.net
 L:	legousb-devel@lists.sourceforge.net
 W:	http://legousb.sourceforge.net/
 S:	Maintained
+F:	drivers/usb/misc/legousbtower.c
 
 LINUX FOR IBM pSERIES (RS/6000)
 P:	Paul Mackerras
 M:	paulus@au.ibm.com
 W:	http://www.ibm.com/linux/ltc/projects/ppc
 S:	Supported
+F:	arch/powerpc/boot/rs6000.h
+F:	arch/ppc/boot/include/rs6000.h
 
 LINUX FOR NCR VOYAGER
 P:	James Bottomley
 M:	James.Bottomley@HansenPartnership.com
 W:	http://www.hansenpartnership.com/voyager
 S:	Maintained
+F:	Documentation/voyager.txt
+F:	arch/i386/boot/voyager.c
+F:	arch/i386/mach-voyager/
+F:	include/asm-i386/mach-voyager/
+F:	include/asm-i386/voyager.h
 
 LINUX FOR POWERPC
 P:	Paul Mackerras
 M:	paulus@samba.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
 S:	Supported
+F:	arch/powerpc/
+F:	arch/ppc/
+F:	include/asm-powerpc/
+F:	include/asm-ppc/
 
 LINUX FOR POWER MACINTOSH
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/powermac
+F:	include/asm-powerpc/pmac_*
 
 LINUX FOR POWERPC EMBEDDED MPC52XX
 P:	Sylvain Munaut
 M:	tnt@246tNt.com
 W:	http://www.246tNt.com/mpc52xx/
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/52xx/
+F:	include/asm-powerpc/mpc52xx.h
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC BOOT CODE
 P:	Tom Rini
 M:	trini@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/boot/
 
 LINUX FOR POWERPC EMBEDDED PPC8XX
 P:	Marcelo Tosatti
 M:	marcelo@kvack.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/syslib/ppc8xx*
 
 LINUX FOR POWERPC EMBEDDED PPC83XX AND PPC85XX
 P:	Kumar Gala
 M:	galak@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	arch/ppc/syslib/ppc83xx_*
 
 LINUX FOR POWERPC PA SEMI PWRFICIENT
 P:	Olof Johansson
 M:	olof@lixom.net
 W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/platforms/pasemi/
 
 LLC (802.2)
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 S:	Maintained
+F:	include/linux/llc.h
+F:	include/net/llc*
+F:	net/llc/
 
 LINUX FOR 64BIT POWERPC
 P:	Paul Mackerras
 M:	paulus@samba.org
 M:	paulus@au.ibm.com
 P:	Anton Blanchard
 M:	anton@samba.org
 M:	anton@au.ibm.com
 W:	http://www.penguinppc.org/ppc64/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/
+F:	include/asm-powerpc/
 
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
 W:	http://lsm.immunix.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LM83 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/lm83
+F:	drivers/hwmon/lm83.c
 
 LM90 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/lm90
+F:	drivers/hwmon/lm90.c
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 P:	Richard Russon (FlatCap)
 M:	ldm@flatcap.org
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
+F:	Documentation/ldm.txt
+F:	fs/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 P:	Eric Moore
 M:	Eric.Moore@lsi.com
 M:	support@lsi.com
 L:	mpt_linux_developer@lsi.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.lsilogic.com/support
 S:	Supported
+F:	drivers/message/fusion/
 
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/sym53c8xx_2/
 
 M32R ARCHITECTURE
 P:	Hirokazu Takata
 M:	takata@linux-m32r.org
 L:	linux-m32r@ml.linux-m32r.org
 L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
 W:	http://www.linux-m32r.org/
 S:	Maintained
+F:	arch/m32r/
+F:	include/asm-m32r/
 
 M68K ARCHITECTURE
 P:	Geert Uytterhoeven
 M:	geert@linux-m68k.org
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
 W:	http://linux-m68k-cvs.ubb.ca/
 S:	Maintained
+F:	arch/m68k/
+F:	include/asm-m68k/
 
 M68K ON APPLE MACINTOSH
 P:	Joshua Thompson
 M:	funaho@jurai.org
 W:	http://www.mac.linux-m68k.org/
 L:	linux-mac68k@mac.linux-m68k.org
 S:	Maintained
 
 M68K ON HP9000/300
 P:	Philip Blundell
 M:	philb@gnu.org
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
+F:	arch/m68k/hp300/
+F:	include/asm-m68k/hp*
 
 MAC80211
 P:	Jiri Benc
 M:	jbenc@suse.cz
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/jbenc/mac80211.git
 S:	Maintained
+F:	net/mac80211/
+F:	Documentation/networking/mac80211-injection.txt
+F:	include/net/mac80211.h
 
 MACVLAN DRIVER
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
-
-MARVELL YUKON / SYSKONNECT DRIVER
-P:	Mirko Lindner
-M: 	mlindner@syskonnect.de
-P:	Ralph Roesler
-M: 	rroesler@syskonnect.de
-W: 	http://www.syskonnect.com
-S: 	Supported
+F:	drivers/net/macvlan.c
+F:	include/linux/if_macvlan.h
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
 M:	mtk-manpages@gmx.net
 W:	ftp://ftp.kernel.org/pub/linux/docs/manpages
 S:	Maintained
 
 MARVELL MV643XX ETHERNET DRIVER
 P:	Dale Farnsworth
 M:	dale@farnsworth.org
 P:	Manish Lachwani
 M:	mlachwani@mvista.com
 L:	netdev@vger.kernel.org
 S:	Odd Fixes for 2.4; Maintained for 2.6.
+F:	drivers/net/mv643xx_eth.*
+F:	include/linux/mv643xx.h
 
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/matrox/matroxfb_*
+F:	include/linux/matroxfb.h
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
 P:	Hans J. Koch
 M:	hjk@linutronix.de
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/max6650
+F:	drivers/hwmon/max6650.c
 
 MEGARAID SCSI DRIVERS
 P:	Neela Syam Kolli
 M:	megaraidlinux@lsi.com
 S:	linux-scsi@vger.kernel.org
 W:	http://megaraid.lsilogic.com
 S:	Maintained
+F:	Documentation/scsi/megaraid.txt
+F:	drivers/scsi/megaraid.*
+F:	drivers/scsi/megaraid/
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
+F:	include/linux/mm.h
+F:	mm/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
+F:	drivers/mtd/
+F:	include/linux/mtd/
+F:	include/mtd/
 
 UNSORTED BLOCK IMAGES (UBI)
 P:	Artem Bityutskiy
 M:	dedekind@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
 S:	Maintained
+F:	drivers/mtd/ubi
+F:	include/linux/mtd/ubi.h
+F:	include/mtd/ubi-*
 
 MICROTEK X6 SCANNER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 S:	Maintained
+F:	drivers/usb/image/microtek.*
 
 MIPS
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
 T:	git www.linux-mips.org:/pub/scm/linux.git
 S:	Supported
+F:	Documentation/mips/
+F:	arch/mips/
+F:	include/asm-mips/
 
 MISCELLANEOUS MCA-SUPPORT
 P:	James Bottomley
 M:	jejb@steeleye.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/ia64/mca.txt
+F:	Documentation/mca.txt
+F:	drivers/mca/
+F:	include/linux/mca*
 
 MODULE SUPPORT
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	include/linux/module.h
+F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
 W:	http://popies.net/meye/
 S:	Maintained
+F:	Documentation/video4linux/meye.txt
+F:	drivers/media/video/meye.*
+F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 P:	Pavel Pisa
 M:	ppisa@pikron.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://mmc.drzeus.cx/wiki/Controllers/Freescale/SDHC
 S:	Maintained
+F:	drivers/mmc/host/imxmmc.*
 
 MOUSE AND MISC DEVICES [GENERAL]
 P:	Alessandro Rubini
 M:	rubini@ipvvis.unipv.it
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/input/mouse/
+F:	include/linux/gpio_mouse.h
 
 MOXA SMARTIO/INDUSTIO SERIAL CARD (MXSER 2.0)
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/moxa-smartio
+F:	drivers/char/mxser_new.*
 
 MSI LAPTOP SUPPORT
 P:	Lennart Poettering
 M:	mzxreary@0pointer.de
 L:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
+F:	drivers/misc/msi-laptop.c
 
 MTRR AND SIMILAR SUPPORT [i386]
 P:	Richard Gooch
 M:	rgooch@atnf.csiro.au
 L:	linux-kernel@vger.kernel.org
 W:	http://www.atnf.csiro.au/~rgooch/linux/kernel-patches.html
 S:	Maintained
+F:	Documentation/mtrr.txt
+F:	arch/i386/kernel/cpu/mtrr/
+F:	include/asm-i386/mtrr.h
 
 MULTIMEDIA CARD (MMC) AND SECURE DIGITAL (SD) SUBSYSTEM
 P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/mmc/
+F:	include/linux/mmc/
 
 MULTISOUND SOUND DRIVER
 P:	Andrew Veliath
 M:	andrewtv@usa.net
 S:	Maintained
+F:	Documentation/sound/oss/MultiSound
+F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/char/isicom.c
+F:	include/linux/isicom.h
 
 NATSEMI ETHERNET DRIVER (DP8381x)
-P: 	Tim Hockin
+P:	Tim Hockin
 M:	thockin@hockin.org
 S:	Maintained
+F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
 L:	linware@sh.cvut.cz
 S:	Maintained
+F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/NCR_D700.*
 
 NETEM NETWORK EMULATOR
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	netem@lists.linux-foundation.org
 S:	Maintained
+F:	net/sched/sch_netem.c
 
 NETFILTER/IPTABLES/IPCHAINS
 P:	Rusty Russell
 P:	Marc Boucher
 P:	James Morris
 P:	Harald Welte
 P:	Jozsef Kadlecsik
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netfilter-devel@lists.netfilter.org
 L:	netfilter@lists.netfilter.org (subscribers-only)
 L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 S:	Supported
+F:	include/linux/netfilter*
+F:	include/linux/netfilter/
+F:	include/net/netfilter/
+F:	net/*/netfilter.c
+F:	net/*/netfilter/
+F:	net/netfilter/
 
 NETLABEL
 P:	Paul Moore
 M:	paul.moore@hp.com
 W:	http://netlabel.sf.net
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/netlabel
+F:	include/net/netlabel.h
+F:	net/netlabel/
 
 NETROM NETWORK LAYER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/netrom.h
+F:	include/net/netrom.h
+F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
 P:	Paul Clements
 M:	Paul.Clements@steeleye.com
 S:	Maintained
+F:	Documentation/nbd.txt
+F:	drivers/block/nbd.c
+F:	include/linux/nbd.h
 
 NETWORK DEVICE DRIVERS
 P:	Andrew Morton
 M:	akpm@linux-foundation.org
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
+F:	drivers/net/
 
 NETWORKING [GENERAL]
 P:	Networking Team
 M:	netdev@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://linux-net.osdl.org/
 S:	Maintained
+F:	net/
+F:	include/net/
 
 NETWORKING [IPv4/IPv6]
 P:	David S. Miller
 M:	davem@davemloft.net
 P:	Alexey Kuznetsov
 M:	kuznet@ms2.inr.ac.ru
 P:	Pekka Savola (ipv6)
 M:	pekkas@netcore.fi
 P:	James Morris
 M:	jmorris@namei.org
 P:	Hideaki YOSHIFUJI
 M:	yoshfuji@linux-ipv6.org
 P:	Patrick McHardy
 M:	kaber@coreworks.de
 L:	netdev@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
+F:	net/ipv4/
+F:	net/ipv6/
+F:	include/net/ip*
 
 NETWORKING [WIRELESS]
 P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
+F:	net/ieee80211/
+F:	include/net/ieee80211*
 
 NETXEN (1/10) GbE SUPPORT
 P:	Amit S. Kale
 M:	amitkale@netxen.com
 L:	netdev@vger.kernel.org
 W:	http://www.netxen.com
 S:	Supported
+F:	drivers/net/netxen/
 
 IPVS
 P:	Wensong Zhang
 M:	wensong@linux-vs.org
 P:	Simon Horman
 M:	horms@verge.net.au
 P:	Julian Anastasov
 M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/ipvs-sysctl.txt
+F:	net/ipv4/ipvs
 
 NFS CLIENT
 P:	Trond Myklebust
 M:	trond.myklebust@fys.uio.no
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/lockd/
+F:	fs/nfs/
+F:	fs/nfs_common/
+F:	net/sunrpc/
+F:	include/linux/lockd/
+F:	include/linux/nfs*
+F:	include/linux/sunrpc/
 
 NI5010 NETWORK DRIVER
 P:	Jan-Pascal van Best
 M:	janpascal@vanbest.org
 P:	Andreas Mohr
 M:	andi@lisas.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ni5010.*
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
 P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
+F:	Documentation/scsi/NinjaSCSI.txt
+F:	drivers/scsi/pcmcia/nsp_*
 
 NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
 P:	GOTO Masanori
 M:	gotom@debian.or.jp
 P:	YOKOTA Hiroshi
 M:	yokota@netlab.is.tsukuba.ac.jp
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
+F:	Documentation/scsi/NinjaSCSI.txt
+F:	drivers/scsi/nsp32*
 
 NTFS FILESYSTEM
 P:	Anton Altaparmakov
 M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
 W:	http://linux-ntfs.sf.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
+F:	Documentation/filesystems/ntfs.txt
+F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/riva/
+F:	drivers/video/nvidia/
 
 NETERION (S2IO) Xframe 10GbE DRIVER
 P:	Ramkrishna Vepa
 M:	ram.vepa@neterion.com
 P:	Rastapur Santosh
 M:	santosh.rastapur@neterion.com
 P:	Sivakumar Subramani
 M:	sivakumar.subramani@neterion.com
 P:	Sreenivasa Honnur
 M:	sreenivasa.honnur@neterion.com
 L:	netdev@vger.kernel.org
 W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/TitleIndex?anonymous
 S:	Supported
+F:	Documentation/networking/s2io.txt
+F:	drivers/net/s2io*
 
 OPENCORES I2C BUS DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-ocores
+F:	drivers/i2c/busses/i2c-ocores.c
 
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 P:	Mark Fasheh
 M:	mark.fasheh@oracle.com
 P:	Kurt Hackel
 M:	kurt.hackel@oracle.com
 L:	ocfs2-devel@oss.oracle.com
 W:	http://oss.oracle.com/projects/ocfs2/
 S:	Supported
+F:	Documentation/filesystems/ocfs2.txt
+F:	Documentation/filesystems/dlmfs.txt
+F:	fs/ocfs2/
 
 OLYMPIC NETWORK DRIVER
 P:	Peter De Shrijver
 M:	p2@ace.ulyssis.student.kuleuven.ac.be
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
+F:	Documentation/networking/olympic.txt
+F:	drivers/net/tokenring/olympic.*
 
 OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/char/pcmcia/cm4000_cs.c
+F:	include/linux/cm4000_cs.h
 
 OMNIKEY CARDMAN 4040 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/char/pcmcia/cm4040_cs.*
 
 OMNIVISION OV7670 SENSOR DRIVER
-P:   	Jonathan Corbet
+P:	Jonathan Corbet
 M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
+F:	drivers/media/video/ov7670.c
 
 ONENAND FLASH DRIVER
 P:	Kyungmin Park
 M:	kyungmin.park@samsung.com
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
+F:	drivers/mtd/onenand/
+F:	include/linux/mtd/onenand*.h
 
 ONSTREAM SCSI TAPE DRIVER
 P:	Willem Riede
 M:	osst@riede.org
 L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/osst*
+F:	drivers/scsi/st.c
 
 OPROFILE
 P:	Philippe Elie
 M:	phil.el@wanadoo.fr
 L:	oprofile-list@lists.sf.net
 S:	Maintained
+F:	arch/*/oprofile/
+F:	drivers/oprofile/
+F:	include/linux/oprofile.h
 
 ORINOCO DRIVER
 P:	Pavel Roskin
 M:	proski@gnu.org
 P:	David Gibson
 M:	hermes@gibson.dropbear.id.au
 L:	linux-wireless@vger.kernel.org
 L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
+F:	drivers/net/wireless/orinoco*
 
 PA SEMI ETHERNET DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/pasemi_mac.*
 
 PA SEMI SMBUS DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-pasemi.c
 
 PARALLEL PORT SUPPORT
 L:	linux-parport@lists.infradead.org (subscribers-only)
 S:	Orphan
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
 P:	Tim Waugh
 M:	tim@cyberelk.net
 L:	linux-parport@lists.infradead.org (subscribers-only)
 W:	http://www.torque.net/linux-pp.html
 S:	Maintained
+F:	Documentation/paride.txt
+F:	drivers/block/paride/
 
 PARISC ARCHITECTURE
 P:	Matthew Wilcox
 M:	matthew@wil.cx
 P:	Grant Grundler
 M:	grundler@parisc-linux.org
 P:	Kyle McMartin
 M:	kyle@parisc-linux.org
 L:	parisc-linux@parisc-linux.org
 W:	http://www.parisc-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 T:	cvs cvs.parisc-linux.org:/var/cvs/linux-2.6
 S:	Maintained
+F:	arch/parisc/
+F:	include/asm-parisc/
 
 PARAVIRT_OPS INTERFACE
 P:	Jeremy Fitzhardinge
 M:	jeremy@xensource.com
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 P:	Zachary Amsden
 M:	zach@vmware.com
 P:	Rusty Russell
 M:	rusty@rustcorp.com.au
 L:	virtualization@lists.osdl.org
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	arch/i386/kernel/paravirt.c
+F:	include/asm-i386/paravirt.h
+F:	include/asm-um/paravirt.h
 
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/pc87360
+F:	drivers/hwmon/pc87360.c
 
 PC8736x GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/char/pc8736x_gpio.c
 
 PCI ERROR RECOVERY
 P:	Linas Vepstas
 M:	linas@austin.ibm.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@atrey.karlin.mff.cuni.cz
 S:	Supported
+F:	Documentation/pci-error-recovery.txt
+F:	Documentation/powerpc/eeh-pci-error-recovery.txt
 
 PCI SOUND DRIVERS (ES1370, ES1371 and SONICVIBES)
 P:	Thomas Sailer
 M:	sailer@ife.ee.ethz.ch
 L:	linux-sound@vger.kernel.org
 W:	http://www.ife.ee.ethz.ch/~sailer/linux/pciaudio.html
 S:	Maintained
+F:	sound/pci/ens1370.c
+F:	sound/pci/ens1371.c
+F:	sound/pci/sonicvibes.c
 
 PCI SUBSYSTEM
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@atrey.karlin.mff.cuni.cz
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/pci.txt
+F:	drivers/pci/
+F:	include/linux/pci*
 
 PCI HOTPLUG CORE
-P: 	Kristen Carlson Accardi
+P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 S:	Supported
+F:	drivers/pci/hotplug/
+F:	drivers/pci/hotplug.c
+F:	include/linux/pci_hotplug.h
 
 PCIE HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/pcie/
 
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
-L:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
+W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
 T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
+F:	Documentation/pcmcia/
+F:	drivers/*/pcmcia/
+F:	drivers/pcmcia/
+F:	include/pcmcia/
+F:	sound/pcmcia/
 
 PCNET32 NETWORK DRIVER
 P:	Don Fry
 M:	pcnet32@verizon.net
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/pcnet32.c
 
 PER-TASK DELAY ACCOUNTING
 P:	Shailabh Nagar
 M:	nagar@watson.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	include/linux/delayacct.h
+F:	kernel/delayacct.c
 
 PERSONALITY HANDLING
 P:	Christoph Hellwig
 M:	hch@infradead.org
 L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
+F:	include/linux/personality.h
 
 PHRAM MTD DRIVER
 P:	Jörn Engel
 M:	joern@wh.fh-wedel.de
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
+F:	drivers/mtd/devices/phram.c
 
 PKTCDVD DRIVER
 P:	Peter Osterlund
 M:	petero2@telia.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/block/pktcdvd.c
+F:	include/linux/pktcdvd.h
 
 POSIX CLOCKS and TIMERS
 P:	Thomas Gleixner
 M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/timerfd.c
+F:	include/linux/timer*
+F:	kernel/*timer*
 
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
 P:	Anton Vorontsov
 M:	cbou@mail.ru
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-kernel@vger.kernel.org
 L:	kernel-discuss@handhelds.org
 T:	git git.infradead.org/battery-2.6.git
 S:	Maintained
+F:	include/linux/power_supply.h
+F:	drivers/power/power_supply*
 
 POWERPC 4xx EMAC DRIVER
 P:	Eugene Surovegin
 M:	ebs@ebshome.net
 W:	http://kernel.ebshome.net/emac/
 L:	linuxppc-embedded@ozlabs.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ibm_emac/
 
 PNP SUPPORT
 P:	Adam Belay
 M:	ambx1@neo.rr.com
 S:	Maintained
+F:	drivers/pnp/
 
 PNXxxxx I2C DRIVER
 P:	Vitaly Wool
 M:	vitalywool@gmail.com
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-pnx.c
 
 PPP PROTOCOL DRIVERS AND COMPRESSORS
 P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-ppp@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ppp_*
 
 PPP OVER ATM (RFC 2364)
 P:	Mitchell Blank Jr
 M:	mitch@sfgoth.com
 S:	Maintained
+F:	net/atm/pppoatm.c
+F:	include/linux/atmppp.h
 
 PPP OVER ETHERNET
 P:	Michal Ostrowski
 M:	mostrows@speakeasy.net
 S:	Maintained
+F:	drivers/net/pppoe.c
+F:	drivers/net/pppox.c
 
 PPP OVER L2TP
 P:	James Chapman
 M:	jchapman@katalix.com
 S:	Maintained
+F:	drivers/net/pppol2tp.c
+F:	include/linux/if_pppol2tp.h
 
 PREEMPTIBLE KERNEL
 P:	Robert Love
 M:	rml@tech9.net
 L:	linux-kernel@vger.kernel.org
 L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
+F:	Documentation/preempt-locking.txt
+F:	include/linux/preempt.h
 
 PRISM54 WIRELESS DRIVER
 P:	Luis R. Rodriguez
 M:	mcgrof@gmail.com
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 S:	Maintained
+F:	drivers/net/wireless/prism54/
 
 PROMISE DC4030 CACHING DISK CONTROLLER DRIVER
 P:	Peter Denison
 M:	promise@pnd-pc.demon.co.uk
 W:	http://www.pnd-pc.demon.co.uk/promise/
 S:	Maintained
 
 PROMISE SATA TX2/TX4 CONTROLLER LIBATA DRIVER
 P:	Mikael Pettersson
 M:	mikpe@it.uu.se
 L:	linux-ide@vger.kernel.org
 S:	Maintained
+F:	drivers/ata/sata_promise.*
 
 PS3 NETWORK SUPPORT
 P:	Masakazu Mokuno
 M:	mokuno@sm.sony.co.jp
 L:	netdev@vger.kernel.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
+F:	drivers/net/ps3_gelic_net.*
 
 PS3 PLATFORM SUPPORT
 P:	Geoff Levand
 M:	geoffrey.levand@am.sony.com
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/boot/ps3*
+F:	arch/powerpc/platforms/ps3/
+F:	drivers/*/ps3*
+F:	drivers/ps3/
+F:	drivers/usb/host/*ps3.c
+F:	include/asm-powerpc/ps3*
+F:	include/asm-powerpc/lv1call.h
 
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com
 L:	pvrusb2@isely.net	(subscribers-only)
 L:	video4linux-list@redhat.com
 W:	http://www.isely.net/pvrusb2/
 S:	Maintained
+F:	Documentation/video4linux/README.pvrusb2
+F:	drivers/media/video/pvrusb2/
 
 PXA2xx SUPPORT
 P:	Nicolas Pitre
 M:	nico@cam.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
+F:	drivers/pcmcia/pxa2xx*
+F:	drivers/spi/pxa2xx*
+F:	drivers/usb/gadget/pxa2xx*
+F:	sound/soc/pxa/pxa2xx*
 
 PXA MMCI DRIVER
 S:	Orphan
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
 P:	Andrew Vasquez
 M:	linux-driver@qlogic.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	Documentation/scsi/LICENSE.qla2xxx
+F:	drivers/scsi/qla2xxx/
 
 QLOGIC QLA3XXX NETWORK DRIVER
 P:	Ron Mercer
 M:	linux-driver@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/networking/LICENSE.qla3xxx
+F:	drivers/net/qla3xxx.*
 
 QNX4 FILESYSTEM
 P:	Anders Larsen
 M:	al@alarsen.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
+F:	fs/qnx4
+F:	include/linux/qnx4_fs.h
+F:	include/linux/qnxtypes.h
 
 RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/aty/radeon*
+F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 P:	Paul Mackerras
 M:	paulus@samba.org
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/aty/aty128fb.c
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
 P:	Corey Thomas
 M:	corey@world.std.com
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wireless/ray*
 
 RANDOM NUMBER DRIVER
 P:	Matt Mackall
 M:	mpm@selenic.com
 S:	Maintained
+F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
 P:	Matt Porter
 M:	mporter@kernel.crashing.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/rapidio/
 
 READ-COPY UPDATE (RCU)
 P:	Dipankar Sarma
 M:	dipankar@in.ibm.com
 W:	http://www.rdrop.com/users/paulmck/rclock/
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	Documentation/RCU/rcu.txt
+F:	Documentation/RCU/rcuref.txt
+F:	include/linux/rcupdate.h
+F:	include/linux/srcu.h
+F:	kernel/rcupdate.c
 
 RCUTORTURE MODULE
 P:	Josh Triplett
 M:	josh@freedesktop.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/RCU/torture.txt
+F:	kernel/rcutorture.c
 
 REAL TIME CLOCK DRIVER
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/rtc.txt
+F:	drivers/rtc/
+F:	include/linux/rtc.h
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 P:	Alessandro Zummo
 M:	a.zummo@towertech.it
 L:	rtc-linux@googlegroups.com
 S:	Maintained
+F:	Documentation/rtc.txt
+F:	drivers/rtc/
+F:	include/linux/rtc.h
 
 REISERFS FILE SYSTEM
 P:	Hans Reiser
 M:	reiserfs-dev@namesys.com
 L:	reiserfs-devel@vger.kernel.org
 W:	http://www.namesys.com
 S:	Supported
+F:	fs/reiserfs/
 
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
 S:	Maintained
+F:	Documentation/rocket.txt
+F:	drivers/char/rocket*
 
 ROSE NETWORK LAYER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
+F:	include/linux/rose.h
+F:	include/net/rose.h
+F:	net/rose/
 
 RISCOM8 DRIVER
 S:	Orphan
 
 RTL818X WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
 P:	Andrea Merello
 M:	andreamrl@tiscali.it
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
+F:	drivers/net/wireless/rtl818*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 P:	Antonino Daplas
 M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/video/savage/
 
 S390
 P:	Martin Schwidefsky
 M:	schwidefsky@de.ibm.com
 P:	Heiko Carstens
 M:	heiko.carstens@de.ibm.com
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	arch/s390/
+F:	include/asm-s390/
 
 S390 NETWORK DRIVERS
 P:	Frank Pavlic
 M:	fpavlic@de.ibm.com
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	drivers/s390/net/
 
 S390 ZFCP DRIVER
 P:	Swen Schillig
 M:	swen@vnet.ibm.com
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
+F:	Documentation/s390/zfcpdump.txt
+F:	drivers/s390/scsi/zfcp_*
 
 SAA7146 VIDEO4LINUX-2 DRIVER
 P:	Michael Hunold
 M:	michael@mihu.de
 W:	http://www.mihu.de/linux/saa7146
 S:	Maintained
+F:	drivers/media/common/saa7146*
+F:	drivers/media/video/*7146*
+F:	include/media/*7146*
 
 SC1200 WDT DRIVER
 P:	Zwane Mwaikambo
 M:	zwane@arm.linux.org.uk
 S:	Maintained
+F:	drivers/char/watchdog/sc1200wdt.c
 
 SCHEDULER
 P:	Ingo Molnar
 M:	mingo@elte.hu
 P:	Robert Love    [the preemptible kernel bits]
 M:	rml@tech9.net
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	kernel/sched*
 
 SCSI CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-scsi@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
+F:	drivers/scsi/sr*
 
 SCSI SG DRIVER
 P:	Doug Gilbert
 M:	dgilbert@interlog.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.torque.net/sg
 S:	Maintained
+F:	drivers/scsi/sg.c
+F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
 P:	James E.J. Bottomley
 M:	James.Bottomley@SteelEye.com
 L:	linux-scsi@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 S:	Maintained
+F:	drivers/scsi/
+F:	include/scsi/
 
 SCSI TAPE DRIVER
 P:	Kai Mäkisara
 M:	Kai.Makisara@kolumbus.fi
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/scsi/st.txt
+F:	drivers/scsi/st*
 
 SCTP PROTOCOL
 P:	Vlad Yasevich
 M:	vladislav.yasevich@hp.com
 P:	Sridhar Samudrala
 M:	sri@us.ibm.com
 L:	lksctp-developers@lists.sourceforge.net
 W:	http://lksctp.sourceforge.net
 S:	Supported
+F:	Documentation/networking/sctp.txt
+F:	include/linux/sctp.h
+F:	include/net/sctp/
+F:	net/sctp/
 
 SCx200 CPU SUPPORT
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Odd Fixes
+F:	Documentation/i2c/busses/scx200_acb
+F:	arch/i386/kernel/scx200.c
+F:	drivers/char/watchdog/scx200_wdt.c
+F:	drivers/i2c/busses/scx200*
+F:	drivers/mtd/maps/scx200_docflash.c
+F:	include/linux/scx200.h
 
 SCx200 GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/char/scx200_gpio.c
+F:	include/linux/scx200_gpio.h
 
 SCx200 HRT CLOCKSOURCE DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/clocksource/scx200_hrt.c
 
 SECURITY CONTACT
 P:	Security Officers
 M:	security@kernel.org
 S:	Supported
 
 SELINUX SECURITY MODULE
 P:	Stephen Smalley
 M:	sds@tycho.nsa.gov
 P:	James Morris
 M:	jmorris@namei.org
 P:	Eric Paris
 M:	eparis@parisplace.org
-L:	linux-kernel@vger.kernel.org (kernel issues)
-L: 	selinux@tycho.nsa.gov (subscribers-only, general discussion)
+L:	linux-kernel@vger.kernel.org
+L:	selinux@tycho.nsa.gov (subscribers-only)
 W:	http://www.nsa.gov/selinux
 S:	Supported
+F:	include/linux/selinux*
+F:	security/selinux/
 
 SENSABLE PHANTOM
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 S:	Maintained
+F:	drivers/misc/phantom.c
+F:	include/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM:
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
+F:	drivers/ata/
+X:	drivers/ata/sata_promise.*
 
 SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
 P:	Pat Gefre
 M:	pfg@sgi.com
 L:	linux-ia64@vger.kernel.org
 S:	Supported
+F:	Documentation/ia64/serial.txt
 
 SGI VISUAL WORKSTATION 320 AND 540
 P:	Andrey Panin
 M:	pazke@donpac.ru
 L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
 M:	support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
+F:	arch/arm/mach-ebsa110/
+F:	include/asm-arm/arch-ebsa110/
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
 P:	Vincent Sanders
 M:	support@simtec.co.uk
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
+F:	Documentation/arm/Samsung-S3C24XX/EB2410ITX.txt
+F:	arch/arm/mach-s3c2410/
+F:	drivers/*/*s3c2410*
+F:	drivers/*/*/*s3c2410*
+F:	include/asm-arm/arch-s3c2410/
 
 SIS 190 ETHERNET DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sis190.c
 
 SIS 5513 IDE CONTROLLER DRIVER
 P:	Lionel Bouton
 M:	Lionel.Bouton@inet6.fr
 W:	http://inet6.dyn.dhs.org/sponsoring/sis5513/index.html
 W:	http://gyver.homeip.net/sis5513/index.html
 S:	Maintained
+F:	drivers/ide/pci/sis5513.c
 
 SIS 900/7016 FAST ETHERNET DRIVER
 P:	Daniele Venzano
 M:	venza@brownhat.org
 W:	http://www.brownhat.org/sis900.html
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sis900.*
 
 SIS 96X I2C/SMBUS DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-sis96x
+F:	drivers/i2c/busses/i2c-sis96x.c
 
 SIS FRAMEBUFFER DRIVER
 P:	Thomas Winischhofer
 M:	thomas@winischhofer.net
 W:	http://www.winischhofer.net/linuxsisvga.shtml
 S:	Maintained
+F:	Documentation/fb/sisfb.txt
+F:	drivers/video/sis/
+F:	include/video/sisfb.h
 
 SIS USB2VGA DRIVER
 P:	Thomas Winischhofer
 M:	thomas@winischhofer.net
 W:	http://www.winischhofer.at/linuxsisusbvga.shtml
 S:	Maintained
+F:	drivers/usb/misc/sisusbvga/
 
-SLAB ALLOCATOR
+SLAB/SLOB/SLUB ALLOCATORS
 P:	Christoph Lameter
 M:	clameter@sgi.com
 P:	Pekka Enberg
 M:	penberg@cs.helsinki.fi
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/sl?b*.h
+F:	mm/sl?b.c
 
 SMC91x ETHERNET DRIVER
 P:	Nicolas Pitre
 M:	nico@cam.org
 S:	Maintained
+F:	drivers/net/smc91x.*
 
 SMSC47B397 HARDWARE MONITOR DRIVER
 P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/smsc47b397
+F:	drivers/hwmon/smsc47b397.c
 
 SOFTMAC LAYER (IEEE 802.11)
 P:	Johannes Berg
 M:	johannes@sipsolutions.net
 P:	Joe Jezak
 M:	josejx@gentoo.org
 P:	Daniel Drake
 M:	dsd@gentoo.org
 W:	http://softmac.sipsolutions.net/
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
+F:	include/net/ieee80211softmac*
+F:	net/ieee80211/softmac/
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
 P:	Neil Brown
 M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
-
-HIBERNATION (aka Software Suspend, aka swsusp):
-P:	Pavel Machek
-M:	pavel@suse.cz
-P:	Rafael J. Wysocki
-M:	rjw@sisk.pl
-L:	linux-pm@lists.linux-foundation.org
-S:	Supported
+F:	drivers/md/
+F:	include/linux/raid/
 
 SUSPEND TO RAM:
 P:	Pavel Machek
 M:	pavel@suse.cz
 P:	Rafael J. Wysocki
 M:	rjw@sisk.pl
 L:	linux-pm@lists.linux-foundation.org
 S:	Maintained
+F:	Documentation/power/
+F:	arch/i386/kernel/acpi/
+F:	arch/x86_64/kernel/acpi/
+F:	arch/x86_64/kernel/suspend.c
+F:	drivers/base/power/
+F:	kernel/power/
+F:	include/linux/suspend.h
+F:	include/linux/freezer.h
+F:	include/linux/pm.h
+F:	include/asm-*/suspend.h
 
 SONIC NETWORK DRIVER
 P:	Thomas Bogendoerfer
 M:	tsbogend@alpha.franken.de
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/sonic.*
 
 SONY VAIO CONTROL DEVICE DRIVER
 P:	Mattia Dongili
 M:	malattia@linux.it
 L:	linux-acpi@vger.kernel.org
 W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
 S:	Maintained
+F:	drivers/char/sonypi.c
+F:	drivers/misc/sony-laptop.c
 
 SOUND
 P:	Jaroslav Kysela
 M:	perex@suse.cz
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Maintained
+F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT
 P:	Liam Girdwood
 M:	liam.girdwood@wolfsonmicro.com
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Supported
+F:	sound/soc/
 
 SPI SUBSYSTEM
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/spi/
+F:	drivers/spi/
+F:	include/linux/spi/
 
 STABLE BRANCH:
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	stable@kernel.org
 S:	Maintained
 
 TPM DEVICE DRIVER
 P:	Kylene Hall
 M:	kjhall@us.ibm.com
 W:	http://tpmdd.sourceforge.net
 P:	Marcel Selhorst
 M:	tpm@selhorst.net
 W:	http://www.prosec.rub.de/tpm/
 L:	tpmdd-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/char/tpm/
 
 Telecom Clock Driver for MCPL0010
 P:	Mark Gross
 M:	mark.gross@intel.com
 S:	Supported
 
 TENSILICA XTENSA PORT (xtensa):
 P:	Chris Zankel
 M:	chris@zankel.net
 S:	Maintained
+F:	arch/xtensa/
+F:	include/asm-xtensa/
 
 THINKPAD ACPI EXTRAS DRIVER
 P:	Henrique de Moraes Holschuh
 M:	ibm-acpi@hmh.eng.br
 L:	ibm-acpi-devel@lists.sourceforge.net
 W:	http://ibm-acpi.sourceforge.net
 W:	http://thinkwiki.org/wiki/Ibm-acpi
 T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 S:	Maintained
 
 UltraSPARC (sparc64):
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 S:	Maintained
+F:	arch/sparc64/
+F:	include/asm-sparc64/
 
 SHARP LH SUPPORT (LH7952X & LH7A40X)
 P:	Marc Singer
 M:	elf@buici.com
 W:	http://projects.buici.com/arm
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
+F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
+F:	arch/arm/mach-lh7a40x/
+F:	drivers/serial/serial_lh7a40x.c
+F:	drivers/*/*/*lh7a40*
+F:	include/asm-arm/arch-lh7a40x/
 
 SHPC HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/shpchp*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE DRIVER
 P:	Pierre Ossman
 M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
 W:	http://mmc.drzeus.cx/wiki/Linux/Drivers/sdhci
 S:	Maintained
+F:	drivers/mmc/host/sdhci.*
 
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
 P:	Stephen Hemminger
 M:	shemminger@linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/skge.*
+F:	drivers/net/sky2.*
 
 SOEKRIS NET48XX LED SUPPORT
 P:	Chris Boot
 M:	bootc@bootc.net
 S:	Maintained
+F:	drivers/leds/leds-net48xx.c
 
 SPARC (sparc32):
 P:	William L. Irwin
 M:	wli@holomorphy.com
 L:	sparclinux@vger.kernel.org
 S:	Maintained
+F:	arch/sparc/
+F:	include/asm-sparc/
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
 P:	Roger Wolff
 M:	R.E.Wolff@BitWizard.nl
 L:	linux-kernel@vger.kernel.org ?
 S:	Supported
+F:	drivers/char/specialix*
 
 SPIDERNET NETWORK DRIVER for CELL
 P:	Linas Vepstas
 M:	linas@austin.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/networking/spider_net.txt
+F:	drivers/net/spider_net*
 
 SRM (Alpha) environment access
 P:	Jan-Benedict Glaw
 M:	jbglaw@lug-owl.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	arch/alpha/kernel/srm_env.c
 
 STARFIRE/DURALAN NETWORK DRIVER
 P:	Ion Badulescu
 M:	ionut@cs.columbia.edu
 S:	Maintained
+F:	drivers/net/starfire*
 
 STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
 W:	http://mosquitonet.Stanford.EDU/strip.html
 S:	Unsupported ?
+F:	drivers/net/wireless/strip.c
+F:	include/linux/if_strip.h
 
 STRADIS MPEG-2 DECODER DRIVER
 P:	Nathan Laredo
 M:	laredo@gnu.org
 W:	http://www.stradis.com/
 S:	Maintained
+F:	drivers/media/video/stradis.c
 
 SUPERH (sh)
 P:	Paul Mundt
 M:	lethal@linux-sh.org
 L:	linuxsh-dev@lists.sourceforge.net (subscribers-only)
 W:	http://www.linux-sh.org
 S:	Maintained
+F:	arch/sh/
+F:	include/asm-sh/
 
 SUPERH64 (sh64)
 P:	Paul Mundt
 M:	lethal@linux-sh.org
 L:	linuxsh-shmedia-dev@lists.sourceforge.net
 W:	http://www.linux-sh.org
 S:	Maintained
+F:	arch/sh64/
+F:	include/asm-sh64/
 
 SUN3/3X
 P:	Sam Creasey
 M:	sammy@sammy.net
 W:	http://sammy.net/sun3/
 S:	Maintained
+F:	arch/m68k/kernel/*sun3*
+F:	arch/m68k/sun3/
+F:	include/asm-m68k/sun3-head.h
 
 SVGA HANDLING
 P:	Martin Mares
 M:	mj@ucw.cz
-L:	linux-video@atrey.karlin.mff.cuni.cz
+L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/svga.txt
+F:	arch/i386/boot/video*
 
 SYSV FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
 S:	Maintained
+F:	Documentation/filesystems/sysv-fs.txt
+F:	fs/sysv/
+F:	include/linux/sysv_fs.h
 
 TC CLASSIFIER
 P:	Jamal Hadi Salim
 M:	hadi@cyberus.ca
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	include/linux/pkt_cls.h
+F:	include/net/pkt_cls.h
+F:	net/sched/
 
 TCP LOW PRIORITY MODULE
 P:	Wong Hoi Sing, Edison
 M:	hswong3i@gmail.com
 P:	Hung Hing Lun, Mike
 M:	hlhung3i@gmail.com
 W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
+F:	net/ipv4/tcp_lp.c
 
 TI FLASH MEDIA INTERFACE DRIVER
-P:      Alex Dubov
-M:      oakad@yahoo.com
-S:      Maintained
+P:	Alex Dubov
+M:	oakad@yahoo.com
+S:	Maintained
+F:	drivers/misc/tifm*
+F:	drivers/mmc/host/tifm_sd.c
 
 TI OMAP MMC INTERFACE DRIVER
 P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
 M:	linux-omap-open-source@linux.omap.com 
 W:	http://linux.omap.com
 W:	http://www.muru.com/linux/omap/
 S:	Maintained
 
 TI OMAP RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
 S:	Maintained
+F:	drivers/char/hw_random/omap-rng.c
 
 TASKSTATS STATISTICS INTERFACE
 P:	Shailabh Nagar
 M:	nagar@watson.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/accounting/taskstats*
+F:	include/linux/taskstats*
+F:	kernel/taskstats.c
 
 TI PARALLEL LINK CABLE DRIVER
 P:	Romain Lievin
 M:	roms@lpg.ticalc.org
 S:	Maintained
+F:	Documentation/tipar.txt
+F:	drivers/char/tipar.c
+F:	include/linux/ticable.h
 
 TIPC NETWORK LAYER
 P:	Per Liden
 M:	per.liden@ericsson.com
 P:	Jon Maloy
 M:	jon.maloy@ericsson.com
 P:	Allan Stephens
 M:	allan.stephens@windriver.com
 L:	tipc-discussion@lists.sourceforge.net
 W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
 T:	git tipc.cslab.ericsson.net:/pub/git/tipc.git
 S:	Maintained
+F:	include/linux/tipc*.h
+F:	include/net/tipc/
+F:	net/tipc/
 
 TLAN NETWORK DRIVER
 P:	Samuel Chessman
 M:	chessman@tux.org
 L:	tlan-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
+F:	Documentation/networking/tlan.txt
+F:	drivers/net/tlan.*
 
 TOKEN-RING NETWORK DRIVER
 P:	Mike Phillips
 M:	mikep@linuxtr.net
 L:	netdev@vger.kernel.org
-L:	linux-tr@linuxtr.net
 W:	http://www.linuxtr.net
 S:	Maintained
+F:	drivers/net/tokenring/
+F:	net/802/tr.c
 
 TOSHIBA ACPI EXTRAS DRIVER
 P:	John Belmonte
 M:	toshiba_acpi@memebeam.org
 W:	http://memebeam.org/toys/ToshibaAcpiDriver
 S:	Maintained
+F:	drivers/acpi/toshiba_acpi.c
 
 TOSHIBA SMM DRIVER
 P:	Jonathan Buzzard
 M:	jonathan@buzzard.org.uk
 L:	tlinux-users@tce.toshiba-dme.co.jp
 W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
+F:	drivers/char/toshiba.c
+F:	include/linux/toshiba.h
 
 TRIDENT 4DWAVE/SIS 7018 PCI AUDIO CORE
 P:	Muli Ben-Yehuda
 M:	mulix@mulix.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	sound/oss/trident*
 
 TRIVIAL PATCHES
 P:	Adrian Bunk
 M:	trivial@kernel.org
 L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/
 T:	git kernel.org:/pub/scm/linux/kernel/git/bunk/trivial.git
 S:	Maintained
 
 TMS380 TOKEN-RING NETWORK DRIVER
 P:	Adam Fritzler
 M:	mid@auk.cx
-L:	linux-tr@linuxtr.net
+L:	netdev@vger.kernel.org
 W:	http://www.auk.cx/tms380tr/
 S:	Maintained
+F:	Documentation/networking/tms380tr.txt
+F:	drivers/net/tokenring/tms380tr.*
 
 TULIP NETWORK DRIVER
 L:	tulip-users@lists.sourceforge.net
 W:	http://sourceforge.net/projects/tulip/
 S:	Orphan
+F:	drivers/net/tulip/
 
 TUN/TAP driver
 P:	Maxim Krasnyansky
 M:	maxk@qualcomm.com
 L:	vtun@office.satix.net
 W:	http://vtun.sourceforge.net/tun
 S:	Maintained
+F:	Documentation/networking/tuntap.txt
+F:	arch/um/os-Linux/drivers/
 
 TURBOCHANNEL SUBSYSTEM
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/tc/
+F:	include/linux/tc.h
 
 U14-34F SCSI DRIVER
 P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/u14-34f.c
 
 UDF FILESYSTEM
 P:	Ben Fennema
 M:	bfennema@falcon.csc.calpoly.edu
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
+F:	Documentation/filesystems/udf.txt
+F:	fs/udf/
 
 UNIFORM CDROM DRIVER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
+F:	Documentation/cdrom/
+F:	drivers/cdrom/cdrom.c
+F:	include/linux/cdrom.h
 
 USB ACM DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/usb/acm.txt
+F:	drivers/usb/class/cdc-acm.*
 
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
 L:	linux-kernel@vger.kernel.org
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Supported
+F:	drivers/block/ub.c
 
 USB CDC ETHERNET DRIVER
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
 W:	http://www.kroah.com/linux-usb/
+F:	drivers/net/usb/cdc_*.c
+F:	include/linux/usb/cdc.h
 
 USB DAVICOM DM9601 DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
+F:	drivers/net/usb/dm9601.c
 
 USB EHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Odd Fixes
+F:	Documentation/usb/ehci.txt
+F:	drivers/usb/host/ehci*
 
 USB ET61X[12]51 DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.linux-usb.org/gadget
 S:	Maintained
+F:	drivers/usb/gadget/
+F:	include/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-usb-devel@lists.sourceforge.net
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
-
-USB HUB DRIVER
-P:	Johannes Erdfelt
-M:	johannes@erdfelt.com
-L:	linux-usb-users@lists.sourceforge.net
-L:	linux-usb-devel@lists.sourceforge.net
-S:	Maintained
+F:	Documentation/usb/hiddev.txt
+F:	drivers/hid/usbhid/
 
 USB ISP116X DRIVER
 P:	Olav Kongas
 M:	ok@artecdesign.ee
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/host/isp116x*
+F:	include/linux/usb/isp116x.h
 
 USB KAWASAKI LSI DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/kl5kusb105.*
 
 USB MASS STORAGE DRIVER
 P:	Matthew Dharm
 M:	mdharm-usb@one-eyed-alien.net
 L:	linux-usb-users@lists.sourceforge.net
 L:	usb-storage@lists.one-eyed-alien.net
 S:	Maintained
 W:	http://www.one-eyed-alien.net/~mdharm/linux-usb/
+F:	drivers/usb/storage/
 
 USB OHCI DRIVER
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Odd Fixes
+F:	Documentation/usb/ohci.txt
+F:	drivers/usb/host/ohci*
 
 USB OPTION-CARD DRIVER
 P:	Matthias Urlichs
 M:	smurf@smurf.noris.de
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/option.c
 
 USB OV511 DRIVER
 P:	Mark McClelland
 M:	mmcclell@bigfoot.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://alpha.dyndns.org/ov511/
 S:	Maintained
+F:	drivers/media/video/ov511.*
 
 USB PEGASUS DRIVER
 P:	Petko Manolov
 M:	petkan@users.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
+F:	drivers/net/usb/pegasus.*
 
 USB PRINTER DRIVER (usblp)
 P:	Pete Zaitcev
 M:	zaitcev@redhat.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Supported
+F:	drivers/usb/class/usblp.c
 
 USB RTL8150 DRIVER
 P:	Petko Manolov
 M:	petkan@users.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
+F:	drivers/net/usb/rtl8150.c
 
 USB SE401 DRIVER
 P:	Jeroen Vreeken
 M:	pe1rxq@amsat.org
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.chello.nl/~j.vreeken/se401/
 S:	Maintained
 
 USB SERIAL CYBERJACK DRIVER
 P:	Matthias Bruestle and Harald Welte
 M:	support@reiner-sct.com
 W:	http://www.reiner-sct.de/support/treiber_cyberjack.php
 S:	Maintained
+F:	drivers/usb/serial/cyberjack.c
 
 USB SERIAL DIGI ACCELEPORT DRIVER
-P:	Peter Berger and Al Borchers
+P:	Peter Berger
 M:	pberger@brimson.com
+P:	Al Borchers
 M:	alborchers@steinerpoint.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/digi_acceleport.c
 
 USB SERIAL DRIVER
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Supported
+F:	Documentation/usb/usb-serial.txt
+F:	drivers/usb/serial/generic.c
+F:	drivers/usb/serial/usb-serial.c
+F:	include/linux/usb/serial.h
 
 USB SERIAL BELKIN F5U103 DRIVER
 P:	William Greathouse
 M:	wgreathouse@smva.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/belkin_sa.*
 
 USB SERIAL CYPRESS M8 DRIVER
 P:	Lonnie Mendez
 M:	dignome@gmail.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
 W:	http://geocities.com/i0xox0i
 W:	http://firstlight.net/cvs
+F:	drivers/usb/serial/cypress_m8.*
 
 USB SERIAL CYBERJACK PINPAD/E-COM DRIVER
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/cyberjack.c
 
 USB AUERSWALD DRIVER
 P:	Wolfgang Muees
 M:	wolfgang@iksw-muees.de
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/misc/auerswald.c
 
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker
 M:	xavyer@ix.netcom.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/empeg.c
 
 USB SERIAL KEYSPAN DRIVER
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.kroah.com/linux/
 S:	Maintained
+F:	drivers/usb/serial/*keyspan*
 
 USB SERIAL WHITEHEAT DRIVER
 P:	Support Department
 M:	support@connecttech.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.connecttech.com
 S:	Supported
+F:	drivers/usb/serial/whiteheat*
 
 USB SN9C1xx DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/sn9c102.txt
+F:	drivers/media/video/sn9c102/
 
 USB SUBSYSTEM
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.linux-usb.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/usb/
+F:	drivers/net/usb/
+F:	drivers/usb/
+F:	include/linux/usb.h
+F:	include/linux/usb/
 
 USB UHCI DRIVER
 P:	Alan Stern
 M:	stern@rowland.harvard.edu
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/usb/uhci.txt
+F:	drivers/usb/host/uhci*
 
 USB "USBNET" DRIVER FRAMEWORK
 P:	David Brownell
 M:	dbrownell@users.sourceforge.net
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
+F:	drivers/net/usb/usbnet.*
 
 USB W996[87]CF DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/w9968cf.txt
+F:	drivers/media/video/w996*
 
 USB ZC0301 DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/zc0301.txt
+F:	drivers/media/video/zc0301/
 
 USB ZD1201 DRIVER
 P:	Jeroen Vreeken
 M:	pe1rxq@amsat.org
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://linux-lc100020.sourceforge.net
 S:	Maintained
+F:	drivers/net/wireless/zd1201.*
 
 USB ZR364XX DRIVER
 P:	Antoine Jacquet
 M:	royale@zerezo.com
 L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
+F:	Documentation/video4linux/zr364xx.txt
+F:	drivers/media/video/zr364xx.c
 
 USER-MODE LINUX
 P:	Jeff Dike
 M:	jdike@karaya.com
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
 S:	Maintained
+F:	Documentation/uml/UserModeLinux-HOWTO.txt
+F:	arch/um/
+F:	include/asm-um/
+F:	fs/hostfs/
+F:	fs/hppfs/
 
 FAT/VFAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/vfat.txt
+F:	fs/fat/
+F:	fs/msdos/
+F:	fs/vfat/
 
 VIA 82Cxxx AUDIO DRIVER (old OSS driver)
 P:	Jeff Garzik
 S:	Odd fixes
+F:	sound/oss/via82cxxx_audio.c
 
 VIA RHINE NETWORK DRIVER
 P:	Roger Luethi
 M:	rl@hellgate.ch
 S:	Maintained
+F:	drivers/net/via-rhine.c
 
 VIAPRO SMBUS DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-viapro
+F:	drivers/i2c/busses/i2c-viapro.c
 
 VIA VELOCITY NETWORK DRIVER
 P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/via-velocity.*
 
 UCLINUX (AND M68KNOMMU)
 P:	Greg Ungerer
 M:	gerg@uclinux.org
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
+F:	arch/m68knommu/
+F:	include/asm-m68knommu/
 
 UCLINUX FOR NEC V850
 P:	Miles Bader
 
 UCLINUX FOR RENESAS H8/300
 P:	Yoshinori Sato
 M:	ysato@users.sourceforge.jp
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
 
 UFS FILESYSTEM
 P:	Evgeniy Dushistov
 M:	dushistov@mail.ru
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/ufs.txt
+F:	fs/ufs/
 
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
 M:	miquel@df.uba.ar
 L:	rio500-users@lists.sourceforge.net
 W:	http://rio500.sourceforge.net
 S:	Maintained
+F:	drivers/usb/misc/rio500*
 
 VIDEO FOR LINUX
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
+P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/video4linux/
+F:	drivers/media/video/
+F:	drivers/media/radio/
+F:	include/linux/video_decoder.h
+F:	include/linux/videodev.h
+F:	include/linux/videodev2.h
+F:	include/media/
 
 VT1211 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger
 M:	juergh@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/vt1211
+F:	drivers/hwmon/vt1211.c
 
 VT8231 HARDWARE MONITOR DRIVER
 P:	Roger Lucas
 M:	roger@planbit.co.uk
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	drivers/hwmon/vt8231.c
 
 W1 DALLAS'S 1-WIRE BUS
 P:	Evgeniy Polyakov
 M:	johnpol@2ka.mipt.ru
 S:	Maintained
+F:	Documentation/w1/
+F:	drivers/w1/
 
 W83791D HARDWARE MONITORING DRIVER
 P:	Charles Spirakis
 M:	bezaur@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/w83791d
+F:	drivers/hwmon/w83791d.c
 
 W83793 HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/w83793
+F:	drivers/hwmon/w83793.c
 
 W83L51xD SD/MMC CARD INTERFACE DRIVER
 P:	Pierre Ossman
 M:	drzeus-wbsd@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 W:	http://projects.drzeus.cx/wbsd
 S:	Maintained
+F:	drivers/mmc/host/wbsd.*
 
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
 M:	wim@iguana.be
 T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
+F:	Documentation/watchdog/
+F:	drivers/char/watchdog/
+F:	include/linux/watchdog.h
 
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
 P:	Jean Tourrilhes
 M:	jt@hpl.hp.com
 L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
+F:	Documentation/networking/wavelan.txt
+F:	drivers/net/wireless/wavelan*
 
 WD7000 SCSI DRIVER
 P:	Miroslav Zagorac
 M:	zaga@fly.cc.fer.hr
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/wd7000.c
 
 WISTRON LAPTOP BUTTON DRIVER
 P:	Miloslav Trmac
 M:	mitr@volny.cz
 S:	Maintained
+F:	drivers/input/misc/wistron_btns.c
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
 L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
+F:	drivers/net/wireless/wl3501*
 
 X.25 NETWORK LAYER
 P:	Henner Eisen
 M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/x25*
+F:	include/net/x25*
+F:	net/x25/
 
 XEN HYPERVISOR INTERFACE
 P:	Jeremy Fitzhardinge
 M:	jeremy@xensource.com
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	virtualization@lists.osdl.org
 L:	xen-devel@lists.xensource.com
 S:	Supported
+F:	arch/i386/xen/
+F:	drivers/*/xen-*front.c
+F:	drivers/xen/
+F:	include/asm-i386/xen/
+F:	include/xen/
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
 P:	Tim Shimmin
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
+F:	Documentation/filesystems/xfs.txt
+F:	fs/xfs/
 
 XILINX UARTLITE SERIAL DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	linux-serial@vger.kernel.org
 S:	Maintained
+F:	drivers/serial/uartlite.c
 
 X86 3-LEVEL PAGING (PAE) SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
 S:	Maintained
 
 X86-64 port
 P:	Andi Kleen
 M:	ak@suse.de
 L:	discuss@x86-64.org
 W:	http://www.x86-64.org
 T:	quilt ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current
 S:	Maintained
+F:	Documentation/x86_64/
+F:	arch/x86_64/
+F:	include/asm-x86_64/
 
 YAM DRIVER FOR AX.25
 P:	Jean-Paul Roubelat
 M:	jpr@f6fbb.org
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	drivers/net/hamradio/yam*
+F:	include/linux/yam.h
 
 YEALINK PHONE DRIVER
 P:	Henk Vergonet
 M:	Henk.Vergonet@gmail.com
 L:	usbb2k-api-dev@nongnu.org
 S:	Maintained
+F:	Documentation/input/yealink.txt
+F:	drivers/input/misc/yealink.*
+F:	drivers/input/misc/map_to_7segment.h
 
 Z8530 DRIVER FOR AX.25
 P:	Joerg Reuter
 M:	jreuter@yaina.de
 W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/z8530drv.txt
+F:	drivers/net/*scc.c
+F:	drivers/net/hamradio/z8530.h
 
 ZD1211RW WIRELESS DRIVER
 P:	Daniel Drake
 M:	dsd@gentoo.org
 P:	Ulrich Kunitz
 M:	kune@deine-taler.de
 W:	http://zd1211.ath.cx/wiki/DriverRewrite
 L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
+F:	drivers/net/wireless/zd1211rw/
 
 ZF MACHZ WATCHDOG
 P:	Fernando Fuganti
 M:	fuganti@netbank.com.br
 W:	http://cvs.conectiva.com.br/drivers/ZFL-watchdog/
 S:	Maintained
+F:	drivers/char/watchdog/machzwd.c
 
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
 M:	rbultje@ronald.bitfreak.net
 L:	mjpeg-users@lists.sourceforge.net
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 S:	Maintained
-
-ZR36120 VIDEO FOR LINUX DRIVER
-P:	Pauline Middelink
-M:	middelin@polyware.nl
-W:	http://www.polyware.nl/~middelin/En/hobbies.html
-W:	http://www.polyware.nl/~middelin/hobbies.html
-S:	Maintained
+F:	drivers/media/video/zoran_*
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
+F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
 S:	Buried alive in reporters


