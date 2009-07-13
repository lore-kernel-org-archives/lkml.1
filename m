Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZGMV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZGMV6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZGMV6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:58:48 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4143 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483AbZGMV6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:58:37 -0400
Subject: [PATCH] MAINTAINERS: Coalesce name and email address lines
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jul 2009 14:58:19 -0700
Message-Id: <1247522300.4008.37.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 14:14 -0700, Joe Perches wrote:
> A collection of cleanup patches to MAINTAINERS

I ran the script I submitted awhile back on MAINTAINERS
after these [0/16] patches are applied.

http://lkml.org/lkml/2009/6/1/275

I think the result is useful for people that rely
on copy and paste of email addresses.

Signed-off-by: Joe Perches <joe@perches.com>

 MAINTAINERS | 2722 ++++++++++++++++++++---------------------------------------
 1 files changed, 908 insertions(+), 1814 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5befb1c..f64b085 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -73,8 +73,8 @@ Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
-P: Person
-M: Mail patches to
+P: Person (obsolete)
+M: Mail patches to: FullName <address@domain>
 L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
@@ -104,67 +104,58 @@ X: Files and directories that are NOT maintained, same rules as F:
    matches all files in and below net excluding net/ipv6/
 
 3C505 NETWORK DRIVER
-P:	Philip Blundell
-M:	philb@gnu.org
+M:	Philip Blundell <philb@gnu.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/3c505*
 
 3C59X NETWORK DRIVER
-P:	Steffen Klassert
-M:	klassert@mathematik.tu-chemnitz.de
+M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/vortex.txt
 F:	drivers/net/3c59x.c
 
 3CR990 NETWORK DRIVER
-P:	David Dillow
-M:	dave@thedillows.org
+M:	David Dillow <dave@thedillows.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/typhoon*
 
 3W-9XXX SATA-RAID CONTROLLER DRIVER
-P:	Adam Radford
-M:	linuxraid@amcc.com
+M:	Adam Radford <linuxraid@amcc.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
 F:	drivers/scsi/3w-9xxx*
 
 3W-XXXX ATA-RAID CONTROLLER DRIVER
-P:	Adam Radford
-M:	linuxraid@amcc.com
+M:	Adam Radford <linuxraid@amcc.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
 F:	drivers/scsi/3w-xxxx*
 
 53C700 AND 53C700-66 SCSI DRIVER
-P:	James E.J. Bottomley
-M:	James.Bottomley@HansenPartnership.com
+M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/53c700*
 
 6PACK NETWORK DRIVER FOR AX.25
-P:	Andreas Koensgen
-M:	ajk@iehk.rwth-aachen.de
+M:	Andreas Koensgen <ajk@iehk.rwth-aachen.de>
 L:	linux-hams@vger.kernel.org
 S:	Maintained
 F:	drivers/net/hamradio/6pack.c
 
 8169 10/100/1000 GIGABIT ETHERNET DRIVER
-P:	Francois Romieu
-M:	romieu@fr.zoreil.com
+M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
-P:	Alan Cox
-M:	alan@lxorguk.ukuu.org.uk
+M:	Alan Cox <alan@lxorguk.ukuu.org.uk>
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
 S:	Odd Fixes
@@ -172,20 +163,16 @@ F:	drivers/serial/8250*
 F:	include/linux/serial_8250.h
 
 8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULTRA, NE2000, 3C503, etc.]
