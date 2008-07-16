Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYGPHUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYGPHUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbYGPHTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:19:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27550 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbYGPHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=RmhUzmVkpxm+9gERrrrr2jRnReWsfIPmP/WXlc+xYUNNforAZqwmZI9KnuGvOMGrsZ
         bYpl2Ro/BR5UB5emVFX8ehFqpnvEaUzwrtqsjx0Cd61G7/8xrMbKsc9rX6VkyFXmAlwa
         tMrHQHDO5nJD5bIm+0fpocza4xN5etn+S2mY8=
From: jkacur <jkacur@gmail.com>
Reply-To: jkacur@gmail.com
To: akpm@linux-foundation.org
Subject: Make the git URL match usage
Date: Wed, 16 Jul 2008 09:19:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807160919.35833.jkacur@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Make the git URL match the usage
Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
would use it. They should only have to copy and paste it and not guess how
to modify it. Secondly, drop the "git" type when the protocol is already git://
This should save someone else the fumbling around that I went through!

Signed-off-by:John Kacur <jkacur at gmail dot com>

Index: linux-2.6.26/MAINTAINERS
===================================================================
--- linux-2.6.26.orig/MAINTAINERS
+++ linux-2.6.26/MAINTAINERS
@@ -154,7 +154,7 @@ P:	Latchesar Ionkov
 M:	lucho@ionkov.net
 L:	v9fs-developer@lists.sourceforge.net
 W:	http://swik.net/v9fs
-T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
 S:	Maintained
 
 A2232 SERIAL BOARD DRIVER
@@ -221,7 +221,7 @@ M:	len.brown@intel.com
 M:	lenb@kernel.org
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
-T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 S:	Supported
 
 ACPI BATTERY DRIVERS
@@ -298,7 +298,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
 ADT746X FAN DRIVER
@@ -325,7 +325,7 @@ S:	Maintained
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 
 AHA152X SCSI DRIVER
@@ -758,7 +758,7 @@ P:	Eric Paris
 M:	eparis@redhat.com
 L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
-T:	git git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
 S:	Maintained
 
 AUXILIARY DISPLAY DRIVERS
@@ -877,7 +877,7 @@ BLOCK LAYER
 P:	Jens Axboe
 M:	axboe@kernel.dk
 L:	linux-kernel@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 S:	Maintained
 
 BLOCK2MTD DRIVER
@@ -895,7 +895,7 @@ L:	linux-bluetooth@vger.kernel.org
 W:	http://bluez.sf.net
 W:	http://www.bluez.org
 W:	http://www.holtmann.org/linux/bluetooth/
-T:	git kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/holtmann/bluetooth-2.6.git
 S:	Maintained
 
 BLUETOOTH RFCOMM LAYER
@@ -1019,7 +1019,7 @@ M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
@@ -1091,7 +1091,7 @@ M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 
 CONFIGFS
@@ -1190,7 +1190,7 @@ P:	Dave Jones
 M:	davej@codemonkey.org.uk
 L:	cpufreq@lists.linux.org.uk
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
-T:	git kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
 
 CPUID/MSR DRIVER
@@ -1227,7 +1227,7 @@ M:	herbert@gondor.apana.org.au
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	linux-crypto@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 
 CS5535 Audio ALSA driver
@@ -1389,7 +1389,7 @@ P:	David Teigland
 M:	teigland@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
@@ -1448,7 +1448,7 @@ DRM DRIVERS
 P:	David Airlie
 M:	airlied@linux.ie
 L:	dri-devel@lists.sourceforge.net
-T:	git kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 
 DSCC4 DRIVER
@@ -1462,7 +1462,7 @@ P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
 L: 	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 
 DZ DECSTATION DZ11 SERIAL DRIVER
@@ -1739,7 +1739,7 @@ P:	Kristian Hoegsberg, Stefan Richter
 M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 
 FIRMWARE LOADER (request_firmware)
@@ -1805,8 +1805,8 @@ P:	Steven Whitehouse
 M:	swhiteho@redhat.com
 L:	cluster-devel@redhat.com
 W:	http://sources.redhat.com/cluster/
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
 
 GIGASET ISDN DRIVERS
@@ -1823,8 +1823,8 @@ P:	Mark M. Hoffman
 M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
-T:	git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git testing
-T:	git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git release
+T:	git://git.lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git testing
+T:	git://git.lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git release
 S:	Maintained
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
@@ -1867,7 +1867,7 @@ HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
@@ -1993,7 +1993,7 @@ S:	Maintained
 i386 SETUP CODE / CPU ERRATA WORKAROUNDS
 P:	H. Peter Anvin
 M:	hpa@zytor.com
-T:	git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git
 S:	Maintained
 
 IA64 (Itanium) PLATFORM
@@ -2001,7 +2001,7 @@ P:	Tony Luck
 M:	tony.luck@intel.com
 L:	linux-ia64@vger.kernel.org
 W:	http://www.ia64-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
+T:	git://git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
 
 SN-IA64 (Itanium) SUB-PLATFORM
