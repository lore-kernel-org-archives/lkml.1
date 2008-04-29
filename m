Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbYD2VAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbYD2VAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYD2VAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:00:43 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:17059 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYD2VAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:00:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Date: Tue, 29 Apr 2008 15:00:39 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200804291459.56300.bjorn.helgaas@hp.com>
In-Reply-To: <200804291459.56300.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291500.39879.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAINTAINERS: straighten out Person <-> Mail associations

Sometimes a "P:" line contains several names, followed by an
"M:" line with several email addresses.  And sometimes a single
"P:" line is followed by several "M:" addresses for the same
person.

This patch adds extra "P:" lines to make the associations
unambiguous.

The first hunk is only relevant if we use the preceeding
script to fold the "P:" and "M:" lines together, but the rest
of the patch should be valid in any case.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/MAINTAINERS
===================================================================
--- work10.orig/MAINTAINERS	2008-04-29 13:31:06.000000000 -0600
+++ work10/MAINTAINERS	2008-04-29 14:45:16.000000000 -0600
@@ -67,8 +67,8 @@
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
-P: Person
-M: Mail patches to
+P: Person with email address, e.g., "Andrew Morton <akpm@linux-foundation.org>"
+M: Additional email address for patches
 L: Mailing list that is relevant to this area
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt.
@@ -218,6 +218,7 @@
 ACPI
 P:	Len Brown
 M:	len.brown@intel.com
+P:	Len Brown
 M:	lenb@kernel.org
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
@@ -1112,11 +1113,14 @@
 L:	alsa-devel@alsa-project.org
 S:	Supported
 
+CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER (2.2 kernel driver)
+P:	Thomas Woller
+M:	twoller@crystal.cirrus.com
+S:	Maintained
+
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
+P:	Nils Faerber
+M:	nils@kernelconcepts.de
 S:	Maintained
 
 CODA FILE SYSTEM
@@ -1130,6 +1134,7 @@
 COMPACTPCI HOTPLUG CORE
 P:	Scott Murray
 M:	scottm@somanetworks.com
+P:	Scott Murray
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
@@ -1137,6 +1142,7 @@
 COMPACTPCI HOTPLUG ZIATECH ZT5550 DRIVER
 P:	Scott Murray
 M:	scottm@somanetworks.com
+P:	Scott Murray
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
@@ -1144,6 +1150,7 @@
 COMPACTPCI HOTPLUG GENERIC DRIVER
 P:	Scott Murray
 M:	scottm@somanetworks.com
+P:	Scott Murray
 M:	scott@spiteful.org
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
@@ -1194,8 +1201,8 @@
 
 CPUSETS
 P:	Paul Jackson
-P:	Simon Derr
 M:	pj@sgi.com
+P:	Simon Derr
 M:	simon.derr@bull.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
@@ -1458,8 +1465,10 @@
 S:	Maintained
 
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
@@ -1473,8 +1482,8 @@
 
 EDAC-E752X
 P:	Mark Gross
-P:	Doug Thompson
 M:	mark.gross@intel.com
+P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
@@ -1510,8 +1519,8 @@
 
 EDAC-I82975X
 P:	Ranganathan Desikan
-P:	Arvind R.
 M:	rdesikan@jetzbroadband.com
+P:	Arvind R.
 M:	arvind@acarlab.com
 L:	bluesmoke-devel@lists.sourceforge.net
 W:	bluesmoke.sourceforge.net
@@ -1557,7 +1566,9 @@
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover
-M:	ch@murgatroid.com, ch@hpl.hp.com
+M:	ch@murgatroid.com
+P:	Christopher Hoover
+M:	ch@hpl.hp.com
 S:	Maintained
 
 ETHEREXPRESS-16 NETWORK DRIVER
@@ -1583,14 +1594,22 @@
 S:	Maintained
 
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
 
 EXT4 FILE SYSTEM
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
 
@@ -1619,7 +1638,7 @@
 S:	Maintained
 
 FREESCALE DMA DRIVER
-P;	Zhang Wei
+P:	Zhang Wei
 M:	wei.zhang@freescale.com
 L:	linuxppc-embedded@ozlabs.org
 L:	linux-kernel@vger.kernel.org
@@ -1680,8 +1699,10 @@
 S:	Maintained
 
 FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
-P:	Kristian Hoegsberg, Stefan Richter
-M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
+P:	Kristian Hoegsberg
+M:	krh@redhat.com
+P:	Stefan Richter
+M:	stefanr@s5r6.in-berlin.de
 L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
@@ -1778,7 +1799,7 @@
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 P:	Robert Love
 M:	rlove@rlove.org
-M:	linux-kernel@vger.kernel.org
+L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
 S:	Maintained
 
@@ -2041,6 +2062,7 @@
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 P:	Dmitry Torokhov
 M:	dmitry.torokhov@gmail.com
+P:	Dmitry Torokhov
 M:	dtor@mail.ru
 L:	linux-input@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
@@ -2261,8 +2283,10 @@
 S:	Supported
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
-P:	Stephen Tweedie, Andrew Morton
-M:	sct@redhat.com, akpm@linux-foundation.org
+P:	Stephen Tweedie
+M:	sct@redhat.com
+P:	Andrew Morton
+M:	akpm@linux-foundation.org
 L:	linux-ext4@vger.kernel.org
 S:	Maintained
 
@@ -2509,9 +2533,11 @@
 LINUX FOR 64BIT POWERPC
 P:	Paul Mackerras
 M:	paulus@samba.org
+P:	Paul Mackerras
 M:	paulus@au.ibm.com
 P:	Anton Blanchard
 M:	anton@samba.org
+P:	Anton Blanchard
 M:	anton@au.ibm.com
 W:	http://www.penguinppc.org/ppc64/
 L:	linuxppc-dev@ozlabs.org
@@ -3901,7 +3927,7 @@
 
 TI OMAP MMC INTERFACE DRIVER
 P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
-M:	linux-omap-open-source@linux.omap.com (subscribers only)
+L:	linux-omap-open-source@linux.omap.com (subscribers only)
 W:	http://linux.omap.com
 W:	http://www.muru.com/linux/omap/
 S:	Maintained
@@ -4137,8 +4163,9 @@
 S:	Maintained
 
 USB SERIAL DIGI ACCELEPORT DRIVER
-P:	Peter Berger and Al Borchers
+P:	Peter Berger
 M:	pberger@brimson.com
+P:	Al Borchers
 M:	alborchers@steinerpoint.com
 L:      linux-usb@vger.kernel.org
 S:	Maintained