-P:	Paul Gortmaker
-M:	p_gortmaker@yahoo.com
+M:	Paul Gortmaker <p_gortmaker@yahoo.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/*8390*
 F:	drivers/net/ax88796.c
 
 9P FILE SYSTEM
-P:	Eric Van Hensbergen
-M:	ericvh@gmail.com
-P:	Ron Minnich
-M:	rminnich@sandia.gov
-P:	Latchesar Ionkov
-M:	lucho@ionkov.net
+M:	Eric Van Hensbergen <ericvh@gmail.com>
+M:	Ron Minnich <rminnich@sandia.gov>
+M:	Latchesar Ionkov <lucho@ionkov.net>
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
 T:	git git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
@@ -194,15 +181,13 @@ F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
-P:	Enver Haase
-M:	A2232@gmx.net
+M:	Enver Haase <A2232@gmx.net>
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 F:	drivers/char/ser_a2232*
 
 AACRAID SCSI RAID DRIVER
-P:	Adaptec OEM Raid Solutions
-M:	aacraid@adaptec.com
+M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Supported
@@ -210,44 +195,38 @@ F:	Documentation/scsi/aacraid.txt
 F:	drivers/scsi/aacraid/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
-P:	Hans de Goede
-M:	j.w.r.degoede@hhs.nl
+M:	Hans de Goede <j.w.r.degoede@hhs.nl>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/abituguru.c
 
 ABIT UGURU 3 HARDWARE MONITOR DRIVER
-P:	Alistair John Strachan
-M:	alistair@devzero.co.uk
+M:	Alistair John Strachan <alistair@devzero.co.uk>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/abituguru3.c
 
 ACENIC DRIVER
-P:	Jes Sorensen
-M:	jes@trained-monkey.org
+M:	Jes Sorensen <jes@trained-monkey.org>
 L:	linux-acenic@sunsite.dk
 S:	Maintained
 F:	drivers/net/acenic*
 
 ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
-P:	Peter Feuerer
-M:	peter@piie.net
+M:	Peter Feuerer <peter@piie.net>
 W:	http://piie.net/?section=acerhdf
 S:	Maintained
 F:	drivers/platform/x86/acerhdf.c
 
 ACER WMI LAPTOP EXTRAS
-P:	Carlos Corbacho
-M:	carlos@strangeworlds.co.uk
+M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
 L:	aceracpi@googlegroups.com (subscribers-only)
 W:	http://code.google.com/p/aceracpi
 S:	Maintained
 F:	drivers/platform/x86/acer-wmi.c
 
 ACPI
-P:	Len Brown
-M:	lenb@kernel.org
+M:	Len Brown <lenb@kernel.org>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
@@ -257,8 +236,7 @@ F:	drivers/pnp/pnpacpi/
 F:	include/linux/acpi.h
 
 ACPI BATTERY DRIVERS
-P:	Alexey Starikovskiy
-M:	astarikovskiy@suse.de
+M:	Alexey Starikovskiy <astarikovskiy@suse.de>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
@@ -266,80 +244,69 @@ F:	drivers/acpi/battery.c
 F:	drivers/acpi/*sbs*
 
 ACPI EC DRIVER
-P:	Alexey Starikovskiy
-M:	astarikovskiy@suse.de
+M:	Alexey Starikovskiy <astarikovskiy@suse.de>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/ec.c
 
 ACPI FAN DRIVER
-P:	Zhang Rui
-M:	rui.zhang@intel.com
+M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/fan.c
 
 ACPI PCI HOTPLUG DRIVER
-P:	Kristen Carlson Accardi
-M:	kristen.c.accardi@intel.com
+M:	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/hotplug/acpi*
 
 ACPI THERMAL DRIVER
-P:	Zhang Rui
-M:	rui.zhang@intel.com
+M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/*thermal*
 
 ACPI VIDEO DRIVER
-P:	Zhang Rui
-M:	rui.zhang@intel.com
+M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/acpi/video.c
 
 ACPI WMI DRIVER
-P:	Carlos Corbacho
-M:	carlos@strangeworlds.co.uk
+M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Maintained
 F:	drivers/platform/x86/wmi.c
 
 AD1889 ALSA SOUND DRIVER
-P:	Kyle McMartin
-M:	kyle@mcmartin.ca
-P:	Thibaut Varene
-M:	T-Bone@parisc-linux.org
+M:	Kyle McMartin <kyle@mcmartin.ca>
+M:	Thibaut Varene <T-Bone@parisc-linux.org>
 W:	http://wiki.parisc-linux.org/AD1889
 L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/pci/ad1889.*
 
 ADM1025 HARDWARE MONITOR DRIVER
-P:	Jean Delvare
-M:	khali@linux-fr.org
+M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/adm1025
 F:	drivers/hwmon/adm1025.c
 
 ADM1029 HARDWARE MONITOR DRIVER
-P:	Corentin Labbe
-M:	corentin.labbe@geomatys.fr
+M:	Corentin Labbe <corentin.labbe@geomatys.fr>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/adm1029.c
 
 ADM8211 WIRELESS DRIVER
-P:	Michael Wu
-M:	flamingice@sourmilk.net
+M:	Michael Wu <flamingice@sourmilk.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
@@ -347,35 +314,30 @@ S:	Maintained
 F:	drivers/net/wireless/adm8211.*
 
 ADT746X FAN DRIVER
-P:	Colin Leroy
-M:	colin@colino.net
+M:	Colin Leroy <colin@colino.net>
 S:	Maintained
 F:	drivers/macintosh/therm_adt746x.c
 
 ADVANSYS SCSI DRIVER
-P:	Matthew Wilcox
-M:	matthew@wil.cx
+M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/advansys.txt
 F:	drivers/scsi/advansys.c
 
 AEDSP16 DRIVER
-P:	Riccardo Facchetti
-M:	fizban@tin.it
+M:	Riccardo Facchetti <fizban@tin.it>
 S:	Maintained
 F:	sound/oss/aedsp16.c
 
 AFFS FILE SYSTEM
-P:	Roman Zippel
-M:	zippel@linux-m68k.org
+M:	Roman Zippel <zippel@linux-m68k.org>
 S:	Maintained
 F:	Documentation/filesystems/affs.txt
 F:	fs/affs/
 
 AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
-P:	David Howells
-M:	dhowells@redhat.com
+M:	David Howells <dhowells@redhat.com>
 L:	linux-afs@lists.infradead.org
 S:	Supported
 F:	fs/afs/
@@ -383,40 +345,35 @@ F:	include/net/af_rxrpc.h
 F:	net/rxrpc/af_rxrpc.c
 
 AGPGART DRIVER
-P:	David Airlie
-M:	airlied@linux.ie
+M:	David Airlie <airlied@linux.ie>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
 
 AHA152X SCSI DRIVER
-P:	Juergen E. Fischer
-M:	fischer@norbit.de
+M:	"Juergen E. Fischer" <fischer@norbit.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aha152x*
 F:	drivers/scsi/pcmcia/aha152x*
 
 AIC7XXX / AIC79XX SCSI DRIVER
-P:	Hannes Reinecke
-M:	hare@suse.de
+M:	Hannes Reinecke <hare@suse.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/aic7xxx/
 F:	drivers/scsi/aic7xxx_old/
 
 AIO
-P:	Benjamin LaHaise
-M:	bcrl@kvack.org
+M:	Benjamin LaHaise <bcrl@kvack.org>
 L:	linux-aio@kvack.org
 S:	Supported
 F:	fs/aio.c
 F:	include/linux/*aio*.h
 
 ALCATEL SPEEDTOUCH USB DRIVER
-P:	Duncan Sands
-M:	duncan.sands@free.fr
+M:	Duncan Sands <duncan.sands@free.fr>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/SpeedTouch/
 S:	Maintained
@@ -424,32 +381,27 @@ F:	drivers/usb/atm/speedtch.c
 F:	drivers/usb/atm/usbatm.c
 
 ALCHEMY AU1XX0 MMC DRIVER
-P:	Manuel Lauss
-M:	manuel.lauss@gmail.com
+M:	Manuel Lauss <manuel.lauss@gmail.com>
 S:	Maintained
 F:	drivers/mmc/host/au1xmmc.c
 
 ALI1563 I2C DRIVER
-P:	Rudolf Marek
-M:	r.marek@assembler.cz
+M:	Rudolf Marek <r.marek@assembler.cz>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-ali1563
 F:	drivers/i2c/busses/i2c-ali1563.c
 
 ALPHA PORT
-P:	Richard Henderson
-M:	rth@twiddle.net
+M:	Richard Henderson <rth@twiddle.net>
 S:	Odd Fixes for 2.4; Maintained for 2.6.
-P:	Ivan Kokshaysky
-M:	ink@jurassic.park.msu.ru
+M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
 S:	Maintained for 2.4; PCI support for 2.6.
 L:	linux-alpha@vger.kernel.org
 F:	arch/alpha/
 
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
-P:	Thomas Dahlmann
-M:	dahlmann.thomas@arcor.de
+M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/usb/gadget/amd5536udc.*
@@ -466,8 +418,7 @@ F:	drivers/video/geode/
 F:	arch/x86/include/asm/geode.h
 
 AMD IOMMU (AMD-VI)
-P:	Joerg Roedel
-M:	joerg.roedel@amd.com
+M:	Joerg Roedel <joerg.roedel@amd.com>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
@@ -475,40 +426,33 @@ F:	arch/x86/kernel/amd_iommu*.c
 F:	arch/x86/include/asm/amd_iommu*.h
 
 AMD MICROCODE UPDATE SUPPORT
-P:	Andreas Herrmann
-M:	andreas.herrmann3@amd.com
+M:	Andreas Herrmann <andreas.herrmann3@amd.com>
 L:	amd64-microcode@amd64.org
 S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
-P:	Stelian Pop
-M:	stelian@popies.net
-P:	Michael Hanselmann
-M:	linux-kernel@hansmi.ch
+M:	Stelian Pop <stelian@popies.net>
+M:	Michael Hanselmann <linux-kernel@hansmi.ch>
 S:	Supported
 F:	drivers/hwmon/ams/
 
 AMSO1100 RNIC DRIVER
-P:	Tom Tucker
-M:	tom@opengridcomputing.com
-P:	Steve Wise
-M:	swise@opengridcomputing.com
+M:	Tom Tucker <tom@opengridcomputing.com>
+M:	Steve Wise <swise@opengridcomputing.com>
 L:	general@lists.openfabrics.org
 S:	Maintained
 F:	drivers/infiniband/hw/amso1100/
 
 AOA (Apple Onboard Audio) ALSA DRIVER
-P:	Johannes Berg
-M:	johannes@sipsolutions.net
+M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linuxppc-dev@ozlabs.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 F:	sound/aoa/
 
 APM DRIVER
-P:	Stephen Rothwell
-M:	sfr@canb.auug.org.au
+M:	Stephen Rothwell <sfr@canb.auug.org.au>
 L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
@@ -516,51 +460,44 @@ F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
 
 APPLE BCM5974 MULTITOUCH DRIVER
-P:	Henrik Rydberg
-M:	rydberg@euromail.se
+M:	Henrik Rydberg <rydberg@euromail.se>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/mouse/bcm5974.c
 
 APPLE SMC DRIVER
-P:	Nicolas Boichat
-M:	nicolas@boichat.ch
+M:	Nicolas Boichat <nicolas@boichat.ch>
 L:	mactel-linux-devel@lists.sourceforge.net
 S:	Maintained
 F:	drivers/hwmon/applesmc.c
 
 APPLETALK NETWORK LAYER
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Maintained
 F:	drivers/net/appletalk/
 F:	net/appletalk/
 
 APPLETOUCH TOUCHPAD DRIVER
-P:	Johannes Berg
-M:	johannes@sipsolutions.net
+M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	Documentation/input/appletouch.txt
 F:	drivers/input/mouse/appletouch.c
 
 ARC FRAMEBUFFER DRIVER
-P:	Jaya Kumar
-M:	jayalk@intworks.biz
+M:	Jaya Kumar <jayalk@intworks.biz>
 S:	Maintained
 F:	drivers/video/arcfb.c
 F:	drivers/video/fb_defio.c
 
 ARM MFM AND FLOPPY DRIVERS
-P:	Ian Molton
-M:	spyro@f2s.com
+M:	Ian Molton <spyro@f2s.com>
 S:	Maintained
 F:	arch/arm/lib/floppydma.S
 F:	arch/arm/include/asm/floppy.h
 
 ARM PORT
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
@@ -571,79 +508,67 @@ S:	Orphan
 F:	drivers/mmc/host/mmci.*
 
 ARM/ADI ROADRUNNER MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 F:	arch/arm/mach-ixp23xx/
 F:	arch/arm/mach-ixp23xx/include/mach/
 
 ARM/ADS SPHERE MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/AFEB9260 MACHINE SUPPORT
-P:	Sergey Lapin
-M:	slapin@ossfans.org
+M:	Sergey Lapin <slapin@ossfans.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/AJECO 1ARM MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
-P:	Andrew Victor
-M:	linux@maxim.org.za
+M:	Andrew Victor <linux@maxim.org.za>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://maxim.org.za/at91_26.html
 S:	Maintained
 
 ARM/CIRRUS LOGIC EP93XX ARM ARCHITECTURE
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/CIRRUS LOGIC EDB9315A MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/CLKDEV SUPPORT
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
-P:	Mike Rapoport
-M:	mike@compulab.co.il
+M:	Mike Rapoport <mike@compulab.co.il>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/CORGI MACHINE SUPPORT
-P:	Richard Purdie
-M:	rpurdie@rpsys.net
+M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 
 ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
-P:	Paulius Zaleckas
-M:	paulius.zaleckas@teltonika.lt
+M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 T:	git git://gitorious.org/linux-gemini/mainline.git
 S:	Maintained
 F:	arch/arm/mach-gemini/
 
 ARM/EBSA110 MACHINE SUPPORT
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
@@ -651,12 +576,9 @@ F:	arch/arm/mach-ebsa110/
 F:	drivers/net/arm/am79c961a.*
 
 ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
-P:	Daniel Ribeiro
-M:	drwyrm@gmail.com
-P:	Stefan Schmidt
-M:	stefan@openezx.org
-P:	Harald Welte
-M:	laforge@openezx.org
+M:	Daniel Ribeiro <drwyrm@gmail.com>
+M:	Stefan Schmidt <stefan@openezx.org>
+M:	Harald Welte <laforge@openezx.org>
 L:	openezx-devel@lists.openezx.org (subscribers-only)
 W:	http://www.openezx.org/
 S:	Maintained
@@ -664,15 +586,13 @@ T:	topgit git://git.openezx.org/openezx.git
 F:	arch/arm/mach-pxa/ezx.c
 
 ARM/FARADAY FA526 PORT
-P:	Paulius Zaleckas
-M:	paulius.zaleckas@teltonika.lt
+M:	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
@@ -680,175 +600,143 @@ F:	arch/arm/include/asm/hardware/dec21285.h
 F:	arch/arm/mach-footbridge/
 
 ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
-P:	Sascha Hauer
-M:	kernel@pengutronix.de
+M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/GLOMATION GESBC9312SX MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/GUMSTIX MACHINE SUPPORT
-P:	Steve Sakoman
-M:	sakoman@gmail.com
+M:	Steve Sakoman <sakoman@gmail.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/H4700 (HP IPAQ HX4700) MACHINE SUPPORT
-P:	Philipp Zabel
-M:	philipp.zabel@gmail.com
+M:	Philipp Zabel <philipp.zabel@gmail.com>
 S:	Maintained
 F:	arch/arm/mach-pxa/hx4700.c
 F:	arch/arm/mach-pxa/include/mach/hx4700.h
 
 ARM/HP JORNADA 7XX MACHINE SUPPORT
-P:	Kristoffer Ericson
-M:	kristoffer.ericson@gmail.com
+M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 W:	www.jlime.com
 S:	Maintained
 
 ARM/INTEL IOP32X ARM ARCHITECTURE
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Lennert Buytenhek <kernel@wantstofly.org>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/INTEL IOP33X ARM ARCHITECTURE
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Lennert Buytenhek <kernel@wantstofly.org>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/INTEL IQ81342EX MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Lennert Buytenhek <kernel@wantstofly.org>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/INTEL IXP2000 ARM ARCHITECTURE
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/INTEL IXDP2850 MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/INTEL IXP23XX ARM ARCHITECTURE
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/INTEL XSC3 (MANZANO) ARM CORE
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Lennert Buytenhek <kernel@wantstofly.org>
+M:	Dan Williams <dan.j.williams@intel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 
 ARM/IP FABRICS DOUBLE ESPRESSO MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/LOGICPD PXA270 MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/MAGICIAN MACHINE SUPPORT
-P:	Philipp Zabel
-M:	philipp.zabel@gmail.com
+M:	Philipp Zabel <philipp.zabel@gmail.com>
 S:	Maintained
 
 ARM/MIOA701 MACHINE SUPPORT
-P:	Robert Jarzmik
-M:	robert.jarzmik@free.fr
+M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 F:	arch/arm/mach-pxa/mioa701.c
 S:	Maintained
 
 ARM/NEC MOBILEPRO 900/c MACHINE SUPPORT
-P:	Michael Petchkovsky
-M:	mkpetch@internode.on.net
+M:	Michael Petchkovsky <mkpetch@internode.on.net>
 S:	Maintained
 
 ARM/OPENMOKO NEO FREERUNNER (GTA02) MACHINE SUPPORT
-P:	Nelson Castillo
-M:	arhuaco@freaks-unidos.net
+M:	Nelson Castillo <arhuaco@freaks-unidos.net>
 L:	openmoko-kernel@lists.openmoko.org (subscribers-only)
 W:	http://wiki.openmoko.org/wiki/Neo_FreeRunner
 S:	Supported
 
 ARM/TOSA MACHINE SUPPORT
-P:	Dmitry Eremin-Solenikov
-M:	dbaryshkov@gmail.com
-P:	Dirk Opfer
-M:	dirk@opfer-online.de
+M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
+M:	Dirk Opfer <dirk@opfer-online.de>
 S:	Maintained
 
 ARM/PALMTX,PALMT5,PALMLD,PALMTE2 SUPPORT
-P:	Marek Vasut
-M:	marek.vasut@gmail.com
+M:	Marek Vasut <marek.vasut@gmail.com>
 W:	http://hackndev.com
 S:	Maintained
 
 ARM/PALM TREO 680 SUPPORT
-P:	Tomas Cech
-M:	sleep_walker@suse.cz
+M:	Tomas Cech <sleep_walker@suse.cz>
 W:	http://hackndev.com
 S:	Maintained
 
 ARM/PALMZ72 SUPPORT
-P:	Sergey Lapin
-M:	slapin@ossfans.org
+M:	Sergey Lapin <slapin@ossfans.org>
 W:	http://hackndev.com
 S:	Maintained
 
 ARM/PLEB SUPPORT
-P:	Peter Chubb
-M:	pleb@gelato.unsw.edu.au
+M:	Peter Chubb <pleb@gelato.unsw.edu.au>
 W:	http://www.disy.cse.unsw.edu.au/Hardware/PLEB
 S:	Maintained
 
 ARM/PT DIGITAL BOARD PORT
-P:	Stefan Eletzhofer
-M:	stefan.eletzhofer@eletztrick.de
+M:	Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
 ARM/RADISYS ENP2611 MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/RISCPC ARCHITECTURE
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
@@ -862,14 +750,12 @@ F:	drivers/net/arm/ether*
 F:	drivers/scsi/arm/
 
 ARM/SHARK MACHINE SUPPORT
-P:	Alexander Schulz
-M:	alex@shark-linux.de
+M:	Alexander Schulz <alex@shark-linux.de>
 W:	http://www.shark-linux.de/shark.html
 S:	Maintained
 
 ARM/SAMSUNG ARM ARCHITECTURES
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
@@ -877,85 +763,73 @@ F:	arch/arm/plat-s3c/
 F:	arch/arm/plat-s3c24xx/
 
 ARM/S3C2410 ARM ARCHITECTURE
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2410/
 
 ARM/S3C2440 ARM ARCHITECTURE
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2440/
 
 ARM/S3C2442 ARM ARCHITECTURE
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2442/
 
 ARM/S3C2443 ARM ARCHITECTURE
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c2443/
 
 ARM/S3C6400 ARM ARCHITECTURE
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6400/
 
 ARM/S3C6410 ARM ARCHITECTURE
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/mach-s3c6410/
 
 ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/THECUS N2100 MACHINE SUPPORT
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 
 ARM/NUVOTON W90X900 ARM ARCHITECTURE
-P:	Wan ZongShun
-M:	mcuos.com@gmail.com
+M:	Wan ZongShun <mcuos.com@gmail.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.mcuos.com
 S:	Maintained
 
 ARM/VFP SUPPORT
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	arch/arm/vfp/
 
 ASUS ACPI EXTRAS DRIVER
-P:	Corentin Chary
-M:	corentincj@iksaif.net
-P:	Karol Kozimor
-M:	sziwan@users.sourceforge.net
+M:	Corentin Chary <corentincj@iksaif.net>
+M:	Karol Kozimor <sziwan@users.sourceforge.net>
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://acpi4asus.sf.net
 S:	Maintained
@@ -963,25 +837,21 @@ F:	arch/x86/kernel/acpi/boot.c
 F:	drivers/platform/x86/asus_acpi.c
 
 ASUS ASB100 HARDWARE MONITOR DRIVER
-P:	Mark M. Hoffman
-M:	mhoffman@lightlink.com
+M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/asb100.c
 
 ASUS LAPTOP EXTRAS DRIVER
-P:	Corentin Chary
-M:	corentincj@iksaif.net
+M:	Corentin Chary <corentincj@iksaif.net>
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/asus-laptop.c
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
-P:	Dan Williams
-M:	dan.j.williams@intel.com
-P:	Maciej Sosnowski
-M:	maciej.sosnowski@intel.com
+M:	Dan Williams <dan.j.williams@intel.com>
+M:	Maciej Sosnowski <maciej.sosnowski@intel.com>
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
 F:	Documentation/crypto/async-tx-api.txt
@@ -991,64 +861,49 @@ F:	include/linux/dmaengine.h
 F:	include/linux/async_tx.h
 
 ATA OVER ETHERNET (AOE) DRIVER
-P:	Ed L. Cashin
-M:	ecashin@coraid.com
+M:	"Ed L. Cashin" <ecashin@coraid.com>
 W:	http://www.coraid.com/support/linux
 S:	Supported
 F:	Documentation/aoe/
 F:	drivers/block/aoe/
 
 ATHEROS ATH5K WIRELESS DRIVER
-P:	Jiri Slaby
-M:	jirislaby@gmail.com
-P:	Nick Kossifidis
-M:	mickflemm@gmail.com
-P:	Luis R. Rodriguez
-M:	lrodriguez@atheros.com
-P:	Bob Copeland
-M:	me@bobcopeland.com
+M:	Jiri Slaby <jirislaby@gmail.com>
+M:	Nick Kossifidis <mickflemm@gmail.com>
+M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
 S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
 ATHEROS ATH9K WIRELESS DRIVER
-P:	Luis R. Rodriguez
-M:	lrodriguez@atheros.com
-P:	Jouni Malinen
-M:	jmalinen@atheros.com
-P:	Sujith Manoharan
-M:	Sujith.Manoharan@atheros.com
-P:	Vasanthakumar Thiagarajan
-M:	vasanth@atheros.com
-P:	Senthil Balasubramanian
-M:	senthilkumar@atheros.com
+M:	"Luis R. Rodriguez" <lrodriguez@atheros.com>
+M:	Jouni Malinen <jmalinen@atheros.com>
+M:	Sujith Manoharan <Sujith.Manoharan@atheros.com>
+M:	Vasanthakumar Thiagarajan <vasanth@atheros.com>
+M:	Senthil Balasubramanian <senthilkumar@atheros.com>
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
 S:	Supported
 F:	drivers/net/wireless/ath/ath9k/
 
 ATHEROS AR9170 WIRELESS DRIVER
-P:	Christian Lamparter
-M:	chunkeey@web.de
+M:	Christian Lamparter <chunkeey@web.de>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ar9170
 S:	Maintained
 F:	drivers/net/wireless/ath/ar9170/
 
 ATI_REMOTE2 DRIVER
-P:	Ville Syrjala
-M:	syrjala@sci.fi
+M:	Ville Syrjala <syrjala@sci.fi>
 S:	Maintained
 F:	drivers/input/misc/ati_remote2.c
 
 ATLX ETHERNET DRIVERS
-P:	Jay Cliburn
-M:	jcliburn@gmail.com
-P:	Chris Snook
-M:	csnook@redhat.com
-P:	Jie Yang
-M:	jie.yang@atheros.com
+M:	Jay Cliburn <jcliburn@gmail.com>
+M:	Chris Snook <csnook@redhat.com>
+M:	Jie Yang <jie.yang@atheros.com>
 L:	atl1-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
@@ -1056,8 +911,7 @@ S:	Maintained
 F:	drivers/net/atlx/
 
 ATM
-P:	Chas Williams
-M:	chas@cmf.nrl.navy.mil
+M:	Chas Williams <chas@cmf.nrl.navy.mil>
 L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
 L:	netdev@vger.kernel.org
 W:	http://linux-atm.sourceforge.net
@@ -1066,8 +920,7 @@ F:	drivers/atm/
 F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
-P:	Nicolas Ferre
-M:	nicolas.ferre@atmel.com
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
@@ -1075,49 +928,42 @@ S:	Maintained
 F:	drivers/mmc/host/at91_mci.c
 
 ATMEL AT91 / AT32 MCI DRIVER
-P:	Nicolas Ferre
-M:	nicolas.ferre@atmel.com
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Maintained
 F:	drivers/mmc/host/atmel-mci.c
 F:	drivers/mmc/host/atmel-mci-regs.h
 
 ATMEL AT91 / AT32 SERIAL DRIVER
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 S:	Supported
 F:	drivers/serial/atmel_serial.c
 
 ATMEL LCDFB DRIVER
-P:	Nicolas Ferre
-M:	nicolas.ferre@atmel.com
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/atmel_lcdfb.c
 F:	include/video/atmel_lcdc.h
 
 ATMEL MACB ETHERNET DRIVER
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 S:	Supported
 F:	drivers/net/macb.*
 
 ATMEL SPI DRIVER
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 S:	Supported
 F:	drivers/spi/atmel_spi.*
 
 ATMEL USBA UDC DRIVER
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 L:	kernel@avr32linux.org
 W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
 S:	Supported
 F:	drivers/usb/gadget/atmel_usba_udc.*
 
 ATMEL WIRELESS DRIVER
-P:	Simon Kelley
-M:	simon@thekelleys.org.uk
+M:	Simon Kelley <simon@thekelleys.org.uk>
 L:	linux-wireless@vger.kernel.org
 W:	http://www.thekelleys.org.uk/atmel
 W:	http://atmelwlandriver.sourceforge.net/
@@ -1125,10 +971,8 @@ S:	Maintained
 F:	drivers/net/wireless/atmel*
 
 AUDIT SUBSYSTEM
-P:	Al Viro
-M:	viro@zeniv.linux.org.uk
-P:	Eric Paris
-M:	eparis@redhat.com
+M:	Al Viro <viro@zeniv.linux.org.uk>
+M:	Eric Paris <eparis@redhat.com>
 L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
@@ -1137,8 +981,7 @@ F:	include/linux/audit.h
 F:	kernel/audit*
 
 AUXILIARY DISPLAY DRIVERS
-P:	Miguel Ojeda Sandonis
-M:	miguel.ojeda.sandonis@gmail.com
+M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1146,8 +989,7 @@ F:	drivers/auxdisplay/
 F:	include/linux/cfag12864b.h
 
 AVR32 ARCHITECTURE
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 W:	http://www.atmel.com/products/AVR32/
 W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
@@ -1155,14 +997,12 @@ S:	Supported
 F:	arch/avr32/
 
 AVR32/AT32AP MACHINE SUPPORT
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 S:	Supported
 F:	arch/avr32/mach-at32ap/
 
 AX.25 NETWORK LAYER
-P:	Ralf Baechle
-M:	ralf@linux-mips.org
+M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
@@ -1171,128 +1011,110 @@ F:	include/net/ax25.h
 F:	net/ax25/
 
 B43 WIRELESS DRIVER
-P:	Michael Buesch
-M:	mb@bu3sch.de
-P:	Stefano Brivio
-M:	stefano.brivio@polimi.it
+M:	Michael Buesch <mb@bu3sch.de>
+M:	Stefano Brivio <stefano.brivio@polimi.it>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
 F:	drivers/net/wireless/b43/
 
 B43LEGACY WIRELESS DRIVER
-P:	Larry Finger
-M:	Larry.Finger@lwfinger.net
-P:	Stefano Brivio
-M:	stefano.brivio@polimi.it
+M:	Larry Finger <Larry.Finger@lwfinger.net>
+M:	Stefano Brivio <stefano.brivio@polimi.it>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/users/Drivers/b43
 S:	Maintained
 F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
-P:	Richard Purdie
-M:	rpurdie@rpsys.net
+M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 F:	drivers/video/backlight/
 F:	include/linux/backlight.h
 
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
-P:	Thomas Sailer
-M:	t.sailer@alumni.ethz.ch
+M:	Thomas Sailer <t.sailer@alumni.ethz.ch>
 L:	linux-hams@vger.kernel.org
 W:	http://www.baycom.org/~tom/ham/ham.html
 S:	Maintained
 F:	drivers/net/hamradio/baycom*
 
 BEFS FILE SYSTEM
-P:	Sergey S. Kostyliov
-M:	rathamahata@php4.ru
+M:	"Sergey S. Kostyliov" <rathamahata@php4.ru>
 S:	Maintained
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
 BFS FILE SYSTEM
-P:	Tigran A. Aivazian
-M:	tigran@aivazian.fsnet.co.uk
+M:	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
 F:	include/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
-P:	Mike Frysinger
-M:	vapier@gentoo.org
+M:	Mike Frysinger <vapier@gentoo.org>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
 
 BLACKFIN EMAC DRIVER
-P:	Michael Hennerich
-M:	michael.hennerich@analog.com
+M:	Michael Hennerich <michael.hennerich@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/net/bfin_mac.*
 
 BLACKFIN RTC DRIVER
-P:	Mike Frysinger
-M:	vapier.adi@gmail.com
+M:	Mike Frysinger <vapier.adi@gmail.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SERIAL DRIVER
-P:	Sonic Zhang
-M:	sonic.zhang@analog.com
+M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/serial/bfin_5xx.c
 
 BLACKFIN WATCHDOG DRIVER
-P:	Mike Frysinger
-M:	vapier.adi@gmail.com
+M:	Mike Frysinger <vapier.adi@gmail.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/watchdog/bfin_wdt.c
 
 BLACKFIN I2C TWI DRIVER
-P:	Sonic Zhang
-M:	sonic.zhang@analog.com
+M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLOCK LAYER
-P:	Jens Axboe
-M:	axboe@kernel.dk
+M:	Jens Axboe <axboe@kernel.dk>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 F:	block/
 
 BLOCK2MTD DRIVER
-P:	Joern Engel
-M:	joern@lazybastard.org
+M:	Joern Engel <joern@lazybastard.org>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/devices/block2mtd.c
 
 BLUETOOTH DRIVERS
-P:	Marcel Holtmann
-M:	marcel@holtmann.org
+M:	Marcel Holtmann <marcel@holtmann.org>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 S:	Maintained
 F:	drivers/bluetooth/
 
 BLUETOOTH SUBSYSTEM
-P:	Marcel Holtmann
-M:	marcel@holtmann.org
+M:	Marcel Holtmann <marcel@holtmann.org>
 L:	linux-bluetooth@vger.kernel.org
 W:	http://www.bluez.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
@@ -1301,8 +1123,7 @@ F:	net/bluetooth/
 F:	include/net/bluetooth/
 
 BONDING DRIVER
-P:	Jay Vosburgh
-M:	fubar@us.ibm.com
+M:	Jay Vosburgh <fubar@us.ibm.com>
 L:	bonding-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
@@ -1310,54 +1131,46 @@ F:	drivers/net/bonding/
 F:	include/linux/if_bonding.h
 
 BROADCOM B44 10/100 ETHERNET DRIVER
-P:	Gary Zambrano
-M:	zambrano@broadcom.com
+M:	Gary Zambrano <zambrano@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/b44.*
 
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
-P:	Michael Chan
-M:	mchan@broadcom.com
+M:	Michael Chan <mchan@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/bnx2.*
 F:	drivers/net/bnx2_*
 
 BROADCOM BNX2X 10 GIGABIT ETHERNET DRIVER
-P:	Eilon Greenstein
-M:	eilong@broadcom.com
+M:	Eilon Greenstein <eilong@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/bnx2x*
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
-P:	Matt Carlson
-M:	mcarlson@broadcom.com
-P:	Michael Chan
-M:	mchan@broadcom.com
+M:	Matt Carlson <mcarlson@broadcom.com>
+M:	Michael Chan <mchan@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/tg3.*
 
 BSG (block layer generic sg v4 driver)
-P:	FUJITA Tomonori
-M:	fujita.tomonori@lab.ntt.co.jp
+M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	block/bsg.c
 F:	include/linux/bsg.h
 
 BT8XXGPIO DRIVER
-P:	Michael Buesch
-M:	mb@bu3sch.de
+M:	Michael Buesch <mb@bu3sch.de>
 W:	http://bu3sch.de/btgpio.php
 S:	Maintained
 F:	drivers/gpio/bt8xxgpio.c
 
 BTRFS FILE SYSTEM
-P:	Chris Mason
-M:	chris.mason@oracle.com
+M:	Chris Mason <chris.mason@oracle.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
@@ -1366,8 +1179,7 @@ F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
 
 BTTV VIDEO4LINUX DRIVER
-P:	Mauro Carvalho Chehab
-M:	mchehab@infradead.org
+M:	Mauro Carvalho Chehab <mchehab@infradead.org>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -1376,16 +1188,14 @@ F:	Documentation/video4linux/bttv/
 F:	drivers/media/video/bt8xx/bttv*
 
 CACHEFILES: FS-CACHE BACKEND FOR CACHING ON MOUNTED FILESYSTEMS
-P:	David Howells
-M:	dhowells@redhat.com
+M:	David Howells <dhowells@redhat.com>
 L:	linux-cachefs@redhat.com
 S:	Supported
 F:	Documentation/filesystems/caching/cachefiles.txt
 F:	fs/cachefiles/
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
-P:	Jonathan Corbet
-M:	corbet@lwn.net
+M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
@@ -1393,10 +1203,8 @@ F:	Documentation/video4linux/cafe_ccic
 F:	drivers/media/video/cafe_ccic*
 
 CALGARY x86-64 IOMMU
-P:	Muli Ben-Yehuda
-M:	muli@il.ibm.com
-P:	Jon D. Mason
-M:	jdmason@kudzu.us
+M:	Muli Ben-Yehuda <muli@il.ibm.com>
+M:	"Jon D. Mason" <jdmason@kudzu.us>
 L:	discuss@x86-64.org
 S:	Maintained
 F:	arch/x86/kernel/pci-calgary_64.c
@@ -1405,10 +1213,8 @@ F:	arch/x86/include/asm/calgary.h
 F:	arch/x86/include/asm/tce.h
 
 CAN NETWORK LAYER
-P:	Urs Thuermann
-M:	urs.thuermann@volkswagen.de
-P:	Oliver Hartkopp
-M:	oliver.hartkopp@volkswagen.de
+M:	Urs Thuermann <urs.thuermann@volkswagen.de>
+M:	Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
 L:	socketcan-core@lists.berlios.de (subscribers-only)
 W:	http://developer.berlios.de/projects/socketcan/
 S:	Maintained
@@ -1417,15 +1223,13 @@ F:	include/linux/can/
 F:	include/linux/can.h
 
 CAN NETWORK DRIVERS
-P:	Wolfgang Grandegger
-M:	wg@grandegger.com
+M:	Wolfgang Grandegger <wg@grandegger.com>
 L:	socketcan-core@lists.berlios.de (subscribers-only)
 W:	http://developer.berlios.de/projects/socketcan/
 S:	Maintained
 
 CELL BROADBAND ENGINE ARCHITECTURE
-P:	Arnd Bergmann
-M:	arnd@arndb.de
+M:	Arnd Bergmann <arnd@arndb.de>
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
@@ -1436,8 +1240,7 @@ F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
 CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
-P:	David Vrabel
-M:	david.vrabel@csr.com
+M:	David Vrabel <david.vrabel@csr.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	Documentation/usb/WUSB-Design-overview.txt
@@ -1446,8 +1249,7 @@ F:	drivers/usb/wusbcore/
 F:	include/linux/usb/wusb*
 
 CFAG12864B LCD DRIVER
-P:	Miguel Ojeda Sandonis
-M:	miguel.ojeda.sandonis@gmail.com
+M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1455,8 +1257,7 @@ F:	drivers/auxdisplay/cfag12864b.c
 F:	include/linux/cfag12864b.h
 
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
-P:	Miguel Ojeda Sandonis
-M:	miguel.ojeda.sandonis@gmail.com
+M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -1464,8 +1265,7 @@ F:	drivers/auxdisplay/cfag12864bfb.c
 F:	include/linux/cfag12864b.h
 
 CFG80211 and NL80211
-P:	Johannes Berg
-M:	johannes@sipsolutions.net
+M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	include/linux/nl80211.h
@@ -1474,57 +1274,47 @@ F:	net/wireless/*
 X:	net/wireless/wext*
 
 CHECKPATCH
-P:	Andy Whitcroft
-M:	apw@canonical.com
+M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 
 CISCO 10G ETHERNET DRIVER
-P:	Scott Feldman
-M:	scofeldm@cisco.com
-P:	Joe Eykholt
-M:	jeykholt@cisco.com
+M:	Scott Feldman <scofeldm@cisco.com>
+M:	Joe Eykholt <jeykholt@cisco.com>
 S:	Supported
 F:	drivers/net/enic/
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/arm/ep93xx_eth.c
 
 CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4270 SOUND DRIVER
-P:	Timur Tabi
-M:	timur@freescale.com
+M:	Timur Tabi <timur@freescale.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
 CLK API
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER
-P:	Abhijeet Joglekar
-M:	abjoglek@cisco.com
-P:	Joe Eykholt
-M:	jeykholt@cisco.com
+M:	Abhijeet Joglekar <abjoglek@cisco.com>
+M:	Joe Eykholt <jeykholt@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
 
 CODA FILE SYSTEM
-P:	Jan Harkes
-M:	jaharkes@cs.cmu.edu
+M:	Jan Harkes <jaharkes@cs.cmu.edu>
 M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
@@ -1534,8 +1324,7 @@ F:	fs/coda/
 F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
-P:	Steve French
-M:	sfrench@samba.org
+M:	Steve French <sfrench@samba.org>
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
@@ -1545,60 +1334,51 @@ F:	Documentation/filesystems/cifs.txt
 F:	fs/cifs/
 
 COMPACTPCI HOTPLUG CORE
-P:	Scott Murray
-M:	scott@spiteful.org
+M:	Scott Murray <scott@spiteful.org>
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 F:	drivers/pci/hotplug/cpci_hotplug*
 
 COMPACTPCI HOTPLUG ZIATECH ZT5550 DRIVER
-P:	Scott Murray
-M:	scott@spiteful.org
+M:	Scott Murray <scott@spiteful.org>
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 F:	drivers/pci/hotplug/cpcihp_zt5550.*
 
 COMPACTPCI HOTPLUG GENERIC DRIVER
-P:	Scott Murray
-M:	scott@spiteful.org
+M:	Scott Murray <scott@spiteful.org>
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 F:	drivers/pci/hotplug/cpcihp_generic.c
 
 COMPAL LAPTOP SUPPORT
-P:	Cezary Jackiewicz
-M:	cezary.jackiewicz@gmail.com
+M:	Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
 S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
 
 COMPUTONE INTELLIPORT MULTIPORT CARD
-P:	Michael H. Warfield
-M:	mhw@wittsend.com
+M:	"Michael H. Warfield" <mhw@wittsend.com>
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
 F:	Documentation/serial/computone.txt
 F:	drivers/char/ip2/
 
 CONEXANT ACCESSRUNNER USB DRIVER
-P:	Simon Arlott
-M:	cxacru@fire.lp0.eu
+M:	Simon Arlott <cxacru@fire.lp0.eu>
 L:	accessrunner-general@lists.sourceforge.net
 W:	http://accessrunner.sourceforge.net/
 S:	Maintained
 F:	drivers/usb/atm/cxacru.c
 
 CONFIGFS
-P:	Joel Becker
-M:	joel.becker@oracle.com
+M:	Joel Becker <joel.becker@oracle.com>
 S:	Supported
 F:	fs/configfs/
 F:	include/linux/configfs.h
 
 CONTROL GROUPS (CGROUPS)
-P:	Paul Menage
-M:	menage@google.com
-P:	Li Zefan
-M:	lizf@cn.fujitsu.com
+M:	Paul Menage <menage@google.com>
+M:	Li Zefan <lizf@cn.fujitsu.com>
 L:	containers@lists.linux-foundation.org
 S:	Maintained
 F:	include/linux/cgroup*
@@ -1606,30 +1386,26 @@ F:	kernel/cgroup*
 F:	mm/*cgroup*
 
 CORETEMP HARDWARE MONITORING DRIVER
-P:	Rudolf Marek
-M:	r.marek@assembler.cz
+M:	Rudolf Marek <r.marek@assembler.cz>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/coretemp
 F:	drivers/hwmon/coretemp.c
 
 COSA/SRP SYNC SERIAL DRIVER
-P:	Jan "Yenya" Kasprzak
-M:	kas@fi.muni.cz
+M:	Jan "Yenya" Kasprzak <kas@fi.muni.cz>
 W:	http://www.fi.muni.cz/~kas/cosa/
 S:	Maintained
 F:	drivers/net/wan/cosa*
 
 CPMAC ETHERNET DRIVER
-P:	Florian Fainelli
-M:	florian@openwrt.org
+M:	Florian Fainelli <florian@openwrt.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/cpmac.c
 
 CPU FREQUENCY DRIVERS
-P:	Dave Jones
-M:	davej@redhat.com
+M:	Dave Jones <davej@redhat.com>
 L:	cpufreq@vger.kernel.org
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
@@ -1639,15 +1415,13 @@ F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h
 
 CPUID/MSR DRIVER
-P:	H. Peter Anvin
-M:	hpa@zytor.com
+M:	"H. Peter Anvin" <hpa@zytor.com>
 S:	Maintained
 F:	arch/x86/kernel/cpuid.c
 F:	arch/x86/kernel/msr.c
 
 CPUSETS
-P:	Paul Menage
-M:	menage@google.com
+M:	Paul Menage <menage@google.com>
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
 S:	Supported
@@ -1662,20 +1436,16 @@ F:	Documentation/filesystems/cramfs.txt
 F:	fs/cramfs/
 
 CRIS PORT
-P:	Mikael Starvik
-M:	starvik@axis.com
-P:	Jesper Nilsson
-M:	jesper.nilsson@axis.com
+M:	Mikael Starvik <starvik@axis.com>
+M:	Jesper Nilsson <jesper.nilsson@axis.com>
 L:	linux-cris-kernel@axis.com
 W:	http://developer.axis.com
 S:	Maintained
 F:	arch/cris/
 
 CRYPTO API
-P:	Herbert Xu
-M:	herbert@gondor.apana.org.au
-P:	David S. Miller
-M:	davem@davemloft.net
+M:	Herbert Xu <herbert@gondor.apana.org.au>
+M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-crypto@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
@@ -1686,22 +1456,18 @@ F:	drivers/crypto/
 F:	include/crypto/
 
 CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
-P:	Neil Horman
-M:	nhorman@tuxdriver.com
+M:	Neil Horman <nhorman@tuxdriver.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 
 CS5535 Audio ALSA driver
-P:	Jaya Kumar
-M:	jayakumar.alsa@gmail.com
+M:	Jaya Kumar <jayakumar.alsa@gmail.com>
 S:	Maintained
 F:	sound/pci/cs5535audio/
 
 CX18 VIDEO4LINUX DRIVER
-P:	Hans Verkuil
-M:	hverkuil@xs4all.nl
-P:	Andy Walls
-M:	awalls@radix.net
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+M:	Andy Walls <awalls@radix.net>
 L:	ivtv-devel@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -1712,32 +1478,28 @@ F:	Documentation/video4linux/cx18.txt
 F:	drivers/media/video/cx18/
 
 CXGB3 ETHERNET DRIVER (CXGB3)
-P:	Divy Le Ray
-M:	divy@chelsio.com
+M:	Divy Le Ray <divy@chelsio.com>
 L:	netdev@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
 F:	drivers/net/cxgb3/
 
 CXGB3 IWARP RNIC DRIVER (IW_CXGB3)
-P:	Steve Wise
-M:	swise@chelsio.com
+M:	Steve Wise <swise@chelsio.com>
 L:	general@lists.openfabrics.org
 W:	http://www.openfabrics.org
 S:	Supported
 F:	drivers/infiniband/hw/cxgb3/
 
 CYBERPRO FB DRIVER
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 F:	drivers/video/cyber2000fb.*
 
 CYCLADES 2X SYNC CARD DRIVER
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
 F:	drivers/net/wan/cycx*
@@ -1754,8 +1516,7 @@ S:	Orphan
 F:	drivers/net/wan/pc300*
 
 DAMA SLAVE for AX.25
-P:	Joerg Reuter
-M:	jreuter@yaina.de
+M:	Joerg Reuter <jreuter@yaina.de>
 W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
@@ -1769,29 +1530,23 @@ F:	net/ax25/ax25_timer.c
 F:	net/ax25/sysctl_net_ax25.c
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
-P:	Tobias Ringstrom
-M:	tori@unhappy.mine.nu
+M:	Tobias Ringstrom <tori@unhappy.mine.nu>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/dmfe.txt
 F:	drivers/net/tulip/dmfe.c
 
 DC390/AM53C974 SCSI driver
-P:	Kurt Garloff
-M:	garloff@suse.de
+M:	Kurt Garloff <garloff@suse.de>
 W:	http://www.garloff.de/kurt/linux/dc390/
-P:	Guennadi Liakhovetski
-M:	g.liakhovetski@gmx.de
+M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 S:	Maintained
 F:	drivers/scsi/tmscsim.*
 
 DC395x SCSI driver
-P:	Oliver Neukum
-M:	oliver@neukum.name
-P:	Ali Akcaagac
-M:	aliakc@web.de
-P:	Jamie Lenehan
-M:	lenehan@twibble.org
+M:	Oliver Neukum <oliver@neukum.name>
+M:	Ali Akcaagac <aliakc@web.de>
+M:	Jamie Lenehan <lenehan@twibble.org>
 W:	http://twibble.org/dist/dc395x/
 L:	dc395x@twibble.org
 L:	http://lists.twibble.org/mailman/listinfo/dc395x/
@@ -1800,8 +1555,7 @@ F:	Documentation/scsi/dc395x.txt
 F:	drivers/scsi/dc395x.*
 
 DCCP PROTOCOL
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 L:	dccp@vger.kernel.org
 W:	http://linux-net.osdl.org/index.php/DCCP
 S:	Maintained
@@ -1810,8 +1564,7 @@ F:	include/linux/tfrc.h
 F:	net/dccp/
 
 DECnet NETWORK LAYER
-P:	Christine Caulfield
-M:	christine.caulfield@googlemail.com
+M:	Christine Caulfield <christine.caulfield@googlemail.com>
 W:	http://linux-decnet.sourceforge.net
 L:	linux-decnet-user@lists.sourceforge.net
 S:	Maintained
@@ -1819,40 +1572,34 @@ F:	Documentation/networking/decnet.txt
 F:	net/decnet/
 
 DEFXX FDDI NETWORK DRIVER
-P:	Maciej W. Rozycki
-M:	macro@linux-mips.org
+M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/net/defxx.*
 
 DELL LAPTOP DRIVER
-P:	Matthew Garrett
-M:	mjg59@srcf.ucam.org
+M:	Matthew Garrett <mjg59@srcf.ucam.org>
 S:	Maintained
 F:	drivers/platform/x86/dell-laptop.c
 
 DELL LAPTOP SMM DRIVER
-P:	Massimo Dal Zotto
-M:	dz@debian.org
+M:	Massimo Dal Zotto <dz@debian.org>
 W:	http://www.debian.org/~dz/i8k/
 S:	Maintained
 F:	drivers/char/i8k.c
 F:	include/linux/i8k.h
 
 DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
-P:	Doug Warzecha
-M:	Douglas_Warzecha@dell.com
+M:	Doug Warzecha <Douglas_Warzecha@dell.com>
 S:	Maintained
 F:	Documentation/dcdbas.txt
 F:	drivers/firmware/dcdbas.*
 
 DELL WMI EXTRAS DRIVER
-P:	Matthew Garrett
-M:	mjg59@srcf.ucam.org
+M:	Matthew Garrett <mjg59@srcf.ucam.org>
 S:	Maintained
 
 DEVICE NUMBER REGISTRY
-P:	Torben Mathiasen
-M:	device@lanana.org
+M:	Torben Mathiasen <device@lanana.org>
 W:	http://lanana.org/docs/device-list/index.html
 S:	Maintained
 
@@ -1867,8 +1614,7 @@ F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 
 DIGI INTL. EPCA DRIVER
-P:	Digi International, Inc
-M:	Eng.Linux@digi.com
+M:	"Digi International, Inc" <Eng.Linux@digi.com>
 L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphan
@@ -1877,34 +1623,29 @@ F:	drivers/char/epca*
 F:	drivers/char/digi*
 
 DIRECTORY NOTIFICATION (DNOTIFY)
-P:	Eric Paris
-M:	eparis@parisplace.org
+M:	Eric Paris <eparis@parisplace.org>
 S:	Maintained
 F:	Documentation/filesystems/dnotify.txt
 F:	fs/notify/dnotify/
 F:	include/linux/dnotify.h
 
 DISK GEOMETRY AND PARTITION HANDLING
-P:	Andries Brouwer
-M:	aeb@cwi.nl
+M:	Andries Brouwer <aeb@cwi.nl>
 W:	http://www.win.tue.nl/~aeb/linux/Large-Disk.html
 W:	http://www.win.tue.nl/~aeb/linux/zip/zip-1.html
 W:	http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
 S:	Maintained
 
 DISKQUOTA
-P:	Jan Kara
-M:	jack@suse.cz
+M:	Jan Kara <jack@suse.cz>
 S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota/
 F:	include/linux/quota*.h
 
 DISTRIBUTED LOCK MANAGER (DLM)
-P:	Christine Caulfield
-M:	ccaulfie@redhat.com
-P:	David Teigland
-M:	teigland@redhat.com
+M:	Christine Caulfield <ccaulfie@redhat.com>
+M:	David Teigland <teigland@redhat.com>
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git
@@ -1912,52 +1653,44 @@ S:	Supported
 F:	fs/dlm/
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
-P:	Maciej Sosnowski
-M:	maciej.sosnowski@intel.com
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Maciej Sosnowski <maciej.sosnowski@intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/
 F:	include/linux/dma*
 
 DME1737 HARDWARE MONITOR DRIVER
-P:	Juerg Haefliger
-M:	juergh@gmail.com
+M:	Juerg Haefliger <juergh@gmail.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/dme1737
 F:	drivers/hwmon/dme1737.c
 
 DOCBOOK FOR DOCUMENTATION
-P:	Randy Dunlap
-M:	rdunlap@xenotime.net
+M:	Randy Dunlap <rdunlap@xenotime.net>
 S:	Maintained
 
 DOCKING STATION DRIVER
-P:	Shaohua Li
-M:	shaohua.li@intel.com
+M:	Shaohua Li <shaohua.li@intel.com>
 L:	linux-acpi@vger.kernel.org
 S:	Supported
 F:	drivers/acpi/dock.c
 
 DOCUMENTATION
-P:	Randy Dunlap
-M:	rdunlap@xenotime.net
+M:	Randy Dunlap <rdunlap@xenotime.net>
 L:	linux-doc@vger.kernel.org
 S:	Maintained
 F:	Documentation/
 
 DOUBLETALK DRIVER
-P:	James R. Van Zandt
-M:	jrv@vanzandt.mv.com
+M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
 L:	blinux-list@redhat.com
 S:	Maintained
 F:	drivers/char/dtlk.c
 F:	include/linux/dtlk.h
 
 DPT_I2O SCSI RAID DRIVER
-P:	Adaptec OEM Raid Solutions
-M:	aacraid@adaptec.com
+M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
@@ -1965,8 +1698,7 @@ F:	drivers/scsi/dpt*
 F:	drivers/scsi/dpt/
 
 DRIVER CORE, KOBJECTS, AND SYSFS
-P:	Greg Kroah-Hartman
-M:	gregkh@suse.de
+M:	Greg Kroah-Hartman <gregkh@suse.de>
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
@@ -1976,52 +1708,45 @@ F:	include/linux/kobj*
 F:	lib/kobj*
 
 DRM DRIVERS
-P:	David Airlie
-M:	airlied@linux.ie
+M:	David Airlie <airlied@linux.ie>
 L:	dri-devel@lists.sourceforge.net
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
 
 DSCC4 DRIVER
-P:	Francois Romieu
-M:	romieu@fr.zoreil.com
+M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dscc4.c
 
 DZ DECSTATION DZ11 SERIAL DRIVER
-P:	Maciej W. Rozycki
-M:	macro@linux-mips.org
+M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/serial/dz.*
 
 EATA-DMA SCSI DRIVER
-P:	Michael Neuffer
-M:	mike@i-Connect.Net
+M:	Michael Neuffer <mike@i-Connect.Net>
 L:	linux-eata@i-connect.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata*
 
 EATA ISA/EISA/PCI SCSI DRIVER
-P:	Dario Ballabio
-M:	ballabio_dario@emc.com
+M:	Dario Ballabio <ballabio_dario@emc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata.c
 
 EATA-PIO SCSI DRIVER
-P:	Michael Neuffer
-M:	mike@i-Connect.Net
+M:	Michael Neuffer <mike@i-Connect.Net>
 L:	linux-eata@i-connect.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/eata_pio.*
 
 EBTABLES
-P:	Bart De Schuymer
-M:	bart.de.schuymer@pandora.be
+M:	Bart De Schuymer <bart.de.schuymer@pandora.be>
 L:	ebtables-user@lists.sourceforge.net
 L:	ebtables-devel@lists.sourceforge.net
 W:	http://ebtables.sourceforge.net/
@@ -2030,10 +1755,8 @@ F:	include/linux/netfilter_bridge/ebt_*.h
 F:	net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
-P:	Tyler Hicks
-M:	tyhicks@linux.vnet.ibm.com
-P:	Dustin Kirkland
-M:	kirkland@canonical.com
+M:	Tyler Hicks <tyhicks@linux.vnet.ibm.com>
+M:	Dustin Kirkland <kirkland@canonical.com>
 L:	ecryptfs-devel@lists.launchpad.net
 W:	https://launchpad.net/ecryptfs
 S:	Supported
@@ -2041,8 +1764,7 @@ F:	Documentation/filesystems/ecryptfs.txt
 F:	fs/ecryptfs/
 
 EDAC-CORE
-P:	Doug Thompson
-M:	dougthompson@xmission.com
+M:	Doug Thompson <dougthompson@xmission.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Supported
@@ -2051,94 +1773,80 @@ F:	drivers/edac/edac_*
 F:	include/linux/edac.h
 
 EDAC-AMD64
-P:	Doug Thompson
-M:	dougthompson@xmission.com
-P:	Borislav Petkov
-M:	borislav.petkov@amd.com
+M:	Doug Thompson <dougthompson@xmission.com>
+M:	Borislav Petkov <borislav.petkov@amd.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Supported
 F:	drivers/edac/amd64_edac*
 
 EDAC-E752X
-P:	Mark Gross
-M:	mark.gross@intel.com
-P:	Doug Thompson
-M:	dougthompson@xmission.com
+M:	Mark Gross <mark.gross@intel.com>
+M:	Doug Thompson <dougthompson@xmission.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/e752x_edac.c
 
 EDAC-E7XXX
-P:	Doug Thompson
-M:	dougthompson@xmission.com
+M:	Doug Thompson <dougthompson@xmission.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/e7xxx_edac.c
 
 EDAC-I82443BXGX
-P:	Tim Small
-M:	tim@buttersideup.com
+M:	Tim Small <tim@buttersideup.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i82443bxgx_edac.c
 
 EDAC-I3000
-P:	Jason Uhlenkott
-M:	juhlenko@akamai.com
+M:	Jason Uhlenkott <juhlenko@akamai.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i3000_edac.c
 
 EDAC-I5000
-P:	Doug Thompson
-M:	dougthompson@xmission.com
+M:	Doug Thompson <dougthompson@xmission.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i5000_edac.c
 
 EDAC-I5400
-P:	Mauro Carvalho Chehab
-M:	mchehab@redhat.com
+M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i5400_edac.c
 
 EDAC-I82975X
-P:	Ranganathan Desikan
-M:	ravi@jetztechnologies.com
-P:	Arvind R.
-M:	arvind@jetztechnologies.com
+M:	Ranganathan Desikan <ravi@jetztechnologies.com>
+M:	"Arvind R." <arvind@jetztechnologies.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i82975x_edac.c
 
 EDAC-PASEMI
-P:	Egor Martovetsky
-M:	egor@pasemi.com
+M:	Egor Martovetsky <egor@pasemi.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/pasemi_edac.c
 
 EDAC-R82600
-P:	Tim Small
-M:	tim@buttersideup.com
+M:	Tim Small <tim@buttersideup.com>
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/r82600_edac.c
 
 EEEPC LAPTOP EXTRAS DRIVER
-P:	Corentin Chary
-M:	corentincj@iksaif.net
+M:	Corentin Chary <corentincj@iksaif.net>
 L:	acpi4asus-user@lists.sourceforge.net
 W:	http://acpi4asus.sf.net
 S:	Maintained
@@ -2150,65 +1858,53 @@ S:	Orphan
 F:	fs/efs/
 
 EHCA (IBM GX bus InfiniBand adapter) DRIVER
-P:	Hoang-Nam Nguyen
-M:	hnguyen@de.ibm.com
-P:	Christoph Raisch
-M:	raisch@de.ibm.com
+M:	Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+M:	Christoph Raisch <raisch@de.ibm.com>
 L:	general@lists.openfabrics.org
 S:	Supported
 F:	drivers/infiniband/hw/ehca/
 
 EMBEDDED LINUX
-P:	Paul Gortmaker
-M:	paul.gortmaker@windriver.com
-P:	Matt Mackall
-M:	mpm@selenic.com
-P:	David Woodhouse
-M:	dwmw2@infradead.org
+M:	Paul Gortmaker <paul.gortmaker@windriver.com>
+M:	Matt Mackall <mpm@selenic.com>
+M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
 
 EMULEX LPFC FC SCSI DRIVER
-P:	James Smart
-M:	james.smart@emulex.com
+M:	James Smart <james.smart@emulex.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://sourceforge.net/projects/lpfcxxxx
 S:	Supported
 F:	drivers/scsi/lpfc/
 
 ENE CB710 FLASH CARD READER DRIVER
-P:	Michał Mirosław
-M:	mirq-linux@rere.qmqm.pl
+M:	Michał Mirosław <mirq-linux@rere.qmqm.pl>
 S:	Maintained
 F:	drivers/misc/cb710/
 F:	drivers/mmc/host/cb710-mmc.*
 F:	include/linux/cb710.h
 
 EPSON 1355 FRAMEBUFFER DRIVER
-P:	Christopher Hoover
-M:	ch@murgatroid.com
-P:	Christopher Hoover
-M:	ch@hpl.hp.com
+M:	Christopher Hoover <ch@murgatroid.com>
+M:	Christopher Hoover <ch@hpl.hp.com>
 S:	Maintained
 F:	drivers/video/epson1355fb.c
 
 EPSON S1D13XXX FRAMEBUFFER DRIVER
-P:	Kristoffer Ericson
-M:	kristoffer.ericson@gmail.com
+M:	Kristoffer Ericson <kristoffer.ericson@gmail.com>
 S:	Maintained
 F:	drivers/video/s1d13xxxfb.c
 F:	include/video/s1d13xxxfb.h
 
 ETHEREXPRESS-16 NETWORK DRIVER
-P:	Philip Blundell
-M:	philb@gnu.org
+M:	Philip Blundell <philb@gnu.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/eexpress.*
 
 ETHERNET BRIDGE
-P:	Stephen Hemminger
-M:	shemminger@linux-foundation.org
+M:	Stephen Hemminger <shemminger@linux-foundation.org>
 L:	bridge@lists.linux-foundation.org
 W:	http://www.linux-foundation.org/en/Net:Bridge
 S:	Maintained
@@ -2216,8 +1912,7 @@ F:	include/linux/netfilter_bridge/
 F:	net/bridge/
 
 ETHERTEAM 16I DRIVER
-P:	Mika Kuoppala
-M:	miku@iki.fi
+M:	Mika Kuoppala <miku@iki.fi>
 S:	Maintained
 F:	drivers/net/eth16i.c
 
@@ -2229,12 +1924,9 @@ F:	fs/ext2/
 F:	include/linux/ext2*
 
 EXT3 FILE SYSTEM
-P:	Stephen Tweedie
-M:	sct@redhat.com
-P:	Andrew Morton
-M:	akpm@linux-foundation.org
-P:	Andreas Dilger
-M:	adilger@sun.com
+M:	Stephen Tweedie <sct@redhat.com>
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Andreas Dilger <adilger@sun.com>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	Documentation/filesystems/ext3.txt
@@ -2242,10 +1934,8 @@ F:	fs/ext3/
 F:	include/linux/ext3*
 
 EXT4 FILE SYSTEM
-P:	Theodore Ts'o
-M:	tytso@mit.edu
-P:	Andreas Dilger
-M:	adilger@sun.com
+M:	"Theodore Ts'o" <tytso@mit.edu>
+M:	Andreas Dilger <adilger@sun.com>
 L:	linux-ext4@vger.kernel.org
 W:	http://ext4.wiki.kernel.org
 S:	Maintained
@@ -2253,30 +1943,26 @@ F:	Documentation/filesystems/ext4.txt
 F:	fs/ext4/
 
 F71805F HARDWARE MONITORING DRIVER
-P:	Jean Delvare
-M:	khali@linux-fr.org
+M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/f71805f
 F:	drivers/hwmon/f71805f.c
 
 FARSYNC SYNCHRONOUS DRIVER
-P:	Kevin Curtis
-M:	kevin.curtis@farsite.co.uk
+M:	Kevin Curtis <kevin.curtis@farsite.co.uk>
 W:	http://www.farsite.co.uk/
 S:	Supported
 F:	drivers/net/wan/farsync.*
 
 FAULT INJECTION SUPPORT
-P:	Akinobu Mita
-M:	akinobu.mita@gmail.com
+M:	Akinobu Mita <akinobu.mita@gmail.com>
 S:	Supported
 F:	Documentation/fault-injection/
 F:	lib/fault-inject.c
 
 FILE LOCKING (flock() and fcntl()/lockf())
-P:	Matthew Wilcox
-M:	matthew@wil.cx
+M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
@@ -2285,25 +1971,21 @@ F:	fs/fcntl.c
 F:	fs/locks.c
 
 FILESYSTEMS (VFS and infrastructure)
-P:	Alexander Viro
-M:	viro@zeniv.linux.org.uk
+M:	Alexander Viro <viro@zeniv.linux.org.uk>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/*
 
 FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
-P:	Riku Voipio
-M:	riku.vipio@iki.fi
+M:	Riku Voipio <riku.vipio@iki.fi>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/f75375s.c
 F:	include/linux/f75375s.h
 
 FIREWIRE SUBSYSTEM
-P:	Kristian Hoegsberg
-M:	krh@redhat.com
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
+M:	Kristian Hoegsberg <krh@redhat.com>
+M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
@@ -2318,15 +2000,13 @@ F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
 FPU EMULATOR
-P:	Bill Metzenthen
-M:	billm@melbpc.org.au
+M:	Bill Metzenthen <billm@melbpc.org.au>
 W:	http://floatingpoint.sourceforge.net/emulator/index.html
 S:	Maintained
 F:	arch/x86/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
-P:	Mike McLagan
-M:	mike.mclagan@linux.org
+M:	Mike McLagan <mike.mclagan@linux.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wan/dlci.c
@@ -2341,25 +2021,21 @@ F:	drivers/video/fb*
 F:	include/linux/fb.h
 
 FREESCALE DMA DRIVER
-P:	Li Yang
-M:	leoli@freescale.com
-P:	Zhang Wei
-M:	zw@zh-kernel.org
+M:	Li Yang <leoli@freescale.com>
+M:	Zhang Wei <zw@zh-kernel.org>
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 F:	drivers/dma/fsldma.*
 
 FREESCALE I2C CPM DRIVER
-P:	Jochen Friedrich
-M:	jochen@scram.de
+M:	Jochen Friedrich <jochen@scram.de>
 L:	linuxppc-dev@ozlabs.org
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
-P:	Sascha Hauer
-M:	kernel@pengutronix.de
+M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
@@ -2367,10 +2043,8 @@ F:	arch/arm/plat-mxc/include/mach/imxfb.h
 F:	drivers/video/imxfb.c
 
 FREESCALE SOC FS_ENET DRIVER
-P:	Pantelis Antoniou
-M:	pantelis.antoniou@gmail.com
-P:	Vitaly Bordug
-M:	vbordug@ru.mvista.com
+M:	Pantelis Antoniou <pantelis.antoniou@gmail.com>
+M:	Vitaly Bordug <vbordug@ru.mvista.com>
 L:	linuxppc-dev@ozlabs.org
 L:	netdev@vger.kernel.org
 S:	Maintained
@@ -2378,39 +2052,34 @@ F:	drivers/net/fs_enet/
 F:	include/linux/fs_enet_pd.h
 
 FREESCALE QUICC ENGINE LIBRARY
-P:	Timur Tabi
-M:	timur@freescale.com
+M:	Timur Tabi <timur@freescale.com>
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 F:	arch/powerpc/sysdev/qe_lib/
 F:	arch/powerpc/include/asm/*qe.h
 
 FREESCALE HIGHSPEED USB DEVICE DRIVER
-P:	Li Yang
-M:	leoli@freescale.com
+M:	Li Yang <leoli@freescale.com>
 L:	linux-usb@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 F:	drivers/usb/gadget/fsl_usb2_udc.c
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
-P:	Li Yang
-M:	leoli@freescale.com
+M:	Li Yang <leoli@freescale.com>
 L:	netdev@vger.kernel.org
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 F:	drivers/net/ucc_geth*
 
 FREESCALE QUICC ENGINE UCC UART DRIVER
-P:	Timur Tabi
-M:	timur@freescale.com
+M:	Timur Tabi <timur@freescale.com>
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 F:	drivers/serial/ucc_uart.c
 
 FREESCALE SOC SOUND DRIVERS
-P:	Timur Tabi
-M:	timur@freescale.com
+M:	Timur Tabi <timur@freescale.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
@@ -2418,17 +2087,14 @@ F:	sound/soc/fsl/fsl*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
 FREEVXFS FILESYSTEM
-P:	Christoph Hellwig
-M:	hch@infradead.org
+M:	Christoph Hellwig <hch@infradead.org>
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 F:	fs/freevxfs/
 
 FREEZER
-P:	Pavel Machek
-M:	pavel@ucw.cz
-P:	Rafael J. Wysocki
-M:	rjw@sisk.pl
+M:	Pavel Machek <pavel@ucw.cz>
+M:	"Rafael J. Wysocki" <rjw@sisk.pl>
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	Documentation/power/freezing-of-tasks.txt
@@ -2436,8 +2102,7 @@ F:	include/linux/freezer.h
 F:	kernel/freezer.c
 
 FS-CACHE: LOCAL CACHING FOR NETWORK FILESYSTEMS
-P:	David Howells
-M:	dhowells@redhat.com
+M:	David Howells <dhowells@redhat.com>
 L:	linux-cachefs@redhat.com
 S:	Supported
 F:	Documentation/filesystems/caching/
@@ -2445,8 +2110,7 @@ F:	fs/fscache/
 F:	include/linux/fscache*.h
 
 FTRACE
-P:	Steven Rostedt
-M:	rostedt@goodmis.org
+M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
 F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
@@ -2455,21 +2119,18 @@ F:	include/*/ftrace.h
 F:	kernel/trace/
 
 FUJITSU FR-V (FRV) PORT