@@ -2068,7 +2068,7 @@ P:	Stefan Richter
 M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 
 IEEE 1394 RAW I/O DRIVER (raw1394)
@@ -2092,7 +2092,7 @@ P:	Hal Rosenstock
 M:	hal.rosenstock@gmail.com 
 L:	general@lists.openfabrics.org
 W:	http://www.openib.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
@@ -2100,7 +2100,7 @@ P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
 M:	dtor@mail.ru
 L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 
 INOTIFY
@@ -2198,7 +2198,7 @@ M:	reinette.chatre@intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw3945-devel@lists.sourceforge.net
 W:	http://intellinuxwireless.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
 S:	Supported
 
 IOC3 ETHERNET DRIVER
@@ -2232,7 +2232,7 @@ IPATH DRIVER:
 P:	Ralph Campbell
 M:	infinipath@qlogic.com
 L:	general@lists.openfabrics.org
-T:	git git://git.qlogic.com/ipath-linux-2.6
+T:	git://git.qlogic.com/ipath-linux-2.6
 S:	Supported
 
 IPMI SUBSYSTEM
@@ -2268,7 +2268,7 @@ P:	Mike Christie
 M:	michaelc@cs.wisc.edu
 L:	open-iscsi@googlegroups.com
 W:	www.open-iscsi.org
-T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
 S:	Maintained
 
 ISAPNP
@@ -2281,7 +2281,7 @@ P:	Karsten Keil
 M:	kkeil@suse.de
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 W:	http://www.isdn4linux.de
-T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
 S:	Maintained
 
 ISDN SUBSYSTEM (Eicon active card driver)
@@ -2312,7 +2312,7 @@ P:	Dave Kleikamp
 M:	shaggy@austin.ibm.com
 L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
-T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
@@ -2358,8 +2358,8 @@ S:	Maintained
 KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
 P:	Sam Ravnborg
 M:	sam@ravnborg.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
 L:	linux-kbuild@vger.kernel.org
 S:	Maintained
 
@@ -2493,7 +2493,7 @@ P:	Benjamin Herrenschmidt
 M:	benh@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
 S:	Supported
 
 LINUX FOR POWER MACINTOSH
@@ -2520,7 +2520,7 @@ P:	Matt Porter
 M:	mporter@kernel.crashing.org
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jwboyer/powerpc.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jwboyer/powerpc.git
 S:	Maintained
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
@@ -2562,7 +2562,7 @@ LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
 L:	linux-security-module@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LM83 HARDWARE MONITOR DRIVER
@@ -2646,7 +2646,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
 MAC80211 PID RATE CONTROL
@@ -2656,7 +2656,7 @@ P:	Mattias Nissler
 M:	mattias.nissler@gmx.de
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
 MACVLAN DRIVER
@@ -2743,7 +2743,7 @@ P:	David Woodhouse
 M:	dwmw2@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/mtd-2.6.git
+T:	git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 
 UNSORTED BLOCK IMAGES (UBI)
@@ -2751,7 +2751,7 @@ P:	Artem Bityutskiy
 M:	dedekind@infradead.org
 W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
+T:	git://git.infradead.org/~dedekind/ubi-2.6.git
 S:	Maintained
 
 MICROTEK X6 SCANNER
@@ -2764,7 +2764,7 @@ P:	Ralf Baechle
 M:	ralf@linux-mips.org
 W:	http://www.linux-mips.org/
 L:	linux-mips@linux-mips.org
-T:	git www.linux-mips.org:/pub/scm/linux.git
+T:	git://www.linux-mips.org:/pub/scm/linux.git
 S:	Supported
 
 MISCELLANEOUS MCA-SUPPORT
@@ -2934,7 +2934,7 @@ NETWORK DEVICE DRIVERS
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 S:	Maintained
 
 NETWORKING [GENERAL]
@@ -2958,7 +2958,7 @@ M:	yoshfuji@linux-ipv6.org
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netdev@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 
 NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
@@ -2971,7 +2971,7 @@ NETWORKING [WIRELESS]
 P:	John W. Linville
 M:	linville@tuxdriver.com
 L:	linux-wireless@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/linville/wireless-2.6.git
 S:	Maintained
 
 NETXEN (1/10) GbE SUPPORT
@@ -2996,7 +2996,7 @@ P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
 L:	linux-nfs@vger.kernel.org
 W:	http://client.linux-nfs.org
-T:	git git://git.linux-nfs.org/pub/linux/nfs-2.6.git
+T:	git://git.linux-nfs.org/pub/linux/nfs-2.6.git
 S:	Maintained
 
 NI5010 NETWORK DRIVER
@@ -3027,7 +3027,7 @@ M:	aia21@cantab.net
 L:	linux-ntfs-dev@lists.sourceforge.net
 L:	linux-kernel@vger.kernel.org
 W:	http://linux-ntfs.sf.net/
-T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
@@ -3049,7 +3049,7 @@ P:	Joel Becker
 M:	joel.becker@oracle.com
 L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
 W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
 S:	Supported
 
 OMNIKEY CARDMAN 4000 DRIVER
