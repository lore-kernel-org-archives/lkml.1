Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYJLXNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYJLXNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbYJLXMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:12:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43487 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYJLXMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:12:42 -0400
Date: Sun, 12 Oct 2008 16:11:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] MAINTAINERS: alpha sort
Message-Id: <20081012161131.5f0dd09b.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
References: <20081010235755.12643.43818.stgit@warthog.procyon.org.uk>
	<alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 12:46:01 -0700 (PDT) Linus Torvalds wrote:

> On Sat, 11 Oct 2008, David Howells wrote:
> >
> > MEI are renaming themselves to Panasonic, so update the MAINTAINERS record for
> > the MN10300 arch.
> 
> Hmm. Somehow I'd expect this to also move to late in the file to keep 
> things in alphabetical order. No?
> 
> > -MEI MN10300/AM33 PORT
> > +PANASONIC MN10300/AM33 PORT

It was already out of place (in midst of MEMORY entries), but David
isn't alone in this sorting problem.

Here's a patch that fixes most of them.  Not going for perfection.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Sorted case-insensitive (sort -f).
Groups that begin with ARM, INTEL, etc. not sorted.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |  876 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 438 insertions(+), 438 deletions(-)

--- lin2627-g2-maint.orig/MAINTAINERS
+++ lin2627-g2-maint/MAINTAINERS
@@ -102,14 +102,14 @@ M:	dave@thedillows.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-3W-XXXX ATA-RAID CONTROLLER DRIVER
+3W-9XXX SATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
 M:	linuxraid@amcc.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.amcc.com
 S:	Supported
 
-3W-9XXX SATA-RAID CONTROLLER DRIVER
+3W-XXXX ATA-RAID CONTROLLER DRIVER
 P:	Adam Radford
 M:	linuxraid@amcc.com
 L:	linux-scsi@vger.kernel.org
@@ -163,16 +163,11 @@ M:	A2232@gmx.net
 L:	linux-m68k@lists.linux-m68k.org
 S:	Maintained
 
-AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
-P:	David Howells
-M:	dhowells@redhat.com
-L:	linux-afs@lists.infradead.org
-S:	Supported
-
-AIO
-P:	Benjamin LaHaise
-M:	bcrl@kvack.org
-L:	linux-aio@kvack.org
+AACRAID SCSI RAID DRIVER
+P:	Adaptec OEM Raid Solutions
+M:	aacraid@adaptec.com
+L:	linux-scsi@vger.kernel.org
+W:	http://www.adaptec.com/
 S:	Supported
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
@@ -193,27 +188,6 @@ M:	jes@trained-monkey.org
 L:	linux-acenic@sunsite.dk
 S:	Maintained
 
-IPS SCSI RAID DRIVER
-P:	Adaptec OEM Raid Solutions
-M:	aacraid@adaptec.com
-L:	linux-scsi@vger.kernel.org
-W:	http://www.adaptec.com/
-S:	Maintained
-
-DPT_I2O SCSI RAID DRIVER
-P:	Adaptec OEM Raid Solutions
-M:	aacraid@adaptec.com
-L:	linux-scsi@vger.kernel.org
-W:	http://www.adaptec.com/
-S:	Maintained
-
-AACRAID SCSI RAID DRIVER
-P:	Adaptec OEM Raid Solutions
-M:	aacraid@adaptec.com
-L:	linux-scsi@vger.kernel.org
-W:	http://www.adaptec.com/
-S:	Supported
-
 ACER WMI LAPTOP EXTRAS
 P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
@@ -327,6 +301,12 @@ P:	Roman Zippel
 M:	zippel@linux-m68k.org
 S:	Maintained
 
+AFS FILESYSTEM & AF_RXRPC SOCKET DOMAIN
+P:	David Howells
+M:	dhowells@redhat.com
+L:	linux-afs@lists.infradead.org
+S:	Supported
+
 AGPGART DRIVER
 P:	David Airlie
 M:	airlied@linux.ie
@@ -345,6 +325,12 @@ M:	hare@suse.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+AIO
+P:	Benjamin LaHaise
+M:	bcrl@kvack.org
+L:	linux-aio@kvack.org
+S:	Supported
+
 ALCATEL SPEEDTOUCH USB DRIVER
 P:	Duncan Sands
 M:	duncan.sands@free.fr
@@ -865,11 +851,48 @@ L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
 
+B43 WIRELESS DRIVER
+P:	Michael Buesch
+M:	mb@bu3sch.de
+P:	Stefano Brivio
+M:	stefano.brivio@polimi.it
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/en/users/Drivers/b43
+S:	Maintained
+
+B43LEGACY WIRELESS DRIVER
+P:	Larry Finger
+M:	Larry.Finger@lwfinger.net
+P:	Stefano Brivio
+M:	stefano.brivio@polimi.it
+L:	linux-wireless@vger.kernel.org
+W:	http://linuxwireless.org/en/users/Drivers/b43
+S:	Maintained
+
 BACKLIGHT CLASS/SUBSYSTEM
 P:	Richard Purdie
 M:	rpurdie@rpsys.net
 S:	Maintained
 
+BAYCOM/HDLCDRV DRIVERS FOR AX.25
+P:	Thomas Sailer
+M:	t.sailer@alumni.ethz.ch
+L:	linux-hams@vger.kernel.org
+W:	http://www.baycom.org/~tom/ham/ham.html
+S:	Maintained
+
+BEFS FILE SYSTEM
+P:	Sergey S. Kostyliov
+M:	rathamahata@php4.ru
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
+BFS FILE SYSTEM
+P:	Tigran A. Aivazian
+M:	tigran@aivazian.fsnet.co.uk
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 BLACKFIN ARCHITECTURE
 P:	Bryan Wu
 M:	cooloney@kernel.org