-P:	David Howells
-M:	dhowells@redhat.com
+M:	David Howells <dhowells@redhat.com>
 S:	Maintained
 F:	arch/frv/
 
 FUJITSU LAPTOP EXTRAS
-P:	Jonathan Woithe
-M:	jwoithe@physics.adelaide.edu.au
+M:	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
 L:	linux-acpi@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/fujitsu-laptop.c
 
 FUSE: FILESYSTEM IN USERSPACE
-P:	Miklos Szeredi
-M:	miklos@szeredi.hu
+M:	Miklos Szeredi <miklos@szeredi.hu>
 L:	fuse-devel@lists.sourceforge.net
 W:	http://fuse.sourceforge.net/
 S:	Maintained
@@ -2477,30 +2138,26 @@ F:	fs/fuse/
 F:	include/linux/fuse.h
 
 FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-bit)
-P:	Rik Faith
-M:	faith@cs.unc.edu
+M:	Rik Faith <faith@cs.unc.edu>
 L:	linux-scsi@vger.kernel.org
 S:	Odd Fixes (e.g., new signatures)
 F:	drivers/scsi/fdomain.*
 
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
-P:	Achim Leubner
-M:	achim_leubner@adaptec.com
+M:	Achim Leubner <achim_leubner@adaptec.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.icp-vortex.com/
 S:	Supported
 F:	drivers/scsi/gdt*
 
 GENERIC GPIO I2C DRIVER
-P:	Haavard Skinnemoen
-M:	hskinnemoen@atmel.com
+M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
 S:	Supported
 F:	drivers/i2c/busses/i2c-gpio.c
 F:	include/linux/i2c-gpio.h
 
 GENERIC HDLC (WAN) DRIVERS
-P:	Krzysztof Halasa
-M:	khc@pm.waw.pl
+M:	Krzysztof Halasa <khc@pm.waw.pl>
 W:	http://www.kernel.org/pub/linux/utils/net/hdlc/
 S:	Maintained
 F:	drivers/net/wan/c101.c
@@ -2512,16 +2169,14 @@ F:	drivers/net/wan/pci200syn.c
 F:	drivers/net/wan/wanxl*
 
 GENERIC INCLUDE/ASM HEADER FILES
-P:	Arnd Bergmann
-M:	arnd@arndb.de
+M:	Arnd Bergmann <arnd@arndb.de>
 L:	linux-arch@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
 S:	Maintained
 F:	include/asm-generic
 
 GFS2 FILE SYSTEM
-P:	Steven Whitehouse
-M:	swhiteho@redhat.com
+M:	Steven Whitehouse <swhiteho@redhat.com>
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
@@ -2532,10 +2187,8 @@ F:	fs/gfs2/
 F:	include/linux/gfs2_ondisk.h
 
 GIGASET ISDN DRIVERS
-P:	Hansjoerg Lipp
-M:	hjlipp@web.de
-P:	Tilman Schmidt
-M:	tilman@imap.cc
+M:	Hansjoerg Lipp <hjlipp@web.de>
+M:	Tilman Schmidt <tilman@imap.cc>
 L:	gigaset307x-common@lists.sourceforge.net
 W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
@@ -2544,8 +2197,7 @@ F:	drivers/isdn/gigaset/
 F:	include/linux/gigaset_dev.h
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-P:	Frank Seidel
-M:	frank@f-seidel.de
+M:	Frank Seidel <frank@f-seidel.de>
 L:	lm-sensors@lm-sensors.org
 W:	http://www.kernel.org/pub/linux/kernel/people/fseidel/hdaps/
 S:	Maintained
@@ -2557,40 +2209,35 @@ S:	Odd Fixes
 F:	drivers/char/hvc_*
 
 GSPCA FINEPIX SUBDRIVER
-P:	Frank Zago
-M:	frank@zago.net
+M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/finepix.c
 
 GSPCA M5602 SUBDRIVER
-P:	Erik Andren
-M:	erik.andren@gmail.com
+M:	Erik Andren <erik.andren@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/m5602/
 
 GSPCA PAC207 SONIXB SUBDRIVER
-P:	Hans de Goede
-M:	hdegoede@redhat.com
+M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/pac207.c
 
 GSPCA T613 SUBDRIVER
-P:	Leandro Costantino
-M:	lcostantino@gmail.com
+M:	Leandro Costantino <lcostantino@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/t613.c
 
 GSPCA USB WEBCAM DRIVER
-P:	Jean-Francois Moine
-M:	moinejf@free.fr
+M:	Jean-Francois Moine <moinejf@free.fr>
 W:	http://moinejf.free.fr
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -2610,31 +2257,27 @@ F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
 HARMONY SOUND DRIVER
-P:	Kyle McMartin
-M:	kyle@mcmartin.ca
+M:	Kyle McMartin <kyle@mcmartin.ca>
 L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
 HAYES ESP SERIAL DRIVER
-P:	Andrew J. Robinson
-M:	arobinso@nyx.net
+M:	"Andrew J. Robinson" <arobinso@nyx.net>
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
 F:	Documentation/serial/hayes-esp.txt
 F:	drivers/char/esp.c
 
 HEWLETT-PACKARD SMART2 RAID DRIVER
-P:	Chirag Kantharia
-M:	chirag.kantharia@hp.com
+M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
 S:	Maintained
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
-P:	Mike Miller
-M:	mike.miller@hp.com
+M:	Mike Miller <mike.miller@hp.com>
 L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/blockdev/cciss.txt
@@ -2642,25 +2285,21 @@ F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
-P:	Roman Zippel
-M:	zippel@linux-m68k.org
+M:	Roman Zippel <zippel@linux-m68k.org>
 S:	Maintained
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
 HGA FRAMEBUFFER DRIVER