@@ -3130,7 +3130,7 @@ P:	Grant Grundler
 M:	grundler@parisc-linux.org
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
 S:	Maintained
 
 PARAVIRT_OPS INTERFACE
@@ -3169,7 +3169,7 @@ P:	Jesse Barnes
 M:	jbarnes@virtuousgeek.org
 L:	linux-kernel@vger.kernel.org
 L:	linux-pci@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
 S:	Supported
 
 PCI HOTPLUG CORE
@@ -3187,7 +3187,7 @@ PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
 L:	linux-pcmcia@lists.infradead.org
 W:	http://lists.infradead.org/mailman/listinfo/linux-pcmcia
-T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 
 PCNET32 NETWORK DRIVER
@@ -3232,7 +3232,7 @@ M:	cbou@mail.ru
 P:	David Woodhouse
 M:	dwmw2@infradead.org
 L:	linux-kernel@vger.kernel.org
-T:	git git.infradead.org/battery-2.6.git
+T:	git://git.infradead.org/battery-2.6.git
 S:	Maintained
 
 POWERPC 4xx EMAC DRIVER
@@ -3288,7 +3288,7 @@ P:	Michael Wu
 M:	flamingice@sourmilk.net
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
 PRISM54 WIRELESS DRIVER
@@ -3386,7 +3386,7 @@ L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
-T:	git kernel.org:/pub/scm/linux/kernel/git/ivd/rt2x00.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/ivd/rt2x00.git
 F:	drivers/net/wireless/rt2x00/
 
 RAMDISK RAM BLOCK DEVICE DRIVER
@@ -3475,7 +3475,7 @@ P:	Andrea Merello
 M:	andreamrl@tiscali.it
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
 S:	Maintained
 
 S3 SAVAGE FRAMEBUFFER DRIVER
@@ -3559,9 +3559,9 @@ SCSI SUBSYSTEM
 P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
-T:	git kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
 S:	Maintained
 
 SCSI TAPE DRIVER
@@ -3620,7 +3620,7 @@ SERIAL ATA (SATA) SUBSYSTEM:
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
 L:	linux-ide@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 
 SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
@@ -3777,7 +3777,7 @@ P:	Liam Girdwood
 M:	liam.girdwood@wolfsonmicro.com
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
-T:	git opensource.wolfsonmicro.com/linux-2.6-asoc
+T:	git://opensource.wolfsonmicro.com/linux-2.6-asoc
 L:	alsa-devel@alsa-project.org (subscribers-only)
 S:	Supported
 
@@ -3879,7 +3879,7 @@ P:	Paul Mundt
 M:	lethal@linux-sh.org
 L:	linux-sh@vger.kernel.org
 W:	http://www.linux-sh.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Maintained
 
 SUN3/3X
@@ -3943,7 +3943,7 @@ M:	ibm-acpi@hmh.eng.br
 L:	ibm-acpi-devel@lists.sourceforge.net
 W:	http://ibm-acpi.sourceforge.net
 W:	http://thinkwiki.org/wiki/Ibm-acpi
-T:	git repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
+T:	git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git
 S:	Maintained
 
 TI FLASH MEDIA INTERFACE DRIVER
@@ -3973,7 +3973,7 @@ M:	allan.stephens@windriver.com
 L:	tipc-discussion@lists.sourceforge.net
 W:	http://tipc.sourceforge.net/
 W:	http://tipc.cslab.ericsson.net/
-T:	git tipc.cslab.ericsson.net:/pub/git/tipc.git
+T:	git://tipc.cslab.ericsson.net:/pub/git/tipc.git
 S:	Maintained
 
 TLAN NETWORK DRIVER
@@ -4083,7 +4083,7 @@ UltraSPARC (sparc64):
 P:	David S. Miller
 M:	davem@davemloft.net
 L:	sparclinux@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git
 S:	Maintained
 
 UNIFORM CDROM DRIVER
@@ -4164,7 +4164,7 @@ USB HID/HIDBP DRIVERS (USB KEYBOARDS, MI
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 L:      linux-usb@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 
 USB ISP116X DRIVER
@@ -4415,7 +4415,7 @@ M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
 
 VLAN (802.1Q)
@@ -4462,7 +4462,7 @@ S:	Maintained
 WATCHDOG DEVICE DRIVERS
 P:	Wim Van Sebroeck
 M:	wim@iguana.be
-T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
+T:	git://git.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
 
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
@@ -4496,7 +4496,7 @@ M:	broonie@opensource.wolfsonmicro.com
 P:	Liam Girdwood
 M:	liam.girdwood@wolfsonmicro.com
 L:	linux-input@vger.kernel.org
-T:	git git://opensource.wolfsonmicro.com/linux-2.6-touch
+T:	git://opensource.wolfsonmicro.com/linux-2.6-touch
 W:	http://opensource.wolfsonmicro.com/node/7
 S:	Supported
 
@@ -4521,7 +4521,7 @@ P:	Tim Shimmin
 M:	xfs-masters@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
-T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
+T:	git://oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
 
 XILINX SYSTEMACE DRIVER