@@ -905,43 +928,6 @@ L:	uclinux-dist-devel@blackfin.uclinux.o
 W:	http://blackfin.uclinux.org
 S:	Supported
 
-BAYCOM/HDLCDRV DRIVERS FOR AX.25
-P:	Thomas Sailer
-M:	t.sailer@alumni.ethz.ch
-L:	linux-hams@vger.kernel.org
-W:	http://www.baycom.org/~tom/ham/ham.html
-S:	Maintained
-
-B43 WIRELESS DRIVER
-P:	Michael Buesch
-M:	mb@bu3sch.de
-P:	Stefano Brivio
-M:	stefano.brivio@polimi.it
-L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/en/users/Drivers/b43
-S:	Maintained
-
-B43LEGACY WIRELESS DRIVER
-P:	Larry Finger
-M:	Larry.Finger@lwfinger.net
-P:	Stefano Brivio
-M:	stefano.brivio@polimi.it
-L:	linux-wireless@vger.kernel.org
-W:	http://linuxwireless.org/en/users/Drivers/b43
-S:	Maintained
-
-BEFS FILE SYSTEM
-P:	Sergey S. Kostyliov
-M:	rathamahata@php4.ru
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
-BFS FILE SYSTEM
-P:	Tigran A. Aivazian
-M:	tigran@aivazian.fsnet.co.uk
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 BLACKFIN I2C TWI DRIVER
 P:	Sonic Zhang
 M:	sonic.zhang@analog.com
@@ -1035,15 +1021,6 @@ M:	corbet@lwn.net
 L:	video4linux-list@redhat.com
 S:	Maintained
 
-CAN NETWORK LAYER
-P:	Urs Thuermann
-M:	urs.thuermann@volkswagen.de
-P:	Oliver Hartkopp
-M:	oliver.hartkopp@volkswagen.de
-L:	socketcan-core@lists.berlios.de (subscribers-only)
-W:	http://developer.berlios.de/projects/socketcan/
-S:	Maintained
-
 CALGARY x86-64 IOMMU
 P:	Muli Ben-Yehuda
 M:	muli@il.ibm.com
@@ -1053,6 +1030,15 @@ L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
 
+CAN NETWORK LAYER
+P:	Urs Thuermann
+M:	urs.thuermann@volkswagen.de
+P:	Oliver Hartkopp
+M:	oliver.hartkopp@volkswagen.de
+L:	socketcan-core@lists.berlios.de (subscribers-only)
+W:	http://developer.berlios.de/projects/socketcan/
+S:	Maintained
+
 CELL BROADBAND ENGINE ARCHITECTURE
 P:	Arnd Bergmann
 M:	arnd@arndb.de
@@ -1061,13 +1047,6 @@ L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
 S:	Supported
 
-CISCO 10G ETHERNET DRIVER
-P:	Scott Feldman
-M:	scofeldm@cisco.com
-P:	Joe Eykholt
-M:	jeykholt@cisco.com
-S:	Supported
-
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	miguel.ojeda.sandonis@gmail.com
@@ -1099,19 +1078,11 @@ P:	Joel Schopp
 M:	jschopp@austin.ibm.com
 S:	Supported
 
-COMMON INTERNET FILE SYSTEM (CIFS)
-P:	Steve French
-M:	sfrench@samba.org
-L:	linux-cifs-client@lists.samba.org
-L:	samba-technical@lists.samba.org
-W:	http://linux-cifs.samba.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
-S:	Supported
-
-CONFIGFS
-P:	Joel Becker
-M:	joel.becker@oracle.com
-L:	linux-kernel@vger.kernel.org
+CISCO 10G ETHERNET DRIVER
+P:	Scott Feldman
+M:	scofeldm@cisco.com
+P:	Joe Eykholt
+M:	jeykholt@cisco.com
 S:	Supported
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
@@ -1147,6 +1118,15 @@ L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
 
+COMMON INTERNET FILE SYSTEM (CIFS)
+P:	Steve French
+M:	sfrench@samba.org
+L:	linux-cifs-client@lists.samba.org
+L:	samba-technical@lists.samba.org
+W:	http://linux-cifs.samba.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
+S:	Supported
+
 COMPACTPCI HOTPLUG CORE
 P:	Scott Murray
 M:	scottm@somanetworks.com
@@ -1186,6 +1166,12 @@ L:	accessrunner-general@lists.sourceforg
 W:	http://accessrunner.sourceforge.net/
 S:	Maintained
 
+CONFIGFS
+P:	Joel Becker
+M:	joel.becker@oracle.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 CONTROL GROUPS (CGROUPS)
 P:	Paul Menage
 M:	menage@google.com
@@ -1309,6 +1295,20 @@ W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
 
+DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
+P:	Tobias Ringstrom
+M:	tori@unhappy.mine.nu
+L:	netdev@vger.kernel.org
+S:	Maintained
+
+DC390/AM53C974 SCSI driver
+P:	Kurt Garloff
+M:	garloff@suse.de
+W:	http://www.garloff.de/kurt/linux/dc390/
+P:	Guennadi Liakhovetski
+M:	g.liakhovetski@gmx.de
+S:	Maintained
+
 DC395x SCSI driver
 P:	Oliver Neukum
 M:	oliver@neukum.name