-P:	Ferenc Bakonyi
-M:	fero@drama.obuda.kando.hu
+M:	Ferenc Bakonyi <fero@drama.obuda.kando.hu>
 L:	linux-nvidia@lists.surfsouth.com
 W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
 S:	Maintained
 F:	drivers/video/hgafb.c
 
 HIBERNATION (aka Software Suspend, aka swsusp)
-P:	Pavel Machek
-M:	pavel@ucw.cz
-P:	Rafael J. Wysocki
-M:	rjw@sisk.pl
+M:	Pavel Machek <pavel@ucw.cz>
+M:	"Rafael J. Wysocki" <rjw@sisk.pl>
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	arch/x86/power/
@@ -2672,8 +2311,7 @@ F:	include/linux/pm.h
 F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
-P:	Jiri Kosina
-M:	jkosina@suse.cz
+M:	Jiri Kosina <jkosina@suse.cz>
 L:	linux-input@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
@@ -2681,16 +2319,14 @@ F:	drivers/hid/
 F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
-P:	Thomas Gleixner
-M:	tglx@linutronix.de
+M:	Thomas Gleixner <tglx@linutronix.de>
 S:	Maintained
 F:	Documentation/timers/
 F:	kernel/hrtimer.c
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
-P:	Klaus Kudielka
-M:	klaus.kudielka@ieee.org
+M:	Klaus Kudielka <klaus.kudielka@ieee.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.nt.tuwien.ac.at/~kkudielk/Linux/
 S:	Maintained
@@ -2698,16 +2334,14 @@ F:	drivers/net/hamradio/dmascc.c
 F:	drivers/net/hamradio/scc.c
 
 HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
-P:	HighPoint Linux Team
-M:	linux@highpoint-tech.com
+M:	HighPoint Linux Team <linux@highpoint-tech.com>
 W:	http://www.highpoint-tech.com
 S:	Supported
 F:	Documentation/scsi/hptiop.txt
 F:	drivers/scsi/hptiop.c
 
 HIPPI
-P:	Jes Sorensen
-M:	jes@trained-monkey.org
+M:	Jes Sorensen <jes@trained-monkey.org>
 L:	linux-hippi@sunsite.dk
 S:	Maintained
 F:	include/linux/hippidevice.h
@@ -2715,8 +2349,7 @@ F:	include/linux/if_hippi.h
 F:	net/802/hippi.c
 
 HOST AP DRIVER
-P:	Jouni Malinen
-M:	j@w1.fi
+M:	Jouni Malinen <j@w1.fi>
 L:	hostap@shmoo.com (subscribers-only)
 L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
@@ -2724,82 +2357,69 @@ S:	Maintained
 F:	drivers/net/wireless/hostap/
 
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
-P:	Carlos Corbacho
-M:	carlos@strangeworlds.co.uk
+M:	Carlos Corbacho <carlos@strangeworlds.co.uk>
 S:	Odd Fixes
 F:	drivers/platform/x86/tc1100-wmi.c
 
 HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
-P:	Jaroslav Kysela
-M:	perex@perex.cz
+M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained
 F:	drivers/net/hp100.*
 
 HPET:	High Precision Event Timers driver
-P:	Clemens Ladisch
-M:	clemens@ladisch.de
+M:	Clemens Ladisch <clemens@ladisch.de>
 S:	Maintained
 F:	Documentation/timers/hpet.txt
 F:	drivers/char/hpet.c
 F:	include/linux/hpet.h
 
 HPET:	i386
-P:	Venkatesh Pallipadi (Venki)
-M:	venkatesh.pallipadi@intel.com
+M:	"Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>
 S:	Maintained
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 
 HPET:	x86_64
-P:	Vojtech Pavlik
-M:	vojtech@suse.cz
+M:	Vojtech Pavlik <vojtech@suse.cz>
 S:	Maintained
 
 HPET:	ACPI
-P:	Bob Picco
-M:	bob.picco@hp.com
+M:	Bob Picco <bob.picco@hp.com>
 S:	Maintained
 F:	drivers/char/hpet.c
 
 HPFS FILESYSTEM
-P:	Mikulas Patocka
-M:	mikulas@artax.karlin.mff.cuni.cz
+M:	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
 W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
 F:	fs/hpfs/
 
 HSO 3G MODEM DRIVER
-P:	Jan Dumon
-M:	j.dumon@option.com
+M:	Jan Dumon <j.dumon@option.com>
 W:	http://www.pharscape.org
 S:	Maintained
 F:	drivers/net/usb/hso.c
 
 HTCPEN TOUCHSCREEN DRIVER
-P:	Pau Oliva Fora
-M:	pof@eslack.org
+M:	Pau Oliva Fora <pof@eslack.org>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/htcpen.c
 
 HUGETLB FILESYSTEM
-P:	William Irwin
-M:	wli@holomorphy.com
+M:	William Irwin <wli@holomorphy.com>
 S:	Maintained
 F:	fs/hugetlbfs/
 
 I2C/SMBUS STUB DRIVER
-P:	Mark M. Hoffman
-M:	mhoffman@lightlink.com
+M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-stub.c
 
 I2C SUBSYSTEM
-P:	Jean Delvare (PC drivers, core)
-M:	khali@linux-fr.org
-P:	Ben Dooks (embedded platforms)
-M:	ben-linux@fluff.org
+M:	"Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
+M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
 L:	linux-i2c@vger.kernel.org
 W:	http://i2c.wiki.kernel.org/
 T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
@@ -2811,30 +2431,25 @@ F:	include/linux/i2c-dev.h
 F:	include/linux/i2c-id.h
 
 I2C-TINY-USB DRIVER
-P:	Till Harbaum
-M:	till@harbaum.org
+M:	Till Harbaum <till@harbaum.org>
 L:	linux-i2c@vger.kernel.org
 W:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
 F:	drivers/i2c/busses/i2c-tiny-usb.c
 
 i386 BOOT CODE
-P:	H. Peter Anvin
-M:	hpa@zytor.com
+M:	"H. Peter Anvin" <hpa@zytor.com>
 S:	Maintained
 F:	arch/x86/boot/
 
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
-P:	H. Peter Anvin
-M:	hpa@zytor.com
+M:	"H. Peter Anvin" <hpa@zytor.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
 
 IA64 (Itanium) PLATFORM
-P:	Tony Luck
-M:	tony.luck@intel.com
-P:	Fenghua Yu
-M:	fenghua.yu@intel.com
+M:	Tony Luck <tony.luck@intel.com>
+M:	Fenghua Yu <fenghua.yu@intel.com>
 L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git
@@ -2842,29 +2457,25 @@ S:	Maintained
 F:	arch/ia64/
 
 IBM MCA SCSI SUBSYSTEM DRIVER
-P:	Michael Lang
-M:	langa2@kph.uni-mainz.de
+M:	Michael Lang <langa2@kph.uni-mainz.de>
 W:	http://www.uni-mainz.de/~langm000/linux.html
 S:	Maintained
 F:	drivers/scsi/ibmmca.c
 
 IBM Power Linux RAID adapter
-P:	Brian King
-M:	brking@us.ibm.com
+M:	Brian King <brking@us.ibm.com>
 S:	Supported
 F:	drivers/scsi/ipr.*
 
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
-P:	Dave Jeffery
-M:	ipslinux@adaptec.com
+M:	Dave Jeffery <ipslinux@adaptec.com>
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported
 F:	drivers/scsi/ips.*
 
 IDE SUBSYSTEM
-P:	David S. Miller
-M:	davem@davemloft.net
+M:	"David S. Miller" <davem@davemloft.net>
 L:	linux-ide@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6.git
 S:	Maintained
@@ -2873,25 +2484,21 @@ F:	drivers/ide/
 F:	include/linux/ide.h
 
 IDE/ATAPI DRIVERS
-P:	Borislav Petkov
-M:	petkovbb@gmail.com
+M:	Borislav Petkov <petkovbb@gmail.com>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	Documentation/cdrom/ide-cd
 F:	drivers/ide/ide-cd*
 
 IDLE-I7300
-P:	Andy Henroid
-M:	andrew.d.henroid@intel.com
+M:	Andy Henroid <andrew.d.henroid@intel.com>
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	drivers/idle/i7300_idle.c
 
 IEEE 1394 SUBSYSTEM
-P:	Ben Collins
-M:	ben.collins@ubuntu.com
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
+M:	Ben Collins <ben.collins@ubuntu.com>
+M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
@@ -2899,19 +2506,15 @@ S:	Maintained
 F:	drivers/ieee1394/
 
 IEEE 1394 RAW I/O DRIVER
-P:	Dan Dennedy
-M:	dan@dennedy.org
-P:	Stefan Richter
-M:	stefanr@s5r6.in-berlin.de
+M:	Dan Dennedy <dan@dennedy.org>
+M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 F:	drivers/ieee1394/raw1394*
 
 IEEE 802.15.4 SUBSYSTEM
-P:	Dmitry Eremin-Solenikov
-M:	dbaryshkov@gmail.com
-P:	Sergey Lapin
-M:	slapin@ossfans.org
+M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
+M:	Sergey Lapin <slapin@ossfans.org>
 L:	linux-zigbee-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://apps.sourceforge.net/trac/linux-zigbee
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git
@@ -2920,8 +2523,7 @@ F:	net/ieee802154/
 F:	drivers/ieee802154/
 
 INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
-P:	Mimi Zohar
-M:	zohar@us.ibm.com
+M:	Mimi Zohar <zohar@us.ibm.com>
 S:	Supported
 F:	security/integrity/ima/
 
@@ -2931,12 +2533,9 @@ S:	Orphan
 F:	drivers/video/imsttfb.c
 
 INFINIBAND SUBSYSTEM
-P:	Roland Dreier
-M:	rolandd@cisco.com
-P:	Sean Hefty
-M:	sean.hefty@intel.com
-P:	Hal Rosenstock
-M:	hal.rosenstock@gmail.com
+M:	Roland Dreier <rolandd@cisco.com>
+M:	Sean Hefty <sean.hefty@intel.com>
+M:	Hal Rosenstock <hal.rosenstock@gmail.com>
 L:	general@lists.openfabrics.org (moderated for non-subscribers)
 W:	http://www.openib.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
@@ -2946,66 +2545,55 @@ F:	drivers/infiniband/
 F:	include/linux/if_infiniband.h
 
 INOTIFY
-P:	John McCutchan
-M:	john@johnmccutchan.com
-P:	Robert Love
-M:	rlove@rlove.org
-P:	Eric Paris
-M:	eparis@parisplace.org
+M:	John McCutchan <john@johnmccutchan.com>
+M:	Robert Love <rlove@rlove.org>
+M:	Eric Paris <eparis@parisplace.org>
 S:	Maintained
 F:	Documentation/filesystems/inotify.txt
 F:	fs/notify/inotify/
 F:	include/linux/inotify.h
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
-P:	Dmitry Torokhov
-M:	dmitry.torokhov@gmail.com
-P:	Dmitry Torokhov
-M:	dtor@mail.ru
+M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
+M:	Dmitry Torokhov <dtor@mail.ru>
 L:	linux-input@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
-P:	Sylvain Meyer
-M:	sylvain.meyer@worldonline.fr
+M:	Sylvain Meyer <sylvain.meyer@worldonline.fr>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/fb/intelfb.txt
 F:	drivers/video/intelfb/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
-P:	Antonino Daplas
-M:	adaplas@gmail.com
+M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/i810/
 
 INTEL MENLOW THERMAL DRIVER
-P:	Sujith Thomas
-M:	sujith.thomas@intel.com
+M:	Sujith Thomas <sujith.thomas@intel.com>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 S:	Supported
 F:	drivers/platform/x86/intel_menlow.c
 
 INTEL IA32 MICROCODE UPDATE SUPPORT
-P:	Tigran Aivazian
-M:	tigran@aivazian.fsnet.co.uk
+M:	Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
 S:	Maintained
 F:	arch/x86/kernel/microcode_core.c
 F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
-P:	Maciej Sosnowski
-M:	maciej.sosnowski@intel.com
+M:	Maciej Sosnowski <maciej.sosnowski@intel.com>
 S:	Supported
 F:	drivers/dma/ioat*
 
 INTEL IOMMU (VT-d)
-P:	David Woodhouse
-M:	dwmw2@infradead.org
+M:	David Woodhouse <dwmw2@infradead.org>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.infradead.org/iommu-2.6.git
 S:	Supported
@@ -3013,14 +2601,12 @@ F:	drivers/pci/intel-iommu.c
 F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
-P:	Dan Williams
-M:	dan.j.williams@intel.com
+M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/iop-adma.c
 
 INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT
-P:	Krzysztof Halasa
-M:	khc@pm.waw.pl
+M:	Krzysztof Halasa <khc@pm.waw.pl>
 S:	Maintained
 F:	arch/arm/mach-ixp4xx/include/mach/qmgr.h
 F:	arch/arm/mach-ixp4xx/include/mach/npe.h
@@ -3030,29 +2616,22 @@ F:	drivers/net/arm/ixp4xx_eth.c
 F:	drivers/net/wan/ixp4xx_hss.c
 
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
-P:	Deepak Saxena
-M:	dsaxena@plexity.net
+M:	Deepak Saxena <dsaxena@plexity.net>
 S:	Maintained
 F:	drivers/char/hw_random/ixp4xx-rng.c
 
 INTEL IXP2000 ETHERNET DRIVER
-P:	Lennert Buytenhek
-M:	kernel@wantstofly.org
+M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ixp2000/
 
 INTEL ETHERNET DRIVERS (e100/e1000/e1000e/igb/ixgb/ixgbe)
-P:	Jeff Kirsher
-M:	jeffrey.t.kirsher@intel.com
-P:	Jesse Brandeburg
-M:	jesse.brandeburg@intel.com
-P:	Bruce Allan
-M:	bruce.w.allan@intel.com
-P:	PJ Waskiewicz
-M:	peter.p.waskiewicz.jr@intel.com
-P:	John Ronciak
-M:	john.ronciak@intel.com
+M:	Jeff Kirsher <jeffrey.t.kirsher@intel.com>
+M:	Jesse Brandeburg <jesse.brandeburg@intel.com>
+M:	Bruce Allan <bruce.w.allan@intel.com>
+M:	PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
+M:	John Ronciak <john.ronciak@intel.com>
 L:	e1000-devel@lists.sourceforge.net
 W:	http://e1000.sourceforge.net/
 S:	Supported
@@ -3064,12 +2643,9 @@ F:	drivers/net/ixgb/
 F:	drivers/net/ixgbe/
 
 INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
-P:	Zhu Yi
-M:	yi.zhu@intel.com
-P:	James Ketrenos
-M:	jketreno@linux.intel.com
-P:	Reinette Chatre
-M:	reinette.chatre@intel.com
+M:	Zhu Yi <yi.zhu@intel.com>
+M:	James Ketrenos <jketreno@linux.intel.com>
+M:	Reinette Chatre <reinette.chatre@intel.com>
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
@@ -3079,12 +2655,9 @@ F:	Documentation/networking/README.ipw2100
 F:	drivers/net/wireless/ipw2x00/ipw2100.*
 
 INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
-P:	Zhu Yi
-M:	yi.zhu@intel.com
-P:	James Ketrenos
-M:	jketreno@linux.intel.com
-P:	Reinette Chatre
-M:	reinette.chatre@intel.com
+M:	Zhu Yi <yi.zhu@intel.com>
+M:	James Ketrenos <jketreno@linux.intel.com>
+M:	Reinette Chatre <reinette.chatre@intel.com>
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
 W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
@@ -3094,8 +2667,7 @@ F:	Documentation/networking/README.ipw2200
 F:	drivers/net/wireless/ipw2x00/ipw2200.*
 
 INTEL WIRELESS WIMAX CONNECTION 2400
-P:	Inaky Perez-Gonzalez
-M:	inaky.perez-gonzalez@intel.com
+M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
 L:	wimax@linuxwimax.org
 S:	Supported
@@ -3105,10 +2677,8 @@ F:	drivers/net/wimax/i2400m/
 F:	include/linux/wimax/i2400m.h
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
-P:	Zhu Yi
-M:	yi.zhu@intel.com
-P:	Reinette Chatre
-M:	reinette.chatre@intel.com
+M:	Zhu Yi <yi.zhu@intel.com>
+M:	Reinette Chatre <reinette.chatre@intel.com>
 L:	linux-wireless@vger.kernel.org
 L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
@@ -3117,47 +2687,39 @@ S:	Supported
 F:	drivers/net/wireless/iwlwifi/
 
 IOC3 ETHERNET DRIVER
-P:	Ralf Baechle
-M:	ralf@linux-mips.org
+M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-mips@linux-mips.org
 S:	Maintained
 F:	drivers/net/ioc3-eth.c
 
 IOC3 SERIAL DRIVER
-P:	Pat Gefre
-M:	pfg@sgi.com
+M:	Pat Gefre <pfg@sgi.com>
 L:	linux-mips@linux-mips.org
 S:	Maintained
 F:	drivers/serial/ioc3_serial.c
 
 IP MASQUERADING
-P:	Juanjo Ciarlante
-M:	jjciarla@raiz.uncu.edu.ar
+M:	Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
 S:	Maintained
 F:	net/ipv4/netfilter/ipt_MASQUERADE.c
 
 IP1000A 10/100/1000 GIGABIT ETHERNET DRIVER
-P:	Francois Romieu
-M:	romieu@fr.zoreil.com
-P:	Sorbica Shieh
-M:	sorbica@icplus.com.tw
-P:	Jesse Huang
-M:	jesse@icplus.com.tw
+M:	Francois Romieu <romieu@fr.zoreil.com>
+M:	Sorbica Shieh <sorbica@icplus.com.tw>
+M:	Jesse Huang <jesse@icplus.com.tw>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ipg.c
 
 IPATH DRIVER
-P:	Ralph Campbell
-M:	infinipath@qlogic.com
+M:	Ralph Campbell <infinipath@qlogic.com>
 L:	general@lists.openfabrics.org
 T:	git git://git.qlogic.com/ipath-linux-2.6
 S:	Supported
 F:	drivers/infiniband/hw/ipath/
 
 IPMI SUBSYSTEM
-P:	Corey Minyard
-M:	minyard@acm.org
+M:	Corey Minyard <minyard@acm.org>
 L:	openipmi-developer@lists.sourceforge.net
 W:	http://openipmi.sourceforge.net/
 S:	Supported
@@ -3166,20 +2728,16 @@ F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
 
 IPS SCSI RAID DRIVER
-P:	Adaptec OEM Raid Solutions
-M:	aacraid@adaptec.com
+M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.adaptec.com/
 S:	Maintained
 F:	drivers/scsi/ips*
 
 IPVS
-P:	Wensong Zhang
-M:	wensong@linux-vs.org
-P:	Simon Horman
-M:	horms@verge.net.au
-P:	Julian Anastasov
-M:	ja@ssi.bg
+M:	Wensong Zhang <wensong@linux-vs.org>
+M:	Simon Horman <horms@verge.net.au>
+M:	Julian Anastasov <ja@ssi.bg>
 L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
@@ -3187,17 +2745,14 @@ F:	Documentation/networking/ipvs-sysctl.txt
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
-P:	Jiri Kosina
-M:	jkosina@suse.cz
-P:	David Sterba
-M:	dsterba@suse.cz
+M:	Jiri Kosina <jkosina@suse.cz>
+M:	David Sterba <dsterba@suse.cz>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
 F:	drivers/char/pcmcia/ipwireless/
 
 IPX NETWORK LAYER
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	include/linux/ipx.h
@@ -3205,8 +2760,7 @@ F:	include/net/ipx.h
 F:	net/ipx/
 
 IRDA SUBSYSTEM
-P:	Samuel Ortiz
-M:	samuel@sortiz.org
+M:	Samuel Ortiz <samuel@sortiz.org>
 L:	irda-users@lists.sourceforge.net (subscribers-only)
 W:	http://irda.sourceforge.net/
 S:	Maintained
@@ -3217,16 +2771,14 @@ F:	include/net/irda/
 F:	net/irda/
 
 ISAPNP
-P:	Jaroslav Kysela
-M:	perex@perex.cz
+M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained
 F:	Documentation/isapnp.txt
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
 ISCSI
-P:	Mike Christie
-M:	michaelc@cs.wisc.edu
+M:	Mike Christie <michaelc@cs.wisc.edu>
 L:	open-iscsi@googlegroups.com
 W:	www.open-iscsi.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
@@ -3235,8 +2787,7 @@ F:	drivers/scsi/*iscsi*
 F:	include/scsi/*iscsi*
 
 ISDN SUBSYSTEM
-P:	Karsten Keil
-M:	isdn@linux-pingi.de
+M:	Karsten Keil <isdn@linux-pingi.de>
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.isdn4linux.de
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/isdn-2.6.git
@@ -3247,16 +2798,14 @@ F:	include/linux/isdn.h
 F:	include/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
-P:	Armin Schindler
-M:	mac@melware.de
+M:	Armin Schindler <mac@melware.de>
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.melware.de
 S:	Maintained
 F:	drivers/isdn/hardware/eicon/
 
 IVTV VIDEO4LINUX DRIVER
-P:	Hans Verkuil
-M:	hverkuil@xs4all.nl
+M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	ivtv-devel@ivtvdriver.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -3267,8 +2816,7 @@ F:	drivers/media/video/ivtv/
 F:	include/linux/ivtv*
 
 JFS FILESYSTEM
-P:	Dave Kleikamp
-M:	shaggy@linux.vnet.ibm.com
+M:	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
@@ -3277,15 +2825,13 @@ F:	Documentation/filesystems/jfs.txt
 F:	fs/jfs/
 
 JME NETWORK DRIVER
-P:	Guo-Fu Tseng
-M:	cooldavid@cooldavid.org
+M:	Guo-Fu Tseng <cooldavid@cooldavid.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/jme.*
 
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
-P:	David Woodhouse
-M:	dwmw2@infradead.org
+M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
@@ -3293,10 +2839,8 @@ F:	fs/jffs2/
 F:	include/linux/jffs2.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-P:	Stephen Tweedie
-M:	sct@redhat.com
-P:	Andrew Morton
-M:	akpm@linux-foundation.org
+M:	Stephen Tweedie <sct@redhat.com>
+M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 F:	fs/jbd*/
@@ -3304,48 +2848,41 @@ F:	include/linux/ext*jbd*.h
 F:	include/linux/jbd*.h
 
 K8TEMP HARDWARE MONITORING DRIVER
-P:	Rudolf Marek
-M:	r.marek@assembler.cz
+M:	Rudolf Marek <r.marek@assembler.cz>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
 KCONFIG
-P:	Roman Zippel
-M:	zippel@linux-m68k.org
+M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
 KDUMP
-P:	Vivek Goyal
-M:	vgoyal@redhat.com
-P:	Haren Myneni
-M:	hbabu@us.ibm.com
+M:	Vivek Goyal <vgoyal@redhat.com>
+M:	Haren Myneni <hbabu@us.ibm.com>
 L:	kexec@lists.infradead.org
 W:	http://lse.sourceforge.net/kdump/
 S:	Maintained
 F:	Documentation/kdump/
 
 KERNEL AUTOMOUNTER (AUTOFS)
-P:	H. Peter Anvin
-M:	hpa@zytor.com
+M:	"H. Peter Anvin" <hpa@zytor.com>
 L:	autofs@linux.kernel.org
 S:	Odd Fixes
 F:	fs/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
-P:	Ian Kent
-M:	raven@themaw.net
+M:	Ian Kent <raven@themaw.net>
 L:	autofs@linux.kernel.org
 S:	Maintained
 F:	fs/autofs4/
 
 KERNEL BUILD
-P:	Sam Ravnborg
-M:	sam@ravnborg.org
+M:	Sam Ravnborg <sam@ravnborg.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-next.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
@@ -3360,10 +2897,8 @@ W:	http://janitor.kernelnewbies.org/
 S:	Odd fixes
 
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
-P:	J. Bruce Fields
-M:	bfields@fieldses.org
-P:	Neil Brown
-M:	neilb@suse.de
+M:	"J. Bruce Fields" <bfields@fieldses.org>
+M:	Neil Brown <neilb@suse.de>
 L:	linux-nfs@vger.kernel.org
 W:	http://nfs.sourceforge.net/
 S:	Supported
@@ -3376,8 +2911,7 @@ F:	include/linux/lockd/
 F:	include/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
-P:	Avi Kivity
-M:	avi@redhat.com
+M:	Avi Kivity <avi@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
@@ -3388,8 +2922,7 @@ F:	include/linux/kvm*
 F:	virt/kvm/
 
 KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
-P:	Joerg Roedel
-M:	joerg.roedel@amd.com
+M:	Joerg Roedel <joerg.roedel@amd.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
@@ -3398,8 +2931,7 @@ F:	arch/x86/kvm/kvm_svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
-P:	Hollis Blanchard
-M:	hollisb@us.ibm.com
+M:	Hollis Blanchard <hollisb@us.ibm.com>
 L:	kvm-ppc@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
@@ -3407,8 +2939,7 @@ F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/kvm/
 
 KERNEL VIRTUAL MACHINE For Itanium (KVM/IA64)
-P:	Xiantao Zhang
-M:	xiantao.zhang@intel.com
+M:	Xiantao Zhang <xiantao.zhang@intel.com>
 L:	kvm-ia64@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
@@ -3417,10 +2948,8 @@ F:	arch/ia64/include/asm/kvm*
 F:	arch/ia64/kvm/
 
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
-P:	Carsten Otte
-M:	cotte@de.ibm.com
-P:	Christian Borntraeger
-M:	borntraeger@de.ibm.com
+M:	Carsten Otte <cotte@de.ibm.com>
+M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -3430,8 +2959,7 @@ F:	arch/s390/include/asm/kvm*
 F:	arch/s390/kvm/
 
 KEXEC
-P:	Eric Biederman
-M:	ebiederm@xmission.com
+M:	Eric Biederman <ebiederm@xmission.com>
 W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 L:	kexec@lists.infradead.org
 S:	Maintained
@@ -3439,8 +2967,7 @@ F:	include/linux/kexec.h
 F:	kernel/kexec.c
 
 KGDB
-P:	Jason Wessel
-M:	jason.wessel@windriver.com
+M:	Jason Wessel <jason.wessel@windriver.com>
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/DocBook/kgdb.tmpl
@@ -3450,15 +2977,13 @@ F:	include/linux/kgdb.h
 F:	kernel/kgdb.c
 
 KMEMCHECK
-P:	Vegard Nossum
-M:	vegardno@ifi.uio.no
+M:	Vegard Nossum <vegardno@ifi.uio.no>
 P	Pekka Enberg
 M:	penberg@cs.helsinki.fi
 S:	Maintained
 
 KMEMLEAK
-P:	Catalin Marinas
-M:	catalin.marinas@arm.com
+M:	Catalin Marinas <catalin.marinas@arm.com>
 S:	Maintained
 F:	Documentation/kmemleak.txt
 F:	include/linux/kmemleak.h
@@ -3466,30 +2991,24 @@ F:	mm/kmemleak.c
 F:	mm/kmemleak-test.c
 
 KMEMTRACE
-P:	Eduard - Gabriel Munteanu
-M:	eduard.munteanu@linux360.ro
+M:	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
 S:	Maintained
 F:	Documentation/trace/kmemtrace.txt
 F:	include/linux/kmemtrace.h
 F:	kernel/trace/kmemtrace.c
 
 KPROBES
-P:	Ananth N Mavinakayanahalli
-M:	ananth@in.ibm.com
-P:	Anil S Keshavamurthy
-M:	anil.s.keshavamurthy@intel.com
-P:	David S. Miller
-M:	davem@davemloft.net
-P:	Masami Hiramatsu
-M:	mhiramat@redhat.com
+M:	Ananth N Mavinakayanahalli <ananth@in.ibm.com>
+M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+M:	"David S. Miller" <davem@davemloft.net>
+M:	Masami Hiramatsu <mhiramat@redhat.com>
 S:	Maintained
 F:	Documentation/kprobes.txt
 F:	include/linux/kprobes.h
 F:	kernel/kprobes.c
 
 KS0108 LCD CONTROLLER DRIVER
-P:	Miguel Ojeda Sandonis
-M:	miguel.ojeda.sandonis@gmail.com
+M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
 W:	http://miguelojeda.es/auxdisplay.htm
 W:	http://jair.lab.fi.uva.es/~migojed/auxdisplay.htm
 S:	Maintained
@@ -3505,31 +3024,27 @@ F:	include/*/lapb.h
 F:	net/lapb/
 
 LASI 53c700 driver for PARISC
-P:	James E.J. Bottomley
-M:	James.Bottomley@HansenPartnership.com
+M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/53c700.txt
 F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
-P:	Richard Purdie
-M:	rpurdie@rpsys.net
+M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 F:	drivers/leds/
 F:	include/linux/leds.h
 
 LEGO USB Tower driver
-P:	Juergen Stuber
-M:	starblue@users.sourceforge.net
+M:	Juergen Stuber <starblue@users.sourceforge.net>
 L:	legousb-devel@lists.sourceforge.net
 W:	http://legousb.sourceforge.net/
 S:	Maintained
 F:	drivers/usb/misc/legousbtower.c
 
 LGUEST
-P:	Rusty Russell
-M:	rusty@rustcorp.com.au
+M:	Rusty Russell <rusty@rustcorp.com.au>
 L:	lguest@ozlabs.org
 W:	http://lguest.ozlabs.org/
 S:	Maintained
@@ -3540,119 +3055,100 @@ F:	include/linux/lguest*.h
 F:	arch/x86/include/asm/lguest*.h
 
 LINUX FOR IBM pSERIES (RS/6000)
-P:	Paul Mackerras
-M:	paulus@au.ibm.com
+M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
 S:	Supported
 
 LINUX FOR POWERPC (32-BIT AND 64-BIT)
-P:	Benjamin Herrenschmidt
-M:	benh@kernel.crashing.org
-P:	Paul Mackerras
-M:	paulus@samba.org
+M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
+M:	Paul Mackerras <paulus@samba.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
 S:	Supported
 
 LINUX FOR POWER MACINTOSH
-P:	Benjamin Herrenschmidt
-M:	benh@kernel.crashing.org
+M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED MPC5XXX
-P:	Grant Likely
-M:	grant.likely@secretlab.ca
+M:	Grant Likely <grant.likely@secretlab.ca>
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
-P:	Josh Boyer
-M:	jwboyer@linux.vnet.ibm.com
-P:	Matt Porter
-M:	mporter@kernel.crashing.org
+M:	Josh Boyer <jwboyer@linux.vnet.ibm.com>
+M:	Matt Porter <mporter@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc-4xx.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
-P:	Grant Likely
-M:	grant.likely@secretlab.ca
+M:	Grant Likely <grant.likely@secretlab.ca>
 W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC8XX
-P:	Vitaly Bordug
-M:	vitb@kernel.crashing.org
-P:	Marcelo Tosatti
-M:	marcelo@kvack.org
+M:	Vitaly Bordug <vitb@kernel.crashing.org>
+M:	Marcelo Tosatti <marcelo@kvack.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED PPC83XX AND PPC85XX
-P:	Kumar Gala
-M:	galak@kernel.crashing.org
+M:	Kumar Gala <galak@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
 
 LINUX FOR POWERPC PA SEMI PWRFICIENT
-P:	Olof Johansson
-M:	olof@lixom.net
+M:	Olof Johansson <olof@lixom.net>
 W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 
 LINUX SECURITY MODULE (LSM) FRAMEWORK
-P:	Chris Wright
-M:	chrisw@sous-sol.org
+M:	Chris Wright <chrisw@sous-sol.org>
 L:	linux-security-module@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LLC (802.2)
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Maintained
 F:	include/linux/llc.h
 F:	include/net/llc*
 F:	net/llc/
 
 LIS3LV02D ACCELEROMETER DRIVER
-P:	Eric Piel
-M:	eric.piel@tremplin-utc.net
+M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
 F:	Documentation/hwmon/lis3lv02d
 F:	drivers/hwmon/lis3lv02d.*
 
 LM83 HARDWARE MONITOR DRIVER
-P:	Jean Delvare
-M:	khali@linux-fr.org
+M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm83
 F:	drivers/hwmon/lm83.c
 
 LM90 HARDWARE MONITOR DRIVER
-P:	Jean Delvare
-M:	khali@linux-fr.org
+M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/lm90
 F:	drivers/hwmon/lm90.c
 
 LOCKDEP AND LOCKSTAT
-P:	Peter Zijlstra
-M:	peterz@infradead.org
-P:	Ingo Molnar
-M:	mingo@redhat.com
+M:	Peter Zijlstra <peterz@infradead.org>
+M:	Ingo Molnar <mingo@redhat.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
 S:	Maintained
 F:	Documentation/lockdep*.txt
@@ -3661,8 +3157,7 @@ F:	include/linux/lockdep.h
 F:	kernel/lockdep*
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
-P:	Richard Russon (FlatCap)
-M:	ldm@flatcap.org
+M:	"Richard Russon (FlatCap)" <ldm@flatcap.org>
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
@@ -3670,8 +3165,7 @@ F:	Documentation/ldm.txt
 F:	fs/partitions/ldm.*
 
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
-P:	Eric Moore
-M:	Eric.Moore@lsi.com
+M:	Eric Moore <Eric.Moore@lsi.com>
 M:	support@lsi.com
 L:	DL-MPTFusionLinux@lsi.com
 L:	linux-scsi@vger.kernel.org
@@ -3680,25 +3174,21 @@ S:	Supported
 F:	drivers/message/fusion/
 
 LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
-P:	Matthew Wilcox
-M:	matthew@wil.cx
+M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/sym53c8xx_2/
 
 LTP (Linux Test Project)
-P:	Subrata Modak
-M:	subrata@linux.vnet.ibm.com
-P:	Mike Frysinger
-M:	vapier@gentoo.org
+M:	Subrata Modak <subrata@linux.vnet.ibm.com>
+M:	Mike Frysinger <vapier@gentoo.org>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
 S:	Maintained
 
 M32R ARCHITECTURE
-P:	Hirokazu Takata
-M:	takata@linux-m32r.org
+M:	Hirokazu Takata <takata@linux-m32r.org>
 L:	linux-m32r@ml.linux-m32r.org
 L:	linux-m32r-ja@ml.linux-m32r.org (in Japanese)
 W:	http://www.linux-m32r.org/
@@ -3706,10 +3196,8 @@ S:	Maintained
 F:	arch/m32r/
 
 M68K ARCHITECTURE
-P:	Geert Uytterhoeven
-M:	geert@linux-m68k.org
-P:	Roman Zippel
-M:	zippel@linux-m68k.org
+M:	Geert Uytterhoeven <geert@linux-m68k.org>
+M:	Roman Zippel <zippel@linux-m68k.org>
 L:	linux-m68k@lists.linux-m68k.org
 W:	http://www.linux-m68k.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
@@ -3718,23 +3206,20 @@ F:	arch/m68k/
 F:	drivers/zorro/
 
 M68K ON APPLE MACINTOSH
-P:	Joshua Thompson
-M:	funaho@jurai.org
+M:	Joshua Thompson <funaho@jurai.org>
 W:	http://www.mac.linux-m68k.org/
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 F:	arch/m68k/mac/
 
 M68K ON HP9000/300
-P:	Philip Blundell
-M:	philb@gnu.org
+M:	Philip Blundell <philb@gnu.org>
 W:	http://www.tazenda.demon.co.uk/phil/linux-hp
 S:	Maintained
 F:	arch/m68k/hp300/
 
 MAC80211
-P:	Johannes Berg
-M:	johannes@sipsolutions.net
+M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
@@ -3744,10 +3229,8 @@ F:	include/net/mac80211.h
 F:	net/mac80211/
 
 MAC80211 PID RATE CONTROL
-P:	Stefano Brivio
-M:	stefano.brivio@polimi.it
-P:	Mattias Nissler
-M:	mattias.nissler@gmx.de
+M:	Stefano Brivio <stefano.brivio@polimi.it>
+M:	Mattias Nissler <mattias.nissler@gmx.de>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
@@ -3755,67 +3238,57 @@ S:	Maintained
 F:	net/mac80211/rc80211_pid*
 
 MACVLAN DRIVER
-P:	Patrick McHardy
-M:	kaber@trash.net
+M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_macvlan.h
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
-P:	Michael Kerrisk
-M:	mtk.manpages@gmail.com
+M:	Michael Kerrisk <mtk.manpages@gmail.com>
 W:	http://www.kernel.org/doc/man-pages
 L:	linux-man@vger.kernel.org
 S:	Maintained
 
 MARVELL LIBERTAS WIRELESS DRIVER
-P:	Dan Williams
-M:	dcbw@redhat.com
+M:	Dan Williams <dcbw@redhat.com>
 L:	libertas-dev@lists.infradead.org
 S:	Maintained
 F:	drivers/net/wireless/libertas/
 
 MARVELL MV643XX ETHERNET DRIVER
-P:	Lennert Buytenhek
-M:	buytenh@marvell.com
+M:	Lennert Buytenhek <buytenh@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/mv643xx_eth.*
 F:	include/linux/mv643xx.h
 
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
-P:	Nicolas Pitre
-M:	nico@cam.org
+M:	Nicolas Pitre <nico@cam.org>
 S:	Maintained
 
 MARVELL YUKON / SYSKONNECT DRIVER
-P:	Mirko Lindner
-M:	mlindner@syskonnect.de
-P:	Ralph Roesler
-M:	rroesler@syskonnect.de
+M:	Mirko Lindner <mlindner@syskonnect.de>
+M:	Ralph Roesler <rroesler@syskonnect.de>
 W:	http://www.syskonnect.com
 S:	Supported
 
 MATROX FRAMEBUFFER DRIVER
-P:	Petr Vandrovec
-M:	vandrove@vc.cvut.cz
+M:	Petr Vandrovec <vandrove@vc.cvut.cz>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/matrox/matroxfb_*
 F:	include/linux/matroxfb.h
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
-P:	Hans J. Koch
-M:	hjk@linutronix.de
+M:	"Hans J. Koch" <hjk@linutronix.de>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/max6650
 F:	drivers/hwmon/max6650.c
 
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
-P:	Mauro Carvalho Chehab
-M:	mchehab@infradead.org
+M:	Mauro Carvalho Chehab <mchehab@infradead.org>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
@@ -3829,8 +3302,7 @@ F:	include/linux/dvb/
 F:	include/linux/videodev*.h
 
 MEGARAID SCSI DRIVERS
-P:	Neela Syam Kolli
-M:	megaraidlinux@lsi.com
+M:	Neela Syam Kolli <megaraidlinux@lsi.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://megaraid.lsilogic.com
 S:	Maintained
@@ -3846,19 +3318,15 @@ F:	include/linux/mm.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
-P:	Balbir Singh
-M:	balbir@linux.vnet.ibm.com
-P:	Pavel Emelyanov
-M:	xemul@openvz.org
-P:	KAMEZAWA Hiroyuki
-M:	kamezawa.hiroyu@jp.fujitsu.com
+M:	Balbir Singh <balbir@linux.vnet.ibm.com>
+M:	Pavel Emelyanov <xemul@openvz.org>
+M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 
 MEMORY TECHNOLOGY DEVICES (MTD)
-P:	David Woodhouse
-M:	dwmw2@infradead.org
+M:	David Woodhouse <dwmw2@infradead.org>
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
@@ -3868,8 +3336,7 @@ F:	include/linux/mtd/
 F:	include/mtd/
 
 MICROBLAZE ARCHITECTURE
-P:	Michal Simek
-M:	monstr@monstr.eu
+M:	Michal Simek <monstr@monstr.eu>
 L:	microblaze-uclinux@itee.uq.edu.au
 W:	http://www.monstr.eu/fdt/
 T:	git git://git.monstr.eu/linux-2.6-microblaze.git
@@ -3877,14 +3344,12 @@ S:	Supported
 F:	arch/microblaze/
 
 MICROTEK X6 SCANNER
-P:	Oliver Neukum
-M:	oliver@neukum.name
+M:	Oliver Neukum <oliver@neukum.name>
 S:	Maintained
 F:	drivers/usb/image/microtek.*
 
 MIPS
-P:	Ralf Baechle
-M:	ralf@linux-mips.org
+M:	Ralf Baechle <ralf@linux-mips.org>
 W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
 T:	git git://git.linux-mips.org/pub/scm/linux.git
@@ -3893,8 +3358,7 @@ F:	Documentation/mips/
 F:	arch/mips/
 
 MISCELLANEOUS MCA-SUPPORT
-P:	James Bottomley
-M:	James.Bottomley@HansenPartnership.com
+M:	James Bottomley <James.Bottomley@HansenPartnership.com>
 S:	Maintained
 F:	Documentation/ia64/mca.txt
 F:	Documentation/mca.txt
@@ -3902,15 +3366,13 @@ F:	drivers/mca/
 F:	include/linux/mca*
 
 MODULE SUPPORT
-P:	Rusty Russell
-M:	rusty@rustcorp.com.au
+M:	Rusty Russell <rusty@rustcorp.com.au>
 S:	Maintained
 F:	include/linux/module.h
 F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
-P:	Stelian Pop
-M:	stelian@popies.net
+M:	Stelian Pop <stelian@popies.net>
 W:	http://popies.net/meye/
 S:	Maintained
 F:	Documentation/video4linux/meye.txt
@@ -3918,135 +3380,112 @@ F:	drivers/media/video/meye.*
 F:	include/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
-P:	Pavel Pisa
-M:	ppisa@pikron.com
+M:	Pavel Pisa <ppisa@pikron.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Maintained
 F:	drivers/mmc/host/imxmmc.*
 
 MOUSE AND MISC DEVICES [GENERAL]
-P:	Alessandro Rubini
-M:	rubini@ipvvis.unipv.it
+M:	Alessandro Rubini <rubini@ipvvis.unipv.it>
 S:	Maintained
 F:	drivers/input/mouse/
 F:	include/linux/gpio_mouse.h
 
 MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
-P:	Jiri Slaby
-M:	jirislaby@gmail.com
+M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
-P:	Lennart Poettering
-M:	mzxreary@0pointer.de
+M:	Lennart Poettering <mzxreary@0pointer.de>
 W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
 
 MULTIFUNCTION DEVICES (MFD)
-P:	Samuel Ortiz
-M:	sameo@linux.intel.com
+M:	Samuel Ortiz <sameo@linux.intel.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git
 S:	Supported
 F:	drivers/mfd/
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
-P:	Pierre Ossman
-M:	pierre@ossman.eu
+M:	Pierre Ossman <pierre@ossman.eu>
 S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
 
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	David Brownell <dbrownell@users.sourceforge.net>
 S:	Odd Fixes
 F:	drivers/mmc/host/mmc_spi.c
 F:	include/linux/spi/mmc_spi.h
 
 MULTISOUND SOUND DRIVER
-P:	Andrew Veliath
-M:	andrewtv@usa.net
+M:	Andrew Veliath <andrewtv@usa.net>
 S:	Maintained
 F:	Documentation/sound/oss/MultiSound
 F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
-P:	Jiri Slaby
-M:	jirislaby@gmail.com
+M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
-P:	Felipe Balbi
-M:	felipe.balbi@nokia.com
+M:	Felipe Balbi <felipe.balbi@nokia.com>
 L:	linux-usb@vger.kernel.org
 T:	git git://gitorious.org/musb/mainline.git
 S:	Maintained
 F:	drivers/usb/musb/
 
 MYRICOM MYRI-10G 10GbE DRIVER (MYRI10GE)
-P:	Andrew Gallatin
-M:	gallatin@myri.com
-P:	Brice Goglin
-M:	brice@myri.com
+M:	Andrew Gallatin <gallatin@myri.com>
+M:	Brice Goglin <brice@myri.com>
 L:	netdev@vger.kernel.org
 W:	http://www.myri.com/scs/download-Myri10GE.html
 S:	Supported
 F:	drivers/net/myri10ge/
 
 NATSEMI ETHERNET DRIVER (DP8381x)
-P:	Tim Hockin
-M:	thockin@hockin.org
+M:	Tim Hockin <thockin@hockin.org>
 S:	Maintained
 F:	drivers/net/natsemi.c
 
 NCP FILESYSTEM
-P:	Petr Vandrovec
-M:	vandrove@vc.cvut.cz
+M:	Petr Vandrovec <vandrove@vc.cvut.cz>
 L:	linware@sh.cvut.cz
 S:	Maintained
 F:	fs/ncpfs/
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
-P:	James E.J. Bottomley
-M:	James.Bottomley@HansenPartnership.com
+M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/NCR_D700.*
 
 NETEFFECT IWARP RNIC DRIVER (IW_NES)
-P:	Faisal Latif
-M:	faisal.latif@intel.com
-P:	Chien Tung
-M:	chien.tin.tung@intel.com
+M:	Faisal Latif <faisal.latif@intel.com>
+M:	Chien Tung <chien.tin.tung@intel.com>
 L:	general@lists.openfabrics.org
 W:	http://www.neteffect.com
 S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-P:	Stephen Hemminger
-M:	shemminger@linux-foundation.org
+M:	Stephen Hemminger <shemminger@linux-foundation.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
 
 NETERION (S2IO) 10GbE DRIVER (xframe/vxge)
-P:	Ramkrishna Vepa
-M:	ram.vepa@neterion.com
-P:	Rastapur Santosh
-M:	santosh.rastapur@neterion.com
-P:	Sivakumar Subramani
-M:	sivakumar.subramani@neterion.com
-P:	Sreenivasa Honnur
-M:	sreenivasa.honnur@neterion.com
-P:	Anil Murthy
-M:	anil.murthy@neterion.com
+M:	Ramkrishna Vepa <ram.vepa@neterion.com>
+M:	Rastapur Santosh <santosh.rastapur@neterion.com>
+M:	Sivakumar Subramani <sivakumar.subramani@neterion.com>
+M:	Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
+M:	Anil Murthy <anil.murthy@neterion.com>
 L:	netdev@vger.kernel.org
 W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/Linux?Anonymous
 W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/X3100Linux?Anonymous
@@ -4060,8 +3499,7 @@ P:	Marc Boucher
 P:	James Morris
 P:	Harald Welte
 P:	Jozsef Kadlecsik
-P:	Patrick McHardy
-M:	kaber@trash.net
+M:	Patrick McHardy <kaber@trash.net>
 L:	netfilter-devel@vger.kernel.org
 L:	netfilter@vger.kernel.org
 L:	coreteam@netfilter.org
@@ -4076,8 +3514,7 @@ F:	net/*/netfilter/
 F:	net/netfilter/
 
 NETLABEL
-P:	Paul Moore
-M:	paul.moore@hp.com
+M:	Paul Moore <paul.moore@hp.com>
 W:	http://netlabel.sf.net
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -4086,8 +3523,7 @@ F:	include/net/netlabel.h
 F:	net/netlabel/
 
 NETROM NETWORK LAYER
-P:	Ralf Baechle
-M:	ralf@linux-mips.org
+M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
@@ -4096,16 +3532,14 @@ F:	include/net/netrom.h
 F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
-P:	Paul Clements
-M:	Paul.Clements@steeleye.com
+M:	Paul Clements <Paul.Clements@steeleye.com>
 S:	Maintained
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
 F:	include/linux/nbd.h
 
 NETWORKING [GENERAL]
-P:	David S. Miller
-M:	davem@davemloft.net
+M:	"David S. Miller" <davem@davemloft.net>
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
@@ -4114,18 +3548,12 @@ F:	net/
 F:	include/net/
 
 NETWORKING [IPv4/IPv6]
-P:	David S. Miller
-M:	davem@davemloft.net
-P:	Alexey Kuznetsov
-M:	kuznet@ms2.inr.ac.ru
-P:	Pekka Savola (ipv6)
-M:	pekkas@netcore.fi
-P:	James Morris
-M:	jmorris@namei.org
-P:	Hideaki YOSHIFUJI
-M:	yoshfuji@linux-ipv6.org
-P:	Patrick McHardy
-M:	kaber@trash.net
+M:	"David S. Miller" <davem@davemloft.net>
+M:	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
+M:	"Pekka Savola (ipv6)" <pekkas@netcore.fi>
+M:	James Morris <jmorris@namei.org>
+M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
+M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
@@ -4134,14 +3562,12 @@ F:	net/ipv6/
 F:	include/net/ip*
 
 NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
-P:	Paul Moore
-M:	paul.moore@hp.com
+M:	Paul Moore <paul.moore@hp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 
 NETWORKING [WIRELESS]
-P:	John W. Linville
-M:	linville@tuxdriver.com
+M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
@@ -4157,16 +3583,14 @@ S:	Odd Fixes
 F:	drivers/net/
 
 NETXEN (1/10) GbE SUPPORT
-P:	Dhananjay Phadke
-M:	dhananjay@netxen.com
+M:	Dhananjay Phadke <dhananjay@netxen.com>
 L:	netdev@vger.kernel.org
 W:	http://www.netxen.com
 S:	Supported
 F:	drivers/net/netxen/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
-P:	Trond Myklebust
-M:	Trond.Myklebust@netapp.com
+M:	Trond Myklebust <Trond.Myklebust@netapp.com>
 L:	linux-nfs@vger.kernel.org
 W:	http://client.linux-nfs.org
 T:	git git://git.linux-nfs.org/pub/linux/nfs-2.6.git
@@ -4180,17 +3604,14 @@ F:	include/linux/nfs*
 F:	include/linux/sunrpc/
 
 NI5010 NETWORK DRIVER
-P:	Jan-Pascal van Best
-M:	janpascal@vanbest.org
-P:	Andreas Mohr
-M:	andi@lisas.de
+M:	Jan-Pascal van Best <janpascal@vanbest.org>
+M:	Andreas Mohr <andi@lisas.de>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ni5010.*
 
 NILFS2 FILESYSTEM
-P:	KONISHI Ryusuke
-M:	konishi.ryusuke@lab.ntt.co.jp
+M:	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
 L:	users@nilfs.org
 W:	http://www.nilfs.org/en/
 S:	Supported
@@ -4199,26 +3620,22 @@ F:	fs/nilfs2/
 F:	include/linux/nilfs2_fs.h
 
 NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
-P:	YOKOTA Hiroshi
-M:	yokota@netlab.is.tsukuba.ac.jp
+M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
 F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/pcmcia/nsp_*
 
 NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
-P:	GOTO Masanori
-M:	gotom@debian.or.jp
-P:	YOKOTA Hiroshi
-M:	yokota@netlab.is.tsukuba.ac.jp
+M:	GOTO Masanori <gotom@debian.or.jp>
+M:	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
 W:	http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
 S:	Maintained
 F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/nsp32*
 
 NTFS FILESYSTEM
-P:	Anton Altaparmakov
-M:	aia21@cantab.net
+M:	Anton Altaparmakov <aia21@cantab.net>
 L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
@@ -4227,16 +3644,14 @@ F:	Documentation/filesystems/ntfs.txt
 F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
-P:	Antonino Daplas
-M:	adaplas@gmail.com
+M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/riva/
 F:	drivers/video/nvidia/
 
 OMAP SUPPORT