@@ -1321,14 +1321,6 @@ L:	dc395x@twibble.org
 L:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
 
-DC390/AM53C974 SCSI driver
-P:	Kurt Garloff
-M:	garloff@suse.de
-W:	http://www.garloff.de/kurt/linux/dc390/
-P:	Guennadi Liakhovetski
-M:	g.liakhovetski@gmx.de
-S:	Maintained
-
 DCCP PROTOCOL
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net
@@ -1359,12 +1351,6 @@ P:	Doug Warzecha
 M:	Douglas_Warzecha@dell.com
 S:	Maintained
 
-DEVICE-MAPPER  (LVM)
-P:	Alasdair Kergon
-L:	dm-devel@redhat.com
-W:	http://sources.redhat.com/dm
-S:	Maintained
-
 DEVICE NUMBER REGISTRY
 P:	Torben Mathiasen
 M:	device@lanana.org
@@ -1372,6 +1358,12 @@ W:	http://lanana.org/docs/device-list/in
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+DEVICE-MAPPER  (LVM)
+P:	Alasdair Kergon
+L:	dm-devel@redhat.com
+W:	http://sources.redhat.com/dm
+S:	Maintained
+
 DIGI INTL. EPCA DRIVER
 P:	Digi International, Inc
 M:	Eng.Linux@digi.com
@@ -1409,12 +1401,6 @@ W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/teigland/dlm.git
 S:	Supported
 
-DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
-P:	Tobias Ringstrom
-M:	tori@unhappy.mine.nu
-L:	netdev@vger.kernel.org
-S:	Maintained
-
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 P:	Maciej Sosnowski
 M:	maciej.sosnowski@intel.com
@@ -1454,6 +1440,13 @@ M:	jrv@vanzandt.mv.com
 L:	blinux-list@redhat.com
 S:	Maintained
 
+DPT_I2O SCSI RAID DRIVER
+P:	Adaptec OEM Raid Solutions
+M:	aacraid@adaptec.com
+L:	linux-scsi@vger.kernel.org
+W:	http://www.adaptec.com/
+S:	Maintained
+
 DRIVER CORE, KOBJECTS, AND SYSFS
 P:	Greg Kroah-Hartman
 M:	gregkh@suse.de
@@ -1682,27 +1675,63 @@ P:	Akinobu Mita
 M:	akinobu.mita@gmail.com
 S:	Supported
 
-FRAMEBUFFER LAYER
-P:	Antonino Daplas
-M:	adaplas@gmail.com
-L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
-W:	http://linux-fbdev.sourceforge.net/
+FILE LOCKING (flock() and fcntl()/lockf())
+P:	Matthew Wilcox
+M:	matthew@wil.cx
+L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 
-FREESCALE DMA DRIVER
-P:	Li Yang
-M:	leoli@freescale.com
-P:	Zhang Wei
-M:	zw@zh-kernel.org
-L:	linuxppc-embedded@ozlabs.org
-L:	linux-kernel@vger.kernel.org
+FILESYSTEMS (VFS and infrastructure)
+P:	Alexander Viro
+M:	viro@zeniv.linux.org.uk
+L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 
-FREESCALE I2C CPM DRIVER
-P:	Jochen Friedrich
-M:	jochen@scram.de
-L:	linuxppc-dev@ozlabs.org
-L:	i2c@lm-sensors.org
+FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
+P:	Kristian Hoegsberg, Stefan Richter
+M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
+L:	linux1394-devel@lists.sourceforge.net
+W:	http://www.linux1394.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+S:	Maintained
+
+FIRMWARE LOADER (request_firmware)
+L:	linux-kernel@vger.kernel.org
+S:	Orphan
+
+FPU EMULATOR
+P:	Bill Metzenthen
+M:	billm@suburbia.net
+W:	http://suburbia.net/~billm/floating-point/emulator/
+S:	Maintained
+
+FRAME RELAY DLCI/FRAD (Sangoma drivers too)
+P:	Mike McLagan
+M:	mike.mclagan@linux.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+
+FRAMEBUFFER LAYER
+P:	Antonino Daplas
+M:	adaplas@gmail.com
+L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
+W:	http://linux-fbdev.sourceforge.net/
+S:	Maintained
+
+FREESCALE DMA DRIVER
+P:	Li Yang
+M:	leoli@freescale.com
+P:	Zhang Wei
+M:	zw@zh-kernel.org
+L:	linuxppc-embedded@ozlabs.org
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
+FREESCALE I2C CPM DRIVER
+P:	Jochen Friedrich
+M:	jochen@scram.de
+L:	linuxppc-dev@ozlabs.org
+L:	i2c@lm-sensors.org
 S:	Maintained
 
 FREESCALE SOC FS_ENET DRIVER
@@ -1747,42 +1776,6 @@ L:	alsa-devel@alsa-project.org
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 
-FILE LOCKING (flock() and fcntl()/lockf())
-P:	Matthew Wilcox
-M:	matthew@wil.cx
-L:	linux-fsdevel@vger.kernel.org
-S:	Maintained
-
-FILESYSTEMS (VFS and infrastructure)
-P:	Alexander Viro
-M:	viro@zeniv.linux.org.uk
-L:	linux-fsdevel@vger.kernel.org
-S:	Maintained
-
-FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
-P:	Kristian Hoegsberg, Stefan Richter
-M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
-L:	linux1394-devel@lists.sourceforge.net
-W:	http://www.linux1394.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
-S:	Maintained
-
-FIRMWARE LOADER (request_firmware)
-L:	linux-kernel@vger.kernel.org
-S:	Orphan
-
-FPU EMULATOR
-P:	Bill Metzenthen
-M:	billm@suburbia.net
-W:	http://suburbia.net/~billm/floating-point/emulator/
-S:	Maintained
-
-FRAME RELAY DLCI/FRAD (Sangoma drivers too)
-P:	Mike McLagan
-M:	mike.mclagan@linux.org
-L:	netdev@vger.kernel.org
-S:	Maintained
-
 FREEVXFS FILESYSTEM
 P:	Christoph Hellwig
 M:	hch@infradead.org