-P:	Tony Lindgren <tony@atomide.com>
-M:	tony@atomide.com
+M:	"Tony Lindgren <tony@atomide.com>" <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
@@ -4245,97 +3660,83 @@ S:	Maintained
 F:	arch/arm/*omap*
 
 OMAP CLOCK FRAMEWORK SUPPORT
-P:	Paul Walmsley
-M:	paul@pwsan.com
+M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*clock*
 
 OMAP POWER MANAGEMENT SUPPORT
-P:	Kevin Hilman
-M:	khilman@deeprootsystems.com
+M:	Kevin Hilman <khilman@deeprootsystems.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
 
 OMAP AUDIO SUPPORT
-P:	Jarkko Nikula
-M:	jhnikula@gmail.com
+M:	Jarkko Nikula <jhnikula@gmail.com>
 L:	alsa-devel@alsa-project.org (subscribers-only)
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	sound/soc/omap/
 
 OMAP FRAMEBUFFER SUPPORT
-P:	Imre Deak
-M:	imre.deak@nokia.com
+M:	Imre Deak <imre.deak@nokia.com>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/video/omap/
 
 OMAP MMC SUPPORT
-P:	Jarkko Lavinen
-M:	jarkko.lavinen@nokia.com
+M:	Jarkko Lavinen <jarkko.lavinen@nokia.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/*omap*
 
 OMAP RANDOM NUMBER GENERATOR SUPPORT
-P:	Deepak Saxena
-M:	dsaxena@plexity.net
+M:	Deepak Saxena <dsaxena@plexity.net>
 S:	Maintained
 F:	drivers/char/hw_random/omap-rng.c
 
 OMAP USB SUPPORT
-P:	Felipe Balbi
-M:	felipe.balbi@nokia.com
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	Felipe Balbi <felipe.balbi@nokia.com>
+M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 
 OMFS FILESYSTEM
-P:	Bob Copeland
-M:	me@bobcopeland.com
+M:	Bob Copeland <me@bobcopeland.com>
 L:	linux-karma-devel@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/filesystems/omfs.txt
 F:	fs/omfs/
 
 OMNIKEY CARDMAN 4000 DRIVER
-P:	Harald Welte
-M:	laforge@gnumonks.org
+M:	Harald Welte <laforge@gnumonks.org>
 S:	Maintained
 F:	drivers/char/pcmcia/cm4000_cs.c
 F:	include/linux/cm4000_cs.h
 
 OMNIKEY CARDMAN 4040 DRIVER
-P:	Harald Welte
-M:	laforge@gnumonks.org
+M:	Harald Welte <laforge@gnumonks.org>
 S:	Maintained
 F:	drivers/char/pcmcia/cm4040_cs.*
 
 OMNIVISION OV7670 SENSOR DRIVER
-P:	Jonathan Corbet
-M:	corbet@lwn.net
+M:	Jonathan Corbet <corbet@lwn.net>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/ov7670.c
 
 ONENAND FLASH DRIVER
-P:	Kyungmin Park
-M:	kyungmin.park@samsung.com
+M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/onenand/
 F:	include/linux/mtd/onenand*.h
 
 ONSTREAM SCSI TAPE DRIVER
-P:	Willem Riede
-M:	osst@riede.org
+M:	Willem Riede <osst@riede.org>
 L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
@@ -4343,16 +3744,14 @@ F:	drivers/scsi/osst*
 F:	drivers/scsi/st*
 
 OPENCORES I2C BUS DRIVER
-P:	Peter Korsgaard
-M:	jacmet@sunsite.dk
+M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
 OPROFILE
-P:	Robert Richter
-M:	robert.richter@amd.com
+M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 F:	arch/*/oprofile/
@@ -4360,10 +3759,8 @@ F:	drivers/oprofile/
 F:	include/linux/oprofile.h
 
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
-P:	Mark Fasheh
-M:	mfasheh@suse.com
-P:	Joel Becker
-M:	joel.becker@oracle.com
+M:	Mark Fasheh <mfasheh@suse.com>
+M:	Joel Becker <joel.becker@oracle.com>
 L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
 W:	http://oss.oracle.com/projects/ocfs2/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git
@@ -4373,10 +3770,8 @@ F:	Documentation/filesystems/dlmfs.txt
 F:	fs/ocfs2/
 
 ORINOCO DRIVER
-P:	Pavel Roskin
-M:	proski@gnu.org
-P:	David Gibson
-M:	hermes@gibson.dropbear.id.au
+M:	Pavel Roskin <proski@gnu.org>
+M:	David Gibson <hermes@gibson.dropbear.id.au>
 L:	linux-wireless@vger.kernel.org
 L:	orinoco-users@lists.sourceforge.net
 L:	orinoco-devel@lists.sourceforge.net
@@ -4385,10 +3780,8 @@ S:	Maintained
 F:	drivers/net/wireless/orinoco/
 
 OSD LIBRARY and FILESYSTEM
-P:	Boaz Harrosh
-M:	bharrosh@panasas.com
-P:	Benny Halevy
-M:	bhalevy@panasas.com
+M:	Boaz Harrosh <bharrosh@panasas.com>
+M:	Benny Halevy <bhalevy@panasas.com>
 L:	osd-dev@open-osd.org
 W:	http://open-osd.org
 T:	git git://git.open-osd.org/open-osd.git
@@ -4398,8 +3791,7 @@ F:	drivers/include/scsi/osd_*
 F:	fs/exofs/
 
 P54 WIRELESS DRIVER
-P:	Michael Wu
-M:	flamingice@sourmilk.net
+M:	Michael Wu <flamingice@sourmilk.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
@@ -4407,30 +3799,25 @@ S:	Maintained
 F:	drivers/net/wireless/p54/
 
 PA SEMI ETHERNET DRIVER
-P:	Olof Johansson
-M:	olof@lixom.net
+M:	Olof Johansson <olof@lixom.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/pasemi_mac.*
 
 PA SEMI SMBUS DRIVER
-P:	Olof Johansson
-M:	olof@lixom.net
+M:	Olof Johansson <olof@lixom.net>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-pasemi.c
 
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
-P:	Harald Welte
-M:	laforge@gnumonks.org
+M:	Harald Welte <laforge@gnumonks.org>
 S:	Maintained
 F:	drivers/platform/x86/panasonic-laptop.c
 
 PANASONIC MN10300/AM33 PORT
-P:	David Howells
-M:	dhowells@redhat.com
-P:	Koichi Yasutake
-M:	yasutake.koichi@jp.panasonic.com
+M:	David Howells <dhowells@redhat.com>
+M:	Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
 L:	linux-am33-list@redhat.com (moderated for non-subscribers)
 W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
 S:	Maintained
@@ -4446,14 +3833,10 @@ F:	drivers/char/ppdev.c
 F:	include/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
-P:	Jeremy Fitzhardinge
-M:	jeremy@xensource.com
-P:	Chris Wright
-M:	chrisw@sous-sol.org
-P:	Alok Kataria
-M:	akataria@vmware.com
-P:	Rusty Russell
-M:	rusty@rustcorp.com.au
+M:	Jeremy Fitzhardinge <jeremy@xensource.com>
+M:	Chris Wright <chrisw@sous-sol.org>
+M:	Alok Kataria <akataria@vmware.com>
+M:	Rusty Russell <rusty@rustcorp.com.au>
 L:	virtualization@lists.osdl.org
 S:	Supported
 F:	Documentation/ia64/paravirt_ops.txt
@@ -4461,8 +3844,7 @@ F:	arch/*/kernel/paravirt*
 F:	arch/*/include/asm/paravirt.h
 
 PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
-P:	Tim Waugh
-M:	tim@cyberelk.net
+M:	Tim Waugh <tim@cyberelk.net>
 L:	linux-parport@lists.infradead.org (subscribers-only)
 W:	http://www.torque.net/linux-pp.html
 S:	Maintained
@@ -4470,10 +3852,8 @@ F:	Documentation/blockdev/paride.txt
 F:	drivers/block/paride/
 
 PARISC ARCHITECTURE
-P:	Kyle McMartin
-M:	kyle@mcmartin.ca
-P:	Helge Deller
-M:	deller@gmx.de
+M:	Kyle McMartin <kyle@mcmartin.ca>
+M:	Helge Deller <deller@gmx.de>
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
@@ -4482,37 +3862,32 @@ F:	arch/parisc/
 F:	drivers/parisc/
 
 PC87360 HARDWARE MONITORING DRIVER
-P:	Jim Cromie
-M:	jim.cromie@gmail.com
+M:	Jim Cromie <jim.cromie@gmail.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/pc87360
 F:	drivers/hwmon/pc87360.c
 
 PC8736x GPIO DRIVER
-P:	Jim Cromie
-M:	jim.cromie@gmail.com
+M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Maintained
 F:	drivers/char/pc8736x_gpio.c
 
 PCA9532 LED DRIVER
-P:	Riku Voipio
-M:	riku.voipio@iki.fi
+M:	Riku Voipio <riku.voipio@iki.fi>
 S:	Maintained
 F:	drivers/leds/leds-pca9532.c
 F:	include/linux/leds-pca9532.h
 
 PCI ERROR RECOVERY
-P:	Linas Vepstas
-M:	linas@austin.ibm.com
+M:	Linas Vepstas <linas@austin.ibm.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt
 F:	Documentation/powerpc/eeh-pci-error-recovery.txt
 
 PCI SUBSYSTEM
-P:	Jesse Barnes
-M:	jbarnes@virtuousgeek.org
+M:	Jesse Barnes <jbarnes@virtuousgeek.org>
 L:	linux-pci@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
@@ -4521,8 +3896,7 @@ F:	drivers/pci/
 F:	include/linux/pci*
 
 PCIE HOTPLUG DRIVER
-P:	Kristen Carlson Accardi
-M:	kristen.c.accardi@intel.com
+M:	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/pcie/
@@ -4538,113 +3912,94 @@ F:	drivers/pcmcia/
 F:	include/pcmcia/
 
 PCNET32 NETWORK DRIVER
-P:	Don Fry
-M:	pcnet32@verizon.net
+M:	Don Fry <pcnet32@verizon.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/pcnet32.c
 
 PER-TASK DELAY ACCOUNTING
-P:	Balbir Singh
-M:	balbir@linux.vnet.ibm.com
+M:	Balbir Singh <balbir@linux.vnet.ibm.com>
 S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
 
 PERFORMANCE COUNTER SUBSYSTEM
-P:	Peter Zijlstra
-M:	a.p.zijlstra@chello.nl
-P:	Paul Mackerras
-M:	paulus@samba.org
-P:	Ingo Molnar
-M:	mingo@elte.hu
+M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
+M:	Paul Mackerras <paulus@samba.org>
+M:	Ingo Molnar <mingo@elte.hu>
 S:	Supported
 
 PERSONALITY HANDLING
-P:	Christoph Hellwig
-M:	hch@infradead.org
+M:	Christoph Hellwig <hch@infradead.org>
 L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
 F:	include/linux/personality.h
 
 PHRAM MTD DRIVER
-P:	Joern Engel
-M:	joern@lazybastard.org
+M:	Joern Engel <joern@lazybastard.org>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/devices/phram.c
 
 PKTCDVD DRIVER
-P:	Peter Osterlund
-M:	petero2@telia.com
+M:	Peter Osterlund <petero2@telia.com>
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
 
 POSIX CLOCKS and TIMERS
-P:	Thomas Gleixner
-M:	tglx@linutronix.de
+M:	Thomas Gleixner <tglx@linutronix.de>
 S:	Supported
 F:	fs/timerfd.c
 F:	include/linux/timer*
 F:	kernel/*timer*
 
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
-P:	Anton Vorontsov
-M:	cbou@mail.ru
-P:	David Woodhouse
-M:	dwmw2@infradead.org
+M:	Anton Vorontsov <cbou@mail.ru>
+M:	David Woodhouse <dwmw2@infradead.org>
 T:	git git://git.infradead.org/battery-2.6.git
 S:	Maintained
 F:	include/linux/power_supply.h
 F:	drivers/power/power_supply*
 
 PNP SUPPORT
-P:	Adam Belay
-M:	abelay@mit.edu
-P:	Bjorn Helgaas
-M:	bjorn.helgaas@hp.com
+M:	Adam Belay <abelay@mit.edu>
+M:	Bjorn Helgaas <bjorn.helgaas@hp.com>
 S:	Maintained
 F:	drivers/pnp/
 
 PNXxxxx I2C DRIVER
-P:	Vitaly Wool
-M:	vitalywool@gmail.com
+M:	Vitaly Wool <vitalywool@gmail.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-pnx.c
 
 PPP PROTOCOL DRIVERS AND COMPRESSORS
-P:	Paul Mackerras
-M:	paulus@samba.org
+M:	Paul Mackerras <paulus@samba.org>
 L:	linux-ppp@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ppp_*
 
 PPP OVER ATM (RFC 2364)
-P:	Mitchell Blank Jr
-M:	mitch@sfgoth.com
+M:	Mitchell Blank Jr <mitch@sfgoth.com>
 S:	Maintained
 F:	net/atm/pppoatm.c
 F:	include/linux/atmppp.h
 
 PPP OVER ETHERNET
-P:	Michal Ostrowski
-M:	mostrows@earthlink.net
+M:	Michal Ostrowski <mostrows@earthlink.net>
 S:	Maintained
 F:	drivers/net/pppoe.c
 F:	drivers/net/pppox.c
 
 PPP OVER L2TP
-P:	James Chapman
-M:	jchapman@katalix.com
+M:	James Chapman <jchapman@katalix.com>
 S:	Maintained
 F:	drivers/net/pppol2tp.c
 F:	include/linux/if_pppol2tp.h
 
 PPS SUPPORT
-P:	Rodolfo Giometti
-M:	giometti@enneenne.com
+M:	Rodolfo Giometti <giometti@enneenne.com>
 W:	http://wiki.enneenne.com/index.php/LinuxPPS_support
 L:	linuxpps@ml.enneenne.com (subscribers-only)
 S:	Maintained
@@ -4653,8 +4008,7 @@ F:	drivers/pps/
 F:	include/linux/pps*.h
 
 PREEMPTIBLE KERNEL
-P:	Robert Love
-M:	rml@tech9.net
+M:	Robert Love <rml@tech9.net>
 L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
@@ -4662,37 +4016,32 @@ F:	Documentation/preempt-locking.txt
 F:	include/linux/preempt.h
 
 PRISM54 WIRELESS DRIVER
-P:	Luis R. Rodriguez
-M:	mcgrof@gmail.com
+M:	"Luis R. Rodriguez" <mcgrof@gmail.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 S:	Maintained
 F:	drivers/net/wireless/prism54/
 
 PROMISE DC4030 CACHING DISK CONTROLLER DRIVER
-P:	Peter Denison
-M:	promise@pnd-pc.demon.co.uk
+M:	Peter Denison <promise@pnd-pc.demon.co.uk>
 W:	http://www.pnd-pc.demon.co.uk/promise/
 S:	Maintained
 
 PROMISE SATA TX2/TX4 CONTROLLER LIBATA DRIVER
-P:	Mikael Pettersson
-M:	mikpe@it.uu.se
+M:	Mikael Pettersson <mikpe@it.uu.se>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	drivers/ata/sata_promise.*
 
 PS3 NETWORK SUPPORT
-P:	Geoff Levand
-M:	geoffrey.levand@am.sony.com
+M:	Geoff Levand <geoffrey.levand@am.sony.com>
 L:	netdev@vger.kernel.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
 F:	drivers/net/ps3_gelic_net.*
 
 PS3 PLATFORM SUPPORT
-P:	Geoff Levand
-M:	geoffrey.levand@am.sony.com
+M:	Geoff Levand <geoffrey.levand@am.sony.com>
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
@@ -4707,16 +4056,13 @@ F:	drivers/usb/host/*ps3.c
 F:	sound/ppc/snd_ps3*
 
 PS3VRAM DRIVER
-P:	Jim Paris
-M:	jim@jtan.com
+M:	Jim Paris <jim@jtan.com>
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
 
 PTRACE SUPPORT
-P:	Roland McGrath
-M:	roland@redhat.com
-P:	Oleg Nesterov
-M:	oleg@redhat.com
+M:	Roland McGrath <roland@redhat.com>
+M:	Oleg Nesterov <oleg@redhat.com>
 S:	Maintained
 F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
@@ -4725,8 +4071,7 @@ F:	include/linux/tracehook.h
 F:	kernel/ptrace.c
 
 PVRUSB2 VIDEO4LINUX DRIVER
-P:	Mike Isely
-M:	isely@pobox.com
+M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
 L:	linux-media@vger.kernel.org
 W:	http://www.isely.net/pvrusb2/
@@ -4736,10 +4081,8 @@ F:	Documentation/video4linux/README.pvrusb2
 F:	drivers/media/video/pvrusb2/
 
 PXA2xx/PXA3xx SUPPORT
-P:	Eric Miao
-M:	eric.y.miao@gmail.com
-P:	Russell King
-M:	linux@arm.linux.org.uk
+M:	Eric Miao <eric.y.miao@gmail.com>
+M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
 F:	arch/arm/mach-pxa/
@@ -4751,17 +4094,14 @@ F:	sound/arm/pxa*
 F:	sound/soc/pxa
 
 PXA168 SUPPORT
-P:	Eric Miao
-M:	eric.y.miao@gmail.com
-P:	Jason Chagas
-M:	jason.chagas@marvell.com
+M:	Eric Miao <eric.y.miao@gmail.com>
+M:	Jason Chagas <jason.chagas@marvell.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
 
 PXA910 SUPPORT
-P:	Eric Miao
-M:	eric.y.miao@gmail.com
+M:	Eric Miao <eric.y.miao@gmail.com>
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git
 S:	Maintained
@@ -4770,14 +4110,12 @@ PXA MMCI DRIVER
 S:	Orphan
 
 PXA RTC DRIVER
-P:	Robert Jarzmik
-M:	robert.jarzmik@free.fr
+M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	rtc-linux@googlegroups.com
 S:	Maintained
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
-P:	Andrew Vasquez
-M:	andrew.vasquez@qlogic.com
+M:	Andrew Vasquez <andrew.vasquez@qlogic.com>
 M:	linux-driver@qlogic.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
@@ -4785,8 +4123,7 @@ F:	Documentation/scsi/LICENSE.qla2xxx
 F:	drivers/scsi/qla2xxx/
 
 QLOGIC QLA3XXX NETWORK DRIVER
-P:	Ron Mercer
-M:	ron.mercer@qlogic.com
+M:	Ron Mercer <ron.mercer@qlogic.com>
 M:	linux-driver@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -4794,16 +4131,14 @@ F:	Documentation/networking/LICENSE.qla3xxx
 F:	drivers/net/qla3xxx.*
 
 QLOGIC QLGE 10Gb ETHERNET DRIVER
-P:	Ron Mercer
-M:	ron.mercer@qlogic.com
+M:	Ron Mercer <ron.mercer@qlogic.com>
 M:	linux-driver@qlogic.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/qlge/
 
 QNX4 FILESYSTEM
-P:	Anders Larsen
-M:	al@alarsen.net
+M:	Anders Larsen <al@alarsen.net>
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
 F:	fs/qnx4/
@@ -4811,16 +4146,14 @@ F:	include/linux/qnx4_fs.h
 F:	include/linux/qnxtypes.h
 
 RADEON FRAMEBUFFER DISPLAY DRIVER
-P:	Benjamin Herrenschmidt
-M:	benh@kernel.crashing.org
+M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/aty/radeon*
 F:	include/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
-P:	Paul Mackerras
-M:	paulus@samba.org
+M:	Paul Mackerras <paulus@samba.org>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/aty/aty128fb.c
@@ -4835,64 +4168,53 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
-P:	Nick Piggin
-M:	npiggin@suse.de
+M:	Nick Piggin <npiggin@suse.de>
 S:	Maintained
 F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
 RANDOM NUMBER DRIVER
-P:	Matt Mackall
-M:	mpm@selenic.com
+M:	Matt Mackall <mpm@selenic.com>
 S:	Maintained
 F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
-P:	Matt Porter
-M:	mporter@kernel.crashing.org
+M:	Matt Porter <mporter@kernel.crashing.org>
 S:	Maintained
 F:	drivers/rapidio/
 
 RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
-P:	Corey Thomas
-M:	coreythomas@charter.net
+M:	Corey Thomas <coreythomas@charter.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/ray*
 
 RCUTORTURE MODULE
-P:	Josh Triplett
-M:	josh@freedesktop.org
-P:	Paul E. McKenney
-M:	paulmck@linux.vnet.ibm.com
+M:	Josh Triplett <josh@freedesktop.org>
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Maintained
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
 RDC R-321X SoC
-P:	Florian Fainelli
-M:	florian@openwrt.org
+M:	Florian Fainelli <florian@openwrt.org>
 S:	Maintained
 
 RDC R6040 FAST ETHERNET DRIVER
-P:	Florian Fainelli
-M:	florian@openwrt.org
+M:	Florian Fainelli <florian@openwrt.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/r6040.c
 
 RDS - RELIABLE DATAGRAM SOCKETS
-P:	Andy Grover
-M:	andy.grover@oracle.com
+M:	Andy Grover <andy.grover@oracle.com>
 L:	rds-devel@oss.oracle.com (moderated for non-subscribers)
 S:	Supported
 F:	net/rds/
 
 READ-COPY UPDATE (RCU)
-P:	Dipankar Sarma
-M:	dipankar@in.ibm.com
-P:	Paul E. McKenney
-M:	paulmck@linux.vnet.ibm.com
+M:	Dipankar Sarma <dipankar@in.ibm.com>
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
 F:	Documentation/RCU/rcu.txt
@@ -4902,16 +4224,14 @@ F:	include/linux/srcu.h
 F:	kernel/rcupdate.c
 
 REAL TIME CLOCK DRIVER
-P:	Paul Gortmaker
-M:	p_gortmaker@yahoo.com
+M:	Paul Gortmaker <p_gortmaker@yahoo.com>
 S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
 F:	include/linux/rtc.h
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
-P:	Alessandro Zummo
-M:	a.zummo@towertech.it
+M:	Alessandro Zummo <a.zummo@towertech.it>
 L:	rtc-linux@googlegroups.com
 S:	Maintained
 F:	Documentation/rtc.txt
@@ -4924,8 +4244,7 @@ S:	Supported
 F:	fs/reiserfs/
 
 RFKILL
-P:	Johannes Berg
-M:	johannes@sipsolutions.net
+M:	Johannes Berg <johannes@sipsolutions.net>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F	Documentation/rfkill.txt
@@ -4944,8 +4263,7 @@ F:	Documentation/serial/rocket.txt
 F:	drivers/char/rocket*
 
 ROSE NETWORK LAYER
-P:	Ralf Baechle
-M:	ralf@linux-mips.org
+M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
@@ -4954,8 +4272,7 @@ F:	include/net/rose.h
 F:	net/rose/
 
 RTL8180 WIRELESS DRIVER
-P:	John W. Linville
-M:	linville@tuxdriver.com
+M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
@@ -4963,12 +4280,9 @@ S:	Maintained
 F:	drivers/net/wireless/rtl818*
 
 RTL8187 WIRELESS DRIVER
-P:	Herton Ronaldo Krzesinski
-M:	herton@mandriva.com.br
-P:	Hin-Tak Leung
-M:	htl10@users.sourceforge.net
-P:	Larry Finger
-M:	Larry.Finger@lwfinger.net
+M:	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
+M:	Hin-Tak Leung <htl10@users.sourceforge.net>
+M:	Larry Finger <Larry.Finger@lwfinger.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
@@ -4976,17 +4290,14 @@ S:	Maintained
 F:	drivers/net/wireless/rtl818x/rtl8187*
 
 S3 SAVAGE FRAMEBUFFER DRIVER
-P:	Antonino Daplas
-M:	adaplas@gmail.com
+M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/savage/
 
 S390
-P:	Martin Schwidefsky
-M:	schwidefsky@de.ibm.com
-P:	Heiko Carstens
-M:	heiko.carstens@de.ibm.com
+M:	Martin Schwidefsky <schwidefsky@de.ibm.com>
+M:	Heiko Carstens <heiko.carstens@de.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -4994,10 +4305,8 @@ S:	Supported
 F:	arch/s390/
 
 S390 NETWORK DRIVERS
-P:	Ursula Braun
-M:	ursula.braun@de.ibm.com
-P:	Frank Blaschka
-M:	blaschka@linux.vnet.ibm.com
+M:	Ursula Braun <ursula.braun@de.ibm.com>
+M:	Frank Blaschka <blaschka@linux.vnet.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -5005,20 +4314,16 @@ S:	Supported
 F:	drivers/s390/net/
 
 S390 ZCRYPT DRIVER
-P:	Felix Beck
-M:	felix.beck@de.ibm.com
-P:	Ralph Wuerthner
-M:	ralph.wuerthner@de.ibm.com
+M:	Felix Beck <felix.beck@de.ibm.com>
+M:	Ralph Wuerthner <ralph.wuerthner@de.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 S:	Supported
 F:	drivers/s390/crypto/
 
 S390 ZFCP DRIVER
-P:	Christof Schmitt
-M:	christof.schmitt@de.ibm.com
-P:	Martin Peschke
-M:	mp3@de.ibm.com
+M:	Christof Schmitt <christof.schmitt@de.ibm.com>
+M:	Martin Peschke <mp3@de.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -5027,8 +4332,7 @@ F:	Documentation/s390/zfcpdump.txt
 F:	drivers/s390/scsi/zfcp_*
 
 S390 IUCV NETWORK LAYER
-P:	Ursula Braun
-M:	ursula.braun@de.ibm.com
+M:	Ursula Braun <ursula.braun@de.ibm.com>
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
@@ -5038,15 +4342,13 @@ F:	include/net/iucv/
 F:	net/iucv/
 
 S3C24XX SD/MMC Driver
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
 F:	drivers/mmc/host/s3cmci.*
 
 SAA7146 VIDEO4LINUX-2 DRIVER
-P:	Michael Hunold
-M:	michael@mihu.de
+M:	Michael Hunold <michael@mihu.de>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.mihu.de/linux/saa7146
@@ -5056,31 +4358,26 @@ F:	drivers/media/video/*7146*
 F:	include/media/*7146*
 
 SC1200 WDT DRIVER
-P:	Zwane Mwaikambo
-M:	zwane@arm.linux.org.uk
+M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
 S:	Maintained
 F:	drivers/watchdog/sc1200wdt.c
 
 SCHEDULER
-P:	Ingo Molnar
-M:	mingo@elte.hu
-P:	Peter Zijlstra
-M:	peterz@infradead.org
+M:	Ingo Molnar <mingo@elte.hu>
+M:	Peter Zijlstra <peterz@infradead.org>
 S:	Maintained
 F:	kernel/sched*
 F:	include/linux/sched.h
 
 SCSI CDROM DRIVER
-P:	Jens Axboe
-M:	axboe@kernel.dk
+M:	Jens Axboe <axboe@kernel.dk>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 F:	drivers/scsi/sr*
 
 SCSI SG DRIVER
-P:	Doug Gilbert
-M:	dgilbert@interlog.com
+M:	Doug Gilbert <dgilbert@interlog.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.torque.net/sg
 S:	Maintained
@@ -5088,8 +4385,7 @@ F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
-P:	James E.J. Bottomley
-M:	James.Bottomley@HansenPartnership.com
+M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
@@ -5099,18 +4395,15 @@ F:	drivers/scsi/
 F:	include/scsi/
 
 SCSI TAPE DRIVER
-P:	Kai Mäkisara
-M:	Kai.Makisara@kolumbus.fi
+M:	Kai Mäkisara <Kai.Makisara@kolumbus.fi>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/st.txt
 F:	drivers/scsi/st*
 
 SCTP PROTOCOL
-P:	Vlad Yasevich
-M:	vladislav.yasevich@hp.com
-P:	Sridhar Samudrala
-M:	sri@us.ibm.com
+M:	Vlad Yasevich <vladislav.yasevich@hp.com>
+M:	Sridhar Samudrala <sri@us.ibm.com>
 L:	linux-sctp@vger.kernel.org
 W:	http://lksctp.sourceforge.net
 S:	Supported
@@ -5120,8 +4413,7 @@ F:	include/net/sctp/
 F:	net/sctp/
 
 SCx200 CPU SUPPORT
-P:	Jim Cromie
-M:	jim.cromie@gmail.com
+M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Odd Fixes
 F:	Documentation/i2c/busses/scx200_acb
 F:	arch/x86/kernel/scx200_32.c
@@ -5131,49 +4423,42 @@ F:	drivers/mtd/maps/scx200_docflash.c
 F:	include/linux/scx200.h
 
 SCx200 GPIO DRIVER
-P:	Jim Cromie
-M:	jim.cromie@gmail.com
+M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Maintained
 F:	drivers/char/scx200_gpio.c
 F:	include/linux/scx200_gpio.h
 
 SCx200 HRT CLOCKSOURCE DRIVER
-P:	Jim Cromie
-M:	jim.cromie@gmail.com
+M:	Jim Cromie <jim.cromie@gmail.com>
 S:	Maintained
 F:	drivers/clocksource/scx200_hrt.c
 
 SDRICOH_CS MMC/SD HOST CONTROLLER INTERFACE DRIVER
-P:	Sascha Sommer
-M:	saschasommer@freenet.de
+M:	Sascha Sommer <saschasommer@freenet.de>
 L:	sdricohcs-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-P:	Pierre Ossman
-M:	pierre@ossman.eu
+M:	Pierre Ossman <pierre@ossman.eu>
 L:	sdhci-devel@lists.ossman.eu
 S:	Maintained
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
-P:	Anton Vorontsov
-M:	avorontsov@ru.mvista.com
+M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@ozlabs.org
 L:	sdhci-devel@lists.ossman.eu
 S:	Maintained
 F:	drivers/mmc/host/sdhci.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
-P:	Ben Dooks
-M:	ben-linux@fluff.org
+M:	Ben Dooks <ben-linux@fluff.org>
 L:	sdhci-devel@lists.ossman.eu
 S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
 SECURITY SUBSYSTEM
-P:	James Morris
-M:	jmorris@namei.org
+M:	James Morris <jmorris@namei.org>
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 W:	http://security.wiki.kernel.org/
@@ -5181,17 +4466,13 @@ S:	Supported
 F:	security/
 
 SECURITY CONTACT
-P:	Security Officers
-M:	security@kernel.org
+M:	Security Officers <security@kernel.org>
 S:	Supported
 
 SELINUX SECURITY MODULE
-P:	Stephen Smalley
-M:	sds@tycho.nsa.gov
-P:	James Morris
-M:	jmorris@namei.org
-P:	Eric Paris
-M:	eparis@parisplace.org
+M:	Stephen Smalley <sds@tycho.nsa.gov>
+M:	James Morris <jmorris@namei.org>
+M:	Eric Paris <eparis@parisplace.org>
 L:	selinux@tycho.nsa.gov (subscribers-only, general discussion)
 W:	http://selinuxproject.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
@@ -5200,15 +4481,13 @@ F:	include/linux/selinux*
 F:	security/selinux/
 
 SENSABLE PHANTOM
-P:	Jiri Slaby
-M:	jirislaby@gmail.com
+M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM
-P:	Jeff Garzik
-M:	jgarzik@pobox.com
+M:	Jeff Garzik <jgarzik@pobox.com>
 L:	linux-ide@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
@@ -5217,10 +4496,8 @@ F:	include/linux/ata.h
 F:	include/linux/libata.h
 
 SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
-P:	Sathya Perla
-M:	sathyap@serverengines.com
-P:	Subbu Seetharaman
-M:	subbus@serverengines.com
+M:	Sathya Perla <sathyap@serverengines.com>
+M:	Subbu Seetharaman <subbus@serverengines.com>
 L:	netdev@vger.kernel.org
 W:	http://www.serverengines.com
 S:	Supported
@@ -5229,20 +4506,17 @@ F:	drivers/net/benet/
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
-P:	Robert Stonehouse
-M:	linux-net-drivers@solarflare.com
+M:	Robert Stonehouse <linux-net-drivers@solarflare.com>
 S:	Supported
 F:	drivers/net/sfc/
 
 SGI GRU DRIVER
-P:	Jack Steiner
-M:	steiner@sgi.com
+M:	Jack Steiner <steiner@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-gru/
 
 SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
-P:	Pat Gefre
-M:	pfg@sgi.com
+M:	Pat Gefre <pfg@sgi.com>
 L:	linux-ia64@vger.kernel.org
 S:	Supported
 F:	Documentation/ia64/serial.txt
@@ -5250,22 +4524,19 @@ F:	drivers/serial/ioc?_serial.c
 F:	include/linux/ioc?.h
 
 SGI VISUAL WORKSTATION 320 AND 540
-P:	Andrey Panin
-M:	pazke@donpac.ru
+M:	Andrey Panin <pazke@donpac.ru>
 L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 F:	Documentation/sgi-visws.txt
 
 SGI XP/XPC/XPNET DRIVER
-P:	Robin Holt
-M:	holt@sgi.com
+M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
 SHARP LH SUPPORT (LH7952X & LH7A40X)
-P:	Marc Singer
-M:	elf@buici.com
+M:	Marc Singer <elf@buici.com>
 W:	http://projects.buici.com/arm
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
@@ -5276,23 +4547,20 @@ F:	drivers/usb/gadget/lh7a40*
 F:	drivers/usb/host/ohci-lh7a40*
 
 SHPC HOTPLUG DRIVER
-P:	Kristen Carlson Accardi
-M:	kristen.c.accardi@intel.com
+M:	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/hotplug/shpchp*
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-P:	Vincent Sanders
-M:	support@simtec.co.uk
+M:	Vincent Sanders <support@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
-P:	Vincent Sanders
-M:	support@simtec.co.uk
+M:	Vincent Sanders <support@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB2410ITX/
 S:	Supported
 F:	arch/arm/mach-s3c2410/
@@ -5300,31 +4568,27 @@ F:	drivers/*/*s3c2410*
 F:	drivers/*/*/*s3c2410*
 
 SIS 190 ETHERNET DRIVER