@@ -1854,6 +1847,13 @@ L:	gigaset307x-common@lists.sourceforge.
 W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
 
+HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
+P:	Robert Love
+M:	rlove@rlove.org
+M:	linux-kernel@vger.kernel.org
+W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
+S:	Maintained
+
 HARDWARE MONITORING
 L:	lm-sensors@lm-sensors.org
 W:	http://www.lm-sensors.org/
@@ -1862,13 +1862,6 @@ S:	Orphan
 HARDWARE RANDOM NUMBER GENERATOR CORE
 S:	Orphan
 
-HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
-P:	Robert Love
-M:	rlove@rlove.org
-M:	linux-kernel@vger.kernel.org
-W:	http://www.kernel.org/pub/linux/kernel/people/rml/hdaps/
-S:	Maintained
-
 HARMONY SOUND DRIVER
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
@@ -1882,6 +1875,24 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
 
+HEWLETT-PACKARD FIBRE CHANNEL 64-bit/66MHz PCI non-intelligent HBA
+P:	Chirag Kantharia
+M:	chirag.kantharia@hp.com
+L:	iss_storagedev@hp.com
+S:	Maintained
+
+HEWLETT-PACKARD SMART2 RAID DRIVER
+P:	Chirag Kantharia
+M:	chirag.kantharia@hp.com
+L:	iss_storagedev@hp.com
+S:	Maintained
+
+HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
+P:	Mike Miller
+M:	mike.miller@hp.com
+L:	iss_storagedev@hp.com
+S:	Supported
+
 HFS FILESYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
@@ -1895,6 +1906,14 @@ L:	linux-nvidia@lists.surfsouth.com
 W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
 S:	Maintained
 
+HIBERNATION (aka Software Suspend, aka swsusp):
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
+
 HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
@@ -1927,24 +1946,6 @@ M:	jes@trained-monkey.org
 L:	linux-hippi@sunsite.dk
 S:	Maintained
 
-HEWLETT-PACKARD FIBRE CHANNEL 64-bit/66MHz PCI non-intelligent HBA
-P:	Chirag Kantharia
-M:	chirag.kantharia@hp.com
-L:	iss_storagedev@hp.com
-S:	Maintained
-
-HEWLETT-PACKARD SMART2 RAID DRIVER
-P:	Chirag Kantharia
-M:	chirag.kantharia@hp.com
-L:	iss_storagedev@hp.com
-S:	Maintained
-
-HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
-P:	Mike Miller
-M:	mike.miller@hp.com
-L:	iss_storagedev@hp.com
-S:	Supported
-
 HOST AP DRIVER
 P:	Jouni Malinen
 M:	j@w1.fi
@@ -1953,16 +1954,16 @@ L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
 
-HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
-P:	Jaroslav Kysela
-M:	perex@perex.cz
-S:	Maintained
-
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
 P:	Carlos Corbacho
 M:	carlos@strangeworlds.co.uk
 S:	Odd Fixes
 
+HP100:	Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
+P:	Jaroslav Kysela
+M:	perex@perex.cz
+S:	Maintained
+
 HPET:	High Precision Event Timers driver (drivers/char/hpet.c)
 P:	Clemens Ladisch
 M:	clemens@ladisch.de
@@ -2042,14 +2043,6 @@ W:	http://www.ia64-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 S:	Maintained
 
-SN-IA64 (Itanium) SUB-PLATFORM
-P:	Jes Sorensen
-M:	jes@sgi.com
-L:	linux-altix@sgi.com
-L:	linux-ia64@vger.kernel.org
-W:	http://www.sgi.com/altix
-S:	Maintained
-
 IBM MCA SCSI SUBSYSTEM DRIVER
 P:	Michael Lang
 M:	langa2@kph.uni-mainz.de
@@ -2133,14 +2126,6 @@ W:	http://www.openib.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 
-INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
-P:	Dmitry Torokhov
-M:	dmitry.torokhov@gmail.com
-M:	dtor@mail.ru
-L:	linux-input@vger.kernel.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
-S:	Maintained
-
 INOTIFY
 P:	John McCutchan
 M:	ttb@tentacle.dhs.org
@@ -2149,6 +2134,14 @@ M:	rml@novell.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
+P:	Dmitry Torokhov
+M:	dmitry.torokhov@gmail.com
+M:	dtor@mail.ru
+L:	linux-input@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/dtor/input.git
+S:	Maintained
+
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 P:	Sylvain Meyer
 M:	sylvain.meyer@worldonline.fr
@@ -2282,10 +2275,22 @@ L:	openipmi-developer@lists.sourceforge.
 W:	http://openipmi.sourceforge.net/
 S:	Supported
 