-P:	Francois Romieu
-M:	romieu@fr.zoreil.com
+M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/sis190.c
 
 SIS 900/7016 FAST ETHERNET DRIVER
-P:	Daniele Venzano
-M:	venza@brownhat.org
+M:	Daniele Venzano <venza@brownhat.org>
 W:	http://www.brownhat.org/sis900.html
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/sis900.*
 
 SIS 96X I2C/SMBUS DRIVER
-P:	Mark M. Hoffman
-M:	mhoffman@lightlink.com
+M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-sis96x
 F:	drivers/i2c/busses/i2c-sis96x.c
 
 SIS FRAMEBUFFER DRIVER
-P:	Thomas Winischhofer
-M:	thomas@winischhofer.net
+M:	Thomas Winischhofer <thomas@winischhofer.net>
 W:	http://www.winischhofer.net/linuxsisvga.shtml
 S:	Maintained
 F:	Documentation/fb/sisfb.txt
@@ -5332,70 +4596,59 @@ F:	drivers/video/sis/
 F:	include/video/sisfb.h
 
 SIS USB2VGA DRIVER
-P:	Thomas Winischhofer
-M:	thomas@winischhofer.net
+M:	Thomas Winischhofer <thomas@winischhofer.net>
 W:	http://www.winischhofer.at/linuxsisusbvga.shtml
 S:	Maintained
 F:	drivers/usb/misc/sisusbvga/
 
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
-P:	Stephen Hemminger
-M:	shemminger@linux-foundation.org
+M:	Stephen Hemminger <shemminger@linux-foundation.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/skge.*
 F:	drivers/net/sky2.*
 
 SLAB ALLOCATOR
-P:	Christoph Lameter
-M:	cl@linux-foundation.org
-P:	Pekka Enberg
-M:	penberg@cs.helsinki.fi
-P:	Matt Mackall
-M:	mpm@selenic.com
+M:	Christoph Lameter <cl@linux-foundation.org>
+M:	Pekka Enberg <penberg@cs.helsinki.fi>
+M:	Matt Mackall <mpm@selenic.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/sl?b*.h
 F:	mm/sl?b.c
 
 SMC91x ETHERNET DRIVER
-P:	Nicolas Pitre
-M:	nico@cam.org
+M:	Nicolas Pitre <nico@cam.org>
 S:	Maintained
 F:	drivers/net/smc91x.*
 
 SMSC47B397 HARDWARE MONITOR DRIVER
-P:	Mark M. Hoffman
-M:	mhoffman@lightlink.com
+M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/smsc47b397
 F:	drivers/hwmon/smsc47b397.c
 
 SMSC911x ETHERNET DRIVER
-P:	Steve Glendinning
-M:	steve.glendinning@smsc.com
+M:	Steve Glendinning <steve.glendinning@smsc.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	include/linux/smsc911x.h
 F:	drivers/net/smsc911x.*
 
 SMSC9420 PCI ETHERNET DRIVER
-P:	Steve Glendinning
-M:	steve.glendinning@smsc.com
+M:	Steve Glendinning <steve.glendinning@smsc.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/smsc9420.*
 
 SMX UIO Interface
-P:	Ben Nizette
-M:	bn@niasdigital.com
+M:	Ben Nizette <bn@niasdigital.com>
 S:	Maintained
 F:	drivers/uio/uio_smx.c
 
 SN-IA64 (Itanium) SUB-PLATFORM
-P:	Jes Sorensen
-M:	jes@sgi.com
+M:	Jes Sorensen <jes@sgi.com>
 L:	linux-altix@sgi.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.sgi.com/altix
@@ -5403,8 +4656,7 @@ S:	Maintained
 F:	arch/ia64/sn/
 
 SOC-CAMERA V4L2 SUBSYSTEM
-P:	Guennadi Liakhovetski
-M:	g.liakhovetski@gmx.de
+M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
@@ -5412,37 +4664,32 @@ F:	include/media/v4l2*
 F:	drivers/media/video/v4l2*
 
 SOEKRIS NET48XX LED SUPPORT
-P:	Chris Boot
-M:	bootc@bootc.net
+M:	Chris Boot <bootc@bootc.net>
 S:	Maintained
 F:	drivers/leds/leds-net48xx.c
 
 SOFTWARE RAID (Multiple Disks) SUPPORT
-P:	Neil Brown
-M:	neilb@suse.de
+M:	Neil Brown <neilb@suse.de>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 F:	drivers/md/
 F:	include/linux/raid/
 
 SONIC NETWORK DRIVER
-P:	Thomas Bogendoerfer
-M:	tsbogend@alpha.franken.de
+M:	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/sonic.*
 
 SONICS SILICON BACKPLANE DRIVER (SSB)
-P:	Michael Buesch
-M:	mb@bu3sch.de
+M:	Michael Buesch <mb@bu3sch.de>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/ssb/
 F:	include/linux/ssb/
 
 SONY VAIO CONTROL DEVICE DRIVER
-P:	Mattia Dongili
-M:	malattia@linux.it
+M:	Mattia Dongili <malattia@linux.it>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.linux.it/~malattia/wiki/index.php/Sony_drivers
 S:	Maintained
@@ -5452,17 +4699,14 @@ F:	drivers/platform/x86/sony-laptop.c
 F:	include/linux/sony-laptop.h
 
 SONY MEMORYSTICK CARD SUPPORT
-P:	Alex Dubov
-M:	oakad@yahoo.com
+M:	Alex Dubov <oakad@yahoo.com>
 W:	http://tifmxx.berlios.de/
 S:	Maintained
 F:	drivers/memstick/host/tifm_ms.c
 
 SOUND
-P:	Jaroslav Kysela
-M:	perex@perex.cz
-P:	Takashi Iwai
-M:	tiwai@suse.de
+M:	Jaroslav Kysela <perex@perex.cz>
+M:	Takashi Iwai <tiwai@suse.de>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://www.alsa-project.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
@@ -5473,10 +4717,8 @@ F:	include/sound/
 F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
-P:	Liam Girdwood
-M:	lrg@slimlogic.co.uk
-P:	Mark Brown
-M:	broonie@opensource.wolfsonmicro.com
+M:	Liam Girdwood <lrg@slimlogic.co.uk>
+M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://alsa-project.org/main/index.php/ASoC
@@ -5485,8 +4727,7 @@ F:	sound/soc/
 F:	include/sound/soc*
 
 SPARC + UltraSPARC (sparc/sparc64)
-P:	David S. Miller
-M:	davem@davemloft.net
+M:	"David S. Miller" <davem@davemloft.net>
 L:	sparclinux@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git
@@ -5494,15 +4735,13 @@ S:	Maintained
 F:	arch/sparc/
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
-P:	Roger Wolff
-M:	R.E.Wolff@BitWizard.nl
+M:	Roger Wolff <R.E.Wolff@BitWizard.nl>
 S:	Supported
 F:	Documentation/serial/specialix.txt
 F:	drivers/char/specialix*
 
 SPI SUBSYSTEM
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/spi/
@@ -5510,18 +4749,15 @@ F:	drivers/spi/
 F:	include/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
-P:	Ishizaki Kou
-M:	kou.ishizaki@toshiba.co.jp
-P:	Jens Osterkamp
-M:	jens@de.ibm.com
+M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
+M:	Jens Osterkamp <jens@de.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/spider_net.txt
 F:	drivers/net/spider_net*
 
 SPU FILE SYSTEM
-P:	Jeremy Kerr
-M:	jk@ozlabs.org
+M:	Jeremy Kerr <jk@ozlabs.org>
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
@@ -5530,8 +4766,7 @@ F:	Documentation/filesystems/spufs.txt
 F:	arch/powerpc/platforms/cell/spufs/
 
 SQUASHFS FILE SYSTEM
-P:	Phillip Lougher
-M:	phillip@lougher.demon.co.uk
+M:	Phillip Lougher <phillip@lougher.demon.co.uk>
 L:	squashfs-devel@lists.sourceforge.net (subscribers-only)
 W:	http://squashfs.org.uk
 S:	Maintained
@@ -5539,30 +4774,25 @@ F:	Documentation/filesystems/squashfs.txt
 F:	fs/squashfs/
 
 SRM (Alpha) environment access
-P:	Jan-Benedict Glaw
-M:	jbglaw@lug-owl.de
+M:	Jan-Benedict Glaw <jbglaw@lug-owl.de>
 S:	Maintained
 F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
-P:	Greg Kroah-Hartman
-M:	greg@kroah.com
-P:	Chris Wright
-M:	chrisw@sous-sol.org
+M:	Greg Kroah-Hartman <greg@kroah.com>
+M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 
 STAGING SUBSYSTEM
-P:	Greg Kroah-Hartman
-M:	gregkh@suse.de
+M:	Greg Kroah-Hartman <gregkh@suse.de>
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 
 STARFIRE/DURALAN NETWORK DRIVER
-P:	Ion Badulescu
-M:	ionut@badula.org
+M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
 F:	drivers/net/starfire*
 
@@ -5573,15 +4803,13 @@ F:	drivers/net/wireless/strip.c
 F:	include/linux/if_strip.h
 
 STRADIS MPEG-2 DECODER DRIVER
-P:	Nathan Laredo
-M:	laredo@gnu.org
+M:	Nathan Laredo <laredo@gnu.org>
 W:	http://www.stradis.com/
 S:	Maintained
 F:	drivers/media/video/stradis.c
 
 SUN3/3X
-P:	Sam Creasey
-M:	sammy@sammy.net
+M:	Sam Creasey <sammy@sammy.net>
 W:	http://sammy.net/sun3/
 S:	Maintained
 F:	arch/m68k/kernel/*sun3*
@@ -5589,8 +4817,7 @@ F:	arch/m68k/sun3*/
 F:	arch/m68k/include/asm/sun3*
 
 SUPERH
-P:	Paul Mundt
-M:	lethal@linux-sh.org
+M:	Paul Mundt <lethal@linux-sh.org>
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
@@ -5600,12 +4827,9 @@ F:	arch/sh/
 F:	drivers/sh/
 
 SUSPEND TO RAM
-P:	Len Brown
-M:	len.brown@intel.com
-P:	Pavel Machek
-M:	pavel@ucw.cz
-P:	Rafael J. Wysocki
-M:	rjw@sisk.pl
+M:	Len Brown <len.brown@intel.com>
+M:	Pavel Machek <pavel@ucw.cz>
+M:	"Rafael J. Wysocki" <rjw@sisk.pl>
 L:	linux-pm@lists.linux-foundation.org
 S:	Supported
 F:	Documentation/power/
@@ -5617,32 +4841,28 @@ F:	include/linux/freezer.h
 F:	include/linux/pm.h
 
 SVGA HANDLING
-P:	Martin Mares
-M:	mj@ucw.cz
+M:	Martin Mares <mj@ucw.cz>
 L:	linux-video@atrey.karlin.mff.cuni.cz
 S:	Maintained
 F:	Documentation/svga.txt
 F:	arch/x86/boot/video*
 
 SYSV FILESYSTEM
-P:	Christoph Hellwig
-M:	hch@infradead.org
+M:	Christoph Hellwig <hch@infradead.org>
 S:	Maintained
 F:	Documentation/filesystems/sysv-fs.txt
 F:	fs/sysv/
 F:	include/linux/sysv_fs.h
 
 TASKSTATS STATISTICS INTERFACE
-P:	Balbir Singh
-M:	balbir@linux.vnet.ibm.com
+M:	Balbir Singh <balbir@linux.vnet.ibm.com>
 S:	Maintained
 F:	Documentation/accounting/taskstats*
 F:	include/linux/taskstats*
 F:	kernel/taskstats.c
 
 TC CLASSIFIER
-P:	Jamal Hadi Salim
-M:	hadi@cyberus.ca
+M:	Jamal Hadi Salim <hadi@cyberus.ca>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	include/linux/pkt_cls.h
@@ -5650,38 +4870,31 @@ F:	include/net/pkt_cls.h
 F:	net/sched/
 
 TCP LOW PRIORITY MODULE
-P:	Wong Hoi Sing, Edison
-M:	hswong3i@gmail.com
-P:	Hung Hing Lun, Mike
-M:	hlhung3i@gmail.com
+M:	"Wong Hoi Sing, Edison" <hswong3i@gmail.com>
+M:	"Hung Hing Lun, Mike" <hlhung3i@gmail.com>
 W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
 F:	net/ipv4/tcp_lp.c
 
 TEHUTI ETHERNET DRIVER
-P:	Alexander Indenbaum
-M:	baum@tehutinetworks.net
-P:	Andy Gospodarek
-M:	andy@greyhouse.net
+M:	Alexander Indenbaum <baum@tehutinetworks.net>
+M:	Andy Gospodarek <andy@greyhouse.net>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/tehuti*
 
 Telecom Clock Driver for MCPL0010
-P:	Mark Gross
-M:	mark.gross@intel.com
+M:	Mark Gross <mark.gross@intel.com>
 S:	Supported
 F:	drivers/char/tlclk.c
 
 TENSILICA XTENSA PORT (xtensa)
-P:	Chris Zankel
-M:	chris@zankel.net
+M:	Chris Zankel <chris@zankel.net>
 S:	Maintained
 F:	arch/xtensa/
 
 THINKPAD ACPI EXTRAS DRIVER
-P:	Henrique de Moraes Holschuh
-M:	ibm-acpi@hmh.eng.br
+M:	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
 L:	ibm-acpi-devel@lists.sourceforge.net
 W:	http://ibm-acpi.sourceforge.net
 W:	http://thinkwiki.org/wiki/Ibm-acpi
@@ -5690,27 +4903,22 @@ S:	Maintained
 F:	drivers/platform/x86/thinkpad_acpi.c
 
 TI FLASH MEDIA INTERFACE DRIVER
-P:	Alex Dubov
-M:	oakad@yahoo.com
+M:	Alex Dubov <oakad@yahoo.com>
 S:	Maintained
 F:	drivers/misc/tifm*
 F:	drivers/mmc/host/tifm_sd.c
 F:	include/linux/tifm.h
 
 TI TWL4030 SERIES SOC CODEC DRIVER
-P:	Peter Ujfalusi
-M:	peter.ujfalusi@nokia.com
+M:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Maintained
 F:	sound/soc/codecs/twl4030*
 
 TIPC NETWORK LAYER
-P:	Per Liden
-M:	per.liden@ericsson.com
-P:	Jon Maloy
-M:	jon.maloy@ericsson.com
-P:	Allan Stephens
-M:	allan.stephens@windriver.com
+M:	Per Liden <per.liden@ericsson.com>
+M:	Jon Maloy <jon.maloy@ericsson.com>
+M:	Allan Stephens <allan.stephens@windriver.com>
 L:	tipc-discussion@lists.sourceforge.net
 W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
@@ -5721,8 +4929,7 @@ F:	include/net/tipc/
 F:	net/tipc/
 
 TLAN NETWORK DRIVER
-P:	Samuel Chessman
-M:	chessman@tux.org
+M:	Samuel Chessman <chessman@tux.org>
 L:	tlan-devel@lists.sourceforge.net (subscribers-only)
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
@@ -5730,10 +4937,8 @@ F:	Documentation/networking/tlan.txt
 F:	drivers/net/tlan.*
 
 TOMOYO SECURITY MODULE
-P:	Kentaro Takeda
-M:	takedakn@nttdata.co.jp
-P:	Tetsuo Handa
-M:	penguin-kernel@I-love.SAKURA.ne.jp
+M:	Kentaro Takeda <takedakn@nttdata.co.jp>
+M:	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
 L:	tomoyo-users-en@lists.sourceforge.jp (subscribers-only, for developers and users in English)
 L:	tomoyo-dev@lists.sourceforge.jp (subscribers-only, for developers in Japanese)
 L:	tomoyo-users@lists.sourceforge.jp (subscribers-only, for users in Japanese)
@@ -5747,8 +4952,7 @@ S:	Orphan
 F:	drivers/platform/x86/toshiba_acpi.c
 
 TOSHIBA SMM DRIVER
-P:	Jonathan Buzzard
-M:	jonathan@buzzard.org.uk
+M:	Jonathan Buzzard <jonathan@buzzard.org.uk>
 L:	tlinux-users@tce.toshiba-dme.co.jp
 W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
@@ -5756,41 +4960,34 @@ F:	drivers/char/toshiba.c
 F:	include/linux/toshiba.h
 
 TMIO MMC DRIVER
-P:	Ian Molton
-M:	ian@mnementh.co.uk
+M:	Ian Molton <ian@mnementh.co.uk>
 S:	Maintained
 F:	drivers/mmc/host/tmio_mmc.*
 
 TMPFS (SHMEM FILESYSTEM)
-P:	Hugh Dickins
-M:	hugh.dickins@tiscali.co.uk
+M:	Hugh Dickins <hugh.dickins@tiscali.co.uk>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/shmem_fs.h
 F:	mm/shmem.c
 
 TPM DEVICE DRIVER
-P:	Debora Velarde
-M:	debora@linux.vnet.ibm.com
-P:	Rajiv Andrade
-M:	srajiv@linux.vnet.ibm.com
+M:	Debora Velarde <debora@linux.vnet.ibm.com>
+M:	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
 W:	http://tpmdd.sourceforge.net
-P:	Marcel Selhorst
-M:	m.selhorst@sirrix.com
+M:	Marcel Selhorst <m.selhorst@sirrix.com>
 W:	http://www.sirrix.com
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
 
 TRIVIAL PATCHES
-P:	Jiri Kosina
-M:	trivial@kernel.org
+M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
 
 TTY LAYER
-P:	Alan Cox
-M:	alan@lxorguk.ukuu.org.uk
+M:	Alan Cox <alan@lxorguk.ukuu.org.uk>
 S:	Maintained
 T:	stgit http://zeniv.linux.org.uk/~alan/ttydev/
 F:	drivers/char/tty_*
@@ -5800,17 +4997,14 @@ F:	include/linux/serial.h
 F:	include/linux/tty.h
 
 TULIP NETWORK DRIVERS
-P:	Grant Grundler
-M:	grundler@parisc-linux.org
-P:	Kyle McMartin
-M:	kyle@mcmartin.ca
+M:	Grant Grundler <grundler@parisc-linux.org>
+M:	Kyle McMartin <kyle@mcmartin.ca>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/tulip/
 
 TUN/TAP driver