-IPX NETWORK LAYER
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
+IPS SCSI RAID DRIVER
+P:	Adaptec OEM Raid Solutions
+M:	aacraid@adaptec.com
+L:	linux-scsi@vger.kernel.org
+W:	http://www.adaptec.com/
+S:	Maintained
+
+IPVS
+P:	Wensong Zhang
+M:	wensong@linux-vs.org
+P:	Simon Horman
+M:	horms@verge.net.au
+P:	Julian Anastasov
+M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
+L:	lvs-devel@vger.kernel.org
 S:	Maintained
 
 IPWIRELES DRIVER
@@ -2296,6 +2301,12 @@ M:	dsterba@suse.cz
 S:	Maintained
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/jikos/ipwireless_cs.git
 
+IPX NETWORK LAYER
+P:	Arnaldo Carvalho de Melo
+M:	acme@ghostprotocols.net
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 IRDA SUBSYSTEM
 P:	Samuel Ortiz
 M:	samuel@sortiz.org
@@ -2303,6 +2314,11 @@ L:	irda-users@lists.sourceforge.net (sub
 W:	http://irda.sourceforge.net/
 S:	Maintained
 
+ISAPNP
+P:	Jaroslav Kysela
+M:	perex@perex.cz
+S:	Maintained
+
 ISCSI
 P:	Mike Christie
 M:	michaelc@cs.wisc.edu
@@ -2311,11 +2327,6 @@ W:	www.open-iscsi.org
 T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
 S:	Maintained
 
-ISAPNP
-P:	Jaroslav Kysela
-M:	perex@perex.cz
-S:	Maintained
-
 ISDN SUBSYSTEM
 P:	Karsten Keil
 M:	kkeil@suse.de
@@ -2340,6 +2351,14 @@ L:	video4linux-list@redhat.com
 W:	http://www.ivtvdriver.org
 S:	Maintained
 
+JFS FILESYSTEM
+P:	Dave Kleikamp
+M:	shaggy@austin.ibm.com
+L:	jfs-discussion@lists.sourceforge.net
+W:	http://jfs.sourceforge.net/
+T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
+S:	Supported
+
 JME NETWORK DRIVER
 P:	Guo-Fu Tseng
 M:	cooldavid@cooldavid.org
@@ -2353,24 +2372,6 @@ L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
 
-UBI FILE SYSTEM (UBIFS)
-P:	Artem Bityutskiy
-M:	dedekind@infradead.org
-P:	Adrian Hunter
-M:	ext-adrian.hunter@nokia.com
-L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubifs-2.6.git
-W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
-S:	Maintained
-
-JFS FILESYSTEM
-P:	Dave Kleikamp
-M:	shaggy@austin.ibm.com
-L:	jfs-discussion@lists.sourceforge.net
-W:	http://jfs.sourceforge.net/
-T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
-S:	Supported
-
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 P:	Stephen Tweedie, Andrew Morton
 M:	sct@redhat.com, akpm@linux-foundation.org
@@ -2607,11 +2608,6 @@ W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 
-LLC (802.2)
-P:	Arnaldo Carvalho de Melo
-M:	acme@ghostprotocols.net
-S:	Maintained
-
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 P:	Chris Wright
 M:	chrisw@sous-sol.org
@@ -2619,6 +2615,11 @@ L:	linux-security-module@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
+LLC (802.2)
+P:	Arnaldo Carvalho de Melo
+M:	acme@ghostprotocols.net
+S:	Maintained
+
 LM83 HARDWARE MONITOR DRIVER
 P:	Jean Delvare
 M:	khali@linux-fr.org
@@ -2719,14 +2720,6 @@ M:	kaber@trash.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-MARVELL YUKON / SYSKONNECT DRIVER
-P:	Mirko Lindner
-M:	mlindner@syskonnect.de
-P:	Ralph Roesler
-M:	rroesler@syskonnect.de
-W:	http://www.syskonnect.com
-S:	Supported
-
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
@@ -2746,6 +2739,14 @@ M:	buytenh@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+MARVELL YUKON / SYSKONNECT DRIVER
+P:	Mirko Lindner
+M:	mlindner@syskonnect.de
+P:	Ralph Roesler
+M:	rroesler@syskonnect.de
+W:	http://www.syskonnect.com
+S:	Supported
+
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec
 M:	vandrove@vc.cvut.cz
@@ -2782,15 +2783,6 @@ L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-MEI MN10300/AM33 PORT
-P:	David Howells
-M:	dhowells@redhat.com
-P:	Koichi Yasutake
-M:	yasutake.koichi@jp.panasonic.com
-L:	linux-am33-list@redhat.com (moderated for non-subscribers)
-W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
-S:	Maintained
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 P:	David Woodhouse
 M:	dwmw2@infradead.org
@@ -2799,12 +2791,13 @@ L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 
-UNSORTED BLOCK IMAGES (UBI)
-P:	Artem Bityutskiy
-M:	dedekind@infradead.org
-W:	http://www.linux-mtd.infradead.org/
-L:	linux-mtd@lists.infradead.org
-T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
+MEI MN10300/AM33 PORT
+P:	David Howells
+M:	dhowells@redhat.com
+P:	Koichi Yasutake
+M:	yasutake.koichi@jp.panasonic.com
+L:	linux-am33-list@redhat.com (moderated for non-subscribers)
+W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
 S:	Maintained
 
 MICROTEK X6 SCANNER
@@ -3038,17 +3031,6 @@ L:	netdev@vger.kernel.org
 W:	http://www.netxen.com
 S:	Supported
 
-IPVS
-P:	Wensong Zhang
-M:	wensong@linux-vs.org
-P:	Simon Horman
-M:	horms@verge.net.au
-P:	Julian Anastasov
-M:	ja@ssi.bg
-L:	netdev@vger.kernel.org
-L:	lvs-devel@vger.kernel.org
-S:	Maintained
-
 NFS, SUNRPC, AND LOCKD CLIENTS
 P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
@@ -3094,22 +3076,6 @@ M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
-OPENCORES I2C BUS DRIVER
-P:	Peter Korsgaard
-M:	jacmet@sunsite.dk
-L:	i2c@lm-sensors.org
-S:	Maintained
-
-ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
-P:	Mark Fasheh
-M:	mfasheh@suse.com
-P:	Joel Becker
-M:	joel.becker@oracle.com
-L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
-W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
-S:	Supported
-
 OMFS FILESYSTEM
 P:	Bob Copeland
 M:	me@bobcopeland.com
@@ -3145,12 +3111,28 @@ L:	osst-users@lists.sourceforge.net
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+OPENCORES I2C BUS DRIVER
+P:	Peter Korsgaard
+M:	jacmet@sunsite.dk
+L:	i2c@lm-sensors.org
+S:	Maintained
+
 OPROFILE
 P:	Robert Richter
 M:	robert.richter@amd.com
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 
+ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
+P:	Mark Fasheh
+M:	mfasheh@suse.com
+P:	Joel Becker
+M:	joel.becker@oracle.com
+L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
+W:	http://oss.oracle.com/projects/ocfs2/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
+S:	Supported
+
 ORINOCO DRIVER
 P:	Pavel Roskin
 M:	proski@gnu.org
@@ -3162,6 +3144,14 @@ L:	orinoco-devel@lists.sourceforge.net
 W:	http://www.nongnu.org/orinoco/
 S:	Maintained
 
+P54 WIRELESS DRIVER
+P:	Michael Wu
+M:	flamingice@sourmilk.net
+L:	linux-wireless@vger.kernel.org
+W:	http://prism54.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
+S:	Maintained
+
 PA SEMI ETHERNET DRIVER
 P:	Olof Johansson
 M:	olof@lixom.net
@@ -3178,25 +3168,6 @@ PARALLEL PORT SUPPORT
 L:	linux-parport@lists.infradead.org (subscribers-only)
 S:	Orphan
 
-PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
-P:	Tim Waugh
-M:	tim@cyberelk.net
-L:	linux-parport@lists.infradead.org (subscribers-only)
-W:	http://www.torque.net/linux-pp.html
-S:	Maintained
-
-PARISC ARCHITECTURE
-P:	Kyle McMartin
-M:	kyle@mcmartin.ca
-P:	Matthew Wilcox
-M:	matthew@wil.cx
-P:	Grant Grundler
-M:	grundler@parisc-linux.org
-L:	linux-parisc@vger.kernel.org
-W:	http://www.parisc-linux.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
-S:	Maintained
-
 PARAVIRT_OPS INTERFACE
 P:	Jeremy Fitzhardinge
 M:	jeremy@xensource.com
@@ -3210,6 +3181,25 @@ L:	virtualization@lists.osdl.org
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
+PARIDE DRIVERS FOR PARALLEL PORT IDE DEVICES
+P:	Tim Waugh
+M:	tim@cyberelk.net
+L:	linux-parport@lists.infradead.org (subscribers-only)
+W:	http://www.torque.net/linux-pp.html
+S:	Maintained
+
+PARISC ARCHITECTURE
+P:	Kyle McMartin
+M:	kyle@mcmartin.ca
+P:	Matthew Wilcox
+M:	matthew@wil.cx
+P:	Grant Grundler
+M:	grundler@parisc-linux.org
+L:	linux-parisc@vger.kernel.org
+W:	http://www.parisc-linux.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
+S:	Maintained
+
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
@@ -3339,14 +3329,6 @@ L:	kpreempt-tech@lists.sourceforge.net
 W:	ftp://ftp.kernel.org/pub/linux/kernel/people/rml/preempt-kernel
 S:	Supported
 
-P54 WIRELESS DRIVER
-P:	Michael Wu
-M:	flamingice@sourmilk.net
-L:	linux-wireless@vger.kernel.org
-W:	http://prism54.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
-S:	Maintained
-
 PRISM54 WIRELESS DRIVER
 P:	Luis R. Rodriguez
 M:	mcgrof@gmail.com
@@ -3437,12 +3419,6 @@ M:	paulus@samba.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
-RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
-P:	Corey Thomas
-M:	coreythomas@charter.net
-L:	linux-wireless@vger.kernel.org
-S:	Maintained
-
 RALINK RT2X00 WLAN DRIVER
 P:	rt2x00 project
 L:	linux-wireless@vger.kernel.org
@@ -3468,6 +3444,18 @@ M:	mporter@kernel.crashing.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+RAYLINK/WEBGEAR 802.11 WIRELESS LAN DRIVER
+P:	Corey Thomas
+M:	coreythomas@charter.net
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+
+RCUTORTURE MODULE
+P:	Josh Triplett
+M:	josh@freedesktop.org
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 RDC R-321X SoC
 P:	Florian Fainelli
 M:	florian.fainelli@telecomint.eu
@@ -3487,12 +3475,6 @@ W:	http://www.rdrop.com/users/paulmck/rc
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
-RCUTORTURE MODULE
-P:	Josh Triplett
-M:	josh@freedesktop.org
-L:	linux-kernel@vger.kernel.org
-S:	Maintained
-
 REAL TIME CLOCK DRIVER
 P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
@@ -3516,6 +3498,9 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	net/rfkill
 
+RISCOM8 DRIVER
+S:	Orphan
+
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
@@ -3528,9 +3513,6 @@ L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
 
-RISCOM8 DRIVER
-S:	Orphan
-
 RTL818X WIRELESS DRIVER
 P:	Michael Wu
 M:	flamingice@sourmilk.net
@@ -3670,6 +3652,12 @@ M:	saschasommer@freenet.de
 L:	sdricohcs-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
+SECURE DIGITAL HOST CONTROLLER INTERFACE DRIVER
+P:	Pierre Ossman
+M:	drzeus-sdhci@drzeus.cx
+L:	sdhci-devel@list.drzeus.cx
+S:	Maintained
+
 SECURITY CONTACT
 P:	Security Officers
 M:	security@kernel.org
@@ -3700,12 +3688,6 @@ L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 
-SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
-P:	Pat Gefre
-M:	pfg@sgi.com
-L:	linux-ia64@vger.kernel.org
-S:	Supported
-
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
@@ -3713,6 +3695,17 @@ P:	Robert Stonehouse
 M:	linux-net-drivers@solarflare.com
 S:	Supported
 
+SGI GRU DRIVER
+P:	Jack Steiner
+M:	steiner@sgi.com
+S:	Maintained
+
+SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
+P:	Pat Gefre
+M:	pfg@sgi.com
+L:	linux-ia64@vger.kernel.org
+S:	Supported
+
 SGI VISUAL WORKSTATION 320 AND 540
 P:	Andrey Panin
 M:	pazke@donpac.ru
@@ -3720,16 +3713,24 @@ L:	linux-visws-devel@lists.sf.net
 W:	http://linux-visws.sf.net
 S:	Maintained for 2.6.
 
-SGI GRU DRIVER
-P:	Jack Steiner
-M:	steiner@sgi.com
-S:	Maintained
-
 SGI XP/XPC/XPNET DRIVER
 P:	Dean Nelson
 M:	dcn@sgi.com
 S:	Maintained
 
+SHARP LH SUPPORT (LH7952X & LH7A40X)
+P:	Marc Singer
+M:	elf@buici.com
+W:	http://projects.buici.com/arm
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+S:	Maintained
+
+SHPC HOTPLUG DRIVER
+P:	Kristen Carlson Accardi
+M:	kristen.c.accardi@intel.com
+L:	linux-pci@vger.kernel.org
+S:	Supported
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
@@ -3775,6 +3776,12 @@ M:	thomas@winischhofer.net
 W:	http://www.winischhofer.at/linuxsisusbvga.shtml
 S:	Maintained
 
+SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
+P:	Stephen Hemminger
+M:	shemminger@linux-foundation.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+
 SLAB ALLOCATOR
 P:	Christoph Lameter
 M:	cl@linux-foundation.org
@@ -3801,12 +3808,25 @@ P:	Ben Nizette
 M:	bn@niasdigital.com
 S:	Maintained
 
+SN-IA64 (Itanium) SUB-PLATFORM
+P:	Jes Sorensen
+M:	jes@sgi.com
+L:	linux-altix@sgi.com
+L:	linux-ia64@vger.kernel.org
+W:	http://www.sgi.com/altix
+S:	Maintained
+
 SOC-CAMERA V4L2 SUBSYSTEM
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
 L:	video4linux-list@redhat.com
 S:	Maintained
 
+SOEKRIS NET48XX LED SUPPORT
+P:	Chris Boot
+M:	bootc@bootc.net
+S:	Maintained
+
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
@@ -3815,24 +3835,6 @@ M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
 
-HIBERNATION (aka Software Suspend, aka swsusp):
-P:	Pavel Machek
-M:	pavel@suse.cz
-P:	Rafael J. Wysocki
-M:	rjw@sisk.pl
-L:	linux-pm@lists.linux-foundation.org
-S:	Supported
-
-SUSPEND TO RAM:
-P:	Len Brown
-M:	len.brown@intel.com
-P:	Pavel Machek
-M:	pavel@suse.cz
-P:	Rafael J. Wysocki
-M:	rjw@sisk.pl
-L:	linux-pm@lists.linux-foundation.org
-S:	Supported
-
 SONIC NETWORK DRIVER
 P:	Thomas Bogendoerfer
 M:	tsbogend@alpha.franken.de
@@ -3877,58 +3879,6 @@ L:	alsa-devel@alsa-project.org (subscrib
 W:	http://alsa-project.org/main/index.php/ASoC
 S:	Supported
 
-SPI SUBSYSTEM
-P:	David Brownell
-M:	dbrownell@users.sourceforge.net
-L:	spi-devel-general@lists.sourceforge.net
-S:	Maintained
-
-SPU FILE SYSTEM
-P:	Jeremy Kerr
-M:	jk@ozlabs.org
-L:	linuxppc-dev@ozlabs.org
-L:	cbe-oss-dev@ozlabs.org
-W:	http://www.ibm.com/developerworks/power/cell/
-S:	Supported
-
-STABLE BRANCH:
-P:	Greg Kroah-Hartman
-M:	greg@kroah.com
-P:	Chris Wright
-M:	chrisw@sous-sol.org
-L:	stable@kernel.org
-S:	Maintained
-
-SHARP LH SUPPORT (LH7952X & LH7A40X)
-P:	Marc Singer
-M:	elf@buici.com
-W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
-S:	Maintained
-
-SHPC HOTPLUG DRIVER
-P:	Kristen Carlson Accardi
-M:	kristen.c.accardi@intel.com
-L:	linux-pci@vger.kernel.org
-S:	Supported
-
-SECURE DIGITAL HOST CONTROLLER INTERFACE DRIVER
-P:	Pierre Ossman
-M:	drzeus-sdhci@drzeus.cx
-L:	sdhci-devel@list.drzeus.cx
-S:	Maintained
-
-SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
-P:	Stephen Hemminger
-M:	shemminger@linux-foundation.org
-L:	netdev@vger.kernel.org
-S:	Maintained
-
-SOEKRIS NET48XX LED SUPPORT
-P:	Chris Boot
-M:	bootc@bootc.net
-S:	Maintained
-
 SPARC (sparc32):
 P:	William L. Irwin
 M:	wli@holomorphy.com
@@ -3941,6 +3891,12 @@ M:	R.E.Wolff@BitWizard.nl
 L:	linux-kernel@vger.kernel.org ?
 S:	Supported
 
+SPI SUBSYSTEM
+P:	David Brownell
+M:	dbrownell@users.sourceforge.net
+L:	spi-devel-general@lists.sourceforge.net
+S:	Maintained
+
 SPIDERNET NETWORK DRIVER for CELL
 P:	Ishizaki Kou
 M:	kou.ishizaki@toshiba.co.jp
@@ -3949,12 +3905,28 @@ M:	jens@de.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+SPU FILE SYSTEM
+P:	Jeremy Kerr
+M:	jk@ozlabs.org
+L:	linuxppc-dev@ozlabs.org
+L:	cbe-oss-dev@ozlabs.org
+W:	http://www.ibm.com/developerworks/power/cell/
+S:	Supported
+
 SRM (Alpha) environment access
 P:	Jan-Benedict Glaw
 M:	jbglaw@lug-owl.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+STABLE BRANCH:
+P:	Greg Kroah-Hartman
+M:	greg@kroah.com
+P:	Chris Wright
+M:	chrisw@sous-sol.org
+L:	stable@kernel.org
+S:	Maintained
+
 STARFIRE/DURALAN NETWORK DRIVER
 P:	Ion Badulescu
 M:	ionut@cs.columbia.edu
@@ -3970,6 +3942,12 @@ M:	laredo@gnu.org
 W:	http://www.stradis.com/
 S:	Maintained
 
+SUN3/3X
+P:	Sam Creasey
+M:	sammy@sammy.net
+W:	http://sammy.net/sun3/
+S:	Maintained
+
 SUPERH
 P:	Paul Mundt
 M:	lethal@linux-sh.org
@@ -3978,11 +3956,15 @@ W:	http://www.linux-sh.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
 S:	Supported
 
-SUN3/3X
-P:	Sam Creasey
-M:	sammy@sammy.net
-W:	http://sammy.net/sun3/
-S:	Maintained
+SUSPEND TO RAM:
+P:	Len Brown
+M:	len.brown@intel.com
+P:	Pavel Machek
+M:	pavel@suse.cz
+P:	Rafael J. Wysocki
+M:	rjw@sisk.pl
+L:	linux-pm@lists.linux-foundation.org
+S:	Supported
 
 SVGA HANDLING
 P:	Martin Mares
@@ -4142,6 +4124,16 @@ M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+UBI FILE SYSTEM (UBIFS)
+P:	Artem Bityutskiy
+M:	dedekind@infradead.org
+P:	Adrian Hunter
+M:	ext-adrian.hunter@nokia.com
+L:	linux-mtd@lists.infradead.org
+T:	git git://git.infradead.org/~dedekind/ubifs-2.6.git
+W:	http://www.linux-mtd.infradead.org/doc/ubifs.html
+S:	Maintained
+
 UCLINUX (AND M68KNOMMU)
 P:	Greg Ungerer
 M:	gerg@uclinux.org
@@ -4181,6 +4173,14 @@ L:	linux-kernel@vger.kernel.org
 W:	http://www.kernel.dk
 S:	Maintained
 
+UNSORTED BLOCK IMAGES (UBI)
+P:	Artem Bityutskiy
+M:	dedekind@infradead.org
+W:	http://www.linux-mtd.infradead.org/
+L:	linux-mtd@lists.infradead.org
+T:	git git://git.infradead.org/~dedekind/ubi-2.6.git
+S:	Maintained
+
 USB ACM DRIVER
 P:	Oliver Neukum
 M:	oliver@neukum.name
@@ -4603,6 +4603,17 @@ M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
 
+X86 ARCHITECTURE (32-BIT AND 64-BIT)
+P:	Thomas Gleixner
+M:	tglx@linutronix.de
+P:	Ingo Molnar
+M:	mingo@redhat.com
+P:	H. Peter Anvin
+M:	hpa@zytor.com
+L:	linux-kernel@vger.kernel.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
+S:	Maintained
+
 XEN HYPERVISOR INTERFACE
 P:	Jeremy Fitzhardinge
 M:	jeremy@xensource.com
@@ -4634,17 +4645,6 @@ M:	jacmet@sunsite.dk
 L:	linux-serial@vger.kernel.org
 S:	Maintained
 
-X86 ARCHITECTURE (32-BIT AND 64-BIT)
-P:	Thomas Gleixner
-M:	tglx@linutronix.de
-P:	Ingo Molnar
-M:	mingo@redhat.com
-P:	H. Peter Anvin
-M:	hpa@zytor.com
-L:	linux-kernel@vger.kernel.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
-S:	Maintained
-
 YAM DRIVER FOR AX.25
 P:	Jean-Paul Roubelat
 M:	jpr@f6fbb.org