-P:	Maxim Krasnyansky
-M:	maxk@qualcomm.com
+M:	Maxim Krasnyansky <maxk@qualcomm.com>
 L:	vtun@office.satix.net
 W:	http://vtun.sourceforge.net/tun
 S:	Maintained
@@ -5818,24 +5012,20 @@ F:	Documentation/networking/tuntap.txt
 F:	arch/um/os-Linux/drivers/
 
 TURBOCHANNEL SUBSYSTEM
-P:	Maciej W. Rozycki
-M:	macro@linux-mips.org
+M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/tc/
 F:	include/linux/tc.h
 
 U14-34F SCSI DRIVER
-P:	Dario Ballabio
-M:	ballabio_dario@emc.com
+M:	Dario Ballabio <ballabio_dario@emc.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/u14-34f.c
 
 UBI FILE SYSTEM (UBIFS)
-P:	Artem Bityutskiy
-M:	dedekind@infradead.org
-P:	Adrian Hunter
-M:	adrian.hunter@nokia.com
+M:	Artem Bityutskiy <dedekind@infradead.org>
+M:	Adrian Hunter <adrian.hunter@nokia.com>
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/ubifs-2.6.git
 W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
@@ -5844,37 +5034,32 @@ F:	Documentation/filesystems/ubifs.txt
 F:	fs/ubifs/
 
 UCLINUX (AND M68KNOMMU)
-P:	Greg Ungerer
-M:	gerg@uclinux.org
+M:	Greg Ungerer <gerg@uclinux.org>
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
 F:	arch/m68knommu/
 
 UCLINUX FOR RENESAS H8/300 (H8300)
-P:	Yoshinori Sato
-M:	ysato@users.sourceforge.jp
+M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
 
 UDF FILESYSTEM
-P:	Jan Kara
-M:	jack@suse.cz
+M:	Jan Kara <jack@suse.cz>
 W:	http://linux-udf.sourceforge.net
 S:	Maintained
 F:	Documentation/filesystems/udf.txt
 F:	fs/udf/
 
 UFS FILESYSTEM
-P:	Evgeniy Dushistov
-M:	dushistov@mail.ru
+M:	Evgeniy Dushistov <dushistov@mail.ru>
 S:	Maintained
 F:	Documentation/filesystems/ufs.txt
 F:	fs/ufs/
 
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
-P:	David Vrabel
-M:	david.vrabel@csr.com
+M:	David Vrabel <david.vrabel@csr.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/uwb/*
@@ -5882,8 +5067,7 @@ F:	include/linux/uwb.h
 F:	include/linux/uwb/
 
 UNIFORM CDROM DRIVER
-P:	Jens Axboe
-M:	axboe@kernel.dk
+M:	Jens Axboe <axboe@kernel.dk>
 W:	http://www.kernel.dk
 S:	Maintained
 F:	Documentation/cdrom/
@@ -5891,8 +5075,7 @@ F:	drivers/cdrom/cdrom.c
 F:	include/linux/cdrom.h
 
 UNSORTED BLOCK IMAGES (UBI)
-P:	Artem Bityutskiy
-M:	dedekind@infradead.org
+M:	Artem Bityutskiy <dedekind@infradead.org>
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/ubi-2.6.git
@@ -5902,23 +5085,20 @@ F:	include/linux/mtd/ubi.h
 F:	include/mtd/ubi-user.h
 
 USB ACM DRIVER
-P:	Oliver Neukum
-M:	oliver@neukum.name
+M:	Oliver Neukum <oliver@neukum.name>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	Documentation/usb/acm.txt
 F:	drivers/usb/class/cdc-acm.*
 
 USB BLOCK DRIVER (UB ub)
-P:	Pete Zaitcev
-M:	zaitcev@redhat.com
+M:	Pete Zaitcev <zaitcev@redhat.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/block/ub.c
 
 USB CDC ETHERNET DRIVER
-P:	Greg Kroah-Hartman
-M:	greg@kroah.com
+M:	Greg Kroah-Hartman <greg@kroah.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 W:	http://www.kroah.com/linux-usb/
@@ -5926,39 +5106,34 @@ F:	drivers/net/usb/cdc_*.c
 F:	include/linux/usb/cdc.h
 
 USB CYPRESS C67X00 DRIVER
-P:	Peter Korsgaard
-M:	jacmet@sunsite.dk
+M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/c67x00/
 
 USB DAVICOM DM9601 DRIVER
-P:	Peter Korsgaard
-M:	jacmet@sunsite.dk
+M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
 F:	drivers/net/usb/dm9601.c
 
 USB DIAMOND RIO500 DRIVER
-P:	Cesar Miquel
-M:	miquel@df.uba.ar
+M:	Cesar Miquel <miquel@df.uba.ar>
 L:	rio500-users@lists.sourceforge.net
 W:	http://rio500.sourceforge.net
 S:	Maintained
 F:	drivers/usb/misc/rio500*
 
 USB EHCI DRIVER
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 S:	Odd Fixes
 F:	Documentation/usb/ehci.txt
 F:	drivers/usb/host/ehci*
 
 USB ET61X[12]51 DRIVER
-P:	Luca Risolia
-M:	luca.risolia@studio.unibo.it
+M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -5967,8 +5142,7 @@ S:	Maintained
 F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org/gadget
 S:	Maintained
@@ -5976,8 +5150,7 @@ F:	drivers/usb/gadget/
 F:	include/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
-P:	Jiri Kosina
-M:	jkosina@suse.cz
+M:	Jiri Kosina <jkosina@suse.cz>
 L:	linux-usb@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
@@ -5985,23 +5158,20 @@ F:	Documentation/usb/hiddev.txt
 F:	drivers/hid/usbhid/
 
 USB ISP116X DRIVER
-P:	Olav Kongas
-M:	ok@artecdesign.ee
+M:	Olav Kongas <ok@artecdesign.ee>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/host/isp116x*
 F:	include/linux/usb/isp116x.h
 
 USB KAWASAKI LSI DRIVER
-P:	Oliver Neukum
-M:	oliver@neukum.name
+M:	Oliver Neukum <oliver@neukum.name>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/kl5kusb105.*
 
 USB MASS STORAGE DRIVER
-P:	Matthew Dharm
-M:	mdharm-usb@one-eyed-alien.net
+M:	Matthew Dharm <mdharm-usb@one-eyed-alien.net>
 L:	linux-usb@vger.kernel.org
 L:	usb-storage@lists.one-eyed-alien.net
 S:	Maintained
@@ -6009,31 +5179,27 @@ W:	http://www.one-eyed-alien.net/~mdharm/linux-usb/
 F:	drivers/usb/storage/
 
 USB OHCI DRIVER
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 S:	Odd Fixes
 F:	Documentation/usb/ohci.txt
 F:	drivers/usb/host/ohci*
 
 USB OPTION-CARD DRIVER
-P:	Matthias Urlichs
-M:	smurf@smurf.noris.de
+M:	Matthias Urlichs <smurf@smurf.noris.de>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/option.c
 
 USB OV511 DRIVER
-P:	Mark McClelland
-M:	mmcclell@bigfoot.com
+M:	Mark McClelland <mmcclell@bigfoot.com>
 L:	linux-usb@vger.kernel.org
 W:	http://alpha.dyndns.org/ov511/
 S:	Maintained
 F:	drivers/media/video/ov511.*
 
 USB PEGASUS DRIVER
-P:	Petko Manolov
-M:	petkan@users.sourceforge.net
+M:	Petko Manolov <petkan@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
@@ -6041,15 +5207,13 @@ S:	Maintained
 F:	drivers/net/usb/pegasus.*
 
 USB PRINTER DRIVER (usblp)
-P:	Pete Zaitcev
-M:	zaitcev@redhat.com
+M:	Pete Zaitcev <zaitcev@redhat.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	drivers/usb/class/usblp.c
 
 USB RTL8150 DRIVER
-P:	Petko Manolov
-M:	petkan@users.sourceforge.net
+M:	Petko Manolov <petkan@users.sourceforge.net>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
@@ -6057,8 +5221,7 @@ S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
 USB SE401 DRIVER
-P:	Jeroen Vreeken
-M:	pe1rxq@amsat.org
+M:	Jeroen Vreeken <pe1rxq@amsat.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.chello.nl/~j.vreeken/se401/
 S:	Maintained
@@ -6066,15 +5229,13 @@ F:	Documentation/video4linux/se401.txt
 F:	drivers/media/video/se401.*
 
 USB SERIAL BELKIN F5U103 DRIVER
-P:	William Greathouse
-M:	wgreathouse@smva.com
+M:	William Greathouse <wgreathouse@smva.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/belkin_sa.*
 
 USB SERIAL CYPRESS M8 DRIVER
-P:	Lonnie Mendez
-M:	dignome@gmail.com
+M:	Lonnie Mendez <dignome@gmail.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 W:	http://geocities.com/i0xox0i
@@ -6082,24 +5243,20 @@ W:	http://firstlight.net/cvs
 F:	drivers/usb/serial/cypress_m8.*
 
 USB SERIAL CYBERJACK DRIVER
-P:	Matthias Bruestle and Harald Welte
-M:	support@reiner-sct.com
+M:	Matthias Bruestle and Harald Welte <support@reiner-sct.com>
 W:	http://www.reiner-sct.de/support/treiber_cyberjack.php
 S:	Maintained
 F:	drivers/usb/serial/cyberjack.c
 
 USB SERIAL DIGI ACCELEPORT DRIVER
-P:	Peter Berger
-M:	pberger@brimson.com
-P:	Al Borchers
-M:	alborchers@steinerpoint.com
+M:	Peter Berger <pberger@brimson.com>
+M:	Al Borchers <alborchers@steinerpoint.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/digi_acceleport.c
 
 USB SERIAL DRIVER
-P:	Greg Kroah-Hartman
-M:	gregkh@suse.de
+M:	Greg Kroah-Hartman <gregkh@suse.de>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 F:	Documentation/usb/usb-serial.txt
@@ -6108,38 +5265,33 @@ F:	drivers/usb/serial/usb-serial.c
 F:	include/linux/usb/serial.h
 
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
-P:	Gary Brubaker
-M:	xavyer@ix.netcom.com
+M:	Gary Brubaker <xavyer@ix.netcom.com>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/serial/empeg.c
 
 USB SERIAL KEYSPAN DRIVER
-P:	Greg Kroah-Hartman
-M:	greg@kroah.com
+M:	Greg Kroah-Hartman <greg@kroah.com>
 L:	linux-usb@vger.kernel.org
 W:	http://www.kroah.com/linux/
 S:	Maintained
 F:	drivers/usb/serial/*keyspan*
 
 USB SERIAL WHITEHEAT DRIVER
-P:	Support Department
-M:	support@connecttech.com
+M:	Support Department <support@connecttech.com>
 L:	linux-usb@vger.kernel.org
 W:	http://www.connecttech.com
 S:	Supported
 F:	drivers/usb/serial/whiteheat*
 
 USB SMSC95XX ETHERNET DRIVER
-P:	Steve Glendinning
-M:	steve.glendinning@smsc.com
+M:	Steve Glendinning <steve.glendinning@smsc.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/usb/smsc95xx.*
 
 USB SN9C1xx DRIVER
-P:	Luca Risolia
-M:	luca.risolia@studio.unibo.it
+M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -6149,8 +5301,7 @@ F:	Documentation/video4linux/sn9c102.txt
 F:	drivers/media/video/sn9c102/
 
 USB SUBSYSTEM
-P:	Greg Kroah-Hartman
-M:	gregkh@suse.de
+M:	Greg Kroah-Hartman <gregkh@suse.de>
 L:	linux-usb@vger.kernel.org
 W:	http://www.linux-usb.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
@@ -6162,15 +5313,13 @@ F:	include/linux/usb.h
 F:	include/linux/usb/
 
 USB UHCI DRIVER
-P:	Alan Stern
-M:	stern@rowland.harvard.edu
+M:	Alan Stern <stern@rowland.harvard.edu>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/host/uhci*
 
 USB "USBNET" DRIVER FRAMEWORK
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
+M:	David Brownell <dbrownell@users.sourceforge.net>
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
@@ -6178,8 +5327,7 @@ F:	drivers/net/usb/usbnet.c
 F:	include/linux/usb/usbnet.h
 
 USB VIDEO CLASS
-P:	Laurent Pinchart
-M:	laurent.pinchart@skynet.be
+M:	Laurent Pinchart <laurent.pinchart@skynet.be>
 L:	linux-uvc-devel@lists.berlios.de (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -6188,8 +5336,7 @@ S:	Maintained
 F:	drivers/media/video/uvc/
 
 USB W996[87]CF DRIVER
-P:	Luca Risolia
-M:	luca.risolia@studio.unibo.it
+M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -6199,21 +5346,18 @@ F:	Documentation/video4linux/w9968cf.txt
 F:	drivers/media/video/w996*
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
-P:	Jussi Kivilinna
-M:	jussi.kivilinna@mbnet.fi
+M:	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/rndis_wlan.c
 
 USB XHCI DRIVER
-P:	Sarah Sharp
-M:	sarah.a.sharp@intel.com
+M:	Sarah Sharp <sarah.a.sharp@intel.com>
 L:	linux-usb@vger.kernel.org
 S:	Supported
 
 USB ZC0301 DRIVER
-P:	Luca Risolia
-M:	luca.risolia@studio.unibo.it
+M:	Luca Risolia <luca.risolia@studio.unibo.it>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -6223,16 +5367,14 @@ F:	Documentation/video4linux/zc0301.txt
 F:	drivers/media/video/zc0301/
 
 USB ZD1201 DRIVER
-P:	Jeroen Vreeken
-M:	pe1rxq@amsat.org
+M:	Jeroen Vreeken <pe1rxq@amsat.org>
 L:	linux-usb@vger.kernel.org
 W:	http://linux-lc100020.sourceforge.net
 S:	Maintained
 F:	drivers/net/wireless/zd1201.*
 
 USB ZR364XX DRIVER
-P:	Antoine Jacquet
-M:	royale@zerezo.com
+M:	Antoine Jacquet <royale@zerezo.com>
 L:	linux-usb@vger.kernel.org
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
@@ -6242,8 +5384,7 @@ F:	Documentation/video4linux/zr364xx.txt
 F:	drivers/media/video/zr364xx.c
 
 USER-MODE LINUX (UML)
-P:	Jeff Dike
-M:	jdike@addtoit.com
+M:	Jeff Dike <jdike@addtoit.com>
 L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
@@ -6254,26 +5395,22 @@ F:	fs/hostfs/
 F:	fs/hppfs/
 
 USERSPACE I/O (UIO)
-P:	Hans J. Koch
-M:	hjk@linutronix.de
-P:	Greg Kroah-Hartman
-M:	gregkh@suse.de
+M:	"Hans J. Koch" <hjk@linutronix.de>
+M:	Greg Kroah-Hartman <gregkh@suse.de>
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
 
 UTIL-LINUX-NG PACKAGE
-P:	Karel Zak
-M:	kzak@redhat.com
+M:	Karel Zak <kzak@redhat.com>
 L:	util-linux-ng@vger.kernel.org
 W:	http://kernel.org/~kzak/util-linux-ng/
 T:	git git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git
 S:	Maintained
 
 UVESAFB DRIVER
-P:	Michal Januszewski
-M:	spock@gentoo.org
+M:	Michal Januszewski <spock@gentoo.org>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://dev.gentoo.org/~spock/projects/uvesafb/
 S:	Maintained
@@ -6281,53 +5418,44 @@ F:	Documentation/fb/uvesafb.txt
 F:	drivers/video/uvesafb.*
 
 VFAT/FAT/MSDOS FILESYSTEM
-P:	OGAWA Hirofumi
-M:	hirofumi@mail.parknet.co.jp
+M:	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
 S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 
 VIA RHINE NETWORK DRIVER
-P:	Roger Luethi
-M:	rl@hellgate.ch
+M:	Roger Luethi <rl@hellgate.ch>
 S:	Maintained
 F:	drivers/net/via-rhine.c
 
 VIAPRO SMBUS DRIVER
-P:	Jean Delvare
-M:	khali@linux-fr.org
+M:	Jean Delvare <khali@linux-fr.org>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	Documentation/i2c/busses/i2c-viapro
 F:	drivers/i2c/busses/i2c-viapro.c
 
 VIA SD/MMC CARD CONTROLLER DRIVER
-P:	Joseph Chan
-M:	JosephChan@via.com.tw
-P:	Harald Welte
-M:	HaraldWelte@viatech.com
+M:	Joseph Chan <JosephChan@via.com.tw>
+M:	Harald Welte <HaraldWelte@viatech.com>
 S:	Maintained
 F:	drivers/mmc/host/via-sdmmc.c
 
 VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
-P:	Joseph Chan
-M:	JosephChan@via.com.tw
-P:	Scott Fang
-M:	ScottFang@viatech.com.cn
+M:	Joseph Chan <JosephChan@via.com.tw>
+M:	Scott Fang <ScottFang@viatech.com.cn>
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/video/via/
 
 VIA VELOCITY NETWORK DRIVER
-P:	Francois Romieu
-M:	romieu@fr.zoreil.com
+M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/via-velocity.*
 
 VLAN (802.1Q)
-P:	Patrick McHardy
-M:	kaber@trash.net
+M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/macvlan.c
@@ -6335,18 +5463,15 @@ F:	include/linux/if_*vlan.h
 F:	net/8021q/
 
 VLYNQ BUS
-P:	Florian Fainelli
-M:	florian@openwrt.org
+M:	Florian Fainelli <florian@openwrt.org>
 L:	openwrt-devel@lists.openwrt.org
 S:	Maintained
 F:	drivers/vlynq/vlynq.c
 F:	include/linux/vlynq.h
 
 VOLTAGE AND CURRENT REGULATOR FRAMEWORK
-P:	Liam Girdwood
-M:	lrg@slimlogic.co.uk
-P:	Mark Brown
-M:	broonie@opensource.wolfsonmicro.com
+M:	Liam Girdwood <lrg@slimlogic.co.uk>
+M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
@@ -6355,52 +5480,45 @@ F:	drivers/regulator/
 F:	include/linux/regulator/
 
 VT1211 HARDWARE MONITOR DRIVER
-P:	Juerg Haefliger
-M:	juergh@gmail.com
+M:	Juerg Haefliger <juergh@gmail.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/vt1211
 F:	drivers/hwmon/vt1211.c
 
 VT8231 HARDWARE MONITOR DRIVER
-P:	Roger Lucas
-M:	vt8231@hiddenengine.co.uk
+M:	Roger Lucas <vt8231@hiddenengine.co.uk>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/vt8231.c
 
 W1 DALLAS'S 1-WIRE BUS
-P:	Evgeniy Polyakov
-M:	johnpol@2ka.mipt.ru
+M:	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 S:	Maintained
 F:	Documentation/w1/
 F:	drivers/w1/
 
 W83791D HARDWARE MONITORING DRIVER
-P:	Marc Hulsman
-M:	m.hulsman@tudelft.nl
+M:	Marc Hulsman <m.hulsman@tudelft.nl>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/w83791d
 F:	drivers/hwmon/w83791d.c
 
 W83793 HARDWARE MONITORING DRIVER
-P:	Rudolf Marek
-M:	r.marek@assembler.cz
+M:	Rudolf Marek <r.marek@assembler.cz>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/w83793
 F:	drivers/hwmon/w83793.c
 
 W83L51xD SD/MMC CARD INTERFACE DRIVER
-P:	Pierre Ossman
-M:	pierre@ossman.eu
+M:	Pierre Ossman <pierre@ossman.eu>
 S:	Maintained
 F:	drivers/mmc/host/wbsd.*
 
 WATCHDOG DEVICE DRIVERS
-P:	Wim Van Sebroeck
-M:	wim@iguana.be
+M:	Wim Van Sebroeck <wim@iguana.be>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
 F:	Documentation/watchdog/
@@ -6408,8 +5526,7 @@ F:	drivers/watchdog/
 F:	include/linux/watchdog.h
 
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
-P:	Jean Tourrilhes
-M:	jt@hpl.hp.com
+M:	Jean Tourrilhes <jt@hpl.hp.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
@@ -6417,46 +5534,39 @@ F:	Documentation/networking/wavelan.txt
 F:	drivers/net/wireless/wavelan*
 
 WD7000 SCSI DRIVER
-P:	Miroslav Zagorac
-M:	zaga@fly.cc.fer.hr
+M:	Miroslav Zagorac <zaga@fly.cc.fer.hr>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/scsi/wd7000.c
 
 WIMAX STACK
-P:	Inaky Perez-Gonzalez
-M:	inaky.perez-gonzalez@intel.com
+M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
 M:	linux-wimax@intel.com
 L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
 
 WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
-P:	David Vrabel
-M:	david.vrabel@csr.com
+M:	David Vrabel <david.vrabel@csr.com>
 S:	Maintained
 F:	include/linux/wlp.h
 F:	drivers/uwb/wlp/
 
 WISTRON LAPTOP BUTTON DRIVER
-P:	Miloslav Trmac
-M:	mitr@volny.cz
+M:	Miloslav Trmac <mitr@volny.cz>
 S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://oops.ghostprotocols.net:81/blog
 S:	Maintained
 F:	drivers/net/wireless/wl3501*
 
 WM97XX TOUCHSCREEN DRIVERS
-P:	Mark Brown
-M:	broonie@opensource.wolfsonmicro.com
-P:	Liam Girdwood
-M:	lrg@slimlogic.co.uk
+M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
+M:	Liam Girdwood <lrg@slimlogic.co.uk>
 L:	linux-input@vger.kernel.org
 T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
 W:	http://opensource.wolfsonmicro.com/node/7
@@ -6465,8 +5575,7 @@ F:	drivers/input/touchscreen/*wm97*
 F:	include/linux/wm97xx.h
 
 X.25 NETWORK LAYER
-P:	Henner Eisen
-M:	eis@baty.hanse.de
+M:	Henner Eisen <eis@baty.hanse.de>
 L:	linux-x25@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/x25*
@@ -6474,12 +5583,9 @@ F:	include/net/x25*
 F:	net/x25/
 
 X86 ARCHITECTURE (32-BIT AND 64-BIT)
-P:	Thomas Gleixner
-M:	tglx@linutronix.de
-P:	Ingo Molnar
-M:	mingo@redhat.com
-P:	H. Peter Anvin
-M:	hpa@zytor.com
+M:	Thomas Gleixner <tglx@linutronix.de>
+M:	Ingo Molnar <mingo@redhat.com>
+M:	"H. Peter Anvin" <hpa@zytor.com>
 M:	x86@kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
 S:	Maintained
@@ -6487,10 +5593,8 @@ F:	Documentation/x86/
 F:	arch/x86/
 
 XEN HYPERVISOR INTERFACE
-P:	Jeremy Fitzhardinge
-M:	jeremy@xensource.com
-P:	Chris Wright
-M:	chrisw@sous-sol.org
+M:	Jeremy Fitzhardinge <jeremy@xensource.com>
+M:	Chris Wright <chrisw@sous-sol.org>
 L:	virtualization@lists.osdl.org
 L:	xen-devel@lists.xensource.com
 S:	Supported
@@ -6502,8 +5606,7 @@ F:	include/xen/
 
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
-P:	Felix Blyakher
-M:	felixb@sgi.com
+M:	Felix Blyakher <felixb@sgi.com>
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
@@ -6513,38 +5616,33 @@ F:	Documentation/filesystems/xfs.txt
 F:	fs/xfs/
 
 XILINX SYSTEMACE DRIVER
-P:	Grant Likely
-M:	grant.likely@secretlab.ca
+M:	Grant Likely <grant.likely@secretlab.ca>
 W:	http://www.secretlab.ca/
 S:	Maintained
 F:	drivers/block/xsysace.c
 
 XILINX UARTLITE SERIAL DRIVER
-P:	Peter Korsgaard
-M:	jacmet@sunsite.dk
+M:	Peter Korsgaard <jacmet@sunsite.dk>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
 F:	drivers/serial/uartlite.c
 
 YAM DRIVER FOR AX.25
-P:	Jean-Paul Roubelat
-M:	jpr@f6fbb.org
+M:	Jean-Paul Roubelat <jpr@f6fbb.org>
 L:	linux-hams@vger.kernel.org
 S:	Maintained
 F:	drivers/net/hamradio/yam*
 F:	include/linux/yam.h
 
 YEALINK PHONE DRIVER
-P:	Henk Vergonet
-M:	Henk.Vergonet@gmail.com
+M:	Henk Vergonet <Henk.Vergonet@gmail.com>
 L:	usbb2k-api-dev@nongnu.org
 S:	Maintained
 F:	Documentation/input/yealink.txt
 F:	drivers/input/misc/yealink.*
 
 Z8530 DRIVER FOR AX.25
-P:	Joerg Reuter
-M:	jreuter@yaina.de
+M:	Joerg Reuter <jreuter@yaina.de>
 W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
@@ -6554,10 +5652,8 @@ F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
 ZD1211RW WIRELESS DRIVER
-P:	Daniel Drake
-M:	dsd@gentoo.org
-P:	Ulrich Kunitz
-M:	kune@deine-taler.de
+M:	Daniel Drake <dsd@gentoo.org>
+M:	Ulrich Kunitz <kune@deine-taler.de>
 W:	http://zd1211.ath.cx/wiki/DriverRewrite
 L:	linux-wireless@vger.kernel.org
 L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
@@ -6573,14 +5669,12 @@ S:	Odd Fixes
 F:	drivers/media/video/zoran/
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
-P:	Maciej W. Rozycki
-M:	macro@linux-mips.org
+M:	"Maciej W. Rozycki" <macro@linux-mips.org>
 S:	Maintained
 F:	drivers/serial/zs.*
 
 THE REST
-P:	Linus Torvalds
-M:	torvalds@linux-foundation.org
+M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters


